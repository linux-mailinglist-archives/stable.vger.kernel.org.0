Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C208763D3BB
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 11:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiK3Ks7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 05:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiK3Ksn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 05:48:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080C5716EC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 02:48:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 494C2B81A9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F18C433D6;
        Wed, 30 Nov 2022 10:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669805312;
        bh=jUB9BI7mlaba3yXbSh9p+F8+j/+zvMiSduDL+Nob0GM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yRyUE2JSLh/PY4yU7PdAVLIjjheCM0fc7UWMzbbtrJvCcaA0EiPN2+VerkrCqn80k
         YTWrC+f4RPPeeK+NOBDcV0EID4w5onABtehtqjIv2qO3tO9fxDv0pDGGhrKsy0zZU1
         FU6IWbtftC53Vtynf/C0KrInmIuQSY4l3NpKkalA=
Date:   Wed, 30 Nov 2022 11:48:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     hinxx <hinxx@protonmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: sendfile(2) use with a char driver
Message-ID: <Y4c0/WBPL72Czwi+@kroah.com>
References: <bb1-8NcxtVn8HSt49oYW5HaHrKdOa814M4_SnZAqAKxacGs9rbrHsadsdzZIDBaZ-w4Ki2H2InCY83bq0uBzOkj23YtHz3hYfqOFPKL87F0=@protonmail.com>
 <Y4cAn1foct0ItDzK@kroah.com>
 <bmwBDL_gaUs_XSqmW_Mt6wo8aH1o9pZiuDSZVjAwNtrs8MMiEJobIQThsEVzynHtlSMepyYFOa06lKL_2tORLdZN31sWcld4Zmo-gpjhSy8=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bmwBDL_gaUs_XSqmW_Mt6wo8aH1o9pZiuDSZVjAwNtrs8MMiEJobIQThsEVzynHtlSMepyYFOa06lKL_2tORLdZN31sWcld4Zmo-gpjhSy8=@protonmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 30, 2022 at 08:23:45AM +0000, hinxx wrote:
> 
> 
> 
> 
> 
> Sent with Proton Mail secure email.
> 
> ------- Original Message -------
> On Wednesday, November 30th, 2022 at 8:05 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> 
> > On Tue, Nov 29, 2022 at 09:15:24PM +0000, hinxx wrote:
> > 
> > > I'm looking to use a sendfile(2) with a Xilinx XDMA kernel driver in order to move data from a PCIe board with Xilinx FPGA to the network card with "zero-copy".
> > > 
> > > Currently I'm getting EINVAL return status from sendfile(2) when providing opened XDMA device file descriptor as input fd.
> > > 
> > > The device driver provides a character device that can be mmap'ed.
> > > 
> > > There seem to be other restrictions. Can anyone provide insight on what would be needed to make this work?
> > 
> > 
> > Please contact the authors of your kernel driver, they can answer this
> > best.
> > 
> 
> That would make sense, sadly they are MIA on their github repo engagement.

Have a link to that repo?  Again, they are the only ones that can
resolve this, or you can modify the code to support this.

> But in general, if I write a PCIe, DMA capable char device, what is the general guidance on what it takes to support splice/sendfile from a char device driver? Maybe there is an existing one in the kernel I could look at?
> 
> Is it even something worth pursuing? This line make me think it might not work for char devices https://elixir.bootlin.com/linux/v5.19.17/source/fs/splice.c#L827. Is going for block device the only way that such device driver can work with the sendfile?

Step back and ask yourself why you want to try to do this first?  Are
you sure the slowdown of a char driver is the copying of the data?
Usually the hardware is the bottleneck, not the kernel code.

Anyway, this is way off-topic for the stable@vger.kernel.org mailing
list, please work on this on a subsystem-specific list.

good luck!

greg k-h
