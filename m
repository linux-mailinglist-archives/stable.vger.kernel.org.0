Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1E989260
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 17:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfHKPmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 11:42:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:54096 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726164AbfHKPmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Aug 2019 11:42:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D6A5AF7A;
        Sun, 11 Aug 2019 15:42:06 +0000 (UTC)
Subject: Re: FAILED: patch "[PATCH] bcache: Revert "bcache: use
 sysfs_match_string() instead of" failed to apply to 5.2-stable tree
To:     gregkh@linuxfoundation.org
Cc:     alexandru.ardelean@analog.com, axboe@kernel.dk, pflin@suse.com,
        stable@vger.kernel.org
References: <156553570618483@kroah.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <81d2423d-74dd-50ba-4a33-05306a1b13dd@suse.de>
Date:   Sun, 11 Aug 2019 23:41:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156553570618483@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/8/11 11:01 下午, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.2-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hi Greg,

I will post a rebased patch for the 5.2-stable tree.

Thanks.


Coly Li


> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 20621fedb2a696e4dc60bc1c5de37cf21976abcb Mon Sep 17 00:00:00 2001
> From: Coly Li <colyli@suse.de>
> Date: Fri, 9 Aug 2019 14:14:05 +0800
> Subject: [PATCH] bcache: Revert "bcache: use sysfs_match_string() instead of
>  __sysfs_match_string()"
> 
> This reverts commit 89e0341af082dbc170019f908846f4a424efc86b.
> 
> In drivers/md/bcache/sysfs.c:bch_snprint_string_list(), NULL pointer at
> the end of list is necessary. Remove the NULL from last element of each
> lists will cause the following panic,
> 
> [ 4340.455652] bcache: register_cache() registered cache device nvme0n1
> [ 4340.464603] bcache: register_bdev() registered backing device sdk
> [ 4421.587335] bcache: bch_cached_dev_run() cached dev sdk is running already
> [ 4421.587348] bcache: bch_cached_dev_attach() Caching sdk as bcache0 on set 354e1d46-d99f-4d8b-870b-078b80dc88a6
> [ 5139.247950] general protection fault: 0000 [#1] SMP NOPTI
> [ 5139.247970] CPU: 9 PID: 5896 Comm: cat Not tainted 4.12.14-95.29-default #1 SLE12-SP4
> [ 5139.247988] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 04/18/2019
> [ 5139.248006] task: ffff888fb25c0b00 task.stack: ffff9bbacc704000
> [ 5139.248021] RIP: 0010:string+0x21/0x70
> [ 5139.248030] RSP: 0018:ffff9bbacc707bf0 EFLAGS: 00010286
> [ 5139.248043] RAX: ffffffffa7e432e3 RBX: ffff8881c20da02a RCX: ffff0a00ffffff04
> [ 5139.248058] RDX: 3f00656863616362 RSI: ffff8881c20db000 RDI: ffffffffffffffff
> [ 5139.248075] RBP: ffff8881c20db000 R08: 0000000000000000 R09: ffff8881c20da02a
> [ 5139.248090] R10: 0000000000000004 R11: 0000000000000000 R12: ffff9bbacc707c48
> [ 5139.248104] R13: 0000000000000fd6 R14: ffffffffc0665855 R15: ffffffffc0665855
> [ 5139.248119] FS:  00007faf253b8700(0000) GS:ffff88903f840000(0000) knlGS:0000000000000000
> [ 5139.248137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 5139.248149] CR2: 00007faf25395008 CR3: 0000000f72150006 CR4: 00000000007606e0
> [ 5139.248164] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 5139.248179] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 5139.248193] PKRU: 55555554
> [ 5139.248200] Call Trace:
> [ 5139.248210]  vsnprintf+0x1fb/0x510
> [ 5139.248221]  snprintf+0x39/0x40
> [ 5139.248238]  bch_snprint_string_list.constprop.15+0x5b/0x90 [bcache]
> [ 5139.248256]  __bch_cached_dev_show+0x44d/0x5f0 [bcache]
> [ 5139.248270]  ? __alloc_pages_nodemask+0xb2/0x210
> [ 5139.248284]  bch_cached_dev_show+0x2c/0x50 [bcache]
> [ 5139.248297]  sysfs_kf_seq_show+0xbb/0x190
> [ 5139.248308]  seq_read+0xfc/0x3c0
> [ 5139.248317]  __vfs_read+0x26/0x140
> [ 5139.248327]  vfs_read+0x87/0x130
> [ 5139.248336]  SyS_read+0x42/0x90
> [ 5139.248346]  do_syscall_64+0x74/0x160
> [ 5139.248358]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [ 5139.248370] RIP: 0033:0x7faf24eea370
> [ 5139.248379] RSP: 002b:00007fff82d03f38 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [ 5139.248395] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007faf24eea370
> [ 5139.248411] RDX: 0000000000020000 RSI: 00007faf25396000 RDI: 0000000000000003
> [ 5139.248426] RBP: 00007faf25396000 R08: 00000000ffffffff R09: 0000000000000000
> [ 5139.248441] R10: 000000007c9d4d41 R11: 0000000000000246 R12: 00007faf25396000
> [ 5139.248456] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000fff
> [ 5139.248892] Code: ff ff ff 0f 1f 80 00 00 00 00 49 89 f9 48 89 cf 48 c7 c0 e3 32 e4 a7 48 c1 ff 30 48 81 fa ff 0f 00 00 48 0f 46 d0 48 85 ff 74 45 <44> 0f b6 02 48 8d 42 01 45 84 c0 74 38 48 01 fa 4c 89 cf eb 0e
> 
> The simplest way to fix is to revert commit 89e0341af082 ("bcache: use
> sysfs_match_string() instead of __sysfs_match_string()").
> 
> This bug was introduced in Linux v5.2, so this fix only applies to
> Linux v5.2 is enough for stable tree maintainer.
> 
> Fixes: 89e0341af082 ("bcache: use sysfs_match_string() instead of __sysfs_match_string()")
> Cc: stable@vger.kernel.org
> Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Reported-by: Peifeng Lin <pflin@suse.com>
> Acked-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 9f0826712845..e2059af90791 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -23,24 +23,28 @@ static const char * const bch_cache_modes[] = {
>  	"writethrough",
>  	"writeback",
>  	"writearound",
> -	"none"
> +	"none",
> +	NULL
>  };
>  
>  /* Default is 0 ("auto") */
>  static const char * const bch_stop_on_failure_modes[] = {
>  	"auto",
> -	"always"
> +	"always",
> +	NULL
>  };
>  
>  static const char * const cache_replacement_policies[] = {
>  	"lru",
>  	"fifo",
> -	"random"
> +	"random",
> +	NULL
>  };
>  
>  static const char * const error_actions[] = {
>  	"unregister",
> -	"panic"
> +	"panic",
> +	NULL
>  };
>  
>  write_attribute(attach);
> @@ -338,7 +342,7 @@ STORE(__cached_dev)
>  	}
>  
>  	if (attr == &sysfs_cache_mode) {
> -		v = sysfs_match_string(bch_cache_modes, buf);
> +		v = __sysfs_match_string(bch_cache_modes, -1, buf);
>  		if (v < 0)
>  			return v;
>  
> @@ -349,7 +353,7 @@ STORE(__cached_dev)
>  	}
>  
>  	if (attr == &sysfs_stop_when_cache_set_failed) {
> -		v = sysfs_match_string(bch_stop_on_failure_modes, buf);
> +		v = __sysfs_match_string(bch_stop_on_failure_modes, -1, buf);
>  		if (v < 0)
>  			return v;
>  
> @@ -816,7 +820,7 @@ STORE(__bch_cache_set)
>  			    0, UINT_MAX);
>  
>  	if (attr == &sysfs_errors) {
> -		v = sysfs_match_string(error_actions, buf);
> +		v = __sysfs_match_string(error_actions, -1, buf);
>  		if (v < 0)
>  			return v;
>  
> @@ -1088,7 +1092,7 @@ STORE(__bch_cache)
>  	}
>  
>  	if (attr == &sysfs_cache_replacement_policy) {
> -		v = sysfs_match_string(cache_replacement_policies, buf);
> +		v = __sysfs_match_string(cache_replacement_policies, -1, buf);
>  		if (v < 0)
>  			return v;
>  
> 
