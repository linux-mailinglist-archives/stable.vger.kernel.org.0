Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEE53C53B2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348446AbhGLHzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350601AbhGLHvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D67261C17;
        Mon, 12 Jul 2021 07:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075990;
        bh=4q3rRfgJB86VpIvEPDFJXatCsw9NkNuUN4ZprX67v2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDt9qHFu+bmSGy3aQSUqorTyXoHkczqNfKuQw/fXbMOpkNy/EJMVvprC4F0I4JJzE
         sONHCf8MvOcZkseILCj4NeYAxrknKNiZXhlp15Jb5U/qQTLASUGJh2b9wgbWzdQSrL
         PcDnQkw4oGUSiezolPhuGMCQQ7Vnawz2i25mUOXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 451/800] net: stmmac: Fix potential integer overflow
Date:   Mon, 12 Jul 2021 08:07:54 +0200
Message-Id: <20210712061015.111129603@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@linux.intel.com>

[ Upstream commit 52e597d3e2e6e5bfce47559eb22b955ac17b3826 ]

The commit d96febedfde2 ("net: stmmac: arrange Tx tail pointer update
to stmmac_flush_tx_descriptors") introduced the following coverity
warning:-

  1. Unintentional integer overflow (OVERFLOW_BEFORE_WIDEN)
     overflow_before_widen: Potentially overflowing expression
     'tx_q->cur_tx * desc_size' with type 'unsigned int' (32 bits,
     unsigned) is evaluated using 32-bit arithmetic, and then used in a
     context that expects an expression of type dma_addr_t (64 bits,
     unsigned).

Fixed this by assigning tx_tail_addr to dma_addr_t type, as dma_addr_t
datatype is decided by CONFIG_ARCH_DMA_ADDR_T_64_BIT.

Fixes: d96febedfde2 ("net: stmmac: arrange Tx tail pointer update to stmmac_flush_tx_descriptors")
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index b6cd43eda7ac..8aa55612d094 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -75,7 +75,7 @@ struct stmmac_tx_queue {
 	unsigned int cur_tx;
 	unsigned int dirty_tx;
 	dma_addr_t dma_tx_phy;
-	u32 tx_tail_addr;
+	dma_addr_t tx_tail_addr;
 	u32 mss;
 };
 
-- 
2.30.2



