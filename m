Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171656B5188
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 21:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjCJUOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 15:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjCJUOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 15:14:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1609F12CBBC;
        Fri, 10 Mar 2023 12:14:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8D75B822C2;
        Fri, 10 Mar 2023 20:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578AAC433D2;
        Fri, 10 Mar 2023 20:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678479250;
        bh=FSvN0dMMOIBal+krA5fTetvx6l6nuLKvzSK+sAbhgiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U0l4qrR6LKxW7/w82/tVMbCJVD1vicHfXGsBaVPcgnD0WOykHWSPU4tbANimy2No/
         QOAx7HIe8xf7kvAKCYGghKebx76Bgs+Ph0WWoD7+reWWpN9MDXhxDBXffzkOkx144i
         sFG642df2Umtdr4MdDEelvAUEexay8BwrVqJfrpLGX/lwhhPWL9jstuLqMDl5L6JY6
         h5JUwXFiuvsLxqm5cltSRqwznt7CUJfx1cvGkWB4bpl7Pi4vqs8Expp5pz2D4AW6X+
         SWIhwqAhkxvsAXzLK1tmFLgdvLzTvQohP5Qs20DPDaXme/x8BR/WqikoyNNVVRVM2Z
         6XI/Fqf5O2hlQ==
Date:   Fri, 10 Mar 2023 12:14:08 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mike Cloaked <mike.cloaked@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Possible kernel fs block code regression in 6.2.3 umounting usb
 drives
Message-ID: <ZAuPkCn49urWBN5P@sol.localdomain>
References: <CAOCAAm7AEY9tkZpu2j+Of91fCE4UuE_PqR0UqNv2p2mZM9kqKw@mail.gmail.com>
 <CAOCAAm4reGhz400DSVrh0BetYD3Ljr2CZen7_3D4gXYYdB4SKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOCAAm4reGhz400DSVrh0BetYD3Ljr2CZen7_3D4gXYYdB4SKQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 07:33:37PM +0000, Mike Cloaked wrote:
> With kerne. 6.2.3 if I simply plug in a usb external drive, mount it
> and umount it, then the journal has a kernel Oops and I have submitted
> a bug report, that includes the journal output, at
> https://bugzilla.kernel.org/show_bug.cgi?id=217174
> 
> As soon as the usb drive is unmounted, the kernel Oops occurs, and the
> machine hangs on shutdown and needs a hard reboot.
> 
> I have reproduced the same issue on three different machines, and in
> each case downgrading back to kernel 6.2.2 resolves the issue and it
> no longer occurs.
> 
> This would seem to be a regression in kernel 6.2.3
> 
> Mike C

Thanks for reporting this!  If this is reliably reproducible and is known to be
a regression between v6.2.2 and v6.2.3, any chance you could bisect it to find
out the exact commit that introduced the bug?

For reference I'm also copying the stack trace from bugzilla below:

BUG: kernel NULL pointer dereference, address: 0000000000000028
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 9 PID: 1118 Comm: lvcreate Tainted: G                T  6.2.3-1>
 Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z370 Ex>
 RIP: 0010:blk_throtl_update_limit_valid+0x1f/0x110
 Code: 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 41 54 49 89 fc>
 RSP: 0018:ffffb5fd01b47bb8 EFLAGS: 00010046
 RAX: 0000000000000000 RBX: ffff9d09040d8000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: ffffffff97b2f648 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000000 R12: ffff9d090fce2c00
 R13: ffff9d090aedf060 R14: ffff9d090aedf1c8 R15: ffff9d090aedf0d8
 FS:  00007f3896fc7240(0000) GS:ffff9d109f040000(0000) knlGS:00000000>
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000028 CR3: 0000000111ce4003 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  throtl_pd_offline+0x40/0x70
  blkcg_deactivate_policy+0xab/0x140
  ? __pfx_dev_remove+0x10/0x10 [dm_mod]
  blk_throtl_exit+0x45/0x80
  disk_release+0x4a/0xf0
  device_release+0x34/0x90
  kobject_put+0x97/0x1d0
  cleanup_mapped_device+0xe0/0x170 [dm_mod]
  __dm_destroy+0x120/0x1e0 [dm_mod]
  dev_remove+0x11b/0x190 [dm_mod]
  ctl_ioctl+0x302/0x5b0 [dm_mod]
  dm_ctl_ioctl+0xe/0x20 [dm_mod]
  __x64_sys_ioctl+0x9c/0xe0
  do_syscall_64+0x5c/0x90
  entry_SYSCALL_64_after_hwframe+0x72/0xdc
 RIP: 0033:0x7f389745653f
 Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48>
 RSP: 002b:00007ffe5499e4f0 EFLAGS: 00000246 ORIG_RAX: 00000000000000>
 RAX: ffffffffffffffda RBX: 000055d198c3bec0 RCX: 00007f389745653f
 RDX: 000055d1994501b0 RSI: 00000000c138fd04 RDI: 0000000000000003
 RBP: 0000000000000006 R08: 000055d197547088 R09: 00007ffe5499e3a0
 R10: 0000000000000000 R11: 0000000000000246 R12: 000055d1974d10d6
 R13: 000055d199450260 R14: 000055d1974d10c7 R15: 000055d197545bbb
  </TASK>
 Modules linked in: dm_cache_smq dm_cache dm_persistent_data dm_bio_p>
  soundcore pcspkr intel_wmi_thunderbolt i2c_smbus mei sysimgblt inpu>
 CR2: 0000000000000028
 ---[ end trace 0000000000000000 ]---
 RIP: 0010:blk_throtl_update_limit_valid+0x1f/0x110
 Code: 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 41 54 49 89 fc>
