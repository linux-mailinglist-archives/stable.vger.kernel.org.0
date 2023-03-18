Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981D06BF95B
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCRKP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCRKPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:47 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0C62E838;
        Sat, 18 Mar 2023 03:15:46 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id ip21-20020a05600ca69500b003ed56690948so4337563wmb.1;
        Sat, 18 Mar 2023 03:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kUvv3uBGGOzJwwn6KRNuDlAWVNfTAIS5jkw/tF5MpM=;
        b=eW37GhIIeMcGMB3jYcOgMYx9qZZoIQkvsQHcLvSPYsyeSPxcfdo0KMKFVMT/Su4y5U
         drmiUmYB3lZU7NA6ECeQa6Gf9I47n2TPISb2yOB3WWLqu43RJkCcD5zOz4i5UzskRGPE
         1gLM6o4sKicFAGOYBINFv23VflvDYi+Mv7ud/dmvoWVgCRVx0f0mQEL2jdo1ZGMKIKmR
         MCNr2rzrKpvSJPNNdw5osyJr53Rbt1HeUVm5pD8i8MP+k6WPC1/c7gw3phk+CH8PVGW8
         B/+JZsHau+rGVGK+LM5KB+fokxFJZWSfclKvln5fd1wutPYdY+afd1VOLXrJcbPgh31u
         S6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kUvv3uBGGOzJwwn6KRNuDlAWVNfTAIS5jkw/tF5MpM=;
        b=a/AeDjfAX8qshX7DarkSSfGSTKHbMw/oS95jx2OvF6rc/V1bBIG1R9yRUijKSstptC
         PCrdCZwxyI3s1DXd4VWruz3hL6QK0h1mwX4t4X8hQ4caLJTc+mxrXgW/HEEPlGnGWWJs
         ZVBSIwztyjbnxQ/ia6unlrlc61ZJoHYEvWxZgNkDyTcujlVRxrdJwgeU8+Lcggv2yoL/
         IQkZeQpUtpOUnrR9GdHJ+5YoYW9cz95tHlwKYft0BqCa+hdrLL+d/Um8lez+Kxw2oq5a
         sggtmWN8Bi4Dj2nRLcE7KMoB9cGGKrj4KrSBCHj6zOAy3GzBu645F7U4/89qPdmDTEt4
         JL3g==
X-Gm-Message-State: AO0yUKU2c/QCnGuttlTFS8i6blFc7wuctHqmOY/9oX9fHP4aeFbY/DTG
        +Po61B8mFp04W7JKWhfuJ9U=
X-Google-Smtp-Source: AK7set+mr5Mxf3uSiKYQFGIidIrZ2inP8iYGI7qQtyPDygLenp7ZDeJMAxVl6M/5e/HPtowVHAHcKQ==
X-Received: by 2002:a05:600c:3b99:b0:3ed:2352:eebd with SMTP id n25-20020a05600c3b9900b003ed2352eebdmr20339096wms.11.1679134545492;
        Sat, 18 Mar 2023 03:15:45 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:45 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 06/15] xfs: set prealloc flag in xfs_alloc_file_space()
Date:   Sat, 18 Mar 2023 12:15:20 +0200
Message-Id: <20230318101529.1361673-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
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

commit 0b02c8c0d75a738c98c35f02efb36217c170d78c upstream.

[backport for 5.10.y]

Now that we only call xfs_update_prealloc_flags() from
xfs_file_fallocate() in the case where we need to set the
preallocation flag, do this in xfs_alloc_file_space() where we
already have the inode joined into a transaction and get
rid of the call to xfs_update_prealloc_flags() from the fallocate
code.

This also means that we now correctly avoid setting the
XFS_DIFLAG_PREALLOC flag when xfs_is_always_cow_inode() is true, as
these inodes will never have preallocated extents.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_bmap_util.c | 9 +++------
 fs/xfs/xfs_file.c      | 8 --------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7371a7f7c652..fbab1042bc90 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -800,9 +800,6 @@ xfs_alloc_file_space(
 			quota_flag = XFS_QMOPT_RES_REGBLKS;
 		}
 
-		/*
-		 * Allocate and setup the transaction.
-		 */
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
 				resrtextents, 0, &tp);
 
@@ -830,9 +827,9 @@ xfs_alloc_file_space(
 		if (error)
 			goto error0;
 
-		/*
-		 * Complete the transaction
-		 */
+		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a95af57a59a7..9b6c5ba5fdfb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -850,7 +850,6 @@ xfs_file_fallocate(
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	long			error;
-	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	loff_t			new_size = 0;
 	bool			do_file_insert = false;
@@ -948,8 +947,6 @@ xfs_file_fallocate(
 		}
 		do_file_insert = true;
 	} else {
-		flags |= XFS_PREALLOC_SET;
-
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
 			new_size = offset + len;
@@ -1000,11 +997,6 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-
-		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
-		if (error)
-			goto out_unlock;
-
 	}
 
 	/* Change file size if needed */
-- 
2.34.1

