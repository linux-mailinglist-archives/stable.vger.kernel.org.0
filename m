Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B253B11AD0C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfLKOIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:08:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfLKOIR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 09:08:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01D2E214AF;
        Wed, 11 Dec 2019 14:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576073296;
        bh=MZBtfT7fXxhQeK3c7lypDHBRErGR3tUytR1w7wlcGUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cyTP5hw78CDVv9xCncFjpJOzR+pnlsn4U8/wTucQhW0a5zvMO5y4MKm1zUp01Ymt3
         crmJ0StTJjtfaPGKOsxvOtKo++V7PLwHU1KVmMTEsBgxBbHKGmyPg55VcgrkbL4PwX
         wUdQIJtO7OUJDa1O23HlEhhDWUWIj6yxkP2UNGso=
Date:   Wed, 11 Dec 2019 15:08:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Denys Vlasenko <dvlasenk@redhat.com>
Cc:     rhkernel-list@redhat.com,
        Alex Williamson <alex.williamson@redhat.com>,
        Radomir Vrbovsky <rvrbovsk@redhat.com>,
        "Monroy, Rodrigo Axel" <rodrigo.axel.monroy@intel.com>,
        "Orrala Contreras, Alfredo" <alfredo.orrala.contreras@intel.com>,
        stable@vger.kernel.org, Hang Yuan <hang.yuan@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [RHEL-7.4.z PATCH BZ1739309] drm/i915/gvt: Fix mmap range check
Message-ID: <20191211140814.GA591409@kroah.com>
References: <20191211140154.13425-1-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211140154.13425-1-dvlasenk@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 03:01:54PM +0100, Denys Vlasenko wrote:
> Bugzilla: 1713567
> Z-Bugzilla: 1739309
> CVE: CVE-2019-11085
> Build Info: https://brewweb.engineering.redhat.com/brew/taskinfo?taskID=25302094
> 
> This is a backport of 7.6.z patch to 7.4.z - 7.4.z needs
> intel_vgpu_in_aperture(), so add it.
> 
> 7.6.z patch tested: Win10 VM with assigned Intel vGPU still works
> 
> This is to fix missed mmap range check on vGPU bar2 region
> and only allow to map vGPU allocated GMADDR range, which means
> user space should support sparse mmap to get proper offset for
> mmap vGPU aperture. And this takes care of actual pgoff in mmap
> request as original code always does from beginning of vGPU
> aperture.
> 
> Fixes: 659643f7d814 ("drm/i915/gvt/kvmgt: add vfio/mdev support to KVMGT")
> Cc: "Monroy, Rodrigo Axel" <rodrigo.axel.monroy@intel.com>
> Cc: "Orrala Contreras, Alfredo" <alfredo.orrala.contreras@intel.com>
> Cc: stable@vger.kernel.org # v4.10+
> Reviewed-by: Hang Yuan <hang.yuan@intel.com>
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> (cherry picked from commit 51b00d8509dc69c98740da2ad07308b630d3eb7d)
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)

Come on, isn't there a requirement to know NOT to spam public mailing
lists for internal emails?

:(
