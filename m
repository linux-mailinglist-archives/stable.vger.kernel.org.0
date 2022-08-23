Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C588D59D33A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbiHWIHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241109AbiHWIHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:07:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488D16B8F7;
        Tue, 23 Aug 2022 01:04:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2765B81C21;
        Tue, 23 Aug 2022 08:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29370C433D6;
        Tue, 23 Aug 2022 08:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241892;
        bh=ITNkrA9oaAdQvqvgxkbO2YmAfNEa2GRB35lOg9Xwodk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWhht10c+VAzrKKNUit/R7D7npGxH75Ho8vJT+MEPq/cEXsv2tDtonr+eM7y9Xd8a
         FjMk4G058ar7+82nEFKllNJSKW6e7zeM5nqY8jxJX7VjOZYjG+4MUesuMHcNcWgD6P
         gvy0WF5mX7ALEJh9MBqU3C1bOqLlFIyOGSU71HC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.19 003/365] RDMA: Handle the return code from dma_resv_wait_timeout() properly
Date:   Tue, 23 Aug 2022 09:58:24 +0200
Message-Id: <20220823080118.298671452@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit b16de8b9e7d1aae169d059c3a0dd9a881a3c0d1d upstream.

ib_umem_dmabuf_map_pages() returns 0 on success and -ERRNO on failure.

dma_resv_wait_timeout() uses a different scheme:

 * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or
 * greater than zero on success.

This results in ib_umem_dmabuf_map_pages() being non-functional as a
positive return will be understood to be an error by drivers.

Fixes: f30bceab16d1 ("RDMA: use dma_resv_wait() instead of extracting the fence")
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/0-v1-d8f4e1fa84c8+17-rdma_dmabuf_fix_jgg@nvidia.com
Tested-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/umem_dmabuf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index fce80a4a5147..04c04e6d24c3 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -18,6 +18,7 @@ int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf)
 	struct scatterlist *sg;
 	unsigned long start, end, cur = 0;
 	unsigned int nmap = 0;
+	long ret;
 	int i;
 
 	dma_resv_assert_held(umem_dmabuf->attach->dmabuf->resv);
@@ -67,9 +68,14 @@ int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf)
 	 * may be not up-to-date. Wait for the exporter to finish
 	 * the migration.
 	 */
-	return dma_resv_wait_timeout(umem_dmabuf->attach->dmabuf->resv,
+	ret = dma_resv_wait_timeout(umem_dmabuf->attach->dmabuf->resv,
 				     DMA_RESV_USAGE_KERNEL,
 				     false, MAX_SCHEDULE_TIMEOUT);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -ETIMEDOUT;
+	return 0;
 }
 EXPORT_SYMBOL(ib_umem_dmabuf_map_pages);
 
-- 
2.37.2



