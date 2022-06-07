Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F1B541779
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358524AbiFGVDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379313AbiFGVCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214C5544E6;
        Tue,  7 Jun 2022 11:47:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CB1B612F2;
        Tue,  7 Jun 2022 18:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCE1C36AFF;
        Tue,  7 Jun 2022 18:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627660;
        bh=wNC8U3dK1TY97OQfPfc2Tk+MoG0IQByeSb90SP0rCYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krQYHnLT0vEs4Hf/4FsrJUj9wGqsz2HZfc00seXXYyoS+S8R3qRXNvhbK+rnPzLXE
         higJKCPv//ir6UDgtPYaVZJcDZsmQPJAF5Bg0fwYn29HKQ3B2jhNC1H+33eWtQC7zT
         Jpf2hZqf0j7ecMhupt67yWSb1wfFwBf9mLCWINB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Luca=20B=C3=A9la=20Palkovics?= 
        <luca.bela.palkovics@gmail.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 047/879] btrfs: repair super block num_devices automatically
Date:   Tue,  7 Jun 2022 18:52:45 +0200
Message-Id: <20220607165004.047386387@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit d201238ccd2f30b9bfcfadaeae0972e3a486a176 upstream.

[BUG]
There is a report that a btrfs has a bad super block num devices.

This makes btrfs to reject the fs completely.

  BTRFS error (device sdd3): super_num_devices 3 mismatch with num_devices 2 found here
  BTRFS error (device sdd3): failed to read chunk tree: -22
  BTRFS error (device sdd3): open_ctree failed

[CAUSE]
During btrfs device removal, chunk tree and super block num devs are
updated in two different transactions:

  btrfs_rm_device()
  |- btrfs_rm_dev_item(device)
  |  |- trans = btrfs_start_transaction()
  |  |  Now we got transaction X
  |  |
  |  |- btrfs_del_item()
  |  |  Now device item is removed from chunk tree
  |  |
  |  |- btrfs_commit_transaction()
  |     Transaction X got committed, super num devs untouched,
  |     but device item removed from chunk tree.
  |     (AKA, super num devs is already incorrect)
  |
  |- cur_devices->num_devices--;
  |- cur_devices->total_devices--;
  |- btrfs_set_super_num_devices()
     All those operations are not in transaction X, thus it will
     only be written back to disk in next transaction.

So after the transaction X in btrfs_rm_dev_item() committed, but before
transaction X+1 (which can be minutes away), a power loss happen, then
we got the super num mismatch.

This has been fixed by commit bbac58698a55 ("btrfs: remove device item
and update super block in the same transaction").

[FIX]
Make the super_num_devices check less strict, converting it from a hard
error to a warning, and reset the value to a correct one for the current
or next transaction commit.

As the number of device items is the critical information where the
super block num_devices is only a cached value (and also useful for
cross checking), it's safe to automatically update it. Other device
related problems like missing device are handled after that and may
require other means to resolve, like degraded mount. With this fix,
potentially affected filesystems won't fail mount and require the manual
repair by btrfs check.

Reported-by: Luca Béla Palkovics <luca.bela.palkovics@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CA+8xDSpvdm_U0QLBAnrH=zqDq_cWCOH5TiV46CKmp3igr44okQ@mail.gmail.com/
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7671,12 +7671,12 @@ int btrfs_read_chunk_tree(struct btrfs_f
 	 * do another round of validation checks.
 	 */
 	if (total_dev != fs_info->fs_devices->total_devices) {
-		btrfs_err(fs_info,
-	   "super_num_devices %llu mismatch with num_devices %llu found here",
+		btrfs_warn(fs_info,
+"super block num_devices %llu mismatch with DEV_ITEM count %llu, will be repaired on next transaction commit",
 			  btrfs_super_num_devices(fs_info->super_copy),
 			  total_dev);
-		ret = -EINVAL;
-		goto error;
+		fs_info->fs_devices->total_devices = total_dev;
+		btrfs_set_super_num_devices(fs_info->super_copy, total_dev);
 	}
 	if (btrfs_super_total_bytes(fs_info->super_copy) <
 	    fs_info->fs_devices->total_rw_bytes) {


