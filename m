Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9984F2E0A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355596AbiDEKUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347153AbiDEJZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:25:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7FFAA018;
        Tue,  5 Apr 2022 02:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1405961659;
        Tue,  5 Apr 2022 09:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2456BC385A0;
        Tue,  5 Apr 2022 09:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150052;
        bh=aVUBwy5ixGJpNkudBT7QG5qe2UFBdxE/HFTF2miR6uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gb2svhWrgPuGQ0BmRVqDy1irybc6a77A7wgOTkSF6Y+rYf+X55k57kNU74R5elzRW
         HR5spq1jQVCNl4Xz5qCBpzJ4PxZ31Mwpg/BmUiIXKqR4myR+YZ7RSIKQrl+tZwC1SG
         HirqyRnnVg0pNbbtsZWVcexNWj0+/GeCvOEYNK44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacky Bai <ping.bai@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Robin Gong <yibin.gong@nxp.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH 5.16 0937/1017] mailbox: imx: fix wakeup failure from freeze mode
Date:   Tue,  5 Apr 2022 09:30:50 +0200
Message-Id: <20220405070422.027277386@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/suspend.h>
 #include <linux/slab.h>
 
 #define IMX_MU_CHANS		16
@@ -76,6 +77,7 @@ struct imx_mu_priv {
 	const struct imx_mu_dcfg	*dcfg;
 	struct clk		*clk;
 	int			irq;
+	bool			suspend;
 
 	u32 xcr[4];
 
@@ -334,6 +336,9 @@ static irqreturn_t imx_mu_isr(int irq, v
 		return IRQ_NONE;
 	}
 
+	if (priv->suspend)
+		pm_system_wakeup();
+
 	return IRQ_HANDLED;
 }
 
@@ -702,6 +707,8 @@ static int __maybe_unused imx_mu_suspend
 			priv->xcr[i] = imx_mu_read(priv, priv->dcfg->xCR[i]);
 	}
 
+	priv->suspend = true;
+
 	return 0;
 }
 
@@ -723,6 +730,8 @@ static int __maybe_unused imx_mu_resume_
 			imx_mu_write(priv, priv->xcr[i], priv->dcfg->xCR[i]);
 	}
 
+	priv->suspend = false;
+
 	return 0;
 }
 


