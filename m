Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A0C6AE9B6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjCGR1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbjCGR0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:26:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3517B9B2D9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:21:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE897614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6574C433EF;
        Tue,  7 Mar 2023 17:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209698;
        bh=ZhR24g26aXXEXnsxxf6/w5Ej8tWNPt5zoAXsd/nSJfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzCN2cuqehxfdL3uyNY2O61LxdxXBinEV6sYmTNYO5YbTxYnze3Y+R69TZJWXZ7Hg
         TUqFPMqKhNQFwW/X8tfeeRpgmsT9mLyMf+ddnkGh1fgYZEGh3G6ctlbDas5jVSXeOj
         YEWWaoRDG+TEfyWHkNwREmpIQ/IKSuPiOoPbafOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0303/1001] wifi: mac80211: fix off-by-one link setting
Date:   Tue,  7 Mar 2023 17:51:15 +0100
Message-Id: <20230307170034.715947692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit cf08e29db760b144bde51e2444f3430c75763e26 ]

The convention for find_first_bit() is 0-based, while ffs()
is 1-based, so this is now off-by-one. I cannot reproduce the
gcc-9 problem, but since the -1 is now removed, I'm hoping it
will still avoid the original issue.

Reported-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Fixes: 1d8d4af43474 ("wifi: mac80211: avoid u32_encode_bits() warning")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 118648af979c7..7699fb4106701 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4434,7 +4434,7 @@ static void ieee80211_mlo_multicast_tx(struct net_device *dev,
 	u32 ctrl_flags = IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX;
 
 	if (hweight16(links) == 1) {
-		ctrl_flags |= u32_encode_bits(find_first_bit(&links, 16) - 1,
+		ctrl_flags |= u32_encode_bits(__ffs(links),
 					      IEEE80211_TX_CTRL_MLO_LINK);
 
 		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags,
-- 
2.39.2



