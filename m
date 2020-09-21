Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACA5272E58
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgIUQsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729616AbgIUQsL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:48:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2102E23888;
        Mon, 21 Sep 2020 16:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706890;
        bh=kehCFbfvPmd28tKBN501R2yONM3sM5wm1unw4+GdN+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5jTiNLVOOkPbSzuiXxY+r3v7f8zKS6UMzUyUK/Jqx0PMD0g8jpXZvNZEGHmwrA+1
         JZmZB1NtJzsj1ERZ1d1bUj1OjuswSc275VbaALAWlnvGQLkFmh4oaXFLzteg9C1CtZ
         /5i/oZMGSgAs99CAzFFl660fuxi6xKEIaNRlpqOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/72] cifs: fix DFS mount with cifsacl/modefromsid
Date:   Mon, 21 Sep 2020 18:30:56 +0200
Message-Id: <20200921163122.692523738@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 01ec372cef1e5afa4ab843bbaf88a6fcb64dc14c ]

RHBZ: 1871246

If during cifs_lookup()/get_inode_info() we encounter a DFS link
and we use the cifsacl or modefromsid mount options we must suppress
any -EREMOTE errors that triggers or else we will not be able to follow
the DFS link and automount the target.

This fixes an issue with modefromsid/cifsacl where these mountoptions
would break DFS and we would no longer be able to access the share.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index eb2e3db3916f0..17df90b5f57a2 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -898,6 +898,8 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, true,
 				       full_path, fid);
+		if (rc == -EREMOTE)
+			rc = 0;
 		if (rc) {
 			cifs_dbg(FYI, "%s: Get mode from SID failed. rc=%d\n",
 				__func__, rc);
@@ -906,6 +908,8 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, false,
 				       full_path, fid);
+		if (rc == -EREMOTE)
+			rc = 0;
 		if (rc) {
 			cifs_dbg(FYI, "%s: Getting ACL failed with error: %d\n",
 				 __func__, rc);
-- 
2.25.1



