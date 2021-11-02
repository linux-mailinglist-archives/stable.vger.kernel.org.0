Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212044432EB
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 17:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhKBQjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 12:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbhKBQir (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 12:38:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729C8C079780;
        Tue,  2 Nov 2021 09:24:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mhwZu-0002xs-Mh; Tue, 02 Nov 2021 17:24:02 +0100
Date:   Tue, 2 Nov 2021 17:24:02 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>, stable@vger.kernel.org
Subject: Re: Potential problem with VRF+conntrack after kernel upgrade
Message-ID: <20211102162402.GB19266@breakpoint.cc>
References: <1a816689-3960-eb6b-2256-9478265d2d8e@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a816689-3960-eb6b-2256-9478265d2d8e@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:

[ cc stable@ ]

> We experienced a major network outage today when upgrading kernels.
> 
> The affected servers run the VRF+conntrack+nftables combo. They are edge
> firewalls/NAT boxes, meaning most interesting traffic is not locally
> generated, but forwarded.
> 
> What we experienced is NATed traffic in the reply direction never being
> forwarded back to the original client.
> 
> Good kernel: 5.10.40 (debian 5.10.0-0.bpo.7-amd64)
> Bad kernel: 5.10.70 (debian 5.10.0-0.bpo.9-amd64)
> 
> I suspect the problem may be related to this patch:
> https://x-lore.kernel.org/stable/20210824165908.709932-58-sashal@kernel.org/

This commit has been reverted upstream:

55161e67d44fdd23900be166a81e996abd6e3be9
("vrf: Revert "Reset skb conntrack connection...").

Sasha, Greg, it would be good if you could apply this revert to all
stable trees that have a backport of
09e856d54bda5f288ef8437a90ab2b9b3eab83d1
("vrf: Reset skb conntrack connection on VRF rcv").

Arturo, it would be good if you could check current linux.git or
net.git -- those contain the revert + an alternate approach to address
the problem that 09e856d54bda5f288ef8437a90ab2b9b3eab83d1 tried to fix.

If net.git is still broken for your use case it would be great if you
could extend this test script:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20211018123813.17248-1-fw@strlen.de/

this would help to figure out what the issue is.
