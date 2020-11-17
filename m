Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C0C2B6445
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733022AbgKQNpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:45:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732772AbgKQNjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:39:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C88AF2467A;
        Tue, 17 Nov 2020 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620382;
        bh=wFZfRTo3gclA5icUvxq051d9frOto9zeN26i1lFRyTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uo9aZLmIX45dvGr+MSMuwPX/PN6gVXhUt6hWW8U3xkwux4wTQNFr5qQa7G0RqVvGz
         EYR9CJcwB8R04zTm7hjaxs28yDCMpsnmPrms9/EZ7g+voF1NicG4zv7+98odJNiWro
         43mGX0SP8pNxuo3YFcqbIWzas6WFxOyzBOz/13gY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.9 200/255] Revert "usb: musb: convert to devm_platform_ioremap_resource_byname"
Date:   Tue, 17 Nov 2020 14:05:40 +0100
Message-Id: <20201117122148.667596171@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit ffa13d2d94029882eca22a565551783787f121e5 upstream.

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
 drivers/usb/musb/musb_dsps.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -429,10 +429,12 @@ static int dsps_musb_init(struct musb *m
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


