Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E64D4E8056
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 11:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiCZKUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 06:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiCZKUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 06:20:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035B6B95;
        Sat, 26 Mar 2022 03:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E48B60AB4;
        Sat, 26 Mar 2022 10:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152A4C2BBE4;
        Sat, 26 Mar 2022 10:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648289889;
        bh=OZH7g2IpG6pK2wMxM9iGM7s18WiIbcFEqwaQDkLIJMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A+4daBoM17fEB6UEwD338UFvlZtz7aDf+AyiXnXrtUx6xSXqSS0R4dTMQwLz90cus
         A73pJA9vstoHKNfEhOkhMi9oWky6N2WTDtcMnIQlhfAvp5vJghfoyxtHiYNKw1b8q+
         LjNxfFhgWkoAyHZ5HdynxTinUpt36awiPZ55DYCo=
Date:   Sat, 26 Mar 2022 11:18:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5.10 11/38] swiotlb: rework "fix info leak with
 DMA_FROM_DEVICE"
Message-ID: <Yj7oXgoCdhWAwFQt@kroah.com>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.085364078@linuxfoundation.org>
 <CAHk-=wiaeZKiEk87Sms1sy53m8tT3UCLOoeUBnX1c_1dZ78WjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiaeZKiEk87Sms1sy53m8tT3UCLOoeUBnX1c_1dZ78WjQ@mail.gmail.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 10:08:27AM -0700, Linus Torvalds wrote:
> On Fri, Mar 25, 2022 at 8:09 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Halil Pasic <pasic@linux.ibm.com>
> >
> > commit aa6f8dcbab473f3a3c7454b74caa46d36cdc5d13 upstream.
> 
> This one causes a regression on at least some wireless drivers
> (ath9k). There's some active discussion about it, maybe it gets
> reverted, maybe there are other options.
> 
> There's an ath9k patch that fixes the problem, so if this patch goes
> into the stable tree the ath9k fix will follow.
> 
> But it might be a good idea to simply hold off on this patch a bit,
> because that ath9k patch hasn't actually landed yet, there's some
> discussion about it all, and it's not clear that other drivers might
> not have the same issue.
> 
> So I'm not NAK'ing this patch from stable, but I also don't think it's
> timing-critical, and it might be a good idea to delay it for a week or
> two to both wait for the ath9k patch and to see if something else
> comes up.

Yes, I've been watching that thread.  This change is already in 5.15 and
5.16 kernels, and does solve one known security issue, so it's a tough
call.  I'll drop them from 5.10 and 5.4 for now and save them to see how
it plays out...

thanks,

greg k-h
