Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C463A974A
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 12:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhFPKbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 06:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232048AbhFPKbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 06:31:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96F4A60FE6;
        Wed, 16 Jun 2021 10:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623839349;
        bh=Z0UNEV6qSxs/ADJyTpVCdlAObn8GbfeoX2RCiE/Gv2g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oU+OxzvxmmwL10TJBoqn1VVSEX0vaisVNjzKh5YrHI/qu7atXiSVG2AiIEv+OBUUf
         LRln0CqIsVc9mG+0PRKLeFPWJNYCJHYLIpgCJ7yjXfMXA1YJS7sJE+KL1/xOxnKZz4
         7q9sCPTngsDTlrnaNSWWIPQsoYs6m5vksC11lVIg=
Date:   Wed, 16 Jun 2021 12:29:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Amit Klein' <aksecurity@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID
 generation
Message-ID: <YMnScmBeZRzi3APe@kroah.com>
References: <20210512144743.039977287@linuxfoundation.org>
 <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
 <YMmlPHMn/+EPdbvm@kroah.com>
 <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
 <a388a8018b09429d93a4a6b6852c70b2@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a388a8018b09429d93a4a6b6852c70b2@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 10:19:15AM +0000, David Laight wrote:
> From: Amit Klein
> > Sent: 16 June 2021 10:17
> ...
> > -#define IP_IDENTS_SZ 2048u
> > -
> > +/* Hash tables of size 2048..262144 depending on RAM size.
> > + * Each bucket uses 8 bytes.
> > + */
> > +static u32 ip_idents_mask __read_mostly;
> ...
> > +    /* For modern hosts, this will use 2 MB of memory */
> > +    idents_hash = alloc_large_system_hash("IP idents",
> > +                          sizeof(*ip_idents) + sizeof(*ip_tstamps),
> > +                          0,
> > +                          16, /* one bucket per 64 KB */
> > +                          HASH_ZERO,
> > +                          NULL,
> > +                          &ip_idents_mask,
> > +                          2048,
> > +                          256*1024);
> > +
> 
> Can someone explain why this is a good idea for a 'normal' system?
> 
> Why should my desktop system 'waste' 2MB of memory on a massive
> hash table that I don't need.
> It might be needed by systems than handle massive numbers
> of concurrent connections - but that isn't 'most systems'.
> 
> Surely it would be better to detect when the number of entries
> is comparable to the table size and then resize the table.

Patches always gladly accepted.
