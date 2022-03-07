Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6154CF7A6
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbiCGJqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238186AbiCGJmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:42:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9709136E27;
        Mon,  7 Mar 2022 01:41:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23FD361349;
        Mon,  7 Mar 2022 09:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09445C340E9;
        Mon,  7 Mar 2022 09:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646087;
        bh=yGF2yk0DciZXVKy44TwKN8EX+j1uAZ+XFwglFSQ1H9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ceu3A1KBOnLdp0AQNrVQ11uJKT+kySSW4hcqA3CoK0dSMqpYJBc2QhFRftaEtXJIx
         XBoxXATFuJm+eIsTNtHkKMexjqz5tBH+noc8AsNe+o+lsQLSidLYFgEJ5o3J0ii8J9
         BG2FWAGmgHS0rJoCQqQSz0mfPgW33RpzXbe03fZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weizhao Ouyang <o451686892@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/262] dma-buf: cma_heap: Fix mutex locking section
Date:   Mon,  7 Mar 2022 10:17:13 +0100
Message-Id: <20220307091704.991374478@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weizhao Ouyang <o451686892@gmail.com>

[ Upstream commit 54329e6f7beea6af56c1230da293acc97d6a6ee7 ]

Fix cma_heap_buffer mutex locking critical section to protect vmap_cnt
and vaddr.

Fixes: a5d2d29e24be ("dma-buf: heaps: Move heap-helper logic into the cma_heap implementation")
Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220104073545.124244-1-o451686892@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/heaps/cma_heap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index 0c05b79870f96..83f02bd51dda6 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -124,10 +124,11 @@ static int cma_heap_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
 	struct cma_heap_buffer *buffer = dmabuf->priv;
 	struct dma_heap_attachment *a;
 
+	mutex_lock(&buffer->lock);
+
 	if (buffer->vmap_cnt)
 		invalidate_kernel_vmap_range(buffer->vaddr, buffer->len);
 
-	mutex_lock(&buffer->lock);
 	list_for_each_entry(a, &buffer->attachments, list) {
 		if (!a->mapped)
 			continue;
@@ -144,10 +145,11 @@ static int cma_heap_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
 	struct cma_heap_buffer *buffer = dmabuf->priv;
 	struct dma_heap_attachment *a;
 
+	mutex_lock(&buffer->lock);
+
 	if (buffer->vmap_cnt)
 		flush_kernel_vmap_range(buffer->vaddr, buffer->len);
 
-	mutex_lock(&buffer->lock);
 	list_for_each_entry(a, &buffer->attachments, list) {
 		if (!a->mapped)
 			continue;
-- 
2.34.1



