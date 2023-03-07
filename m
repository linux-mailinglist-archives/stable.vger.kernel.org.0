Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C803C6AEEBE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbjCGSPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjCGSOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:14:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9072A4006
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:10:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2F666152E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8050C433D2;
        Tue,  7 Mar 2023 18:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212615;
        bh=B9S/aU6WLfM12WVDD1l/pigUkT+l1M4h9W8B8gG929E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iulKDk5l57+wOsS5lW6sM1HTPMkg/Mp0G6VnLsPlu2EJ4SxV5Xq5FWr8Bgg7IERiw
         Bjeigb8XYCdvkynXR46RlWCI2YRextKDtVQsej3Rx8O1g518Gs4vi4ZTuWhaXlbIsL
         +U9nIWREi3LQputNhnO6VQfdjdODGSnbARBTxLuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 239/885] wifi: mac80211: avoid u32_encode_bits() warning
Date:   Tue,  7 Mar 2023 17:52:53 +0100
Message-Id: <20230307170012.401272441@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1d8d4af4347420d657be448f8be4c39c558f3b5d ]

gcc-9 triggers a false-postive warning in ieee80211_mlo_multicast_tx()
for u32_encode_bits(ffs(links) - 1, ...), since ffs() can return zero
on an empty bitmask, and the negative argument to u32_encode_bits()
is then out of range:

In file included from include/linux/ieee80211.h:21,
                 from include/net/cfg80211.h:23,
                 from net/mac80211/tx.c:23:
In function 'u32_encode_bits',
    inlined from 'ieee80211_mlo_multicast_tx' at net/mac80211/tx.c:4437:17,
    inlined from 'ieee80211_subif_start_xmit' at net/mac80211/tx.c:4485:3:
include/linux/bitfield.h:177:3: error: call to '__field_overflow' declared with attribute error: value doesn't fit into mask
  177 |   __field_overflow();     \
      |   ^~~~~~~~~~~~~~~~~~
include/linux/bitfield.h:197:2: note: in expansion of macro '____MAKE_OP'
  197 |  ____MAKE_OP(u##size,u##size,,)
      |  ^~~~~~~~~~~
include/linux/bitfield.h:200:1: note: in expansion of macro '__MAKE_OP'
  200 | __MAKE_OP(32)
      | ^~~~~~~~~

Newer compiler versions do not cause problems with the zero argument
because they do not consider this a __builtin_constant_p().
It's also harmless since the hweight16() check already guarantees
that this cannot be 0.

Replace the ffs() with an equivalent find_first_bit() check that
matches the later for_each_set_bit() style and avoids the warning.

Fixes: 963d0e8d08d9 ("wifi: mac80211: optionally implement MLO multicast TX")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230214132025.1532147-1-arnd@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6409097a56c7a..55220e764de68 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4395,7 +4395,7 @@ static void ieee80211_mlo_multicast_tx(struct net_device *dev,
 	u32 ctrl_flags = IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX;
 
 	if (hweight16(links) == 1) {
-		ctrl_flags |= u32_encode_bits(ffs(links) - 1,
+		ctrl_flags |= u32_encode_bits(find_first_bit(&links, 16) - 1,
 					      IEEE80211_TX_CTRL_MLO_LINK);
 
 		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags,
-- 
2.39.2



