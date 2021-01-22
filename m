Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04123005E4
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbhAVOrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:47:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbhAVOZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:25:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A17AF23A7D;
        Fri, 22 Jan 2021 14:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325174;
        bh=KyrULsYQmIiuhIKuJYxY/FluOQshkhufQcJc9d6Lytc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRUORr9LE4GeXvEFNuuYC2Rem13ZswgiNu5xxFP22UuB4vgYlkmZB4maTTsow/tDQ
         spmrcdbAb9+/RN1+JOQUTTJjSAv55bphtT4NFcs115XH9zdaQUYGvO8+Age9ZVsu40
         Ov6+9OiLkV2/egd+K5am9ESNIkCWJpCDrF0oc71c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 42/43] spi: fsl: Fix driver breakage when SPI_CS_HIGH is not set in spi->mode
Date:   Fri, 22 Jan 2021 15:12:58 +0100
Message-Id: <20210122135737.366019166@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 7a2da5d7960a64ee923fe3e31f01a1101052c66f upstream.

Commit 766c6b63aa04 ("spi: fix client driver breakages when using GPIO
descriptors") broke fsl spi driver.

As now we fully rely on gpiolib for handling the polarity of
chip selects, the driver shall not alter the GPIO value anymore
when SPI_CS_HIGH is not set in spi->mode.

Fixes: 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/6b51cc2bfbca70d3e9b9da7b7aa4c7a9d793ca0e.1610629002.git.christophe.leroy@csgroup.eu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-spi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -115,14 +115,13 @@ static void fsl_spi_chipselect(struct sp
 {
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
 	struct fsl_spi_platform_data *pdata;
-	bool pol = spi->mode & SPI_CS_HIGH;
 	struct spi_mpc8xxx_cs	*cs = spi->controller_state;
 
 	pdata = spi->dev.parent->parent->platform_data;
 
 	if (value == BITBANG_CS_INACTIVE) {
 		if (pdata->cs_control)
-			pdata->cs_control(spi, !pol);
+			pdata->cs_control(spi, false);
 	}
 
 	if (value == BITBANG_CS_ACTIVE) {
@@ -134,7 +133,7 @@ static void fsl_spi_chipselect(struct sp
 		fsl_spi_change_mode(spi);
 
 		if (pdata->cs_control)
-			pdata->cs_control(spi, pol);
+			pdata->cs_control(spi, true);
 	}
 }
 


