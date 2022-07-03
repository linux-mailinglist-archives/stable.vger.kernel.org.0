Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF377564538
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 07:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiGCFFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 01:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiGCFFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 01:05:14 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A09AE69;
        Sat,  2 Jul 2022 22:05:13 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id g39-20020a05600c4ca700b003a03ac7d540so6010368wmp.3;
        Sat, 02 Jul 2022 22:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XuR6csBt5VIuujm9Pevv35ft13+Qv2iA32WgWJOoFTg=;
        b=qlWpFJPwTbAdaZy3PdM5KNLWuwcqjyaEUUkdGeW1FOrlD2ZOOEUwsfe1eMsY5hAV+m
         ZXiXKnsCaJkTUniyHl/A4t7Et3+ZgtYtlzQkTaYeBjd1zLZtSN+csAoJ7ah1S3OOjaO5
         KoRRz58hwBi+utsOXEE0+AgwE1AJQUl8GLwLxEPKBmvF5REH9Qh3ojIHFjwuWMkDukbF
         5PLf2kTj9qxaIMS6DF1oM0aKSjONuN9hTYB8gaA8Fk5WKvtLGvm9sxS94FjnBa0Cxhgz
         mS1wggIWALnBW1DiYYh9W32cBBdLP9EikgVXPy56UPu2H//6d2yx+Db6rKXhldg8cOSj
         yMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XuR6csBt5VIuujm9Pevv35ft13+Qv2iA32WgWJOoFTg=;
        b=Bq75bcZTe8C0XAsWPFsG2up5+cdMpmg+ZCyYJGerC6URDB4D5XTP2ZexQkeikcIhta
         ad8rAHmBGeBqL0c+KePVKt/uH9fD7H2N1bt4yfhqOHC44eTsdM0BulwnKlgQtNG4iAmI
         Yb3lyN50o/WpYc457HTeZLGN2tKFfHMWHS1oqyU9oBicRnU/uVJHWftmUN1/nPQT0UwV
         8xMFhzZDJYC7lQloVs3rIBhPtbLuf/ZepED6GhHFwDUPfmy/diEB2HnG0Vy5K91ZCKzF
         jq873xId5em4IX0Pul3kK2jsCKTW6ybsjfrXZuoeE71UPOy8e79AHJ8+MftIlazFFQGJ
         86sQ==
X-Gm-Message-State: AJIora+FI1vlRz+6pjKPCETcp/JEpIp5cn6SD9v65okJN0faLr67O0N0
        Y5Kfz+Ce1JSmSZqp7tXjNq4=
X-Google-Smtp-Source: AGRyM1uaHFYT7w4INEofcj8PmW7cMnBRKcwitzYCF1KzewbdDDmgILDKe8V7fy+3DlifMOcXowg2yA==
X-Received: by 2002:a05:600c:1ca9:b0:3a1:887d:1567 with SMTP id k41-20020a05600c1ca900b003a1887d1567mr13671289wms.175.1656824712096;
        Sat, 02 Jul 2022 22:05:12 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id e2-20020adfdbc2000000b0021b9f126fd3sm27028952wrj.14.2022.07.02.22.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 22:05:11 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 v3 6/7] xfs: update superblock counters correctly for !lazysbcount
Date:   Sun,  3 Jul 2022 08:04:55 +0300
Message-Id: <20220703050456.3222610-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220703050456.3222610-1-amir73il@gmail.com>
References: <20220703050456.3222610-1-amir73il@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

commit 6543990a168acf366f4b6174d7bd46ba15a8a2a6 upstream.

Keep the mount superblock counters up to date for !lazysbcount
filesystems so that when we log the superblock they do not need
updating in any way because they are already correct.

It's found by what Zorro reported:
1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
2. mount $dev $mnt
3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
4. umount $mnt
5. xfs_repair -n $dev
and I've seen no problem with this patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reported-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 16 +++++++++++++---
 fs/xfs/xfs_trans.c     |  3 +++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5aeafa59ed27..66e8353da2f3 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -956,9 +956,19 @@ xfs_log_sb(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*bp = xfs_trans_getsb(tp);
 
-	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
-	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
-	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	/*
+	 * Lazy sb counters don't update the in-core superblock so do that now.
+	 * If this is at unmount, the counters will be exactly correct, but at
+	 * any other time they will only be ballpark correct because of
+	 * reservations that have been taken out percpu counters. If we have an
+	 * unclean shutdown, this will be corrected by log recovery rebuilding
+	 * the counters from the AGF block counts.
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
+		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 2d7deacea2cf..36166bae24a6 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -615,6 +615,9 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
+	mp->m_sb.sb_icount += idelta;
+	mp->m_sb.sb_ifree += ifreedelta;
 	mp->m_sb.sb_frextents += rtxdelta;
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
-- 
2.25.1

