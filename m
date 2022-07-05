Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11313566BDB
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbiGEMJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbiGEMIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2425018E28;
        Tue,  5 Jul 2022 05:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B8E8CE0B30;
        Tue,  5 Jul 2022 12:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B087C341C7;
        Tue,  5 Jul 2022 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022877;
        bh=2JtqIbtFJfdDNZ4T/8szuSSA4AJdQvZzvM4BVV86cwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CP6TAaKIwESAk/wmM4SCK08fZJJbf2SCqv8YIG8YU2gsMsLa1/n9e15D9F2EOVXTc
         qDpKxAgTVRZLr1+eY6V3aX77d2d9VMBhLUSnnUDOkQH7PhcNxx1BIWv3DjEKsFkGM2
         aiLSnkoxOuG8pVroAqhAHtMx4UNdSSp+BRe7QbPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Reichl <preichl@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5.10 43/84] xfs: Skip repetitive warnings about mount options
Date:   Tue,  5 Jul 2022 13:58:06 +0200
Message-Id: <20220705115616.580197652@linuxfoundation.org>
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

commit 92cf7d36384b99d5a57bf4422904a3c16dc4527a upstream.

Skip the warnings about mount option being deprecated if we are
remounting and deprecated option state is not changing.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211605
Fix-suggested-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1155,6 +1155,22 @@ suffix_kstrtoint(
 	return ret;
 }
 
+static inline void
+xfs_fs_warn_deprecated(
+	struct fs_context	*fc,
+	struct fs_parameter	*param,
+	uint64_t		flag,
+	bool			value)
+{
+	/* Don't print the warning if reconfiguring and current mount point
+	 * already had the flag set
+	 */
+	if ((fc->purpose & FS_CONTEXT_FOR_RECONFIGURE) &&
+			!!(XFS_M(fc->root->d_sb)->m_flags & flag) == value)
+		return;
+	xfs_warn(fc->s_fs_info, "%s mount option is deprecated.", param->key);
+}
+
 /*
  * Set mount state from a mount option.
  *
@@ -1294,19 +1310,19 @@ xfs_fc_parse_param(
 #endif
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
 		parsing_mp->m_flags |= XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_noikeep:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, false);
 		parsing_mp->m_flags &= ~XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_attr2:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_ATTR2, true);
 		parsing_mp->m_flags |= XFS_MOUNT_ATTR2;
 		return 0;
 	case Opt_noattr2:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_NOATTR2, true);
 		parsing_mp->m_flags &= ~XFS_MOUNT_ATTR2;
 		parsing_mp->m_flags |= XFS_MOUNT_NOATTR2;
 		return 0;


