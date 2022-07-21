Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE0557D622
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 23:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbiGUVhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 17:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbiGUVhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 17:37:31 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2179363A;
        Thu, 21 Jul 2022 14:37:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n10-20020a17090a670a00b001f22ebae50aso2555055pjj.3;
        Thu, 21 Jul 2022 14:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OvBrM6Tx7WDNNlnMO7Z0IYVkA9JQzTIu4/j8gJ6gqZU=;
        b=XsvsLWE5+9nyJuQK5SkUg+3CM9n3gPxOO7KvNXrXZhR5zcYsU4l31vCaizGMJ2BNHr
         eYKEUp/56iuGSXMB7Z7QPHpii2dykQOnpwIyJMfxvH9KKPD4Ifonouiw5Qg3S6ii32Il
         ODnUVpsR6gWMQjPuyQ1zaJUIRYJ0CG3C+SdOh4G2XiMTzu6x1L+9IhrhuN9pNZ/EhWzz
         cbhkmxs/d+9UOvgn/O/zZDu3QapNvCXscNgYMQ1/6Lc4yukKExlifPnOkpcPAo/ssLi2
         F7A0gyFgkU2ClzxIwRtJL/3B9WAidW8lgo8W7Bnjw9vkEl/bJy9xOKkX4plo13tQkG16
         xnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OvBrM6Tx7WDNNlnMO7Z0IYVkA9JQzTIu4/j8gJ6gqZU=;
        b=w9qT5l2vZdINaN8Gnv2r6yIksGeLhSwEeEeSR/htPxdYlAiOsdmJ9PxkjY+KLxZAvB
         Q8uWN7LybjUEJ+gtXDGnXymisIl0uJQnlxb+SDkv58kbJEOgbBKQtLR8Xf7tgm2zbOv6
         vzCUwXKx1lOF79rv3kvTvkZ9L4VaEl4n6u7mgGaSaDGPnVQCJTxiOQMNW0qIlBnzANj7
         fTjAv7blhkpvk7Hb4qaWHweMN/ZFBx/4xbaqhsaogn11Jo4sRB5zu+Vd+VQPBBbdaUTj
         wqGa1DH1tGjEnEMOAVj7Rile97eyqA142w8RwfpWm+4LXRJJOcMyA979C7oAiARFZfkz
         Fygw==
X-Gm-Message-State: AJIora9YWSyCO9BVu5Xb19CnQzzfbg9TKcCLUAPboQ3q2cb4UW8tDsaN
        N5aNy68lLFL6wWflMg8S/kYP5eWIp64FPg==
X-Google-Smtp-Source: AGRyM1unx13hil3w4TflQsqfTexe5zHVDNckDrC6dtxkjWI0LeDkjS5LtxPTRGiO5/wI8B+QN58UKw==
X-Received: by 2002:a17:90a:1c01:b0:1f1:bf54:67ff with SMTP id s1-20020a17090a1c0100b001f1bf5467ffmr13295292pjs.172.1658439449698;
        Thu, 21 Jul 2022 14:37:29 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:ea45:e7f2:4e46:fc7a])
        by smtp.gmail.com with ESMTPSA id c26-20020a634e1a000000b004114cc062f0sm1919502pgb.65.2022.07.21.14.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:37:28 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 5/6] xfs: fix perag reference leak on iteration race with growfs
Date:   Thu, 21 Jul 2022 14:36:09 -0700
Message-Id: <20220721213610.2794134-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
In-Reply-To: <20220721213610.2794134-1-leah.rumancik@gmail.com>
References: <20220721213610.2794134-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 892a666fafa19ab04b5e948f6c92f98f1dafb489 ]

The for_each_perag*() set of macros are hacky in that some (i.e.
those based on sb_agcount) rely on the assumption that perag
iteration terminates naturally with a NULL perag at the specified
end_agno. Others allow for the final AG to have a valid perag and
require the calling function to clean up any potential leftover
xfs_perag reference on termination of the loop.

Aside from providing a subtly inconsistent interface, the former
variant is racy with growfs because growfs can create discoverable
post-eofs perags before the final superblock update that completes
the grow operation and increases sb_agcount. This leads to the
following assert failure (reproduced by xfs/104) in the perag free
path during unmount:

 XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/libxfs/xfs_ag.c, line: 195

This occurs because one of the many for_each_perag() loops in the
code that is expected to terminate with a NULL pag (and thus has no
post-loop xfs_perag_put() check) raced with a growfs and found a
non-NULL post-EOFS perag, but terminated naturally based on the
end_agno check without releasing the post-EOFS perag.

Rework the iteration logic to lift the agno check from the main for
loop conditional to the iteration helper function. The for loop now
purely terminates on a NULL pag and xfs_perag_next() avoids taking a
reference to any perag beyond end_agno in the first place.

Fixes: f250eedcf762 ("xfs: make for_each_perag... a first class citizen")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.h | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4585ebb3f450..3f597cad2c33 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -116,30 +116,26 @@ void xfs_perag_put(struct xfs_perag *pag);
 
 /*
  * Perag iteration APIs
- *
- * XXX: for_each_perag_range() usage really needs an iterator to clean up when
- * we terminate at end_agno because we may have taken a reference to the perag
- * beyond end_agno. Right now callers have to be careful to catch and clean that
- * up themselves. This is not necessary for the callers of for_each_perag() and
- * for_each_perag_from() because they terminate at sb_agcount where there are
- * no perag structures in tree beyond end_agno.
  */
 static inline struct xfs_perag *
 xfs_perag_next(
 	struct xfs_perag	*pag,
-	xfs_agnumber_t		*agno)
+	xfs_agnumber_t		*agno,
+	xfs_agnumber_t		end_agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
 	*agno = pag->pag_agno + 1;
 	xfs_perag_put(pag);
+	if (*agno > end_agno)
+		return NULL;
 	return xfs_perag_get(mp, *agno);
 }
 
 #define for_each_perag_range(mp, agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (agno)); \
-		(pag) != NULL && (agno) <= (end_agno); \
-		(pag) = xfs_perag_next((pag), &(agno)))
+		(pag) != NULL; \
+		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
 
 #define for_each_perag_from(mp, agno, pag) \
 	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
-- 
2.37.1.359.gd136c6c3e2-goog

