Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5AF4F39E2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378840AbiDELjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354079AbiDEKL3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:11:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A744DF76;
        Tue,  5 Apr 2022 02:57:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B46256157A;
        Tue,  5 Apr 2022 09:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A0DC385A2;
        Tue,  5 Apr 2022 09:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152625;
        bh=iTXKqvGPA52czy0DyOfskTNfOi5wLMP9Uy+AzJwxCLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftXrOx3l5XUrdwuaS8/2qAovzbhRkh7RKYhqeC4QnbeDfD1LmL4eeUOMcgO9RWx1x
         l4klSUWZOqTW5updEXm4liRLM4RkTYOMNkbBC5KLkptU8JbEjzVxtaWncYKuP1Kte+
         OfJt6jb5LIh87UfhQZTw2mb5xAYkpo7kO7E0zO5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacky Bai <ping.bai@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Robin Gong <yibin.gong@nxp.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH 5.15 844/913] mailbox: imx: fix wakeup failure from freeze mode
Date:   Tue,  5 Apr 2022 09:31:46 +0200
Message-Id: <20220405070405.127669353@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
 
 #define IMX_MU_CHANS		16
@@ -67,6 +68,7 @@ struct imx_mu_priv {
 	const struct imx_mu_dcfg	*dcfg;
 	struct clk		*clk;
 	int			irq;
+	bool			suspend;
 
 	u32 xcr[4];
 
@@ -307,6 +309,9 @@ static irqreturn_t imx_mu_isr(int irq, v
 		return IRQ_NONE;
 	}
 
+	if (priv->suspend)
+		pm_system_wakeup();
+
 	return IRQ_HANDLED;
 }
 
@@ -652,6 +657,8 @@ static int __maybe_unused imx_mu_suspend
 			priv->xcr[i] = imx_mu_read(priv, priv->dcfg->xCR[i]);
 	}
 
+	priv->suspend = true;
+
 	return 0;
 }
 
@@ -673,6 +680,8 @@ static int __maybe_unused imx_mu_resume_
 			imx_mu_write(priv, priv->xcr[i], priv->dcfg->xCR[i]);
 	}
 
+	priv->suspend = false;
+
 	return 0;
 }
 


