Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F4A2E653E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393186AbgL1P67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387907AbgL1Nd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:33:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4990B208BA;
        Mon, 28 Dec 2020 13:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162390;
        bh=3wSvMfr6rAe3rr5bfNq49T8RsR1hMLZUWvLvwV6wReY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8cEZWpUdlpLXtjTWqCfV1FYiXmAiKeELGy9pW/PjpPfcgpePeRDbfLgB9PfWad1x
         879DIzDSnP4wohUFVykzYKkKWPUyEWrj7cNXwF+sFr2pbfWZ378BbZIKPwSO9Xgd5E
         Wv7y63YYtmV2fYjEWeq1Rv/MrW6LpCiUE2Nk6Je8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        syzbot+44e64397bd81d5e84cba@syzkaller.appspotmail.com
Subject: [PATCH 4.19 258/346] media: gspca: Fix memory leak in probe
Date:   Mon, 28 Dec 2020 13:49:37 +0100
Message-Id: <20201228124932.252331748@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit e469d0b09a19496e1972a20974bbf55b728151eb upstream.

The gspca driver leaks memory when a probe fails.  gspca_dev_probe2()
calls v4l2_device_register(), which takes a reference to the
underlying device node (in this case, a USB interface).  But the
failure pathway neglects to call v4l2_device_unregister(), the routine
responsible for dropping this reference.  Consequently the memory for
the USB interface and its device never gets released.

This patch adds the missing function call.

Reported-and-tested-by: syzbot+44e64397bd81d5e84cba@syzkaller.appspotmail.com

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/gspca/gspca.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1585,6 +1585,7 @@ out:
 		input_unregister_device(gspca_dev->input_dev);
 #endif
 	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
+	v4l2_device_unregister(&gspca_dev->v4l2_dev);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 	return ret;


