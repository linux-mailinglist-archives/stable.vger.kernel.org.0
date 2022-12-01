Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FED463F044
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 13:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiLAMQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 07:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiLAMQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 07:16:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4B0A555F
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 04:16:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE52261FC5
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 12:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17B2C433D6;
        Thu,  1 Dec 2022 12:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669896974;
        bh=Yu0qtAdUJVuU3Vm1xhyefvXLdqUB/JQpMxUkujkrPk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1rJECEFWCKm8svbZmHnmhCtC0u0ifsWanCeeid4R/ivweW4vFCxZixeD+TGnMbDhP
         46qJWL10T4bzySyuFs+pSffAL0C70FN/ErDmKuIfYOAcbLM4vO2deg5rDjsY7UpLPX
         8cW4C0zr6ZzSEb+GxkonYag192ShEKYYCt71U5UI=
Date:   Thu, 1 Dec 2022 13:16:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     chris.p.wilson@intel.com, daniel.vetter@ffwll.ch,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/i915: fix TLB invalidation for Gen12
 video and compute" failed to apply to 5.15-stable tree
Message-ID: <Y4ibCXKoanYDVU81@kroah.com>
References: <1669831197124193@kroah.com>
 <Y4ebgwSCQPeCPtFY@kroah.com>
 <958bb07e-1cc5-d97b-5480-6d8ce09c27d8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <958bb07e-1cc5-d97b-5480-6d8ce09c27d8@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 11:26:05AM +0100, Andrzej Hajda wrote:
> 
> 
> On 30.11.2022 19:05, Greg KH wrote:
> > On Wed, Nov 30, 2022 at 06:59:57PM +0100, gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 5.15-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > Possible dependencies:
> > > 
> > > 04aa64375f48 ("drm/i915: fix TLB invalidation for Gen12 video and compute engines")
> > > 33da97894758 ("drm/i915/gt: Serialize TLB invalidates with GT resets")
> > > 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
> > > 1176d15f0f6e ("Merge tag 'drm-intel-gt-next-2021-10-08' of git://anongit.freedesktop.org/drm/drm-intel into drm-next")
> > > 
> > Ah, wait, I found the tarball you sent for these, and have taken them
> > for 5.4, 5.10, and 5.15 now (the original broke the build.)  We still
> > need them for older kernels though, that's still an issue.
> 
> Thanks for applying patches.
> Older kernels ( < 5.4) do not have the patch to fix ("drm/i915: Flush TLBs
> before releasing backing store"), and they do not support Gen12 AFAIK,
> so it should be fine.

The Fixes: tag in this commit references a commit that has been
backported into a lot of older kernels:

git id: '7938d61591d33394a21bdd7797a245b65428f44c' is in: 4.4.301 4.9.299 4.14.264 4.19.227 5.4.175 5.10.95 5.15.18 5.16.4 5.17

So is the Fixes tag incorrect?

thanks,

greg k-h
