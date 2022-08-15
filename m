Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECE85949F6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345891AbiHOXhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347644AbiHOXd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:33:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B9612D1E;
        Mon, 15 Aug 2022 13:08:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43ADFB80EAB;
        Mon, 15 Aug 2022 20:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DF3C433C1;
        Mon, 15 Aug 2022 20:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594121;
        bh=HDljj8CcBWlocdOKTe6crOSfnVL33XDHdc/F8wmSatE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wa9eJCpPQYGRQlp2ZkJgnBoadILOxj4NJWdUBr3epv6zy3sI32NBu0GsIgx3tPjl2
         lCQjVSzweahfN2dQSeUK/6e/g8TRoBH9x2pDKg+p/CMGYkCWTxu1/A7hLXNkWP0qAR
         VF1gSnKtXzc1ZIQ/RnEjJHBmCxysLIzd4sccq/J8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0382/1157] wifi: mac80211: set STA deflink addresses
Date:   Mon, 15 Aug 2022 19:55:38 +0200
Message-Id: <20220815180455.016801284@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 630c7e4621763220d23789fbb036e0cf227e0b22 ]

We should set the STA deflink addresses in case no
link is really added.

Fixes: 046d2e7c50e3 ("mac80211: prepare sta handling for MLO support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e04a0905e941..8b192cf7d446 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -373,6 +373,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	memcpy(sta->addr, addr, ETH_ALEN);
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
+	memcpy(sta->deflink.addr, addr, ETH_ALEN);
+	memcpy(sta->sta.deflink.addr, addr, ETH_ALEN);
 	sta->sta.max_rx_aggregation_subframes =
 		local->hw.max_rx_aggregation_subframes;
 
-- 
2.35.1



