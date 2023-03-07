Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B6F6AEEB7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjCGSPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjCGSOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:14:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEE29BA49
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D550B819C7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EB2C4339E;
        Tue,  7 Mar 2023 18:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212602;
        bh=xT3m1iIvnj9vgDIPS3oWJMSgzV5cs4PSU8qK6w/53GY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2OmhjMp1uPE+QHpQ5m6x+5Rn4LeiNuA1HE+imvHFjxu+qLIJywnfUxMlmzCpKDTqy
         I2YQ4EzWBZ01kqWbiei/fOMSDEo6x5Jnq51OxqRjOwonSKRaVC5DLtdgGWUJxEVXbI
         mu8NSIroVdLxdz9NOsF2Xsj0r/lPDrdlTwEPCThU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shayne Chen <shayne.chen@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/885] wifi: mac80211: make rate u32 in sta_set_rate_info_rx()
Date:   Tue,  7 Mar 2023 17:52:50 +0100
Message-Id: <20230307170012.281550270@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 59336e07b287d91dc4ec265e07724e8f7e3d0209 ]

The value of last_rate in ieee80211_sta_rx_stats is degraded from u32 to
u16 after being assigned to rate variable, which causes information loss
in STA_STATS_FIELD_TYPE and later bitfields.

Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://lore.kernel.org/r/20230209110659.25447-1-shayne.chen@mediatek.com
Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index cebfd148bb406..3603cbc167570 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2380,7 +2380,7 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 
 static int sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 {
-	u16 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
+	u32 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
 
 	if (rate == STA_STATS_RATE_INVALID)
 		return -EINVAL;
-- 
2.39.2



