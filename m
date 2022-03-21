Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2E04E2842
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348250AbiCUNzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 09:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348367AbiCUNzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:55:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3605710CC;
        Mon, 21 Mar 2022 06:53:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6C5A611F4;
        Mon, 21 Mar 2022 13:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA876C340E8;
        Mon, 21 Mar 2022 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870822;
        bh=KnxeRE+Le/zxu/bcAkRRacwhz4IT1ZtXf1iBhjipU6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jrk5ro8UV15hmQiH+AByUabHhtvqK84+Wtkf0xZ1NaQm5SVWaBn0Qc1hTcqTWf+8Y
         ugRlU5LQ5CV+oaK2xhucjhhR5e8ccQoy2BVMYTVX6u+UyxN2IuimBosOknup9ylJTC
         m6CAbX5bLxzR18ZazX3pZtPyLMJN3DhJQssrx3Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreeramya Soratkal <quic_ssramya@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/16] nl80211: Update bss channel on channel switch for P2P_CLIENT
Date:   Mon, 21 Mar 2022 14:51:37 +0100
Message-Id: <20220321133216.867138847@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133216.648316863@linuxfoundation.org>
References: <20220321133216.648316863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index ab8bca39afa3..562e138deba2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14068,7 +14068,8 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 	wdev->chandef = *chandef;
 	wdev->preset_chandef = *chandef;
 
-	if (wdev->iftype == NL80211_IFTYPE_STATION &&
+	if ((wdev->iftype == NL80211_IFTYPE_STATION ||
+	     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
 	    !WARN_ON(!wdev->current_bss))
 		wdev->current_bss->pub.channel = chandef->chan;
 
-- 
2.34.1



