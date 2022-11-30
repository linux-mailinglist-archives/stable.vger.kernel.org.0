Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9281F63E03E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiK3SzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiK3SzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:55:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95552900C0
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:55:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BCB0B81CAC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5122C433D7;
        Wed, 30 Nov 2022 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834498;
        bh=XYgsnd4W6hCWJfURxV1B6HWb17BS1Hff2VRndbizrr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXN3iCRXt0oM4QCV9+gWlBe8nrr4psigkQUflC/OgK6yuFO7KekHpceEU17ixdGho
         Bv+CMYhUmR/DF3E70GL7PMA3BsPL8B52hnFpNRYDsMM+R4+QWWLjhdpqaB3d9VELV1
         lRqYV3tbxCj3WR8RC8uDvaRDU91AKyKbu4s8QXrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 276/289] btrfs: use kvcalloc in btrfs_get_dev_zone_info
Date:   Wed, 30 Nov 2022 19:24:21 +0100
Message-Id: <20221130180550.358958463@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 8fe97d47b52ae1ad130470b1780f0ded4ba609a4 upstream.

Otherwise the kernel memory allocator seems to be unhappy about failing
order 6 allocations for the zones array, that cause 100% reproducible
mount failures in my qemu setup:

  [26.078981] mount: page allocation failure: order:6, mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), nodemask=(null)
  [26.079741] CPU: 0 PID: 2965 Comm: mount Not tainted 6.1.0-rc5+ #185
  [26.080181] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
  [26.080950] Call Trace:
  [26.081132]  <TASK>
  [26.081291]  dump_stack_lvl+0x56/0x6f
  [26.081554]  warn_alloc+0x117/0x140
  [26.081808]  ? __alloc_pages_direct_compact+0x1b5/0x300
  [26.082174]  __alloc_pages_slowpath.constprop.0+0xd0e/0xde0
  [26.082569]  __alloc_pages+0x32a/0x340
  [26.082836]  __kmalloc_large_node+0x4d/0xa0
  [26.083133]  ? trace_kmalloc+0x29/0xd0
  [26.083399]  kmalloc_large+0x14/0x60
  [26.083654]  btrfs_get_dev_zone_info+0x1b9/0xc00
  [26.083980]  ? _raw_spin_unlock_irqrestore+0x28/0x50
  [26.084328]  btrfs_get_dev_zone_info_all_devices+0x54/0x80
  [26.084708]  open_ctree+0xed4/0x1654
  [26.084974]  btrfs_mount_root.cold+0x12/0xde
  [26.085288]  ? lock_is_held_type+0xe2/0x140
  [26.085603]  legacy_get_tree+0x28/0x50
  [26.085876]  vfs_get_tree+0x1d/0xb0
  [26.086139]  vfs_kern_mount.part.0+0x6c/0xb0
  [26.086456]  btrfs_mount+0x118/0x3a0
  [26.086728]  ? lock_is_held_type+0xe2/0x140
  [26.087043]  legacy_get_tree+0x28/0x50
  [26.087323]  vfs_get_tree+0x1d/0xb0
  [26.087587]  path_mount+0x2ba/0xbe0
  [26.087850]  ? _raw_spin_unlock_irqrestore+0x38/0x50
  [26.088217]  __x64_sys_mount+0xfe/0x140
  [26.088506]  do_syscall_64+0x35/0x80
  [26.088776]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 5b316468983d ("btrfs: get zone information of zoned block devices")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -467,7 +467,7 @@ int btrfs_get_dev_zone_info(struct btrfs
 		goto out;
 	}
 
-	zones = kcalloc(BTRFS_REPORT_NR_ZONES, sizeof(struct blk_zone), GFP_KERNEL);
+	zones = kvcalloc(BTRFS_REPORT_NR_ZONES, sizeof(struct blk_zone), GFP_KERNEL);
 	if (!zones) {
 		ret = -ENOMEM;
 		goto out;
@@ -586,7 +586,7 @@ int btrfs_get_dev_zone_info(struct btrfs
 	}
 
 
-	kfree(zones);
+	kvfree(zones);
 
 	switch (bdev_zoned_model(bdev)) {
 	case BLK_ZONED_HM:
@@ -618,7 +618,7 @@ int btrfs_get_dev_zone_info(struct btrfs
 	return 0;
 
 out:
-	kfree(zones);
+	kvfree(zones);
 out_free_zone_info:
 	btrfs_destroy_dev_zone_info(device);
 


