Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB5E53164C
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbiEWRRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbiEWRRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:17:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1346B653;
        Mon, 23 May 2022 10:17:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2872BB81210;
        Mon, 23 May 2022 17:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F54C385AA;
        Mon, 23 May 2022 17:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326182;
        bh=qNsw8UK5s/gGHb4MLQDTHi7UXjBbR34W4sjFr7+B9qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2UFbfb3dYSUY+BUpaAltX4NFS937S+Q3GiW4gXZ5IgbyqsYG5cnaSYt8cnTP3Ry5C
         0W8P+Mk/Mr497H4We+NqWrVtGDqSN0RiPgS8zcuAejzd+a1qAlPVFEaGjYQ9R2lmtd
         ugn8uXWWKGJkQIBmtQPwHjKY2bOj6eP6QRyrjE4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/97] Revert "swiotlb: fix info leak with DMA_FROM_DEVICE"
Date:   Mon, 23 May 2022 19:05:35 +0200
Message-Id: <20220523165817.160571252@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
References: <20220523165812.244140613@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit d4d975e7921079f877f828099bb8260af335508f.

Upstream had a follow-up fix, revert, and a semi-reverted-revert.
Instead of going through this chain which is more painful to backport,
I'm just going to revert this original commit and pick the final one.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/core-api/dma-attributes.rst | 8 --------
 include/linux/dma-mapping.h               | 8 --------
 kernel/dma/swiotlb.c                      | 3 +--
 3 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 17706dc91ec9..1887d92e8e92 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -130,11 +130,3 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
-
-DMA_ATTR_OVERWRITE
-------------------
-
-This is a hint to the DMA-mapping subsystem that the device is expected to
-overwrite the entire mapped size, thus the caller does not require any of the
-previous buffer contents to be preserved. This allows bounce-buffering
-implementations to optimise DMA_FROM_DEVICE transfers.
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index a9361178c5db..a7d70cdee25e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -61,14 +61,6 @@
  */
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
-/*
- * This is a hint to the DMA-mapping subsystem that the device is expected
- * to overwrite the entire mapped size, thus the caller does not require any
- * of the previous buffer contents to be preserved. This allows
- * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
- */
-#define DMA_ATTR_OVERWRITE		(1UL << 10)
-
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 62b1e5fa8673..0ed0e1f215c7 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -598,8 +598,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 
 	tlb_addr = slot_addr(io_tlb_start, index) + offset;
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
-	    dir == DMA_BIDIRECTIONAL))
+	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
 		swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
-- 
2.35.1



