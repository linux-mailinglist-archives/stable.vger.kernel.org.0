Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7AD6AC185
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjCFNjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbjCFNj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:39:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C912C2A6F6
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 05:39:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71F2BB80E40
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 13:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C116AC4339C;
        Mon,  6 Mar 2023 13:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678109962;
        bh=fQeSwFM1vfJ7/uIlAEjiu+UNDEg+nAzmJ8H7HPuD4Mw=;
        h=Subject:To:Cc:From:Date:From;
        b=1NeVFDNJfVOIX0OHiPSPut3G6nWCNL0ZW0roebVuHlgQC7Li7cT6fSS2weKZ2JM2T
         ki7ES4/4qLDUUUYDZ+genHezJejM+qADty+8Attn/G5KPmi41HAoVBYwTVWjzgbRlN
         olCjiGCYScSlNg6niKEuBtojCJn4Uz387xVG8E9c=
Subject: FAILED: patch "[PATCH] udf: Preserve link count of system files" failed to apply to 4.19-stable tree
To:     jack@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 14:39:19 +0100
Message-ID: <167810995913998@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x fc8033a34a3ca7d23353e645e6dde5d364ac5f12
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167810995913998@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

fc8033a34a3c ("udf: Preserve link count of system files")
382a2287bf9c ("udf: Remove pointless union in udf_inode_info")
044e2e26f214 ("udf: Avoid accessing uninitialized data on failed inode read")
ab9a3a737284 ("udf: reduce leakage of blocks related to named streams")
d288d95842f1 ("udf: Fix BUG on corrupted inode")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fc8033a34a3ca7d23353e645e6dde5d364ac5f12 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 3 Jan 2023 09:56:56 +0100
Subject: [PATCH] udf: Preserve link count of system files

System files in UDF filesystem have link count 0. To not confuse VFS we
fudge the link count to be 1 when reading such inodes however we forget
to restore the link count of 0 when writing such inodes. Fix that.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 31965c3798f2..9ee269d3d546 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1301,6 +1301,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		ret = -EIO;
 		goto out;
 	}
+	iinfo->i_hidden = hidden_inode;
 	iinfo->i_unique = 0;
 	iinfo->i_lenEAttr = 0;
 	iinfo->i_lenExtents = 0;
@@ -1636,8 +1637,12 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
 	if (S_ISDIR(inode->i_mode) && inode->i_nlink > 0)
 		fe->fileLinkCount = cpu_to_le16(inode->i_nlink - 1);
-	else
-		fe->fileLinkCount = cpu_to_le16(inode->i_nlink);
+	else {
+		if (iinfo->i_hidden)
+			fe->fileLinkCount = cpu_to_le16(0);
+		else
+			fe->fileLinkCount = cpu_to_le16(inode->i_nlink);
+	}
 
 	fe->informationLength = cpu_to_le64(inode->i_size);
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 06eda8177b5f..241b40e886b3 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -147,6 +147,7 @@ static struct inode *udf_alloc_inode(struct super_block *sb)
 	ei->i_next_alloc_goal = 0;
 	ei->i_strat4096 = 0;
 	ei->i_streamdir = 0;
+	ei->i_hidden = 0;
 	init_rwsem(&ei->i_data_sem);
 	ei->cached_extent.lstart = -1;
 	spin_lock_init(&ei->i_extent_cache_lock);
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index 06ff7006b822..312b7c9ef10e 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -44,7 +44,8 @@ struct udf_inode_info {
 	unsigned		i_use : 1;	/* unallocSpaceEntry */
 	unsigned		i_strat4096 : 1;
 	unsigned		i_streamdir : 1;
-	unsigned		reserved : 25;
+	unsigned		i_hidden : 1;	/* hidden system inode */
+	unsigned		reserved : 24;
 	__u8			*i_data;
 	struct kernel_lb_addr	i_locStreamdir;
 	__u64			i_lenStreams;

