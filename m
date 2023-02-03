Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A34C689571
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbjBCKWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbjBCKWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:22:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CF79D06C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:21:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BB4D61EC0
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13B6C433D2;
        Fri,  3 Feb 2023 10:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419691;
        bh=p/TESxW3x2c13Ep18IXZqi2TzocwFHIWf5tuyhmRZmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MfohrZ+sKkGnZH2Yd2MDczh4xy1BWWgR8Lg1CV2KWl4oIhGxBhsKrqX0w+DZZ5m3+
         pziq5UXVto2S2mAxievyWGidjxxddKUasvV9rK+l8dy2b679T7CAYBhjL+iIs2wkdI
         VPpTEDWY2nHVWcClbc6yEqImjAPSyJa8olGl0QBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sriram R <quic_srirrama@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/28] mac80211: Fix MLO address translation for multiple bss case
Date:   Fri,  3 Feb 2023 11:12:56 +0100
Message-Id: <20230203101010.331917874@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
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

From: Sriram R <quic_srirrama@quicinc.com>

[ Upstream commit fa22b51ace8aa106267636f36170e940e676809c ]

When multiple interfaces are present in the local interface
list, new skb copy is taken before rx processing except for
the first interface. The address translation happens each
time only on the original skb since the hdr pointer is not
updated properly to the newly created skb.

As a result frames start to drop in userspace when address
based checks or search fails.

Signed-off-by: Sriram R <quic_srirrama@quicinc.com>
Link: https://lore.kernel.org/r/20221208040050.25922-1-quic_srirrama@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3262ebb24092..8f0d7c666df7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4859,6 +4859,9 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 		 */
 		shwt = skb_hwtstamps(rx->skb);
 		shwt->hwtstamp = skb_hwtstamps(skb)->hwtstamp;
+
+		/* Update the hdr pointer to the new skb for translation below */
+		hdr = (struct ieee80211_hdr *)rx->skb->data;
 	}
 
 	if (unlikely(rx->sta && rx->sta->sta.mlo)) {
-- 
2.39.0



