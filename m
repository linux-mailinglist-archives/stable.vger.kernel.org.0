Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52E05407FD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348727AbiFGRxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349648AbiFGRv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3D813C1C4;
        Tue,  7 Jun 2022 10:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D6606157B;
        Tue,  7 Jun 2022 17:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B026C385A5;
        Tue,  7 Jun 2022 17:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623477;
        bh=jqBp+YTbylwh1DJj9yoGKwUK3G1UP5qserMh8zArCPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G13WpNndJKnjHTlWz5crhcQyQLLpQ1ujCIAqj2PF2mC8DaZTvZkW2LFtLR1FowzEo
         OSMHOUsZZYvNYQ2ede2UQbRLDGVto5aT7m/4xUaOP1Ljd0FabdTCJeWq+ViyLAKoB9
         AxG9ZljwvAWiQJsA5TsawNDeInSoNJQ5DHqpyt6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 433/452] xfs: fix incorrect root dquot corruption error when switching group/project quota types
Date:   Tue,  7 Jun 2022 19:04:50 +0200
Message-Id: <20220607164921.460244852@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 45068063efb7dd0a8d115c106aa05d9ab0946257 upstream.

While writing up a regression test for broken behavior when a chprojid
request fails, I noticed that we were logging corruption notices about
the root dquot of the group/project quota file at mount time when
testing V4 filesystems.

In commit afeda6000b0c, I was trying to improve ondisk dquot validation
by making sure that when we load an ondisk dquot into memory on behalf
of an incore dquot, the dquot id and type matches.  Unfortunately, I
forgot that V4 filesystems only have two quota files, and can switch
that file between group and project quota types at mount time.  When we
perform that switch, we'll try to load the default quota limits from the
root dquot prior to running quotacheck and log a corruption error when
the types don't match.

This is inconsequential because quotacheck will reset the second quota
file as part of doing the switch, but we shouldn't leave scary messages
in the kernel log.

Fixes: afeda6000b0c ("xfs: validate ondisk/incore dquot flags")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -500,6 +500,42 @@ xfs_dquot_alloc(
 	return dqp;
 }
 
+/* Check the ondisk dquot's id and type match what the incore dquot expects. */
+static bool
+xfs_dquot_check_type(
+	struct xfs_dquot	*dqp,
+	struct xfs_disk_dquot	*ddqp)
+{
+	uint8_t			ddqp_type;
+	uint8_t			dqp_type;
+
+	ddqp_type = ddqp->d_type & XFS_DQTYPE_REC_MASK;
+	dqp_type = xfs_dquot_type(dqp);
+
+	if (be32_to_cpu(ddqp->d_id) != dqp->q_id)
+		return false;
+
+	/*
+	 * V5 filesystems always expect an exact type match.  V4 filesystems
+	 * expect an exact match for user dquots and for non-root group and
+	 * project dquots.
+	 */
+	if (xfs_sb_version_hascrc(&dqp->q_mount->m_sb) ||
+	    dqp_type == XFS_DQTYPE_USER || dqp->q_id != 0)
+		return ddqp_type == dqp_type;
+
+	/*
+	 * V4 filesystems support either group or project quotas, but not both
+	 * at the same time.  The non-user quota file can be switched between
+	 * group and project quota uses depending on the mount options, which
+	 * means that we can encounter the other type when we try to load quota
+	 * defaults.  Quotacheck will soon reset the the entire quota file
+	 * (including the root dquot) anyway, but don't log scary corruption
+	 * reports to dmesg.
+	 */
+	return ddqp_type == XFS_DQTYPE_GROUP || ddqp_type == XFS_DQTYPE_PROJ;
+}
+
 /* Copy the in-core quota fields in from the on-disk buffer. */
 STATIC int
 xfs_dquot_from_disk(
@@ -512,8 +548,7 @@ xfs_dquot_from_disk(
 	 * Ensure that we got the type and ID we were looking for.
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
-	if ((ddqp->d_type & XFS_DQTYPE_REC_MASK) != xfs_dquot_type(dqp) ||
-	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
+	if (!xfs_dquot_check_type(dqp, ddqp)) {
 		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
 			  "Metadata corruption detected at %pS, quota %u",
 			  __this_address, dqp->q_id);


