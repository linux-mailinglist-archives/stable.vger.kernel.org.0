Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674143C53C7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348703AbhGLHz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350683AbhGLHvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5982461450;
        Mon, 12 Jul 2021 07:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076057;
        bh=iyJJED7STGiKbuwD/N9uBYcsecrSk4aVuOy+pHuJ+58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Stt+LbMJsvV3LlJH0cVcT0TITIXC6ZIzFHLJBouiGjOrF7JF+gokKiYfVT8gEcyLt
         TGIhIPGxJ4t584GfOAy/83OpltwjTXZUHoyG4Khhnrk8Ig0mk6liT8TPnXKRoVUMrL
         h9taPXKFUzoiU+E5eoxVHL/tTRYg3eKhj+0pF9xQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 481/800] xsk: Fix broken Tx ring validation
Date:   Mon, 12 Jul 2021 08:08:24 +0200
Message-Id: <20210712061018.362462713@linuxfoundation.org>
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

[ Upstream commit f654fae47e83e56b454fbbfd0af0a4f232e356d6 ]

Fix broken Tx ring validation for AF_XDP. The commit under the Fixes
tag, fixed an off-by-one error in the validation but introduced
another error. Descriptors are now let through even if they straddle a
chunk boundary which they are not allowed to do in aligned mode. Worse
is that they are let through even if they straddle the end of the umem
itself, tricking the kernel to read data outside the allowed umem
region which might or might not be mapped at all.

Fix this by reintroducing the old code, but subtract the length by one
to fix the off-by-one error that the original patch was
addressing. The test chunk != chunk_end makes sure packets do not
straddle chunk boundraries. Note that packets of zero length are
allowed in the interface, therefore the test if the length is
non-zero.

Fixes: ac31565c2193 ("xsk: Fix for xp_aligned_validate_desc() when len == chunk_size")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20210618075805.14412-1-magnus.karlsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_queue.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 9d2a89d793c0..9ae13cccfb28 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -128,12 +128,15 @@ static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
 static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
 					    struct xdp_desc *desc)
 {
-	u64 chunk;
-
-	if (desc->len > pool->chunk_size)
-		return false;
+	u64 chunk, chunk_end;
 
 	chunk = xp_aligned_extract_addr(pool, desc->addr);
+	if (likely(desc->len)) {
+		chunk_end = xp_aligned_extract_addr(pool, desc->addr + desc->len - 1);
+		if (chunk != chunk_end)
+			return false;
+	}
+
 	if (chunk >= pool->addrs_cnt)
 		return false;
 
-- 
2.30.2



