Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A35227C73E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgI2Lwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731079AbgI2Lrg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81AB4206F7;
        Tue, 29 Sep 2020 11:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380056;
        bh=0gpkqYr6zeW+XZmL6JgbcEWeivALiNbg7XH8JSez6cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYYPpNHyhQ+IPrObaAXa6hU8zj8pWaULCW4zibJ+j0fCWjND5CxQ+C7jYL7IT5Wm8
         vNQ3Rzb+JCNela2CyNUE9FEH/00wHddW/7fN3CcHpR4rnTg+DBv3btK0io9GC8KrjM
         oYNh3x7fKxxLTbCpvF+LLK8+S+1cLaaLQ7F5rW5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ciara Loftus <ciara.loftus@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 47/99] xsk: Fix number of pinned pages/umem size discrepancy
Date:   Tue, 29 Sep 2020 13:01:30 +0200
Message-Id: <20200929105932.042990534@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 2b1667e54caf95e1e4249d9068eea7a3089a5229 ]

For AF_XDP sockets, there was a discrepancy between the number of of
pinned pages and the size of the umem region.

The size of the umem region is used to validate the AF_XDP descriptor
addresses. The logic that pinned the pages covered by the region only
took whole pages into consideration, creating a mismatch between the
size and pinned pages. A user could then pass AF_XDP addresses outside
the range of pinned pages, but still within the size of the region,
crashing the kernel.

This change correctly calculates the number of pages to be
pinned. Further, the size check for the aligned mode is
simplified. Now the code simply checks if the size is divisible by the
chunk size.

Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")
Reported-by: Ciara Loftus <ciara.loftus@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: Ciara Loftus <ciara.loftus@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20200910075609.7904-1-bjorn.topel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index e97db37354e4f..b010bfde01490 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -303,10 +303,10 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
 
 static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 {
+	u32 npgs_rem, chunk_size = mr->chunk_size, headroom = mr->headroom;
 	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
-	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
 	u64 npgs, addr = mr->addr, size = mr->len;
-	unsigned int chunks, chunks_per_page;
+	unsigned int chunks, chunks_rem;
 	int err;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
@@ -336,19 +336,18 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if ((addr + size) < addr)
 		return -EINVAL;
 
-	npgs = size >> PAGE_SHIFT;
+	npgs = div_u64_rem(size, PAGE_SIZE, &npgs_rem);
+	if (npgs_rem)
+		npgs++;
 	if (npgs > U32_MAX)
 		return -EINVAL;
 
-	chunks = (unsigned int)div_u64(size, chunk_size);
+	chunks = (unsigned int)div_u64_rem(size, chunk_size, &chunks_rem);
 	if (chunks == 0)
 		return -EINVAL;
 
-	if (!unaligned_chunks) {
-		chunks_per_page = PAGE_SIZE / chunk_size;
-		if (chunks < chunks_per_page || chunks % chunks_per_page)
-			return -EINVAL;
-	}
+	if (!unaligned_chunks && chunks_rem)
+		return -EINVAL;
 
 	if (headroom >= chunk_size - XDP_PACKET_HEADROOM)
 		return -EINVAL;
-- 
2.25.1



