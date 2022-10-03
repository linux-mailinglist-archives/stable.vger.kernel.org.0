Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6C45F2A55
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiJCHfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiJCHec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:34:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A0C52E5E;
        Mon,  3 Oct 2022 00:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63261B80E68;
        Mon,  3 Oct 2022 07:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9C1C433D6;
        Mon,  3 Oct 2022 07:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781618;
        bh=SXP9nyNk5NtHD1ho0EXPJBi6RxYXVxyFXz9k3y7vsU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zE5XH6OlMIWNJBbSlfeTQfb1HN7bNNmH5rYEKLn4jeSSpoPKEtjplOd8NhGnV22On
         x2BScNvD3Q3IiXZgT/lWkCG1EwSwNOsfZhS1MURzGRJ+heXntvpUaw76BUlhZxQKhP
         roOySSxw5cHPPDi4uwl7tCGTT2nsuswzW7248lyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Theil <markus.theil@tu-ilmenau.de>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Hans de Goede <hdegoede@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 61/83] wifi: mac80211: fix regression with non-QoS drivers
Date:   Mon,  3 Oct 2022 09:11:26 +0200
Message-Id: <20221003070723.529470949@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d873697ef2b7e1b6fdd8e9d449d9354bd5d29a4a ]

Commit 10cb8e617560 ("mac80211: enable QoS support for nl80211 ctrl port")
changed ieee80211_tx_control_port() to aways call
__ieee80211_select_queue() without checking local->hw.queues.

__ieee80211_select_queue() returns a queue-id between 0 and 3, which means
that now ieee80211_tx_control_port() may end up setting the queue-mapping
for a skb to a value higher then local->hw.queues if local->hw.queues
is less then 4.

Specifically this is a problem for ralink rt2500-pci cards where
local->hw.queues is 2. There this causes rt2x00queue_get_tx_queue() to
return NULL and the following error to be logged: "ieee80211 phy0:
rt2x00mac_tx: Error - Attempt to send packet over invalid queue 2",
after which association with the AP fails.

Other callers of __ieee80211_select_queue() skip calling it when
local->hw.queues < IEEE80211_NUM_ACS, add the same check to
ieee80211_tx_control_port(). This fixes ralink rt2500-pci and
similar cards when less then 4 tx-queues no longer working.

Fixes: 10cb8e617560 ("mac80211: enable QoS support for nl80211 ctrl port")
Cc: Markus Theil <markus.theil@tu-ilmenau.de>
Suggested-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220918192052.443529-1-hdegoede@redhat.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a499b07fee33..8f8dc2625d53 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5719,6 +5719,9 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	skb_reset_network_header(skb);
 	skb_reset_mac_header(skb);
 
+	if (local->hw.queues < IEEE80211_NUM_ACS)
+		goto start_xmit;
+
 	/* update QoS header to prioritize control port frames if possible,
 	 * priorization also happens for control port frames send over
 	 * AF_PACKET
@@ -5734,6 +5737,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 
 	rcu_read_unlock();
 
+start_xmit:
 	/* mutex lock is only needed for incrementing the cookie counter */
 	mutex_lock(&local->mtx);
 
-- 
2.35.1



