Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3273869CDCE
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbjBTNxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbjBTNxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:53:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FCF1ADD0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:53:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17DE860E9D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A75C433EF;
        Mon, 20 Feb 2023 13:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901179;
        bh=PuxJDn9p9JUf8AINQVmne9TbRT/2P3mBoX46UnJg8zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qF5BTYEP0BMPJLP9T1uo55BoI/PxHu4JtNcs62XVH1eb1u8NNoUNt8ufoZjfmNLcA
         2msikAlShwdSZ/ctsf8o45I2TImEbZEcJj34XCA0AHm7WmLcl3ax+FLlBzGJ1FcELr
         3AtHR5PzjGY4Z4pxgalcEytX2NAQ7KuRG8rBCfN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/83] xfs: dont assert fail on perag references on teardown
Date:   Mon, 20 Feb 2023 14:36:03 +0100
Message-Id: <20230220133554.723916261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 5b55cbc2d72632e874e50d2e36bce608e55aaaea ]

Not fatal, the assert is there to catch developer attention. I'm
seeing this occasionally during recoveryloop testing after a
shutdown, and I don't want this to stop an overnight recoveryloop
run as it is currently doing.

Convert the ASSERT to a XFS_IS_CORRUPT() check so it will dump a
corruption report into the log and cause a test failure that way,
but it won't stop the machine dead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 005abfd9fd347..aff6fb5281f63 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -173,7 +173,6 @@ __xfs_free_perag(
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
 	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
-	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
 
@@ -192,7 +191,7 @@ xfs_free_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
-		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_iunlink_destroy(pag);
-- 
2.39.0



