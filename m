Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660CA599F0A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350169AbiHSPrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350178AbiHSPqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:46:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684851B79F;
        Fri, 19 Aug 2022 08:46:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3ACA616A9;
        Fri, 19 Aug 2022 15:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35AAC4314B;
        Fri, 19 Aug 2022 15:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923996;
        bh=YbPq9NNG3cYB6MK7uwbwTPsU2RWj+UAGaCHof1Nm5zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHhvr1OSJ2YOzuhUKsa2rGKj5eZJQGk7L/lXaC43IwumuhZIA+0Jtp9KqQHHJHwWr
         jyfsqs0VFwPOWvl+kl6b6Rg+Py+f91ennRNfQKXdGTk5HbTeCwfHgbEgI50ltx2iPL
         mjr+e7rFkbVlLMsAwb3ImiH4W0pzHc5qwIcFyoxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeongik Cha <jeongik@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 008/545] wifi: mac80211_hwsim: fix race condition in pending packet
Date:   Fri, 19 Aug 2022 17:36:18 +0200
Message-Id: <20220819153829.547093919@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Jeongik Cha <jeongik@google.com>

commit 4ee186fa7e40ae06ebbfbad77e249e3746e14114 upstream.

A pending packet uses a cookie as an unique key, but it can be duplicated
because it didn't use atomic operators.

And also, a pending packet can be null in hwsim_tx_info_frame_received_nl
due to race condition with mac80211_hwsim_stop.

For this,
 * Use an atomic type and operator for a cookie
 * Add a lock around the loop for pending packets

Signed-off-by: Jeongik Cha <jeongik@google.com>
Link: https://lore.kernel.org/r/20220704084354.3556326-1-jeongik@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mac80211_hwsim.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -593,7 +593,7 @@ struct mac80211_hwsim_data {
 	bool ps_poll_pending;
 	struct dentry *debugfs;
 
-	uintptr_t pending_cookie;
+	atomic64_t pending_cookie;
 	struct sk_buff_head pending;	/* packets pending */
 	/*
 	 * Only radios in the same group can communicate together (the
@@ -1200,7 +1200,7 @@ static void mac80211_hwsim_tx_frame_nl(s
 	int i;
 	struct hwsim_tx_rate tx_attempts[IEEE80211_TX_MAX_RATES];
 	struct hwsim_tx_rate_flag tx_attempts_flags[IEEE80211_TX_MAX_RATES];
-	uintptr_t cookie;
+	u64 cookie;
 
 	if (data->ps != PS_DISABLED)
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
@@ -1269,8 +1269,7 @@ static void mac80211_hwsim_tx_frame_nl(s
 		goto nla_put_failure;
 
 	/* We create a cookie to identify this skb */
-	data->pending_cookie++;
-	cookie = data->pending_cookie;
+	cookie = (u64)atomic64_inc_return(&data->pending_cookie);
 	info->rate_driver_data[0] = (void *)cookie;
 	if (nla_put_u64_64bit(skb, HWSIM_ATTR_COOKIE, cookie, HWSIM_ATTR_PAD))
 		goto nla_put_failure;
@@ -3508,6 +3507,7 @@ static int hwsim_tx_info_frame_received_
 	const u8 *src;
 	unsigned int hwsim_flags;
 	int i;
+	unsigned long flags;
 	bool found = false;
 
 	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||
@@ -3535,18 +3535,20 @@ static int hwsim_tx_info_frame_received_
 	}
 
 	/* look for the skb matching the cookie passed back from user */
+	spin_lock_irqsave(&data2->pending.lock, flags);
 	skb_queue_walk_safe(&data2->pending, skb, tmp) {
 		u64 skb_cookie;
 
 		txi = IEEE80211_SKB_CB(skb);
-		skb_cookie = (u64)(uintptr_t)txi->rate_driver_data[0];
+		skb_cookie = (u64)txi->rate_driver_data[0];
 
 		if (skb_cookie == ret_skb_cookie) {
-			skb_unlink(skb, &data2->pending);
+			__skb_unlink(skb, &data2->pending);
 			found = true;
 			break;
 		}
 	}
+	spin_unlock_irqrestore(&data2->pending.lock, flags);
 
 	/* not found */
 	if (!found)


