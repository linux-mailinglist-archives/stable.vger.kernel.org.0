Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628D03AEF02
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhFUQf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:35:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230283AbhFUQcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 174DD61357;
        Mon, 21 Jun 2021 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292759;
        bh=3LWTFrPqZrRejivSLKDXE5jWosmTTHgrAR+hU/+DOrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nd8J4qP6dA7ieFYwUkhEqBpbQ8qsKorCTIwDZx4Lgu6fZ7qzLSLlePW1ro5Sm40QD
         I6akCRl0iUtv1aNNB+lRnOmwHnyo84EDsEaVYMQK73K18e/Nd0XD+BK7NWPt100lph
         vYukfi4wyG4mZRgGY0AhUXMecQNfgQU8i4r9X8Zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/146] regulator: rt4801: Fix NULL pointer dereference if priv->enable_gpios is NULL
Date:   Mon, 21 Jun 2021 18:15:16 +0200
Message-Id: <20210621154916.534198584@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit cb2381cbecb81a8893b2d1e1af29bc2e5531df27 ]

devm_gpiod_get_array_optional may return NULL if no GPIO was assigned.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210603094944.1114156-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rt4801-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/rt4801-regulator.c b/drivers/regulator/rt4801-regulator.c
index 2055a9cb13ba..7a87788d3f09 100644
--- a/drivers/regulator/rt4801-regulator.c
+++ b/drivers/regulator/rt4801-regulator.c
@@ -66,7 +66,7 @@ static int rt4801_enable(struct regulator_dev *rdev)
 	struct gpio_descs *gpios = priv->enable_gpios;
 	int id = rdev_get_id(rdev), ret;
 
-	if (gpios->ndescs <= id) {
+	if (!gpios || gpios->ndescs <= id) {
 		dev_warn(&rdev->dev, "no dedicated gpio can control\n");
 		goto bypass_gpio;
 	}
@@ -88,7 +88,7 @@ static int rt4801_disable(struct regulator_dev *rdev)
 	struct gpio_descs *gpios = priv->enable_gpios;
 	int id = rdev_get_id(rdev);
 
-	if (gpios->ndescs <= id) {
+	if (!gpios || gpios->ndescs <= id) {
 		dev_warn(&rdev->dev, "no dedicated gpio can control\n");
 		goto bypass_gpio;
 	}
-- 
2.30.2



