Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8C7499ADF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379008AbiAXVra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:47:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55820 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377564AbiAXVhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89AF261320;
        Mon, 24 Jan 2022 21:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8D0C340E4;
        Mon, 24 Jan 2022 21:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060259;
        bh=UT/Dyl9nj/GkI8RbdJNJ6JJC4uuJhbXEjUEcFtXd0Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERebD0CSw+APQ9s/XpSjt6C35Wpb0fd42IGcq6a9V2aBWJ+Ft4oL5dtpNIdDhdfFT
         IFejbMLFaSSwEf6gSvLHrCuSAiy1DU1G5j3Ha/0etyNCniJ9+RVYC6XzkIux63p8pM
         Wrc5shrI8ilPYyf8Mmb/ZVn6GhvDFsB7BSQbZ89U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.16 0890/1039] ext4: make sure quota gets properly shutdown on error
Date:   Mon, 24 Jan 2022 19:44:39 +0100
Message-Id: <20220124184155.205187963@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 15fc69bbbbbc8c72e5f6cc4e1be0f51283c5448e upstream.

When we hit an error when enabling quotas and setting inode flags, we do
not properly shutdown quota subsystem despite returning error from
Q_QUOTAON quotactl. This can lead to some odd situations like kernel
using quota file while it is still writeable for userspace. Make sure we
properly cleanup the quota subsystem in case of error.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20211007155336.12493-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6275,10 +6275,7 @@ static int ext4_quota_on(struct super_bl
 
 	lockdep_set_quota_inode(path->dentry->d_inode, I_DATA_SEM_QUOTA);
 	err = dquot_quota_on(sb, type, format_id, path);
-	if (err) {
-		lockdep_set_quota_inode(path->dentry->d_inode,
-					     I_DATA_SEM_NORMAL);
-	} else {
+	if (!err) {
 		struct inode *inode = d_inode(path->dentry);
 		handle_t *handle;
 
@@ -6298,7 +6295,12 @@ static int ext4_quota_on(struct super_bl
 		ext4_journal_stop(handle);
 	unlock_inode:
 		inode_unlock(inode);
+		if (err)
+			dquot_quota_off(sb, type);
 	}
+	if (err)
+		lockdep_set_quota_inode(path->dentry->d_inode,
+					     I_DATA_SEM_NORMAL);
 	return err;
 }
 


