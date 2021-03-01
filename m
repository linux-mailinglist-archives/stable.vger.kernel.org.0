Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C547B329202
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243477AbhCAUhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:37:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238807AbhCAU3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:29:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0D786541F;
        Mon,  1 Mar 2021 18:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622074;
        bh=OqF8kGi6hIdK9vSDb+mzFFWMLfTp4M7QdefA1DWUTf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsYym0imgr/JJ0iMsiBo9XcvdzomSLoMGEyWRKQX2dTzOB6qAjx9ucNBHJUBtq7r3
         Q3NTg1LfKnmInC88EIeQiDHXQZD1iLxVIVPK+m6aN2b36Gg7JcZPfhLVZS9+BahjNf
         0sCR58L7/sBMmsChuYtoX5nKC0zXFKHFv95TlBkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.11 747/775] spi: fsl: invert spisel_boot signal on MPC8309
Date:   Mon,  1 Mar 2021 17:15:15 +0100
Message-Id: <20210301161238.232428519@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
 


