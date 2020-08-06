Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77A223DEE0
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgHFRdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729891AbgHFRcF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 13:32:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B218C23105;
        Thu,  6 Aug 2020 14:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596725061;
        bh=E95cVZz1kZmYgQvozvQIvX6d9sYlP/p5sA+n/8nxaZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=diInIpATfbYcs2/AKyzNe4XmDCTQ/l8PzvghBx7FLd2FjF6HDtViPWJXxzPe8yxix
         yo3ClYUPlRuYCcOrmiIux+2RUd8JEy+JnOdOx4D8eS4z5teHfXkXOCyJKWBDDStZwj
         10ihxJtCATfefOIvDRGzwlD2JgL0oKIqARLTRHO0=
Date:   Thu, 6 Aug 2020 16:44:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     "for 3.8" <stable@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: Re: [PATCH] drm/amdgpu: fix ordering of psp suspend
Message-ID: <20200806144435.GB2891564@kroah.com>
References: <20200805215700.451808-1-alexander.deucher@amd.com>
 <20200806070103.GC2582961@kroah.com>
 <CADnq5_N0P8S5X4bqsavjNJ5KgZUKN=3cDrigiH=W8-3PiEv49w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_N0P8S5X4bqsavjNJ5KgZUKN=3cDrigiH=W8-3PiEv49w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 09:42:51AM -0400, Alex Deucher wrote:
> On Thu, Aug 6, 2020 at 7:10 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Aug 05, 2020 at 05:57:00PM -0400, Alex Deucher wrote:
> > > The ordering of psp_tmr_terminate() and psp_asd_unload()
> > > got reversed when the patches were applied to stable.
> > >
> > > Fixes: 22ff658396b446 ("drm/amdgpu: asd function needs to be unloaded in suspend phase")
> > > Fixes: 2c41c968c6f648 ("drm/amdgpu: add TMR destory function for psp")
> > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > Cc: stable@vger.kernel.org # 5.7.x
> > > Cc: Huang Rui <ray.huang@amd.com>
> > > ---
> > >  drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > What is the git commit id of this patch in Linus's tree?
> 
> It doesn't exist in Linus' tree.  The order is correct in 5.8 and
> newer.  The order got reversed when the patches were applied to
> stable.

Than this needs to be explicitly called out and documented in the patch,
otherwise we have no idea what is going on...

thanks,

greg k-h
