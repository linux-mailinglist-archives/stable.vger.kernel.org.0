Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD802BA873
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgKTLH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbgKTLHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D28D7206E3;
        Fri, 20 Nov 2020 11:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870473;
        bh=+R9mbpPh7h148JHzELe0UuzUPeX5lF+ArRayE6tiq0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edJQKoV1m1MWGsJU3Mwtk72+q3H1X4MZ9GPA42M7wBd/FV2j7xcO0F348Cj3ACJMK
         ElSOPZ2d9A/mPGQs7CHyAF+BbiZ0ortA2nAlHMdf+d9+KsT8H+X7rRx7Rq+NSz5q/D
         1vtwOACPLsGlMNJl2xEdmbSYe1VtGKKtT6jjRm8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel David <ultracoolguy@tutanota.com>,
        Pavel Machek <pavel@ucw.cz>, stable@kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.9 06/14] leds: lm3697: Fix out-of-bound access
Date:   Fri, 20 Nov 2020 12:03:44 +0100
Message-Id: <20201120104541.482562040@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel David <ultracoolguy@tutanota.com>

commit 98d278ca00bd8f62c8bc98bd9e65372d16eb6956 upstream

If both LED banks aren't used in device tree, an out-of-bounds
condition in lm3697_init occurs because of the for loop assuming that
all the banks are used.  Fix it by adding a variable that contains the
number of used banks.

Signed-off-by: Gabriel David <ultracoolguy@tutanota.com>
[removed extra rename, minor tweaks]
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: stable@kernel.org
[sudip: use client->dev]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lm3697.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/leds/leds-lm3697.c
+++ b/drivers/leds/leds-lm3697.c
@@ -78,6 +78,7 @@ struct lm3697 {
 	struct mutex lock;
 
 	int bank_cfg;
+	int num_banks;
 
 	struct lm3697_led leds[];
 };
@@ -180,7 +181,7 @@ static int lm3697_init(struct lm3697 *pr
 	if (ret)
 		dev_err(&priv->client->dev, "Cannot write OUTPUT config\n");
 
-	for (i = 0; i < LM3697_MAX_CONTROL_BANKS; i++) {
+	for (i = 0; i < priv->num_banks; i++) {
 		led = &priv->leds[i];
 		ret = ti_lmu_common_set_ramp(&led->lmu_data);
 		if (ret)
@@ -307,8 +308,8 @@ static int lm3697_probe(struct i2c_clien
 	int ret;
 
 	count = device_get_child_node_count(&client->dev);
-	if (!count) {
-		dev_err(&client->dev, "LEDs are not defined in device tree!");
+	if (!count || count > LM3697_MAX_CONTROL_BANKS) {
+		dev_err(&client->dev, "Strange device tree!");
 		return -ENODEV;
 	}
 
@@ -322,6 +323,7 @@ static int lm3697_probe(struct i2c_clien
 
 	led->client = client;
 	led->dev = &client->dev;
+	led->num_banks = count;
 	led->regmap = devm_regmap_init_i2c(client, &lm3697_regmap_config);
 	if (IS_ERR(led->regmap)) {
 		ret = PTR_ERR(led->regmap);


