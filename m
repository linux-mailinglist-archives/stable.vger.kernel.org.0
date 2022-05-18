Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F32552B5F9
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 11:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbiERJ2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 05:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbiERJ2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 05:28:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC87F79389;
        Wed, 18 May 2022 02:27:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 56D141F983;
        Wed, 18 May 2022 09:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652866049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8VUBQW747RrhLmzGdxwxIaamcxCr/XdRlK1NT+DftbA=;
        b=LiuZseOBqu44/HyjpSy4ODFE/x2zISlCiDGy1FGL0GaCL5oXBaxq1TpGOwgTu0qgGkhQey
        e0AksgmLnYe28y1+SMKJLs2WE5FmQp5hHj3rIUyTmDYB6Tj4O6QY3B7KX5heMcgDbhEVCh
        Yskej+tLc5G3oXMQWZCoclN78AcHqwM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652866049;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8VUBQW747RrhLmzGdxwxIaamcxCr/XdRlK1NT+DftbA=;
        b=ONs0EzAi+zNoPNNLBxw8ORYLz2PdruHTCEZ+XCWGxxy7AnC6NXhM747VDLgbqu5Yyxwa86
        /h5A7CY/kOEZNMCw==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 476A72C141;
        Wed, 18 May 2022 09:27:29 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E485AA062F; Wed, 18 May 2022 11:27:28 +0200 (CEST)
Date:   Wed, 18 May 2022 11:27:28 +0200
From:   Jan Kara <jack@suse.cz>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: Avoid cycles in directory h-tree
Message-ID: <20220518092728.pad2255opmjljqqh@quack3.lan>
References: <20220428180355.15209-1-jack@suse.cz>
 <20220428183143.5439-2-jack@suse.cz>
 <YoQ2AyDwS6GP3t2M@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoQ2AyDwS6GP3t2M@mit.edu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 17-05-22 19:55:47, Theodore Ts'o wrote:
> On Thu, Apr 28, 2022 at 08:31:38PM +0200, Jan Kara wrote:
> > A maliciously corrupted filesystem can contain cycles in the h-tree
> > stored inside a directory. That can easily lead to the kernel corrupting
> > tree nodes that were already verified under its hands while doing a node
> > split and consequently accessing unallocated memory. Fix the problem by
> > verifying traversed block numbers are unique.
> > 
> > CC: stable@vger.kernel.org
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> When I tried applying this patch, I got this crash:
> 
> ext4/052 23s ... 	[19:28:41][    2.683407] run fstests ext4/052 at 2022-05-17 19:28:41
> [    5.433672] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: dx_probe+0x629/0x630
> [    5.434449] CPU: 0 PID: 2468 Comm: dirstress Not tainted 5.18.0-rc5-xfstests-00019-g204e6b4d4cc1 #610
> [    5.435012] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> [    5.435501] Call Trace:
> [    5.435659]  <TASK>
> [    5.435791]  dump_stack_lvl+0x34/0x44
> [    5.436027]  panic+0x107/0x28f
> [    5.436221]  ? dx_probe+0x629/0x630
> [    5.436430]  __stack_chk_fail+0x10/0x10
> [    5.436663]  dx_probe+0x629/0x630
> [    5.436869]  ext4_dx_add_entry+0x54/0x700
> [    5.437176]  ext4_add_entry+0x38d/0x4e0
> [    5.437421]  ext4_add_nondir+0x2b/0xc0
> [    5.437647]  ext4_symlink+0x1c5/0x390
> [    5.437869]  vfs_symlink+0x184/0x220
> [    5.438095]  do_symlinkat+0x7a/0x110
> [    5.438313]  __x64_sys_symlink+0x38/0x40
> [    5.438548]  do_syscall_64+0x38/0x90
> [    5.438762]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [    5.439070] RIP: 0033:0x7f8137109a97
> [    5.439285] Code: f0 ff ff 73 01 c3 48 8b 0d f6 d3 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 58 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 d3 0c 00 f7 d8 64 89 01 48
> [    5.440374] RSP: 002b:00007ffc514a2428 EFLAGS: 00000246 ORIG_RAX: 0000000000000058
> [    5.440820] RAX: ffffffffffffffda RBX: 0000000000035d4a RCX: 00007f8137109a97
> [    5.441278] RDX: 0000000000000000 RSI: 00007ffc514a2450 RDI: 00007ffc514a2450
> [    5.441734] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000013
> [    5.442153] R10: 00007ffc514a21c2 R11: 0000000000000246 R12: 0000000000061a80
> [    5.442571] R13: 0000000000000000 R14: 00007ffc514a2450 R15: 00007ffc514a2c50
> [    5.442989]  </TASK>
> [    5.443289] Kernel Offset: disabled
> [    5.443517] Rebooting in 5 seconds..
> 
> Applying just the first patch series (plus the patch hunk from this
> commit needed so that the first patch compiles) does not result in a
> crash, so the problem is clearly with this change.

I was wondering why my testing didn't catch this and the reason was that my
test VM had a version of xfstests which had ext4/052 test but somehow the
'tests/ext4/group' file didn't contain that test (and a few other newer
ones) so it didn't get executed. Not sure how that broken group file got
there but anyway it's fixed now and indeed ext4/052 test crashes for me as
well.

> Looking more closely at ext4/052 which tests the large_dir feature,
> and then looking at the patch, I suspect the fix which is needed
> is:
> 
> > +	ext4_lblk_t blocks[EXT4_HTREE_LEVEL];
> 
> needs to be
> 
> 	ext4_lblk_t blocks[EXT4_HTREE_LEVEL + 1];
> 
> Otherwise on large htree which is 3 levels deep, this
> 
> > +		blocks[++level] = block;
> 
> is going to end up smashing the stack.
> 
> Jan, do you agree?

Yes, thanks for debugging this! But I'd prefer a fix like:

		if (++level > indirect)
			return frame;
		blocks[level] = block;

because the store of the leaf block into 'blocks' array is just bogus. I'll
send V2 with both the issues fixed.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
