Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF60198F6F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbgCaJDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730768AbgCaJDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:03:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC71D208E0;
        Tue, 31 Mar 2020 09:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645399;
        bh=N4lza5PsPJ6ir0AzvN2vRfEMehU1QEbwTNi/AXOw9us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXNBVGRNRX7/wXQmcfXPbK3wo5GoaDOHaDf3LQGtO3tl3fmONM8uvy1JNjZlVr7uD
         3zhoEkTD81ztfmkxGm1L4QtZuFb1t7V+AQulQyzZ1mDD3CXnmzd6KSQ5w0NFt/Vzwf
         m5mMfDliBILLpzkI3Po/f+FbxShsnCUMGQIwX7rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 042/170] bnxt_en: Fix Priority Bytes and Packets counters in ethtool -S.
Date:   Tue, 31 Mar 2020 10:57:36 +0200
Message-Id: <20200331085428.908015722@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit a24ec3220f369aa0b94c863b6b310685a727151c ]

There is an indexing bug in determining these ethtool priority
counters.  Instead of using the queue ID to index, we need to
normalize by modulo 10 to get the index.  This index is then used
to obtain the proper CoS queue counter.  Rename bp->pri2cos to
bp->pri2cos_idx to make this more clear.

Fixes: e37fed790335 ("bnxt_en: Add ethtool -S priority counters.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |   10 +++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |    8 ++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7406,14 +7406,22 @@ static int bnxt_hwrm_port_qstats_ext(str
 		pri2cos = &resp2->pri0_cos_queue_id;
 		for (i = 0; i < 8; i++) {
 			u8 queue_id = pri2cos[i];
+			u8 queue_idx;
 
+			/* Per port queue IDs start from 0, 10, 20, etc */
+			queue_idx = queue_id % 10;
+			if (queue_idx > BNXT_MAX_QUEUE) {
+				bp->pri2cos_valid = false;
+				goto qstats_done;
+			}
 			for (j = 0; j < bp->max_q; j++) {
 				if (bp->q_ids[j] == queue_id)
-					bp->pri2cos[i] = j;
+					bp->pri2cos_idx[i] = queue_idx;
 			}
 		}
 		bp->pri2cos_valid = 1;
 	}
+qstats_done:
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
 }
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1714,7 +1714,7 @@ struct bnxt {
 	u16			fw_rx_stats_ext_size;
 	u16			fw_tx_stats_ext_size;
 	u16			hw_ring_stats_size;
-	u8			pri2cos[8];
+	u8			pri2cos_idx[8];
 	u8			pri2cos_valid;
 
 	u16			hwrm_max_req_len;
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -589,25 +589,25 @@ skip_ring_stats:
 		if (bp->pri2cos_valid) {
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_rx_bytes_pri_arr[i].base_off +
-					 bp->pri2cos[i];
+					 bp->pri2cos_idx[i];
 
 				buf[j] = le64_to_cpu(*(rx_port_stats_ext + n));
 			}
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_rx_pkts_pri_arr[i].base_off +
-					 bp->pri2cos[i];
+					 bp->pri2cos_idx[i];
 
 				buf[j] = le64_to_cpu(*(rx_port_stats_ext + n));
 			}
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_tx_bytes_pri_arr[i].base_off +
-					 bp->pri2cos[i];
+					 bp->pri2cos_idx[i];
 
 				buf[j] = le64_to_cpu(*(tx_port_stats_ext + n));
 			}
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_tx_pkts_pri_arr[i].base_off +
-					 bp->pri2cos[i];
+					 bp->pri2cos_idx[i];
 
 				buf[j] = le64_to_cpu(*(tx_port_stats_ext + n));
 			}


