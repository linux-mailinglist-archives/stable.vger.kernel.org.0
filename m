Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3BE6BF955
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjCRKPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjCRKPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:45 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A9F28231;
        Sat, 18 Mar 2023 03:15:43 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id ip21-20020a05600ca69500b003ed56690948so4337522wmb.1;
        Sat, 18 Mar 2023 03:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KgTIRGgLDwbCat3zch5MMu/wejmfIPRpBTIP2AxcCWU=;
        b=Dtf8yWt6UlzIXHWCMs+nXtlnl8nhPxxq5xr5iZoAhhgz92MuYOje4/BeaDkkrT9nGk
         HgxrKxO8D5oUw/YZU9kET/6VH618xtEsY5EYtnR0beR8j3Jgmi4l10ykI4X6fd1whkNK
         qN6Z38Z3/TPwNsPKe2EQtzvhtzZXRPRBhnc9dn0dh5p4rOUxpN90mhgmAtbHuY1G73I0
         bmS8FuG17e53Gd2toQTruz4lhx+qARAbKxUIWTBtzeI4qABoVaT/J2lw+XkFp5W1DUH8
         nUv/S1T5yCX55E4xIOHR2OKNLp/M8g/7DxneaEcFpsrXxIYoVx33VAZ01pGEwY0Ejil0
         LK9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KgTIRGgLDwbCat3zch5MMu/wejmfIPRpBTIP2AxcCWU=;
        b=JeX7iV7cK8S2Xp9XyhhENRxzPSMBTy0/gPJ8zwtMvNRjIyCJvaHMmWbe37PwZlDY7t
         T3hERm87qF3G4wviCZ8L06mDWvaIa1/ROHNjLNHunaOjyLBY3EXsCJoLpYBLqyUsO++5
         mQbu0fAELDGxo+3J9g0GtfgsHrnVlPXjWUM4ZLXfgl22J5ZYK07UWrLba+6GfR2DwthX
         hSfcLUw3q+kvrJJjO4vjSBSNMwM6+kieBKcuuF/ySbsG8eZ+YO8d63O+iNNhqcggb5GE
         CM9ip4BCGofhZSh2mfOnrYDwKyeBVYN4X8yw7lFz+yNdOtI8ISwpZVCgUUIdW+qdaOe6
         DtmQ==
X-Gm-Message-State: AO0yUKU+fQBXbxF+Ex5osfbuAcR4Kyyw8WDtiZHAjIfNejNh1i4dqdzG
        0Fmklne8xOOqPLE+rRt17rg=
X-Google-Smtp-Source: AK7set+RHOBxqbOwKyYtu03a9pBX3MMZm55ZYMXevQYuTkLuZcA3xe3Zl3mtGITIebUURvFci6hQZg==
X-Received: by 2002:a05:600c:45d2:b0:3ed:2105:9abc with SMTP id s18-20020a05600c45d200b003ed21059abcmr20837891wmo.14.1679134542388;
        Sat, 18 Mar 2023 03:15:42 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:42 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 04/15] xfs: remove XFS_PREALLOC_SYNC
Date:   Sat, 18 Mar 2023 12:15:18 +0200
Message-Id: <20230318101529.1361673-5-amir73il@gmail.com>
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

commit 472c6e46f589c26057596dcba160712a5b3e02c5 upstream.

[partial backport for dependency -
 xfs_ioc_space() still uses XFS_PREALLOC_SYNC]

Callers can acheive the same thing by calling xfs_log_force_inode()
after making their modifications. There is no need for
xfs_update_prealloc_flags() to do this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_file.c | 13 +++++++------
 fs/xfs/xfs_pnfs.c |  6 ++++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4d6bf8d4974f..630525b1da77 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -94,8 +94,6 @@ xfs_update_prealloc_flags(
 		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	if (flags & XFS_PREALLOC_SYNC)
-		xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp);
 }
 
@@ -1000,9 +998,6 @@ xfs_file_fallocate(
 		}
 	}
 
-	if (file->f_flags & O_DSYNC)
-		flags |= XFS_PREALLOC_SYNC;
-
 	error = xfs_update_prealloc_flags(ip, flags);
 	if (error)
 		goto out_unlock;
@@ -1024,8 +1019,14 @@ xfs_file_fallocate(
 	 * leave shifted extents past EOF and hence losing access to
 	 * the data that is contained within them.
 	 */
-	if (do_file_insert)
+	if (do_file_insert) {
 		error = xfs_insert_file_space(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (file->f_flags & O_DSYNC)
+		error = xfs_log_force_inode(ip);
 
 out_unlock:
 	xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f3082a957d5e..64ab54f2fe81 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -164,10 +164,12 @@ xfs_fs_map_blocks(
 		 * that the blocks allocated and handed out to the client are
 		 * guaranteed to be present even after a server crash.
 		 */
-		error = xfs_update_prealloc_flags(ip,
-				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (!error)
+			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
+
 	} else {
 		xfs_iunlock(ip, lock_flags);
 	}
-- 
2.34.1

