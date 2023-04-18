Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644196E626F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjDRMce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjDRMcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:32:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343A29747
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59F6A631ED
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C440C433EF;
        Tue, 18 Apr 2023 12:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821095;
        bh=dPdHkVAiarSeIk5b18CdbCAPSB++eKPQoDba17Za3RM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIklpMgq561NyXH7gDfVoUi/fOQfj+S8rMPCiUQ2sua0pHDYBAvmg/O35sKg4WCsr
         J9LYsBqx/XhC4EGEluOcEAfB0zkOD40UkisD6ykTy5iHU25yeJXvIYFRByo+R1KDR+
         SYJURWxIsX0YtYPjAKx9AKlPxVCuFn3opm31WoLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 89/92] xfs: shut down the filesystem if we screw up quota reservation
Date:   Tue, 18 Apr 2023 14:22:04 +0200
Message-Id: <20230418120307.901727472@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2a4bdfa8558ca2904dc17b83497dc82aa7fc05e9 upstream.

If we ever screw up the quota reservations enough to trip the
assertions, something's wrong with the quota code.  Shut down the
filesystem when this happens, because this is corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans_dquot.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -15,6 +15,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
+#include "xfs_error.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -700,9 +701,14 @@ xfs_trans_dqresv(
 					    XFS_TRANS_DQ_RES_INOS,
 					    ninos);
 	}
-	ASSERT(dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount));
-	ASSERT(dqp->q_res_rtbcount >= be64_to_cpu(dqp->q_core.d_rtbcount));
-	ASSERT(dqp->q_res_icount >= be64_to_cpu(dqp->q_core.d_icount));
+
+	if (XFS_IS_CORRUPT(mp,
+		dqp->q_res_bcount < be64_to_cpu(dqp->q_core.d_bcount)) ||
+	    XFS_IS_CORRUPT(mp,
+		dqp->q_res_rtbcount < be64_to_cpu(dqp->q_core.d_rtbcount)) ||
+	    XFS_IS_CORRUPT(mp,
+		dqp->q_res_icount < be64_to_cpu(dqp->q_core.d_icount)))
+		goto error_corrupt;
 
 	xfs_dqunlock(dqp);
 	return 0;
@@ -712,6 +718,10 @@ error_return:
 	if (flags & XFS_QMOPT_ENOSPC)
 		return -ENOSPC;
 	return -EDQUOT;
+error_corrupt:
+	xfs_dqunlock(dqp);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return -EFSCORRUPTED;
 }
 
 


