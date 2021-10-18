Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88B3431E21
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbhJRN55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234398AbhJRNz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:55:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5016613A1;
        Mon, 18 Oct 2021 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564422;
        bh=5uAmbIsyWlNJmxe5/Mf4Itd1jbhwgkNurGQCEKrmiCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRZigrnzY4xFegGcJp06o0ie/UKC++nxzEV6Rsqb5LiYHnUq0XFr9qSwEA8/W+dKC
         tGlMWdAX5hZ2lgY+aI0ADtGl7UdVs9NTQWLa+GP3Mqy6Y+wpUG/uoIuZalV7e24g2h
         G/LbqbfiJGOV91lB3a7n8bwHLH9KtXJzcUz8f3bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.14 084/151] eeprom: at25: Add SPI ID table
Date:   Mon, 18 Oct 2021 15:24:23 +0200
Message-Id: <20211018132343.416133030@linuxfoundation.org>
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

commit 9e2cd444909b3c93f5cc83463d12291e3e0f990b upstream.

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding an id_table listing the
SPI IDs for everything.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210923172453.4921-1-broonie@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/at25.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -366,6 +366,13 @@ static const struct of_device_id at25_of
 };
 MODULE_DEVICE_TABLE(of, at25_of_match);
 
+static const struct spi_device_id at25_spi_ids[] = {
+	{ .name = "at25",},
+	{ .name = "fm25",},
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, at25_spi_ids);
+
 static int at25_probe(struct spi_device *spi)
 {
 	struct at25_data	*at25 = NULL;
@@ -491,6 +498,7 @@ static struct spi_driver at25_driver = {
 		.dev_groups	= sernum_groups,
 	},
 	.probe		= at25_probe,
+	.id_table	= at25_spi_ids,
 };
 
 module_spi_driver(at25_driver);


