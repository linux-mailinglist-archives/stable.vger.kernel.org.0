Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EE0566BD3
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiGEMJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbiGEMIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23AA186F3;
        Tue,  5 Jul 2022 05:07:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 666C8B817DA;
        Tue,  5 Jul 2022 12:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65A6C341C7;
        Tue,  5 Jul 2022 12:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022874;
        bh=OvnhGOcUqjoChuGDNgWAkekn3mPvdrJyY3fxt/tWztw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pspwmvBb01EJyQ919WMamR0WP96eJe9LYSg+0T/ng4YcEaBy6yTfU/xKMz+fHBoHf
         VfBsQdVUU/81RfvV72FBa9wj/yCWDbld7hJ8qGl77jnEZ/ofvRVVi9VHg68W86fGfA
         OhafwfRilcKqvu8godzgReyEp7BwkXiLlB8Vi2qQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Pavel Reichl <preichl@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 42/84] xfs: rename variable mp to parsing_mp
Date:   Tue,  5 Jul 2022 13:58:05 +0200
Message-Id: <20220705115616.550135317@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |  102 ++++++++++++++++++++++++++---------------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

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
 


