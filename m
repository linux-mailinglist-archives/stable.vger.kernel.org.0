Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F6C3A8480
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhFOPvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhFOPuw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:50:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D8E46162E;
        Tue, 15 Jun 2021 15:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772128;
        bh=3LWTFrPqZrRejivSLKDXE5jWosmTTHgrAR+hU/+DOrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i85V35cHN64elZY9jq9QJsxmUM2auycXAqmHTaXQyD6yjMpM38pamgSmyHnE809+p
         R4RT0qe+Rf22kzlyJ58KbSEIyV9nIiRF9btWThhlJDM0PC4OXfQZZwlXDwCNB9+BOZ
         jpeiXwgGFfKvZwlij2e+9eq+PyoR0w+qiVaucf5I0nYGEYpqHEwRxAAv1SuNA9JgRT
         uVGdWtDtabHDpC4f/D+htqc7qtHZBONUhICuv2atUo4j7c2QG0itcsERpfePWU6g9C
         QD2DVE3/9j594NwRDYYIDStCZvcliilcrqQi7L+89xNXnJXlAaCZ2eAZgP3SkugWWN
         xOqsTz4CsvCPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 19/33] regulator: rt4801: Fix NULL pointer dereference if priv->enable_gpios is NULL
Date:   Tue, 15 Jun 2021 11:48:10 -0400
Message-Id: <20210615154824.62044-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

