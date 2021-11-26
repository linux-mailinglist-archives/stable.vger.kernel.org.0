Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B52B45E678
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344807AbhKZDVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 22:21:00 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:55216 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234851AbhKZDS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 22:18:59 -0500
X-UUID: 2ef8e41a65c6410096f01756b76319a9-20211126
X-UUID: 2ef8e41a65c6410096f01756b76319a9-20211126
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <guangming.cao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1675055840; Fri, 26 Nov 2021 11:15:41 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 26 Nov 2021 11:15:40 +0800
Received: from mszswglt01.gcn.mediatek.inc (10.16.20.20) by
 mtkcas11.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Fri, 26 Nov 2021 11:15:40 +0800
From:   <guangming.cao@mediatek.com>
To:     <robin.murphy@arm.com>
CC:     <Brian.Starkey@arm.com>, <benjamin.gaignard@linaro.org>,
        <christian.koenig@amd.com>, <dri-devel@lists.freedesktop.org>,
        <guangming.cao@mediatek.com>, <john.stultz@linaro.org>,
        <labbott@redhat.com>, <linaro-mm-sig@lists.linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <lmark@codeaurora.org>,
        <matthias.bgg@gmail.com>, <sumit.semwal@linaro.org>,
        <wsd_upstream@mediatek.com>, <stable@vger.kernel.org>,
        Guangming <Guangming.Cao@mediatek.com>
Subject: [PATCH v3] dma-buf: system_heap: Use 'for_each_sgtable_sg' in pages free flow
Date:   Fri, 26 Nov 2021 11:16:05 +0800
Message-ID: <20211126031605.81436-1-guangming.cao@mediatek.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <eb6cc56d-cbe0-73d5-d4f5-0aa2b76272a4@arm.com>
References: <eb6cc56d-cbe0-73d5-d4f5-0aa2b76272a4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangming <Guangming.Cao@mediatek.com>

For previous version, it uses 'sg_table.nent's to traverse sg_table in pages
free flow.
However, 'sg_table.nents' is reassigned in 'dma_map_sg', it means the number of
created entries in the DMA adderess space.
So, use 'sg_table.nents' in pages free flow will case some pages can't be freed.

Here we should use sg_table.orig_nents to free pages memory, but use the
sgtable helper 'for each_sgtable_sg'(, instead of the previous rather common
helper 'for_each_sg' which maybe cause memory leak) is much better.

Fixes: d963ab0f15fb0 ("dma-buf: system_heap: Allocate higher order pages if available")

Signed-off-by: Guangming <Guangming.Cao@mediatek.com>
---
 drivers/dma-buf/heaps/system_heap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index 23a7e74ef966..8660508f3684 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -289,7 +289,7 @@ static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
 	int i;
 
 	table = &buffer->sg_table;
-	for_each_sg(table->sgl, sg, table->nents, i) {
+	for_each_sgtable_sg(table, sg, i) {
 		struct page *page = sg_page(sg);
 
 		__free_pages(page, compound_order(page));
-- 
2.17.1

