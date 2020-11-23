Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E822C07D4
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733242AbgKWMoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733234AbgKWMoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC14720857;
        Mon, 23 Nov 2020 12:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135472;
        bh=oawkLqD5w9DcatLHuTo+BQpwvuqyMt53A5nULE1MhUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNAKKyLISpvWQ78qyOw30ULQ7OAhov/Y7VXjwi4K9sU1gvJwU8ttPC3ql3fvnOihz
         eaCCprPuyiu7egShhylXWYpPJK3wAslDJflZa1ct7O5NyPNZIrH2k9cDm/pD1uScdY
         O92tbvKLeBHfIUr0ySAepxCC0zxnMtNfJ59fI75s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 051/252] net: mvneta: fix possible memory leak in mvneta_swbm_add_rx_fragment
Date:   Mon, 23 Nov 2020 13:20:01 +0100
Message-Id: <20201123121838.052032966@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 9c79a8ab5f124db01eb1d7287454a702f0d4252f ]

Recycle the page running page_pool_put_full_page() in
mvneta_swbm_add_rx_fragment routine when the last descriptor
contains just the FCS or if the received packet contains more than
MAX_SKB_FRAGS fragments

Fixes: ca0e014609f0 ("net: mvneta: move skb build after descriptors processing")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/df6a2bad70323ee58d3901491ada31c1ca2a40b9.1605291228.git.lorenzo@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2287,6 +2287,7 @@ mvneta_swbm_add_rx_fragment(struct mvnet
 	dma_sync_single_for_cpu(dev->dev.parent,
 				rx_desc->buf_phys_addr,
 				len, dma_dir);
+	rx_desc->buf_phys_addr = 0;
 
 	if (data_len > 0 && sinfo->nr_frags < MAX_SKB_FRAGS) {
 		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags];
@@ -2295,8 +2296,8 @@ mvneta_swbm_add_rx_fragment(struct mvnet
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
 		sinfo->nr_frags++;
-
-		rx_desc->buf_phys_addr = 0;
+	} else {
+		page_pool_put_full_page(rxq->page_pool, page, true);
 	}
 	*size -= len;
 }


