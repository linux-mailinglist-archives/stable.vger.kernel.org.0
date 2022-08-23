Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD2E59DDE1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352743AbiHWKUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353653AbiHWKSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:18:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A0180EAD;
        Tue, 23 Aug 2022 02:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5401461530;
        Tue, 23 Aug 2022 09:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B20FC433D6;
        Tue, 23 Aug 2022 09:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245304;
        bh=1DV94zophLjpcEDGwBTmbdo/8rx+MYKlO0RwTEpo6bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3pcOf6zoQkwOCCp0to2zO3s6H3T89sC2oPO1z++5Jl8TKYxkIWaDEk33M0mDcZrF
         0X/2NXDFBLHfnhyqygP0Bx8I7vc+xIjj1EqfDOnCAPQIQgRWiRH1rKwgzU601eB/Sh
         RsadMJu0vFD81kwIhZNg1Zp3Jh7rfSRpNfNQCNqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Jeongik Cha <jeongik@google.com>
Subject: [PATCH 4.19 006/287] wifi: mac80211_hwsim: use 32-bit skb cookie
Date:   Tue, 23 Aug 2022 10:22:55 +0200
Message-Id: <20220823080100.475833180@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit cc5250cdb43d444061412df7fae72d2b4acbdf97 upstream.

We won't really have enough skbs to need a 64-bit cookie,
and on 32-bit platforms storing the 64-bit cookie into the
void *rate_driver_data doesn't work anyway. Switch back to
using just a 32-bit cookie and uintptr_t for the type to
avoid compiler warnings about all this.

Fixes: 4ee186fa7e40 ("wifi: mac80211_hwsim: fix race condition in pending packet")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Jeongik Cha <jeongik@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mac80211_hwsim.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -552,7 +552,7 @@ struct mac80211_hwsim_data {
 	bool ps_poll_pending;
 	struct dentry *debugfs;
 
-	atomic64_t pending_cookie;
+	atomic_t pending_cookie;
 	struct sk_buff_head pending;	/* packets pending */
 	/*
 	 * Only radios in the same group can communicate together (the
@@ -1067,7 +1067,7 @@ static void mac80211_hwsim_tx_frame_nl(s
 	int i;
 	struct hwsim_tx_rate tx_attempts[IEEE80211_TX_MAX_RATES];
 	struct hwsim_tx_rate_flag tx_attempts_flags[IEEE80211_TX_MAX_RATES];
-	u64 cookie;
+	uintptr_t cookie;
 
 	if (data->ps != PS_DISABLED)
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
@@ -1136,7 +1136,7 @@ static void mac80211_hwsim_tx_frame_nl(s
 		goto nla_put_failure;
 
 	/* We create a cookie to identify this skb */
-	cookie = (u64)atomic64_inc_return(&data->pending_cookie);
+	cookie = atomic_inc_return(&data->pending_cookie);
 	info->rate_driver_data[0] = (void *)cookie;
 	if (nla_put_u64_64bit(skb, HWSIM_ATTR_COOKIE, cookie, HWSIM_ATTR_PAD))
 		goto nla_put_failure;
@@ -3146,10 +3146,10 @@ static int hwsim_tx_info_frame_received_
 	/* look for the skb matching the cookie passed back from user */
 	spin_lock_irqsave(&data2->pending.lock, flags);
 	skb_queue_walk_safe(&data2->pending, skb, tmp) {
-		u64 skb_cookie;
+		uintptr_t skb_cookie;
 
 		txi = IEEE80211_SKB_CB(skb);
-		skb_cookie = (u64)(uintptr_t)txi->rate_driver_data[0];
+		skb_cookie = (uintptr_t)txi->rate_driver_data[0];
 
 		if (skb_cookie == ret_skb_cookie) {
 			__skb_unlink(skb, &data2->pending);


