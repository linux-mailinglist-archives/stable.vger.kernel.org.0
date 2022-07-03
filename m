Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1372356453F
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 07:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiGCFFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 01:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiGCFFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 01:05:07 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AB1AE60;
        Sat,  2 Jul 2022 22:05:06 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id t17-20020a1c7711000000b003a0434b0af7so3822077wmi.0;
        Sat, 02 Jul 2022 22:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s1o3LmoNwnhjJpsGkuftqrddAaAG+j8fYiABI4g5FE0=;
        b=kJytoVHDIxS/8nC4cto3YZLcHhxIbl240gNtpgrz5pLn6IPQ95SZOR9hvnWmzFit+G
         8j+xwssRUE+oF/ofYOmpQBVeR61008xsNFzCptXXBBn0d7aw9RpLg/IGLEAfU40bRALt
         S9HPSQ+g6W9YJzJJh6KowlaIrXh+Pg3AsBO4N6cknIYOQ1SVbX6CdKbn8af+NoR3kzkK
         Dqkr/u1weugxHthP/dReMwmJf0cBLRSmZFwPgfhFopd7lKySKfQEWDRGmt/4rnHOG4aS
         7X+UcRchqb4IfYeVDcq/H08ypwc4CtL8dH8/c6lOnK9Y6OEiiezJMX7sUwPb5A96aDaC
         ZFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s1o3LmoNwnhjJpsGkuftqrddAaAG+j8fYiABI4g5FE0=;
        b=OUztSQ9CtDf09eExmJiWxZgGh7I8xa9dZ2kWWqyLYxPlGAuw5U/8m9vm8CbrD6xwnY
         MWoK5115hcOKp0idWSzAynaXaOb++8q61kvcNtkc1Dk1iiGW5mPRzUsz86kBNTqC/gG1
         Hlw8Szh2DS+HadPGTnsh3lfXRC8kgKM+4BUQ5XRdT6tlqtxITZkKieXb+BodryABOuJe
         rTVK0XF/l/JY+zpH7x9kQs39nd0Jpe7cqWF+VOqX1FWobP9lL8zatwqH4SoX1Uw4vczO
         Du/eLkGcWEBXjqfaeLnceLiuiHC6r9hhrF5u4Jly0/f13yw6uNc1lTsDMSbkmgJLW8Xy
         WAaQ==
X-Gm-Message-State: AJIora+PFyAjWoSgMo3R+JtRAjT5PwhAbR25etXSR76w6W3Kpa3gDVm0
        qjK4cwNP6PJDqfINVD5CZkk=
X-Google-Smtp-Source: AGRyM1uMcZ2rHkVNmPG1EEe8vwnlne3YAtameJmh9YumbzKHSYhdor7nLKbuwFNsKQyX9UfUMxsquA==
X-Received: by 2002:a05:600c:1908:b0:3a0:bfaa:38c with SMTP id j8-20020a05600c190800b003a0bfaa038cmr24509935wmq.130.1656824704851;
        Sat, 02 Jul 2022 22:05:04 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id e2-20020adfdbc2000000b0021b9f126fd3sm27028952wrj.14.2022.07.02.22.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 22:05:04 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 5.10 v3 2/7] xfs: rename variable mp to parsing_mp
Date:   Sun,  3 Jul 2022 08:04:51 +0300
Message-Id: <20220703050456.3222610-3-amir73il@gmail.com>
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

From: Pavel Reichl <preichl@redhat.com>

commit 0f98b4ece18da9d8287bb4cc4e8f78b8760ea0d0 upstream.

Rename mp variable to parsisng_mp so it is easy to distinguish
between current mount point handle and handle for mount point
which mount options are being parsed.

Suggested-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 102 ++++++++++++++++++++++-----------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 05cea7788d49..cba47adbbfdc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1165,7 +1165,7 @@ xfs_fc_parse_param(
 	struct fs_context	*fc,
 	struct fs_parameter	*param)
 {
-	struct xfs_mount	*mp = fc->s_fs_info;
+	struct xfs_mount	*parsing_mp = fc->s_fs_info;
 	struct fs_parse_result	result;
 	int			size = 0;
 	int			opt;
@@ -1176,142 +1176,142 @@ xfs_fc_parse_param(
 
 	switch (opt) {
 	case Opt_logbufs:
-		mp->m_logbufs = result.uint_32;
+		parsing_mp->m_logbufs = result.uint_32;
 		return 0;
 	case Opt_logbsize:
-		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
+		if (suffix_kstrtoint(param->string, 10, &parsing_mp->m_logbsize))
 			return -EINVAL;
 		return 0;
 	case Opt_logdev:
-		kfree(mp->m_logname);
-		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
-		if (!mp->m_logname)
+		kfree(parsing_mp->m_logname);
+		parsing_mp->m_logname = kstrdup(param->string, GFP_KERNEL);
+		if (!parsing_mp->m_logname)
 			return -ENOMEM;
 		return 0;
 	case Opt_rtdev:
-		kfree(mp->m_rtname);
-		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
-		if (!mp->m_rtname)
+		kfree(parsing_mp->m_rtname);
+		parsing_mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
+		if (!parsing_mp->m_rtname)
 			return -ENOMEM;
 		return 0;
 	case Opt_allocsize:
 		if (suffix_kstrtoint(param->string, 10, &size))
 			return -EINVAL;
-		mp->m_allocsize_log = ffs(size) - 1;
-		mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
+		parsing_mp->m_allocsize_log = ffs(size) - 1;
+		parsing_mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
 		return 0;
 	case Opt_grpid:
 	case Opt_bsdgroups:
-		mp->m_flags |= XFS_MOUNT_GRPID;
+		parsing_mp->m_flags |= XFS_MOUNT_GRPID;
 		return 0;
 	case Opt_nogrpid:
 	case Opt_sysvgroups:
-		mp->m_flags &= ~XFS_MOUNT_GRPID;
+		parsing_mp->m_flags &= ~XFS_MOUNT_GRPID;
 		return 0;
 	case Opt_wsync:
-		mp->m_flags |= XFS_MOUNT_WSYNC;
+		parsing_mp->m_flags |= XFS_MOUNT_WSYNC;
 		return 0;
 	case Opt_norecovery:
-		mp->m_flags |= XFS_MOUNT_NORECOVERY;
+		parsing_mp->m_flags |= XFS_MOUNT_NORECOVERY;
 		return 0;
 	case Opt_noalign:
-		mp->m_flags |= XFS_MOUNT_NOALIGN;
+		parsing_mp->m_flags |= XFS_MOUNT_NOALIGN;
 		return 0;
 	case Opt_swalloc:
-		mp->m_flags |= XFS_MOUNT_SWALLOC;
+		parsing_mp->m_flags |= XFS_MOUNT_SWALLOC;
 		return 0;
 	case Opt_sunit:
-		mp->m_dalign = result.uint_32;
+		parsing_mp->m_dalign = result.uint_32;
 		return 0;
 	case Opt_swidth:
-		mp->m_swidth = result.uint_32;
+		parsing_mp->m_swidth = result.uint_32;
 		return 0;
 	case Opt_inode32:
-		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+		parsing_mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
 		return 0;
 	case Opt_inode64:
-		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+		parsing_mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
 		return 0;
 	case Opt_nouuid:
-		mp->m_flags |= XFS_MOUNT_NOUUID;
+		parsing_mp->m_flags |= XFS_MOUNT_NOUUID;
 		return 0;
 	case Opt_largeio:
-		mp->m_flags |= XFS_MOUNT_LARGEIO;
+		parsing_mp->m_flags |= XFS_MOUNT_LARGEIO;
 		return 0;
 	case Opt_nolargeio:
-		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
+		parsing_mp->m_flags &= ~XFS_MOUNT_LARGEIO;
 		return 0;
 	case Opt_filestreams:
-		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
+		parsing_mp->m_flags |= XFS_MOUNT_FILESTREAMS;
 		return 0;
 	case Opt_noquota:
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
+		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
+		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
 		return 0;
 	case Opt_quota:
 	case Opt_uquota:
 	case Opt_usrquota:
-		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
+		parsing_mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
 				 XFS_UQUOTA_ENFD);
 		return 0;
 	case Opt_qnoenforce:
 	case Opt_uqnoenforce:
-		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
-		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
+		parsing_mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
+		parsing_mp->m_qflags &= ~XFS_UQUOTA_ENFD;
 		return 0;
 	case Opt_pquota:
 	case Opt_prjquota:
-		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
+		parsing_mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
 				 XFS_PQUOTA_ENFD);
 		return 0;
 	case Opt_pqnoenforce:
-		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
-		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
+		parsing_mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
+		parsing_mp->m_qflags &= ~XFS_PQUOTA_ENFD;
 		return 0;
 	case Opt_gquota:
 	case Opt_grpquota:
-		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
+		parsing_mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
 				 XFS_GQUOTA_ENFD);
 		return 0;
 	case Opt_gqnoenforce:
-		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
-		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
+		parsing_mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
+		parsing_mp->m_qflags &= ~XFS_GQUOTA_ENFD;
 		return 0;
 	case Opt_discard:
-		mp->m_flags |= XFS_MOUNT_DISCARD;
+		parsing_mp->m_flags |= XFS_MOUNT_DISCARD;
 		return 0;
 	case Opt_nodiscard:
-		mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		parsing_mp->m_flags &= ~XFS_MOUNT_DISCARD;
 		return 0;
 #ifdef CONFIG_FS_DAX
 	case Opt_dax:
-		xfs_mount_set_dax_mode(mp, XFS_DAX_ALWAYS);
+		xfs_mount_set_dax_mode(parsing_mp, XFS_DAX_ALWAYS);
 		return 0;
 	case Opt_dax_enum:
-		xfs_mount_set_dax_mode(mp, result.uint_32);
+		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
 		return 0;
 #endif
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
-		mp->m_flags |= XFS_MOUNT_IKEEP;
+		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		parsing_mp->m_flags |= XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_noikeep:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
-		mp->m_flags &= ~XFS_MOUNT_IKEEP;
+		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		parsing_mp->m_flags &= ~XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_attr2:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
-		mp->m_flags |= XFS_MOUNT_ATTR2;
+		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		parsing_mp->m_flags |= XFS_MOUNT_ATTR2;
 		return 0;
 	case Opt_noattr2:
-		xfs_warn(mp, "%s mount option is deprecated.", param->key);
-		mp->m_flags &= ~XFS_MOUNT_ATTR2;
-		mp->m_flags |= XFS_MOUNT_NOATTR2;
+		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		parsing_mp->m_flags &= ~XFS_MOUNT_ATTR2;
+		parsing_mp->m_flags |= XFS_MOUNT_NOATTR2;
 		return 0;
 	default:
-		xfs_warn(mp, "unknown mount option [%s].", param->key);
+		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
 	}
 
-- 
2.25.1

