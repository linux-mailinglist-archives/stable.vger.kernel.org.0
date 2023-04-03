Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20196D4848
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbjDCO1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbjDCO1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:27:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154802D7FF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4EFC61DBE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BF4C433EF;
        Mon,  3 Apr 2023 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532032;
        bh=U1B9SCUwyo+l2TBmiKv0wwTMcpUYbNihOL0RsfXLvLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JB7Z7/Tx3hB11++jQpk+kYvKZOYEwAEuP+e8q6nr5cA44wjrV76jCHxbU1NRQG0VB
         J27XcUFGdhsUS91LclhvrJ5uKj55CA7HJFhEIL1YUdF7sXYkWM2MllpRlYYy6lO+I+
         SyNFq1JQZYXEMTY4GjHAjVDVHWb3BB89UssHMn8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 100/173] xfs: shut down the filesystem if we screw up quota reservation
Date:   Mon,  3 Apr 2023 16:08:35 +0200
Message-Id: <20230403140417.658551304@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 fs/xfs/xfs_trans_dquot.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -16,6 +16,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
+#include "xfs_error.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -708,9 +709,11 @@ xfs_trans_dqresv(
 					    XFS_TRANS_DQ_RES_INOS,
 					    ninos);
 	}
-	ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
-	ASSERT(dqp->q_rtb.reserved >= dqp->q_rtb.count);
-	ASSERT(dqp->q_ino.reserved >= dqp->q_ino.count);
+
+	if (XFS_IS_CORRUPT(mp, dqp->q_blk.reserved < dqp->q_blk.count) ||
+	    XFS_IS_CORRUPT(mp, dqp->q_rtb.reserved < dqp->q_rtb.count) ||
+	    XFS_IS_CORRUPT(mp, dqp->q_ino.reserved < dqp->q_ino.count))
+		goto error_corrupt;
 
 	xfs_dqunlock(dqp);
 	return 0;
@@ -720,6 +723,10 @@ error_return:
 	if (xfs_dquot_type(dqp) == XFS_DQTYPE_PROJ)
 		return -ENOSPC;
 	return -EDQUOT;
+error_corrupt:
+	xfs_dqunlock(dqp);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return -EFSCORRUPTED;
 }
 
 


