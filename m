Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4432B328
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 13:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfE0LZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 07:25:40 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48649 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbfE0LZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 07:25:40 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AC48F22200;
        Mon, 27 May 2019 07:25:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 27 May 2019 07:25:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QYkwMF
        0iEWmEa+Cvi91jDN7tNxmt69aMPW8rsEQfJOo=; b=ojIjjoqfuAb58qaPQN5Bs0
        CfcGw7GXJS6dJfaSyo3/jO5LdLRK/3ZSGbtIYvBqqPlgWqyq+lQs5zoDoN4FSjNA
        KRfvygVERMI60cPuEBZ+7ZZZooF+Jatiwh+13hnRgs0YJ7UvrWpf9CgaLNh4YD3Z
        FA7K5gsz89njZkvIxm3aUcmM98EvZgDwJuLuNcphfwrZ36rZ16f58V49pA+cMEhV
        TonV96NhKDZA3u56w7UZSKherA/dh0TFvNciXf8jFL7X09UjGHmneADhSPGN43Rr
        Mhm+26Tv0PMkKgUkk3hOD6KZIhnS+cPQnqraGtb2KrpPELifYG9OMDusDBgzjEXA
        ==
X-ME-Sender: <xms:M8nrXIUtKUzUNyMHNeqtZH2rCSKuBf8FNEFfr5lfTAkUOneyV8cbrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvvddggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:M8nrXA3VLloghRzN9BmnsucyyEjkSPDVJtJ7GSTcjIaG02AsD3Z2Bg>
    <xmx:M8nrXHZRAel1JVqkaAby487nhDlhFlIMKVNFtVnl0MzaoB2rP29pAA>
    <xmx:M8nrXLq8huBS4MphtE5SXRTJaWY17BYIckn7MejjijFWKm_6zZlY_w>
    <xmx:M8nrXPH7eXIl6Pa-Xji86DtaEfiQ7us-y4Ca1jznZz0cjwMbCc7sHA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22B91380083;
        Mon, 27 May 2019 07:25:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: wait for outstanding dio during truncate in nojournal" failed to apply to 4.9-stable tree
To:     jack@suse.cz, ira.weiny@intel.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 May 2019 13:25:28 +0200
Message-ID: <155895632815449@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

