Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F9B272F65
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbgIUQ46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729444AbgIUQob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A149D238E6;
        Mon, 21 Sep 2020 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706658;
        bh=G4k/FEqhQSblg+6kOPLkOd3CjvibLyPyJmZrlc2TBR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mz/4YL1E7vtjwQPFvTJM/CbTRJU0kviUN4ajQDaI4Bn7b+Epohp68zg3njpjXPL86
         kTN7157Xp55jiE+FWOLh5O7IUUsWCWhAehW6XCu+VeTLZuFRFLdk0aOpMsEEFd+tVv
         VFRsA/yC5wsb/BWCgwCV51y5sayrasKHTnRA/8lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 024/118] cifs: fix DFS mount with cifsacl/modefromsid
Date:   Mon, 21 Sep 2020 18:27:16 +0200
Message-Id: <20200921162037.431371116@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
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
index ce95801e9b664..7708175062eba 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1017,6 +1017,8 @@ handle_mnt_opt:
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, true,
 				       full_path, fid);
+		if (rc == -EREMOTE)
+			rc = 0;
 		if (rc) {
 			cifs_dbg(FYI, "%s: Get mode from SID failed. rc=%d\n",
 				 __func__, rc);
@@ -1025,6 +1027,8 @@ handle_mnt_opt:
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



