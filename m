Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A954A86F7
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 15:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiBCOuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 09:50:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43412 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbiBCOuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 09:50:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75C42619C6;
        Thu,  3 Feb 2022 14:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE68C340E4;
        Thu,  3 Feb 2022 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643899812;
        bh=7MDECds9QpxDlqutr57lbHfsV1URAtMrvTd5Dui61QQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=opyzAxcspWn1X0KXrhQA96t45ZHa62uep+6WrrQB3y1cMYJIa1B7Ly0xzy/NRGrNa
         3K/z9a3aWuXS9Ov1oH3lxT8gCIUqRmehMOR9V86IOrc2myHoNj5iTvZOuZplC7kAfy
         F81avDqIG7tccSNaRbe9C7PX9NyZ8YR5pHlRA2PE=
Date:   Thu, 3 Feb 2022 15:50:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH 5.16 138/200] mptcp: keep track of local endpoint still
 available for each msk
Message-ID: <YfvropKkErsrkhzl@kroah.com>
References: <20220131105233.561926043@linuxfoundation.org>
 <20220131105238.198209212@linuxfoundation.org>
 <26d216d1-355-e132-a868-529f15c9b660@linux.intel.com>
 <YflD6pbqi/EGPG3f@kroah.com>
 <YflEd6+5rdsfKojI@kroah.com>
 <7c25c17-84d5-82ee-6d3-6b2482c939b2@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c25c17-84d5-82ee-6d3-6b2482c939b2@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 02:23:55PM -0800, Mat Martineau wrote:
> On Tue, 1 Feb 2022, Greg Kroah-Hartman wrote:
> 
> > On Tue, Feb 01, 2022 at 03:30:02PM +0100, Greg Kroah-Hartman wrote:
> > > On Mon, Jan 31, 2022 at 11:36:32AM -0800, Mat Martineau wrote:
> > > > On Mon, 31 Jan 2022, Greg Kroah-Hartman wrote:
> > > > 
> > > > > From: Paolo Abeni <pabeni@redhat.com>
> > > > > 
> > > > > [ Upstream commit 86e39e04482b0aadf3ee3ed5fcf2d63816559d36 ]
> > > > 
> > > > Hi Greg -
> > > > 
> > > > Please drop this from the stable queue for both 5.16 and 5.15. It wasn't
> > > > intended for backporting and we haven't checked for dependencies with other
> > > > changes in this part of MPTCP subsystem.
> > > > 
> > > > In the mptcp tree we make sure to add Fixes: tags on every patch we think is
> > > > eligible for the -stable tree. I know you're sifting through a lot of
> > > > patches from subsystems that end up with important fixes arriving from the
> > > > "-next" branches, and it seems like the scripts scooped up several MPTCP
> > > > patches this time around that don't meet the -stable rules.
> > > 
> > > I think these were needed due to 8e9eacad7ec7 ("mptcp: fix msk traversal
> > > in mptcp_nl_cmd_set_flags()") which you did tag with a "Fixes:" tag,
> > > right?  Without these other commits, that one does not apply and it
> > > looks like it should go into 5.15.y and 5.16.y.
> > > 
> 
> Ok, I see what happened there (there's a new variable present in 5.17 that's
> not relevant for the earlier kernels). 8e9eacad7ec7 needs manual
> backporting, I'll work on that and send to the stable list.
> 
> > > Note, just putting a "Fixes:" tag does not guarantee if a commit
> > > will go into a stable tree.  Please use the correct
> > > "Cc:stable@vger.kernel.org" tag as the documentation asks for.
> > > 
> 
> I will make sure to use the Cc:stable@vger.kernel.org tag in the future.
> 
> 
> > > I'll go drop all of these mptcp patches, including 8e9eacad7ec7 ("mptcp:
> > > fix msk traversal in mptcp_nl_cmd_set_flags()") for now.  If you want
> > > them added back in, please let us know.
> > 
> > To be specific, I have dropped the following commits from the queues
> > now, which was more than just these three that you asked:
> > 
> > 602837e8479d ("mptcp: allow changing the "backup" bit by endpoint id")
> > 59060a47ca50 ("mptcp: clean up harmless false expressions")
> > 86e39e04482b ("mptcp: keep track of local endpoint still available for each msk")
> > 8e9eacad7ec7 ("mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()")
> > a4c0214fbee9 ("mptcp: fix removing ids bitmap setting")
> > 9846921dba49 ("selftests: mptcp: fix ipv6 routing setup")
> > 
> > If you want them back, please let us know.
> > 
> 
> Of the above, there's only one suitable for stable as-is:
> 
> 9846921dba49 ("selftests: mptcp: fix ipv6 routing setup")
> 
> Please add that one to the 5.16 and 5.15 queues.

Now queued up, thanks.

greg k-h
