Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796945A483B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiH2LHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiH2LG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:06:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE192AF0;
        Mon, 29 Aug 2022 04:05:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E221611AE;
        Mon, 29 Aug 2022 11:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AECCC433C1;
        Mon, 29 Aug 2022 11:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771029;
        bh=dqiK5REKnPU8x64zwxWtImY5F8JfmY7KSRGoi8YzrXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNKvbu3RZ/dhFTogfQdzuz3TSAP2YvoKNyaVAFDORB0WVA5oYzqjkqxBjUe7B8TJ/
         bJDVInykwWt4ZxfTQBd5o0c1+IpfHQpOV9lXe6htDQkkHTrS2y0GX5F4c7bdJlD9kC
         mNYTi6DD2oOBjZryH6d5VodUpBUtiW0ZRoeHYGBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 10/86] xfs: only bother with sync_filesystem during readonly remount
Date:   Mon, 29 Aug 2022 12:58:36 +0200
Message-Id: <20220829105756.962345456@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

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


