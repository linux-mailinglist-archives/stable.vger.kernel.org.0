Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A09657C8A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbiL1Pdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbiL1Pde (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:33:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237A41649A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:33:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF9ABB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356FAC433F0;
        Wed, 28 Dec 2022 15:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241610;
        bh=7OqLrE8VqfaKw/7UH8Ppl+h4W6SzmKut1joDfri5VkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUC0ooNmVT5zC7loX2fTsTsZUJrwX8/cP8A08vgrs6gF7nEQEXOBlgsXYv00skynF
         l/w8H7sFkDyq/sPOqH7YPaXbZXKp8/59cA+0RHeNsCPaKzmL1GEhiHc8fVP11euAh7
         wTh97bEdJLNVIn9rG5KfqscmItGRqeiSq/m042Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yassine Oudjana <y.oudjana@protonmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0304/1073] regmap-irq: Use the new num_config_regs property in regmap_add_irq_chip_fwnode
Date:   Wed, 28 Dec 2022 15:31:32 +0100
Message-Id: <20221228144336.268373551@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yassine Oudjana <y.oudjana@protonmail.com>

[ Upstream commit 84498d1fb35de6ab71bdfdb6270a464fb4a0951b ]

Commit faa87ce9196d ("regmap-irq: Introduce config registers for irq
types") added the num_config_regs, then commit 9edd4f5aee84 ("regmap-irq:
Deprecate type registers and virtual registers") suggested to replace
num_type_reg with it. However, regmap_add_irq_chip_fwnode wasn't modified
to use the new property. Later on, commit 255a03bb1bb3 ("ASoC: wcd9335:
Convert irq chip to config regs") removed the old num_type_reg property
from the WCD9335 driver's struct regmap_irq_chip, causing a null pointer
dereference in regmap_irq_set_type when it tried to index d->type_buf as
it was never allocated in regmap_add_irq_chip_fwnode:

[   39.199374] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000

[   39.200006] Call trace:
[   39.200014]  regmap_irq_set_type+0x84/0x1c0
[   39.200026]  __irq_set_trigger+0x60/0x1c0
[   39.200040]  __setup_irq+0x2f4/0x78c
[   39.200051]  request_threaded_irq+0xe8/0x1a0

Use num_config_regs in regmap_add_irq_chip_fwnode instead of num_type_reg,
and fall back to it if num_config_regs isn't defined to maintain backward
compatibility.

Fixes: faa87ce9196d ("regmap-irq: Introduce config registers for irq types")
Signed-off-by: Yassine Oudjana <y.oudjana@protonmail.com>
Link: https://lore.kernel.org/r/20221107202114.823975-1-y.oudjana@protonmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-irq.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 4ef9488d05cd..3de89795f584 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -722,6 +722,7 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 	int i;
 	int ret = -ENOMEM;
 	int num_type_reg;
+	int num_regs;
 	u32 reg;
 
 	if (chip->num_regs <= 0)
@@ -796,14 +797,20 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 			goto err_alloc;
 	}
 
-	num_type_reg = chip->type_in_mask ? chip->num_regs : chip->num_type_reg;
-	if (num_type_reg) {
-		d->type_buf_def = kcalloc(num_type_reg,
+	/*
+	 * Use num_config_regs if defined, otherwise fall back to num_type_reg
+	 * to maintain backward compatibility.
+	 */
+	num_type_reg = chip->num_config_regs ? chip->num_config_regs
+			: chip->num_type_reg;
+	num_regs = chip->type_in_mask ? chip->num_regs : num_type_reg;
+	if (num_regs) {
+		d->type_buf_def = kcalloc(num_regs,
 					  sizeof(*d->type_buf_def), GFP_KERNEL);
 		if (!d->type_buf_def)
 			goto err_alloc;
 
-		d->type_buf = kcalloc(num_type_reg, sizeof(*d->type_buf),
+		d->type_buf = kcalloc(num_regs, sizeof(*d->type_buf),
 				      GFP_KERNEL);
 		if (!d->type_buf)
 			goto err_alloc;
-- 
2.35.1



