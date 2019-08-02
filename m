Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490E47FA0C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404071AbfHBNan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394150AbfHBNYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:24:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAF0320644;
        Fri,  2 Aug 2019 13:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752261;
        bh=dZeEXrzP2FGVY/ahJCjiRXYGxTXCSuAChtIkspnQDrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeEtWPhcRxc2NBKfoDV6iatO349wHPAp2ih1bpQDQm0jOGOEMAw68wYwfbDf0rtsi
         ZjaMLqk2/hMqokDP/Tho9rxLFy4FRVKpmcxPWRpnDhrXGI5tBACanWJbTKvFsVKSN2
         w82zzR48avbPVT1uCURZD85MwM39sRHX38b+qdfY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Petr Tesarik <ptesarik@suse.cz>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 42/42] s390/dma: provide proper ARCH_ZONE_DMA_BITS value
Date:   Fri,  2 Aug 2019 09:23:02 -0400
Message-Id: <20190802132302.13537-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132302.13537-1-sashal@kernel.org>
References: <20190802132302.13537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

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
index 41e3908b397f8..0d753291c43c0 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -176,6 +176,8 @@ static inline int devmem_is_allowed(unsigned long pfn)
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
+#define ARCH_ZONE_DMA_BITS	31
+
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
-- 
2.20.1

