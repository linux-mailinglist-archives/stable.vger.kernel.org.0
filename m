Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C583498CEC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346440AbiAXT0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:26:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46340 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345996AbiAXTWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:22:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 804B3B81215;
        Mon, 24 Jan 2022 19:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8A8C340E5;
        Mon, 24 Jan 2022 19:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052145;
        bh=zhxegM3sBBiujj8RPue3C+DEmvIsUk70MnMMWX3SENk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCVlsu39ayCxeh4HNEb9u8yEXiR15U3Kopnr60OESxzlGMQR+tL3llQ827NHI7DCL
         IbN7BcYx1W3tSDbsl/3A/5kcUiYYHxqjLDYFXvlYSJCiwT5+ogOAGmkDpgy61euPXC
         mOm0CCPP5QHQE9t+EYEQCBu6VZZgUPxzU9FN8pPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 203/239] ext4: make sure quota gets properly shutdown on error
Date:   Mon, 24 Jan 2022 19:44:01 +0100
Message-Id: <20220124183949.561283422@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
@@ -5797,10 +5797,7 @@ static int ext4_quota_on(struct super_bl
 
 	lockdep_set_quota_inode(path->dentry->d_inode, I_DATA_SEM_QUOTA);
 	err = dquot_quota_on(sb, type, format_id, path);
-	if (err) {
-		lockdep_set_quota_inode(path->dentry->d_inode,
-					     I_DATA_SEM_NORMAL);
-	} else {
+	if (!err) {
 		struct inode *inode = d_inode(path->dentry);
 		handle_t *handle;
 
@@ -5820,7 +5817,12 @@ static int ext4_quota_on(struct super_bl
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
 


