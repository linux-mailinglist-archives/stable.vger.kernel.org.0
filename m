Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBD3443F7F
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 10:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhKCJop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 05:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231278AbhKCJop (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 05:44:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F2946023E;
        Wed,  3 Nov 2021 09:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635932529;
        bh=1h2VN8LrKMjwSkdkZ0SH9Vpr4P3HWT71CwT/3GqYsqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k8AapTAja/J+tv7rG/kDJkitc7tyibOCGzCf6ACWzKd/NRYZS6BMz/koclSp3zTYG
         FDLOBsiWM7DrOJ0tbRkME1Ay/wDAqXhUtX9zdlWjCKNyZS7t9z9kbIK5Gw2PVYmeyc
         SS/8xdTe4bQusboFXyoUCzSeZJHPOHl3qeZJ3bZg=
Date:   Wed, 3 Nov 2021 10:42:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>, stable@vger.kernel.org
Subject: Re: Potential problem with VRF+conntrack after kernel upgrade
Message-ID: <YYJZbE/8HRje+0eT@kroah.com>
References: <1a816689-3960-eb6b-2256-9478265d2d8e@netfilter.org>
 <20211102162402.GB19266@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102162402.GB19266@breakpoint.cc>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 02, 2021 at 05:24:02PM +0100, Florian Westphal wrote:
> Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:
> 
> [ cc stable@ ]
> 
> > We experienced a major network outage today when upgrading kernels.
> > 
> > The affected servers run the VRF+conntrack+nftables combo. They are edge
> > firewalls/NAT boxes, meaning most interesting traffic is not locally
> > generated, but forwarded.
> > 
> > What we experienced is NATed traffic in the reply direction never being
> > forwarded back to the original client.
> > 
> > Good kernel: 5.10.40 (debian 5.10.0-0.bpo.7-amd64)
> > Bad kernel: 5.10.70 (debian 5.10.0-0.bpo.9-amd64)
> > 
> > I suspect the problem may be related to this patch:
> > https://x-lore.kernel.org/stable/20210824165908.709932-58-sashal@kernel.org/
> 
> This commit has been reverted upstream:
> 
> 55161e67d44fdd23900be166a81e996abd6e3be9
> ("vrf: Revert "Reset skb conntrack connection...").
> 
> Sasha, Greg, it would be good if you could apply this revert to all
> stable trees that have a backport of
> 09e856d54bda5f288ef8437a90ab2b9b3eab83d1
> ("vrf: Reset skb conntrack connection on VRF rcv").

Now reverted, thanks.

greg k-h
