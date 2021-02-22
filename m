Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E99D3215D2
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhBVMKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:10:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhBVMKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:10:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23A8E60C3E;
        Mon, 22 Feb 2021 12:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613995769;
        bh=vkn91XSEQHym5zKtY83o4vZak+yc+4d2glFxeuvEa3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kdoClrqPsqQJvuHVAsqzA23cnbbgUVBjy4WIU4/1dWdtDtufSVrLOI6QT2zvCSbnA
         nXP2F1NUsdyMy6h2EicBCRXHwYsxST/CfQesrbJLD4QipaWEYpYxCJsjU60QtZdBV8
         zFemL0Kt4oaXbt7no6Cw0Z+l8xlIG7FQYHa/kRPA=
Date:   Mon, 22 Feb 2021 13:09:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sashal@kernel.org, tglx@linutronix.de, wangle6@huawei.com,
        zhengyejian1@huawei.com
Subject: Re: [PATCH stable-rc queue/4.9 1/1] futex: Provide distinct return
 value when owner is exiting
Message-ID: <YDOe9GNivoHQphQc@kroah.com>
References: <20210222070328.102384-1-nixiaoming@huawei.com>
 <20210222070328.102384-2-nixiaoming@huawei.com>
 <YDOEZhmKqjTVxtMn@kroah.com>
 <3bc570f6-f8af-b0a2-4d62-13ed4adc1f33@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bc570f6-f8af-b0a2-4d62-13ed4adc1f33@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 06:54:06PM +0800, Xiaoming Ni wrote:
> On 2021/2/22 18:16, Greg KH wrote:
> > On Mon, Feb 22, 2021 at 03:03:28PM +0800, Xiaoming Ni wrote:
> > > From: Thomas Gleixner<tglx@linutronix.de>
> > > 
> > > commit ac31c7ff8624409ba3c4901df9237a616c187a5d upstream.
> > This commit is already in the 4.9 tree.  If the backport was incorrect,
> > say that here, and describe what went wrong and why this commit fixes
> > it.
> > 
> > Also state what commit this fixes as well, otherwise this changelog just
> > looks like it is being applied again to the tree, which doesn't make
> > much sense.
> > 
> > thanks,
> > 
> > greg k-h
> > .
> 
> I wrote a cover for it. but forgot to adjust the title of the cover:
> 
> https://lore.kernel.org/lkml/20210222070328.102384-1-nixiaoming@huawei.com/
> 
> 
> I found a dead code in the queue/4.9 branch of the stable-rc repository.
> 
> 2021-02-03:
> commit c27f392040e2f6 ("futex: Provide distinct return value when
>  owner is exiting")
> 	The function handle_exit_race does not exist. Therefore, the
> 	change in handle_exit_race() is ignored in the patch round.
> 
> 2021-02-22:
> commit e55cb811e612 ("futex: Cure exit race")
> 	Define the handle_exit_race() function,
> 	but no branch in the function returns EBUSY.
> 	As a result, dead code occurs in the attach_to_pi_owner():
> 
> 		int ret = handle_exit_race(uaddr, uval, p);
> 		...
> 		if (ret == -EBUSY)
> 			*exiting = p; /* dead code */
> 
> To fix the dead code, modify the commit e55cb811e612 ("futex: Cure exit
> race"),
> or install a patch to incorporate the changes in handle_exit_race().
> 
> I am unfamiliar with the processing of the stable-rc queue branch,
> and I cannot find the patch mail of the current branch in
> 	https://lore.kernel.org/lkml/?q=%22futex%3A+Cure+exit+race%22
> Therefore, I re-integrated commit ac31c7ff8624 ("futex: Provide distinct
>  return value when owner is exiting").
>  And wrote a cover (but forgot to adjust the title of the cover):
> 
> https://lore.kernel.org/lkml/20210222070328.102384-1-nixiaoming@huawei.com/

So this is a "fixup" patch, right?

Please clearly label it as such in your patch description and resend
this as what is here I can not apply at all.

thanks,

greg k-h
