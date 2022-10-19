Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F5E603F7D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiJSJcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiJSJaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9B2EE089;
        Wed, 19 Oct 2022 02:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FE7761882;
        Wed, 19 Oct 2022 09:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F79C433D7;
        Wed, 19 Oct 2022 09:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170525;
        bh=m4KrS+f91Bw2+wpxolcuqnxHD4V0hk/Zrm3h5a6H50c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNMoodGSxgXSrmUXYnu0CBwWyMj5WBP1eX1rrtevsOPUCsVowiRC6M3HPr9r1363w
         o3Gd35WV2Gwi/v0N/cRcvojzmGJWDttyWDo/Iqpas1zJnfZ2euybW1hH/IP6e0N9a3
         G83j2Nix4jZssT/UU0Di6D584bnYIqAkRO+P548U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 689/862] wifi: mac80211: accept STA changes without link changes
Date:   Wed, 19 Oct 2022 10:32:56 +0200
Message-Id: <20221019083320.429793127@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b303835dabe0340f932ebb4e260d2229f79b0684 ]

If there's no link ID, then check that there are no changes to
the link, and if so accept them, unless a new link is created.
While at it, reject creating a new link without an address.

This fixes authorizing an MLD (peer) that has no link 0.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e5239a17a875..65f34945a767 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1610,6 +1610,18 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 		rcu_dereference_protected(sta->link[link_id],
 					  lockdep_is_held(&local->sta_mtx));
 
+	/*
+	 * If there are no changes, then accept a link that doesn't exist,
+	 * unless it's a new link.
+	 */
+	if (params->link_id < 0 && !new_link &&
+	    !params->link_mac && !params->txpwr_set &&
+	    !params->supported_rates_len &&
+	    !params->ht_capa && !params->vht_capa &&
+	    !params->he_capa && !params->eht_capa &&
+	    !params->opmode_notif_used)
+		return 0;
+
 	if (!link || !link_sta)
 		return -EINVAL;
 
@@ -1625,6 +1637,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 					     params->link_mac)) {
 			return -EINVAL;
 		}
+	} else if (new_link) {
+		return -EINVAL;
 	}
 
 	if (params->txpwr_set) {
-- 
2.35.1



