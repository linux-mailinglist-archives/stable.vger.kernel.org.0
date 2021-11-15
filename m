Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FEC45145D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348499AbhKOUEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344340AbhKOTYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFE5363662;
        Mon, 15 Nov 2021 18:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002564;
        bh=vygLcSj35JfyuJklnBz3qEqV7FnIr1Mug85ihSC8ewE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwKEiyYLX27AsFeF01RqaUvhpq00S5DAsb9LeRHUZ4Kbv7hJKHemNParFEpmclMTq
         q7RDyRSitITNLl0KdO0diCHCewp7yLuZ3KgdloK5CfhzAFuRdLjCDPsiP5QFLMLtrt
         JuAKAdCJXTBjNLDbpTd4XAfTidLy6PhXO9NrogXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 615/917] iio: st_pressure_spi: Add missing entries SPI to device ID table
Date:   Mon, 15 Nov 2021 18:01:50 +0100
Message-Id: <20211115165449.647206532@linuxfoundation.org>
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

[ Upstream commit 03748d4e003c9f2ad3cd00e3e46f054dcad6b96d ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding SPI IDs for parts that
only have a compatible listed.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210927134153.12739-1-broonie@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/st_pressure_spi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iio/pressure/st_pressure_spi.c b/drivers/iio/pressure/st_pressure_spi.c
index 5001aae8f00b8..e220cf0b125f1 100644
--- a/drivers/iio/pressure/st_pressure_spi.c
+++ b/drivers/iio/pressure/st_pressure_spi.c
@@ -117,6 +117,10 @@ static const struct spi_device_id st_press_id_table[] = {
 	{ LPS33HW_PRESS_DEV_NAME },
 	{ LPS35HW_PRESS_DEV_NAME },
 	{ LPS22HH_PRESS_DEV_NAME },
+	{ "lps001wp-press" },
+	{ "lps25h-press", },
+	{ "lps331ap-press" },
+	{ "lps22hb-press" },
 	{},
 };
 MODULE_DEVICE_TABLE(spi, st_press_id_table);
-- 
2.33.0



