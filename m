Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446203E5CF6
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242491AbhHJOQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242483AbhHJOQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 566C561077;
        Tue, 10 Aug 2021 14:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604943;
        bh=jsXSwu3e2W5/Bbh8Ni7wMfk8kDl0v6oLmGXB/izskHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdhgbEUHY8tIM4QexD8b4xwl4rEYgaCOjowORp4+KwEyUxd9EQmjP02YJCSqyIcY0
         kWFFFiNHKKeKxrmQeLd3IbRGnk2M/aJ+Smmu3g0sXIXyjOWpyzWSC+DSDQjhfaznfM
         k4L6+J1MDs2ztjDGnMTeNmwx5gmo7YTeCS9c0wQUKsiQdTID20G1J6D+rAP3Owg0zV
         rPJ/NonlQUCDG7GZyefspwQxef4Nrmyl+Uer2TUUz7VHOQQ9nw+eAX8JEMlCu25Zlu
         DG1Jb9pru9fVPh5Wxm2HRiM/GoycLTwFxrI04Ca9Z309tt5rpyCHRAPxJh7TvOPTvM
         v+Cwp8zTXOHIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/20] spi: spi-mux: Add module info needed for autoloading
Date:   Tue, 10 Aug 2021 10:15:21 -0400
Message-Id: <20210810141538.3117707-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141538.3117707-1-sashal@kernel.org>
References: <20210810141538.3117707-1-sashal@kernel.org>
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

