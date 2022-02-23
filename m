Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D0E4C07F6
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbiBWC3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236900AbiBWC3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:29:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B643447056;
        Tue, 22 Feb 2022 18:28:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EF3261515;
        Wed, 23 Feb 2022 02:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BFCC340F1;
        Wed, 23 Feb 2022 02:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583329;
        bh=Bn7oBZoG4xShtRwSYpsv4u4xeQP5D8FI6py9uUOP7w0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEyv8llEi6V8WL4IGPZEGFoxbLXyw1EKDKQhFHzY3Z3e0IrfrWhLHsQoSie8EWQjR
         IZx79Of/wu9vzXMC+W8I9Ewr/+TaC8iYAJbLofD/zkFAqQb8u3jmipDiJ/7iZ9SDN0
         wWzvSkhS8/ZKz6km6VrDld7DaWyuJLKpa2z0UplJHTPFSB08EGXCZvGqe0RjOIqcro
         o8e7n/ZU6ttdY8MIa8DCwB3XQZKTP7vDuC+iTQjmoElJl6YRDGXx4hzsC7CgBLFR7w
         BjQgqBp1us5+cTa0tlyCHcSj+HEKjnCEhIaZ/NjBBKA1oRaTgGrtPoApYXthf1CHPS
         wKCb34y5yVCwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.16 15/30] cifs: fix double free race when mount fails in cifs_get_root()
Date:   Tue, 22 Feb 2022 21:28:04 -0500
Message-Id: <20220223022820.240649-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022820.240649-1-sashal@kernel.org>
References: <20220223022820.240649-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 3d6cc9898efdfb062efb74dc18cfc700e082f5d5 ]

When cifs_get_root() fails during cifs_smb3_do_mount() we call
deactivate_locked_super() which eventually will call delayed_free() which
will free the context.
In this situation we should not proceed to enter the out: section in
cifs_smb3_do_mount() and free the same resources a second time.

[Thu Feb 10 12:59:06 2022] BUG: KASAN: use-after-free in rcu_cblist_dequeue+0x32/0x60
[Thu Feb 10 12:59:06 2022] Read of size 8 at addr ffff888364f4d110 by task swapper/1/0

[Thu Feb 10 12:59:06 2022] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G           OE     5.17.0-rc3+ #4
[Thu Feb 10 12:59:06 2022] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.0 12/17/2019
[Thu Feb 10 12:59:06 2022] Call Trace:
[Thu Feb 10 12:59:06 2022]  <IRQ>
[Thu Feb 10 12:59:06 2022]  dump_stack_lvl+0x5d/0x78
[Thu Feb 10 12:59:06 2022]  print_address_description.constprop.0+0x24/0x150
[Thu Feb 10 12:59:06 2022]  ? rcu_cblist_dequeue+0x32/0x60
[Thu Feb 10 12:59:06 2022]  kasan_report.cold+0x7d/0x117
[Thu Feb 10 12:59:06 2022]  ? rcu_cblist_dequeue+0x32/0x60
[Thu Feb 10 12:59:06 2022]  __asan_load8+0x86/0xa0
[Thu Feb 10 12:59:06 2022]  rcu_cblist_dequeue+0x32/0x60
[Thu Feb 10 12:59:06 2022]  rcu_core+0x547/0xca0
[Thu Feb 10 12:59:06 2022]  ? call_rcu+0x3c0/0x3c0
[Thu Feb 10 12:59:06 2022]  ? __this_cpu_preempt_check+0x13/0x20
[Thu Feb 10 12:59:06 2022]  ? lock_is_held_type+0xea/0x140
[Thu Feb 10 12:59:06 2022]  rcu_core_si+0xe/0x10
[Thu Feb 10 12:59:06 2022]  __do_softirq+0x1d4/0x67b
[Thu Feb 10 12:59:06 2022]  __irq_exit_rcu+0x100/0x150
[Thu Feb 10 12:59:06 2022]  irq_exit_rcu+0xe/0x30
[Thu Feb 10 12:59:06 2022]  sysvec_hyperv_stimer0+0x9d/0xc0
...
[Thu Feb 10 12:59:07 2022] Freed by task 58179:
[Thu Feb 10 12:59:07 2022]  kasan_save_stack+0x26/0x50
[Thu Feb 10 12:59:07 2022]  kasan_set_track+0x25/0x30
[Thu Feb 10 12:59:07 2022]  kasan_set_free_info+0x24/0x40
[Thu Feb 10 12:59:07 2022]  ____kasan_slab_free+0x137/0x170
[Thu Feb 10 12:59:07 2022]  __kasan_slab_free+0x12/0x20
[Thu Feb 10 12:59:07 2022]  slab_free_freelist_hook+0xb3/0x1d0
[Thu Feb 10 12:59:07 2022]  kfree+0xcd/0x520
[Thu Feb 10 12:59:07 2022]  cifs_smb3_do_mount+0x149/0xbe0 [cifs]
[Thu Feb 10 12:59:07 2022]  smb3_get_tree+0x1a0/0x2e0 [cifs]
[Thu Feb 10 12:59:07 2022]  vfs_get_tree+0x52/0x140
[Thu Feb 10 12:59:07 2022]  path_mount+0x635/0x10c0
[Thu Feb 10 12:59:07 2022]  __x64_sys_mount+0x1bf/0x210
[Thu Feb 10 12:59:07 2022]  do_syscall_64+0x5c/0xc0
[Thu Feb 10 12:59:07 2022]  entry_SYSCALL_64_after_hwframe+0x44/0xae

[Thu Feb 10 12:59:07 2022] Last potentially related work creation:
[Thu Feb 10 12:59:07 2022]  kasan_save_stack+0x26/0x50
[Thu Feb 10 12:59:07 2022]  __kasan_record_aux_stack+0xb6/0xc0
[Thu Feb 10 12:59:07 2022]  kasan_record_aux_stack_noalloc+0xb/0x10
[Thu Feb 10 12:59:07 2022]  call_rcu+0x76/0x3c0
[Thu Feb 10 12:59:07 2022]  cifs_umount+0xce/0xe0 [cifs]
[Thu Feb 10 12:59:07 2022]  cifs_kill_sb+0xc8/0xe0 [cifs]
[Thu Feb 10 12:59:07 2022]  deactivate_locked_super+0x5d/0xd0
[Thu Feb 10 12:59:07 2022]  cifs_smb3_do_mount+0xab9/0xbe0 [cifs]
[Thu Feb 10 12:59:07 2022]  smb3_get_tree+0x1a0/0x2e0 [cifs]
[Thu Feb 10 12:59:07 2022]  vfs_get_tree+0x52/0x140
[Thu Feb 10 12:59:07 2022]  path_mount+0x635/0x10c0
[Thu Feb 10 12:59:07 2022]  __x64_sys_mount+0x1bf/0x210
[Thu Feb 10 12:59:07 2022]  do_syscall_64+0x5c/0xc0
[Thu Feb 10 12:59:07 2022]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index dca42aa87d305..99c51391a48da 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -908,6 +908,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 
 out_super:
 	deactivate_locked_super(sb);
+	return root;
 out:
 	if (cifs_sb) {
 		kfree(cifs_sb->prepath);
-- 
2.34.1

