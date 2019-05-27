Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79CCA2B327
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 13:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfE0LZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 07:25:39 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51817 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbfE0LZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 07:25:39 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1F6BB22199;
        Mon, 27 May 2019 07:25:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 27 May 2019 07:25:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XmXlGz
        AzsaMg7vPq2z9ISZNtqZ6yCXe4vpHVEy+5jQ4=; b=RY+uAN3o6NQsToPLtwtyzC
        aL5a4grOAEhpwzTJIDWCrCIPOii+eHETcbulM/Wt6prJbOugsfU8Hc+QIkCa4EJl
        gzlxXt1KkeA8OuBz3p2d1KtwZcEP0F3WWGJr/gfMAtebglt4nQKSdHsdDh47iSv1
        zEB6oyyB3gfOVSjncQb/dqMscRr5JRQrHVQQsaT2M1DZ6YOP8JuCNOYD3+7ateI7
        2PjByFkYo55VKfwadDaAVTW/gDssstCNmRRclipyLNGuzNNTsjIh7YNW4dBG1TiW
        kn3Zq9uZjfFEoS8BCC23V1DHCClGzLlJLx+ZPv70LC5x6eq2xHMzd22sRRW0s9Eg
        ==
X-ME-Sender: <xms:McnrXJRDK2SzZAia-LcAyILmXRANhfLtaW8hRS46w5S9Py0zJWdonQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvvddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:McnrXF8bZkYzAoCV4vFNCK-MS9yOq9ALJPuu8oUk6HBLJOke9t-PJQ>
    <xmx:McnrXFoX0syUMdCLl-M8LDvW-gyzRr3n_BVw_ZfU0krpy40YHrksuw>
    <xmx:McnrXGHq9yY_-qOgr0RUuAhaNwBf1iPUUM_9Vfsj298rQKVupGKW2A>
    <xmx:MsnrXIAL_JILg7FculnMFBnScp45Y6XMdev95oeNAw_cfcEx3ywdMw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8005E380083;
        Mon, 27 May 2019 07:25:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: wait for outstanding dio during truncate in nojournal" failed to apply to 4.4-stable tree
To:     jack@suse.cz, ira.weiny@intel.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 May 2019 13:25:28 +0200
Message-ID: <155895632888142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 82a25b027ca48d7ef197295846b352345853dfa8 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 23 May 2019 23:07:08 -0400
Subject: [PATCH] ext4: wait for outstanding dio during truncate in nojournal
 mode

We didn't wait for outstanding direct IO during truncate in nojournal
mode (as we skip orphan handling in that case). This can lead to fs
corruption or stale data exposure if truncate ends up freeing blocks
and these get reallocated before direct IO finishes. Fix the condition
determining whether the wait is necessary.

CC: stable@vger.kernel.org
Fixes: 1c9114f9c0f1 ("ext4: serialize unlocked dio reads with truncate")
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 82298c63ea6d..9bcb7f2b86dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5630,20 +5630,17 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 				goto err_out;
 			}
 		}
-		if (!shrink)
+		if (!shrink) {
 			pagecache_isize_extended(inode, oldsize, inode->i_size);
-
-		/*
-		 * Blocks are going to be removed from the inode. Wait
-		 * for dio in flight.  Temporarily disable
-		 * dioread_nolock to prevent livelock.
-		 */
-		if (orphan) {
-			if (!ext4_should_journal_data(inode)) {
-				inode_dio_wait(inode);
-			} else
-				ext4_wait_for_tail_page_commit(inode);
+		} else {
+			/*
+			 * Blocks are going to be removed from the inode. Wait
+			 * for dio in flight.
+			 */
+			inode_dio_wait(inode);
 		}
+		if (orphan && ext4_should_journal_data(inode))
+			ext4_wait_for_tail_page_commit(inode);
 		down_write(&EXT4_I(inode)->i_mmap_sem);
 
 		rc = ext4_break_layouts(inode);

