Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA70B23E2A5
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 21:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgHFT4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 15:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgHFT4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 15:56:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC0512173E;
        Thu,  6 Aug 2020 19:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596743810;
        bh=hTLw5ILiv66vXjziu/wz3b7OS2jZ1a120WnIytyZ+eY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mnHQ3cuDtvkhWsN/eoxq0jfiWLkvUeuynBMipXGyCVmNeLp4wWjqlSiU8Q/NBgFDJ
         yAVFwSR9IVaN5A/B0JUvjzSuB/DR+sGBJMasCKYvRJz+eyGSgJw6sMyAVq0E+Uzeq+
         26EImv3CnwNWZGRDfvyIfariYWpauP3cmcHdGfMM=
Date:   Thu, 6 Aug 2020 21:57:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Matthias Maennich <maennich@google.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        YueHaibing <yuehaibing@huawei.com>, jeyu@kernel.org,
        cocci@systeme.lip6.fr, stable@vger.kernel.org
Subject: Re: [PATCH] scripts: add dummy report mode to add_namespace.cocci
Message-ID: <20200806195704.GA2950037@kroah.com>
References: <20200604164145.173925-1-maennich@google.com>
 <alpine.DEB.2.21.2006042130080.2577@hadrien>
 <bf757b9d-6a67-598b-ed6e-7ee24464abfa@linuxfoundation.org>
 <20200622080345.GD260206@google.com>
 <0eda607e-4083-46d2-acb8-63cfa2697a71@linuxfoundation.org>
 <20200622150605.GA3828014@kroah.com>
 <f09e32dc-8f17-d09a-b2e4-fb4c0699838e@linuxfoundation.org>
 <baf80622-0860-e640-eb14-dffc02597ed3@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <baf80622-0860-e640-eb14-dffc02597ed3@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 01:48:26PM -0600, Shuah Khan wrote:
> On 6/22/20 10:14 AM, Shuah Khan wrote:
> > On 6/22/20 9:06 AM, Greg Kroah-Hartman wrote:
> > > On Mon, Jun 22, 2020 at 08:46:18AM -0600, Shuah Khan wrote:
> > > > On 6/22/20 2:03 AM, Matthias Maennich wrote:
> > > > > On Thu, Jun 04, 2020 at 02:39:18PM -0600, Shuah Khan wrote:
> > > > > > On 6/4/20 1:31 PM, Julia Lawall wrote:
> > > > > > > 
> > > > > > > 
> > > > > > > On Thu, 4 Jun 2020, Matthias Maennich wrote:
> > > > > > > 
> > > > > > > > When running `make coccicheck` in report mode using the
> > > > > > > > add_namespace.cocci file, it will fail for files that contain
> > > > > > > > MODULE_LICENSE. Those match the replacement precondition, but spatch
> > > > > > > > errors out as virtual.ns is not set.
> > > > > > > > 
> > > > > > > > In order to fix that, add the virtual rule nsdeps and only
> > > > > > > > do search and
> > > > > > > > replace if that rule has been explicitly requested.
> > > > > > > > 
> > > > > > > > In order to make spatch happy in report mode, we also need a
> > > > > > > > dummy rule,
> > > > > > > > as otherwise it errors out with "No rules
> > > > > > > > apply". Using a script:python
> > > > > > > > rule appears unrelated and odd, but this is the shortest I
> > > > > > > > could come up
> > > > > > > > with.
> > > > > > > > 
> > > > > > > > Adjust scripts/nsdeps accordingly to set the nsdeps rule
> > > > > > > > when run trough
> > > > > > > > `make nsdeps`.
> > > > > > > > 
> > > > > > > > Suggested-by: Julia Lawall <julia.lawall@inria.fr>
> > > > > > > > Fixes: c7c4e29fb5a4 ("scripts: add_namespace:
> > > > > > > > Fix coccicheck failed")
> > > > > > > > Cc: YueHaibing <yuehaibing@huawei.com>
> > > > > > > > Cc: jeyu@kernel.org
> > > > > > > > Cc: cocci@systeme.lip6.fr
> > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > Signed-off-by: Matthias Maennich <maennich@google.com>
> > > > > > > 
> > > > > > > Acked-by: Julia Lawall <julia.lawall@inria.fr>
> > > > > > > 
> > > > > > > Shuah reported the problem to me, so you could add
> > > > > > > 
> > > > > > > Reported-by: Shuah Khan <skhan@linuxfoundation.org>
> > > > > > > 
> > > > > > 
> > > > > > Very cool. No errors with this patch. Thanks for fixing it
> > > > > > quickly.
> > > > > 
> > > > > I am happy I could fix that and thanks for confirming. I assume your
> > > > > Tested-by could be added?
> > > > 
> > > > Yes
> > > > 
> > > > Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> > > > > 
> > > > > Is somebody willing to take this patch through their tree?
> > > > > 
> > > > 
> > > > My guess is that these go through kbuild git??
> > > 
> > > If you want to take this, that's fine with me.  But as I had the
> > > original file come through my tree, I can take it too.  It's up to you,
> > > either is ok with me.
> > > 
> > 
> > Great. Please take this through your tree.
> > 
> 
> Greg! Looks like this one didn't make it in. Can you pick this up?

I think this is 55c7549819e4 ("scripts: add dummy report mode to
add_namespace.cocci") in Linus's tree right now, right?

thanks,

greg k-h
