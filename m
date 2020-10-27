Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC5529B435
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784602AbgJ0O7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784585AbgJ0O7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:59:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 615D520714;
        Tue, 27 Oct 2020 14:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810756;
        bh=CZGrA1IfK0TadZ9bTfmryHnGI1j7nqYWh/K5qz9Cmdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0oBrBQOUJz079b6heoflM/gKyoJysOpXq/sukmFtyKPRBm1JXv9FbXhnNoAaItXj
         98j2i/kiHloV64AYBC1zOLFqZXhDkZfbVK9j27HIP+IiRSo++fG+xoYA2oh3XolzMV
         VkY18U4moqlbBrbuj6E8h5apfqlOpY8fyDrmo3Cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 253/633] ASoC: tas2770: Fix unbalanced calls to pm_runtime
Date:   Tue, 27 Oct 2020 14:49:56 +0100
Message-Id: <20201027135534.535154925@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit d3d71c99b541040da198f43da3bbd85d8e9598cb ]

Fix the unbalanced call to the pm_runtime_disable when removing the
module.  pm_runtime_enable is not called nor is the pm_runtime setup in
the code.  Remove the i2c_remove function and the pm_runtime_disable.

Fixes: 1a476abc723e6 ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Link: https://lore.kernel.org/r/20200918190548.12598-5-dmurphy@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 8d88ed5578ddd..531bf32043813 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -16,7 +16,6 @@
 #include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
-#include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <linux/firmware.h>
 #include <linux/regmap.h>
@@ -780,13 +779,6 @@ static int tas2770_i2c_probe(struct i2c_client *client,
 	return result;
 }
 
-static int tas2770_i2c_remove(struct i2c_client *client)
-{
-	pm_runtime_disable(&client->dev);
-	return 0;
-}
-
-
 static const struct i2c_device_id tas2770_i2c_id[] = {
 	{ "tas2770", 0},
 	{ }
@@ -807,7 +799,6 @@ static struct i2c_driver tas2770_i2c_driver = {
 		.of_match_table = of_match_ptr(tas2770_of_match),
 	},
 	.probe      = tas2770_i2c_probe,
-	.remove     = tas2770_i2c_remove,
 	.id_table   = tas2770_i2c_id,
 };
 
-- 
2.25.1



