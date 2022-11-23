Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB5163550E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbiKWJMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbiKWJMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:12:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98573C77E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:12:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5F5FB81EEE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07213C433C1;
        Wed, 23 Nov 2022 09:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194758;
        bh=kIPcyw8nm/hEqUfJcDMxsc71M3KNDHbPfU1IiXR6978=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRg8p3SN0LF3NnYWMGpDhZt5UfpYECJ7foa/PMFzgPPpBx0lnXfLFRHticxTvgNlv
         STRMTS9RHUbKxHbLp8DJZ8YrPPKkZwphYHMnEXIgWCnbLI/CBlrRX9eR8p99miocOs
         h1f0uhyl/o3F9AIzSM4Q88kG8UJQVEn3xr6kTZ2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 052/156] btrfs: selftests: fix wrong error check in btrfs_free_dummy_root()
Date:   Wed, 23 Nov 2022 09:50:09 +0100
Message-Id: <20221123084559.809412625@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
@@ -189,7 +189,7 @@ void btrfs_free_dummy_fs_info(struct btr
 
 void btrfs_free_dummy_root(struct btrfs_root *root)
 {
-	if (!root)
+	if (IS_ERR_OR_NULL(root))
 		return;
 	/* Will be freed by btrfs_free_fs_roots */
 	if (WARN_ON(test_bit(BTRFS_ROOT_IN_RADIX, &root->state)))


