Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8952A4522C8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378605AbhKPBQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238724AbhKOTPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01931634BE;
        Mon, 15 Nov 2021 18:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000470;
        bh=wsGKm10ksuY31FjjYSn3/mUsd6W6EqvPSKvZOrHEg78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p27KWJup0NWgVCirs5vacb0gw2e5ivgRzq+uH5rDoYRsRemKjN4yS5fblxYPX8vVL
         nUgGCYwpiVLc0Gp2LI9ZA57J0O+jjiKrp+mtZekXFmSP/ZOQob0JgKFpkDZO3kGu6o
         s849B2CSEo/u8IWf6Cs3dxMjd5QME+zzREkh6MHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 670/849] rtc: pcf2123: Add SPI ID table
Date:   Mon, 15 Nov 2021 18:02:33 +0100
Message-Id: <20211115165442.924974212@linuxfoundation.org>
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

[ Upstream commit 5f84478e14aa8b43a4ea85d2e091931741947749 ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding an id_table listing the
SPI IDs for everything.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210923194922.53386-4-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf2123.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index 0f58cac81d8c0..7473e6c8a183b 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -451,12 +451,21 @@ static const struct of_device_id pcf2123_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, pcf2123_dt_ids);
 #endif
 
+static const struct spi_device_id pcf2123_spi_ids[] = {
+	{ .name = "pcf2123", },
+	{ .name = "rv2123", },
+	{ .name = "rtc-pcf2123", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(spi, pcf2123_spi_ids);
+
 static struct spi_driver pcf2123_driver = {
 	.driver	= {
 			.name	= "rtc-pcf2123",
 			.of_match_table = of_match_ptr(pcf2123_dt_ids),
 	},
 	.probe	= pcf2123_probe,
+	.id_table = pcf2123_spi_ids,
 };
 
 module_spi_driver(pcf2123_driver);
-- 
2.33.0



