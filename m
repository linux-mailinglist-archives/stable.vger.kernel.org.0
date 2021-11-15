Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D90451220
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238719AbhKOTaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244424AbhKOTOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:14:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E92634BF;
        Mon, 15 Nov 2021 18:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000464;
        bh=xIWacHPJYumNIerpRw8+Wy0rKa7p0QqJbQKbI/rlDNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7J+euyTYAmYnqXua+3eKVzue7GiMd0RrflqqsAsiNSrlsrPa6qzmjZjKY6iAD82y
         rFNbPPVfp40RVZWmLvMAnNnmoMlckV6tkW/1mSBy9mEtEbS77xyTyf99Hx9FWz5p4O
         hXJyt/4M/uIysoBvYAxPkuacjV30kx5KOtVbS2qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 668/849] rtc: ds1302: Add SPI ID table
Date:   Mon, 15 Nov 2021 18:02:31 +0100
Message-Id: <20211115165442.861214874@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 8719a17613e0233d707eb22e1645d217594631ef ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding an id_table listing the
SPI IDs for everything.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210923194922.53386-2-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1302.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
index b3de6d2e680a4..2f83adef966eb 100644
--- a/drivers/rtc/rtc-ds1302.c
+++ b/drivers/rtc/rtc-ds1302.c
@@ -199,11 +199,18 @@ static const struct of_device_id ds1302_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, ds1302_dt_ids);
 #endif
 
+static const struct spi_device_id ds1302_spi_ids[] = {
+	{ .name = "ds1302", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(spi, ds1302_spi_ids);
+
 static struct spi_driver ds1302_driver = {
 	.driver.name	= "rtc-ds1302",
 	.driver.of_match_table = of_match_ptr(ds1302_dt_ids),
 	.probe		= ds1302_probe,
 	.remove		= ds1302_remove,
+	.id_table	= ds1302_spi_ids,
 };
 
 module_spi_driver(ds1302_driver);
-- 
2.33.0



