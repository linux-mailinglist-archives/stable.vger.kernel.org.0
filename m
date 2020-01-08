Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CA2134BA9
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgAHTqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43372 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728502AbgAHTqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:00 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-0006nj-CV; Wed, 08 Jan 2020 19:45:57 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHA-007dka-Ul; Wed, 08 Jan 2020 19:45:56 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 08 Jan 2020 19:43:00 +0000
Message-ID: <lsq.1578512578.332359728@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 02/63] net: qlogic: Fix error paths in
 ql_alloc_large_buffers()
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit cad46039e4c99812db067c8ac22a864960e7acc4 upstream.

ql_alloc_large_buffers() has the usual RX buffer allocation
loop where it allocates skbs and maps them for DMA.  It also
treats failure as a fatal error.

There are (at least) three bugs in the error paths:

1. ql_free_large_buffers() assumes that the lrg_buf[] entry for the
first buffer that couldn't be allocated will have .skb == NULL.
But the qla_buf[] array is not zero-initialised.

2. ql_free_large_buffers() DMA-unmaps all skbs in lrg_buf[].  This is
incorrect for the last allocated skb, if DMA mapping failed.

3. Commit 1acb8f2a7a9f ("net: qlogic: Fix memory leak in
ql_alloc_large_buffers") added a direct call to dev_kfree_skb_any()
after the skb is recorded in lrg_buf[], so ql_free_large_buffers()
will double-free it.

The bugs are somewhat inter-twined, so fix them all at once:

* Clear each entry in qla_buf[] before attempting to allocate
  an skb for it.  This goes half-way to fixing bug 1.
* Set the .skb field only after the skb is DMA-mapped.  This
  fixes the rest.

Fixes: 1357bfcf7106 ("qla3xxx: Dynamically size the rx buffer queue ...")
Fixes: 0f8ab89e825f ("qla3xxx: Check return code from pci_map_single() ...")
Fixes: 1acb8f2a7a9f ("net: qlogic: Fix memory leak in ql_alloc_large_buffers")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2758,6 +2758,9 @@ static int ql_alloc_large_buffers(struct
 	int err;
 
 	for (i = 0; i < qdev->num_large_buffers; i++) {
+		lrg_buf_cb = &qdev->lrg_buf[i];
+		memset(lrg_buf_cb, 0, sizeof(struct ql_rcv_buf_cb));
+
 		skb = netdev_alloc_skb(qdev->ndev,
 				       qdev->lrg_buffer_len);
 		if (unlikely(!skb)) {
@@ -2768,11 +2771,7 @@ static int ql_alloc_large_buffers(struct
 			ql_free_large_buffers(qdev);
 			return -ENOMEM;
 		} else {
-
-			lrg_buf_cb = &qdev->lrg_buf[i];
-			memset(lrg_buf_cb, 0, sizeof(struct ql_rcv_buf_cb));
 			lrg_buf_cb->index = i;
-			lrg_buf_cb->skb = skb;
 			/*
 			 * We save some space to copy the ethhdr from first
 			 * buffer
@@ -2794,6 +2793,7 @@ static int ql_alloc_large_buffers(struct
 				return -ENOMEM;
 			}
 
+			lrg_buf_cb->skb = skb;
 			dma_unmap_addr_set(lrg_buf_cb, mapaddr, map);
 			dma_unmap_len_set(lrg_buf_cb, maplen,
 					  qdev->lrg_buffer_len -

