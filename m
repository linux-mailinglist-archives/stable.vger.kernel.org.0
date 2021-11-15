Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635144525E5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343731AbhKPB74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240062AbhKOSJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:09:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E396329B;
        Mon, 15 Nov 2021 17:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998385;
        bh=f1mIN4gYuWnP6R2ic3w6g+Qu96gOSlDme395r1CZjhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpJFcJ5u0UJexKjEvewFZL/iQnkSDfW6wm5IZyOQyOhIPux19ZotW9NjvWeOeyZvX
         I7klkDT72BHHDgMoouhHdEQnfQdi3+BHNTyNPefQHoJtwkG6GQvYgfigTLk+MqAQ7s
         0rIA0tcilLmY4tjBlOYMhVZEVJGV/OWO98ka0T+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin van der Gracht <robin@protonic.nl>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 490/575] auxdisplay: ht16k33: Fix frame buffer device blanking
Date:   Mon, 15 Nov 2021 18:03:35 +0100
Message-Id: <20211115165400.644860630@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index b8c25a17186b5..7e3858c4e030f 100644
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
@@ -231,6 +240,7 @@ static const struct fb_ops ht16k33_fb_ops = {
 	.owner = THIS_MODULE,
 	.fb_read = fb_sys_read,
 	.fb_write = fb_sys_write,
+	.fb_blank = ht16k33_blank,
 	.fb_fillrect = sys_fillrect,
 	.fb_copyarea = sys_copyarea,
 	.fb_imageblit = sys_imageblit,
-- 
2.33.0



