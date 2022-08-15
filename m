Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BAE594921
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354508AbiHOXsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355203AbiHOXrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:47:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC6EA8CD6;
        Mon, 15 Aug 2022 13:15:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F0ABB81136;
        Mon, 15 Aug 2022 20:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9733EC433D7;
        Mon, 15 Aug 2022 20:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594523;
        bh=75Z41sroTYn1e/S0XuKc13w0fL8LkxKB1qEup6hHIg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9uBpd3rjGSYPyK1/Yr9M2tR+OXwcAbfuz2MrGlOcLv6g81PiU/ETa7qLr1RfPPSH
         NVUJlqUeobhbvLJhQ4tzrHXiI84bLW+0uYgOQqQjdbpSyiPDtBi4plQZJRnwHao0dz
         MoTZY9T3l6ALe9t9Mv/xqmy6QFq0i/65TzxDPZE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0473/1157] wifi: mac80211: reject WEP or pairwise keys with key ID > 3
Date:   Mon, 15 Aug 2022 19:57:09 +0200
Message-Id: <20220815180458.534586999@linuxfoundation.org>
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

[ Upstream commit 92ea8df110b8ca92f9664ec7bd76dea109115348 ]

We don't really care too much right now since our data
structures are set up to not have a problem with this,
but clearly it's wrong to accept WEP and pairwise keys
with key ID > 3.

However, with MLD we need to split into per-link (GTK,
IGTK, BIGTK) and per interface/MLD (including WEP) keys
so make sure this is not a problem.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/key.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 0fcf8aebedc4..047a06b857c9 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -433,13 +433,25 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	int idx;
 	int ret = 0;
 	bool defunikey, defmultikey, defmgmtkey, defbeaconkey;
+	bool is_wep;
 
 	/* caller must provide at least one old/new */
 	if (WARN_ON(!new && !old))
 		return 0;
 
-	if (new)
+	if (new) {
+		idx = new->conf.keyidx;
 		list_add_tail_rcu(&new->list, &sdata->key_list);
+		is_wep = new->conf.cipher == WLAN_CIPHER_SUITE_WEP40 ||
+			 new->conf.cipher == WLAN_CIPHER_SUITE_WEP104;
+	} else {
+		idx = old->conf.keyidx;
+		is_wep = old->conf.cipher == WLAN_CIPHER_SUITE_WEP40 ||
+			 old->conf.cipher == WLAN_CIPHER_SUITE_WEP104;
+	}
+
+	if ((is_wep || pairwise) && idx >= NUM_DEFAULT_KEYS)
+		return -EINVAL;
 
 	WARN_ON(new && old && new->conf.keyidx != old->conf.keyidx);
 
@@ -451,8 +463,6 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (old) {
-		idx = old->conf.keyidx;
-
 		if (old->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 			ieee80211_key_disable_hw_accel(old);
 
@@ -460,8 +470,6 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 				ret = ieee80211_key_enable_hw_accel(new);
 		}
 	} else {
-		/* new must be provided in case old is not */
-		idx = new->conf.keyidx;
 		if (!new->local->wowlan)
 			ret = ieee80211_key_enable_hw_accel(new);
 	}
-- 
2.35.1



