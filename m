Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2B843A02C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhJYT3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235297AbhJYT0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:26:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C72C3610EA;
        Mon, 25 Oct 2021 19:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189809;
        bh=dDFNmYnqmBuK3mo9ePkSyqJtnw43sKhDZ558/J8yPwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIRtE6R25V8sq3fi9ud+pp6hRLG2xQwgTNBKcPRx3TsDBxYnwrg+sxvV5JoOvBfNp
         f7CxyF0uXLYJKqog8Ded6V7UaPGcqxTPnYJmRqj9djzSMLywXKUoX+VGO8TBkaUW/y
         gHo8YSJdXsGNH0jdnNnJ5kFzNIjoP2mPvr0AQvg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/37] dma-debug: fix sg checks in debug_dma_map_sg()
Date:   Mon, 25 Oct 2021 21:14:30 +0200
Message-Id: <20211025190929.360415863@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

[ Upstream commit 293d92cbbd2418ca2ba43fed07f1b92e884d1c77 ]

The following warning occurred sporadically on s390:
DMA-API: nvme 0006:00:00.0: device driver maps memory from kernel text or rodata [addr=0000000048cc5e2f] [len=131072]
WARNING: CPU: 4 PID: 825 at kernel/dma/debug.c:1083 check_for_illegal_area+0xa8/0x138

It is a false-positive warning, due to broken logic in debug_dma_map_sg().
check_for_illegal_area() checks for overlay of sg elements with kernel text
or rodata. It is called with sg_dma_len(s) instead of s->length as
parameter. After the call to ->map_sg(), sg_dma_len() will contain the
length of possibly combined sg elements in the DMA address space, and not
the individual sg element length, which would be s->length.

The check will then use the physical start address of an sg element, and
add the DMA length for the overlap check, which could result in the false
warning, because the DMA length can be larger than the actual single sg
element length.

In addition, the call to check_for_illegal_area() happens in the iteration
over mapped_ents, which will not include all individual sg elements if
any of them were combined in ->map_sg().

Fix this by using s->length instead of sg_dma_len(s). Also put the call to
check_for_illegal_area() in a separate loop, iterating over all the
individual sg elements ("nents" instead of "mapped_ents").

While at it, as suggested by Robin Murphy, also move check_for_stack()
inside the new loop, as it is similarly concerned with validating the
individual sg elements.

Link: https://lore.kernel.org/lkml/20210705185252.4074653-1-gerald.schaefer@linux.ibm.com
Fixes: 884d05970bfb ("dma-debug: use sg_dma_len accessor")
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 3a2397444076..1c82b0d25498 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -1422,6 +1422,12 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 	if (unlikely(dma_debug_disabled()))
 		return;
 
+	for_each_sg(sg, s, nents, i) {
+		check_for_stack(dev, sg_page(s), s->offset);
+		if (!PageHighMem(sg_page(s)))
+			check_for_illegal_area(dev, sg_virt(s), s->length);
+	}
+
 	for_each_sg(sg, s, mapped_ents, i) {
 		entry = dma_entry_alloc();
 		if (!entry)
@@ -1437,12 +1443,6 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		entry->sg_call_ents   = nents;
 		entry->sg_mapped_ents = mapped_ents;
 
-		check_for_stack(dev, sg_page(s), s->offset);
-
-		if (!PageHighMem(sg_page(s))) {
-			check_for_illegal_area(dev, sg_virt(s), sg_dma_len(s));
-		}
-
 		check_sg_segment(dev, s);
 
 		add_dma_entry(entry);
-- 
2.33.0



