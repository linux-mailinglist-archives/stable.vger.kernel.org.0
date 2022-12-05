Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBBC6431F2
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiLETWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbiLETWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:22:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C60D958C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:18:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD694B81214
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1927CC433C1;
        Mon,  5 Dec 2022 19:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267883;
        bh=0AWotSKh2jBL7wHgXlfttMCy9zVCTd4JAZaDlVw30xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWTqmSDmq8cZCAMxpBUd5RNWshlhIR2+KEuZ9idvWdmdi3eCSs6yjKuSX6j7+1CLm
         ojuL9PU+bUKBQnA/foMywIfli+0BGx00UYK3AkqXBwgUoc57OQx+T5sOn75cxxxODz
         hn33fYqxtKg4XjAXLoTtBcT6FBF1e0E/EDKE54Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jonas Jelonek <jelonek.jonas@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/105] wifi: mac80211_hwsim: fix debugfs attribute ps with rc table support
Date:   Mon,  5 Dec 2022 20:08:33 +0100
Message-Id: <20221205190803.176568910@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Jonas Jelonek <jelonek.jonas@gmail.com>

[ Upstream commit 69188df5f6e4cecc6b76b958979ba363cd5240e8 ]

Fixes a warning that occurs when rc table support is enabled
(IEEE80211_HW_SUPPORTS_RC_TABLE) in mac80211_hwsim and the PS mode
is changed via the exported debugfs attribute.

When the PS mode is changed, a packet is broadcasted via
hwsim_send_nullfunc by creating and transmitting a plain skb with only
header initialized. The ieee80211 rate array in the control buffer is
zero-initialized. When ratetbl support is enabled, ieee80211_get_tx_rates
is called for the skb with sta parameter set to NULL and thus no
ratetbl can be used. The final rate array then looks like
[-1,0; 0,0; 0,0; 0,0] which causes the warning in ieee80211_get_tx_rate.

The issue is fixed by setting the count of the first rate with idx '0'
to 1 and hence ieee80211_get_tx_rates won't overwrite it with idx '-1'.

Signed-off-by: Jonas Jelonek <jelonek.jonas@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c52802adb5b2..22738ba7d65b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -686,6 +686,7 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_info *cb;
 
 	if (!vp->assoc)
 		return;
@@ -707,6 +708,10 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	memcpy(hdr->addr2, mac, ETH_ALEN);
 	memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
 
+	cb = IEEE80211_SKB_CB(skb);
+	cb->control.rates[0].count = 1;
+	cb->control.rates[1].idx = -1;
+
 	rcu_read_lock();
 	mac80211_hwsim_tx_frame(data->hw, skb,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
-- 
2.35.1



