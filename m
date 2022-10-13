Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE795FDEC3
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiJMRQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJMRQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:16:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED2AD03BE
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 10:16:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9E22618B4
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 17:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD861C433C1;
        Thu, 13 Oct 2022 17:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665681402;
        bh=1MXajSG1SduZXWEsORHjxxFPaV8Lh9ZF9Sp5J1vlIRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tvWM8K39K7fziTpD5rqPXUT/GzsVpomPp1G/TN/EJSdk08Yh6dPjPEYC8k5zGDJOR
         TuL7GGrHAbGE8LD5BqxZp9KxjV0Sjt8hXVfopYrusR2K2K4qRVELVKr33B5dnxoxiv
         GdYHP3ydEGs7dmRi/z5r+x/TWrJp0YQeuUMeK8ak=
Date:   Thu, 13 Oct 2022 19:17:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 4.9.y 4.14.y] random: use expired timer rather
 than wq for mixing fast pool
Message-ID: <Y0hIHsPdL39HwBLu@kroah.com>
References: <CAHmME9pg8D2cOtoiQYJFYzfkz1RmZY7V_HxRH1WAgd_qXYtPYg@mail.gmail.com>
 <20221013170731.1456197-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221013170731.1456197-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 11:07:31AM -0600, Jason A. Donenfeld wrote:
> commit 748bc4dd9e663f23448d8ad7e58c011a67ea1eca upstream.
> 
> Previously, the fast pool was dumped into the main pool periodically in
> the fast pool's hard IRQ handler. This worked fine and there weren't
> problems with it, until RT came around. Since RT converts spinlocks into
> sleeping locks, problems cropped up. Rather than switching to raw
> spinlocks, the RT developers preferred we make the transformation from
> originally doing:
> 
>     do_some_stuff()
>     spin_lock()
>     do_some_other_stuff()
>     spin_unlock()
> 
> to doing:
> 
>     do_some_stuff()
>     queue_work_on(some_other_stuff_worker)
> 
> This is an ordinary pattern done all over the kernel. However, Sherry
> noticed a 10% performance regression in qperf TCP over a 40gbps
> InfiniBand card. Quoting her message:
> 
> > MT27500 Family [ConnectX-3] cards:
> > Infiniband device 'mlx4_0' port 1 status:
> > default gid: fe80:0000:0000:0000:0010:e000:0178:9eb1
> > base lid: 0x6
> > sm lid: 0x1
> > state: 4: ACTIVE
> > phys state: 5: LinkUp
> > rate: 40 Gb/sec (4X QDR)
> > link_layer: InfiniBand
> >
> > Cards are configured with IP addresses on private subnet for IPoIB
> > performance testing.
> > Regression identified in this bug is in TCP latency in this stack as reported
> > by qperf tcp_lat metric:
> >
> > We have one system listen as a qperf server:
> > [root@yourQperfServer ~]# qperf
> >
> > Have the other system connect to qperf server as a client (in this
> > case, it’s X7 server with Mellanox card):
> > [root@yourQperfClient ~]# numactl -m0 -N0 qperf 20.20.20.101 -v -uu -ub --time 60 --wait_server 20 -oo msg_size:4K:1024K:*2 tcp_lat
> 
> Rather than incur the scheduling latency from queue_work_on, we can
> instead switch to running on the next timer tick, on the same core. This
> also batches things a bit more -- once per jiffy -- which is okay now
> that mix_interrupt_randomness() can credit multiple bits at once.
> 
> Reported-by: Sherry Yang <sherry.yang@oracle.com>
> Tested-by: Paul Webb <paul.x.webb@oracle.com>
> Cc: Sherry Yang <sherry.yang@oracle.com>
> Cc: Phillip Goerl <phillip.goerl@oracle.com>
> Cc: Jack Vogel <jack.vogel@oracle.com>
> Cc: Nicky Veitch <nicky.veitch@oracle.com>
> Cc: Colm Harrington <colm.harrington@oracle.com>
> Cc: Ramanan Govindarajan <ramanan.govindarajan@oracle.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Sultan Alsawaf <sultan@kerneltoast.com>
> Cc: stable@vger.kernel.org
> Fixes: 58340f8e952b ("random: defer fast pool mixing to worker")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/random.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)

That worked, thanks, now queued up.

greg k-h
