Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B76635359
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbiKWIyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236472AbiKWIyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:54:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BFEE9316
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:54:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6284461B39
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA6CC433C1;
        Wed, 23 Nov 2022 08:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193642;
        bh=Sx1ZqYTj+xz+xvVWExzlBk/tdb8vOLYL27lRZ/KZB4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5+MMtGyNRJUu6uKmGEioUYV50MuakA4W+2zIU8EbznQb8xbWTRjRay+zKWBqy79I
         ZXhBsOfK3ein2sAYzUNayIGIpWPW5jLjZyZdnHQemW1OzDQ0S+kkbEEPAJkueDNb3W
         h4U3VkyodLSSRCP+XqdZARIv/G6nwa8bLEYCm/Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 20/76] btrfs: selftests: fix wrong error check in btrfs_free_dummy_root()
Date:   Wed, 23 Nov 2022 09:50:19 +0100
Message-Id: <20221123084547.385759749@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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
@@ -183,7 +183,7 @@ void btrfs_free_dummy_fs_info(struct btr
 
 void btrfs_free_dummy_root(struct btrfs_root *root)
 {
-	if (!root)
+	if (IS_ERR_OR_NULL(root))
 		return;
 	/* Will be freed by btrfs_free_fs_roots */
 	if (WARN_ON(test_bit(BTRFS_ROOT_IN_RADIX, &root->state)))


