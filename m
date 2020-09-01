Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6CF25935C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbgIAPYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728720AbgIAPYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:24:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C5242078B;
        Tue,  1 Sep 2020 15:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973892;
        bh=mI2ix3jDcTd6+yitBSFLtIfCRzJi7p2SJWcUmdKPOQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+QQTq9HG5QQhQWy1cTS6Uzk8btU7GGg5PY9q4gz1X/LT9HSHQuJubjurgOJIlYj0
         0vdSB+qkWmncRZWTuISR9XQcPx6Kr38uoX+8AmEh/HuAKpVKIOxN4B8RnGhEYbjqec
         duhty0sposNLo6fYOhMoVlG3hAOEIEQ/A1WS8dV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Kennedy <george.kennedy@oracle.com>,
        syzbot+38a3699c7eaf165b97a6@syzkaller.appspotmail.com
Subject: [PATCH 4.19 088/125] vt_ioctl: change VT_RESIZEX ioctl to check for error return from vc_resize()
Date:   Tue,  1 Sep 2020 17:10:43 +0200
Message-Id: <20200901150938.891267321@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

commit bc5269ca765057a1b762e79a1cfd267cd7bf1c46 upstream.

vc_resize() can return with an error after failure. Change VT_RESIZEX ioctl
to save struct vc_data values that are modified and restore the original
values in case of error.

Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+38a3699c7eaf165b97a6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/1596213192-6635-2-git-send-email-george.kennedy@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt_ioctl.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -893,12 +893,22 @@ int vt_ioctl(struct tty_struct *tty,
 			console_lock();
 			vcp = vc_cons[i].d;
 			if (vcp) {
+				int ret;
+				int save_scan_lines = vcp->vc_scan_lines;
+				int save_font_height = vcp->vc_font.height;
+
 				if (v.v_vlin)
 					vcp->vc_scan_lines = v.v_vlin;
 				if (v.v_clin)
 					vcp->vc_font.height = v.v_clin;
 				vcp->vc_resize_user = 1;
-				vc_resize(vcp, v.v_cols, v.v_rows);
+				ret = vc_resize(vcp, v.v_cols, v.v_rows);
+				if (ret) {
+					vcp->vc_scan_lines = save_scan_lines;
+					vcp->vc_font.height = save_font_height;
+					console_unlock();
+					return ret;
+				}
 			}
 			console_unlock();
 		}


