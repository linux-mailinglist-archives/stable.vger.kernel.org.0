Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F57353E6D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238628AbhDEJFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238654AbhDEJFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:05:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58CF6613A7;
        Mon,  5 Apr 2021 09:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613538;
        bh=pEzju/dlC2eXW2eScCWdr+GsuWS3ibxQw6GHftvlrlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ha4py1siEOtxHPbxh+1U+SjabVrSqrbm2L6686Do7xo8t7aWGaxsr6EciPProsdEk
         EQqs9BQY3DMEqGiuJc87nwch+7sHHtNlru6q8gxLiSyFF8GCWZa2sCW4ApAb580NRE
         SuNQ9sIN+pgsPZbTdz/5uLmDDmirPaGdm4W4rCho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b67aaae8d3a927f68d20@syzkaller.appspotmail.com,
        Du Cheng <ducheng2@gmail.com>
Subject: [PATCH 5.4 74/74] drivers: video: fbcon: fix NULL dereference in fbcon_cursor()
Date:   Mon,  5 Apr 2021 10:54:38 +0200
Message-Id: <20210405085027.153874789@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

commit 01faae5193d6190b7b3aa93dae43f514e866d652 upstream.

add null-check on function pointer before dereference on ops->cursor

Reported-by: syzbot+b67aaae8d3a927f68d20@syzkaller.appspotmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Link: https://lore.kernel.org/r/20210312081421.452405-1-ducheng2@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1339,6 +1339,9 @@ static void fbcon_cursor(struct vc_data
 
 	ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;
 
+	if (!ops->cursor)
+		return;
+
 	ops->cursor(vc, info, mode, get_color(vc, info, c, 1),
 		    get_color(vc, info, c, 0));
 }


