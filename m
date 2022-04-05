Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F654F353A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiDEJAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237384AbiDEIly (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:41:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC49F632B;
        Tue,  5 Apr 2022 01:34:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8ABB5B81B13;
        Tue,  5 Apr 2022 08:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED65BC385A1;
        Tue,  5 Apr 2022 08:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147677;
        bh=svZuOa8pDq3zAWgG/cti6ctsXMEigFytM+QrFm9Cwm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMB8pEqhTUcxwO3R1WN6SHsWJNiZgJ/hpqLzlc0oM7eoL1NPwuPtalPoWP90s9c48
         DunCXoQ5UWfgQFO9iAO4+X9st9p3riZKTZJOlO3Tkd43krQAlV6vLh385zqQybEufs
         3vfuwjai3w/EGyUGXvixhm2GXpAMedHqdQxWp1yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Baokun Li <libaokun1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.16 0083/1017] jffs2: fix use-after-free in jffs2_clear_xattr_subsystem
Date:   Tue,  5 Apr 2022 09:16:36 +0200
Message-Id: <20220405070356.655820343@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit 4c7c44ee1650677fbe89d86edbad9497b7679b5c upstream.

When we mount a jffs2 image, assume that the first few blocks of
the image are normal and contain at least one xattr-related inode,
but the next block is abnormal. As a result, an error is returned
in jffs2_scan_eraseblock(). jffs2_clear_xattr_subsystem() is then
called in jffs2_build_filesystem() and then again in
jffs2_do_fill_super().

Finally we can observe the following report:
 ==================================================================
 BUG: KASAN: use-after-free in jffs2_clear_xattr_subsystem+0x95/0x6ac
 Read of size 8 at addr ffff8881243384e0 by task mount/719

 Call Trace:
  dump_stack+0x115/0x16b
  jffs2_clear_xattr_subsystem+0x95/0x6ac
  jffs2_do_fill_super+0x84f/0xc30
  jffs2_fill_super+0x2ea/0x4c0
  mtd_get_sb+0x254/0x400
  mtd_get_sb_by_nr+0x4f/0xd0
  get_tree_mtd+0x498/0x840
  jffs2_get_tree+0x25/0x30
  vfs_get_tree+0x8d/0x2e0
  path_mount+0x50f/0x1e50
  do_mount+0x107/0x130
  __se_sys_mount+0x1c5/0x2f0
  __x64_sys_mount+0xc7/0x160
  do_syscall_64+0x45/0x70
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

 Allocated by task 719:
  kasan_save_stack+0x23/0x60
  __kasan_kmalloc.constprop.0+0x10b/0x120
  kasan_slab_alloc+0x12/0x20
  kmem_cache_alloc+0x1c0/0x870
  jffs2_alloc_xattr_ref+0x2f/0xa0
  jffs2_scan_medium.cold+0x3713/0x4794
  jffs2_do_mount_fs.cold+0xa7/0x2253
  jffs2_do_fill_super+0x383/0xc30
  jffs2_fill_super+0x2ea/0x4c0
 [...]

 Freed by task 719:
  kmem_cache_free+0xcc/0x7b0
  jffs2_free_xattr_ref+0x78/0x98
  jffs2_clear_xattr_subsystem+0xa1/0x6ac
  jffs2_do_mount_fs.cold+0x5e6/0x2253
  jffs2_do_fill_super+0x383/0xc30
  jffs2_fill_super+0x2ea/0x4c0
 [...]

 The buggy address belongs to the object at ffff8881243384b8
  which belongs to the cache jffs2_xattr_ref of size 48
 The buggy address is located 40 bytes inside of
  48-byte region [ffff8881243384b8, ffff8881243384e8)
 [...]
 ==================================================================

The triggering of the BUG is shown in the following stack:
-----------------------------------------------------------
jffs2_fill_super
  jffs2_do_fill_super
    jffs2_do_mount_fs
      jffs2_build_filesystem
        jffs2_scan_medium
          jffs2_scan_eraseblock        <--- ERROR
        jffs2_clear_xattr_subsystem    <--- free
    jffs2_clear_xattr_subsystem        <--- free again
-----------------------------------------------------------

An error is returned in jffs2_do_mount_fs(). If the error is returned
by jffs2_sum_init(), the jffs2_clear_xattr_subsystem() does not need to
be executed. If the error is returned by jffs2_build_filesystem(), the
jffs2_clear_xattr_subsystem() also does not need to be executed again.
So move jffs2_clear_xattr_subsystem() from 'out_inohash' to 'out_root'
to fix this UAF problem.

Fixes: aa98d7cf59b5 ("[JFFS2][XATTR] XATTR support on JFFS2 (version. 5)")
Cc: stable@vger.kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jffs2/fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -603,8 +603,8 @@ out_root:
 	jffs2_free_ino_caches(c);
 	jffs2_free_raw_node_refs(c);
 	kvfree(c->blocks);
- out_inohash:
 	jffs2_clear_xattr_subsystem(c);
+ out_inohash:
 	kfree(c->inocache_list);
  out_wbuf:
 	jffs2_flash_cleanup(c);


