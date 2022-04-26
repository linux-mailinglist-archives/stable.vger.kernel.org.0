Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6E450F136
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 08:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbiDZGmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 02:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbiDZGmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 02:42:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74BE1AF32
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 23:39:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8191D6140B
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 06:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C025C385A4;
        Tue, 26 Apr 2022 06:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650955185;
        bh=Im/ysSkjSRGyAqiMGkCmE02AoSF0XzJ8hACV7yLqQF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n7+KG9WvctQIzFSoHfhm07WoXkfPCH7qznlNYAu8R8yRKMZVba4oSwSjCoqIhv8BX
         03Pdpy5UJk0AYQQUBhlHWpBu1FxN0sFhOn+0EfArjBmaOmYnngeHOC+UkERhoVooSL
         UTFWw5xc6ZbU65mrdc3JT54knh+RchW4wd8lwzk4=
Date:   Tue, 26 Apr 2022 08:39:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Khazhy Kumykov <khazhy@google.com>
Cc:     stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block/compat_ioctl: fix range check in BLKGETSIZE
Message-ID: <YmeTrkCUh5sBsIpE@kroah.com>
References: <20220419191239.588421-1-khazhy@google.com>
 <YmErsSY45MQu/Ks4@kroah.com>
 <CACGdZYJR=pAjb2FMQEuGK2ucXKK4_zjwSgs5caTUv88_CrC4-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGdZYJR=pAjb2FMQEuGK2ucXKK4_zjwSgs5caTUv88_CrC4-A@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 25, 2022 at 12:29:41PM -0700, Khazhy Kumykov wrote:
> On Thu, Apr 21, 2022 at 3:02 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Apr 19, 2022 at 12:12:39PM -0700, Khazhismel Kumykov wrote:
> > > [ Upstream commit ccf16413e520164eb718cf8b22a30438da80ff23 ]
> > >
> > > kernel ulong and compat_ulong_t may not be same width. Use type directly
> > > to eliminate mismatches.
> > >
> > > This would result in truncation rather than EFBIG for 32bit mode for
> > > large disks.
> > >
> > > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > > Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> > > Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> > > Link: https://lore.kernel.org/r/20220414224056.2875681-1-khazhy@google.com
> > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > [compat_ioctl is it's own file in 5.4-stable and earlier]
> > > ---
> > >
> > > The original commit should apply to the newer stables
> >
> > It does not, it only applied to 5.17.y.
> >
> > Please provide working backports for all of the others.
> >
> > > this should apply
> > > to all the older stables.
> >
> > I'll wait for the 5.10.y and 5.15.y backport first before applying this
> > one.
> I double checked and the above patch applied to 4.9-5.4 for me

All now queued up, thanks.

greg k-h
