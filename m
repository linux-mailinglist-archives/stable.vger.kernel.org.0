Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C66A203A43
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 17:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgFVPGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 11:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729210AbgFVPGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 11:06:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E33C20716;
        Mon, 22 Jun 2020 15:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592838370;
        bh=Y4CpcF3aADqh+pQXARrCx9IJmnrlUGPWQkgvA0aXDAs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CCKP6Iy/aswRA9wgZNXlyp1WDg4SxZykY40qDUqdWQ4gzZq2As5ych8GHMpMYeVRn
         vp8p82C2iMFPP/Nsj5p36r9VTQiYvjYk0bySbR85IDLrIXhgCEiIH/HtvN590bOGl6
         b+MoH2N2jQ5ovfnlZZ908qs7t34AhELPRyWPTkTY=
Date:   Mon, 22 Jun 2020 17:06:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Matthias Maennich <maennich@google.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        YueHaibing <yuehaibing@huawei.com>, jeyu@kernel.org,
        cocci@systeme.lip6.fr, stable@vger.kernel.org
Subject: Re: [PATCH] scripts: add dummy report mode to add_namespace.cocci
Message-ID: <20200622150605.GA3828014@kroah.com>
References: <20200604164145.173925-1-maennich@google.com>
 <alpine.DEB.2.21.2006042130080.2577@hadrien>
 <bf757b9d-6a67-598b-ed6e-7ee24464abfa@linuxfoundation.org>
 <20200622080345.GD260206@google.com>
 <0eda607e-4083-46d2-acb8-63cfa2697a71@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0eda607e-4083-46d2-acb8-63cfa2697a71@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 08:46:18AM -0600, Shuah Khan wrote:
> On 6/22/20 2:03 AM, Matthias Maennich wrote:
> > On Thu, Jun 04, 2020 at 02:39:18PM -0600, Shuah Khan wrote:
> > > On 6/4/20 1:31 PM, Julia Lawall wrote:
> > > > 
> > > > 
> > > > On Thu, 4 Jun 2020, Matthias Maennich wrote:
> > > > 
> > > > > When running `make coccicheck` in report mode using the
> > > > > add_namespace.cocci file, it will fail for files that contain
> > > > > MODULE_LICENSE. Those match the replacement precondition, but spatch
> > > > > errors out as virtual.ns is not set.
> > > > > 
> > > > > In order to fix that, add the virtual rule nsdeps and only
> > > > > do search and
> > > > > replace if that rule has been explicitly requested.
> > > > > 
> > > > > In order to make spatch happy in report mode, we also need a
> > > > > dummy rule,
> > > > > as otherwise it errors out with "No rules apply". Using a script:python
> > > > > rule appears unrelated and odd, but this is the shortest I
> > > > > could come up
> > > > > with.
> > > > > 
> > > > > Adjust scripts/nsdeps accordingly to set the nsdeps rule
> > > > > when run trough
> > > > > `make nsdeps`.
> > > > > 
> > > > > Suggested-by: Julia Lawall <julia.lawall@inria.fr>
> > > > > Fixes: c7c4e29fb5a4 ("scripts: add_namespace: Fix coccicheck failed")
> > > > > Cc: YueHaibing <yuehaibing@huawei.com>
> > > > > Cc: jeyu@kernel.org
> > > > > Cc: cocci@systeme.lip6.fr
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Matthias Maennich <maennich@google.com>
> > > > 
> > > > Acked-by: Julia Lawall <julia.lawall@inria.fr>
> > > > 
> > > > Shuah reported the problem to me, so you could add
> > > > 
> > > > Reported-by: Shuah Khan <skhan@linuxfoundation.org>
> > > > 
> > > 
> > > Very cool. No errors with this patch. Thanks for fixing it
> > > quickly.
> > 
> > I am happy I could fix that and thanks for confirming. I assume your
> > Tested-by could be added?
> 
> Yes
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> > 
> > Is somebody willing to take this patch through their tree?
> > 
> 
> My guess is that these go through kbuild git??

If you want to take this, that's fine with me.  But as I had the
original file come through my tree, I can take it too.  It's up to you,
either is ok with me.

thanks

greg k-h
