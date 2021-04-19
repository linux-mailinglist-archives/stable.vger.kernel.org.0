Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3BF364305
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbhDSNNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239479AbhDSNL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E472E613B4;
        Mon, 19 Apr 2021 13:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837888;
        bh=Be/wPIhjYoF25nMcPA+zAFHvrdbPff3ORCpp9wdeBPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOVUF22UIVsGjg7uBCRpoLefPvG9UoQePzTcjmgX1kgdtqYin6oLRNvsxY0lgkI3K
         NXX7pZXyBlPIz2nDChKFKKaQiGPxzqmAP0NYaMkrIyY7DXqLg5U9YbGwHHQpuQe5k4
         o3D8Uz3Apnt/Wf7OmyzeQl53pA/z5Nct4zsu8Fd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        Lijun Pan <lijunp213@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 090/122] ibmvnic: correctly use dev_consume/free_skb_irq
Date:   Mon, 19 Apr 2021 15:06:10 +0200
Message-Id: <20210419130533.213256135@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <lijunp213@gmail.com>

commit ca09bf7bb109a37a7ff05f230bb3fa3627e6625f upstream.

It is more correct to use dev_kfree_skb_irq when packets are dropped,
and to use dev_consume_skb_irq when packets are consumed.

Fixes: 0d973388185d ("ibmvnic: Introduce xmit_more support using batched subCRQ hcalls")
Suggested-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3274,9 +3274,6 @@ restart_loop:
 
 		next = ibmvnic_next_scrq(adapter, scrq);
 		for (i = 0; i < next->tx_comp.num_comps; i++) {
-			if (next->tx_comp.rcs[i])
-				dev_err(dev, "tx error %x\n",
-					next->tx_comp.rcs[i]);
 			index = be32_to_cpu(next->tx_comp.correlators[i]);
 			if (index & IBMVNIC_TSO_POOL_MASK) {
 				tx_pool = &adapter->tso_pool[pool];
@@ -3290,7 +3287,13 @@ restart_loop:
 			num_entries += txbuff->num_entries;
 			if (txbuff->skb) {
 				total_bytes += txbuff->skb->len;
-				dev_consume_skb_irq(txbuff->skb);
+				if (next->tx_comp.rcs[i]) {
+					dev_err(dev, "tx error %x\n",
+						next->tx_comp.rcs[i]);
+					dev_kfree_skb_irq(txbuff->skb);
+				} else {
+					dev_consume_skb_irq(txbuff->skb);
+				}
 				txbuff->skb = NULL;
 			} else {
 				netdev_warn(adapter->netdev,


