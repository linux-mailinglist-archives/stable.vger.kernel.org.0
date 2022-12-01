Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AFD63F05E
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 13:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiLAMXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 07:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiLAMXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 07:23:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F200B1BE83
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 04:23:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCDE4B81EF0
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 12:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B085C433C1;
        Thu,  1 Dec 2022 12:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669897387;
        bh=G7wnHugpkHqVv1MqH8C0x/Zt829wJIXOD9GduhJKYmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SrrJRR14T9ZwiZG2JHNU+fCJYeQ+FRjbffSBh5eh66qNLjzJGZE3bbE9KAdDz9B+n
         Ykcc5WT2z2ZE5PbcXz7b5bjB4fsPiI36HVY+JwRjbsopbPHS0wjhAwyS87hCdD+SbP
         Ym/jV+xo7ToXD3LqxwUcjukiG0k+rsDsA3VVj3fE=
Date:   Thu, 1 Dec 2022 13:23:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     hinxx <hinxx@protonmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: sendfile(2) use with a char driver
Message-ID: <Y4icp/D2U9FMSbsR@kroah.com>
References: <bb1-8NcxtVn8HSt49oYW5HaHrKdOa814M4_SnZAqAKxacGs9rbrHsadsdzZIDBaZ-w4Ki2H2InCY83bq0uBzOkj23YtHz3hYfqOFPKL87F0=@protonmail.com>
 <Y4cAn1foct0ItDzK@kroah.com>
 <bmwBDL_gaUs_XSqmW_Mt6wo8aH1o9pZiuDSZVjAwNtrs8MMiEJobIQThsEVzynHtlSMepyYFOa06lKL_2tORLdZN31sWcld4Zmo-gpjhSy8=@protonmail.com>
 <Y4c0/WBPL72Czwi+@kroah.com>
 <6ZmbsuZEj6y7IRkPIzEouIl5ZnBP6uAdlUpdODJRW-oxQYZvQFL8pDZmg8eKm2y3_3B28xk_ii34yUc9VbW0isBJVDgXf6klMqEs9uzj6ck=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ZmbsuZEj6y7IRkPIzEouIl5ZnBP6uAdlUpdODJRW-oxQYZvQFL8pDZmg8eKm2y3_3B28xk_ii34yUc9VbW0isBJVDgXf6klMqEs9uzj6ck=@protonmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 09:08:27AM +0000, hinxx wrote:
> 
> 
> 
> 
> 
> Sent with Proton Mail secure email.
> 
> ------- Original Message -------
> On Wednesday, November 30th, 2022 at 11:48 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> 
> > On Wed, Nov 30, 2022 at 08:23:45AM +0000, hinxx wrote:
> > 
> > > Sent with Proton Mail secure email.
> > > 
> > > ------- Original Message -------
> > > On Wednesday, November 30th, 2022 at 8:05 AM, Greg KH gregkh@linuxfoundation.org wrote:
> > > 
> > > > On Tue, Nov 29, 2022 at 09:15:24PM +0000, hinxx wrote:
> > > > 
> > > > > I'm looking to use a sendfile(2) with a Xilinx XDMA kernel driver in order to move data from a PCIe board with Xilinx FPGA to the network card with "zero-copy".
> > > > > 
> > > > > Currently I'm getting EINVAL return status from sendfile(2) when providing opened XDMA device file descriptor as input fd.
> > > > > 
> > > > > The device driver provides a character device that can be mmap'ed.
> > > > > 
> > > > > There seem to be other restrictions. Can anyone provide insight on what would be needed to make this work?
> > > > 
> > > > Please contact the authors of your kernel driver, they can answer this
> > > > best.
> > > 
> > > That would make sense, sadly they are MIA on their github repo engagement.
> > 
> > 
> > Have a link to that repo? Again, they are the only ones that can
> > resolve this, or you can modify the code to support this.
> > 
> 
> Thank you for your time Greg!
> 
> I'm trying to understand the concepts behind the sendfile and modify the drivers myself.
> 
> Here is the Xilinx XDMA driver repo:
> 
> https://github.com/Xilinx/dma_ip_drivers/tree/master/XDMA/linux-kernel

That's a very odd driver, it creates a lot of different char device
nodes, all doing different things.  Please work with the authors on that
to figure out how to get this to go faster if you need it and have
determined that the extra copy is the speed limiter here (for most
processors that is not the case, they can copy memory very fast).

And a char device node can support sendfile if the driver supports it,
so this is up to the driver to do so.

good luck!

greg k-h
