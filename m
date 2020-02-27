Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F411720FC
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbgB0NpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:45:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730314AbgB0NpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:45:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9BE620578;
        Thu, 27 Feb 2020 13:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811102;
        bh=X0N4qAhIcSGQX/+onXxgznseKCjCioKEWftFRkvE8Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dN9SSTpq2PAmTn7uLJnEXsCQts+G0hePMAkJMGy1brdwrmft5ZsEvTCGf3Eb6v1zN
         1KF1SDESDYKeUodIL7CIXkT7eHzsfJcgUNV8IiHuYIy4nccw5tUBv8VpzuvLE9kCGG
         eQ6FPB3+A8w5sPtd89CSCiuxbvhDgYdN7qy47JNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shijie Luo <luoshijie1@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@kernel.org
Subject: [PATCH 4.4 102/113] ext4: add cond_resched() to __ext4_find_entry()
Date:   Thu, 27 Feb 2020 14:36:58 +0100
Message-Id: <20200227132228.098577351@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shijie Luo <luoshijie1@huawei.com>

commit 9424ef56e13a1f14c57ea161eed3ecfdc7b2770e upstream.

We tested a soft lockup problem in linux 4.19 which could also
be found in linux 5.x.

When dir inode takes up a large number of blocks, and if the
directory is growing when we are searching, it's possible the
restart branch could be called many times, and the do while loop
could hold cpu a long time.

Here is the call trace in linux 4.19.

[  473.756186] Call trace:
[  473.756196]  dump_backtrace+0x0/0x198
[  473.756199]  show_stack+0x24/0x30
[  473.756205]  dump_stack+0xa4/0xcc
[  473.756210]  watchdog_timer_fn+0x300/0x3e8
[  473.756215]  __hrtimer_run_queues+0x114/0x358
[  473.756217]  hrtimer_interrupt+0x104/0x2d8
[  473.756222]  arch_timer_handler_virt+0x38/0x58
[  473.756226]  handle_percpu_devid_irq+0x90/0x248
[  473.756231]  generic_handle_irq+0x34/0x50
[  473.756234]  __handle_domain_irq+0x68/0xc0
[  473.756236]  gic_handle_irq+0x6c/0x150
[  473.756238]  el1_irq+0xb8/0x140
[  473.756286]  ext4_es_lookup_extent+0xdc/0x258 [ext4]
[  473.756310]  ext4_map_blocks+0x64/0x5c0 [ext4]
[  473.756333]  ext4_getblk+0x6c/0x1d0 [ext4]
[  473.756356]  ext4_bread_batch+0x7c/0x1f8 [ext4]
[  473.756379]  ext4_find_entry+0x124/0x3f8 [ext4]
[  473.756402]  ext4_lookup+0x8c/0x258 [ext4]
[  473.756407]  __lookup_hash+0x8c/0xe8
[  473.756411]  filename_create+0xa0/0x170
[  473.756413]  do_mkdirat+0x6c/0x140
[  473.756415]  __arm64_sys_mkdirat+0x28/0x38
[  473.756419]  el0_svc_common+0x78/0x130
[  473.756421]  el0_svc_handler+0x38/0x78
[  473.756423]  el0_svc+0x8/0xc
[  485.755156] watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [tmp:5149]

Add cond_resched() to avoid soft lockup and to provide a better
system responding.

Link: https://lore.kernel.org/r/20200215080206.13293-1-luoshijie1@huawei.com
Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1418,6 +1418,7 @@ restart:
 		/*
 		 * We deal with the read-ahead logic here.
 		 */
+		cond_resched();
 		if (ra_ptr >= ra_max) {
 			/* Refill the readahead buffer */
 			ra_ptr = 0;


