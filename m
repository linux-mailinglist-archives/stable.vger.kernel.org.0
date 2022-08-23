Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C2E59E683
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 18:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbiHWQCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 12:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244296AbiHWQAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 12:00:43 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B8CE0FFD;
        Tue, 23 Aug 2022 05:12:17 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r16so16750935wrm.6;
        Tue, 23 Aug 2022 05:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=haOSYz+6QrKmwaD4BrFpRocUIGNsBlWlnI4UVn7k7XM=;
        b=IWFHNFKxPBd87IynPPP9ZcVhwZYPfgzUy2oQ2ZS4mCd9zGqhQTknGrnv4q2v/o6mA7
         EX5D+DMlkxxMg6H7XefzSCavmo9wsu3D0xGm+oxWWqFSLTrktbqoobVdNWeg1tPSi1tQ
         OeX21yT7IvyQgvB5QD1nEU/LvPQxihMRsqDfpa/BYLgz4kqj6oQ5qUvdG9rKkjlnqXV7
         nI/PWFIjVb16sYv2u7323DoqB87K7gK1nRWQZ0KihK03cg+elzbqy7OycoBYw3smniFj
         mXxbuYJpjl1rhvcQMPASEPoSnFgcY1uTZfGSBAnb7dloP5kyBVg71I8eSyYO3c1YYcPH
         zvdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=haOSYz+6QrKmwaD4BrFpRocUIGNsBlWlnI4UVn7k7XM=;
        b=TPq74ALHpPhqilFQQvfdet57xyQ1xaDOEIwx72S0rlpciusF3iFv1BuhvWVPRY94fR
         IF0e3G1hPVX6ivbgjwAWsOm7AUX/jlVhMYvIgRyQq3FaT6KDRDEQpXMgrKAIfonFxTLC
         9g5CALEQEHgNBztxTtsYF8FxbikZ32mgbtn5mABCEZeOMLgtYD15zRAT8Izduo6D/1Lc
         DKAe12no+oMoEXyjS5LS1rIIY6NhjM3olcOkRWKhMvPSgh1hxCjCxzrVQ9aJPqraSSUS
         XB7mOwyjDDNYnnG4OBPU6/B4o+M8fnIi+s1qmaFu/Jl3sXsDSssbL1e72utvxuReQqGw
         P9RA==
X-Gm-Message-State: ACgBeo04x3dicO2RLylrLNtUTYQNMCzzNbMW1QkCNikMULNEgO2az6uZ
        hd2VQg9XslSJWLVP0StaxKE=
X-Google-Smtp-Source: AA6agR6qzAhyO++YetpH1tZ2m534iaSAoVAufpjuu3nwbgo+lmwmvpZzWMy9hkHeF399T7Ke7CIDNw==
X-Received: by 2002:a5d:594a:0:b0:225:3606:da33 with SMTP id e10-20020a5d594a000000b002253606da33mr11254785wri.60.1661256712325;
        Tue, 23 Aug 2022 05:11:52 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c4ecb00b003a4c6e67f01sm24681879wmq.6.2022.08.23.05.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 05:11:51 -0700 (PDT)
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
Subject: [PATCH 5.10 v2 6/6] xfs: only bother with sync_filesystem during readonly remount
Date:   Tue, 23 Aug 2022 15:11:36 +0300
Message-Id: <20220823121136.1806820-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823121136.1806820-1-amir73il@gmail.com>
References: <20220823121136.1806820-1-amir73il@gmail.com>
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

From: "Darrick J. Wong" <djwong@kernel.org>

commit b97cca3ba9098522e5a1c3388764ead42640c1a5 upstream.

In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
into xfs_fs_remount.  The only time that we ever need to push dirty file
data or metadata to disk for a remount is if we're remounting the
filesystem read only, so this really could be moved to xfs_remount_ro.

Once we've moved the call site, actually check the return value from
sync_filesystem.

Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ff686cb16c7b..434c87cc9fbf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1720,6 +1720,11 @@ xfs_remount_ro(
 	};
 	int			error;
 
+	/* Flush all the dirty data to disk. */
+	error = sync_filesystem(mp->m_super);
+	if (error)
+		return error;
+
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
 	 * log force+buftarg wait and deadlock the remount.
@@ -1790,8 +1795,6 @@ xfs_fc_reconfigure(
 	if (error)
 		return error;
 
-	sync_filesystem(mp->m_super);
-
 	/* inode32 -> inode64 */
 	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
 	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
-- 
2.25.1

