Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EAB6B478A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbjCJOvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbjCJOu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:50:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9004F515EC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:48:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C2C8619E0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D6DC433A1;
        Fri, 10 Mar 2023 14:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459674;
        bh=HNQkrgDjVDxavYIZRu7zI+YRIh4AWHcxkWD6sSkmD18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goBea3d+pALPl0DXuSs4YDpYyvRXUqNDNigP0b46yreU5GdOtHJt6uJnJaioS2Us4
         E2bL4/fUBS1uAAOvROu9U4j5Z2eXmuUl4VuAX8+D1oY3BwVSmIjwcaGTvh28Beblku
         TjkFJlWGiHHbM/286gMv4mDA+Z/WJccpLM+baPec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/529] wifi: iwlegacy: common: dont call dev_kfree_skb() under spin_lock_irqsave()
Date:   Fri, 10 Mar 2023 14:33:16 +0100
Message-Id: <20230310133807.457768349@linuxfoundation.org>
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

[ Upstream commit 0c1528675d7a9787cb516b64d8f6c0f6f8efcb48 ]

It is not allowed to call consume_skb() from hardware interrupt context
or with interrupts being disabled. So replace dev_kfree_skb() with
dev_consume_skb_irq() under spin_lock_irqsave(). Compile tested only.

Fixes: 4bc85c1324aa ("Revert "iwlwifi: split the drivers for agn and legacy devices 3945/4965"")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207144013.70210-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 0651a6a416d1d..4b55779de00a9 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -5176,7 +5176,7 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	memset(&il->current_ht_config, 0, sizeof(struct il_ht_config));
 
 	/* new association get rid of ibss beacon skb */
-	dev_kfree_skb(il->beacon_skb);
+	dev_consume_skb_irq(il->beacon_skb);
 	il->beacon_skb = NULL;
 	il->timestamp = 0;
 
@@ -5295,7 +5295,7 @@ il_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_irqsave(&il->lock, flags);
-	dev_kfree_skb(il->beacon_skb);
+	dev_consume_skb_irq(il->beacon_skb);
 	il->beacon_skb = skb;
 
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
-- 
2.39.2



