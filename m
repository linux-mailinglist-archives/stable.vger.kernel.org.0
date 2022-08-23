Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A689759DF19
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbiHWKSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353969AbiHWKQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:16:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B2B7FE75;
        Tue, 23 Aug 2022 02:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B62D6123D;
        Tue, 23 Aug 2022 09:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8ACC433B5;
        Tue, 23 Aug 2022 09:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245257;
        bh=zx4gx2c7NUuB/8D90F7t4/tp3sdXtHdzmmcbUvr3UC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xLArfx27Ktaba8STeQ5v5Tvjg9h4FtQhCB4UdI+yl5dCqEhqej1EX5q5RKrmP9+i
         QeZ2kSt5CVnE5TakMM8ilBMOfZnfucmVMPYR5yAlTtX1RB5aBzo6xKvv1AdP9ca5J+
         9tdR3BILecG7f+0FD8vlmK1YSIm8tKRhztrGNpZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeongik Cha <jeongik@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 004/287] wifi: mac80211_hwsim: fix race condition in pending packet
Date:   Tue, 23 Aug 2022 10:22:53 +0200
Message-Id: <20220823080100.416660485@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
@@ -552,7 +552,7 @@ struct mac80211_hwsim_data {
 	bool ps_poll_pending;
 	struct dentry *debugfs;
 
-	uintptr_t pending_cookie;
+	atomic64_t pending_cookie;
 	struct sk_buff_head pending;	/* packets pending */
 	/*
 	 * Only radios in the same group can communicate together (the
@@ -1067,7 +1067,7 @@ static void mac80211_hwsim_tx_frame_nl(s
 	int i;
 	struct hwsim_tx_rate tx_attempts[IEEE80211_TX_MAX_RATES];
 	struct hwsim_tx_rate_flag tx_attempts_flags[IEEE80211_TX_MAX_RATES];
-	uintptr_t cookie;
+	u64 cookie;
 
 	if (data->ps != PS_DISABLED)
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
@@ -1136,8 +1136,7 @@ static void mac80211_hwsim_tx_frame_nl(s
 		goto nla_put_failure;
 
 	/* We create a cookie to identify this skb */
-	data->pending_cookie++;
-	cookie = data->pending_cookie;
+	cookie = (u64)atomic64_inc_return(&data->pending_cookie);
 	info->rate_driver_data[0] = (void *)cookie;
 	if (nla_put_u64_64bit(skb, HWSIM_ATTR_COOKIE, cookie, HWSIM_ATTR_PAD))
 		goto nla_put_failure;
@@ -3120,6 +3119,7 @@ static int hwsim_tx_info_frame_received_
 	const u8 *src;
 	unsigned int hwsim_flags;
 	int i;
+	unsigned long flags;
 	bool found = false;
 
 	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||
@@ -3144,18 +3144,20 @@ static int hwsim_tx_info_frame_received_
 		goto out;
 
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


