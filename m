Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE084272F98
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgIUQ62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729467AbgIUQlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:41:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9022076B;
        Mon, 21 Sep 2020 16:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706512;
        bh=0K8unwuVdEnitQmmbzXtHLrjYn+jgY5egNSiHxqrTng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYA2DiGdWjI4v9Tba1aoIx7Qf9tI9iIVmaKxIcXtXF3jMzTxv4mFEXnqJqTo+h7DW
         n7xbmAsk6Y2OISy+ni60F6FaSPWt5kKO6s+TgkD9OMqurt9aK7OLJTxA2pJIdFYwGv
         sYVCKBykwJ/SMFR6XJLN4hXkpErnkYzwPYq/0zB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+b38b1ef6edf0c74a8d97@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        George Kennedy <george.kennedy@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/49] fbcon: Fix user font detection test at fbcon_resize().
Date:   Mon, 21 Sep 2020 18:28:17 +0200
Message-Id: <20200921162036.118784075@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit ec0972adecb391a8d8650832263a4790f3bfb4df ]

syzbot is reporting OOB read at fbcon_resize() [1], for
commit 39b3cffb8cf31117 ("fbcon: prevent user font height or width change
 from causing potential out-of-bounds access") is by error using
registered_fb[con2fb_map[vc->vc_num]]->fbcon_par->p->userfont (which was
set to non-zero) instead of fb_display[vc->vc_num].userfont (which remains
zero for that display).

We could remove tricky userfont flag [2], for we can determine it by
comparing address of the font data and addresses of built-in font data.
But since that commit is failing to fix the original OOB read [3], this
patch keeps the change minimal in case we decide to revert altogether.

[1] https://syzkaller.appspot.com/bug?id=ebcbbb6576958a496500fee9cf7aa83ea00b5920
[2] https://syzkaller.appspot.com/text?tag=Patch&x=14030853900000
[3] https://syzkaller.appspot.com/bug?id=6fba8c186d97cf1011ab17660e633b1cc4e080c9

Reported-by: syzbot <syzbot+b38b1ef6edf0c74a8d97@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 39b3cffb8cf31117 ("fbcon: prevent user font height or width change from causing potential out-of-bounds access")
Cc: George Kennedy <george.kennedy@oracle.com>
Link: https://lore.kernel.org/r/f6e3e611-8704-1263-d163-f52c906a4f06@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 29226b6cb632d..0bf5ea518558c 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1979,7 +1979,7 @@ static int fbcon_resize(struct vc_data *vc, unsigned int width,
 	struct fb_var_screeninfo var = info->var;
 	int x_diff, y_diff, virt_w, virt_h, virt_fw, virt_fh;
 
-	if (ops->p && ops->p->userfont && FNTSIZE(vc->vc_font.data)) {
+	if (p->userfont && FNTSIZE(vc->vc_font.data)) {
 		int size;
 		int pitch = PITCH(vc->vc_font.width);
 
-- 
2.25.1



