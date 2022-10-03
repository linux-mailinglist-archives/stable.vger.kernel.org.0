Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FBE5F29A7
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiJCHXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiJCHWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:22:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2F540BCA;
        Mon,  3 Oct 2022 00:16:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 308BA60FB0;
        Mon,  3 Oct 2022 07:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111ABC433C1;
        Mon,  3 Oct 2022 07:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781386;
        bh=zGDXXWjBRzum85yqymXEZW4/fwzlt0QXmVsfjdeyMFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TY5Zp14kxY4UEct7FeVwtpJKtR+NuzEWFZgN76hxAT72M5/CIloiGwpSJJOrihQ+i
         +ipf4Gqh8jwkWeGXM02MjKHVGxoSwS1g3fvOWUdD2mobb+cxwKgEBVzVhESubRAay7
         PYKUHxJTO0GCUVSfBkNF6L/i3w9IfLO6CsHHX3hU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Seiderer <ps.report@gmx.net>,
        Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?q?Pawe=C5=82=20Lenkow?= <pawel.lenkow@camlingroup.com>,
        Lech Perczak <lech.perczak@camlingroup.com>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?q?Krzysztof=20Drobi=C5=84ski?= 
        <krzysztof.drobinski@camlingroup.com>
Subject: [PATCH 5.19 080/101] wifi: mac80211: fix memory corruption in minstrel_ht_update_rates()
Date:   Mon,  3 Oct 2022 09:11:16 +0200
Message-Id: <20221003070726.445270935@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Paweł Lenkow <pawel.lenkow@camlingroup.com>

[ Upstream commit be92292b90bfdc31f332c962882b6d3ea0285fdf ]

During our testing of WFM200 module over SDIO on i.MX6Q-based platform,
we discovered a memory corruption on the system, tracing back to the wfx
driver. Using kfence, it was possible to trace it back to the root
cause, which is hw->max_rates set to 8 in wfx_init_common,
while the maximum defined by IEEE80211_TX_TABLE_SIZE is 4.

This causes array out-of-bounds writes during updates of the rate table,
as seen below:

BUG: KFENCE: memory corruption in kfree_rcu_work+0x320/0x36c

Corrupted memory at 0xe0a4ffe0 [ 0x03 0x03 0x03 0x03 0x01 0x00 0x00
0x02 0x02 0x02 0x09 0x00 0x21 0xbb 0xbb 0xbb ] (in kfence-#81):
kfree_rcu_work+0x320/0x36c
process_one_work+0x3ec/0x920
worker_thread+0x60/0x7a4
kthread+0x174/0x1b4
ret_from_fork+0x14/0x2c
0x0

kfence-#81: 0xe0a4ffc0-0xe0a4ffdf, size=32, cache=kmalloc-64

allocated by task 297 on cpu 0 at 631.039555s:
minstrel_ht_update_rates+0x38/0x2b0 [mac80211]
rate_control_tx_status+0xb4/0x148 [mac80211]
ieee80211_tx_status_ext+0x364/0x1030 [mac80211]
ieee80211_tx_status+0xe0/0x118 [mac80211]
ieee80211_tasklet_handler+0xb0/0xe0 [mac80211]
tasklet_action_common.constprop.0+0x11c/0x148
__do_softirq+0x1a4/0x61c
irq_exit+0xcc/0x104
call_with_stack+0x18/0x20
__irq_svc+0x80/0xb0
wq_worker_sleeping+0x10/0x100
wq_worker_sleeping+0x10/0x100
schedule+0x50/0xe0
schedule_timeout+0x2e0/0x474
wait_for_completion+0xdc/0x1ec
mmc_wait_for_req_done+0xc4/0xf8
mmc_io_rw_extended+0x3b4/0x4ec
sdio_io_rw_ext_helper+0x290/0x384
sdio_memcpy_toio+0x30/0x38
wfx_sdio_copy_to_io+0x88/0x108 [wfx]
wfx_data_write+0x88/0x1f0 [wfx]
bh_work+0x1c8/0xcc0 [wfx]
process_one_work+0x3ec/0x920
worker_thread+0x60/0x7a4
kthread+0x174/0x1b4
ret_from_fork+0x14/0x2c 0x0

After discussion on the wireless mailing list it was clarified
that the issue has been introduced by:
commit ee0e16ab756a ("mac80211: minstrel_ht: fill all requested rates")
and fix shall be in minstrel_ht_update_rates in rc80211_minstrel_ht.c.

Fixes: ee0e16ab756a ("mac80211: minstrel_ht: fill all requested rates")
Link: https://lore.kernel.org/all/12e5adcd-8aed-f0f7-70cc-4fb7b656b829@camlingroup.com/
Link: https://lore.kernel.org/linux-wireless/20220915131445.30600-1-lech.perczak@camlingroup.com/
Cc: Jérôme Pouiller <jerome.pouiller@silabs.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Peter Seiderer <ps.report@gmx.net>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Krzysztof Drobiński <krzysztof.drobinski@camlingroup.com>,
Signed-off-by: Paweł Lenkow <pawel.lenkow@camlingroup.com>
Signed-off-by: Lech Perczak <lech.perczak@camlingroup.com>
Reviewed-by: Peter Seiderer <ps.report@gmx.net>
Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 5f27e6746762..788a82f9c74d 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -10,6 +10,7 @@
 #include <linux/random.h>
 #include <linux/moduleparam.h>
 #include <linux/ieee80211.h>
+#include <linux/minmax.h>
 #include <net/mac80211.h>
 #include "rate.h"
 #include "sta_info.h"
@@ -1550,6 +1551,7 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
 	struct ieee80211_sta_rates *rates;
 	int i = 0;
+	int max_rates = min_t(int, mp->hw->max_rates, IEEE80211_TX_RATE_TABLE_SIZE);
 
 	rates = kzalloc(sizeof(*rates), GFP_ATOMIC);
 	if (!rates)
@@ -1559,10 +1561,10 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[0]);
 
 	/* Fill up remaining, keep one entry for max_probe_rate */
-	for (; i < (mp->hw->max_rates - 1); i++)
+	for (; i < (max_rates - 1); i++)
 		minstrel_ht_set_rate(mp, mi, rates, i, mi->max_tp_rate[i]);
 
-	if (i < mp->hw->max_rates)
+	if (i < max_rates)
 		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_prob_rate);
 
 	if (i < IEEE80211_TX_RATE_TABLE_SIZE)
-- 
2.35.1



