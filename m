Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA271696F89
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbjBNV1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBNV1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:27:11 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DCF298C1;
        Tue, 14 Feb 2023 13:26:35 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id e17so9504252plg.12;
        Tue, 14 Feb 2023 13:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F67ZEsFHmg5bEOyWUasxb3V34Kww6nIyBNz8EfnDjrE=;
        b=k5zvv+Eut2USYNdayngc61hRQ3iE11uh/SrzxXyxrzYHfxPWUYLdT4zoNR3C+HhNhG
         +NGXc7FrzeN+2U0Ar/GpMbRPeuPlau86HXJ56gkb8IvfwEJe2ETypaEILeXGowmwtT7u
         eafketX7vi41CxVr5Yieaa2CDh4YkaIDbZe0UzeYbpJTIDfagNjGeQGqd0DBDmpXSPVb
         nyehNIXRflIBgSUCGIfgGR3ESjvJgY4juld4ELGSTnaIk53wzBtr3HQhu4cNWgo+qe7c
         2kDoqIOTHvrfucJL4oiLqGKs4rCl5I+0nxzokwERNY86Yr9mUBJNorayTJHfJxI8KN5h
         FuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F67ZEsFHmg5bEOyWUasxb3V34Kww6nIyBNz8EfnDjrE=;
        b=YuAE7Phk5QzqivZdMPQtcQNtuYyDx6JgflPwCL8kaewRVLT5fWaitnI30LPY6/RHfQ
         ExaX9TbQRVo4n/HFf3J8zIwEVvyZWn0005pO2VTU8Zmrim9iV2KGyIvEfa1q2rvEbkUx
         WOqCIkhamPTPa/6PWej9+ETTXyjd7gnpLoFHTQqjtXcngvzj8f459dXNB3PNtGungu7J
         DJUps7ZuutVfP94hWFOXE9sC/cxxCaHhrNQqkyGUtJrc4StzmuUlxZRxA8JvOcQTzTWN
         74ceQE4Rs1zQ0jqRZ/CA3QTCwe8QMSEBy1kwvRS5+4eeswIzjqvWI7AQC3PcBJCXX0Bc
         4egw==
X-Gm-Message-State: AO0yUKV8i8PunbnrfQmU/EfibZmCwvp6paChHzubnCCO8t4mph/DC8pn
        l0dMzZ2zvQMPnrp/RG8yFIjeKbxhe08q2Q==
X-Google-Smtp-Source: AK7set/qhfpBSI+8S1A+jumK7jo5nwZ7WhaFoVboEUauEcIqPnOxfbS7kaSKt3zinIHCxHeOnS9a8w==
X-Received: by 2002:a17:902:dacb:b0:196:22d5:6583 with SMTP id q11-20020a170902dacb00b0019622d56583mr89503plx.32.1676409972070;
        Tue, 14 Feb 2023 13:26:12 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cf14:3756:2b5e:fb87])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b00195f0fb0c18sm6692569pln.31.2023.02.14.13.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:26:11 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        kernel test robot <oliver.sang@intel.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 06/10] xfs: avoid unnecessary runtime sibling pointer endian conversions
Date:   Tue, 14 Feb 2023 13:25:30 -0800
Message-Id: <20230214212534.1420323-7-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230214212534.1420323-1-leah.rumancik@gmail.com>
References: <20230214212534.1420323-1-leah.rumancik@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 5672225e8f2a872a22b0cecedba7a6644af1fb84 ]

Commit dc04db2aa7c9 has caused a small aim7 regression, showing a
small increase in CPU usage in __xfs_btree_check_sblock() as a
result of the extra checking.

This is likely due to the endian conversion of the sibling poitners
being unconditional instead of relying on the compiler to endian
convert the NULL pointer at compile time and avoiding the runtime
conversion for this common case.

Rework the checks so that endian conversion of the sibling pointers
is only done if they are not null as the original code did.

.... and these need to be "inline" because the compiler completely
fails to inline them automatically like it should be doing.

$ size fs/xfs/libxfs/xfs_btree.o*
   text	   data	    bss	    dec	    hex	filename
  51874	    240	      0	  52114	   cb92 fs/xfs/libxfs/xfs_btree.o.orig
  51562	    240	      0	  51802	   ca5a fs/xfs/libxfs/xfs_btree.o.inline

Just when you think the tools have advanced sufficiently we don't
have to care about stuff like this anymore, along comes a reminder
that *our tools still suck*.

Fixes: dc04db2aa7c9 ("xfs: detect self referencing btree sibling pointers")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 47 +++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5bec048343b0..b4b5bf4bfed7 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -51,16 +51,31 @@ xfs_btree_magic(
 	return magic;
 }
 
-static xfs_failaddr_t
+/*
+ * These sibling pointer checks are optimised for null sibling pointers. This
+ * happens a lot, and we don't need to byte swap at runtime if the sibling
+ * pointer is NULL.
+ *
+ * These are explicitly marked at inline because the cost of calling them as
+ * functions instead of inlining them is about 36 bytes extra code per call site
+ * on x86-64. Yes, gcc-11 fails to inline them, and explicit inlining of these
+ * two sibling check functions reduces the compiled code size by over 300
+ * bytes.
+ */
+static inline xfs_failaddr_t
 xfs_btree_check_lblock_siblings(
 	struct xfs_mount	*mp,
 	struct xfs_btree_cur	*cur,
 	int			level,
 	xfs_fsblock_t		fsb,
-	xfs_fsblock_t		sibling)
+	__be64			dsibling)
 {
-	if (sibling == NULLFSBLOCK)
+	xfs_fsblock_t		sibling;
+
+	if (dsibling == cpu_to_be64(NULLFSBLOCK))
 		return NULL;
+
+	sibling = be64_to_cpu(dsibling);
 	if (sibling == fsb)
 		return __this_address;
 	if (level >= 0) {
@@ -74,17 +89,21 @@ xfs_btree_check_lblock_siblings(
 	return NULL;
 }
 
-static xfs_failaddr_t
+static inline xfs_failaddr_t
 xfs_btree_check_sblock_siblings(
 	struct xfs_mount	*mp,
 	struct xfs_btree_cur	*cur,
 	int			level,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
-	xfs_agblock_t		sibling)
+	__be32			dsibling)
 {
-	if (sibling == NULLAGBLOCK)
+	xfs_agblock_t		sibling;
+
+	if (dsibling == cpu_to_be32(NULLAGBLOCK))
 		return NULL;
+
+	sibling = be32_to_cpu(dsibling);
 	if (sibling == agbno)
 		return __this_address;
 	if (level >= 0) {
@@ -136,10 +155,10 @@ __xfs_btree_check_lblock(
 		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
 	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
-			be64_to_cpu(block->bb_u.l.bb_leftsib));
+			block->bb_u.l.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
-				be64_to_cpu(block->bb_u.l.bb_rightsib));
+				block->bb_u.l.bb_rightsib);
 	return fa;
 }
 
@@ -204,10 +223,10 @@ __xfs_btree_check_sblock(
 	}
 
 	fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno, agbno,
-			be32_to_cpu(block->bb_u.s.bb_leftsib));
+			block->bb_u.s.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno,
-				 agbno, be32_to_cpu(block->bb_u.s.bb_rightsib));
+				 agbno, block->bb_u.s.bb_rightsib);
 	return fa;
 }
 
@@ -4517,10 +4536,10 @@ xfs_btree_lblock_verify(
 	/* sibling pointer verification */
 	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
-			be64_to_cpu(block->bb_u.l.bb_leftsib));
+			block->bb_u.l.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
-				be64_to_cpu(block->bb_u.l.bb_rightsib));
+				block->bb_u.l.bb_rightsib);
 	return fa;
 }
 
@@ -4574,10 +4593,10 @@ xfs_btree_sblock_verify(
 	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
 	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
-			be32_to_cpu(block->bb_u.s.bb_leftsib));
+			block->bb_u.s.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
-				be32_to_cpu(block->bb_u.s.bb_rightsib));
+				block->bb_u.s.bb_rightsib);
 	return fa;
 }
 
-- 
2.39.1.581.gbfd45094c4-goog

