Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5F828FF53
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 09:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404764AbgJPHmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 03:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404652AbgJPHmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 03:42:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60802207F7;
        Fri, 16 Oct 2020 07:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602834158;
        bh=VCDudKielD56bgwxNAKXTJeHaYo3e6g1QA0p/gA04Z0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ApILK3pz0sWKjs+3JqSzvPksjXAgp0gzKQhOQ+eReiGQllwaByXdvXhmuuOfc7MGw
         YDOqbEbxLKwEj6D1gAxNdbp2P1yIbOBtY1czwg/oIvHskMc84NweneA/r1aNNwMYVi
         ajTUuG6h0XmdbGIZkD9/1gIIJVqKG0e4rthiuqvU=
Date:   Fri, 16 Oct 2020 09:43:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     Alex Deucher <alexdeucher@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs
 handlers"
Message-ID: <20201016074309.GA852856@kroah.com>
References: <20201014202836.240347-1-alexander.deucher@amd.com>
 <20201015051451.GA405484@kroah.com>
 <MN2PR12MB448853FE73DE3EF2D64BE36CF7020@MN2PR12MB4488.namprd12.prod.outlook.com>
 <20201015140617.GA4039567@kroah.com>
 <MN2PR12MB44881689BB508017AE3174E8F7020@MN2PR12MB4488.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB44881689BB508017AE3174E8F7020@MN2PR12MB4488.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 15, 2020 at 02:11:17PM +0000, Deucher, Alexander wrote:
> [AMD Public Use]
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Thursday, October 15, 2020 10:06 AM
> > To: Deucher, Alexander <Alexander.Deucher@amd.com>
> > Cc: Alex Deucher <alexdeucher@gmail.com>; stable@vger.kernel.org
> > Subject: Re: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm
> > sysfs handlers"
> >
> > On Thu, Oct 15, 2020 at 01:18:34PM +0000, Deucher, Alexander wrote:
> > > [AMD Public Use]
> > >
> > > > -----Original Message-----
> > > > From: Greg KH <gregkh@linuxfoundation.org>
> > > > Sent: Thursday, October 15, 2020 1:15 AM
> > > > To: Alex Deucher <alexdeucher@gmail.com>
> > > > Cc: stable@vger.kernel.org; Deucher, Alexander
> > > > <Alexander.Deucher@amd.com>
> > > > Subject: Re: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm
> > > > sysfs handlers"
> > > >
> > > > On Wed, Oct 14, 2020 at 04:28:36PM -0400, Alex Deucher wrote:
> > > > > This regressed some working configurations so revert it.  Will fix
> > > > > this properly for 5.9 and backport then.
> > > >
> > > > What do you mean "backport then"?
> > > >
> > > > >
> > > > > This reverts commit 38e0c89a19fd13f28d2b4721035160a3e66e270b.
> > > > >
> > > > > This needs to be applied to 5.9 as well.  -next (5.10) has this
> > > > > already, but 5.9 missed it.
> > > >
> > > > What is the real fix for this?  Is it in Linus's tree and I can just
> > > > backport that fix?
> > > >
> > >
> > > This is no real fix.  The revert is the fix.  Sorry, I should have clarified that.
> >
> > Is it also reverted in Linus's tree?  If so, what's that commit id?
> >
> > If not, shouldn't it be?
> 
> It is reverted in Linus' tree.  I cherry-picked the revert from Linus' tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=87004abfbc27261edd15716515d89ab42198b405

Ok, I've queued that one up now, can you also send me versions of this
for the older kernel trees that need it (I think 4.19.y and 5.4.y).

thanks,

greg k-h
