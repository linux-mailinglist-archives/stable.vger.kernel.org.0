Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623DE45C09A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346726AbhKXNJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348229AbhKXNJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6C2B610A1;
        Wed, 24 Nov 2021 12:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757565;
        bh=f87D2RB4NZhf9JACyxt4BE2xBfihr3GK3rOau+/RW+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZcFPBBs6laX5qx0yjUT7uT0mx+bvbXmK81sR9qNhsw9K1wvEqtnRUsGm7MLh1AIV
         D6z528aguCAeARygO61fGnP3VMmeCz6sO5VEiv7RS+5fsetywDkfKOU+FWWuCmUH8X
         fdkeqpMcJ+hbNdu1qQHwDUsZCExMtBBD+X/bSAlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin van der Gracht <robin@protonic.nl>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 211/323] auxdisplay: ht16k33: Fix frame buffer device blanking
Date:   Wed, 24 Nov 2021 12:56:41 +0100
Message-Id: <20211124115726.053338119@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 840fe258332544aa7321921e1723d37b772af7a9 ]

As the ht16k33 frame buffer sub-driver does not register an
fb_ops.fb_blank() handler, blanking does not work:

    $ echo 1 > /sys/class/graphics/fb0/blank
    sh: write error: Invalid argument

Fix this by providing a handler that always returns zero, to make sure
blank events will be sent to the actual device handling the backlight.

Reported-by: Robin van der Gracht <robin@protonic.nl>
Suggested-by: Robin van der Gracht <robin@protonic.nl>
Fixes: 8992da44c6805d53 ("auxdisplay: ht16k33: Driver for LED controller")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/ht16k33.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/auxdisplay/ht16k33.c b/drivers/auxdisplay/ht16k33.c
index f6927871fa4e8..03a87dd1f625e 100644
--- a/drivers/auxdisplay/ht16k33.c
+++ b/drivers/auxdisplay/ht16k33.c
@@ -219,6 +219,15 @@ static const struct backlight_ops ht16k33_bl_ops = {
 	.check_fb	= ht16k33_bl_check_fb,
 };
 
+/*
+ * Blank events will be passed to the actual device handling the backlight when
+ * we return zero here.
+ */
+static int ht16k33_blank(int blank, struct fb_info *info)
+{
+	return 0;
+}
+
 static int ht16k33_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	struct ht16k33_priv *priv = info->par;
@@ -231,6 +240,7 @@ static struct fb_ops ht16k33_fb_ops = {
 	.owner = THIS_MODULE,
 	.fb_read = fb_sys_read,
 	.fb_write = fb_sys_write,
+	.fb_blank = ht16k33_blank,
 	.fb_fillrect = sys_fillrect,
 	.fb_copyarea = sys_copyarea,
 	.fb_imageblit = sys_imageblit,
-- 
2.33.0



