Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CEF1FF5CC
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbgFROyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:54:11 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:44061 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731039AbgFROyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 10:54:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 664AF75F;
        Thu, 18 Jun 2020 10:54:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 10:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6EYJgy
        cW/t/pHBpYdiOYY9TSZvp2uNxafi/klBA0aYY=; b=H5PXd7EIAG5Kgp3fzjMWZg
        iHNCBqXBS52XZVzHM7iddoHtdxN6pPDmyZOP+Bdz0bHEZtM0Cp+xEm7/5nWOFr6n
        eBP2Ftb5jnJUDlxJpbOKUv2jOdf5AfhEF9sFR/WWzxf02e0Qxum5ZaEDrBSCu13v
        8vlZMlMeRLzgFehtcNwKbPjf+dJkb6qtQzIFzxrJAf+Z110YyaV9bkCnaWuOEwyn
        acEw86qRbSgkIGRupmf7bhJRVvIjTCXXWrKO0h6PwDhC0US1cPq7VW7O7CV7k7rB
        Znxy+zuPEvvhVZ52xcybsnfEfnvF/0Rb9+UddbtQ8vFpc1/DhoQg/vTRwsKtTWxQ
        ==
X-ME-Sender: <xms:D4DrXpoEAZoA4rvUWcseMWau3GsoM9euitgbI-cixC3CNjtMFsi6Rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:D4DrXrptf47--phCoNeNnvMtLaWTdZxasFKCfsjTqTCzfTt6iMoKaA>
    <xmx:D4DrXmMsr5O_7OLRBg7JCYE6521UnGial9KXHJclbbWxv-krLPLpDg>
    <xmx:D4DrXk5Enk3oVmVyvfGYfJLEEJ8hJi2rtw76SzVMG9Ec0ZBJdKre2w>
    <xmx:EIDrXthSwuXQjLJxHQROjhDu0SmjrdhKGYI0oEALEf29N3FomA_DMjpiJlk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7BE2730614FA;
        Thu, 18 Jun 2020 10:54:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: reloc: fix reloc root leak and NULL pointer" failed to apply to 5.4-stable tree
To:     wqu@suse.com, dsterba@suse.com, johannes.thumshirn@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 16:54:00 +0200
Message-ID: <159249204034160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 51415b6c1b117e223bc083e30af675cb5c5498f3 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Tue, 19 May 2020 10:13:20 +0800
Subject: [PATCH] btrfs: reloc: fix reloc root leak and NULL pointer
 dereference

[BUG]
When balance is canceled, there is a pretty high chance that unmounting
the fs can lead to lead the NULL pointer dereference:

  BTRFS warning (device dm-3): page private not zero on page 223158272
  ...
  BTRFS warning (device dm-3): page private not zero on page 223162368
  BTRFS error (device dm-3): leaked root 18446744073709551608-304 refcount 1
  BUG: kernel NULL pointer dereference, address: 0000000000000168
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 2 PID: 5793 Comm: umount Tainted: G           O      5.7.0-rc5-custom+ #53
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:__lock_acquire+0x5dc/0x24c0
  Call Trace:
   lock_acquire+0xab/0x390
   _raw_spin_lock+0x39/0x80
   btrfs_release_extent_buffer_pages+0xd7/0x200 [btrfs]
   release_extent_buffer+0xb2/0x170 [btrfs]
   free_extent_buffer+0x66/0xb0 [btrfs]
   btrfs_put_root+0x8e/0x130 [btrfs]
   btrfs_check_leaked_roots.cold+0x5/0x5d [btrfs]
   btrfs_free_fs_info+0xe5/0x120 [btrfs]
   btrfs_kill_super+0x1f/0x30 [btrfs]
   deactivate_locked_super+0x3b/0x80
   deactivate_super+0x3e/0x50
   cleanup_mnt+0x109/0x160
   __cleanup_mnt+0x12/0x20
   task_work_run+0x67/0xa0
   exit_to_usermode_loop+0xc5/0xd0
   syscall_return_slowpath+0x205/0x360
   do_syscall_64+0x6e/0xb0
   entry_SYSCALL_64_after_hwframe+0x49/0xb3
  RIP: 0033:0x7fd028ef740b

[CAUSE]
When balance is canceled, all reloc roots are marked as orphan, and
orphan reloc roots are going to be cleaned up.

However for orphan reloc roots and merged reloc roots, their lifespan
are quite different:

	Merged reloc roots	|	Orphan reloc roots by cancel
--------------------------------------------------------------------
create_reloc_root()		| create_reloc_root()
|- refs == 1			| |- refs == 1
				|
btrfs_grab_root(reloc_root);	| btrfs_grab_root(reloc_root);
|- refs == 2			| |- refs == 2
				|
root->reloc_root = reloc_root;	| root->reloc_root = reloc_root;
		>>> No difference so far <<<
				|
prepare_to_merge()		| prepare_to_merge()
|- btrfs_set_root_refs(item, 1);| |- if (!err) (err == -EINTR)
				|
merge_reloc_roots()		| merge_reloc_roots()
|- merge_reloc_root()		| |- Doing nothing to put reloc root
   |- insert_dirty_subvol()	| |- refs == 2
      |- __del_reloc_root()	|
         |- btrfs_put_root()	|
            |- refs == 1	|
		>>> Now orphan reloc roots still have refs 2 <<<
				|
clean_dirty_subvols()		| clean_dirty_subvols()
|- btrfs_drop_snapshot()	| |- btrfS_drop_snapshot()
   |- reloc_root get freed	|    |- reloc_root still has refs 2
				|	related ebs get freed, but
				|	reloc_root still recorded in
				|	allocated_roots
btrfs_check_leaked_roots()	| btrfs_check_leaked_roots()
|- No leaked roots		| |- Leaked reloc_roots detected
				| |- btrfs_put_root()
				|    |- free_extent_buffer(root->node);
				|       |- eb already freed, caused NULL
				|	   pointer dereference

[FIX]
The fix is to clear fs_root->reloc_root and put it at
merge_reloc_roots() time, so that we won't leak reloc roots.

Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
CC: stable@vger.kernel.org # 5.1+
Tested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 58f56e01de0d..81b076e46143 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1917,12 +1917,10 @@ void merge_reloc_roots(struct reloc_control *rc)
 		reloc_root = list_entry(reloc_roots.next,
 					struct btrfs_root, root_list);
 
+		root = read_fs_root(fs_info, reloc_root->root_key.offset);
 		if (btrfs_root_refs(&reloc_root->root_item) > 0) {
-			root = read_fs_root(fs_info,
-					    reloc_root->root_key.offset);
 			BUG_ON(IS_ERR(root));
 			BUG_ON(root->reloc_root != reloc_root);
-
 			ret = merge_reloc_root(rc, root);
 			btrfs_put_root(root);
 			if (ret) {
@@ -1932,6 +1930,14 @@ void merge_reloc_roots(struct reloc_control *rc)
 				goto out;
 			}
 		} else {
+			if (!IS_ERR(root)) {
+				if (root->reloc_root == reloc_root) {
+					root->reloc_root = NULL;
+					btrfs_put_root(reloc_root);
+				}
+				btrfs_put_root(root);
+			}
+
 			list_del_init(&reloc_root->root_list);
 			/* Don't forget to queue this reloc root for cleanup */
 			list_add_tail(&reloc_root->reloc_dirty_list,

