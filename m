Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8C549A5AC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371073AbiAYAGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360934AbiAXXin (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:38:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2389C014B57;
        Mon, 24 Jan 2022 13:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63D5761502;
        Mon, 24 Jan 2022 21:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B61C340E7;
        Mon, 24 Jan 2022 21:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060288;
        bh=hXcoNs0eV+dMtxkq6Dw8eNgx0kpJ36Vku3/tBigUjX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgCttLkVY7hEZOtnLbBNwlxjOKniPVcoJVK/h6HsvCIprjzuYiCiv3O7RmF1ahbHD
         fbBipsveLscdBTneYUxiMP/TI7svlfJfCzBZZ0Q1J4FcOL8uiSIlMvA1DnHDqF0DqT
         Q3CnIoQWBdquKmAHVk233MO8ru//zIvtt0nT7l6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.16 0899/1039] ext4: fix null-ptr-deref in __ext4_journal_ensure_credits
Date:   Mon, 24 Jan 2022 19:44:48 +0100
Message-Id: <20220124184155.508817756@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit 298b5c521746d69c07beb2757292fb5ccc1b0f85 upstream.

We got issue as follows when run syzkaller test:
[ 1901.130043] EXT4-fs error (device vda): ext4_remount:5624: comm syz-executor.5: Abort forced by user
[ 1901.130901] Aborting journal on device vda-8.
[ 1901.131437] EXT4-fs error (device vda): ext4_journal_check_start:61: comm syz-executor.16: Detected aborted journal
[ 1901.131566] EXT4-fs error (device vda): ext4_journal_check_start:61: comm syz-executor.11: Detected aborted journal
[ 1901.132586] EXT4-fs error (device vda): ext4_journal_check_start:61: comm syz-executor.18: Detected aborted journal
[ 1901.132751] EXT4-fs error (device vda): ext4_journal_check_start:61: comm syz-executor.9: Detected aborted journal
[ 1901.136149] EXT4-fs error (device vda) in ext4_reserve_inode_write:6035: Journal has aborted
[ 1901.136837] EXT4-fs error (device vda): ext4_journal_check_start:61: comm syz-fuzzer: Detected aborted journal
[ 1901.136915] ==================================================================
[ 1901.138175] BUG: KASAN: null-ptr-deref in __ext4_journal_ensure_credits+0x74/0x140 [ext4]
[ 1901.138343] EXT4-fs error (device vda): ext4_journal_check_start:61: comm syz-executor.13: Detected aborted journal
[ 1901.138398] EXT4-fs error (device vda): ext4_journal_check_start:61: comm syz-executor.1: Detected aborted journal
[ 1901.138808] Read of size 8 at addr 0000000000000000 by task syz-executor.17/968
[ 1901.138817]
[ 1901.138852] EXT4-fs error (device vda): ext4_journal_check_start:61: comm syz-executor.30: Detected aborted journal
[ 1901.144779] CPU: 1 PID: 968 Comm: syz-executor.17 Not tainted 4.19.90-vhulk2111.1.0.h893.eulerosv2r10.aarch64+ #1
[ 1901.146479] Hardware name: linux,dummy-virt (DT)
[ 1901.147317] Call trace:
[ 1901.147552]  dump_backtrace+0x0/0x2d8
[ 1901.147898]  show_stack+0x28/0x38
[ 1901.148215]  dump_stack+0xec/0x15c
[ 1901.148746]  kasan_report+0x108/0x338
[ 1901.149207]  __asan_load8+0x58/0xb0
[ 1901.149753]  __ext4_journal_ensure_credits+0x74/0x140 [ext4]
[ 1901.150579]  ext4_xattr_delete_inode+0xe4/0x700 [ext4]
[ 1901.151316]  ext4_evict_inode+0x524/0xba8 [ext4]
[ 1901.151985]  evict+0x1a4/0x378
[ 1901.152353]  iput+0x310/0x428
[ 1901.152733]  do_unlinkat+0x260/0x428
[ 1901.153056]  __arm64_sys_unlinkat+0x6c/0xc0
[ 1901.153455]  el0_svc_common+0xc8/0x320
[ 1901.153799]  el0_svc_handler+0xf8/0x160
[ 1901.154265]  el0_svc+0x10/0x218
[ 1901.154682] ==================================================================

This issue may happens like this:
	Process1                               Process2
ext4_evict_inode
  ext4_journal_start
   ext4_truncate
     ext4_ind_truncate
       ext4_free_branches
         ext4_ind_truncate_ensure_credits
	   ext4_journal_ensure_credits_fn
	     ext4_journal_restart
	       handle->h_transaction = NULL;
                                           mount -o remount,abort  /mnt
					   -> trigger JBD abort
               start_this_handle -> will return failed
  ext4_xattr_delete_inode
    ext4_journal_ensure_credits
      ext4_journal_ensure_credits_fn
        __ext4_journal_ensure_credits
	  jbd2_handle_buffer_credits
	    journal = handle->h_transaction->t_journal; ->null-ptr-deref

Now, indirect truncate process didn't handle error. To solve this issue
maybe simply add check handle is abort in '__ext4_journal_ensure_credits'
is enough, and i also think this is necessary.

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20211224100341.3299128-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4_jbd2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -162,6 +162,8 @@ int __ext4_journal_ensure_credits(handle
 {
 	if (!ext4_handle_valid(handle))
 		return 0;
+	if (is_handle_aborted(handle))
+		return -EROFS;
 	if (jbd2_handle_buffer_credits(handle) >= check_cred &&
 	    handle->h_revoke_credits >= revoke_cred)
 		return 0;


