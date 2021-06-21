Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1760C3AF013
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhFUQqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232893AbhFUQnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:43:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07EF861380;
        Mon, 21 Jun 2021 16:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293108;
        bh=3LWTFrPqZrRejivSLKDXE5jWosmTTHgrAR+hU/+DOrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9b67TdKZTu+9EZrZPV1DRM0Kh5q6O7n0MXQQFURLwmIh2ZwTxMOrrtNJiBARLoeD
         nzUGYeTNxysyYhmfg7sbLB69JIFlpHIyYeVRAjh9Jl0FhPROs8HkAYMAzMLBlyZULp
         D1m1dPaFsijDIxuvU5NJtrxFLNTGFb4CMeiOXtJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 102/178] regulator: rt4801: Fix NULL pointer dereference if priv->enable_gpios is NULL
Date:   Mon, 21 Jun 2021 18:15:16 +0200
Message-Id: <20210621154926.257098564@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
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



