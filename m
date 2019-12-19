Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A9F126DB8
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfLSTLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:11:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbfLSShy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:37:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5000A222C2;
        Thu, 19 Dec 2019 18:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780673;
        bh=1HKDtvWYNVyMJcPdD5ufXrP3BQadBttkknjlLK6HduI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5fALnarnEv6Pyb3Ei8YVEyV5oYH2nJ1U1SKbvJs5E0l+z2qV9pfqyTkU3CmWWWfN
         tQ6WtroHqxnCNL4oo71wGUgImVlPSrtTd1MZ0vQTuG8WZfa1XVBLj4ISGJuD+huvUx
         NGZpSV5771FaGJa5k0VW1xN3zkU33+y7jjy6Eeio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 068/162] spi: atmel: Fix CS high support
Date:   Thu, 19 Dec 2019 19:32:56 +0100
Message-Id: <20191219183211.968120548@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@bootlin.com>

commit 7cbb16b2122c09f2ae393a1542fed628505b9da6 upstream.

Until a few years ago, this driver was only used with CS GPIO. The
only exception is CS0 on AT91RM9200 which has to use internal CS. A
limitation of the internal CS is that they don't support CS High.

So by using the CS GPIO the CS high configuration was available except
for the particular case CS0 on RM9200.

When the support for the internal chip-select was added, the check of
the CS high support was not updated. Due to this the driver accepts
this configuration for all the SPI controller v2 (used by all SoCs
excepting the AT91RM9200) whereas the hardware doesn't support it for
infernal CS.

This patch fixes the test to match the hardware capabilities.

Fixes: 4820303480a1 ("spi: atmel: add support for the internal chip-select of the spi controller")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20191017141846.7523-3-gregory.clement@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-atmel.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1209,10 +1209,8 @@ static int atmel_spi_setup(struct spi_de
 	as = spi_master_get_devdata(spi->master);
 
 	/* see notes above re chipselect */
-	if (!atmel_spi_is_v2(as)
-			&& spi->chip_select == 0
-			&& (spi->mode & SPI_CS_HIGH)) {
-		dev_dbg(&spi->dev, "setup: can't be active-high\n");
+	if (!as->use_cs_gpios && (spi->mode & SPI_CS_HIGH)) {
+		dev_warn(&spi->dev, "setup: non GPIO CS can't be active-high\n");
 		return -EINVAL;
 	}
 


