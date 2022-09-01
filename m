Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1E35A8DA8
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 07:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiIAFtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 01:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiIAFtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 01:49:36 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F291178E6;
        Wed, 31 Aug 2022 22:49:19 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m3-20020a05600c3b0300b003a5e0557150so2667849wms.0;
        Wed, 31 Aug 2022 22:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=esm7WY5NBPF0ohza2iIRHTShjFzVuQEeXBALGm/uCz0=;
        b=f3BwabQXtFLB3sxcrI4AExoIkU478Q8Jxpm2w9lj9pBCD+cbfY8Uv6g81zSDZoMDsz
         twHcHeOU1vNxl6UMErBxjozzoYlMcMN553ZIT+wmXHKF555+uLZ1KdnswWAKKHNDLl4U
         wLWuUASVVTvxdbT4Ckkc2q7H7vXUokYILLCBb49+zmKg00iagU/e8klfu11nz0juXVh9
         kAIi+jZXHi2YvYT63sDn+0JS2sVC5HOXyB9K0kkE+K6OCVUMdVyJkxOshdy2Z7cBy0ab
         BXZAoR+KM1yXfkG/jBAHaGYA6oIDW/RQZP52/Y0hLmU3xN9Sge2HG+ivl7td0f6AoGGX
         tzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=esm7WY5NBPF0ohza2iIRHTShjFzVuQEeXBALGm/uCz0=;
        b=sKDRiVJq3iy5eBiDE1psiqgAJrSPoJ1zsrl4CMCf4lXKw8N7+4ouop9hTZCksViaj4
         RdP7ia3ZzL5ndqnhmLjGUQ6+XbsbYx4H2ktxJYThg3b9CpPYu+zpsuHg/p+LQhNcbf1i
         nZQ3U+2olEYSaAgvDpUcH+ksaDi+/BexXW9dPQhSpo0aJNce8pvdaTqmtBjD/y1RZDM1
         lrMXYAtFF3xhGKBG3zuCWHy8ZIEkhusqSenUi4xjG/r47BD1RalnguXpcOXfY0zwIdvz
         8C5TrmbFf9rSoFer9YxRMkswMpHgd+e83AIhHZNNiNANRMV9/YhukZ//02L9Tx1lYW+4
         xxyQ==
X-Gm-Message-State: ACgBeo2d3ENpH+EpQTxfy1GuKMk/uAGveZx+c/ceHkjJAGgbNY9g7KUK
        LEjuR0xqyELFe8/HFmxv8sA=
X-Google-Smtp-Source: AA6agR5fg+7Au2KoQmAhTByhBycyzCYTbLAzUG//LZsbjYv4u+RKV64y8EHg21CMHJ/uDh5TGIX6Sw==
X-Received: by 2002:a1c:3b55:0:b0:3a6:7b62:3901 with SMTP id i82-20020a1c3b55000000b003a67b623901mr3927634wma.113.1662011352705;
        Wed, 31 Aug 2022 22:49:12 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id bg15-20020a05600c3c8f00b003a4f08495b7sm4447262wmb.34.2022.08.31.22.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 22:49:12 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 v2 6/7] xfs: reorder iunlink remove operation in xfs_ifree
Date:   Thu,  1 Sep 2022 08:48:53 +0300
Message-Id: <20220901054854.2449416-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901054854.2449416-1-amir73il@gmail.com>
References: <20220901054854.2449416-1-amir73il@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.

[backport for 5.10.y]

The O_TMPFILE creation implementation creates a specific order of
operations for inode allocation/freeing and unlinked list
modification. Currently both are serialised by the AGI, so the order
doesn't strictly matter as long as the are both in the same
transaction.

However, if we want to move the unlinked list insertions largely out
from under the AGI lock, then we have to be concerned about the
order in which we do unlinked list modification operations.
O_TMPFILE creation tells us this order is inode allocation/free,
then unlinked list modification.

Change xfs_ifree() to use this same ordering on unlinked list
removal. This way we always guarantee that when we enter the
iunlinked list removal code from this path, we already have the AGI
locked and we don't have to worry about lock nesting AGI reads
inside unlink list locks because it's already locked and attached to
the transaction.

We can do this safely as the inode freeing and unlinked list removal
are done in the same transaction and hence are atomic operations
with respect to log recovery.

Reported-by: Frank Hofmann <fhofmann@cloudflare.com>
Fixes: 298f7bec503f ("xfs: pin inode backing buffer to the inode log item")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1f61e085676b..929ed3bc5619 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2669,14 +2669,13 @@ xfs_ifree_cluster(
 }
 
 /*
- * This is called to return an inode to the inode free list.
- * The inode should already be truncated to 0 length and have
- * no pages associated with it.  This routine also assumes that
- * the inode is already a part of the transaction.
+ * This is called to return an inode to the inode free list.  The inode should
+ * already be truncated to 0 length and have no pages associated with it.  This
+ * routine also assumes that the inode is already a part of the transaction.
  *
- * The on-disk copy of the inode will have been added to the list
- * of unlinked inodes in the AGI. We need to remove the inode from
- * that list atomically with respect to freeing it here.
+ * The on-disk copy of the inode will have been added to the list of unlinked
+ * inodes in the AGI. We need to remove the inode from that list atomically with
+ * respect to freeing it here.
  */
 int
 xfs_ifree(
@@ -2694,13 +2693,16 @@ xfs_ifree(
 	ASSERT(ip->i_d.di_nblocks == 0);
 
 	/*
-	 * Pull the on-disk inode from the AGI unlinked list.
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
 	 */
-	error = xfs_iunlink_remove(tp, ip);
+	error = xfs_difree(tp, ip->i_ino, &xic);
 	if (error)
 		return error;
 
-	error = xfs_difree(tp, ip->i_ino, &xic);
+	error = xfs_iunlink_remove(tp, ip);
 	if (error)
 		return error;
 
-- 
2.25.1

