Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F463A84C6
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhFOPwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232131AbhFOPve (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E43E461626;
        Tue, 15 Jun 2021 15:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772169;
        bh=3LWTFrPqZrRejivSLKDXE5jWosmTTHgrAR+hU/+DOrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmNdZinRWIrfZsWZRciY0vADG5Ux+a2LnUYeaf8GMt9NTf5KbUYHFM6mm0XCBl+ch
         nVKkuQCWJhQSA+Ddz7ANxC5BbnMVzNnKzxeekKEZwBnEMKKlFy31q5SB228Nqgd5lO
         3vRHn6+RzAvtOXQ0kGauV6bD7Aro+nH98KoWQtoLxiUVnYo3CILthpeQDZfbwDtJhY
         cm6Nc3o6peXeL1eJzZXH6hGCCJ/qVOn6yhwpO2WvJUALXffB/mniA8lrN1JBgYXTPs
         1jVTGuoCii0oze9LlNoDGm4XIrSvgX7kq1QwGuszFVeFWNlXDYOS6c97JWZIL0mq+Z
         4w5lnhqIWO3kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 17/30] regulator: rt4801: Fix NULL pointer dereference if priv->enable_gpios is NULL
Date:   Tue, 15 Jun 2021 11:48:54 -0400
Message-Id: <20210615154908.62388-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
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

