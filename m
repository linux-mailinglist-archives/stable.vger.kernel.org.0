Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD455FA3EB
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 21:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJJTHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 15:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJJTHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 15:07:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08791ADB7
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 12:07:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A4FF60EF9
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 19:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0B1C433C1;
        Mon, 10 Oct 2022 19:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665428838;
        bh=9+vd2DCu/VJwmEGPuVhwnwfGI/Bgenh05yFjvLX/VsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sii25ggXsgS/Pp9XwnuicchkWvVPLFfKfBhjVMiZYNiBen/lYuCjzQAXT7UlA6hle
         nFdp6/DRktzpPbhxO4vR1dXwYjIsWRplzPF+Z8huLDN/560wg/mgnOv2nmrGE8MQsG
         I0SWoMJBNlU2qaUgvwtp163uiwqsFe+nYPDr2EMw=
Date:   Mon, 10 Oct 2022 21:08:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport of patches 8238b4579866b7c1bb99883cfe102a43db5506ff and
 d6ffe6067a54972564552ea45d320fb98db1ac5e
Message-ID: <Y0Rtkk7hA4CBwp16@kroah.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com>
 <YzflXQMdGLsjPb70@kroah.com>
 <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com>
 <Yz21dn2vJPOVOffr@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz21dn2vJPOVOffr@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 05, 2022 at 06:48:54PM +0200, Greg KH wrote:
> On Mon, Oct 03, 2022 at 08:28:06AM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Sat, 1 Oct 2022, Greg KH wrote:
> > 
> > > On Fri, Sep 30, 2022 at 11:32:30AM -0400, Mikulas Patocka wrote:
> > > > Hi
> > > > 
> > > > Here I'm submitting backport of patches 
> > > > 8238b4579866b7c1bb99883cfe102a43db5506ff and 
> > > > d6ffe6067a54972564552ea45d320fb98db1ac5e to the stable branches.
> > > 
> > > Thanks, but you provide no information as to why these are needed.
> > > 
> > > What needs them?  They are just adding new functions to the tree from
> > > what I can tell.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > There's a race condition in wait_on_bit. wait_on_bit tests a bit using the 
> > "test_bit" function, however this function doesn't do any memory barrier, 
> > so the memory accesses that follow wait_on_bit may be reordered before it 
> > and return invalid data.
> > 
> > Linus didn't want to add a memory barrier to wait_on_bit, he instead 
> > wanted to introduce a new function test_bit_acquire that performs the 
> > "acquire" memory barrier and use it in wait_on_bit.
> > 
> > The patch d6ffe6067a54972564552ea45d320fb98db1ac5e fixes an oversight in 
> > the patch 8238b4579866b7c1bb99883cfe102a43db5506ff where the function 
> > test_bit_acquire was not defined for some architectures and this caused 
> > compile failure.
> > 
> > The backport of the patch 8238b4579866b7c1bb99883cfe102a43db5506ff should 
> > be applied first and the backport of the patch 
> > d6ffe6067a54972564552ea45d320fb98db1ac5e afterwards.
> 
> All now queued up, thanks.

Nope, these cause loads of breakages.  See
https://lore.kernel.org/r/09eca44e-4d91-a060-d48c-d0aa41ac5045@roeck-us.net
for one such example, and I know kbuild sent you other build problems.
I'll drop all of these from the stable trees now.  Please feel free to
resend them when you have the build issues worked out.

thanks,

greg k-h
