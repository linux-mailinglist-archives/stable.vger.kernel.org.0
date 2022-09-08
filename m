Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8E35B11AE
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 02:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiIHA6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 20:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiIHA6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 20:58:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D3B9A9CF;
        Wed,  7 Sep 2022 17:58:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8E27B20A56;
        Thu,  8 Sep 2022 00:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662598709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1sVWnAAnTYxB9mmx1/j+RlRGXGxT07VbcuqU/QACwrU=;
        b=rLNm8ktG0jQCPjWFLwxMRAePAc3t/nhRGPMRXgE0whNd0A3EKWF7oNeATJ+CifQgLikJDD
        wYd0ANTVsmYmaZZQG+uCt7PIfI3cUMTqyqnyyQC222s7422rtejZ5/kCZb0vgSVOHby2yI
        +B5HPdMFt+aPw4XMLi5/HbZTyJFPEsU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662598709;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1sVWnAAnTYxB9mmx1/j+RlRGXGxT07VbcuqU/QACwrU=;
        b=2jetKXQJo9onTu5rzMn6L3lnRBCzygv0U1UBC5xBFFsROzqco0Ya1YGYOg3gSIwrLESSU5
        tOSKfjpKNC5BoaCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 14B8D1339E;
        Thu,  8 Sep 2022 00:58:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TIAXLzI+GWP6DQAAMHmgww
        (envelope-from <neilb@suse.de>); Thu, 08 Sep 2022 00:58:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Eugeniu Rosca" <erosca@de.adit-jv.com>
Cc:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Trond Myklebust" <trond.myklebust@hammerspace.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Michael Rodin" <mrodin@de.adit-jv.com>,
        "Eugeniu Rosca" <erosca@de.adit-jv.com>,
        "Eugeniu Rosca" <roscaeugeniu@gmail.com>
Subject: Re: [PATCH 4.14 022/284] SUNRPC: avoid race between mod_timer() and
 del_timer_sync()
In-reply-to: <20220907142548.GA9975@lxhi-065>
References: <20220418121210.689577360@linuxfoundation.org>,
 <20220418121211.327937970@linuxfoundation.org>,
 <20220907142548.GA9975@lxhi-065>
Date:   Thu, 08 Sep 2022 10:58:23 +1000
Message-id: <166259870333.30452.4204968221881228505@noble.neil.brown.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 08 Sep 2022, Eugeniu Rosca wrote:
> Hello all,
>=20
> On Mo, Apr 18, 2022 at 02:10:03 +0200, Greg Kroah-Hartman wrote:
> > From: NeilBrown <neilb@suse.de>
> >=20
> > commit 3848e96edf4788f772d83990022fa7023a233d83 upstream.
> >=20
> > xprt_destory() claims XPRT_LOCKED and then calls del_timer_sync().
> > Both xprt_unlock_connect() and xprt_release() call
> >  ->release_xprt()
> > which drops XPRT_LOCKED and *then* xprt_schedule_autodisconnect()
> > which calls mod_timer().
> >=20
> > This may result in mod_timer() being called *after* del_timer_sync().
> > When this happens, the timer may fire long after the xprt has been freed,
> > and run_timer_softirq() will probably crash.
> >=20
> > The pairing of ->release_xprt() and xprt_schedule_autodisconnect() is
> > always called under ->transport_lock.  So if we take ->transport_lock to
> > call del_timer_sync(), we can be sure that mod_timer() will run first
> > (if it runs at all).
> >=20
> > Cc: stable@vger.kernel.org
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  net/sunrpc/xprt.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> >=20
> > --- a/net/sunrpc/xprt.c
> > +++ b/net/sunrpc/xprt.c
> > @@ -1520,7 +1520,14 @@ static void xprt_destroy(struct rpc_xprt
> >  	 */
> >  	wait_on_bit_lock(&xprt->state, XPRT_LOCKED, TASK_UNINTERRUPTIBLE);
> > =20
> > +	/*
> > +	 * xprt_schedule_autodisconnect() can run after XPRT_LOCKED
> > +	 * is cleared.  We use ->transport_lock to ensure the mod_timer()
> > +	 * can only run *before* del_time_sync(), never after.
> > +	 */
> > +	spin_lock(&xprt->transport_lock);
> >  	del_timer_sync(&xprt->timer);
> > +	spin_unlock(&xprt->transport_lock);

I think it is sufficient to change the to spin_{,un}lock_bh()
in older kernels.  The spinlock call need to match other uses of the
same lock.

Can you confirm doing that removes the problem?

NeilBrown




> > =20
> >  	/*
> >  	 * Destroy sockets etc from the system workqueue so they can
>=20
> This commit introduced the following warning [1][2] on the
> v4.9, v4.14 and v4.19 stable trees, when booting Renesas H3ULCB
> (and potentially other HW targets) from NFS.
>=20
> Once in a while, the issue leads to the real freeze of the target.
>=20
> The culprit commits have been identified via git bisecting (see [1]).
>=20
> Additionally, it has been determined that what's missing for fixing
> the issue on the stable trees are the two v5.3-rc1 mainline commits:
>=20
> 4f8943f8088348 ("SUNRPC: Replace direct task wakeups from softirq context")
> b5e924191f8723 ("SUNRPC: Remove the bh-safe lock requirement on xprt->trans=
port_lock")
>=20
> However, attempting to port them to the stable trees leads to
> significant amount of conflicts. Any idea if the culprit commit(s)
> should better be reverted?
>=20
> [1] https://gist.github.com/erosca/7b5f1dadd4172b38461478d38c1040b8
> [2] Excerpt from [1]
>=20
> [    7.548549] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [    7.552827] WARNING: inconsistent lock state
> [    7.557112] 4.14.292 #35 Not tainted
> [    7.560694] --------------------------------
> [    7.564973] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> [    7.570994] swapper/0/0 [HC0[0]:SC1[3]:HE1:SE0] takes:
> [    7.576142]  (&(&xprt->transport_lock)->rlock){+.?.}, at: [<ffff2000095a=
6a48>] xs_tcp_state_change+0x740/0xb24
> [    7.586196] {SOFTIRQ-ON-W} state was registered at:
> [    7.591093]   lock_acquire+0x724/0x790
> [    7.594857]   _raw_spin_lock+0xec/0x12c
> [    7.598706]   xprt_destroy+0xc8/0x214
> [    7.602379]   xprt_put+0x34/0x40
> [    7.605618]   rpc_new_client+0x1a8/0x8e8
> [    7.609552]   rpc_create_xprt+0x124/0x300
> [    7.613573]   rpc_create+0x234/0x410
> [    7.617162]   nfs_create_rpc_client+0x33c/0x38c
> [    7.621709]   nfs4_alloc_client+0x8f4/0xb5c
> [    7.625904]   nfs_get_client+0x10d4/0x10e8
> [    7.630013]   nfs4_set_client+0x1b0/0x254
> [    7.634034]   nfs4_create_server+0x4c0/0x92c
> [    7.638317]   nfs4_remote_mount+0x74/0xac
> [    7.642339]   mount_fs+0x80/0x27c
> [    7.645666]   vfs_kern_mount+0xe0/0x3b4
> [    7.649514]   nfs_do_root_mount+0x8c/0xc8
> [    7.653534]   nfs4_try_mount+0xdc/0x120
> [    7.657382]   nfs_fs_mount+0x1b6c/0x2038
> [    7.661315]   mount_fs+0x80/0x27c
> [    7.664639]   vfs_kern_mount+0xe0/0x3b4
> [    7.668488]   do_mount+0x1324/0x1c90
> [    7.672074]   SyS_mount+0xc0/0xd0
> [    7.675403]   mount_root+0xe4/0x1c0
> [    7.678903]   prepare_namespace+0x174/0x184
> [    7.683098]   kernel_init_freeable+0x5b4/0x674
> [    7.687556]   kernel_init+0x18/0x138
> [    7.691144]   ret_from_fork+0x10/0x18
> [    7.694814] irq event stamp: 24322
> [    7.698228] hardirqs last  enabled at (24322): [<ffff200009679f8c>] _raw=
_spin_unlock_irqrestore+0x100/0x108
> [    7.707990] hardirqs last disabled at (24321): [<ffff200009679a38>] _raw=
_spin_lock_irqsave+0x30/0x138
> [    7.717233] softirqs last  enabled at (24244): [<ffff2000080e79d8>] _loc=
al_bh_enable+0x78/0x84
> [    7.725865] softirqs last disabled at (24245): [<ffff2000080e9ed4>] irq_=
exit+0x350/0x4e0
> [    7.733969]=20
> [    7.733969] other info that might help us debug this:
> [    7.740511]  Possible unsafe locking scenario:
> [    7.740511]=20
> [    7.746442]        CPU0
> [    7.748893]        ----
> [    7.751343]   lock(&(&xprt->transport_lock)->rlock);
> [    7.756323]   <Interrupt>
> [    7.758947]     lock(&(&xprt->transport_lock)->rlock);
> [    7.764100]=20
> [    7.764100]  *** DEADLOCK ***
> [    7.764100]=20
> [    7.770038] 4 locks held by swapper/0/0:
> [    7.773967]  #0:  (rcu_read_lock){....}, at: [<ffff200009318d1c>] netif_=
receive_skb_internal+0x1b0/0x99c
> [    7.783487]  #1:  (rcu_read_lock){....}, at: [<ffff2000093e0b10>] ip_loc=
al_deliver_finish+0x1e4/0xae0
> [    7.792743]  #2:  (slock-AF_INET-RPC/1){+.-.}, at: [<ffff2000094757cc>] =
tcp_v4_rcv+0x1a04/0x2694
> [    7.801567]  #3:  (k-clock-AF_INET){++.-}, at: [<ffff2000095a633c>] xs_t=
cp_state_change+0x34/0xb24
> [    7.810559]=20
> [    7.810559] stack backtrace:
> [    7.814931] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.292 #35
> [    7.821123] Hardware name: Renesas H3ULCB Kingfisher board based on r8a7=
795 ES2.0+ (DT)
> [    7.829142] Call trace:
> [    7.831599]  dump_backtrace+0x0/0x320
> [    7.835272]  show_stack+0x24/0x30
> [    7.838598]  dump_stack+0x150/0x1b8
> [    7.842097]  print_usage_bug.part.23+0x5c4/0x724
> [    7.846725]  mark_lock+0x940/0x113c
> [    7.850223]  __lock_acquire+0x9a8/0x2e70
> [    7.854156]  lock_acquire+0x724/0x790
> [    7.857827]  _raw_spin_lock+0xec/0x12c
> [    7.861586]  xs_tcp_state_change+0x740/0xb24
> [    7.865869]  tcp_rcv_state_process+0x1330/0x3a34
> [    7.870498]  tcp_v4_do_rcv+0x9c8/0x9dc
> [    7.874256]  tcp_v4_rcv+0x1c5c/0x2694
> [    7.877930]  ip_local_deliver_finish+0x770/0xae0
> [    7.882560]  ip_local_deliver+0x1c0/0x528
> [    7.886581]  ip_rcv_finish+0x770/0x1024
> [    7.890427]  ip_rcv+0xa50/0xe5c
> [    7.893579]  __netif_receive_skb_core+0x1adc/0x2164
> [    7.898470]  __netif_receive_skb+0x1e0/0x1e8
> [    7.902752]  netif_receive_skb_internal+0x6c8/0x99c
> [    7.907642]  napi_gro_receive+0x79c/0x7dc
> [    7.911666]  ravb_poll+0xc98/0x1594
> [    7.915165]  napi_poll+0x260/0xb6c
> [    7.918577]  net_rx_action+0x2fc/0x668
> [    7.922336]  __do_softirq+0xec8/0x1620
> [    7.926095]  irq_exit+0x350/0x4e0
> [    7.929421]  __handle_domain_irq+0x124/0x1c0
> [    7.933701]  gic_handle_irq+0x70/0xb0
> [    7.937372]  el1_irq+0xb4/0x140
> [    7.940523]  arch_cpu_idle+0x17c/0x7fc
> [    7.944282]  default_idle_call+0x74/0x8c
> [    7.948216]  do_idle+0x250/0x344
> [    7.951453]  cpu_startup_entry+0x28/0x38
> [    7.955387]  rest_init+0x5f0/0x604
> [    7.958799]  start_kernel+0x5dc/0x60c
>=20
> Best Regards,
> Eugeniu Rosca
>=20
