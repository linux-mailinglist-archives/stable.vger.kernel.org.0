Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B9B5FB4FA
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiJKOu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiJKOuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF7A62A9A;
        Tue, 11 Oct 2022 07:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39C59611C2;
        Tue, 11 Oct 2022 14:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56F1C433D6;
        Tue, 11 Oct 2022 14:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499822;
        bh=rAXd2onfjOSk4anOXOv14ePB/k3EyDw064ac0HUno90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmk81D1qv01dhmq8xVLCd3y27SXoueFkWDAMl7s8MehhrwfDsR4he0lQhFFifZj95
         sOOOQ0gK6M34WUKNPoT2XcRfJSIQJm8p0MLlsRH8Q0cVpn7a9/w0KlB1Hz+84SATVb
         SI+ck+WgXqptHpLqW3iH5PlBcZ/4LGbZxaDpgQeC86RHJaacJwM6hC/FgPb1Ufk/eQ
         1F6L2MzCmHa8gHN0EChHetlUJuxreyLkFlLRFym8Zkp4Lq2DaQpBJEEH2vGZOVttPr
         Sg7y6Hsn9iTi33/lsn5xb1yZLXUg7J5Wzdyajx8goync7mD/2px8zMMd/OVfbUS8L/
         S13A4KjsW/EuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.de>, kernel test robot <lkp@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chenglin Xu <chenglin.xu@mediatek.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 04/46] soc: mediatek: Let PMIC Wrapper and SCPSYS depend on OF
Date:   Tue, 11 Oct 2022 10:49:32 -0400
Message-Id: <20221011145015.1622882-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit 2778caedb5667239823a29148dfc48b26a8b3c2a ]

With the following configuration options:
CONFIG_OF is not set
CONFIG_MTK_PMIC_WRAP=y
CONFIG_MTK_SCPSYS=y
we get the following build warnings:

  CC      drivers/soc/mediatek/mtk-pmic-wrap.o
drivers/soc/mediatek/mtk-pmic-wrap.c:2138:34: warning: ‘of_pwrap_match_tbl’ defined but not used [-Wunused-const-variable=]
drivers/soc/mediatek/mtk-pmic-wrap.c:1953:34: warning: ‘of_slave_match_tbl’ defined but not used [-Wunused-const-variable=]
  CC      drivers/soc/mediatek/mtk-scpsys.o
drivers/soc/mediatek/mtk-scpsys.c:1084:34: warning: ‘of_scpsys_match_tbl’ defined but not used [-Wunused-const-variable=]

Looking at the code, both drivers can only bind to OF-defined device
nodes, so these drivers are useless without OF and should therefore
depend on it.

Also drop of_match_ptr() from both drivers. We already know what it
will resolve to, so we might as well save cpp some work.

Developers or QA teams who wish to test-build the code can still do
so by enabling CONFIG_OF, which is available on all architectures and
has no dependencies.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/all/202207240252.ZY5hSCNB-lkp@intel.com/
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Chenglin Xu <chenglin.xu@mediatek.com>
Link: https://lore.kernel.org/r/20220730144833.0a0d9825@endymion.delvare
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/Kconfig         | 2 ++
 drivers/soc/mediatek/mtk-pmic-wrap.c | 2 +-
 drivers/soc/mediatek/mtk-scpsys.c    | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/mediatek/Kconfig b/drivers/soc/mediatek/Kconfig
index 3c3eedea35f7..73e63920b1b9 100644
--- a/drivers/soc/mediatek/Kconfig
+++ b/drivers/soc/mediatek/Kconfig
@@ -37,6 +37,7 @@ config MTK_INFRACFG
 config MTK_PMIC_WRAP
 	tristate "MediaTek PMIC Wrapper Support"
 	depends on RESET_CONTROLLER
+	depends on OF
 	select REGMAP
 	help
 	  Say yes here to add support for MediaTek PMIC Wrapper found
@@ -46,6 +47,7 @@ config MTK_PMIC_WRAP
 config MTK_SCPSYS
 	bool "MediaTek SCPSYS Support"
 	default ARCH_MEDIATEK
+	depends on OF
 	select REGMAP
 	select MTK_INFRACFG
 	select PM_GENERIC_DOMAINS if PM
diff --git a/drivers/soc/mediatek/mtk-pmic-wrap.c b/drivers/soc/mediatek/mtk-pmic-wrap.c
index d8cb0f833645..eb82ae06697f 100644
--- a/drivers/soc/mediatek/mtk-pmic-wrap.c
+++ b/drivers/soc/mediatek/mtk-pmic-wrap.c
@@ -2316,7 +2316,7 @@ static int pwrap_probe(struct platform_device *pdev)
 static struct platform_driver pwrap_drv = {
 	.driver = {
 		.name = "mt-pmic-pwrap",
-		.of_match_table = of_match_ptr(of_pwrap_match_tbl),
+		.of_match_table = of_pwrap_match_tbl,
 	},
 	.probe = pwrap_probe,
 };
diff --git a/drivers/soc/mediatek/mtk-scpsys.c b/drivers/soc/mediatek/mtk-scpsys.c
index ca75b14931ec..7a668888111c 100644
--- a/drivers/soc/mediatek/mtk-scpsys.c
+++ b/drivers/soc/mediatek/mtk-scpsys.c
@@ -1141,7 +1141,7 @@ static struct platform_driver scpsys_drv = {
 		.name = "mtk-scpsys",
 		.suppress_bind_attrs = true,
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(of_scpsys_match_tbl),
+		.of_match_table = of_scpsys_match_tbl,
 	},
 };
 builtin_platform_driver(scpsys_drv);
-- 
2.35.1

