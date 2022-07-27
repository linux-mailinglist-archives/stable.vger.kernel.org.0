Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152E5582DC1
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiG0RCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241082AbiG0RCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:02:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393FE6C11C;
        Wed, 27 Jul 2022 09:38:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC080B8200D;
        Wed, 27 Jul 2022 16:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12BBC433D7;
        Wed, 27 Jul 2022 16:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939859;
        bh=mPEUpCltEvoeCnadERliB+25tv9OoFIoS22pvdNZNYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTm3X+xbNMxO5dsZcTY44AV3pkiF91hYYiqet1h3813doI7SczY5c2Fj2bUMF7J/5
         xCTJHONCZO9644Eq7gVB5mLleodrooOjEKTvbj6FWtQ4bxyRUKcEdiKRjdVtdey/1G
         rvLHquyFb/7da+yNxre5RF0BBnlqOR36J7omOdJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 023/201] xfs: rename the next_agno perag iteration variable
Date:   Wed, 27 Jul 2022 18:08:47 +0200
Message-Id: <20220727161027.866105909@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit f1788b5e5ee25bedf00bb4d25f82b93820d61189 ]

Rename the next_agno variable to be consistent across the several
iteration macros and shorten line length.

[backport: dependency for 8ed004eb9d07a5d6114db3e97a166707c186262d]

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -127,22 +127,22 @@ void xfs_perag_put(struct xfs_perag *pag
 static inline struct xfs_perag *
 xfs_perag_next(
 	struct xfs_perag	*pag,
-	xfs_agnumber_t		*next_agno)
+	xfs_agnumber_t		*agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
-	*next_agno = pag->pag_agno + 1;
+	*agno = pag->pag_agno + 1;
 	xfs_perag_put(pag);
-	return xfs_perag_get(mp, *next_agno);
+	return xfs_perag_get(mp, *agno);
 }
 
-#define for_each_perag_range(mp, next_agno, end_agno, pag) \
-	for ((pag) = xfs_perag_get((mp), (next_agno)); \
-		(pag) != NULL && (next_agno) <= (end_agno); \
-		(pag) = xfs_perag_next((pag), &(next_agno)))
+#define for_each_perag_range(mp, agno, end_agno, pag) \
+	for ((pag) = xfs_perag_get((mp), (agno)); \
+		(pag) != NULL && (agno) <= (end_agno); \
+		(pag) = xfs_perag_next((pag), &(agno)))
 
-#define for_each_perag_from(mp, next_agno, pag) \
-	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
+#define for_each_perag_from(mp, agno, pag) \
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \


