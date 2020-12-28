Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD002E429D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407557AbgL1N6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:58:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391620AbgL1N6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:58:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 724DC206D4;
        Mon, 28 Dec 2020 13:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163857;
        bh=QUQBwe+w8UY2x4I69f9tbE4aqveZ8D5HF1lCcBfUCWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uY99wrkpbzOZiK5Wyu3uRd0/QF3P6dSW8QIZTBRjcXX6u1hwttX61eVsv1HL8cAKF
         PP1Q9BXmJR376JiUoy0Q1dePYHf4SvpFATXAnYLdMx0TJtQV/+zSv2/P42UVaioQle
         FSmzFWYd/JerLzcisCBRVRKh95KjijIDMJxiW2q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 405/453] spi: fsl: fix use of spisel_boot signal on MPC8309
Date:   Mon, 28 Dec 2020 13:50:41 +0100
Message-Id: <20201228124956.701538844@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

commit 122541f2b10897b08f7f7e6db5f1eb693e51f0a1 upstream.

Commit 0f0581b24bd0 ("spi: fsl: Convert to use CS GPIO descriptors")
broke the use of the SPISEL_BOOT signal as a chip select on the
MPC8309.

pdata->max_chipselect, which becomes master->num_chipselect, must be
initialized to take into account the possibility that there's one more
chip select in use than the number of GPIO chip selects.

Cc: stable@vger.kernel.org # v5.4+
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Linus Walleij <linus.walleij@linaro.org>
Fixes: 0f0581b24bd0 ("spi: fsl: Convert to use CS GPIO descriptors")
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Link: https://lore.kernel.org/r/20201127152947.376-1-rasmus.villemoes@prevas.dk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-spi.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -717,10 +717,11 @@ static int of_fsl_spi_probe(struct platf
 	type = fsl_spi_get_type(&ofdev->dev);
 	if (type == TYPE_FSL) {
 		struct fsl_spi_platform_data *pdata = dev_get_platdata(dev);
+		bool spisel_boot = false;
 #if IS_ENABLED(CONFIG_FSL_SOC)
 		struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(pdata);
-		bool spisel_boot = of_property_read_bool(np, "fsl,spisel_boot");
 
+		spisel_boot = of_property_read_bool(np, "fsl,spisel_boot");
 		if (spisel_boot) {
 			pinfo->immr_spi_cs = ioremap(get_immrbase() + IMMR_SPI_CS_OFFSET, 4);
 			if (!pinfo->immr_spi_cs) {
@@ -737,10 +738,14 @@ static int of_fsl_spi_probe(struct platf
 		 * supported on the GRLIB variant.
 		 */
 		ret = gpiod_count(dev, "cs");
-		if (ret <= 0)
+		if (ret < 0)
+			ret = 0;
+		if (ret == 0 && !spisel_boot) {
 			pdata->max_chipselect = 1;
-		else
+		} else {
+			pdata->max_chipselect = ret + spisel_boot;
 			pdata->cs_control = fsl_spi_cs_control;
+		}
 	}
 
 	ret = of_address_to_resource(np, 0, &mem);


