Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5AC6AEEB4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjCGSPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjCGSOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:14:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D909AA3B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:10:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7BA561531
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8A0C433EF;
        Tue,  7 Mar 2023 18:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212605;
        bh=NHbO6ZxYTzwGyFiba1ZNzxPfJF73tS58vvqaccSemCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2YVjPQyq5fBK3FSlA9Chj4mbyeX1xbyKJVcRuCRC7KUByE5Tz1cyFTq+tTj/nB3H
         Vac/C67wmyJ7yc+nddqRYv4XP002O4613yf17glhSasMPf53foEsWfcPvm5QDKwvd9
         USFX2NwWm73KQ8vrJ+oh33pGNXpSkw9qph//cRCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/885] wifi: mac80211: fix non-MLO station association
Date:   Tue,  7 Mar 2023 17:52:51 +0100
Message-Id: <20230307170012.316174423@linuxfoundation.org>
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

From: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>

[ Upstream commit aaacf1740f2f95e0c5449ff3bbcff252d69cf952 ]

Non-MLO station frames are dropped in Rx path due to the condition
check in ieee80211_rx_is_valid_sta_link_id(). In multi-link AP scenario,
non-MLO stations try to connect in any of the valid links in the ML AP,
where the station valid_links and link_id params are valid in the
ieee80211_sta object. But ieee80211_rx_is_valid_sta_link_id() always
return false for the non-MLO stations by the assumption taken is
valid_links and link_id are not valid in non-MLO stations object
(ieee80211_sta), this assumption is wrong. Due to this assumption,
non-MLO station frames are dropped which leads to failure in association.

Fix it by removing the condition check and allow the link validation
check for the non-MLO stations.

Fixes: e66b7920aa5a ("wifi: mac80211: fix initialization of rx->link and rx->link_sta")
Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Link: https://lore.kernel.org/r/20230206160330.1613-1-quic_periyasa@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8f0d7c666df7e..f9604dc182a87 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4073,9 +4073,6 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 static bool
 ieee80211_rx_is_valid_sta_link_id(struct ieee80211_sta *sta, u8 link_id)
 {
-	if (!sta->mlo)
-		return false;
-
 	return !!(sta->valid_links & BIT(link_id));
 }
 
-- 
2.39.2



