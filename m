Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FE4269290
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgINRIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbgINNFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 001C1221E7;
        Mon, 14 Sep 2020 13:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088657;
        bh=/TgvuTtu3dB+kip6pfwy4beQVD01+cDItXjAMGkkd/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYXdKhyR4nDLwcJUEk8geGl+ddqxHWDkH43EkCPXYxfgbVsbwVIEnhbkFHkJcvcev
         mqW95GrGc00RMD7yzh5OslsyLaF5U5bGK7+/qT/9WT+k63BUtr+uSW1WwO8gBvO/px
         xNZJ2wPNPRGUykqDG7aOiOvyukFEEKFs2SWI9cf4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.8 16/29] cifs: fix DFS mount with cifsacl/modefromsid
Date:   Mon, 14 Sep 2020 09:03:45 -0400
Message-Id: <20200914130358.1804194-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index ce95801e9b664..7708175062eba 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1017,6 +1017,8 @@ cifs_get_inode_info(struct inode **inode,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, true,
 				       full_path, fid);
+		if (rc == -EREMOTE)
+			rc = 0;
 		if (rc) {
 			cifs_dbg(FYI, "%s: Get mode from SID failed. rc=%d\n",
 				 __func__, rc);
@@ -1025,6 +1027,8 @@ cifs_get_inode_info(struct inode **inode,
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

