Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA193317275
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 22:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhBJVhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 16:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:56626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233097AbhBJVg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 16:36:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F374A64DD6;
        Wed, 10 Feb 2021 21:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612992978;
        bh=8/iQqCFp3uQ57lkielDRJ0nDpWhNDeLQmdENd46C96w=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=F836RUntz0IBDKngDQbq6aGEQziWb/MAEhkCht/Gs3AfcWs9QpJkpcpu53XnqB76L
         26FFqUSFoVsm8s6oxtIMezKKdXHeSnYV5S+0VpaGOOzlckdja727xfnz9yYK9sxraD
         XYawRZLigDxevf/m9gUmB710mGxhIT8kfHLFfSkySNkfjdxjR97Wq+mMKMGjw6MT1v
         M6rUbgSmP1guhdUywccceiXEVQ5Gas/RR6CBDjZK3i7pwjL2CPpeWTBRwCUmbSuxm+
         uVDXTzIs/zdj4f9sECXYyjcBVZwsgfnRJCQ03JlBNwTRX+XGCUgOugvP2l5Dm/ha1W
         l7ilAWpbCkwXg==
Date:   Wed, 10 Feb 2021 13:36:17 -0800 (PST)
From:   Stefano Stabellini <sstabellini@kernel.org>
X-X-Sender: sstabellini@sstabellini-ThinkPad-T480s
To:     "Woodhouse, David" <dwmw@amazon.co.uk>
cc:     "julien@xen.org" <julien@xen.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iwj@xenproject.org" <iwj@xenproject.org>,
        "Grall, Julien" <jgrall@amazon.co.uk>
Subject: Re: [PATCH] arm/xen: Don't probe xenbus as part of an early
 initcall
In-Reply-To: <7858866d099732baf56e395a627f610968d24a7d.camel@amazon.co.uk>
Message-ID: <alpine.DEB.2.21.2102101335590.7114@sstabellini-ThinkPad-T480s>
References: <20210210170654.5377-1-julien@xen.org> <7858866d099732baf56e395a627f610968d24a7d.camel@amazon.co.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Feb 2021, Woodhouse, David wrote:
> On Wed, 2021-02-10 at 17:06 +0000, Julien Grall wrote:
> > From: Julien Grall <jgrall@amazon.com>
> > 
> > After Commit 3499ba8198cad ("xen: Fix event channel callback via
> > INTX/GSI"), xenbus_probe() will be called too early on Arm. This will
> > recent to a guest hang during boot.
> > 
> > If there hang wasn't there, we would have ended up to call
> > xenbus_probe() twice (the second time is in xenbus_probe_initcall()).
> > 
> > We don't need to initialize xenbus_probe() early for Arm guest.
> > Therefore, the call in xen_guest_init() is now removed.
> > 
> > After this change, there is no more external caller for xenbus_probe().
> > So the function is turned to a static one. Interestingly there were two
> > prototypes for it.
> > 
> > Fixes: 3499ba8198cad ("xen: Fix event channel callback via INTX/GSI")
> > Reported-by: Ian Jackson <iwj@xenproject.org>
> > Signed-off-by: Julien Grall <jgrall@amazon.com>
> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> Cc: stable@vger.kernel.org

Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
