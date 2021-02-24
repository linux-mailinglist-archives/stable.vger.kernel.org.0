Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBD132380B
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 08:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhBXHsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 02:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232244AbhBXHsL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 02:48:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6703F64ED0;
        Wed, 24 Feb 2021 07:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614152849;
        bh=RVf5GkQcDbIy/YKyojc1T9OWKopOggYUqzd/K3p18Gc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fsl0Mazf9x2E9GV9w09rtf7Ll8pgIoQguOgdeJhYFyeEUmbYNcG1UC6w53UJKzFWO
         wHyhPW9cuxLtwAu7sFC/COAXk5Xl6v8yLSEz9V5sW+/EAHYisBXmzwJ3L5Fp9AowX2
         t95iO76FJbBAxhWHNUguaWWcXr75AybyXNqARM38=
Date:   Wed, 24 Feb 2021 08:47:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sashal@kernel.org, tglx@linutronix.de, wangle6@huawei.com,
        zhengyejian1@huawei.com
Subject: Re: [PATCH stable-rc queue/4.9 1/1] futex: Provide distinct return
 value when owner is exiting
Message-ID: <YDYEjmfcykR3achs@kroah.com>
References: <20210222070328.102384-1-nixiaoming@huawei.com>
 <20210222070328.102384-2-nixiaoming@huawei.com>
 <YDOEZhmKqjTVxtMn@kroah.com>
 <3bc570f6-f8af-b0a2-4d62-13ed4adc1f33@huawei.com>
 <YDOe9GNivoHQphQc@kroah.com>
 <76f6a446-41db-3b7a-dcab-a85d0841654f@huawei.com>
 <YDT8ZsMqVqihECoE@kroah.com>
 <2e8cf845-30ee-22c2-428a-b56e03cb49e4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e8cf845-30ee-22c2-428a-b56e03cb49e4@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 09:41:01AM +0800, Xiaoming Ni wrote:
> On 2021/2/23 21:00, Greg KH wrote:
> > On Mon, Feb 22, 2021 at 10:11:37PM +0800, Xiaoming Ni wrote:
> > > On 2021/2/22 20:09, Greg KH wrote:
> > > > On Mon, Feb 22, 2021 at 06:54:06PM +0800, Xiaoming Ni wrote:
> > > > > On 2021/2/22 18:16, Greg KH wrote:
> > > > > > On Mon, Feb 22, 2021 at 03:03:28PM +0800, Xiaoming Ni wrote:
> > > > > > > From: Thomas Gleixner<tglx@linutronix.de>
> > > > > > > 
> > > > > > > commit ac31c7ff8624409ba3c4901df9237a616c187a5d upstream.
> > > > > > This commit is already in the 4.9 tree.  If the backport was incorrect,
> > > > > > say that here, and describe what went wrong and why this commit fixes
> > > > > > it.
> > > > > > 
> > > > > > Also state what commit this fixes as well, otherwise this changelog just
> > > > > > looks like it is being applied again to the tree, which doesn't make
> > > > > > much sense.
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > > .
> > > > > 
> > > > > I wrote a cover for it. but forgot to adjust the title of the cover:
> > > > > 
> > > > > https://lore.kernel.org/lkml/20210222070328.102384-1-nixiaoming@huawei.com/
> > > > > 
> > > > > 
> > > > > I found a dead code in the queue/4.9 branch of the stable-rc repository.
> > > > > 
> > > > > 2021-02-03:
> > > > > commit c27f392040e2f6 ("futex: Provide distinct return value when
> > > > >    owner is exiting")
> > > > > 	The function handle_exit_race does not exist. Therefore, the
> > > > > 	change in handle_exit_race() is ignored in the patch round.
> > > > > 
> > > > > 2021-02-22:
> > > > > commit e55cb811e612 ("futex: Cure exit race")
> > > > > 	Define the handle_exit_race() function,
> > > > > 	but no branch in the function returns EBUSY.
> > > > > 	As a result, dead code occurs in the attach_to_pi_owner():
> > > > > 
> > > > > 		int ret = handle_exit_race(uaddr, uval, p);
> > > > > 		...
> > > > > 		if (ret == -EBUSY)
> > > > > 			*exiting = p; /* dead code */
> > > > > 
> > > > > To fix the dead code, modify the commit e55cb811e612 ("futex: Cure exit
> > > > > race"),
> > > > > or install a patch to incorporate the changes in handle_exit_race().
> > > > > 
> > > > > I am unfamiliar with the processing of the stable-rc queue branch,
> > > > > and I cannot find the patch mail of the current branch in
> > > > > 	https://lore.kernel.org/lkml/?q=%22futex%3A+Cure+exit+race%22
> > > > > Therefore, I re-integrated commit ac31c7ff8624 ("futex: Provide distinct
> > > > >    return value when owner is exiting").
> > > > >    And wrote a cover (but forgot to adjust the title of the cover):
> > > > > 
> > > > > https://lore.kernel.org/lkml/20210222070328.102384-1-nixiaoming@huawei.com/
> > > > 
> > > > So this is a "fixup" patch, right?
> > > > 
> > > > Please clearly label it as such in your patch description and resend
> > > > this as what is here I can not apply at all.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > .
> > > > 
> > > Thank you for your guidance.
> > > I have updated the patch description and resent the patch based on
> > > v4.9.258-rc1
> > > https://lore.kernel.org/lkml/20210222125352.110124-1-nixiaoming@huawei.com/
> > 
> > Can you please try 4.9.258 and let me know if this is still needed or
> > not?
> > 
> > thanks,
> > 
> > greg k-h
> > .
> > 
> The dead code problem still exists in V4.9.258. No conflict occurs during my
> patch integration. Do I need to correct the version number marked in the cc
> table in the patch and resend the patch?

Please do.

thanks,

greg k-h
