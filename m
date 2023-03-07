Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7166AEEB8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbjCGSP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjCGSOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:14:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DD7A3B52
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 867EE61522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8E5C433D2;
        Tue,  7 Mar 2023 18:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212618;
        bh=05qDYmTS1bPuKURkUfmOWvaNz+fDu9SoscnEmVNvuF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5k4FcgAzYYgr4wemZXGO57aZKk5EwVYrc0s+PgVGR80B4UOEUHq3RfPHqC19U43y
         akGn9Sh0ADOiuzFbDsbKGEqALqXV9VZ8NXn6C82lAz59ItY/vezPGcsmINTPi0yo7R
         fSiEYCdoTv11151QfxOvvo7MltSlEQlhlME+yIXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 240/885] wifi: mac80211: fix off-by-one link setting
Date:   Tue,  7 Mar 2023 17:52:54 +0100
Message-Id: <20230307170012.433867377@linuxfoundation.org>
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
index 55220e764de68..6a1708db652f2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4395,7 +4395,7 @@ static void ieee80211_mlo_multicast_tx(struct net_device *dev,
 	u32 ctrl_flags = IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX;
 
 	if (hweight16(links) == 1) {
-		ctrl_flags |= u32_encode_bits(find_first_bit(&links, 16) - 1,
+		ctrl_flags |= u32_encode_bits(__ffs(links),
 					      IEEE80211_TX_CTRL_MLO_LINK);
 
 		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags,
-- 
2.39.2



