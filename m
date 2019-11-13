Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88364FA263
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfKMCC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:02:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731019AbfKMCC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:02:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCC50204EC;
        Wed, 13 Nov 2019 02:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610545;
        bh=sRrLkyUGgCKpwty94eVo3szlNVzGQWCr0iIWSeGW3dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vt5Vy3ufTvimNav0XOMmJEvNA3X5/eAtEAH4BB3yaoxTL5F+F+SGrsK3l+chWCcPK
         61j6CR12prTjfwpbS2+6C0IS9YtIo2+4Y4R3Wt51+6QySHKdQ7PbnTw+1SIdssBp4h
         Lci3SJoRpEbtpUqmh/mk1VqVsXscNSEYFgQK1arA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Mathieu Malaterre <malat@debian.org>,
        Peter Malone <peter.malone@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 32/48] fbdev: sbuslib: use checked version of put_user()
Date:   Tue, 12 Nov 2019 21:01:15 -0500
Message-Id: <20191113020131.13356-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113020131.13356-1-sashal@kernel.org>
References: <20191113020131.13356-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d8bad911e5e55e228d59c0606ff7e6b8131ca7bf ]

I'm not sure why the code assumes that only the first put_user() needs
an access_ok() check.  I have made all the put_user() and get_user()
calls checked.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Peter Malone <peter.malone@gmail.com>,
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sbuslib.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/video/fbdev/sbuslib.c b/drivers/video/fbdev/sbuslib.c
index 31c301d6be621..b425718925c01 100644
--- a/drivers/video/fbdev/sbuslib.c
+++ b/drivers/video/fbdev/sbuslib.c
@@ -105,11 +105,11 @@ int sbusfb_ioctl_helper(unsigned long cmd, unsigned long arg,
 		struct fbtype __user *f = (struct fbtype __user *) arg;
 
 		if (put_user(type, &f->fb_type) ||
-		    __put_user(info->var.yres, &f->fb_height) ||
-		    __put_user(info->var.xres, &f->fb_width) ||
-		    __put_user(fb_depth, &f->fb_depth) ||
-		    __put_user(0, &f->fb_cmsize) ||
-		    __put_user(fb_size, &f->fb_cmsize))
+		    put_user(info->var.yres, &f->fb_height) ||
+		    put_user(info->var.xres, &f->fb_width) ||
+		    put_user(fb_depth, &f->fb_depth) ||
+		    put_user(0, &f->fb_cmsize) ||
+		    put_user(fb_size, &f->fb_cmsize))
 			return -EFAULT;
 		return 0;
 	}
@@ -124,10 +124,10 @@ int sbusfb_ioctl_helper(unsigned long cmd, unsigned long arg,
 		unsigned int index, count, i;
 
 		if (get_user(index, &c->index) ||
-		    __get_user(count, &c->count) ||
-		    __get_user(ured, &c->red) ||
-		    __get_user(ugreen, &c->green) ||
-		    __get_user(ublue, &c->blue))
+		    get_user(count, &c->count) ||
+		    get_user(ured, &c->red) ||
+		    get_user(ugreen, &c->green) ||
+		    get_user(ublue, &c->blue))
 			return -EFAULT;
 
 		cmap.len = 1;
@@ -164,10 +164,10 @@ int sbusfb_ioctl_helper(unsigned long cmd, unsigned long arg,
 		u8 red, green, blue;
 
 		if (get_user(index, &c->index) ||
-		    __get_user(count, &c->count) ||
-		    __get_user(ured, &c->red) ||
-		    __get_user(ugreen, &c->green) ||
-		    __get_user(ublue, &c->blue))
+		    get_user(count, &c->count) ||
+		    get_user(ured, &c->red) ||
+		    get_user(ugreen, &c->green) ||
+		    get_user(ublue, &c->blue))
 			return -EFAULT;
 
 		if (index + count > cmap->len)
-- 
2.20.1

