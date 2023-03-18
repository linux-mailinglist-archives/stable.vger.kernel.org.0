Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77DF6BF958
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjCRKPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCRKPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:47 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1862410D;
        Sat, 18 Mar 2023 03:15:45 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id g18so4702679wmk.0;
        Sat, 18 Mar 2023 03:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SN211lgBBr1aJAJHF2diSYORjNp/PE39Z5mZHl1CgbA=;
        b=S42YikshP9VmCZNe8KEtdxt0mJtmNJoVS06CBk4TTsrOFAiLeo0dkBesF5awmrSrUE
         lV0lWT5+tUyeVTIY7njJh9K2yGDeUHIa2i5mZtlCfSjJduaq2/cVQ9g3eBrnwmx8kRlZ
         NXqRxOGo438w6G0qsytewNVd1Id1o2sCaZQLCzwTuuLTcT9HElOPTsD3WGyF8Ibq4aEQ
         kY2zycNJacFzoDOUDx9ttrmtER50L2XqJsClxm7YxceQdgo/aLsQtWj7XEsxfOMhmzLH
         v0RxZTcT3lxZOQotNKHPsbDUHsWFgWYUmfGNYin1PC5OXLtsEbVS4+RWBV4As8X/D0lQ
         wPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SN211lgBBr1aJAJHF2diSYORjNp/PE39Z5mZHl1CgbA=;
        b=oWZ2MibVuiPg6/ekGiYIuNiRGNlmtZXEgvh0yo33FZl8lJP6e/F07/ZNaRRYcrlEwA
         gFv/bLIdDj5HMMnMgr9zbPQrmH0qmWXzt/SB6OXSLH5O0TdKnoa6U9HPXB/8OI8jtGmS
         oRSzxhzZP5P1qoi3GyVN8P7eHYWRZUp/9stb/H8HEgC/wY35gxCV+zpI2I0TzOB1M7Di
         GCUMEgXHcG9V9CaquuOEwBz4wDWHsctllhPBAzFsszqmODxrQ4GY8IKcV8Fg9vqWMYQ+
         RmxrBPAWMD17L6EP3k57i0tg9BmKU41+OvB/wYmgk/iYuCc0ipbn1nCl4C+h9fZ2nMUQ
         lYsw==
X-Gm-Message-State: AO0yUKXGmC/sdestQIHnVjAwxOyhmOSMJGgLGQ2F2xvxydSILjZWD3Gu
        PWeY8lsfw/1BAVczF8DnIaS4e7tNtbM=
X-Google-Smtp-Source: AK7set8foq+c1VGq0VTPnmeHhsWdwegl+tE6RaFUNYIckxtZHbZP2AQ91385e5mX0szrEwWPf+Tmng==
X-Received: by 2002:a7b:c3d7:0:b0:3ed:a80e:6dfa with SMTP id t23-20020a7bc3d7000000b003eda80e6dfamr1322285wmj.40.1679134543965;
        Sat, 18 Mar 2023 03:15:43 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:43 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 05/15] xfs: fallocate() should call file_modified()
Date:   Sat, 18 Mar 2023 12:15:19 +0200
Message-Id: <20230318101529.1361673-6-amir73il@gmail.com>
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

commit fbe7e520036583a783b13ff9744e35c2a329d9a4 upstream.

In XFS, we always update the inode change and modification time when
any fallocate() operation succeeds.  Furthermore, as various
fallocate modes can change the file contents (extending EOF,
punching holes, zeroing things, shifting extents), we should drop
file privileges like suid just like we do for a regular write().
There's already a VFS helper that figures all this out for us, so
use that.

The net effect of this is that we no longer drop suid/sgid if the
caller is root, but we also now drop file capabilities.

We also move the xfs_update_prealloc_flags() function so that it now
is only called by the scope that needs to set the the prealloc flag.

Based on a patch from Darrick Wong.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_file.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 630525b1da77..a95af57a59a7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -895,6 +895,10 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
+	error = file_modified(file);
+	if (error)
+		goto out_unlock;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -996,11 +1000,12 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-	}
 
-	error = xfs_update_prealloc_flags(ip, flags);
-	if (error)
-		goto out_unlock;
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (error)
+			goto out_unlock;
+
+	}
 
 	/* Change file size if needed */
 	if (new_size) {
-- 
2.34.1

