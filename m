Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58293383036
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbhEQOZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239232AbhEQOW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:22:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 400EF6145D;
        Mon, 17 May 2021 14:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260723;
        bh=Jr74mpcAFGs90GVsKiJjiazXqFTEMwCXJ3RvrPOOb8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pA9Am9ELzaUQ3spJaHQc2WuxofPxSmoUIIi5kazAgWc9bmZnW0hz0JoIV+qzNv+Dr
         ZfnTLd1hPDXFoNqMX/AterOaBkfXOGLxt8H8ooVVEq8edUW2sNNerAkiAc2n9Lh9h5
         95YhdPFC+EK2TacCwnMiCSAExDsVgejbrGJgyNfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 210/363] xsk: Fix for xp_aligned_validate_desc() when len == chunk_size
Date:   Mon, 17 May 2021 16:01:16 +0200
Message-Id: <20210517140309.680699318@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit ac31565c21937eee9117e43c9cd34f557f6f1cb8 ]

When desc->len is equal to chunk_size, it is legal. But when the
xp_aligned_validate_desc() got chunk_end from desc->addr + desc->len
pointing to the next chunk during the check, it caused the check to
fail.

This problem was first introduced in bbff2f321a86 ("xsk: new descriptor
addressing scheme"). Later in 2b43470add8c ("xsk: Introduce AF_XDP buffer
allocation API") this piece of code was moved into the new function called
xp_aligned_validate_desc(). This function was then moved into xsk_queue.h
via 26062b185eee ("xsk: Explicitly inline functions and move definitions").

Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20210428094424.54435-1-xuanzhuo@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_queue.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 2823b7c3302d..40f359bf2044 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -128,13 +128,12 @@ static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
 static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
 					    struct xdp_desc *desc)
 {
-	u64 chunk, chunk_end;
+	u64 chunk;
 
-	chunk = xp_aligned_extract_addr(pool, desc->addr);
-	chunk_end = xp_aligned_extract_addr(pool, desc->addr + desc->len);
-	if (chunk != chunk_end)
+	if (desc->len > pool->chunk_size)
 		return false;
 
+	chunk = xp_aligned_extract_addr(pool, desc->addr);
 	if (chunk >= pool->addrs_cnt)
 		return false;
 
-- 
2.30.2



