Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931E95A8DA1
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 07:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbiIAFts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 01:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiIAFtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 01:49:33 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0821B1178EB;
        Wed, 31 Aug 2022 22:49:17 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d5so8415095wms.5;
        Wed, 31 Aug 2022 22:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=6yyRgULoHRta/eb3LyurLgmxqUUvQOMkvOIjaPH3158=;
        b=g6NuDieey/R+ImRzcZ1wTMrdAV5kCw1Q+Czn5Cfe1WToMyqnG7/QXRKJ6WXjFHgDQW
         zoOK8QNUGf+dVhc6xklD/POc3tHL9egSXMATDefOCne8FIz7f9LAVsXrFbtgIlsyockc
         YB4g2IAU9BF+FZd2ncNFwfnbCDLXDiJzsN84AQd0ZJ4elH3CcZNrsqiU5HC+nspXbVjE
         Kf8RDN/wO9SSh5sSVHI0AfijvJ85ZIuw1Mo4gpLAKG0d/ASAaXyFQY95crGOqWhsfmof
         kjz1lT398+7vSzvaBIpGI5XNWa5AbfJd41n+Ys4J4rtED0KEXdQUpTb4q9T0s4spaWAF
         +l+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=6yyRgULoHRta/eb3LyurLgmxqUUvQOMkvOIjaPH3158=;
        b=wkkKR5we1Fl41cQ2I3lopI8d5dYUFbUrZnuncNDKZj2fnydnwe6OULUg1QgFZSQhMk
         hTTq61s0oQObZKSy1gxK6uAEKuNXQAmW628GpcKN50YHMLodYFjIW5/Z31S4o6eDWU3Q
         /NJbPQUaYJmOOqqfv7Qs4PVAbNhPDTf9voKlhoNem3uih1Y9Z1VRSO41Qao3Q2yjn0xs
         ijkPQ96yM9QFsQN/o2VAQliXR6H0WbPUvx6lPIxRoCxACxBPs5shX5iRuMnmsDz3asP6
         g/C083t4waUlrQ46T9ebmfvD93vgYMRWL+e4nvOBJK2vl+nbybxuUxWOwgxGMIOAqG5V
         9Jcw==
X-Gm-Message-State: ACgBeo0Mx0hkMuegwtEhxng2xV/BtFT23HSZMNPcuGY3/fXHGX+locYk
        yiXfLx9a2IHSCq8/J+JTxZc=
X-Google-Smtp-Source: AA6agR6lJRveGsUJMNiN6foTfoqKPphM/QrPewa0sAkh7Dmx37qve++Ac4G1+VxmEL6xC14o1W07BA==
X-Received: by 2002:a05:600c:1992:b0:3a6:23f6:8417 with SMTP id t18-20020a05600c199200b003a623f68417mr3757460wmq.14.1662011343318;
        Wed, 31 Aug 2022 22:49:03 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id bg15-20020a05600c3c8f00b003a4f08495b7sm4447262wmb.34.2022.08.31.22.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 22:49:02 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 v2 1/7] xfs: remove infinite loop when reserving free block pool
Date:   Thu,  1 Sep 2022 08:48:48 +0300
Message-Id: <20220901054854.2449416-2-amir73il@gmail.com>
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

commit 15f04fdc75aaaa1cccb0b8b3af1be290e118a7bc upstream.

[Added wrapper xfs_fdblocks_unavailable() for 5.10.y backport]

Infinite loops in kernel code are scary.  Calls to xfs_reserve_blocks
should be rare (people should just use the defaults!) so we really don't
need to try so hard.  Simplify the logic here by removing the infinite
loop.

Cc: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c | 52 +++++++++++++++++++---------------------------
 fs/xfs/xfs_mount.h |  8 +++++++
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ef1d5bb88b93..6d4f4271e7be 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -376,46 +376,36 @@ xfs_reserve_blocks(
 	 * If the request is larger than the current reservation, reserve the
 	 * blocks before we update the reserve counters. Sample m_fdblocks and
 	 * perform a partial reservation if the request exceeds free space.
+	 *
+	 * The code below estimates how many blocks it can request from
+	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
+	 * race since fdblocks updates are not always coordinated via
+	 * m_sb_lock.
 	 */
-	error = -ENOSPC;
-	do {
-		free = percpu_counter_sum(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
-		if (free <= 0)
-			break;
-
-		delta = request - mp->m_resblks;
-		lcounter = free - delta;
-		if (lcounter < 0)
-			/* We can't satisfy the request, just get what we can */
-			fdblks_delta = free;
-		else
-			fdblks_delta = delta;
-
+	free = percpu_counter_sum(&mp->m_fdblocks) -
+						xfs_fdblocks_unavailable(mp);
+	delta = request - mp->m_resblks;
+	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
-		 * count or we'll get an ENOSPC. If we get a ENOSPC, it means
-		 * things changed while we were calculating fdblks_delta and so
-		 * we should try again to see if there is anything left to
-		 * reserve.
-		 *
-		 * Don't set the reserved flag here - we don't want to reserve
-		 * the extra reserve blocks from the reserve.....
+		 * count or we'll get an ENOSPC.  Don't set the reserved flag
+		 * here - we don't want to reserve the extra reserve blocks
+		 * from the reserve.
 		 */
+		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
 		spin_lock(&mp->m_sb_lock);
-	} while (error == -ENOSPC);
 
-	/*
-	 * Update the reserve counters if blocks have been successfully
-	 * allocated.
-	 */
-	if (!error && fdblks_delta) {
-		mp->m_resblks += fdblks_delta;
-		mp->m_resblks_avail += fdblks_delta;
+		/*
+		 * Update the reserve counters if blocks have been successfully
+		 * allocated.
+		 */
+		if (!error) {
+			mp->m_resblks += fdblks_delta;
+			mp->m_resblks_avail += fdblks_delta;
+		}
 	}
-
 out:
 	if (outval) {
 		outval->resblks = mp->m_resblks;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dfa429b77ee2..3a6bc9dc11b5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -406,6 +406,14 @@ extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
 				     xfs_agnumber_t *maxagi);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
+/* Accessor added for 5.10.y backport */
+static inline uint64_t
+xfs_fdblocks_unavailable(
+	struct xfs_mount	*mp)
+{
+	return mp->m_alloc_set_aside;
+}
+
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
-- 
2.25.1

