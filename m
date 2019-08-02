Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3837F858
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393185AbfHBNTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731146AbfHBNTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:19:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AC9B2087C;
        Fri,  2 Aug 2019 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564751993;
        bh=kXFROHAYkXRIULUzuGLUVrpHYOTI4dMpB7Q5h8lnU3c=;
        h=From:To:Cc:Subject:Date:From;
        b=h7YmwDd9mlv87T7+94X0HrK0Gz57lzDWJYqXJlFqId3Q+Sos/zLMk4TyeR3PtSVk9
         5mhZBiLCBrQIe3ICyujYYS/GPK1mYkh1q/16l9Vv/Dua6r/TbU88gYffLb6sJZg71B
         +ZQfN4YqZqmc94pcDrBjguwh2iX1QsNM5ByWDZi4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Zorro Lang <zlang@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.2 01/76] powerpc: fix off by one in max_zone_pfn initialization for ZONE_DMA
Date:   Fri,  2 Aug 2019 09:18:35 -0400
Message-Id: <20190802131951.11600-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

[ Upstream commit 03800e0526ee25ed7c843ca1e57b69ac2a5af642 ]

25078dc1f74be16b858e914f52cc8f4d03c2271a first introduced an off by
one error in the ZONE_DMA initialization of PPC_BOOK3E_64=y and since
9739ab7eda459f0669ec9807e0d9be5020bab88c the off by one applies to
PPC32=y too. This simply corrects the off by one and should resolve
crashes like below:

[   65.179101] page 0x7fff outside node 0 zone DMA [ 0x0 - 0x7fff ]

Unfortunately in various MM places "max" means a non inclusive end of
range. free_area_init_nodes max_zone_pfn parameter is one case and
MAX_ORDER is another one (unrelated) that comes by memory.

Reported-by: Zorro Lang <zlang@redhat.com>
Fixes: 25078dc1f74b ("powerpc: use mm zones more sensibly")
Fixes: 9739ab7eda45 ("powerpc: enable a 30-bit ZONE_DMA for 32-bit pmac")
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190625141727.2883-1-aarcange@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 2540d3b2588c3..2eda1ec36f552 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -249,7 +249,7 @@ void __init paging_init(void)
 
 #ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA]	= min(max_low_pfn,
-			((1UL << ARCH_ZONE_DMA_BITS) - 1) >> PAGE_SHIFT);
+				      1UL << (ARCH_ZONE_DMA_BITS - PAGE_SHIFT));
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
-- 
2.20.1

