Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9356AE9B1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjCGR1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbjCGR0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:26:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC2399677
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:21:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B6C8614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFE0C433D2;
        Tue,  7 Mar 2023 17:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209688;
        bh=wA+3jbIIi6bEc7FqzNl0L2zJj5curjnHO/u8kMPPSGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E53ynl6gjLP0lR/yy9u898A1b4sABR2nPab6dXqkE2nyzISUZWRDsCd3WEQSaf3uQ
         Z9wLV1FCiL1QdoVNMNftbOn9e1quL9xZWOtoKtfVlFKVUkZ9EX0OtGdMu3qScsbQyS
         aRP45IpaEBcePUQyCG/ajFSwiPWsOfrmQV5qWeD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0300/1001] wifi: mac80211: fix non-MLO station association
Date:   Tue,  7 Mar 2023 17:51:12 +0100
Message-Id: <20230307170034.600408733@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index c6562a6d25035..3c4541ee9e6d4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4052,9 +4052,6 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
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



