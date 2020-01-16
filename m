Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6972E13FF8F
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389842AbgAPXn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:43:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387656AbgAPXYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D58B82075B;
        Thu, 16 Jan 2020 23:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217074;
        bh=s74q2vs0Pm/TZ/Gqkd/YCzfn1ZB1h0PHMDmLnjAnEsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qep5xNjtq2oUruJqVZxqUrTy/Ebs1uL0c2x1rI3uJwitnvCya67/1pb0SEr0wIaoJ
         LO20obMR3uZRdNR/xqT8kkqI/BWcnYIZipwIWpHoj46ffgkhmNFoBRHMt4K3ZUjGYw
         XPWravIG1Ec6GvISIFqwhTeIcln+zDhykxZs9x2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stephen Boyd <swboyd@chromium.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 5.4 121/203] pinctrl: sh-pfc: Do not use platform_get_irq() to count interrupts
Date:   Fri, 17 Jan 2020 00:17:18 +0100
Message-Id: <20200116231755.888490098@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit ad7fe1a1a35994a201497443b5140bf54b074cca upstream.

As platform_get_irq() now prints an error when the interrupt does not
exist, counting interrupts by looping until failure causes the printing
of scary messages like:

    sh-pfc e6060000.pin-controller: IRQ index 0 not found

Fix this by using the platform_irq_count() helper instead.

Fixes: 7723f4c5ecdb8d83 ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20191016142601.28255-1-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/sh-pfc/core.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/pinctrl/sh-pfc/core.c
+++ b/drivers/pinctrl/sh-pfc/core.c
@@ -29,12 +29,12 @@
 static int sh_pfc_map_resources(struct sh_pfc *pfc,
 				struct platform_device *pdev)
 {
-	unsigned int num_windows, num_irqs;
 	struct sh_pfc_window *windows;
 	unsigned int *irqs = NULL;
+	unsigned int num_windows;
 	struct resource *res;
 	unsigned int i;
-	int irq;
+	int num_irqs;
 
 	/* Count the MEM and IRQ resources. */
 	for (num_windows = 0;; num_windows++) {
@@ -42,17 +42,13 @@ static int sh_pfc_map_resources(struct s
 		if (!res)
 			break;
 	}
-	for (num_irqs = 0;; num_irqs++) {
-		irq = platform_get_irq(pdev, num_irqs);
-		if (irq == -EPROBE_DEFER)
-			return irq;
-		if (irq < 0)
-			break;
-	}
-
 	if (num_windows == 0)
 		return -EINVAL;
 
+	num_irqs = platform_irq_count(pdev);
+	if (num_irqs < 0)
+		return num_irqs;
+
 	/* Allocate memory windows and IRQs arrays. */
 	windows = devm_kcalloc(pfc->dev, num_windows, sizeof(*windows),
 			       GFP_KERNEL);


