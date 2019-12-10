Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4D6119821
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfLJVgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730350AbfLJVfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37C2024654;
        Tue, 10 Dec 2019 21:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013743;
        bh=uWX06uUxFeX8zetLZ36TwHYzBpw/f58N2akuobGPiWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZV2l75WTyasJprFKBs0H15uNO24QfcROR0aSClo8zIp6HcqXSqTqwX4PXQ4MQLqNY
         gQgyW+EeGEWEaJgnqPvGJF0koaz1EGJie7lGrSqPPl051DPNCkdvnNVZBK9zmKUNae
         zvzIJ8sroe1TRUvQic1l/+8Wt1OmQmsXzMWY9eBU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.19 165/177] fbtft: Make sure string is NULL terminated
Date:   Tue, 10 Dec 2019 16:32:09 -0500
Message-Id: <20191210213221.11921-165-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 21f585480deb4bcf0d92b08879c35d066dfee030 ]

New GCC warns about inappropriate use of strncpy():

drivers/staging/fbtft/fbtft-core.c: In function ‘fbtft_framebuffer_alloc’:
drivers/staging/fbtft/fbtft-core.c:665:2: warning: ‘strncpy’ specified bound 16 equals destination size [-Wstringop-truncation]
  665 |  strncpy(info->fix.id, dev->driver->name, 16);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Later on the copy is being used with the assumption to be NULL terminated.
Make sure string is NULL terminated by switching to snprintf().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20191120095716.26628-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 16fcf633e60f8..3fe4738720eab 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -771,7 +771,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	fbdefio->deferred_io =     fbtft_deferred_io;
 	fb_deferred_io_init(info);
 
-	strncpy(info->fix.id, dev->driver->name, 16);
+	snprintf(info->fix.id, sizeof(info->fix.id), "%s", dev->driver->name);
 	info->fix.type =           FB_TYPE_PACKED_PIXELS;
 	info->fix.visual =         FB_VISUAL_TRUECOLOR;
 	info->fix.xpanstep =	   0;
-- 
2.20.1

