Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56B42D0250
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 10:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgLFJr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 04:47:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgLFJr2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 04:47:28 -0500
Date:   Sun, 6 Dec 2020 10:47:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607248002;
        bh=9T/fIDQ5YSYC4t3Xz6OjD8bsBiV+ac/8FbFTYXnziEI=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=BzqlnzF+Nsm0paDZEDorEX2OeS9zA//PxJf/x+eE3fJSPrvLoxckqglBgFGvtMS+0
         DZHhUZ+yLETAX/Gf9DshYPFfBIBwyJ3cIwNs9ow/kSJ+oxAOYjIPUwHc8hy3xA/Ygp
         BFoycnaJm7eKnvQ1U5xFRPd/pOs4ZtVgr+wYiLxg=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     yangerkun <yangerkun@huawei.com>, sashal@kernel.org,
        linux-kernel@vger.kernel.org, chenwenyong2@huawei.com,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: Patch "spi: Fix controller unregister order" has been added to
 the 4.4-stable tree
Message-ID: <X8yotKZNLzhtxaYB@kroah.com>
References: <20200616015646.AC54E2074D@mail.kernel.org>
 <8c7683cc-ca73-6883-8e45-613de68fa665@huawei.com>
 <20201205174207.GA4028@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205174207.GA4028@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 05, 2020 at 06:42:07PM +0100, Lukas Wunner wrote:
> On Sat, Oct 10, 2020 at 04:41:09PM +0800, yangerkun wrote:
> > ?? 2020/6/16 9:56, Sasha Levin ????:
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >      spi: Fix controller unregister order
> > > 
> > > to the 4.4-stable tree which can be found at:
> [...]
> > > --- a/drivers/spi/spi.c
> > > +++ b/drivers/spi/spi.c
> > > @@ -1922,11 +1922,12 @@ void spi_unregister_master(struct spi_master *master)
> > >   			dev_err(&master->dev, "queue remove failed\n");
> > >   	}
> > > +	device_for_each_child(&master->dev, NULL, __unregister);
> > > +
> > 
> > This is a wrong patch. We should move this line before
> > spi_destroy_queue, but we didn't. 4.9 stable exists this
> > problem too.
> 
> Hi Sasha, Hi Greg,
> 
> below please find a patch for the 4.9-stable tree to fix the backporting
> issue reported above.

Now applied, thanks.

greg k-h
