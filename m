Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE34612086
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 07:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiJ2FX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 01:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJ2FXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 01:23:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8FFBB386;
        Fri, 28 Oct 2022 22:23:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DFD560B93;
        Sat, 29 Oct 2022 05:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8FBC433C1;
        Sat, 29 Oct 2022 05:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667021003;
        bh=4BCMeazaAZuFmFSxNG5KKwwMNmP70F8DdbHA+Dmi6gc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VKgL30F87gWo3NhI0xQxFwnKoQVwmLL2mTdCmPbAn6g7bAhgn3EFRPdN18svjPzd4
         9n9oYWGPOe9v1W7nMZy10sGrr87ACHQr+6OxLc0KeJpWxzAhZzi1IIU4dua933LMhu
         dMtjuUtb6zT0SEkcnM30UNQvFCtGJg0PHlqJEYqY=
Date:   Sat, 29 Oct 2022 07:24:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Oleksandr Tymoshenko <ovt@google.com>, christophe.leroy@csgroup.eu,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        sashal@kernel.org, stable@vger.kernel.org, w@1wt.eu
Subject: Re: [PATCH 5.4 086/255] once: add DO_ONCE_SLOW() for sleepable
 contexts
Message-ID: <Y1y5Ao0c27JfTr8p@kroah.com>
References: <20221024113005.376059449@linuxfoundation.org>
 <20221029011211.4049810-1-ovt@google.com>
 <CANn89iLVb+zHBXhPrD7JAdawLwAAYP_Fc3Vt3YB1AAy1fj=F4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLVb+zHBXhPrD7JAdawLwAAYP_Fc3Vt3YB1AAy1fj=F4w@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 06:18:36PM -0700, Eric Dumazet wrote:
> On Fri, Oct 28, 2022 at 6:12 PM Oleksandr Tymoshenko <ovt@google.com> wrote:
> >
> > Hello,
> >
> > This commit causes the following panic in kernel built with clang
> > (GCC build is not affected):
> >
> > [    8.320308] BUG: unable to handle page fault for address: ffffffff97216c6a                                        [26/4066]
> > [    8.330029] #PF: supervisor write access in kernel mode
> > [    8.337263] #PF: error_code(0x0003) - permissions violation
> > [    8.344816] PGD 12e816067 P4D 12e816067 PUD 12e817063 PMD 800000012e2001e1
> > [    8.354337] Oops: 0003 [#1] SMP PTI
> > [    8.359178] CPU: 2 PID: 437 Comm: curl Not tainted 5.4.220 #15
> > [    8.367241] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
> > [    8.378529] RIP: 0010:__do_once_slow_done+0xf/0xa0
> > [    8.384962] Code: 1b 84 db 74 0c 48 c7 c7 80 ce 8d 97 e8 fa e9 4a 00 84 db 0f 94 c0 5b 5d c3 66 90 55 48 89 e5 41 57 41 56
> > 53 49 89 d7 49 89 f6 <c6> 07 01 48 c7 c7 80 ce 8d 97 e8 d2 e9 4a 00 48 8b 3d 9b de c9 00
> > [    8.409066] RSP: 0018:ffffb764c02d3c90 EFLAGS: 00010246
> > [    8.415697] RAX: 4f51d3d06bc94000 RBX: d474b86ddf7162eb RCX: 000000007229b1d6
> > [    8.424805] RDX: 0000000000000000 RSI: ffffffff9791b4a0 RDI: ffffffff97216c6a
> > [    8.434108] RBP: ffffb764c02d3ca8 R08: 0e81c130f1159fc1 R09: 1d19d60ce0b52c77
> > [    8.443408] R10: 8ea59218e6892b1f R11: d5260237a3c1e35c R12: ffff9c3dadd42600
> > [    8.452468] R13: ffffffff97910f80 R14: ffffffff9791b4a0 R15: 0000000000000000
> > [    8.461416] FS:  00007eff855b40c0(0000) GS:ffff9c3db7a80000(0000) knlGS:0000000000000000
> > [    8.471632] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    8.478763] CR2: ffffffff97216c6a CR3: 000000022ded0000 CR4: 00000000000006a0
> > [    8.487789] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [    8.496684] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [    8.505443] Call Trace:
> > [    8.508568]  __inet_hash_connect+0x523/0x530
> > [    8.513839]  ? inet_hash_connect+0x50/0x50
> > [    8.518818]  ? secure_ipv4_port_ephemeral+0x69/0xe0
> > [    8.525003]  tcp_v4_connect+0x2c5/0x410
> > [    8.529858]  __inet_stream_connect+0xd7/0x360
> > [    8.535329]  ? _raw_spin_unlock+0xe/0x10
> > ... skipped ...
> >
> >
> > The root cause is the difference in __section macro semantics between 5.4 and
> > later LTS releases. On 5.4 it stringifies the argument so the ___done
> > symbol is created in a bogus section ".data.once", with double quotes:
> >
> > % readelf -S vmlinux | grep data.once
> >   [ 5] ".data.once"      PROGBITS         ffffffff82216c6a  01416c6a
> 
> Yes, this has been discovered earlier today.
> 
> Look at Google-Bug-Id 256204637

It's a bit hard to see a google bug in public :(

Why not talk about it here?

> (include/linux/mmdebug.h has a similar issue)

Is this an issue in Linus's tree?  Should it be reverted there and/or in
stable kernels too?

what is recommended?

thanks,

greg k-h
