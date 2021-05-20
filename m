Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F0E38B1DB
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 16:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhETOjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 10:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231310AbhETOjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 10:39:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB19561059;
        Thu, 20 May 2021 14:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621521511;
        bh=xvpCtCufiEHwVLoZrZUuCzovi/WhEqwFryl/dyaGESA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E5gNo0AkzwIQ49Zjqpf5rcBKCtOPZK07+e4coH0+oL9opWwb9iA2fsGVuOPCkbw/1
         nmAnUjbr6H4V+kW15Ly4QbTVTb/JCFUkGSZrdMWDadrDGQgcK0yV1UkW9X76twSM9h
         MCmxtRnTBJTCAdWzcAdyPR+r0tLVO+s3ZZ4fbDpQ=
Date:   Thu, 20 May 2021 16:38:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Joerg M. Sigle" <joerg.sigle@jsigle.com>
Cc:     stable@vger.kernel.org
Subject: Re: To Greg KH: Re: [PATCH] iommu/vt-d: Fix kernel panic caused by
 416fa531c816: Preset Access/Dirty bits for IOVA over FL
Message-ID: <YKZ0ZROJ+alWpuvF@kroah.com>
References: <d3fa9eed-98bf-a137-5b0d-c6e992848f76@jsigle.com>
 <4a3c08af-6f6f-ac84-7c98-46529f96fefc@jsigle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a3c08af-6f6f-ac84-7c98-46529f96fefc@jsigle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 04:05:51PM +0200, Joerg M. Sigle wrote:
> From: Joerg M. Sigle <joerg.sigle@jsigle.com>

Odd subject line, what happened?

> 
> Patch 416fa531c816 commit 416fa531c8160151090206a51b829b9218b804d9 caused
> an immediate kernel panic on boot at RIP: 0010:__domain_mapping+0xa7/0x3a0
> with longterm kernel 5.10.37 configured w/ CONFIG_INTEL_IOMMU_DEFAULT_ON=y
> due to removal of a check. Putting the check back in place fixes this.
> The kernel panic was observed on various Intel Core i7 i5 i3 CPUs from
> Sandy Bridge, Haswell, Broadwell and Kaby Lake generations (at least).
> It may NOT be reproducible on some older CPU generations.
> Suppressing the panic with boot parameter intel_iommu=off is diagnostic.
> See: https://bugzilla.kernel.org/show_bug.cgi?id=213077
> https://bugzilla.kernel.org/show_bug.cgi?id=213087
> https://bugzilla.kernel.org/show_bug.cgi?id=213095
> 
> Signed-off-by: Joerg M. Sigle <joerg.sigle@jsigle.com>
> Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
> 
> ---
> 
> Hi Greg, thanks for your response.
> 
> > Are you sure that 5.10.38 doesn't already fix this issue?  We resolved
> > an issue in this area.
> 
> Yes, I'm sure.

Did you test 5.10.38?

> 
> Your a282b76166b13496967c70bd61ea8f03609d8a76 simply reverts the offending patch.

Yes, and then the next commit in the series applied it back in a
different form, hopefully "fixed up" correctly.

> My approach corrects it instead.

How so?  It does not apply to 5.10.38.  Nor to 5.10.39-rc1.

> I have submitted that properly before, don't know why it hasn't found you yet.

Where on lore.kernel.org is it shown?

> I'm including the "proper" submission info above.
> The file with the patch is attached again again.

That's not how to submit patches, take a look at the kernel documentaion
for all that we need.

But again, are you sure this is needed?  If so, can you make it against
5.10.39-rc1?

thanks,

greg k-h
