Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C1F55D5E9
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbiF0GwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiF0GwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:52:01 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C4126C5;
        Sun, 26 Jun 2022 23:52:00 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v14so11562427wra.5;
        Sun, 26 Jun 2022 23:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X6hunTx6t84e1RH7TuIwMAVJt14IU7tMQ/ZDFHTvWjE=;
        b=PKS5QLP9Pxtzk0i5U0iZqlq6FVXVMm7J2tqdxtgxpHjjRbPEvFzQ48hcVt4BcUxu5w
         4biDkN8bDHnFVkJHGakO+dN/je6ZH7uwogeK33mZiMvXOPe4k4vl6humhdN9oEA/2Vnp
         UkeeXGBe5CXXZHnNnKWkWcPJhba9jze3trzMN9ePag61qb6Lq0jkV67kOnWE6yqmge/H
         PxUSfaxiFoZB860dwWMDaJ5qkicrSSb2AG0UoJ0RRQ60ZWRSwhIkm3kHmoNX+iXzeZAa
         lPwZGHfo0xrr6nIn/+XuNXXN1qY4LPLmNBKusljJ73IO4/eVzDP4L7W61CaLblkXbN99
         6LSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X6hunTx6t84e1RH7TuIwMAVJt14IU7tMQ/ZDFHTvWjE=;
        b=TRMLZB/yk06u8K6OZiBIACnzMEY3Gqrh/xsLKmx2f6Ct2FumZWcN7wHzRczCgk/gC0
         fq9vkTLok9QYvbeFsqe5BVEsWhhFLXi+TfqFC0C/kTir3EdoGm/oFG55g3vPIhLktVWM
         IVKXs7H04eNIugvI0driGbkMTIxE+EbDykRjloLr7gE9t9GKn3Fd+DlO6bcsi64FBuv6
         nxrVPkLu835i3iyufo9EPitM2kRugwC2woSyoejyYL1zkGipQMcdaFbK1xdwuNHVtaL8
         2p3YCqb7eLe5WbqT+7jQWVbqec8dwWjXEQZpMn3rDqomOxOw5rTslgrLfAvVrNRWCTxg
         Spmg==
X-Gm-Message-State: AJIora8cirFIZu1w/iQiYNNxltpmJXLB5Ew4Ue3UrtP1I05l298QbcXI
        xdgVj2RrQ1HfdZ6TrQflIXg=
X-Google-Smtp-Source: AGRyM1t/jn8Kjvt+p/Bi9YPgXfG+NJdJuj6QJR3OvU+gzS+3kTjCXS1fRHxHJP7F5MPjlLs7R9PqHw==
X-Received: by 2002:a05:6000:1888:b0:21d:151c:92a0 with SMTP id a8-20020a056000188800b0021d151c92a0mr605463wri.609.1656312718949;
        Sun, 26 Jun 2022 23:51:58 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id e10-20020adffd0a000000b0021a3dd1c5d5sm9415076wrr.96.2022.06.26.23.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:51:58 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [PATCH 5.10 v4 1/5] xfs: use kmem_cache_free() for kmem_cache objects
Date:   Mon, 27 Jun 2022 09:51:36 +0300
Message-Id: <20220627065140.2798412-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627065140.2798412-1-amir73il@gmail.com>
References: <20220627065140.2798412-1-amir73il@gmail.com>
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

commit c30a0cbd07ecc0eec7b3cd568f7b1c7bb7913f93 upstream.

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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 5c0395256bd1..11474770d630 100644
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
2.25.1

