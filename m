Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76A604868
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbiJSN4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbiJSNym (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:54:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881A3132DC1;
        Wed, 19 Oct 2022 06:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D933B82387;
        Wed, 19 Oct 2022 08:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F438C433C1;
        Wed, 19 Oct 2022 08:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169427;
        bh=bWaCn8E8sqheU4Kuv/pIWO/8UF7dv16NNlulGm9SNbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yf2zINUJzTDhEDVIK+ONIX/hP2n9fzWZk1ImM0FLMT3X5SUuYNl+GqypFuczS8TvL
         R7qgFIxp78aHNHCXhmhUO8TLKUWQ1hSUc4xghzrv6llZYk8OEU40/mnc2AGoVS/g2G
         ina6uMIvNNdTNs7YSBFHn1WAFOXdT7zTA3thIIXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaul Triebitz <shaul.triebitz@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 238/862] wifi: mac80211: properly set old_links when removing a link
Date:   Wed, 19 Oct 2022 10:25:25 +0200
Message-Id: <20221019083300.554557388@linuxfoundation.org>
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

From: Shaul Triebitz <shaul.triebitz@intel.com>

[ Upstream commit a8f62399daa6917e7f9efeb79bce4dd2cd494a1e ]

In ieee80211_sta_remove_link, valid_links is set to
the new_links before calling drv_change_sta_links, but
is used for the old_links.

Fixes: cb71f1d136a6 ("wifi: mac80211: add sta link addition/removal")
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 58998d821778..9d7b238a6737 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2799,6 +2799,7 @@ int ieee80211_sta_activate_link(struct sta_info *sta, unsigned int link_id)
 void ieee80211_sta_remove_link(struct sta_info *sta, unsigned int link_id)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u16 old_links = sta->sta.valid_links;
 
 	lockdep_assert_held(&sdata->local->sta_mtx);
 
@@ -2806,8 +2807,7 @@ void ieee80211_sta_remove_link(struct sta_info *sta, unsigned int link_id)
 
 	if (test_sta_flag(sta, WLAN_STA_INSERTED))
 		drv_change_sta_links(sdata->local, sdata, &sta->sta,
-				     sta->sta.valid_links,
-				     sta->sta.valid_links & ~BIT(link_id));
+				     old_links, sta->sta.valid_links);
 
 	sta_remove_link(sta, link_id, true);
 }
-- 
2.35.1



