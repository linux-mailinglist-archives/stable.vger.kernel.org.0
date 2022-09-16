Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838FF5BA958
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 11:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiIPJ1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 05:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIPJ1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 05:27:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEC6A346C;
        Fri, 16 Sep 2022 02:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67CDA622A8;
        Fri, 16 Sep 2022 09:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E22C433D6;
        Fri, 16 Sep 2022 09:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663320440;
        bh=/MbCCWvfY/b1qyntb3td32NBslVGpl//w8KGvmHgeJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HDP4Amiasr8z4M4I/WLXROZp/eLHnmsWVBGKIKSWnpklEGxVVFhpwAcIv9Gq4GXyg
         zzyQzvJsjkEkdvDahhehUKcq332S2x5fyMGmh9ZTQX9XxFEp1M5PCM2wVHJ4guFZav
         EIq7GKEW6B2VpWJGUlC6Qv+wxXnG4ag2TRWAFOmk=
Date:   Fri, 16 Sep 2022 11:27:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Wysochanski <dwysocha@redhat.com>
Cc:     wangyugui@e16-tech.com, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/121] 5.15.68-rc1 review
Message-ID: <YyRBktIgj+G3wq/k@kroah.com>
References: <20220913140357.323297659@linuxfoundation.org>
 <CA+G9fYv5CJeEaxu6XoaJrpizk+z1uXZ0aaQm2DVTA_w79oa2SA@mail.gmail.com>
 <20220915235936.4AD5.409509F4@e16-tech.com>
 <CALF+zO=u0ehYsEuLBR4HG+KCma8zdjweE_Chgw1oJJEMS4TDjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALF+zO=u0ehYsEuLBR4HG+KCma8zdjweE_Chgw1oJJEMS4TDjg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 15, 2022 at 05:27:40PM -0400, David Wysochanski wrote:
> On Thu, Sep 15, 2022 at 12:02 PM Wang Yugui <wangyugui@e16-tech.com> wrote:
> >
> > Hi,
> >
> > > I have not bisected the reported problem.
> > >
> > > hugemmap05.c:99: TINFO: check /proc/meminfo before allocation.
> > > hugemmap05.c:278: TINFO: HugePages_Total is 3.
> > > hugemmap05.c:278: TINFO: HugePages_Free is 3.
> > > hugemmap05.c:278: TINFO: HugePages_Surp is 1.
> > > hugemmap05.c:27[   51.077819] ------------[ cut here ]------------
> > > [   51.082692] WARNING: CPU: 0 PID: 590 at fs/nfs/inode.c:123
> > > nfs_evict_inode+0x58/0x70
> > > [   51.090451] Modules linked in: x86_pkg_temp_thermal
> > > [   51.095329] CPU: 0 PID: 590 Comm: hugemmap05 Not tainted 5.15.68-rc1 #1
> > > [   51.101948] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> > > 2.5 11/26/2020
> > > [   51.109340] RIP: 0010:nfs_evict_inode+0x58/0x70
> > > [   51.113872] Code: 29 49 8b 54 24 90 49 8d 44 24 90 48 39 c2 75 2b
> > > 4c 89 e7 e8 7a d8 ff ff 4c 89 e7 e8 82 74 ff ff 4c 8b 65 f8 c9 c3 cc
> > > cc cc cc <0f> 0b 49 8b 54 24 90 49 8d 44 24 90 48 39 c2 74 d5 0f 0b eb
> > > d1 0f
> > > [   51.132626] RSP: 0018:ffffb6b140a8fb90 EFLAGS: 00010286
> > > [   51.137861] RAX: adacafaea9a8abaa RBX: ffff937fa606a2c0 RCX: ffffb6b140a8fbd0
> > > [   51.144986] RDX: ffff937fa606a2d0 RSI: ffffffffbc720682 RDI: ffffffffbc5ec05f
> > > [   51.152120] RBP: ffffb6b140a8fb98 R08: 0000000000000000 R09: ffffb6b140a8fcf0
> > > [   51.159253] R10: 0000000000000000 R11: 0000000000000002 R12: ffff937fa606a1a8
> > > [   51.166395] R13: ffffffffbd851b40 R14: ffff937c40803870 R15: 0000000000000003
> > > [   51.173525] FS:  00007f5afcdf4740(0000) GS:ffff937fa7a00000(0000)
> > > knlGS:0000000000000000
> > > [   51.181602] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   51.187359] CR2: 00007f5afcf10680 CR3: 000000010360a006 CR4: 00000000003706f0
> > > 8: TINFO: HugePa[   51.194499] DR0: 0000000000000000 DR1:
> > > 0000000000000000 DR2: 0000000000000000
> > > [   51.203009] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > [   51.210135] Call Trace:
> > > [   51.212585]  <TASK>
> > > [   51.214684]  evict+0xc8/0x180
> > > [   51.217682]  prune_icache_sb+0x81/0xc0
> > > [   51.221435]  super_cache_scan+0x169/0x200
> > > [   51.225447]  do_shrink_slab+0x13f/0x2b0
> > > [   51.229288]  shrink_slab+0x186/0x2a0
> > > [   51.232868]  drop_slab_node+0x4a/0xa0
> > > [   51.236533]  drop_slab+0x41/0x90
> > > [   51.239765]  drop_caches_sysctl_handler+0x79/0x90
> > > [   51.244471]  proc_sys_call_handler+0x159/0x290
> > > [   51.248918]  proc_sys_write+0x13/0x20
> > > [   51.252582]  new_sync_write+0x111/0x1a0
> > > [   51.256423]  vfs_write+0x1d5/0x270
> > > [   51.259828]  ksys_write+0x67/0xf0
> > > [   51.263150]  __x64_sys_write+0x19/0x20
> > > [   51.266901]  do_syscall_64+0x38/0x90
> > > [   51.270479]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
> > > [   51.275534] RIP: 0033:0x7f5afcef31d7
> > > [   51.279112] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7
> > > 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00
> > > 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89
> > > 74 24
> > > [   51.297859] RSP: 002b:00007ffd40638738 EFLAGS: 00000246 ORIG_RAX:
> > > 0000000000000001
> > > [   51.305425] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f5afcef31d7
> > > [   51.312557] RDX: 0000000000000001 RSI: 00000000016f1480 RDI: 0000000000000003
> > > [   51.319689] RBP: 00000000016f1480 R08: 0000000000000001 R09: 0000000000000001
> > > [   51.326812] R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000001
> > > [   51.333938] R13: 00000000016f12a0 R14: 0000000000000001 R15: 00007f5afcfe87a0
> > > [   51.341073]  </TASK>
> > > [   51.343264] ---[ end trace 3420625c1fbde9e9 ]---
> > > ges_Rsvd is 3.
> > > [   51.348004] hugemmap05 (590): drop_caches: 3
> > > hugemmap05.c:253: TINFO: First hex is 7070707
> >
> > I hit this warning too.
> >
> > It seems that we need this patch for 5.15.y
> >
> > commit 0ebeebcf59601bcfa0284f4bb7abdec051eb856d
> > Author: Dave Wysochanski <dwysocha@redhat.com>
> > Date:   Sun Oct 10 18:23:13 2021 -0400
> >
> >     NFS: Fix WARN_ON due to unionization of nfs_inode.nrequests
> >
> >     Fixes the following WARN_ON
> >     WARNING: CPU: 2 PID: 18678 at fs/nfs/inode.c:123 nfs_clear_inode+0x3b/0x50 [nfs]
> >     ...
> >     Call Trace:
> >       nfs4_evict_inode+0x57/0x70 [nfsv4]
> >       evict+0xd1/0x180
> >
> > Best Regards
> > Wang Yugui (wangyugui@e16-tech.com)
> > 2022/09/15
> >
> >
> 
> Sorry, commit 0ebeebcf59601bcfa0284f4bb7abdec051eb856d probably should
> have had this
> Fixes: e591b298d7ec "NFS: Save some space in the inode"

Now queued up, thanks.

greg k-h
