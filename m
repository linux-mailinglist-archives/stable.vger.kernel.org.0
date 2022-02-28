Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191834C74A8
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbiB1RqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239534AbiB1RoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8885797BA3;
        Mon, 28 Feb 2022 09:36:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38CCEB815BA;
        Mon, 28 Feb 2022 17:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8539EC340E7;
        Mon, 28 Feb 2022 17:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069789;
        bh=/lkHRovb7tuP7QSBAxNGLBNV4Hp3gGZsWicNkv1v7mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDpKC9qcNBGAdSwWaWVyxKtudXOfiwCnuCEK40bbmCylqyIjjfP801j9jnH+0FZKB
         p7Lve7t8JfeTe8XO04qCpO/+FiSMD4Cy+gJwZzLYdNmE7k+TFPoJWbyIP31pqBLi0a
         kIEoCwUxdbWE8LDt8Iu+uAjsfEbb/XZ/Z4qGrovc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenqing Liu <wenqingliu0120@gmail.com>,
        Su Yue <l@damenly.su>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 005/139] btrfs: tree-checker: check item_size for inode_item
Date:   Mon, 28 Feb 2022 18:22:59 +0100
Message-Id: <20220228172348.180951495@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Su Yue <l@damenly.su>

commit 0c982944af27d131d3b74242f3528169f66950ad upstream.

while mounting the crafted image, out-of-bounds access happens:

  [350.429619] UBSAN: array-index-out-of-bounds in fs/btrfs/struct-funcs.c:161:1
  [350.429636] index 1048096 is out of range for type 'page *[16]'
  [350.429650] CPU: 0 PID: 9 Comm: kworker/u8:1 Not tainted 5.16.0-rc4 #1
  [350.429652] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
  [350.429653] Workqueue: btrfs-endio-meta btrfs_work_helper [btrfs]
  [350.429772] Call Trace:
  [350.429774]  <TASK>
  [350.429776]  dump_stack_lvl+0x47/0x5c
  [350.429780]  ubsan_epilogue+0x5/0x50
  [350.429786]  __ubsan_handle_out_of_bounds+0x66/0x70
  [350.429791]  btrfs_get_16+0xfd/0x120 [btrfs]
  [350.429832]  check_leaf+0x754/0x1a40 [btrfs]
  [350.429874]  ? filemap_read+0x34a/0x390
  [350.429878]  ? load_balance+0x175/0xfc0
  [350.429881]  validate_extent_buffer+0x244/0x310 [btrfs]
  [350.429911]  btrfs_validate_metadata_buffer+0xf8/0x100 [btrfs]
  [350.429935]  end_bio_extent_readpage+0x3af/0x850 [btrfs]
  [350.429969]  ? newidle_balance+0x259/0x480
  [350.429972]  end_workqueue_fn+0x29/0x40 [btrfs]
  [350.429995]  btrfs_work_helper+0x71/0x330 [btrfs]
  [350.430030]  ? __schedule+0x2fb/0xa40
  [350.430033]  process_one_work+0x1f6/0x400
  [350.430035]  ? process_one_work+0x400/0x400
  [350.430036]  worker_thread+0x2d/0x3d0
  [350.430037]  ? process_one_work+0x400/0x400
  [350.430038]  kthread+0x165/0x190
  [350.430041]  ? set_kthread_struct+0x40/0x40
  [350.430043]  ret_from_fork+0x1f/0x30
  [350.430047]  </TASK>
  [350.430077] BTRFS warning (device loop0): bad eb member start: ptr 0xffe20f4e start 20975616 member offset 4293005178 size 2

check_leaf() is checking the leaf:

  corrupt leaf: root=4 block=29396992 slot=1, bad key order, prev (16140901064495857664 1 0) current (1 204 12582912)
  leaf 29396992 items 6 free space 3565 generation 6 owner DEV_TREE
  leaf 29396992 flags 0x1(WRITTEN) backref revision 1
  fs uuid a62e00e8-e94e-4200-8217-12444de93c2e
  chunk uuid cecbd0f7-9ca0-441e-ae9f-f782f9732bd8
	  item 0 key (16140901064495857664 INODE_ITEM 0) itemoff 3955 itemsize 40
		  generation 0 transid 0 size 0 nbytes 17592186044416
		  block group 0 mode 52667 links 33 uid 0 gid 2104132511 rdev 94223634821136
		  sequence 100305 flags 0x2409000(none)
		  atime 0.0 (1970-01-01 08:00:00)
		  ctime 2973280098083405823.4294967295 (-269783007-01-01 21:37:03)
		  mtime 18446744071572723616.4026825121 (1902-04-16 12:40:00)
		  otime 9249929404488876031.4294967295 (622322949-04-16 04:25:58)
	  item 1 key (1 DEV_EXTENT 12582912) itemoff 3907 itemsize 48
		  dev extent chunk_tree 3
		  chunk_objectid 256 chunk_offset 12582912 length 8388608
		  chunk_tree_uuid cecbd0f7-9ca0-441e-ae9f-f782f9732bd8

The corrupted leaf of device tree has an inode item. The leaf passed
checksum and others checks in validate_extent_buffer until check_leaf_item().
Because of the key type BTRFS_INODE_ITEM, check_inode_item() is called even we
are in the device tree. Since the
item offset + sizeof(struct btrfs_inode_item) > eb->len, out-of-bounds access
is triggered.

The item end vs leaf boundary check has been done before
check_leaf_item(), so fix it by checking item size in check_inode_item()
before access of the inode item in extent buffer.

Other check functions except check_dev_item() in check_leaf_item()
have their item size checks.
The commit for check_dev_item() is followed.

No regression observed during running fstests.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215299
CC: stable@vger.kernel.org # 5.10+
CC: Wenqing Liu <wenqingliu0120@gmail.com>
Signed-off-by: Su Yue <l@damenly.su>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1007,6 +1007,7 @@ static int check_inode_item(struct exten
 	struct btrfs_inode_item *iitem;
 	u64 super_gen = btrfs_super_generation(fs_info->super_copy);
 	u32 valid_mask = (S_IFMT | S_ISUID | S_ISGID | S_ISVTX | 0777);
+	const u32 item_size = btrfs_item_size_nr(leaf, slot);
 	u32 mode;
 	int ret;
 	u32 flags;
@@ -1016,6 +1017,12 @@ static int check_inode_item(struct exten
 	if (unlikely(ret < 0))
 		return ret;
 
+	if (unlikely(item_size != sizeof(*iitem))) {
+		generic_err(leaf, slot, "invalid item size: has %u expect %zu",
+			    item_size, sizeof(*iitem));
+		return -EUCLEAN;
+	}
+
 	iitem = btrfs_item_ptr(leaf, slot, struct btrfs_inode_item);
 
 	/* Here we use super block generation + 1 to handle log tree */


