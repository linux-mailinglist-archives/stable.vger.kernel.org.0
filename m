Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B3A451F02
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348295AbhKPAiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344556AbhKOTY6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 474C16369C;
        Mon, 15 Nov 2021 18:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002793;
        bh=Ot/PbKU1wjgsFOEOP++5SBFvEwNyesLSNiPzGCMTZNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTB+AQGQoHHyr2NCtm//IF6Qj1wtbz7sokp7foQvDt9rHGYxiuwUeYI+UNta/eaCv
         c3pRN0XAyF7Da1lRGh3WdUsF7UkwcglXYSUuDGazYgY4McK/0975CtB6AxESABdCxK
         tKsMFm94qONH/f9LODo6CIt5tkeRm8aCtRDHbiGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 698/917] rtc: ds1390: Add SPI ID table
Date:   Mon, 15 Nov 2021 18:03:13 +0100
Message-Id: <20211115165452.557067243@linuxfoundation.org>
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

[ Upstream commit da87639d6312afb8855717c791768bf2d4ca8ac8 ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding an id_table listing the
SPI IDs for everything.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210923194922.53386-3-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1390.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index 66fc8617d07ee..93ce72b9ae59e 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -219,12 +219,19 @@ static const struct of_device_id ds1390_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ds1390_of_match);
 
+static const struct spi_device_id ds1390_spi_ids[] = {
+	{ .name = "ds1390" },
+	{}
+};
+MODULE_DEVICE_TABLE(spi, ds1390_spi_ids);
+
 static struct spi_driver ds1390_driver = {
 	.driver = {
 		.name	= "rtc-ds1390",
 		.of_match_table = of_match_ptr(ds1390_of_match),
 	},
 	.probe	= ds1390_probe,
+	.id_table = ds1390_spi_ids,
 };
 
 module_spi_driver(ds1390_driver);
-- 
2.33.0



