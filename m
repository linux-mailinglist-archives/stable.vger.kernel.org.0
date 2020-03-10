Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA81717FDA8
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgCJMwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729005AbgCJMwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:52:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 245C420674;
        Tue, 10 Mar 2020 12:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844728;
        bh=3aUHtr5VhDOf2LoeEAfUA4zom+D6IHvYST6XzR/+4/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijPcdLVMJG0ZobxjpfL4TQOpXmdox8thgFFjWDa0uHnQByqVMmQQgR0py691balDA
         UAZs2ErWTsfqqUaTkwK10Ee2ZJf0tUPPi5eQIIGqaR+HxGNBh21fOL0Lcxyz7Sc/yD
         MzbVt8v1zu37p2Pkxx8AaJeUcCehJOGz4lchLyyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Han <z.han@kunbus.com>,
        Lukas Wunner <lukas@wunner.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 096/168] spi: spidev: Fix CS polarity if GPIO descriptors are used
Date:   Tue, 10 Mar 2020 13:39:02 +0100
Message-Id: <20200310123645.084722622@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 138c9c32f090894614899eca15e0bb7279f59865 upstream.

Commit f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
amended of_spi_parse_dt() to always set SPI_CS_HIGH for SPI slaves whose
Chip Select is defined by a "cs-gpios" devicetree property.

This change broke userspace applications which issue an SPI_IOC_WR_MODE
ioctl() to an spidev:  Chip Select polarity will be incorrect unless the
application is changed to set SPI_CS_HIGH.  And once changed, it will be
incompatible with kernels not containing the commit.

Fix by setting SPI_CS_HIGH in spidev_ioctl() (under the same conditions
as in of_spi_parse_dt()).

Fixes: f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
Reported-by: Simon Han <z.han@kunbus.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/fca3ba7cdc930cd36854666ceac4fbcf01b89028.1582027457.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spidev.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -394,6 +394,7 @@ spidev_ioctl(struct file *filp, unsigned
 		else
 			retval = get_user(tmp, (u32 __user *)arg);
 		if (retval == 0) {
+			struct spi_controller *ctlr = spi->controller;
 			u32	save = spi->mode;
 
 			if (tmp & ~SPI_MODE_MASK) {
@@ -401,6 +402,10 @@ spidev_ioctl(struct file *filp, unsigned
 				break;
 			}
 
+			if (ctlr->use_gpio_descriptors && ctlr->cs_gpiods &&
+			    ctlr->cs_gpiods[spi->chip_select])
+				tmp |= SPI_CS_HIGH;
+
 			tmp |= spi->mode & ~SPI_MODE_MASK;
 			spi->mode = (u16)tmp;
 			retval = spi_setup(spi);


