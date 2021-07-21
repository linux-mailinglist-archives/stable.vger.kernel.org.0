Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6883D0F3D
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 15:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbhGUM3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 08:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236534AbhGUM3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 08:29:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6D5A60E08;
        Wed, 21 Jul 2021 13:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626872985;
        bh=0cKN38H5QwtYtjSBi1Vxzqbnp5z74e0BfgWfrJuLPA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jQ+IqBMfJVMb52jT89kNU14QdMO3JM6YHHJwvO4KEvBFPgwg4npPj9UMPmZPdMzoa
         +b5Qmm8iVjDItVzZ8R8EnzkQwiNd2jXBXEKJT7ywecbOX0YIcIUlLxng7Wkjjd36A/
         vgBjd9/GRVuyk7crZuH3ISRMgBOy/obAVYFiB1852RL7aipXVX2uLTktQW8OkgO1KG
         wy0vmW9RtKEziO2U9rK1YXmKiLU9DDNpb+jXJ2VZVJPfJpkMALRPGtYmSVqbPq2Odc
         JZMBZ4oCnmVIiFysYquhd8HZ2byhfkq6R8hm3pQynB4VDXGuRVsru6KgXjdgWLIi88
         /6ND2azVNT4Cw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m6ByT-00018a-DS; Wed, 21 Jul 2021 15:09:21 +0200
Date:   Wed, 21 Jul 2021 15:09:21 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tty: nozomi: tty_unregister_device ->
 tty_port_unregister_device
Message-ID: <YPgcgahQ458ndT1j@hovoldconsulting.com>
References: <20210721113305.1524059-1-mudongliangabcd@gmail.com>
 <YPgMZBK/FWLRD1Ic@hovoldconsulting.com>
 <CAD-N9QVLshn_A=S+Nqemc9BRUdW432VrLJCAb=t35WaoL-C3=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-N9QVLshn_A=S+Nqemc9BRUdW432VrLJCAb=t35WaoL-C3=Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 21, 2021 at 08:53:47PM +0800, Dongliang Mu wrote:
> On Wed, Jul 21, 2021 at 8:01 PM Johan Hovold <johan@kernel.org> wrote:
> >
> > On Wed, Jul 21, 2021 at 07:33:04PM +0800, Dongliang Mu wrote:
> > > The pairwise api invocation of tty_port_register_device should be
> > > tty_port_unregister_device, other than tty_unregister_device.
> >
> > Are you sure about that? Please explain why you think this to be the
> > case and why this change is needed.
> 
> I am sure about this.

I'm afraid you are mistaken. There is a bit of inconsistency in the API,
but it is *not* a requirement to use the port helper for deregistration
here.

> 1. From the implementation,
>     tty_port_register_device -> tty_port_register_device_attr ->
> tty_port_link_device; tty_register_device_attr
>     tty_register_device -> tty_register_device_attr
> 
>     tty_port_unregister_device -> serdev_tty_port_unregister;
> tty_unregister_device
>     tty_unregister_device

>     As to the functionability, tty_port_register_device pairs with
> tty_port_unregister_device; meanwhile, the same to tty_register_device
> and tty_unregister_device.

Again, this is not an explanation. Why do think it is needed? What could
possibly go wrong if you don't change the code like you propose?

> 2. From the function naming style,
> 
>     tty_port_register_device - tty_port_unregister_device;
> tty_register_device - tty_unregister_device

Yes, the naming suggests you should be using the port helper and it is
ok to do so, but again, it is not a requirement (unless you're using the
serdev variant).

> > > Fixes: a6afd9f3e819 ("tty: move a number of tty drivers from drivers/char/ to drivers/tty/")
> >
> > Please try a little harder, that's clearly not the commit that changed
> > to the port registration helper.
> >
> > > Cc: stable@vger.kernel.org
> >
> > Why do you think this is stable material? (hint: it is not)
> 
> From the documentation, this label could make the patch automatically
> go to stable tree. And stable tree is also using the incorrect api.

No, it is not using an "incorrect api". There is nothing wrong with
current code. And it certainly does not need to be changed in stable.

Johan
