Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8175318F723
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 15:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgCWOnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 10:43:10 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55075 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbgCWOnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 10:43:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 78EB0574;
        Mon, 23 Mar 2020 10:43:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 23 Mar 2020 10:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hRLAGn
        2YCrDwn9RJJwumehHvr4N6XFHG8bl0FpowKSA=; b=dhsgZpSwYm0tcWo/AIDCLm
        8OKm0syeU2PjkfR4JaUO5iZRs3WfFICHOjfJZtSpiKJMlmD+kBJfIihOjoQETsYw
        jJBYHOL/Y3VGioAZhXkj9zXsPH5TifRBWBSyhZvQFqMUD8Jv9By0ctyceZKgY8BU
        xcuGxEs2P1o7q2YT2GADebNexAsFdboTkyqZZLMIAF1WyWQvXxHeUI7IEL3q6n/l
        t1HXnqA/N8HhgXnTDDD0Tp7xaSsCb4ZpExBYea+yPkywTumnvWgG5T+fUpgPoNsE
        GHZKMsP29JyO+2GWWqbsId2k5TWAWhEFCy3YzPuXAMc6LE0EiaXBjSFfSgzhdNXA
        ==
X-ME-Sender: <xms:_cp4XkZ14r_SqFc0at9CaWwZ3kplg2ldpzYguZCeU7f9u9cWlj-LMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegkedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_cp4XrXlVyrJ2pdXJDjBBty0YyH2jpJc6g0uO1EX1Vr3vzaUrf56Og>
    <xmx:_cp4XqzbZe_k_p4-8tQDsKUj0uUc5Wx8t5uxawFC1s55MAYk9UgUIQ>
    <xmx:_cp4Xmlwl_5mKtpSpxpCxCIgnpPe8hIDylXviyUNoZeGfRbkXKsHjA>
    <xmx:_cp4XkSbicgJjoRVupB-znY938GV8f39LeJ5rKN2ScXZEWmijSWHeA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B96E83280064;
        Mon, 23 Mar 2020 10:43:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix log context list corruption after rename whiteout" failed to apply to 4.14-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 15:43:02 +0100
Message-ID: <1584974582132143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 236ebc20d9afc5e9ff52f3cf3f365a91583aac10 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Tue, 10 Mar 2020 12:13:53 +0000
Subject: [PATCH] btrfs: fix log context list corruption after rename whiteout
 error

During a rename whiteout, if btrfs_whiteout_for_rename() returns an error
we can end up returning from btrfs_rename() with the log context object
still in the root's log context list - this happens if 'sync_log' was
set to true before we called btrfs_whiteout_for_rename() and it is
dangerous because we end up with a corrupt linked list (root->log_ctxs)
as the log context object was allocated on the stack.

After btrfs_rename() returns, any task that is running btrfs_sync_log()
concurrently can end up crashing because that linked list is traversed by
btrfs_sync_log() (through btrfs_remove_all_log_ctxs()). That results in
the same issue that commit e6c617102c7e4 ("Btrfs: fix log context list
corruption after rename exchange operation") fixed.

Fixes: d4682ba03ef618 ("Btrfs: sync log after logging new name")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 27076ebadb36..d267eb5caa7b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9496,6 +9496,10 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		ret = btrfs_sync_log(trans, BTRFS_I(old_inode)->root, &ctx);
 		if (ret)
 			commit_transaction = true;
+	} else if (sync_log) {
+		mutex_lock(&root->log_mutex);
+		list_del(&ctx.list);
+		mutex_unlock(&root->log_mutex);
 	}
 	if (commit_transaction) {
 		ret = btrfs_commit_transaction(trans);

