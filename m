Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FB72A1709
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgJaLt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbgJaLt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:49:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 561112065D;
        Sat, 31 Oct 2020 11:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144996;
        bh=Q2e7Ko9ET+1NPh3lETNZ9+vZbIea68+XoQuQ4cdBmDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vl/XQQF0hJ9H2fQ5zrvEnJFQDHfN51RW9AQrYjREucRXIBbgTc96lAJYj7NT9sXSX
         HzD3fOJrGtVGReidsS4avJBBkBZtUBsCzX9SVSOANaMJfXpR5xhiQmqyUHCYbj+5y1
         qE3YN56Tauf82jvt1SYjqyCmimteTT6NisbSUFNI=
Date:   Sat, 31 Oct 2020 12:42:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        CQ Tang <cq.tang@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 5.4 40/49] drm/i915/gem: Serialise debugfs
 i915_gem_objects with ctx->mutex
Message-ID: <20201031114248.GA2073275@kroah.com>
References: <20201031113455.439684970@linuxfoundation.org>
 <20201031113457.373067458@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031113457.373067458@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 12:35:36PM +0100, Greg Kroah-Hartman wrote:
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> commit 4fe9af8e881d946bf60790eeb37a7c4f96e28382 upstream.
> 
> Since the debugfs may peek into the GEM contexts as the corresponding
> client/fd is being closed, we may try and follow a dangling pointer.
> However, the context closure itself is serialised with the ctx->mutex,
> so if we hold that mutex as we inspect the state coupled in the context,
> we know the pointers within the context are stable and will remain valid
> as we inspect their tables.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: CQ Tang <cq.tang@intel.com>
> Cc: Daniel Vetter <daniel.vetter@intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20200723172119.17649-3-chris@chris-wilson.co.uk
> (cherry picked from commit 102f5aa491f262c818e607fc4fee08a724a76c69)
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/gpu/drm/i915/i915_debugfs.c |    2 ++
>  1 file changed, 2 insertions(+)

Oops, nope, this breaks the build here, now dropping it...

greg k-h
