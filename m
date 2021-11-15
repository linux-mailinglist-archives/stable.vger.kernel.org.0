Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A017451EE8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355423AbhKPAh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344651AbhKOTZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 791A6636AD;
        Mon, 15 Nov 2021 19:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002899;
        bh=9hKHflMQr9m/2690S4jwcKZdUKjuHvoNqW8AlOYk21Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnZpKSWnRY7Gnh2qp0UVbEYcPy7kfwtQ7//vTeOFAfsr3OAbWyGwcXemVupLYgUwy
         4SQ1NLoYScpgkMbW6x0Cb3+cfSezFZkkLwOzRFe1fOWKYxpsKEwrAygq0BQVn/ubtv
         zDELf5EqYaauqH8jzCxmeL5+80dgJiT+0KTQ+9JY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 704/917] Input: ariel-pwrbutton - add SPI device ID table
Date:   Mon, 15 Nov 2021 18:03:19 +0100
Message-Id: <20211115165452.762148964@linuxfoundation.org>
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

[ Upstream commit 5c4c2c8e6fac26fa0b80c234d6e9f75d637193af ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding a SPI device ID table.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210927134104.38648-1-broonie@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/ariel-pwrbutton.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/misc/ariel-pwrbutton.c b/drivers/input/misc/ariel-pwrbutton.c
index 17bbaac8b80c8..cdc80715b5fd6 100644
--- a/drivers/input/misc/ariel-pwrbutton.c
+++ b/drivers/input/misc/ariel-pwrbutton.c
@@ -149,12 +149,19 @@ static const struct of_device_id ariel_pwrbutton_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ariel_pwrbutton_of_match);
 
+static const struct spi_device_id ariel_pwrbutton_spi_ids[] = {
+	{ .name = "wyse-ariel-ec-input" },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, ariel_pwrbutton_spi_ids);
+
 static struct spi_driver ariel_pwrbutton_driver = {
 	.driver = {
 		.name = "dell-wyse-ariel-ec-input",
 		.of_match_table = ariel_pwrbutton_of_match,
 	},
 	.probe = ariel_pwrbutton_probe,
+	.id_table = ariel_pwrbutton_spi_ids,
 };
 module_spi_driver(ariel_pwrbutton_driver);
 
-- 
2.33.0



