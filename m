Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43043431E49
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhJRN74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234304AbhJRN5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E61306139E;
        Mon, 18 Oct 2021 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564468;
        bh=rEet7YUxuIXeiVZf3/YE6pPboeMS3BSY1qV4RzFQQlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTzm4lVMy0BUXetqWNeprlUrB8ZG1Q/WvMftp8ziVpba2udnulJCUgF3bbcicWAqT
         s3TDO1kG1bxWYkijEGLbnVA6iXdBjdVRE6Rn7QzqKUFzUKSu/4X1Gd43gMJ6zeSDRQ
         4OJI9UwVkpke7GQVjEFsnjVUhlzzQxMAG5i8K4nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.14 099/151] gpio: 74x164: Add SPI device ID table
Date:   Mon, 18 Oct 2021 15:24:38 +0200
Message-Id: <20211018132343.887300062@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit be4491838359e78e42e88db4ac479e21c5eda1e0 upstream.

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding a SPI device ID table.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-74x164.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpio/gpio-74x164.c
+++ b/drivers/gpio/gpio-74x164.c
@@ -174,6 +174,13 @@ static int gen_74x164_remove(struct spi_
 	return 0;
 }
 
+static const struct spi_device_id gen_74x164_spi_ids[] = {
+	{ .name = "74hc595" },
+	{ .name = "74lvc594" },
+	{},
+};
+MODULE_DEVICE_TABLE(spi, gen_74x164_spi_ids);
+
 static const struct of_device_id gen_74x164_dt_ids[] = {
 	{ .compatible = "fairchild,74hc595" },
 	{ .compatible = "nxp,74lvc594" },
@@ -188,6 +195,7 @@ static struct spi_driver gen_74x164_driv
 	},
 	.probe		= gen_74x164_probe,
 	.remove		= gen_74x164_remove,
+	.id_table	= gen_74x164_spi_ids,
 };
 module_spi_driver(gen_74x164_driver);
 


