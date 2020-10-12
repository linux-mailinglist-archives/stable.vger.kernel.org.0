Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC3328B873
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389808AbgJLNw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731834AbgJLNsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA58D22244;
        Mon, 12 Oct 2020 13:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510434;
        bh=yBB+S97Fcrnu6+v1tUIYYTSfGuSJjd3BkVEvsyRp9uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZ+Yw0WbZFlgjHHYsvWBv/yx+SV7z/AM/sRdICDgvzvk/O7JRsRi3kA77YlFnhT+Y
         gNiRXRdGDCTggrJlow9yiVsYKimPoBqkgJLQ/uL1HGED7cdpqzTTOqR8LEQpii5uuS
         t2zXi+meGCgzgJsnejXoloG4OtLqAVmYpGje3kOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 098/124] net: mvneta: fix double free of txq->buf
Date:   Mon, 12 Oct 2020 15:31:42 +0200
Message-Id: <20201012133151.603817911@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit f4544e5361da5050ff5c0330ceea095cb5dbdd72 ]

clang static analysis reports this problem:

drivers/net/ethernet/marvell/mvneta.c:3465:2: warning:
  Attempt to free released memory
        kfree(txq->buf);
        ^~~~~~~~~~~~~~~

When mvneta_txq_sw_init() fails to alloc txq->tso_hdrs,
it frees without poisoning txq->buf.  The error is caught
in the mvneta_setup_txqs() caller which handles the error
by cleaning up all of the txqs with a call to
mvneta_txq_sw_deinit which also frees txq->buf.

Since mvneta_txq_sw_deinit is a general cleaner, all of the
partial cleaning in mvneta_txq_sw_deinit()'s error handling
is not needed.

Fixes: 2adb719d74f6 ("net: mvneta: Implement software TSO")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7d5d9d34f4e47..69a234e83b8b7 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3372,24 +3372,15 @@ static int mvneta_txq_sw_init(struct mvneta_port *pp,
 	txq->last_desc = txq->size - 1;
 
 	txq->buf = kmalloc_array(txq->size, sizeof(*txq->buf), GFP_KERNEL);
-	if (!txq->buf) {
-		dma_free_coherent(pp->dev->dev.parent,
-				  txq->size * MVNETA_DESC_ALIGNED_SIZE,
-				  txq->descs, txq->descs_phys);
+	if (!txq->buf)
 		return -ENOMEM;
-	}
 
 	/* Allocate DMA buffers for TSO MAC/IP/TCP headers */
 	txq->tso_hdrs = dma_alloc_coherent(pp->dev->dev.parent,
 					   txq->size * TSO_HEADER_SIZE,
 					   &txq->tso_hdrs_phys, GFP_KERNEL);
-	if (!txq->tso_hdrs) {
-		kfree(txq->buf);
-		dma_free_coherent(pp->dev->dev.parent,
-				  txq->size * MVNETA_DESC_ALIGNED_SIZE,
-				  txq->descs, txq->descs_phys);
+	if (!txq->tso_hdrs)
 		return -ENOMEM;
-	}
 
 	/* Setup XPS mapping */
 	if (txq_number > 1)
-- 
2.25.1



