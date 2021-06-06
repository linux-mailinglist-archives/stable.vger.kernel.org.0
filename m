Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FBC39CE28
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 10:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhFFIph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 04:45:37 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:40723 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhFFIph (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 04:45:37 -0400
Received: by mail-lf1-f49.google.com with SMTP id w33so20977080lfu.7;
        Sun, 06 Jun 2021 01:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MFpS58k0Vm6yIKdn4FIWazrNMfDVvxmfyBGfzdfZZac=;
        b=M1Lh941SKg+jatCQeJs275IZ2b9oBQ61UjNJOu70GSbbbYK/PQST6kTT+xscByEEho
         Je5mIqjqizGGhmwt8dNIRFP3cZQaKgDzbEYdx9gMtPHWwpfKwQFkpbHouJvyuz8azsuK
         AZlbqsjW0umf6KIKA51y7DTmV45EwGXiE3NMP4AOVQjSjSsWyTwyR4cZxypA7OiTDUNe
         pCZv3HonQCejaKTSDDbb+7L8434xyvTEVireq2HRVRwBD+Yu8CkLm2G108wpj9Kk5YNi
         vl/IIimZSDPQQAJe6q6LGC3cokVoNXEulxKrHF3IAy4lMwveXGhTYhdyWRmmpwYr4iUi
         oBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MFpS58k0Vm6yIKdn4FIWazrNMfDVvxmfyBGfzdfZZac=;
        b=stRu/4WdQIrk+5shysD02QWHZMq6XvdqM71gkvgKsqy12uvy+wcu/VCOcEe8Q8Yt+v
         rkukwXW+wML+uDW5dIpGHWhT9yzsTCEuM9cI6Rlyv5g9no/ZMyIEl7phnUs8o39xoWj9
         VsPTqwfMyxCxSmVoReG5JYt3rtR8SFPHXmXz99MaVFs+MPUVEMVuzH4OUASk8mHKoQQC
         IMqFaI8mTiXgzFCrAu8MV3LA2RxtQEKTdNcmAcoQLAZQaRanu2vEgkq+on8Eui2JYBUp
         /CrU612AEv5xtJe3EVRpXnS1RZ9hlNHvG2VeAlgyz8ohLk0KkkuzwjqGnXHkgZJhPIex
         JIPg==
X-Gm-Message-State: AOAM533D0uEyRX8ppsNQaALhZC7SSw0dnxmZLJ3/+S93Oom+rJKtDCcd
        tYKJ9YDUG+wQVYSfcn4jppU=
X-Google-Smtp-Source: ABdhPJwhAGKhNlWPJ4wKrWO+V6d4d6hFiBemL7ZGSZAW9sh3LEqbc6xJ0wI+RMJ5WNvqk9hnmtVgOw==
X-Received: by 2002:ac2:5617:: with SMTP id v23mr7425752lfd.532.1622968966714;
        Sun, 06 Jun 2021 01:42:46 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id h39sm576827lfv.140.2021.06.06.01.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 01:42:46 -0700 (PDT)
Date:   Sun, 6 Jun 2021 11:42:41 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     dledford@redhat.com, jgg@ziepe.ca, shayd@nvidia.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] infiniband: core: fix memory leak
Message-ID: <20210606114241.09ab8830@gmail.com>
In-Reply-To: <YLxbbwcSli9bCec6@unreal>
References: <20210605202051.14783-1-paskripkin@gmail.com>
        <YLxbbwcSli9bCec6@unreal>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 6 Jun 2021 08:21:51 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Sat, Jun 05, 2021 at 11:20:51PM +0300, Pavel Skripkin wrote:
> > My local syzbot instance hit memory leak in
> > copy_process(). The problem was in unputted task
> > struct in _destroy_id().
> > 
> > Simple reproducer:
> > 
> > int main(void)
> > {
> >         struct rdma_ucm_cmd_hdr *hdr;
> >         struct rdma_ucm_create_id *cmd_id;
> >         char cmd[sizeof(*hdr) + sizeof(*cmd_id)] = {0};
> >         int fd;
> > 
> >         hdr = (struct rdma_ucm_cmd_hdr *)cmd;
> >         cmd_id = (struct rdma_ucm_create_id *) (cmd + sizeof(*hdr));
> > 
> >         hdr->cmd = 0;
> >         hdr->in = 0x18;
> >         hdr->out = 0xfa00;
> > 
> >         cmd_id->uid = 0x3;
> >         cmd_id->response = 0x0;
> >         cmd_id->ps = 0x106;
> > 
> >         fd = open("/dev/infiniband/rdma_cm", O_WRONLY);
> >         write(fd, cmd, sizeof(cmd));
> > }
> > 
> > Ftrace log:
> > 
> > ucma_open();
> > ucma_write() {
> >   ucma_create_id() {
> >     ucma_alloc_ctx();
> >     rdma_create_user_id() {
> >       rdma_restrack_new();
> >       rdma_restrack_set_name() {
> >         rdma_restrack_attach_task.part.0(); <--- task_struct getted
> >       }
> >     }
> >     ucma_destroy_private_ctx() {
> >       ucma_put_ctx();
> >       rdma_destroy_id() {
> >         _destroy_id()			    <--- id_priv freed
> >       }
> >     }
> >   }
> > }
> > ucma_close();
> > 
> > From previous log it's easy to undertand that
> > _destroy_id() is the last place, where task_struct
> > can be putted, because at the end of this function
> > id_priv is freed.
> > 
> > With this patch applied, above reproducer doesn't hit memory
> > leak anymore.
> > 
> > Fixes: e51060f08a61 ("IB: IP address based RDMA connection manager")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > ---
> >  drivers/infiniband/core/cma.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/infiniband/core/cma.c
> > b/drivers/infiniband/core/cma.c index ab148a696c0c..2760352261b3
> > 100644 --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -1874,6 +1874,7 @@ static void _destroy_id(struct
> > rdma_id_private *id_priv, 
> >  	kfree(id_priv->id.route.path_rec);
> >  
> > +	rdma_restrack_put(&id_priv->res);
> 
> This change will cause to use-after-free
> 
>  [ 2478.766905] ------------[ cut here ]------------
>  [ 2478.768721] refcount_t: underflow; use-after-free.
>  [ 2478.770577] WARNING: CPU: 1 PID: 56454 at lib/refcount.c:28
> refcount_warn_saturate+0x17a/0x190 [ 2478.773787] Modules linked in:
> bonding ib_umad ip_gre geneve nf_tables ipip tunnel4 ip6_gre gre
> ib_ipoib rdma_ucm mlx5_ib ib_uverbs mlx5_core ptp pps_core ip6_tunnel
> tunnel6 openvswitch nsh xt_conntrack xt_MASQUERADE
> nf_conntrack_netlink nfnetlink rpcrdma xt_addrtype ib_iser libiscsi
> scsi_transport_iscsi iptable_nat nf_nat nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 rdma_cm iw_cm br_netfilter ib_cm ib_core overlay fuse
> [last unloaded: nf_tables] [ 2478.783501] CPU: 1 PID: 56454 Comm:
> python3 Tainted: G        W         5.13.0-rc4_2021_06_05_20_55_37_
> #1 [ 2478.785418] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014 [
> 2478.787566] RIP: 0010:refcount_warn_saturate+0x17a/0x190 [
> 2478.788612] Code: 08 e8 00 0f 0b e9 10 ff ff ff 48 89 df e8 ee c2 5d
> ff e9 d4 fe ff ff 48 c7 c7 40 6d a4 83 c6 05 3b f7 6f 02 01 e8 65 08
> e8 00 <0f> 0b e9 e9 fe ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
> 40 00 [ 2478.792014] RSP: 0018:ffff8881277f7b90 EFLAGS: 00010282 [
> 2478.793081] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> 0000000000000000 [ 2478.794418] RDX: 0000000000000004 RSI:
> 0000000000000008 RDI: ffffed1024efef64 [ 2478.795761] RBP:
> 0000000000000003 R08: 0000000000000001 R09: ffff8882a40bfd47 [
> 2478.797141] R10: ffffed1054817fa8 R11: ffff88812ab60898 R12:
> 0000000000000000 [ 2478.798502] R13: dffffc0000000000 R14:
> dead000000000100 R15: ffff888102099000 [ 2478.799863] FS:
> 00007f5a6492a740(0000) GS:ffff8882a4080000(0000)
> knlGS:0000000000000000 [ 2478.801538] CS:  0010 DS: 0000 ES: 0000
> CR0: 0000000080050033 [ 2478.802671] CR2: 00007f5a56e60900 CR3:
> 00000001aa7d8002 CR4: 0000000000370ea0 [ 2478.804030] DR0:
> 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 [
> 2478.805428] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400 [ 2478.806802] Call Trace: [ 2478.807380]
> rdma_restrack_put+0x5b/0x70 [ib_core] [ 2478.808397]
> _destroy_id+0x41c/0x760 [rdma_cm] [ 2478.809342]  ?
> ucma_close+0x180/0x180 [rdma_ucm] [ 2478.810295]  ?
> ucma_close+0x180/0x180 [rdma_ucm] [ 2478.811252]
> ucma_destroy_private_ctx+0x7e4/0xa80 [rdma_ucm] [ 2478.812371]  ?
> ucma_destroy_id+0x18e/0x220 [rdma_ucm] [ 2478.813422]  ?
> ucma_query_route+0xd70/0xd70 [rdma_ucm] [ 2478.814464]  ?
> ucma_close+0x180/0x180 [rdma_ucm] [ 2478.815400]
> ucma_destroy_id+0x196/0x220 [rdma_ucm] [ 2478.816366]  ?
> ucma_close+0x180/0x180 [rdma_ucm] [ 2478.817313]
> ucma_write+0x1d2/0x2f0 [rdma_ucm] [ 2478.818207]  ?
> ucma_close_id+0x90/0x90 [rdma_ucm] [ 2478.819159]  ?
> __fget_files+0x1e0/0x2f0 [ 2478.819958]  vfs_write+0x1c9/0x850 [
> 2478.820681]  ksys_write+0x176/0x1d0 [ 2478.821436]  ?
> __x64_sys_read+0xb0/0xb0 [ 2478.822234]  ?
> lockdep_hardirqs_on_prepare+0x286/0x400 [ 2478.823256]  ?
> syscall_enter_from_user_mode+0x1d/0x50 [ 2478.824247]
> do_syscall_64+0x3f/0x80 [ 2478.825019]
> entry_SYSCALL_64_after_hwframe+0x44/0xae [ 2478.826015] RIP:
> 0033:0x7f5a64ecf32f [ 2478.826773] Code: 89 54 24 18 48 89 74 24 10
> 89 7c 24 08 e8 19 4b f9 ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b
> 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48
> 89 44 24 08 e8 4c 4b f9 ff 48 [ 2478.830248] RSP:
> 002b:00007ffe9ea8d730 EFLAGS: 00000293 ORIG_RAX: 0000000000000001 [
> 2478.831779] RAX: ffffffffffffffda RBX: 00007ffe9ea8d764 RCX:
> 00007f5a64ecf32f [ 2478.833166] RDX: 0000000000000018 RSI:
> 00007ffe9ea8d770 RDI: 000000000000000a [ 2478.834529] RBP:
> 0000563b16f9f620 R08: 0000000000000000 R09: 00007f5a64db6c60 [
> 2478.835897] R10: 0000000000000001 R11: 0000000000000293 R12:
> 00007f5a574dea60 [ 2478.837278] R13: 00007f5a64db49e0 R14:
> 00007f5a64dba840 R15: 00007f5a565c33a0 [ 2478.838649] irq event
> stamp: 23055 [ 2478.839381] hardirqs last  enabled at (23063):
> [<ffffffff8146354b>] console_unlock+0x5fb/0x8e0 [ 2478.841098]
> hardirqs last disabled at (23072): [<ffffffff81463541>]
> console_unlock+0x5f1/0x8e0 [ 2478.842805] softirqs last  enabled at
> (22670): [<ffffffff81346ba6>] __irq_exit_rcu+0x126/0x1b0 [
> 2478.844498] softirqs last disabled at (22665): [<ffffffff81346ba6>]
> __irq_exit_rcu+0x126/0x1b0 [ 2478.846230] ---[ end trace
> f33482f6d20ccf0e ]---
> 
> I think that better fix is:
> https://lore.kernel.org/linux-rdma/f72e27d5c82cd9beec7670141afa62786836c569.1622956637.git.leonro@nvidia.com/T/#u
> 

Thanks for testing. I ran some random tests, but didn't hit this
use-after-free.

> 
> >  	put_net(id_priv->id.route.addr.dev_addr.net);
> >  	kfree(id_priv);
> >  }
> > -- 
> > 2.31.1
> > 




With regards,
Pavel Skripkin
