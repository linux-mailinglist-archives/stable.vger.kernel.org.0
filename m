Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AAA627F5E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237596AbiKNM6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbiKNM6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:58:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8972D27DEB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:58:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44225B80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EE5C433D6;
        Mon, 14 Nov 2022 12:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430699;
        bh=38BDvln7PnU/y46+dOahXIYGjNVMQ2TxS1yEFEQv2QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/274QsJE5UxLshz4jZAdn+5mF8W7UFrteklBvKiixHibmAulvESlwMk+wGYx/+aw
         GUUKuZ1p9hxOJfTq7KHjQMsFAJJnyyj4WVPFzUoCOzbztDnEXBQPWMTSG+TeKsnP3I
         /a63ogNtc9RskrQ6C2im8F1Jo06e3+8QW1iH8CuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 105/131] btrfs: selftests: fix wrong error check in btrfs_free_dummy_root()
Date:   Mon, 14 Nov 2022 13:46:14 +0100
Message-Id: <20221114124453.149272150@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit 9b2f20344d450137d015b380ff0c2e2a6a170135 upstream.

The btrfs_alloc_dummy_root() uses ERR_PTR as the error return value
rather than NULL, if error happened, there will be a NULL pointer
dereference:

  BUG: KASAN: null-ptr-deref in btrfs_free_dummy_root+0x21/0x50 [btrfs]
  Read of size 8 at addr 000000000000002c by task insmod/258926

  CPU: 2 PID: 258926 Comm: insmod Tainted: G        W          6.1.0-rc2+ #5
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   kasan_report+0xb7/0x140
   kasan_check_range+0x145/0x1a0
   btrfs_free_dummy_root+0x21/0x50 [btrfs]
   btrfs_test_free_space_cache+0x1a8c/0x1add [btrfs]
   btrfs_run_sanity_tests+0x65/0x80 [btrfs]
   init_btrfs_fs+0xec/0x154 [btrfs]
   do_one_initcall+0x87/0x2a0
   do_init_module+0xdf/0x320
   load_module+0x3006/0x3390
   __do_sys_finit_module+0x113/0x1b0
   do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: aaedb55bc08f ("Btrfs: add tests for btrfs_get_extent")
CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tests/btrfs-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -199,7 +199,7 @@ void btrfs_free_dummy_fs_info(struct btr
 
 void btrfs_free_dummy_root(struct btrfs_root *root)
 {
-	if (!root)
+	if (IS_ERR_OR_NULL(root))
 		return;
 	/* Will be freed by btrfs_free_fs_roots */
 	if (WARN_ON(test_bit(BTRFS_ROOT_IN_RADIX, &root->state)))


