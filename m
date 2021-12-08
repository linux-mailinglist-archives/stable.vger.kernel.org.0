Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A21446D3DD
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhLHNBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 08:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbhLHNBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 08:01:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED16C061746
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 04:57:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C5662CE214F
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 12:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649D4C00446;
        Wed,  8 Dec 2021 12:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968266;
        bh=YHPRMh2uk2L6Q46EC366cfowe+lnQgevaxpyPayvDT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jgfF2gTrRXMNY17qYCUZ8V9UrPzDxWCMVqdfgpNc/Dvxnp0LDEAsBI0iGRZKAhujv
         lvUPBXi15iwRUzVGli2uRipOVp/Gnk3VFtr5rAX76AXnZo0I4s0/cgChO/kVrsrxog
         QSjdthFjoWiUUHANcfJaTl+pqe+sF+WYiKQTEd3I=
Date:   Wed, 8 Dec 2021 13:57:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lyude Paul <lyude@redhat.com>
Cc:     rodrigo.vivi@intel.com, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Subject: Re: FAILED: patch "[PATCH] drm/i915: Add support for panels with
 VESA backlights with" failed to apply to 5.15-stable tree
Message-ID: <YbCrx22nKTboVF/M@kroah.com>
References: <16387074612176@kroah.com>
 <390babb7a9b7e27a9edbc909a4ea5bf6bf256da3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <390babb7a9b7e27a9edbc909a4ea5bf6bf256da3.camel@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 06:23:49PM -0500, Lyude Paul wrote:
> Huh, well this is strange. I'm assuming that you send these emails out as part
> of an automated script that tries applying patches and fails, but I think
> something may have gone wrong here as I just tried cherry-picking
> 04f0d6cc62cc1eaf9242c081520c024a17ba86a3 onto v5.15.6, and it applied without
> needing any manual conflict resolution. Any idea what might be going on?

You mean 61e29a0956bd ("drm/i915: Add support for panels with VESA
backlights with PWM enable/disable"), right?

Anyway, yes, it fails to build:

  CC [M]  drivers/gpu/drm/i915/display/intel_dp_aux_backlight.o
drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c: In function ‘intel_dp_aux_vesa_enable_backlight’:
drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c:302:33: error: implicit declaration of function ‘intel_backlight_invert_pwm_level’; did you mean ‘intel_panel_invert_pwm_level’? [-Werror=implicit-function-declaration]
  302 |                 u32 pwm_level = intel_backlight_invert_pwm_level(connector,
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                 intel_panel_invert_pwm_level
cc1: all warnings being treated as errors

thanks,

greg k-h
