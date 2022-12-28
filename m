Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B0C657BA7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiL1PYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiL1PYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:24:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBFC14081
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:24:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E10FDB8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5267DC433F0;
        Wed, 28 Dec 2022 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241039;
        bh=YG6lVsrVTqRNh+4M9kK0c7vwuigfw/2hwuvyqQ5C5Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWX6xYpoTZFS3X4O1cEQ4n6Jrz5jRQhcxFSkLxG3i0VhW+MdxVeYHuP6SsmAX/gm/
         gaWgIRDC2dY9gUn3PA9ArjbJKHYxuc3aiHOjq4Fvb0vFlViXoGKqds1CWZRnZj4t+Z
         QifBSMOy52oVPzynfsqW+cB7t6z5KtamfFe/W2M8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0198/1146] wifi: mac80211: fix ifdef symbol name
Date:   Wed, 28 Dec 2022 15:28:57 +0100
Message-Id: <20221228144335.523267711@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9d13aff91ecd3f077b432df35291c945bde585be ]

This should of course be CONFIG_, not CPTCFG_, which is an
artifact from working with backports.

Fixes: 9dd1953846c7 ("wifi: nl80211/mac80211: clarify link ID in control port TX")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 874f2a4d831d..cc10ee1ff8e9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2973,7 +2973,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 		if (pre_conf_link_id != link_id &&
 		    link_id != IEEE80211_LINK_UNSPECIFIED) {
-#ifdef CPTCFG_MAC80211_VERBOSE_DEBUG
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			net_info_ratelimited("%s: dropped frame to %pM with bad link ID request (%d vs. %d)\n",
 					     sdata->name, hdr.addr1,
 					     pre_conf_link_id, link_id);
-- 
2.35.1



