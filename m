Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DAA328F89
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242261AbhCATwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:52:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242200AbhCAToD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6ACF65095;
        Mon,  1 Mar 2021 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619936;
        bh=OqF8kGi6hIdK9vSDb+mzFFWMLfTp4M7QdefA1DWUTf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+KeAY6IEi2s6sSTANkm+6hOKMW7TtvlCCxfDX3J/X5vHBHnlKkbEuR2HRhDdTD/W
         ihidfVtRq8+jfYQVyGdCaJyarL1WDDWPIiPzVB1io3Aiqe5vsms4pZWCaNU1hH76yS
         MBLR5p/1GYvmJHNOVmAhpaGFEJmNurUbBvvxbagA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 635/663] spi: fsl: invert spisel_boot signal on MPC8309
Date:   Mon,  1 Mar 2021 17:14:43 +0100
Message-Id: <20210301161213.272536280@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

commit 9d2aa6dbf87af89c13cac2d1b4cccad83fb14a7e upstream.

Commit 7a2da5d7960a ("spi: fsl: Fix driver breakage when SPI_CS_HIGH
is not set in spi->mode") broke our MPC8309 board by effectively
inverting the boolean value passed to fsl_spi_cs_control. The
SPISEL_BOOT signal is used as chipselect, but it's not a gpio, so
we cannot rely on gpiolib handling the polarity.

Adapt to the new world order by inverting the logic here. This does
assume that the slave sitting at the SPISEL_BOOT is active low, but
should that ever turn out not to be the case, one can create a stub
gpiochip driver controlling a single gpio (or rather, a single "spo",
special-purpose output).

Fixes: 7a2da5d7960a ("spi: fsl: Fix driver breakage when SPI_CS_HIGH is not set in spi->mode")
Cc: stable@vger.kernel.org
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Link: https://lore.kernel.org/r/20210130143545.505613-1-rasmus.villemoes@prevas.dk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -695,7 +695,7 @@ static void fsl_spi_cs_control(struct sp
 
 		if (WARN_ON_ONCE(!pinfo->immr_spi_cs))
 			return;
-		iowrite32be(on ? SPI_BOOT_SEL_BIT : 0, pinfo->immr_spi_cs);
+		iowrite32be(on ? 0 : SPI_BOOT_SEL_BIT, pinfo->immr_spi_cs);
 	}
 }
 


