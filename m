Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715FD3C5408
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349423AbhGLH4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351795AbhGLHwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD322610D1;
        Mon, 12 Jul 2021 07:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076158;
        bh=8mzXLg0yDhF0iUgrxIe37YacjcJwVN75C/cMHvDwuOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PD9Pupd2friXq4+QvbSrUXFTSwuiADZT8GBoqXcwHGIrCdgmzplF0JV+IF/Rq6Vkv
         jcHyQX6GNJOveSrKZQKAZCoKuElrs0SqL3eCjQICI++tih6oqJwQBkY57fiMV7IfBv
         vPdfNq0ZJ5h7zGFrtaEImbTriUduYk6Gks0+ShUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 480/800] xsk: Fix missing validation for skb and unaligned mode
Date:   Mon, 12 Jul 2021 08:08:23 +0200
Message-Id: <20210712061018.249667084@linuxfoundation.org>
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 2f99619820c2269534eb2c0cde44870313c6d353 ]

Fix a missing validation of a Tx descriptor when executing in skb mode
and the umem is in unaligned mode. A descriptor could point to a
buffer straddling the end of the umem, thus effectively tricking the
kernel to read outside the allowed umem region. This could lead to a
kernel crash if that part of memory is not mapped.

In zero-copy mode, the descriptor validation code rejects such
descriptors by checking a bit in the DMA address that tells us if the
next page is physically contiguous or not. For the last page in the
umem, this bit is not set, therefore any descriptor pointing to a
packet straddling this last page boundary will be rejected. However,
the skb path does not use this bit since it copies out data and can do
so to two different pages. (It also does not have the array of DMA
address, so it cannot even store this bit.) The code just returned
that the packet is always physically contiguous. But this is
unfortunately also returned for the last page in the umem, which means
that packets that cross the end of the umem are being allowed, which
they should not be.

Fix this by introducing a check for this in the SKB path only, not
penalizing the zero-copy path.

Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20210617092255.3487-1-magnus.karlsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xsk_buff_pool.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index eaa8386dbc63..7a9a23e7a604 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -147,11 +147,16 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 {
 	bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
 
-	if (pool->dma_pages_cnt && cross_pg) {
+	if (likely(!cross_pg))
+		return false;
+
+	if (pool->dma_pages_cnt) {
 		return !(pool->dma_pages[addr >> PAGE_SHIFT] &
 			 XSK_NEXT_PG_CONTIG_MASK);
 	}
-	return false;
+
+	/* skb path */
+	return addr + len > pool->addrs_cnt;
 }
 
 static inline u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
-- 
2.30.2



