Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABDE6B46F1
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjCJOrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbjCJOrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:47:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362FF1220BA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:47:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 497ECB822E5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9294FC4339B;
        Fri, 10 Mar 2023 14:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459623;
        bh=QE4MKEUIa2n5G9hC+F96AtHS9wGpx17d9YFvAYE1ZrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPWoA2w/ulRSYTR7e2K3Tbfkk/BmKk3cE4dRWzng47dYoPgLERWoXAQ/oBLem0EK4
         4ClH2ruU/mDr/gjtU8wKzO7kWiEVu5SdZrkA0P19s9DhaOYVHO7+BN2weSWNmiltx1
         rDnHV2RpRGTJFrMhP170/ZJ88Z1DFPmlD+j533Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/529] wifi: libertas: main: dont call kfree_skb() under spin_lock_irqsave()
Date:   Fri, 10 Mar 2023 14:33:29 +0100
Message-Id: <20230310133808.046095601@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f393df151540bf858effbd29ff572ab94e76a4c4 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave(). Compile
tested only.

Fixes: d2e7b3425c47 ("libertas: disable functionality when interface is down")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207150008.111743-4-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/main.c b/drivers/net/wireless/marvell/libertas/main.c
index 36237457d1363..1c56cc2742b07 100644
--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -217,7 +217,7 @@ int lbs_stop_iface(struct lbs_private *priv)
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	priv->iface_running = false;
-	kfree_skb(priv->currenttxskb);
+	dev_kfree_skb_irq(priv->currenttxskb);
 	priv->currenttxskb = NULL;
 	priv->tx_pending_len = 0;
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
-- 
2.39.2



