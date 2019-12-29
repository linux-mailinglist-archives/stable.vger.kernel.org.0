Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E227B12C76C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbfL2R31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:29:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbfL2R31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:29:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B566620722;
        Sun, 29 Dec 2019 17:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640566;
        bh=yUrwpv0lLsyDAQ/9yE40ZB0yyr49ozxNiQrmwjgfLZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMrbMYHSGzfT6LbSdIFxxlg9slZLLemdd9jppFKddOGHyZGDgUNVwhnF88dUMCLu6
         DnM0ncI/QzlFfnKpTHCUqasbDDE3/0Vw562v5AZQz9UhvxLjBsPgdvou+rARUIjJQc
         gUUNgLPkNdI1Nk8UjWTgfKQ7ONVJVMiTHlOigPsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 008/219] net: qlogic: Fix error paths in ql_alloc_large_buffers()
Date:   Sun, 29 Dec 2019 18:16:50 +0100
Message-Id: <20191229162510.164175872@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit cad46039e4c99812db067c8ac22a864960e7acc4 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2757,6 +2757,9 @@ static int ql_alloc_large_buffers(struct
 	int err;
 
 	for (i = 0; i < qdev->num_large_buffers; i++) {
+		lrg_buf_cb = &qdev->lrg_buf[i];
+		memset(lrg_buf_cb, 0, sizeof(struct ql_rcv_buf_cb));
+
 		skb = netdev_alloc_skb(qdev->ndev,
 				       qdev->lrg_buffer_len);
 		if (unlikely(!skb)) {
@@ -2767,11 +2770,7 @@ static int ql_alloc_large_buffers(struct
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
@@ -2793,6 +2792,7 @@ static int ql_alloc_large_buffers(struct
 				return -ENOMEM;
 			}
 
+			lrg_buf_cb->skb = skb;
 			dma_unmap_addr_set(lrg_buf_cb, mapaddr, map);
 			dma_unmap_len_set(lrg_buf_cb, maplen,
 					  qdev->lrg_buffer_len -


