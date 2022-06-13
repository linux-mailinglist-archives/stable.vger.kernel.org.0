Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1387548CA7
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381788AbiFMOQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382133AbiFMONG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:13:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67C39A9B6;
        Mon, 13 Jun 2022 04:42:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 415986124E;
        Mon, 13 Jun 2022 11:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D49C34114;
        Mon, 13 Jun 2022 11:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120532;
        bh=ZGGFBQ/7BqbYRuy9xYNskjJI5yvJ09M/XZftnlvYtvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N19sdZ+Cny1nqvVf3pfa0CUOpEn4US4Xd2tHbsaZR3An0uKAcgVLT1RPL+RxgaMt1
         4aRyjEK2TH7dfMCH5y6G7u7PdMPbjLluuhSmETI/gATa3qyrRpvmKjIivWVGLeK2Fk
         LlJhyVO/pUx3MHFeWTU6mtrf5raXsbC2zpfysWRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 043/298] watchdog: rzg2l_wdt: Fix BUG: Invalid wait context
Date:   Mon, 13 Jun 2022 12:08:57 +0200
Message-Id: <20220613094926.249999561@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit e4cf89596c1f1e33309556699f910ced4abbaf44 ]

This patch fixes the issue 'BUG: Invalid wait context' during restart()
callback by using clk_prepare_enable() instead of pm_runtime_get_sync()
for turning on the clocks during restart.

This issue is noticed when testing with renesas_defconfig.

[   42.213802] reboot: Restarting system
[   42.217860]
[   42.219364] =============================
[   42.223368] [ BUG: Invalid wait context ]
[   42.227372] 5.17.0-rc5-arm64-renesas-00002-g10393723e35e #522 Not tainted
[   42.234153] -----------------------------
[   42.238155] systemd-shutdow/1 is trying to lock:
[   42.242766] ffff00000a650828 (&genpd->mlock){+.+.}-{3:3}, at: genpd_lock_mtx+0x14/0x20
[   42.250709] other info that might help us debug this:
[   42.255753] context-{4:4}
[   42.258368] 2 locks held by systemd-shutdow/1:
[   42.262806]  #0: ffff80000944e1c8 (system_transition_mutex#2){+.+.}-{3:3}, at: __do_sys_reboot+0xd0/0x250
[   42.272388]  #1: ffff8000094c4e40 (rcu_read_lock){....}-{1:2}, at: atomic_notifier_call_chain+0x0/0x150
[   42.281795] stack backtrace:
[   42.284672] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 5.17.0-rc5-arm64-renesas-00002-g10393723e35e #522
[   42.294577] Hardware name: Renesas SMARC EVK based on r9a07g044c2 (DT)
[   42.301096] Call trace:
[   42.303538]  dump_backtrace+0xcc/0xd8
[   42.307203]  show_stack+0x14/0x30
[   42.310517]  dump_stack_lvl+0x88/0xb0
[   42.314180]  dump_stack+0x14/0x2c
[   42.317492]  __lock_acquire+0x1b24/0x1b50
[   42.321502]  lock_acquire+0x120/0x3a8
[   42.325162]  __mutex_lock+0x84/0x8f8
[   42.328737]  mutex_lock_nested+0x30/0x58
[   42.332658]  genpd_lock_mtx+0x14/0x20
[   42.336319]  genpd_runtime_resume+0xc4/0x228
[   42.340587]  __rpm_callback+0x44/0x170
[   42.344337]  rpm_callback+0x64/0x70
[   42.347824]  rpm_resume+0x4e0/0x6b8
[   42.351310]  __pm_runtime_resume+0x50/0x78
[   42.355404]  rzg2l_wdt_restart+0x28/0x68
[   42.359329]  watchdog_restart_notifier+0x1c/0x30
[   42.363943]  atomic_notifier_call_chain+0x94/0x150
[   42.368732]  do_kernel_restart+0x24/0x30
[   42.372652]  machine_restart+0x44/0x70
[   42.376399]  kernel_restart+0x3c/0x60
[   42.380058]  __do_sys_reboot+0x228/0x250
[   42.383977]  __arm64_sys_reboot+0x20/0x28
[   42.387983]  invoke_syscall+0x40/0xf8

Fixes: 2cbc5cd0b55fa2 ("watchdog: Add Watchdog Timer driver for RZ/G2L")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220225175320.11041-4-biju.das.jz@bp.renesas.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rzg2l_wdt.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/rzg2l_wdt.c b/drivers/watchdog/rzg2l_wdt.c
index 0fc73b8a9567..48dfe6e5e64f 100644
--- a/drivers/watchdog/rzg2l_wdt.c
+++ b/drivers/watchdog/rzg2l_wdt.c
@@ -43,6 +43,8 @@ struct rzg2l_wdt_priv {
 	struct reset_control *rstc;
 	unsigned long osc_clk_rate;
 	unsigned long delay;
+	struct clk *pclk;
+	struct clk *osc_clk;
 };
 
 static void rzg2l_wdt_wait_delay(struct rzg2l_wdt_priv *priv)
@@ -118,7 +120,9 @@ static int rzg2l_wdt_restart(struct watchdog_device *wdev,
 
 	/* Reset the module before we modify any register */
 	reset_control_reset(priv->rstc);
-	pm_runtime_get_sync(wdev->parent);
+
+	clk_prepare_enable(priv->pclk);
+	clk_prepare_enable(priv->osc_clk);
 
 	/* smallest counter value to reboot soon */
 	rzg2l_wdt_write(priv, WDTSET_COUNTER_VAL(1), WDTSET);
@@ -165,7 +169,6 @@ static int rzg2l_wdt_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct rzg2l_wdt_priv *priv;
 	unsigned long pclk_rate;
-	struct clk *wdt_clk;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -177,22 +180,20 @@ static int rzg2l_wdt_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->base);
 
 	/* Get watchdog main clock */
-	wdt_clk = clk_get(&pdev->dev, "oscclk");
-	if (IS_ERR(wdt_clk))
-		return dev_err_probe(&pdev->dev, PTR_ERR(wdt_clk), "no oscclk");
+	priv->osc_clk = devm_clk_get(&pdev->dev, "oscclk");
+	if (IS_ERR(priv->osc_clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(priv->osc_clk), "no oscclk");
 
-	priv->osc_clk_rate = clk_get_rate(wdt_clk);
-	clk_put(wdt_clk);
+	priv->osc_clk_rate = clk_get_rate(priv->osc_clk);
 	if (!priv->osc_clk_rate)
 		return dev_err_probe(&pdev->dev, -EINVAL, "oscclk rate is 0");
 
 	/* Get Peripheral clock */
-	wdt_clk = clk_get(&pdev->dev, "pclk");
-	if (IS_ERR(wdt_clk))
-		return dev_err_probe(&pdev->dev, PTR_ERR(wdt_clk), "no pclk");
+	priv->pclk = devm_clk_get(&pdev->dev, "pclk");
+	if (IS_ERR(priv->pclk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(priv->pclk), "no pclk");
 
-	pclk_rate = clk_get_rate(wdt_clk);
-	clk_put(wdt_clk);
+	pclk_rate = clk_get_rate(priv->pclk);
 	if (!pclk_rate)
 		return dev_err_probe(&pdev->dev, -EINVAL, "pclk rate is 0");
 
-- 
2.35.1



