Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3808DB3C
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbfHNRHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbfHNRHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:07:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0346D2173E;
        Wed, 14 Aug 2019 17:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802457;
        bh=0Vp4UWZHnthpVFQDM/7UKuuzPZZ4o4H7ERW+zQ1yIRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRnzMx4VFb2rnnEY/y1aOoUhrE9qB3SGmagHwCGyJ68YOInKcvpmHvo5ol1Y7MtZp
         X5QEGYJPJeHDpa8leao+xbgDR2FBQNe7EP2TASqqrQ/MhiZkvvdcoUJyS0+4600jH/
         kNwTWh9fwVkvAQgv52IxaREX6uelopFcpsG6LkpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 116/144] s390/dma: provide proper ARCH_ZONE_DMA_BITS value
Date:   Wed, 14 Aug 2019 19:01:12 +0200
Message-Id: <20190814165804.781212788@linuxfoundation.org>
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

[ Upstream commit 1a2dcff881059dedc14fafc8a442664c8dbd60f1 ]

On s390 ZONE_DMA is up to 2G, i.e. ARCH_ZONE_DMA_BITS should be 31 bits.
The current value is 24 and makes __dma_direct_alloc_pages() take a
wrong turn first (but __dma_direct_alloc_pages() recovers then).

Let's correct ARCH_ZONE_DMA_BITS value and avoid wrong turns.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Petr Tesarik <ptesarik@suse.cz>
Fixes: c61e9637340e ("dma-direct: add support for allocation from ZONE_DMA and ZONE_DMA32")
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/page.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index a4d38092530ab..823578c6b9e2c 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -177,6 +177,8 @@ static inline int devmem_is_allowed(unsigned long pfn)
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
+#define ARCH_ZONE_DMA_BITS	31
+
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
-- 
2.20.1



