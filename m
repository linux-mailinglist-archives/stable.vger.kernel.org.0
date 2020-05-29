Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5B71E7D89
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 14:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgE2Mq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 08:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgE2Mq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 08:46:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EA7A206A4;
        Fri, 29 May 2020 12:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590756417;
        bh=F3t2dxiHUIDt57araoXS9PDemIzudXNb/UjBh+gfY8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tGvqt4x8b+DG+7jt4lS5H0IW5W1poYYfphvzYEWlFo6FDNbwOnmP4EJedmHnM5Fmd
         px7YCOuppaSI3aGEy6M+EdeknhaEv1RLIJvFcuWMgwMaMXgPICkcMgkA4CjboLjCr9
         8NlKf5nAEpoTbiy7PxmHBtpZ71ruBXfKwcUcLb5Q=
Date:   Fri, 29 May 2020 14:46:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Henri Rosten <henri.rosten@unikie.com>
Cc:     stable@vger.kernel.org, lukas.bulwahn@gmail.com
Subject: Re: Patches potentially missing from stable releases
Message-ID: <20200529124655.GA1714108@kroah.com>
References: <20200529122445.GA32214@buimax>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529122445.GA32214@buimax>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 29, 2020 at 03:24:47PM +0300, Henri Rosten wrote:
> We did some work on analyzing patches potentially missing from stable 
> releases based on the Fixes: and Revert references in the commit 
> messages. Our script is based on similar idea as described by Guenter 
> Roeck in this earlier mail: 
> https://lore.kernel.org/stable/20190827171621.GA30360@roeck-us.net/.
> 
> Although the list is not comprehensive, we figured it makes sense to 
> publish it in case the results are of interest to someone else also.
> 
> The below list of potentially missing commits is based on 4.19, but some 
> of the commits might also apply to 5.4 and 5.6.
> 
> For each potentially missing commit flagged by the script, we read the 
> commit message and had a short look at the change. We then added 
> comments on our own judgement if it might be stable material or not. No 
> comments simply means the potentially missing patch appears stable 
> material. "Based on commit" is the mainline patch that has been 
> backported to 4.19 and is referenced by the missing commit. We did not 
> check if the patch applies without changes, nor did we build or execute 
> any tests.

That last sentence should have been a huge red flag when writing it and
sending out this email...

> 6011002c1584    uio: make symbol 'uio_class_registered' static
>     Based on commit: ae61cf5b9913

You looked at this patch and thought it was relevant for backporting?

Why?  It "obviously" does not fix anything, and is just a cleanup patch.

Why did it pass your criteria?

> 968339fad422    powerpc/boot: Delete unneeded .globl _zimage_start
>     Based on commit: ee9d21b3b358
>     Comment: not stable material?

Ok, I'm going to stop here.

I appreciate sending lists of commits that you have determined should be
applied, and will be glad to review them, but you don't have to give me
a list of all potential patches and your comments on them, as that
doesn't help much.

I have scripts that can churn out the false-positive lists like these,
that's relatively easy to create.  It's the curated lists that you have
looked at and reviewed and determined, in your opinion, should be
applied that are much more valuable and better to work with.

> 61c347ba5511    afs: Clear AFS_VNODE_CB_PROMISED if we detect callback expiry
>     Based on commit: ae3b7361dc0e
>     Comment: likely requires manual backport

At this point, I will need others to do backporting for older kernels
like this, unless there is a good reason why you can't do it yourself.
That shows you actually want the patch to be backported, as you have
done the effort to do so and check that it builds properly.

Again, random lists aren't all that helpful, but curated ones are.

> 2b74c878b0ea    IB/hfi1: Unreserve a flushed OPFN request
>     Based on commit: ca95f802ef51
>     Comment: earlier backport failed, this would likely require manual 
>     backport: https://lore.kernel.org/stable/15649835016938@kroah.com/

This was known not to work.  I asked for help, and just asking for help
again isn't probably going to do much :(

> 0fbf21c3b36a    ALSA: hda/realtek - Enable micmute LED for Huawei laptops
>     Based on commit: 8ac51bbc4cfe
>     Comment: not stable material?

It doesn't apply and needs manual backporting.  Why didn't you test
that?

Again, curated ids, and backported patches are the best thing you can
do to help out here.  See Guenter's email for an example of the first,
and Ben's emails of backported patches for examples of the second.

thanks,

greg k-h


