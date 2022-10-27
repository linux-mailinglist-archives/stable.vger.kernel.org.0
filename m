Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293A260FEC9
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbiJ0RI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbiJ0RI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90FA12FFAB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89BD7B826FC
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3696C433C1;
        Thu, 27 Oct 2022 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890503;
        bh=D4TQlgWXdUnuuN9mWTO4/Vt6zqolb3DXDgzka0c30RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qtx4LDVyfZfE0vVvJNQ9Ev7dkiDAG4AoR6TPDhbE8dx5Y0jQEaNkzDwzJP/BZNC0W
         vR+TIZpFnywSXv7ZzsD/l5ifIcvpAeglMJHwcUXOZJ85zpx9ckRB1wWANFHE5DABk5
         4QnZsPMpQoP+SX7Npkk8RjnCGRh4XyZgTMKKKaLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 16/53] xfs: preserve default grace interval during quotacheck
Date:   Thu, 27 Oct 2022 18:56:04 +0200
Message-Id: <20221027165050.447924164@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 5885539f0af371024d07afd14974bfdc3fff84c5 upstream.

When quotacheck runs, it zeroes all the timer fields in every dquot.
Unfortunately, it also does this to the root dquot, which erases any
preconfigured grace intervals and warning limits that the administrator
may have set.  Worse yet, the incore copies of those variables remain
set.  This cache coherence problem manifests itself as the grace
interval mysteriously being reset back to the defaults at the /next/
mount.

Fix it by not resetting the root disk dquot's timer and warning fields.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_qm.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -875,12 +875,20 @@ xfs_qm_reset_dqcounts(
 		ddq->d_bcount = 0;
 		ddq->d_icount = 0;
 		ddq->d_rtbcount = 0;
-		ddq->d_btimer = 0;
-		ddq->d_itimer = 0;
-		ddq->d_rtbtimer = 0;
-		ddq->d_bwarns = 0;
-		ddq->d_iwarns = 0;
-		ddq->d_rtbwarns = 0;
+
+		/*
+		 * dquot id 0 stores the default grace period and the maximum
+		 * warning limit that were set by the administrator, so we
+		 * should not reset them.
+		 */
+		if (ddq->d_id != 0) {
+			ddq->d_btimer = 0;
+			ddq->d_itimer = 0;
+			ddq->d_rtbtimer = 0;
+			ddq->d_bwarns = 0;
+			ddq->d_iwarns = 0;
+			ddq->d_rtbwarns = 0;
+		}
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			xfs_update_cksum((char *)&dqb[j],


