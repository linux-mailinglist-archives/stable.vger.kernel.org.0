Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0BA8D8F7
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbfHNREE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729112AbfHNRED (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEDC721744;
        Wed, 14 Aug 2019 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802243;
        bh=TEkliHrCqmBMsOtkH+iKXQ2HGKVEK/CT4G9DrCRz0t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvB2lUfewvo7jdNlIS2lQTIi8Og6nFbrTSpJnGWuZnXYVJUHJKy9mrLcMDu6Q018Z
         AckZ1ZubqzQZQ04+/4UAXkTj7FloaiU9cg0+snz+XicNhy+8YNHmT+J78yXIWvrdR7
         462etl6Wr3GLwTqzCHXb9iJ/o5Nv26P8flXwyygI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zorro Lang <zlang@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 049/144] powerpc: fix off by one in max_zone_pfn initialization for ZONE_DMA
Date:   Wed, 14 Aug 2019 19:00:05 +0200
Message-Id: <20190814165801.880757406@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



