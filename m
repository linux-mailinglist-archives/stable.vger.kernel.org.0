Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98511586911
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbiHAL4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiHALzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:55:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5A345F59;
        Mon,  1 Aug 2022 04:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EACF7B81173;
        Mon,  1 Aug 2022 11:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10072C433C1;
        Mon,  1 Aug 2022 11:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354671;
        bh=FjzBCPAb7C25Y28emX03KeTIQr80qdVVFHA6xEHStRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFcfkORo61ZpBF47gK9EUeFJR4FQU9YqrbJkJ7i+DRoGj2WvZ2TV3rTRP560ZzQIv
         iGzpEZoOpQQn7sy29f1Q9+etffkb1z8VtY9xlm19piNsNQcubcMqTz30skTvy4pUQF
         xfqZKNv7+fwrh4xWijURyBuMzGhLCsqqNFHapRX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/65] sfc: disable softirqs for ptp TX
Date:   Mon,  1 Aug 2022 13:47:02 +0200
Message-Id: <20220801114135.614705683@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

[ Upstream commit 67c3b611d92fc238c43734878bc3e232ab570c79 ]

Sending a PTP packet can imply to use the normal TX driver datapath but
invoked from the driver's ptp worker. The kernel generic TX code
disables softirqs and preemption before calling specific driver TX code,
but the ptp worker does not. Although current ptp driver functionality
does not require it, there are several reasons for doing so:

   1) The invoked code is always executed with softirqs disabled for non
      PTP packets.
   2) Better if a ptp packet transmission is not interrupted by softirq
      handling which could lead to high latencies.
   3) netdev_xmit_more used by the TX code requires preemption to be
      disabled.

Indeed a solution for dealing with kernel preemption state based on static
kernel configuration is not possible since the introduction of dynamic
preemption level configuration at boot time using the static calls
functionality.

Fixes: f79c957a0b537 ("drivers: net: sfc: use netdev_xmit_more helper")
Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
Link: https://lore.kernel.org/r/20220726064504.49613-1-alejandro.lucero-palau@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ptp.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 725b0f38813a..a2b4e3befa59 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1100,7 +1100,29 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 
 	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
 	if (tx_queue && tx_queue->timestamping) {
+		/* This code invokes normal driver TX code which is always
+		 * protected from softirqs when called from generic TX code,
+		 * which in turn disables preemption. Look at __dev_queue_xmit
+		 * which uses rcu_read_lock_bh disabling preemption for RCU
+		 * plus disabling softirqs. We do not need RCU reader
+		 * protection here.
+		 *
+		 * Although it is theoretically safe for current PTP TX/RX code
+		 * running without disabling softirqs, there are three good
+		 * reasond for doing so:
+		 *
+		 *      1) The code invoked is mainly implemented for non-PTP
+		 *         packets and it is always executed with softirqs
+		 *         disabled.
+		 *      2) This being a single PTP packet, better to not
+		 *         interrupt its processing by softirqs which can lead
+		 *         to high latencies.
+		 *      3) netdev_xmit_more checks preemption is disabled and
+		 *         triggers a BUG_ON if not.
+		 */
+		local_bh_disable();
 		efx_enqueue_skb(tx_queue, skb);
+		local_bh_enable();
 	} else {
 		WARN_ONCE(1, "PTP channel has no timestamped tx queue\n");
 		dev_kfree_skb_any(skb);
-- 
2.35.1



