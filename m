Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6236B4307
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjCJOKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbjCJOJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:09:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E78136FC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:09:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C9A9B82278
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C813DC4339E;
        Fri, 10 Mar 2023 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457331;
        bh=4lnI+5Kb8MywBCiDi5A3cBTfxTbIBDrqoA3KNl/THWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QekvDN6t+6AKhUK9S8p9IYeSBMlVmkm3nmKlsUzUo7raEETHLi2/yPgo7T0jE63F3
         ZoqepHoj/VZKVKWNY4QZPliHZ4NCgtCtYZ1NqOyTzfYbb7KsC447XIcucqfTnaDGio
         yaOevqlReZgd8R3ApTag6vqlIUhnjHvXCY6oqrc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geetha sowjanya <gakula@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Sai Krishna <saikrishnag@marvell.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/200] octeontx2-pf: Recalculate UDP checksum for ptp 1-step sync packet
Date:   Fri, 10 Mar 2023 14:37:57 +0100
Message-Id: <20230310133719.272044784@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit edea0c5a994b7829c9ada8f5bc762c4e32f4f797 ]

When checksum offload is disabled in the driver via ethtool,
the PTP 1-step sync packets contain incorrect checksum, since
the stack calculates the checksum before driver updates
PTP timestamp field in the packet. This results in PTP packets
getting dropped at the other end. This patch fixes the issue by
re-calculating the UDP checksum after updating PTP
timestamp field in the driver.

Fixes: 2958d17a8984 ("octeontx2-pf: Add support for ptp 1-step mode on CN10K silicon")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Link: https://lore.kernel.org/r/20230222113600.1965116-1-saikrishnag@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/nic/otx2_txrx.c         | 76 ++++++++++++++-----
 1 file changed, 57 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index ef10aef3cda02..7045fedfd73a0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -10,6 +10,7 @@
 #include <net/tso.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <net/ip6_checksum.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -699,7 +700,7 @@ static void otx2_sqe_add_ext(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 
 static void otx2_sqe_add_mem(struct otx2_snd_queue *sq, int *offset,
 			     int alg, u64 iova, int ptp_offset,
-			     u64 base_ns, int udp_csum)
+			     u64 base_ns, bool udp_csum_crt)
 {
 	struct nix_sqe_mem_s *mem;
 
@@ -711,7 +712,7 @@ static void otx2_sqe_add_mem(struct otx2_snd_queue *sq, int *offset,
 
 	if (ptp_offset) {
 		mem->start_offset = ptp_offset;
-		mem->udp_csum_crt = udp_csum;
+		mem->udp_csum_crt = !!udp_csum_crt;
 		mem->base_ns = base_ns;
 		mem->step_type = 1;
 	}
@@ -986,10 +987,11 @@ static bool otx2_validate_network_transport(struct sk_buff *skb)
 	return false;
 }
 
-static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, int *udp_csum)
+static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, bool *udp_csum_crt)
 {
 	struct ethhdr *eth = (struct ethhdr *)(skb->data);
 	u16 nix_offload_hlen = 0, inner_vhlen = 0;
+	bool udp_hdr_present = false, is_sync;
 	u8 *data = skb->data, *msgtype;
 	__be16 proto = eth->h_proto;
 	int network_depth = 0;
@@ -1029,45 +1031,81 @@ static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, int *udp_csum)
 		if (!otx2_validate_network_transport(skb))
 			return false;
 
-		*udp_csum = 1;
 		*offset = nix_offload_hlen + skb_transport_offset(skb) +
 			  sizeof(struct udphdr);
+		udp_hdr_present = true;
+
 	}
 
 	msgtype = data + *offset;
-
 	/* Check PTP messageId is SYNC or not */
-	return (*msgtype & 0xf) == 0;
+	is_sync = !(*msgtype & 0xf);
+	if (is_sync)
+		*udp_csum_crt = udp_hdr_present;
+	else
+		*offset = 0;
+
+	return is_sync;
 }
 
 static void otx2_set_txtstamp(struct otx2_nic *pfvf, struct sk_buff *skb,
 			      struct otx2_snd_queue *sq, int *offset)
 {
+	struct ethhdr	*eth = (struct ethhdr *)(skb->data);
 	struct ptpv2_tstamp *origin_tstamp;
-	int ptp_offset = 0, udp_csum = 0;
+	bool udp_csum_crt = false;
+	unsigned int udphoff;
 	struct timespec64 ts;
+	int ptp_offset = 0;
+	__wsum skb_csum;
 	u64 iova;
 
 	if (unlikely(!skb_shinfo(skb)->gso_size &&
 		     (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))) {
-		if (unlikely(pfvf->flags & OTX2_FLAG_PTP_ONESTEP_SYNC)) {
-			if (otx2_ptp_is_sync(skb, &ptp_offset, &udp_csum)) {
-				origin_tstamp = (struct ptpv2_tstamp *)
-						((u8 *)skb->data + ptp_offset +
-						 PTP_SYNC_SEC_OFFSET);
-				ts = ns_to_timespec64(pfvf->ptp->tstamp);
-				origin_tstamp->seconds_msb = htons((ts.tv_sec >> 32) & 0xffff);
-				origin_tstamp->seconds_lsb = htonl(ts.tv_sec & 0xffffffff);
-				origin_tstamp->nanoseconds = htonl(ts.tv_nsec);
-				/* Point to correction field in PTP packet */
-				ptp_offset += 8;
+		if (unlikely(pfvf->flags & OTX2_FLAG_PTP_ONESTEP_SYNC &&
+			     otx2_ptp_is_sync(skb, &ptp_offset, &udp_csum_crt))) {
+			origin_tstamp = (struct ptpv2_tstamp *)
+					((u8 *)skb->data + ptp_offset +
+					 PTP_SYNC_SEC_OFFSET);
+			ts = ns_to_timespec64(pfvf->ptp->tstamp);
+			origin_tstamp->seconds_msb = htons((ts.tv_sec >> 32) & 0xffff);
+			origin_tstamp->seconds_lsb = htonl(ts.tv_sec & 0xffffffff);
+			origin_tstamp->nanoseconds = htonl(ts.tv_nsec);
+			/* Point to correction field in PTP packet */
+			ptp_offset += 8;
+
+			/* When user disables hw checksum, stack calculates the csum,
+			 * but it does not cover ptp timestamp which is added later.
+			 * Recalculate the checksum manually considering the timestamp.
+			 */
+			if (udp_csum_crt) {
+				struct udphdr *uh = udp_hdr(skb);
+
+				if (skb->ip_summed != CHECKSUM_PARTIAL && uh->check != 0) {
+					udphoff = skb_transport_offset(skb);
+					uh->check = 0;
+					skb_csum = skb_checksum(skb, udphoff, skb->len - udphoff,
+								0);
+					if (ntohs(eth->h_proto) == ETH_P_IPV6)
+						uh->check = csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
+									    &ipv6_hdr(skb)->daddr,
+									    skb->len - udphoff,
+									    ipv6_hdr(skb)->nexthdr,
+									    skb_csum);
+					else
+						uh->check = csum_tcpudp_magic(ip_hdr(skb)->saddr,
+									      ip_hdr(skb)->daddr,
+									      skb->len - udphoff,
+									      IPPROTO_UDP,
+									      skb_csum);
+				}
 			}
 		} else {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 		}
 		iova = sq->timestamps->iova + (sq->head * sizeof(u64));
 		otx2_sqe_add_mem(sq, offset, NIX_SENDMEMALG_E_SETTSTMP, iova,
-				 ptp_offset, pfvf->ptp->base_ns, udp_csum);
+				 ptp_offset, pfvf->ptp->base_ns, udp_csum_crt);
 	} else {
 		skb_tx_timestamp(skb);
 	}
-- 
2.39.2



