Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410086AE9B4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCGR1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjCGR0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:26:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037971555A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:21:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93AC8614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A179C433EF;
        Tue,  7 Mar 2023 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209695;
        bh=5KY4ObnIs4ioAsY4kJN5gQ/ImV2ynce+cM+CruzdSSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3oamINsk+UsHxeda1QZdLqnvFuS2zsq55LJ5aeEdmSst4PYrt+Q/s1UUo93Q1CLq
         4uPYYhxORYxmU9SoY1n+GubloWIXCyzJb2zG4DxhB0dbNTb2/GqTGPm+fQCZ5EOZay
         1sTY2XKC3UjIiZMK92FmaqeYRfeBk2YXFYsBf8PA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0302/1001] wifi: mac80211: avoid u32_encode_bits() warning
Date:   Tue,  7 Mar 2023 17:51:14 +0100
Message-Id: <20230307170034.683100954@linuxfoundation.org>
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
index defe97a31724d..118648af979c7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4434,7 +4434,7 @@ static void ieee80211_mlo_multicast_tx(struct net_device *dev,
 	u32 ctrl_flags = IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX;
 
 	if (hweight16(links) == 1) {
-		ctrl_flags |= u32_encode_bits(ffs(links) - 1,
+		ctrl_flags |= u32_encode_bits(find_first_bit(&links, 16) - 1,
 					      IEEE80211_TX_CTRL_MLO_LINK);
 
 		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags,
-- 
2.39.2



