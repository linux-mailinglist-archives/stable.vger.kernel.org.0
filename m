Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0169A6B496D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbjCJPMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbjCJPMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:12:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AF110C4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:03:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5E96B822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B311C4339C;
        Fri, 10 Mar 2023 14:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459841;
        bh=dbNVXLNXLF9tmtDeLxwn0K7X2YQccU4s+X8cG+vzoOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpyKdKmN84GqAaSldtyzAizemBcsAABVWPwlP82gMWwZ82g0WZKuivwMtfMxiKqLp
         4Td9jFjQUsroI8U9Yfjsr+XvtYoW9af6f370dZamXQ9ICOyTBtgZj5l3LXRhXKadnX
         UyCbXGXVxSVk/QqcpO0gax9guRakNoEDK8E7srvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shayne Chen <shayne.chen@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/529] wifi: mac80211: make rate u32 in sta_set_rate_info_rx()
Date:   Fri, 10 Mar 2023 14:34:40 +0100
Message-Id: <20230310133811.317090111@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index cee39ae52245c..d572478c4d68e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2159,7 +2159,7 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 
 static int sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 {
-	u16 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
+	u32 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
 
 	if (rate == STA_STATS_RATE_INVALID)
 		return -EINVAL;
-- 
2.39.2



