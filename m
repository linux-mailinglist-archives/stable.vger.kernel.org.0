Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D4A529016
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiEPUH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349581AbiEPUAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A4242A17;
        Mon, 16 May 2022 12:54:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E5E060EDF;
        Mon, 16 May 2022 19:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67559C385AA;
        Mon, 16 May 2022 19:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730845;
        bh=/gIDxI1wHhsi2UC0VnCpHTggEC2VuqMVU7gLQEUWN9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpSFlQNvRWvqmx8HAscqfBwUnf1913Au3pRVmYZc+LbfC3WXXPUUkCM9sy1Idhw4s
         e5TUMlQAt9E41BW9y76iEAWHQ8cKL+Qvg9Py3zZMdbaOGLWGcazrYOnw9KCp6awkX1
         kx39t5o7cleeXfPNWUVEx+tQlf+B69N9SsaVv3uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 023/114] net: sfc: fix memory leak due to ptp channel
Date:   Mon, 16 May 2022 21:35:57 +0200
Message-Id: <20220516193626.159408763@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 49e6123c65dac6393b04f39ceabf79c44f66b8be ]

It fixes memory leak in ring buffer change logic.

When ring buffer size is changed(ethtool -G eth0 rx 4096), sfc driver
works like below.
1. stop all channels and remove ring buffers.
2. allocates new buffer array.
3. allocates rx buffers.
4. start channels.

While the above steps are working, it skips some steps if the channel
doesn't have a ->copy callback function.
Due to ptp channel doesn't have ->copy callback, these above steps are
skipped for ptp channel.
It eventually makes some problems.
a. ptp channel's ring buffer size is not changed, it works only
   1024(default).
b. memory leak.

The reason for memory leak is to use the wrong ring buffer values.
There are some values, which is related to ring buffer size.
a. efx->rxq_entries
 - This is global value of rx queue size.
b. rx_queue->ptr_mask
 - used for access ring buffer as circular ring.
 - roundup_pow_of_two(efx->rxq_entries) - 1
c. rx_queue->max_fill
 - efx->rxq_entries - EFX_RXD_HEAD_ROOM

These all values should be based on ring buffer size consistently.
But ptp channel's values are not.
a. efx->rxq_entries
 - This is global(for sfc) value, always new ring buffer size.
b. rx_queue->ptr_mask
 - This is always 1023(default).
c. rx_queue->max_fill
 - This is new ring buffer size - EFX_RXD_HEAD_ROOM.

Let's assume we set 4096 for rx ring buffer,

                      normal channel     ptp channel
efx->rxq_entries      4096               4096
rx_queue->ptr_mask    4095               1023
rx_queue->max_fill    4086               4086

sfc driver allocates rx ring buffers based on these values.
When it allocates ptp channel's ring buffer, 4086 ring buffers are
allocated then, these buffers are attached to the allocated array.
But ptp channel's ring buffer array size is still 1024(default)
and ptr_mask is still 1023 too.
So, 3062 ring buffers will be overwritten to the array.
This is the reason for memory leak.

Test commands:
   ethtool -G <interface name> rx 4096
   while :
   do
       ip link set <interface name> up
       ip link set <interface name> down
   done

In order to avoid this problem, it adds ->copy callback to ptp channel
type.
So that rx_queue->ptr_mask value will be updated correctly.

Fixes: 7c236c43b838 ("sfc: Add support for IEEE-1588 PTP")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_channels.c |  7 ++++++-
 drivers/net/ethernet/sfc/ptp.c          | 14 +++++++++++++-
 drivers/net/ethernet/sfc/ptp.h          |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 40bfd0ad7d05..eec0db76d888 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -845,7 +845,9 @@ static void efx_set_xdp_channels(struct efx_nic *efx)
 
 int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 {
-	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel;
+	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel,
+			   *ptp_channel = efx_ptp_channel(efx);
+	struct efx_ptp_data *ptp_data = efx->ptp_data;
 	unsigned int i, next_buffer_table = 0;
 	u32 old_rxq_entries, old_txq_entries;
 	int rc, rc2;
@@ -916,6 +918,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 
 	efx_set_xdp_channels(efx);
 out:
+	efx->ptp_data = NULL;
 	/* Destroy unused channel structures */
 	for (i = 0; i < efx->n_channels; i++) {
 		channel = other_channel[i];
@@ -926,6 +929,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 		}
 	}
 
+	efx->ptp_data = ptp_data;
 	rc2 = efx_soft_enable_interrupts(efx);
 	if (rc2) {
 		rc = rc ? rc : rc2;
@@ -944,6 +948,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	efx->txq_entries = old_txq_entries;
 	for (i = 0; i < efx->n_channels; i++)
 		swap(efx->channel[i], other_channel[i]);
+	efx_ptp_update_channel(efx, ptp_channel);
 	goto out;
 }
 
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index f0ef515e2ade..4625f85acab2 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -45,6 +45,7 @@
 #include "farch_regs.h"
 #include "tx.h"
 #include "nic.h" /* indirectly includes ptp.h */
+#include "efx_channels.h"
 
 /* Maximum number of events expected to make up a PTP event */
 #define	MAX_EVENT_FRAGS			3
@@ -541,6 +542,12 @@ struct efx_channel *efx_ptp_channel(struct efx_nic *efx)
 	return efx->ptp_data ? efx->ptp_data->channel : NULL;
 }
 
+void efx_ptp_update_channel(struct efx_nic *efx, struct efx_channel *channel)
+{
+	if (efx->ptp_data)
+		efx->ptp_data->channel = channel;
+}
+
 static u32 last_sync_timestamp_major(struct efx_nic *efx)
 {
 	struct efx_channel *channel = efx_ptp_channel(efx);
@@ -1443,6 +1450,11 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 	int rc = 0;
 	unsigned int pos;
 
+	if (efx->ptp_data) {
+		efx->ptp_data->channel = channel;
+		return 0;
+	}
+
 	ptp = kzalloc(sizeof(struct efx_ptp_data), GFP_KERNEL);
 	efx->ptp_data = ptp;
 	if (!efx->ptp_data)
@@ -2176,7 +2188,7 @@ static const struct efx_channel_type efx_ptp_channel_type = {
 	.pre_probe		= efx_ptp_probe_channel,
 	.post_remove		= efx_ptp_remove_channel,
 	.get_name		= efx_ptp_get_channel_name,
-	/* no copy operation; there is no need to reallocate this channel */
+	.copy                   = efx_copy_channel,
 	.receive_skb		= efx_ptp_rx,
 	.want_txqs		= efx_ptp_want_txqs,
 	.keep_eventq		= false,
diff --git a/drivers/net/ethernet/sfc/ptp.h b/drivers/net/ethernet/sfc/ptp.h
index 9855e8c9e544..7b1ef7002b3f 100644
--- a/drivers/net/ethernet/sfc/ptp.h
+++ b/drivers/net/ethernet/sfc/ptp.h
@@ -16,6 +16,7 @@ struct ethtool_ts_info;
 int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel);
 void efx_ptp_defer_probe_with_channel(struct efx_nic *efx);
 struct efx_channel *efx_ptp_channel(struct efx_nic *efx);
+void efx_ptp_update_channel(struct efx_nic *efx, struct efx_channel *channel);
 void efx_ptp_remove(struct efx_nic *efx);
 int efx_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr);
 int efx_ptp_get_ts_config(struct efx_nic *efx, struct ifreq *ifr);
-- 
2.35.1



