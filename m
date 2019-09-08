Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE29AACE4A
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbfIHM5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731131AbfIHMsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:48:43 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49EAE218AC;
        Sun,  8 Sep 2019 12:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946922;
        bh=P6zxFv9o4/b1cOgLWIe7mJyfenxsoJ4ZJtDeh7Q9hrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLEnf3vdNOA7QCG2fI5W3WvrEF6R9MWiiaF+rc+qcmfkuSMbzpkFxy7sNvwUnLVcN
         Q+NgKPwZ2zne/Gt70R7g4/Fld5F3w3HI2okubfpYISCgCv7YEOpx5pPt4576GtWBBE
         Yn2aHa5apQ1YeXxDTkw+oio6vhB5D8Glg90zY54I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        "Devesh K. Singh" <devesh_singh@in.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/57] ibmvnic: Unmap DMA address of TX descriptor buffers after use
Date:   Sun,  8 Sep 2019 13:41:58 +0100
Message-Id: <20190908121140.554764096@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 80f0fe0934cd3daa13a5e4d48a103f469115b160 ]

There's no need to wait until a completion is received to unmap
TX descriptor buffers that have been passed to the hypervisor.
Instead unmap it when the hypervisor call has completed. This patch
avoids the possibility that a buffer will not be unmapped because
a TX completion is lost or mishandled.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Tested-by: Devesh K. Singh <devesh_singh@in.ibm.com>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0ae43d27cdcff..255de7d68cd33 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1586,6 +1586,8 @@ static int ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		lpar_rc = send_subcrq_indirect(adapter, handle_array[queue_num],
 					       (u64)tx_buff->indir_dma,
 					       (u64)num_entries);
+		dma_unmap_single(dev, tx_buff->indir_dma,
+				 sizeof(tx_buff->indir_arr), DMA_TO_DEVICE);
 	} else {
 		tx_buff->num_entries = num_entries;
 		lpar_rc = send_subcrq(adapter, handle_array[queue_num],
@@ -2747,7 +2749,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 	union sub_crq *next;
 	int index;
 	int i, j;
-	u8 *first;
 
 restart_loop:
 	while (pending_scrq(adapter, scrq)) {
@@ -2777,14 +2778,6 @@ restart_loop:
 
 				txbuff->data_dma[j] = 0;
 			}
-			/* if sub_crq was sent indirectly */
-			first = &txbuff->indir_arr[0].generic.first;
-			if (*first == IBMVNIC_CRQ_CMD) {
-				dma_unmap_single(dev, txbuff->indir_dma,
-						 sizeof(txbuff->indir_arr),
-						 DMA_TO_DEVICE);
-				*first = 0;
-			}
 
 			if (txbuff->last_frag) {
 				dev_kfree_skb_any(txbuff->skb);
-- 
2.20.1



