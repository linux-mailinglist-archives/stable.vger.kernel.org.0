Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D284C452227
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245747AbhKPBKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244951AbhKOTSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1540163338;
        Mon, 15 Nov 2021 18:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000771;
        bh=AIf3OGbDG7GkOz/5CLdnUl7dUuLx/f0kCjh6DXlo7e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/EPfUnd2opsIhy5TXimaZNZHKwjO/nuVmEFKqtH9TyeIee6W7VBiz9iCHpphzGH/
         o3PEw1rYGQXYZ/YSNjIT2cV+wzWRVK3Fmwxs6cEL+5HZYffEEvZz/JzpYLthuOLZv3
         tBQrhwcAX6iiwZi7YiSKWQh7PJysNj2758LwRjS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 743/849] mfd: cpcap: Add SPI device ID table
Date:   Mon, 15 Nov 2021 18:03:46 +0100
Message-Id: <20211115165445.383548482@linuxfoundation.org>
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

[ Upstream commit d5fa8592b773f4da2b04e7333cd37efec5e4ca43 ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding a SPI device ID table.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20210924143347.14721-3-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/motorola-cpcap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mfd/motorola-cpcap.c b/drivers/mfd/motorola-cpcap.c
index 6fb206da27298..265464b5d7cc5 100644
--- a/drivers/mfd/motorola-cpcap.c
+++ b/drivers/mfd/motorola-cpcap.c
@@ -202,6 +202,13 @@ static const struct of_device_id cpcap_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, cpcap_of_match);
 
+static const struct spi_device_id cpcap_spi_ids[] = {
+	{ .name = "cpcap", },
+	{ .name = "6556002", },
+	{},
+};
+MODULE_DEVICE_TABLE(spi, cpcap_spi_ids);
+
 static const struct regmap_config cpcap_regmap_config = {
 	.reg_bits = 16,
 	.reg_stride = 4,
@@ -342,6 +349,7 @@ static struct spi_driver cpcap_driver = {
 		.pm = &cpcap_pm,
 	},
 	.probe = cpcap_probe,
+	.id_table = cpcap_spi_ids,
 };
 module_spi_driver(cpcap_driver);
 
-- 
2.33.0



