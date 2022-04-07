Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35B04F70EA
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbiDGBXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240523AbiDGBUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:20:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C622A14B000;
        Wed,  6 Apr 2022 18:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AAD4B81E7F;
        Thu,  7 Apr 2022 01:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C838C385A3;
        Thu,  7 Apr 2022 01:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294280;
        bh=HRk57lP6sF9mILCmLjJQ6o2/9oKk/pnufB31Sf1vFA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RneknGu6n9Sy3zDHZwB0+H7M0lB7KMSd1SCxEYVIhtovHafn9P2DkrStIuGGjDvK8
         igDRCIj/IKgGkhjJpS5jRgR53Yvir/8do5WmZmfB+W82nIlFq7xcUDLdBh0y3luw5O
         lW/8mOgVcidoPDRoO0XebYcn7tbwKvNKghTV4kruFL210zV1D+gdGxydF7YLRIKzow
         qhuI3T2NR3wYOsrXgRay8Ew0CYbERFwViiZUu2yJ7iV/4njN9hI4gBiN/W4+zIQTZh
         uiA9IaIY7N0QA9tZS5x6HRwOhZ1KrbAozaYm36sjzTlnDwmUAfeEuCTYL7oQv2RM0V
         dzkoMZ/FcQV/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        wangborong@cdjrlc.com, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/7] MIPS: lantiq: check the return value of kzalloc()
Date:   Wed,  6 Apr 2022 21:17:38 -0400
Message-Id: <20220407011740.115717-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011740.115717-1-sashal@kernel.org>
References: <20220407011740.115717-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit 34123208bbcc8c884a0489f543a23fe9eebb5514 ]

kzalloc() is a memory allocation function which can return NULL when
some internal memory errors happen. So it is better to check the
return value of it to prevent potential wrong memory access or
memory leak.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/falcon/sysctrl.c |  2 ++
 arch/mips/lantiq/xway/gptu.c      |  2 ++
 arch/mips/lantiq/xway/sysctrl.c   | 46 ++++++++++++++++++++-----------
 3 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/arch/mips/lantiq/falcon/sysctrl.c b/arch/mips/lantiq/falcon/sysctrl.c
index 82bbd0e2e298..714d92659489 100644
--- a/arch/mips/lantiq/falcon/sysctrl.c
+++ b/arch/mips/lantiq/falcon/sysctrl.c
@@ -169,6 +169,8 @@ static inline void clkdev_add_sys(const char *dev, unsigned int module,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev;
 	clk->cl.con_id = NULL;
 	clk->cl.clk = clk;
diff --git a/arch/mips/lantiq/xway/gptu.c b/arch/mips/lantiq/xway/gptu.c
index 0f1bbea1a816..955d0d5cfbdb 100644
--- a/arch/mips/lantiq/xway/gptu.c
+++ b/arch/mips/lantiq/xway/gptu.c
@@ -124,6 +124,8 @@ static inline void clkdev_add_gptu(struct device *dev, const char *con,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev_name(dev);
 	clk->cl.con_id = con;
 	clk->cl.clk = clk;
diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index 95bec460b651..dd7c36a193e3 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -331,6 +331,8 @@ static void clkdev_add_pmu(const char *dev, const char *con, bool deactivate,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev;
 	clk->cl.con_id = con;
 	clk->cl.clk = clk;
@@ -354,6 +356,8 @@ static void clkdev_add_cgu(const char *dev, const char *con,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev;
 	clk->cl.con_id = con;
 	clk->cl.clk = clk;
@@ -372,24 +376,28 @@ static void clkdev_add_pci(void)
 	struct clk *clk_ext = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
 	/* main pci clock */
-	clk->cl.dev_id = "17000000.pci";
-	clk->cl.con_id = NULL;
-	clk->cl.clk = clk;
-	clk->rate = CLOCK_33M;
-	clk->rates = valid_pci_rates;
-	clk->enable = pci_enable;
-	clk->disable = pmu_disable;
-	clk->module = 0;
-	clk->bits = PMU_PCI;
-	clkdev_add(&clk->cl);
+	if (clk) {
+		clk->cl.dev_id = "17000000.pci";
+		clk->cl.con_id = NULL;
+		clk->cl.clk = clk;
+		clk->rate = CLOCK_33M;
+		clk->rates = valid_pci_rates;
+		clk->enable = pci_enable;
+		clk->disable = pmu_disable;
+		clk->module = 0;
+		clk->bits = PMU_PCI;
+		clkdev_add(&clk->cl);
+	}
 
 	/* use internal/external bus clock */
-	clk_ext->cl.dev_id = "17000000.pci";
-	clk_ext->cl.con_id = "external";
-	clk_ext->cl.clk = clk_ext;
-	clk_ext->enable = pci_ext_enable;
-	clk_ext->disable = pci_ext_disable;
-	clkdev_add(&clk_ext->cl);
+	if (clk_ext) {
+		clk_ext->cl.dev_id = "17000000.pci";
+		clk_ext->cl.con_id = "external";
+		clk_ext->cl.clk = clk_ext;
+		clk_ext->enable = pci_ext_enable;
+		clk_ext->disable = pci_ext_disable;
+		clkdev_add(&clk_ext->cl);
+	}
 }
 
 /* xway socs can generate clocks on gpio pins */
@@ -409,9 +417,15 @@ static void clkdev_add_clkout(void)
 		char *name;
 
 		name = kzalloc(sizeof("clkout0"), GFP_KERNEL);
+		if (!name)
+			continue;
 		sprintf(name, "clkout%d", i);
 
 		clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
+		if (!clk) {
+			kfree(name);
+			continue;
+		}
 		clk->cl.dev_id = "1f103000.cgu";
 		clk->cl.con_id = name;
 		clk->cl.clk = clk;
-- 
2.35.1

