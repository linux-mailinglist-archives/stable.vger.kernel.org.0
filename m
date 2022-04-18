Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FF9504FD5
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbiDRMSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238123AbiDRMSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:18:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA16E0F4;
        Mon, 18 Apr 2022 05:15:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79A7860F09;
        Mon, 18 Apr 2022 12:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD09C385A1;
        Mon, 18 Apr 2022 12:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284119;
        bh=2dPRE+Zv1VmQOig1vPhXOzPvKQh29twZf5djrYUW3kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9xERDq3C+VjCBsfECAwLp0DAPfb+G15wPuxApsxFA9CBu+OiYhJYpRglttWCvWoT
         oRv8eqZldCvBxpHAOeJTkpdBwtxOO0hT4OwSsV2pLvwn82IdLikXBMXctF/C7o9GLV
         iSrgOKtVzsujmqVHB/s5cEznv1Y5EaCb/BZxicc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.17 005/219] net: dsa: realtek: allow subdrivers to externally lock regmap
Date:   Mon, 18 Apr 2022 14:09:34 +0200
Message-Id: <20220418121203.623778576@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

commit 907e772f6f6debb610ea28298ab57b31019a4edb upstream.

Currently there is no way for Realtek DSA subdrivers to serialize
consecutive regmap accesses. In preparation for a bugfix relating to
indirect PHY register access - which involves a series of regmap
reads and writes - add a facility for subdrivers to serialize their
regmap access.

Specifically, a mutex is added to the driver private data structure and
the standard regmap is initialized with custom lock/unlock ops which use
this mutex. Then, a "nolock" variant of the regmap is added, which is
functionally equivalent to the existing regmap except that regmap
locking is disabled. Functions that wish to serialize a sequence of
regmap accesses may then lock the newly introduced driver-owned mutex
before using the nolock regmap.

Doing things this way means that subdriver code that doesn't care about
serialized register access - i.e. the vast majority of code - needn't
worry about synchronizing register access with an external lock: it can
just continue to use the original regmap.

Another advantage of this design is that, while regmaps with locking
disabled do not expose a debugfs interface for obvious reasons, there
still exists the original regmap which does expose this interface. This
interface remains safe to use even combined with driver codepaths that
use the nolock regmap, because said codepaths will use the same mutex
to synchronize access.

With respect to disadvantages, it can be argued that having
near-duplicate regmaps is confusing. However, the naming is rather
explicit, and examples will abound.

Finally, while we are at it, rename realtek_smi_mdio_regmap_config to
realtek_smi_regmap_config. This makes it consistent with the naming
realtek_mdio_regmap_config in realtek-mdio.c.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[alsi: backport to 5.16: s/priv/smi/g and remove realtek-mdio changes]
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/realtek/realtek-smi-core.c |   48 +++++++++++++++++++++++++++--
 drivers/net/dsa/realtek/realtek-smi-core.h |    2 +
 2 files changed, 47 insertions(+), 3 deletions(-)

--- a/drivers/net/dsa/realtek/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek/realtek-smi-core.c
@@ -315,7 +315,21 @@ static int realtek_smi_read(void *ctx, u
 	return realtek_smi_read_reg(smi, reg, val);
 }
 
-static const struct regmap_config realtek_smi_mdio_regmap_config = {
+static void realtek_smi_lock(void *ctx)
+{
+	struct realtek_smi *smi = ctx;
+
+	mutex_lock(&smi->map_lock);
+}
+
+static void realtek_smi_unlock(void *ctx)
+{
+	struct realtek_smi *smi = ctx;
+
+	mutex_unlock(&smi->map_lock);
+}
+
+static const struct regmap_config realtek_smi_regmap_config = {
 	.reg_bits = 10, /* A4..A0 R4..R0 */
 	.val_bits = 16,
 	.reg_stride = 1,
@@ -325,6 +339,21 @@ static const struct regmap_config realte
 	.reg_read = realtek_smi_read,
 	.reg_write = realtek_smi_write,
 	.cache_type = REGCACHE_NONE,
+	.lock = realtek_smi_lock,
+	.unlock = realtek_smi_unlock,
+};
+
+static const struct regmap_config realtek_smi_nolock_regmap_config = {
+	.reg_bits = 10, /* A4..A0 R4..R0 */
+	.val_bits = 16,
+	.reg_stride = 1,
+	/* PHY regs are at 0x8000 */
+	.max_register = 0xffff,
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.reg_read = realtek_smi_read,
+	.reg_write = realtek_smi_write,
+	.cache_type = REGCACHE_NONE,
+	.disable_locking = true,
 };
 
 static int realtek_smi_mdio_read(struct mii_bus *bus, int addr, int regnum)
@@ -388,6 +417,7 @@ static int realtek_smi_probe(struct plat
 	const struct realtek_smi_variant *var;
 	struct device *dev = &pdev->dev;
 	struct realtek_smi *smi;
+	struct regmap_config rc;
 	struct device_node *np;
 	int ret;
 
@@ -398,13 +428,25 @@ static int realtek_smi_probe(struct plat
 	if (!smi)
 		return -ENOMEM;
 	smi->chip_data = (void *)smi + sizeof(*smi);
-	smi->map = devm_regmap_init(dev, NULL, smi,
-				    &realtek_smi_mdio_regmap_config);
+
+	mutex_init(&smi->map_lock);
+
+	rc = realtek_smi_regmap_config;
+	rc.lock_arg = smi;
+	smi->map = devm_regmap_init(dev, NULL, smi, &rc);
 	if (IS_ERR(smi->map)) {
 		ret = PTR_ERR(smi->map);
 		dev_err(dev, "regmap init failed: %d\n", ret);
 		return ret;
 	}
+
+	rc = realtek_smi_nolock_regmap_config;
+	smi->map_nolock = devm_regmap_init(dev, NULL, smi, &rc);
+	if (IS_ERR(smi->map_nolock)) {
+		ret = PTR_ERR(smi->map_nolock);
+		dev_err(dev, "regmap init failed: %d\n", ret);
+		return ret;
+	}
 
 	/* Link forward and backward */
 	smi->dev = dev;
--- a/drivers/net/dsa/realtek/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek/realtek-smi-core.h
@@ -49,6 +49,8 @@ struct realtek_smi {
 	struct gpio_desc	*mdc;
 	struct gpio_desc	*mdio;
 	struct regmap		*map;
+	struct regmap		*map_nolock;
+	struct mutex		map_lock;
 	struct mii_bus		*slave_mii_bus;
 
 	unsigned int		clk_delay;


