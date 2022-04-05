Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CADD4F44E8
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380992AbiDEMYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345280AbiDEKk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:40:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBBAD93;
        Tue,  5 Apr 2022 03:26:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DBDBB81B18;
        Tue,  5 Apr 2022 10:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52090C385A0;
        Tue,  5 Apr 2022 10:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154382;
        bh=/Y0R8KyqaUA4NN0p4BSOO0086I2pd6URMR88meKY2Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTnR/Y/K6KJmAEn9XcDJ7pfZR28fh1T54NjD8B8T64DngxVC07w5r4vuNYVlfpHmb
         qLZf8othqMVJtSNac/PsodgDnqP0WY/R9g1gbrABGORCpa2wt/7mVviwOZDc7nZh3l
         QpHnbTNdFSVXyo6M6ZD1JE1CSM2mOKsZIewqworE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacky Bai <ping.bai@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Robin Gong <yibin.gong@nxp.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH 5.10 557/599] mailbox: imx: fix wakeup failure from freeze mode
Date:   Tue,  5 Apr 2022 09:34:11 +0200
Message-Id: <20220405070315.416940927@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Robin Gong <yibin.gong@nxp.com>

commit 892cb524ae8a27bf5e42f711318371acd9a9f74a upstream.

Since IRQF_NO_SUSPEND used for imx mailbox driver, that means this irq
can't be used for wakeup source so that can't wakeup from freeze mode.
Add pm_system_wakeup() to wakeup from freeze mode.

Fixes: b7b2796b9b31e("mailbox: imx: ONLY IPC MU needs IRQF_NO_SUSPEND flag")
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/imx-mailbox.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/suspend.h>
 #include <linux/slab.h>
 
 #define IMX_MU_xSR_GIPn(x)	BIT(28 + (3 - (x)))
@@ -66,6 +67,7 @@ struct imx_mu_priv {
 	const struct imx_mu_dcfg	*dcfg;
 	struct clk		*clk;
 	int			irq;
+	bool			suspend;
 
 	u32 xcr;
 
@@ -277,6 +279,9 @@ static irqreturn_t imx_mu_isr(int irq, v
 		return IRQ_NONE;
 	}
 
+	if (priv->suspend)
+		pm_system_wakeup();
+
 	return IRQ_HANDLED;
 }
 
@@ -326,6 +331,8 @@ static int imx_mu_startup(struct mbox_ch
 		break;
 	}
 
+	priv->suspend = true;
+
 	return 0;
 }
 
@@ -543,6 +550,8 @@ static int imx_mu_probe(struct platform_
 
 	clk_disable_unprepare(priv->clk);
 
+	priv->suspend = false;
+
 	return 0;
 
 disable_runtime_pm:


