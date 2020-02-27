Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A301713E0
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgB0JRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:17:04 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:33895 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728555AbgB0JRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:17:03 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id DC353654;
        Thu, 27 Feb 2020 04:17:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:17:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=a32xC8
        3Fh9y7p91/mW/YZ0QJvzYJYP2OzsDxPtQHvV0=; b=s37ADqYY78zEQ/beyi/qfS
        fsMJ7tCK7fWrDwfXvvzAZ2CDWIGJK5NgNq5mOOILoMc0y14ETk1KUldeeV93Dii+
        A9OM10/UhfW0rwToTwYwblFSXcjcbw8YEzKZVsp44bAWCcCd+kZ2rm3WuQ7HWWMp
        RMvOXr3HlyXL+nHjOx8sl4vKBfNowca4dypAaiP2xTlSV0dB72j7jvLSbEcxnGsk
        qTidKJ72MIjysWefNP/MEnW7hiNR0v4AxeW2WBcbjyMUHHJIP7gnxf8JZxD3GQ7A
        PfKSNkDuFpZXz9C79E55rocso7KckQBNcqoTPEia4HiiqXz8x2/U2k7wuCMLwIOQ
        ==
X-ME-Sender: <xms:DolXXswmHRnVzxdcAE0iEoLdAww9Ey_6UFD6RwlpEpXhD3AkkjJh1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DolXXk5ugwP6e4vfp2Yn-5MTOgWK4n5FAfYfmGoVTJNAm2tlDOtIRA>
    <xmx:DolXXmeiiKMCATRddnllSgqtWmryMKrKckYtxK1aUgfwyYaBe8qRgA>
    <xmx:DolXXkq-5r89sHFjX9eOqcA2rWdcjPCL7prngH2pVCPQaKwXswub4A>
    <xmx:DolXXlP46LWH3DDNO1P1bt7MUkX3igfwRKaKEFWfor518T5bkxL48g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 33ADB3060FD3;
        Thu, 27 Feb 2020 04:17:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix bytes_may_use underflow in prealloc error" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:16:53 +0100
Message-ID: <158279501324339@kroah.com>
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

From b778cf962d71a0e737923d55d0432f3bd287258e Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 13 Feb 2020 10:47:31 -0500
Subject: [PATCH] btrfs: fix bytes_may_use underflow in prealloc error
 condtition

I hit the following warning while running my error injection stress
testing:

  WARNING: CPU: 3 PID: 1453 at fs/btrfs/space-info.h:108 btrfs_free_reserved_data_space_noquota+0xfd/0x160 [btrfs]
  RIP: 0010:btrfs_free_reserved_data_space_noquota+0xfd/0x160 [btrfs]
  Call Trace:
  btrfs_free_reserved_data_space+0x4f/0x70 [btrfs]
  __btrfs_prealloc_file_range+0x378/0x470 [btrfs]
  elfcorehdr_read+0x40/0x40
  ? elfcorehdr_read+0x40/0x40
  ? btrfs_commit_transaction+0xca/0xa50 [btrfs]
  ? dput+0xb4/0x2a0
  ? btrfs_log_dentry_safe+0x55/0x70 [btrfs]
  ? btrfs_sync_file+0x30e/0x420 [btrfs]
  ? do_fsync+0x38/0x70
  ? __x64_sys_fdatasync+0x13/0x20
  ? do_syscall_64+0x5b/0x1b0
  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

This happens if we fail to insert our reserved file extent.  At this
point we've already converted our reservation from ->bytes_may_use to
->bytes_reserved.  However once we break we will attempt to free
everything from [cur_offset, end] from ->bytes_may_use, but our extent
reservation will overlap part of this.

Fix this problem by adding ins.offset (our extent allocation size) to
cur_offset so we remove the actual remaining part from ->bytes_may_use.

I validated this fix using my inject-error.py script

python inject-error.py -o should_fail_bio -t cache_save_setup -t \
	__btrfs_prealloc_file_range \
	-t insert_reserved_file_extent.constprop.0 \
	-r "-5" ./run-fsstress.sh

where run-fsstress.sh simply mounts and runs fsstress on a disk.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 36deef69f847..4f47ba652b31 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9824,6 +9824,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key ins;
 	u64 cur_offset = start;
+	u64 clear_offset = start;
 	u64 i_size;
 	u64 cur_bytes;
 	u64 last_alloc = (u64)-1;
@@ -9858,6 +9859,15 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 				btrfs_end_transaction(trans);
 			break;
 		}
+
+		/*
+		 * We've reserved this space, and thus converted it from
+		 * ->bytes_may_use to ->bytes_reserved.  Any error that happens
+		 * from here on out we will only need to clear our reservation
+		 * for the remaining unreserved area, so advance our
+		 * clear_offset by our extent size.
+		 */
+		clear_offset += ins.offset;
 		btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 
 		last_alloc = ins.offset;
@@ -9937,9 +9947,9 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		if (own_trans)
 			btrfs_end_transaction(trans);
 	}
-	if (cur_offset < end)
-		btrfs_free_reserved_data_space(inode, NULL, cur_offset,
-			end - cur_offset + 1);
+	if (clear_offset < end)
+		btrfs_free_reserved_data_space(inode, NULL, clear_offset,
+			end - clear_offset + 1);
 	return ret;
 }
 

