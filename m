Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDC755ECBC
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 20:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiF1SkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 14:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiF1SkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 14:40:23 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE9822B10;
        Tue, 28 Jun 2022 11:40:22 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 9so13007607pgd.7;
        Tue, 28 Jun 2022 11:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EJ0biCIxVVWv8FXDO+74+pFK2hXee6NmP1YA59oxZXM=;
        b=EItH706DMshBX3gVgFCw9OI1N3ZYI27k/cfqRyeuHa1io608PcLmzVwISlWBhgd4l3
         3+V1ZIeSkJflRwAPWWPITJmT0vuCsWUCCf+S1pjuNUMFjUkxZQhKkkMQd3NuU4KVlp6C
         0DTLhUEyZomFEuV0TR1E+dg4+qdTTXtLrjNgxNg8Sk9HpN2GwU3V9e2BacpwTfaoMYHj
         PvJ/g2VfLeIVkC+BQKImFM26eh7SZ9smdzuco+XquQ16alv48ubaONFR1NB6SOhE2770
         ervT5ikTpVYXtS+RtvqcuyQPiRvdzjM555BwzV2/ZrMg4Lndwq1O0+wE4o2CH3F33ggm
         jrqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EJ0biCIxVVWv8FXDO+74+pFK2hXee6NmP1YA59oxZXM=;
        b=O5FZb7OHi9hT3oJfYJSxOK2kPSBnjebPd162fjwVmNMZHZKAywpNPlkiLo93j23U4v
         7cxmnd9Cmq9zp2GnCEYWqMHYrV0UD4IfI5qTMHlKKfMSEK1Vs7mcokzmSM5EG1DocnjF
         YZpeEMrt1+uULjM8BUzV88xLglGjFxvh79tdaeJYmQ1Iaw/6bWLIaTnK2xvR0fp+wAWt
         l3u/JirY0hxLn6pMGyg0u3bbKXHTMOWgYzYPsGWs9KPHNpnF1j8Mfuusx7q771GgQRnP
         xFJTOxmA3MjhCxnDByMZBqQ8ywz7vqb8c50e7Prars3GpKzJrKNqplWHGr2qPDvcnchX
         3Ujg==
X-Gm-Message-State: AJIora/lJVwNL+FVC9vkIUYDhPxWSaD6/CyFM4nT8tYfGIejZUjsbheE
        k77PIVov3mfiCM3T5yoY+0q/tVB/aOi6mg==
X-Google-Smtp-Source: AGRyM1v2jRd2d9X8f6eK9tr0B8ePViNUBBqHiBUntonn08E1eavBPfhWQwf5ktYPjDr4JPzhrvniew==
X-Received: by 2002:aa7:82ca:0:b0:51b:cf43:d00a with SMTP id f10-20020aa782ca000000b0051bcf43d00amr6074138pfn.58.1656441621781;
        Tue, 28 Jun 2022 11:40:21 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:1d5d:7791:41a3:902a])
        by smtp.gmail.com with ESMTPSA id a20-20020a621a14000000b005251bea0d53sm9743498pfa.83.2022.06.28.11.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:40:21 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v4 1/7] xfs: use kmem_cache_free() for kmem_cache objects
Date:   Tue, 28 Jun 2022 11:39:45 -0700
Message-Id: <20220628183951.3425528-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220628183951.3425528-1-leah.rumancik@gmail.com>
References: <20220628183951.3425528-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

[ Upstream commit c30a0cbd07ecc0eec7b3cd568f7b1c7bb7913f93 ]

For kmalloc() allocations SLOB prepends the blocks with a 4-byte header,
and it puts the size of the allocated blocks in that header.
Blocks allocated with kmem_cache_alloc() allocations do not have that
header.

SLOB explodes when you allocate memory with kmem_cache_alloc() and then
try to free it with kfree() instead of kmem_cache_free().
SLOB will assume that there is a header when there is none, read some
garbage to size variable and corrupt the adjacent objects, which
eventually leads to hang or panic.

Let's make XFS work with SLOB by using proper free function.

Fixes: 9749fee83f38 ("xfs: enable the xfs_defer mechanism to process extents to free")
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3f8a0713573a..a4b8caa2c601 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -482,7 +482,7 @@ xfs_extent_free_finish_item(
 			free->xefi_startblock,
 			free->xefi_blockcount,
 			&free->xefi_oinfo, free->xefi_skip_discard);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 	return error;
 }
 
@@ -502,7 +502,7 @@ xfs_extent_free_cancel_item(
 	struct xfs_extent_free_item	*free;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -564,7 +564,7 @@ xfs_agfl_free_finish_item(
 	extp->ext_len = free->xefi_blockcount;
 	efdp->efd_next_extent++;
 
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 	return error;
 }
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

