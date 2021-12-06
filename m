Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9822A469EFF
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391199AbhLFPpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43242 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386590AbhLFP0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:26:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45CBF6130D;
        Mon,  6 Dec 2021 15:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277DBC341C1;
        Mon,  6 Dec 2021 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804197;
        bh=/45T2yyCka3M+RblEsH3cJJq2gT7EEw5uPA5HPf7I0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCm151UuoIOpWRtrs+ujb6t+pS/lmCkCH3LQ04U3p3o1EGanZBJMTz/lMRtC22p+M
         44oP6UZNQUzTBkhZY/5cN7New2ekCVIAvlFggJoEhiDQ5Ekx84IS+Hng2ai9ztuIZS
         Ns+oYAOSe1glrvTfj0kO1B8fHOs4kjk6WAxwUDlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangming <Guangming.Cao@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 5.15 060/207] dma-buf: system_heap: Use for_each_sgtable_sg in pages free flow
Date:   Mon,  6 Dec 2021 15:55:14 +0100
Message-Id: <20211206145612.317212725@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangming <Guangming.Cao@mediatek.com>

commit 679d94cd7d900871e5bc9cf780bd5b73af35ab42 upstream.

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
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Cc: <stable@vger.kernel.org> # 5.11.*
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211126074904.88388-1-guangming.cao@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/heaps/system_heap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -289,7 +289,7 @@ static void system_heap_dma_buf_release(
 	int i;
 
 	table = &buffer->sg_table;
-	for_each_sg(table->sgl, sg, table->nents, i) {
+	for_each_sgtable_sg(table, sg, i) {
 		struct page *page = sg_page(sg);
 
 		__free_pages(page, compound_order(page));


