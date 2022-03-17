Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0874DC674
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiCQMwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbiCQMwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:52:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3771D12F6;
        Thu, 17 Mar 2022 05:49:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11534612AC;
        Thu, 17 Mar 2022 12:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E266C340E9;
        Thu, 17 Mar 2022 12:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521387;
        bh=vfkEJc4ylCqd1yNANLqxBaki/v7RtDs/YuDQdWSkMhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6Mz/ffHIzxPjSIryFUP4zM3MW5pQYU75qxly27e5hx7tSGABaYILNer54Ow/jAt+
         VT5f7HjlM02AxJnNwuky6SU25+fV9NDe2AKlGTjU1gIWIULWmd9pzlEL8+dTtaWa4I
         eh7rZD8IDX6Om3zDJ84RVG5kiBQhAKueD6ts859I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreeramya Soratkal <quic_ssramya@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/23] nl80211: Update bss channel on channel switch for P2P_CLIENT
Date:   Thu, 17 Mar 2022 13:45:58 +0100
Message-Id: <20220317124526.459212352@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124525.955110315@linuxfoundation.org>
References: <20220317124525.955110315@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreeramya Soratkal <quic_ssramya@quicinc.com>

[ Upstream commit e50b88c4f076242358b66ddb67482b96947438f2 ]

The wdev channel information is updated post channel switch only for
the station mode and not for the other modes. Due to this, the P2P client
still points to the old value though it moved to the new channel
when the channel change is induced from the P2P GO.

Update the bss channel after CSA channel switch completion for P2P client
interface as well.

Signed-off-by: Sreeramya Soratkal <quic_ssramya@quicinc.com>
Link: https://lore.kernel.org/r/1646114600-31479-1-git-send-email-quic_ssramya@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 07bd7b00b56d..0df8b9a19952 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17127,7 +17127,8 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 	wdev->chandef = *chandef;
 	wdev->preset_chandef = *chandef;
 
-	if (wdev->iftype == NL80211_IFTYPE_STATION &&
+	if ((wdev->iftype == NL80211_IFTYPE_STATION ||
+	     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
 	    !WARN_ON(!wdev->current_bss))
 		cfg80211_update_assoc_bss_entry(wdev, chandef->chan);
 
-- 
2.34.1



