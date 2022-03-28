Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51614E9010
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 10:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiC1IXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 04:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiC1IXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 04:23:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC80053704;
        Mon, 28 Mar 2022 01:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 48F92CE1268;
        Mon, 28 Mar 2022 08:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F124C004DD;
        Mon, 28 Mar 2022 08:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648455699;
        bh=rGS3hg/MsslSpTPtajHfguVHB2camyQ2cJ7EAOHchlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qs/+XN8V+cYmkweV7abKvrL3IsgVrtYiptavboQsW+qhYyMmfxoKl0neGLCXm9zJj
         RbBpQ8TA2CzS7ZzzfNa4B7e5ffpc7zwQ2SjLlxqXaHUcj30lA+q/FN3zgXl9m2wFHp
         9/GdzpUMeyVxruRswzKx1YEX8m7y08yBYLqWm5JQ=
Date:   Mon, 28 Mar 2022 10:21:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5.10 11/38] swiotlb: rework "fix info leak with
 DMA_FROM_DEVICE"
Message-ID: <YkFwEWy9Pt0v5KLr@kroah.com>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.085364078@linuxfoundation.org>
 <CAHk-=wiaeZKiEk87Sms1sy53m8tT3UCLOoeUBnX1c_1dZ78WjQ@mail.gmail.com>
 <Yj7oXgoCdhWAwFQt@kroah.com>
 <CAHk-=wgeOrhN_Gznm80==STG1pEbqLMCaZZoeQzZu=NN9GOTgw@mail.gmail.com>
 <YkAuqiHAEaDLHDAO@kroah.com>
 <CAHk-=wgzSHQqz33i0DfmFyEG43eeyDkkUO=a3jY0eH2h_1AwgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgzSHQqz33i0DfmFyEG43eeyDkkUO=a3jY0eH2h_1AwgA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 27, 2022 at 11:02:12AM -0700, Linus Torvalds wrote:
> On Sun, Mar 27, 2022 at 2:30 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > But why did you just revert that commit, and not the previous one (i.e.
> > the one that this one "fixes")?  Shouldn't ddbd89deb7d3 ("swiotlb: fix
> > info leak with DMA_FROM_DEVICE") also be dropped?
> 
> The previous one wasn't obviously broken, and while it's a bit ugly,
> it doesn't have the fundamental issues that the "fix" commit had.
> 
> And it does fix the whole "bounce buffer contents are undefined, and
> can get copied back later" at the bounce buffer allocation (well,
> "mapping") stage.
> 
> Which could cause wasted CPU cycles and isn't great, but should fix
> the stale content thing for at least the common "map DMA, do DMA,
> unmap" situation.
> 
> What commit aa6f8dcbab47 tried to fix was the "do multiple DMA
> sequences using one single mapping" case, but that's also what then
> broke ath9k because it really does want to do exactly that, but it
> very much needs to do it using the same buffer with no "let's reset
> it".
> 
> So I think you're fine to drop ddbd89deb7d3 too, but that commit
> doesn't seem *wrong* per se.
> 
> I do think we need some model for "clear the bounce buffer of stale
> data", and I do think that commit ddbd89deb7d3 probably isn't the
> final word, but we don't actually _have_ the final word on this all,
> so stable dropping it all is sane.
> 
> But as mentioned, commit ddbd89deb7d3 can actually fix some cases.
> 
> In particular, I do think it fixes the SG_IO data leak case that
> triggered the whole issue. It was just then the "let's expand on this
> fix" that was a disaster.

Ok, I have just queued that one up now for the older kernels, and the
revert for 5.15 and newer, thanks.

greg k-h
