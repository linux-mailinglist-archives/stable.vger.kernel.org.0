Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15FC844401
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfFMQe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbfFMHw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 03:52:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF9A92084D;
        Thu, 13 Jun 2019 07:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560412378;
        bh=ErpOgk7fEhPiiO2mVcvQu8m8IvLTzaheOWgRyHzLtC8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Awdw8CPafTqx/hFkTbl8DsUSJN+xtq3Q1DW63w6WGQG5eI6ABRhoL+GP2RhRoWrat
         Xc/+kL5na5U8sy62o6hL5QmiIHs/qW/mKleFhUBUFzKgpd1Ll5VE/2XVL7NNPDRnUa
         nMrzUmULOTqwvfbCBfuXoQCtQ02JlI2ueiZKIwnI=
Date:   Thu, 13 Jun 2019 09:52:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     stable@vger.kernel.org, linux@endlessm.com, hui.wang@canonical.com
Subject: Re: [PATCH stable-5.1 0/3] drm/i915: Prevent screen from flickering
 when the CDCLK changes
Message-ID: <20190613075256.GF19685@kroah.com>
References: <20190603100938.5414-1-jian-hong@endlessm.com>
 <20190610060141.5377-1-jian-hong@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190610060141.5377-1-jian-hong@endlessm.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 02:01:39PM +0800, Jian-Hong Pan wrote:
> Hi,
> 
> After apply the commit "drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio
> power is enabled", it induces the screen to flicker when the CDCLK changes on
> the laptop like ASUS E406MA. [1]
> 
> So, we need these commits to prevent that:
> commit 48d9f87ddd21 drm/i915: Save the old CDCLK atomic state
> commit 2b21dfbeee72 drm/i915: Remove redundant store of logical CDCLK state
> commit 59f9e9cab3a1 drm/i915: Skip modeset for cdclk changes if possible
> 
> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=203623#c12
> 
> Jian-Hong Pan
> 
> Imre Deak (2):
>   drm/i915: Save the old CDCLK atomic state
>   drm/i915: Remove redundant store of logical CDCLK state
> 
> Ville Syrjälä (1):
>   drm/i915: Skip modeset for cdclk changes if possible
> 
>  drivers/gpu/drm/i915/i915_drv.h      |   3 +-
>  drivers/gpu/drm/i915/intel_cdclk.c   | 155 ++++++++++++++++++++++-----
>  drivers/gpu/drm/i915/intel_display.c |  48 +++++++--
>  drivers/gpu/drm/i915/intel_drv.h     |  18 +++-
>  4 files changed, 186 insertions(+), 38 deletions(-)

These are all big patches, I would like to get an ack from the i915
developer(s) that these are acceptable for the stable tree before
applying them...

thanks,

greg k-h
