Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5324F3E5CB3
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242208AbhHJOPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242197AbhHJOPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:15:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3D7660FC4;
        Tue, 10 Aug 2021 14:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604910;
        bh=jsXSwu3e2W5/Bbh8Ni7wMfk8kDl0v6oLmGXB/izskHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N45eox4MhbKinL18XmaWDlgKOLHpqPLw/M4mRrZ3NK2w1OSOotnH6tP062j1XijRs
         HmmeimtqP1+FHrCiH2Y/YmK8Nggb4yfrQ69/rG4zHd7klaEt6uMMp7SkoKKiTOQRkb
         TN8nWaPsIdqiBkkp/nuC6k0KfHFPZIvR5wGKx/wEDuQ5HT3A2vZFiXz9Kq38Usnhi2
         ZRKGlddzk4aaywg8HVAi2UNeSSwTzhWvBUgTeuKxgPZ0YAg8+eAcHWUDSJl9nCh4lo
         9q4+NFpByZSu4q7yrzIBKz9a6qee4J3yO0dBL5Ybud1WFNQjiS6yxLqrZ6YGnThjaa
         on4vo0q6LsZUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 03/24] spi: spi-mux: Add module info needed for autoloading
Date:   Tue, 10 Aug 2021 10:14:44 -0400
Message-Id: <20210810141505.3117318-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141505.3117318-1-sashal@kernel.org>
References: <20210810141505.3117318-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 1d5ccab95f06675a269f4cb223a1e3f6d1ebef42 ]

With the spi device table udev can autoload the spi-mux module in
the presence of an spi-mux device.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20210721095321.2165453-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mux.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-mux.c b/drivers/spi/spi-mux.c
index 37dfc6e82804..9708b7827ff7 100644
--- a/drivers/spi/spi-mux.c
+++ b/drivers/spi/spi-mux.c
@@ -167,10 +167,17 @@ static int spi_mux_probe(struct spi_device *spi)
 	return ret;
 }
 
+static const struct spi_device_id spi_mux_id[] = {
+	{ "spi-mux" },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, spi_mux_id);
+
 static const struct of_device_id spi_mux_of_match[] = {
 	{ .compatible = "spi-mux" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, spi_mux_of_match);
 
 static struct spi_driver spi_mux_driver = {
 	.probe  = spi_mux_probe,
@@ -178,6 +185,7 @@ static struct spi_driver spi_mux_driver = {
 		.name   = "spi-mux",
 		.of_match_table = spi_mux_of_match,
 	},
+	.id_table = spi_mux_id,
 };
 
 module_spi_driver(spi_mux_driver);
-- 
2.30.2

