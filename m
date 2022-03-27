Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D724E8719
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 11:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiC0JcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 05:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiC0JcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 05:32:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8DC1ADAF;
        Sun, 27 Mar 2022 02:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F01FB80B83;
        Sun, 27 Mar 2022 09:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAE2C340EC;
        Sun, 27 Mar 2022 09:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648373420;
        bh=uYdHV634xx8fmttpJSv5wEyHchLuqfos7d5Vy+D+VfY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pSPEJ13ZnylSrihPfIfASdYXVdJVBFZIVI3NRzXjCuygzphTWvP8/Z7td5vUgNYUx
         HA+f/KB0ARm5JuaP0rKwf/vLkqbBa+aYeg1i9V0r/5YyBoIjxupcaijc1nzZoNwe78
         cFnH85Ch+r7SwobYSaa6jLu7fzboe84WthW1q+MA=
Date:   Sun, 27 Mar 2022 11:30:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5.10 11/38] swiotlb: rework "fix info leak with
 DMA_FROM_DEVICE"
Message-ID: <YkAuqiHAEaDLHDAO@kroah.com>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.085364078@linuxfoundation.org>
 <CAHk-=wiaeZKiEk87Sms1sy53m8tT3UCLOoeUBnX1c_1dZ78WjQ@mail.gmail.com>
 <Yj7oXgoCdhWAwFQt@kroah.com>
 <CAHk-=wgeOrhN_Gznm80==STG1pEbqLMCaZZoeQzZu=NN9GOTgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgeOrhN_Gznm80==STG1pEbqLMCaZZoeQzZu=NN9GOTgw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 26, 2022 at 11:41:17AM -0700, Linus Torvalds wrote:
> On Sat, Mar 26, 2022 at 3:18 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:"
> >
> > Yes, I've been watching that thread.  This change is already in 5.15 and
> > 5.16 kernels, and does solve one known security issue, so it's a tough
> > call.
> 
> If you're following that thread, you'll have seen that I've reverted
> it, and I actually think the security argument was bogus - the whole
> commit was due to a misunderstanding of the actual direction of the
> data transfer.

I see that now, thanks.

But why did you just revert that commit, and not the previous one (i.e.
the one that this one "fixes")?  Shouldn't ddbd89deb7d3 ("swiotlb: fix
info leak with DMA_FROM_DEVICE") also be dropped?

I'm going to drop both from the 5.4 and 5.10 stable queues now, and add
your revert, but I think your tree also needs the original swiotlb fix
commit reverted to get back to a "known good" state.

thanks,

greg k-h
