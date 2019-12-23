Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F44129919
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfLWRLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:11:31 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56429 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726754AbfLWRLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:11:31 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C2E4921EBC;
        Mon, 23 Dec 2019 12:11:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:11:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oj4od6
        yHYjL9/RX1Rlws7eQlPe/Qvbo830e9xnvCpgI=; b=Z/9L55mEkQ1mA5sV7VDgZR
        jCU+oXAbyWuhVig6fKnjioeLxnQZWMWcr3Ovr7mD3UQp++spUsTqaQN4YfREyf4t
        JzdP3ptH+XmoOoirhjea2+6CQnfWHkK4wA0HkKsaqexKEupG2MvEt3detYXl5YuK
        dyLunIo/n7PMUUQ4ekH/AE/AOVt2vOF396TOK6JAiYqiwSmlDl7mXdmzaj7Fxgcp
        1ynhYv74JXItVhERagr3tCSV6sEUk02s6TkSzhl7iOm4l6QmxRy4Tuc4ZibUe/Ah
        d1io70li/qYlY62nv7iF0b5o9qRb9Mic99+2xp7XEXwz6oFbCBSaf1kfDHzQ/btA
        ==
X-ME-Sender: <xms:QvUAXqJIYKFaXNHDkjcyiFOQMmLfLnWHaHSOXNClPsvaK3Rq1jDXlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeduleekrdekledrieegrddvgeelnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:QvUAXun5J4xSTV9Da0bCdj_AziAsKVLFK-5Ok6IdKfZkZwFDOWPc9g>
    <xmx:QvUAXh8JNxPMZJUtA2Gb24CR-BRCviNsKCUXAGEkuRec1DL3ld-q-Q>
    <xmx:QvUAXl7YiagOuREmYEffEGhonE6moxmMy2C7k62w3HaSt98ALKR5Yg>
    <xmx:QvUAXlA5pMtUU0UkqEL695S3DpDQUxX3IEHgqAt8LM6a4NL6S1CaCg>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id 62B4680062;
        Mon, 23 Dec 2019 12:11:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: don't double lock the subvol_sem for rename exchange" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:11:15 -0500
Message-ID: <157712107589200@kroah.com>
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

From 943eb3bf25f4a7b745dd799e031be276aa104d82 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 19 Nov 2019 13:59:20 -0500
Subject: [PATCH] btrfs: don't double lock the subvol_sem for rename exchange

If we're rename exchanging two subvols we'll try to lock this lock
twice, which is bad.  Just lock once if either of the ino's are subvols.

Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5766c2d19896..e3c76645cad7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9554,9 +9554,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	btrfs_init_log_ctx(&ctx_dest, new_inode);
 
 	/* close the race window with snapshot create/destroy ioctl */
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
-		down_read(&fs_info->subvol_sem);
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (old_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    new_ino == BTRFS_FIRST_FREE_OBJECTID)
 		down_read(&fs_info->subvol_sem);
 
 	/*
@@ -9790,9 +9789,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		ret = ret ? ret : ret2;
 	}
 out_notrans:
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
-		up_read(&fs_info->subvol_sem);
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (new_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&fs_info->subvol_sem);
 
 	ASSERT(list_empty(&ctx_root.list));

