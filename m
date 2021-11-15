Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DA1451481
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345157AbhKOUIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:08:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344649AbhKOTZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3813636A9;
        Mon, 15 Nov 2021 19:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002896;
        bh=CNvbAcdhZ2PsHJMjtkKDF0kxQ3hi5jEBvy5Vup0evvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/GfX3ZU1GAFYVKmbD4JLviH9vNaM4ffXgtajpUSQPueY2GaldOEWJ4EuUVI2cGm4
         QBjo4498MefrFBBrpuEEWJDdjEvHqsigrizsNUMhJgN7CzMG5GX2KAQW9QXKNYhVsP
         cIHLNSzvsdErOofeD7snNubqbyS7g+Jfrld+6ZvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 703/917] rtc: mcp795: Add SPI ID table
Date:   Mon, 15 Nov 2021 18:03:18 +0100
Message-Id: <20211115165452.723291685@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 3109151c47343c80300177ec7704e0757064efdc ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding an id_table listing the
SPI IDs for everything.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210927130240.33693-1-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mcp795.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/rtc/rtc-mcp795.c b/drivers/rtc/rtc-mcp795.c
index bad7792b6ca58..0d515b3df5710 100644
--- a/drivers/rtc/rtc-mcp795.c
+++ b/drivers/rtc/rtc-mcp795.c
@@ -430,12 +430,19 @@ static const struct of_device_id mcp795_of_match[] = {
 MODULE_DEVICE_TABLE(of, mcp795_of_match);
 #endif
 
+static const struct spi_device_id mcp795_spi_ids[] = {
+	{ .name = "mcp795" },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, mcp795_spi_ids);
+
 static struct spi_driver mcp795_driver = {
 		.driver = {
 				.name = "rtc-mcp795",
 				.of_match_table = of_match_ptr(mcp795_of_match),
 		},
 		.probe = mcp795_probe,
+		.id_table = mcp795_spi_ids,
 };
 
 module_spi_driver(mcp795_driver);
-- 
2.33.0



