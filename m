Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377ED329205
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243536AbhCAUiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:38:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238662AbhCAU3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:29:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 125BE64E04;
        Mon,  1 Mar 2021 18:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622060;
        bh=Ae5v0dVmRYeszKsSPJgZ1xqqmIL/GjkZv6ipVskhWCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+ki2+bF8tPsZULha3DxsChSFWMQSon4TY16SbN3HNeO6ZUFFGwD2eD1M0f2+0PEM
         kLxnukTJcIHNHSlQsWN+CI184lXKZs3elS5sw/qQ6uCfIm6n4XTqj8NHIfz7tqhhg7
         mtOzplh8w5+OrFhETKyYLdhHocVRElmMH0v3P4r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 743/775] cifs: fix nodfs mount option
Date:   Mon,  1 Mar 2021 17:15:11 +0100
Message-Id: <20210301161238.052107569@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit d01132ae50207bb6fd94e08e80c2d7b839408086 upstream.

Skip DFS resolving when mounting with 'nodfs' even if
CONFIG_CIFS_DFS_UPCALL is enabled.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org # 5.11
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3366,15 +3366,15 @@ int cifs_mount(struct cifs_sb_info *cifs
 
 	rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
 	/*
-	 * Unconditionally try to get an DFS referral (even cached) to determine whether it is an
-	 * DFS mount.
+	 * If called with 'nodfs' mount option, then skip DFS resolving.  Otherwise unconditionally
+	 * try to get an DFS referral (even cached) to determine whether it is an DFS mount.
 	 *
 	 * Skip prefix path to provide support for DFS referrals from w2k8 servers which don't seem
 	 * to respond with PATH_NOT_COVERED to requests that include the prefix.
 	 */
-	if (dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb), ctx->UNC + 1, NULL,
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
+	    dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb), ctx->UNC + 1, NULL,
 			   NULL)) {
-		/* No DFS referral was returned.  Looks like a regular share. */
 		if (rc)
 			goto error;
 		/* Check if it is fully accessible and then mount it */


