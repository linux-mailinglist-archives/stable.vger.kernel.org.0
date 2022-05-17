Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CE152AEE0
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 01:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiEQX4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 19:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiEQXz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 19:55:56 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64BF1181E;
        Tue, 17 May 2022 16:55:53 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24HNtl4Y032180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 19:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652831749; bh=2dq5sZmwK4X75Q1G2V4SouTGU0MvG2CDfD8GCfhVrTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=CTkx7K12OlvR0lbRGUCjFxazMqWaLBXy0F07qqGfTFT6fQXrcg2WTVnJARHSci3HF
         djsnwRZ0k4Z622X2A1oJoVm413uSW3Jf+viwIenMhSW8G4qJzINXmPDcszB20PFRty
         6yXsBm2h8AIL8OXPWMEDV9ygKrHoeeByCFX2pOlKJL+FhQLGLdtXgHrblguLQpyxBj
         Imigau8cV2S8eoh+QTyxew/zzUKbOQji+UsKWR2rHrhIyXmucnd9Uj4MdTCfDBrXJi
         QfDNdZIPRN6tHdn03TNv8dPliWAMZUGpT31S0MoQvqpeOD7U+9NIVu1WmppeQk0JPS
         P8xos7iUV7ACg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 12FBE15C3EC0; Tue, 17 May 2022 19:55:47 -0400 (EDT)
Date:   Tue, 17 May 2022 19:55:47 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: Avoid cycles in directory h-tree
Message-ID: <YoQ2AyDwS6GP3t2M@mit.edu>
References: <20220428180355.15209-1-jack@suse.cz>
 <20220428183143.5439-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428183143.5439-2-jack@suse.cz>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 28, 2022 at 08:31:38PM +0200, Jan Kara wrote:
> A maliciously corrupted filesystem can contain cycles in the h-tree
> stored inside a directory. That can easily lead to the kernel corrupting
> tree nodes that were already verified under its hands while doing a node
> split and consequently accessing unallocated memory. Fix the problem by
> verifying traversed block numbers are unique.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

When I tried applying this patch, I got this crash:

ext4/052 23s ... 	[19:28:41][    2.683407] run fstests ext4/052 at 2022-05-17 19:28:41
[    5.433672] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: dx_probe+0x629/0x630
[    5.434449] CPU: 0 PID: 2468 Comm: dirstress Not tainted 5.18.0-rc5-xfstests-00019-g204e6b4d4cc1 #610
[    5.435012] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[    5.435501] Call Trace:
[    5.435659]  <TASK>
[    5.435791]  dump_stack_lvl+0x34/0x44
[    5.436027]  panic+0x107/0x28f
[    5.436221]  ? dx_probe+0x629/0x630
[    5.436430]  __stack_chk_fail+0x10/0x10
[    5.436663]  dx_probe+0x629/0x630
[    5.436869]  ext4_dx_add_entry+0x54/0x700
[    5.437176]  ext4_add_entry+0x38d/0x4e0
[    5.437421]  ext4_add_nondir+0x2b/0xc0
[    5.437647]  ext4_symlink+0x1c5/0x390
[    5.437869]  vfs_symlink+0x184/0x220
[    5.438095]  do_symlinkat+0x7a/0x110
[    5.438313]  __x64_sys_symlink+0x38/0x40
[    5.438548]  do_syscall_64+0x38/0x90
[    5.438762]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[    5.439070] RIP: 0033:0x7f8137109a97
[    5.439285] Code: f0 ff ff 73 01 c3 48 8b 0d f6 d3 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 58 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 d3 0c 00 f7 d8 64 89 01 48
[    5.440374] RSP: 002b:00007ffc514a2428 EFLAGS: 00000246 ORIG_RAX: 0000000000000058
[    5.440820] RAX: ffffffffffffffda RBX: 0000000000035d4a RCX: 00007f8137109a97
[    5.441278] RDX: 0000000000000000 RSI: 00007ffc514a2450 RDI: 00007ffc514a2450
[    5.441734] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000013
[    5.442153] R10: 00007ffc514a21c2 R11: 0000000000000246 R12: 0000000000061a80
[    5.442571] R13: 0000000000000000 R14: 00007ffc514a2450 R15: 00007ffc514a2c50
[    5.442989]  </TASK>
[    5.443289] Kernel Offset: disabled
[    5.443517] Rebooting in 5 seconds..

Applying just the first patch series (plus the patch hunk from this
commit needed so that the first patch compiles) does not result in a
crash, so the problem is clearly with this change.

Looking more closely at ext4/052 which tests the large_dir feature,
and then looking at the patch, I suspect the fix which is needed
is:

> +	ext4_lblk_t blocks[EXT4_HTREE_LEVEL];

needs to be

	ext4_lblk_t blocks[EXT4_HTREE_LEVEL + 1];

Otherwise on large htree which is 3 levels deep, this

> +		blocks[++level] = block;

is going to end up smashing the stack.

Jan, do you agree?

							- Ted
