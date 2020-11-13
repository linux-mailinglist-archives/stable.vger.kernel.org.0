Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D122B1BE3
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 14:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgKMNaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 08:30:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgKMNaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 08:30:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E31D92085B;
        Fri, 13 Nov 2020 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605274218;
        bh=UjHo09uhR1R7bMBz4gJfb3dG7zqRZvhoqZPr1Rr+j9I=;
        h=Subject:To:From:Date:From;
        b=agCwFbzQ4ZHjCXZJET3GysW355VIUu5PNagsdd1IWRxnsfW2deeO8AbWkzwGbhcrb
         8mkf7tXW5t3u1qgPkW6XNAsy7fkmPmAwcZVjR9bf0NXkUeLB2caaAOpzy+cOyo8Etu
         AI8sPQHouVD455Q7Xwds8w0wmiWHQB19OVkHGCDw=
Subject: patch "Revert "usb: musb: convert to devm_platform_ioremap_resource_byname"" added to usb-linus
To:     geert+renesas@glider.be, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 13 Nov 2020 14:31:15 +0100
Message-ID: <16052742753528@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "usb: musb: convert to devm_platform_ioremap_resource_byname"

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ffa13d2d94029882eca22a565551783787f121e5 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Thu, 12 Nov 2020 14:59:00 +0100
Subject: Revert "usb: musb: convert to devm_platform_ioremap_resource_byname"

This reverts commit 2d30e408a2a6b3443d3232593e3d472584a3e9f8.

On Beaglebone Black, where each interface has 2 children:

    musb-dsps 47401c00.usb: can't request region for resource [mem 0x47401800-0x474019ff]
    musb-hdrc musb-hdrc.1: musb_init_controller failed with status -16
    musb-hdrc: probe of musb-hdrc.1 failed with error -16
    musb-dsps 47401400.usb: can't request region for resource [mem 0x47401000-0x474011ff]
    musb-hdrc musb-hdrc.0: musb_init_controller failed with status -16
    musb-hdrc: probe of musb-hdrc.0 failed with error -16

Before, devm_ioremap_resource() was called on "dev" ("musb-hdrc.0" or
"musb-hdrc.1"), after it is called on "&pdev->dev" ("47401400.usb" or
"47401c00.usb"), leading to a duplicate region request, which fails.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 2d30e408a2a6 ("usb: musb: convert to devm_platform_ioremap_resource_byname")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201112135900.3822599-1-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_dsps.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 30085b2be7b9..5892f3ce0cdc 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -429,10 +429,12 @@ static int dsps_musb_init(struct musb *musb)
 	struct platform_device *parent = to_platform_device(dev->parent);
 	const struct dsps_musb_wrapper *wrp = glue->wrp;
 	void __iomem *reg_base;
+	struct resource *r;
 	u32 rev, val;
 	int ret;
 
-	reg_base = devm_platform_ioremap_resource_byname(parent, "control");
+	r = platform_get_resource_byname(parent, IORESOURCE_MEM, "control");
+	reg_base = devm_ioremap_resource(dev, r);
 	if (IS_ERR(reg_base))
 		return PTR_ERR(reg_base);
 	musb->ctrl_base = reg_base;
-- 
2.29.2


