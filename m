Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0B6582D93
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbiG0RAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241409AbiG0Q7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:59:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D5F691FB;
        Wed, 27 Jul 2022 09:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACE1FB821B9;
        Wed, 27 Jul 2022 16:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79B4C433C1;
        Wed, 27 Jul 2022 16:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939856;
        bh=QIwyvBHzMft5hHeUPCGfaHE9IruANW/3bkRMmqt8OuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgdCR/7bqOYCGgky5TC4bmy3rHzWkFma3TG0icixcYElcYRQOpfAwur5VGwJ97y73
         R39/Kts+dqQp2QtoyW+ML6ncgRkCwxTa9EVKMXwKwjhsBw3MoVR9gxM9ShXfcuRSZg
         lfQlPmKHhbWjFaNe4TQYMinRZEpPr1z0J5zaLwco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 022/201] xfs: fold perag loop iteration logic into helper function
Date:   Wed, 27 Jul 2022 18:08:46 +0200
Message-Id: <20220727161027.823297023@linuxfoundation.org>
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

[ Upstream commit bf2307b195135ed9c95eebb38920d8bd41843092 ]

Fold the loop iteration logic into a helper in preparation for
further fixups. No functional change in this patch.

[backport: dependency for f1788b5e5ee25bedf00bb4d25f82b93820d61189]

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.h |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -124,12 +124,22 @@ void xfs_perag_put(struct xfs_perag *pag
  * for_each_perag_from() because they terminate at sb_agcount where there are
  * no perag structures in tree beyond end_agno.
  */
+static inline struct xfs_perag *
+xfs_perag_next(
+	struct xfs_perag	*pag,
+	xfs_agnumber_t		*next_agno)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	*next_agno = pag->pag_agno + 1;
+	xfs_perag_put(pag);
+	return xfs_perag_get(mp, *next_agno);
+}
+
 #define for_each_perag_range(mp, next_agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (next_agno)); \
 		(pag) != NULL && (next_agno) <= (end_agno); \
-		(next_agno) = (pag)->pag_agno + 1, \
-		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get((mp), (next_agno)))
+		(pag) = xfs_perag_next((pag), &(next_agno)))
 
 #define for_each_perag_from(mp, next_agno, pag) \
 	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))


