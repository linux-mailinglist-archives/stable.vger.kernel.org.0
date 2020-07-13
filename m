Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C3821D3AD
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 12:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgGMKUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 06:20:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:25393 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgGMKUD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 06:20:03 -0400
IronPort-SDR: jfRoMmTsVMSo3jSGudG7NmAs5zpMaAcWHbG6qgl/F51FClJYBu62vufCcNvhyAcaTMzzT4VnHF
 OyNaxVi5i3dQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9680"; a="148584123"
X-IronPort-AV: E=Sophos;i="5.75,347,1589266800"; 
   d="scan'208";a="148584123"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 03:20:02 -0700
IronPort-SDR: fGiJdv3yL40M+/PwvDFsAUvrOcMF2Kl8LzIUm9x1KzwKZmfq4EgpN69kY66/dHeOZYZ/0yfnpL
 JxQfO7DF08hQ==
X-IronPort-AV: E=Sophos;i="5.75,347,1589266800"; 
   d="scan'208";a="459242050"
Received: from thoebenx-mobl.ger.corp.intel.com (HELO [10.255.194.109]) ([10.255.194.109])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 03:20:01 -0700
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Ignore irq enabling on the
 virtual engines
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200711203236.12330-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <4d6930b8-80d2-0e74-79fa-9e297beccf26@linux.intel.com>
Date:   Mon, 13 Jul 2020 11:19:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200711203236.12330-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/07/2020 21:32, Chris Wilson wrote:
> We do not use the virtual engines for interrupts (they have physical
> components), but we do use them to decouple the fence signaling during
> submission. Currently, when we submit a completed request, we try to
> enable the interrupt handler for the virtual engine, but we never disarm
> it. A quick fix is then to mark the irq as enabled, and it will then
> remain enabled -- and this prevents us from waking the device and never
> letting it sleep again.
> 
> Fixes: f8db4d051b5e ("drm/i915: Initialise breadcrumb lists on the virtual engine")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.5+
> ---
>   drivers/gpu/drm/i915/gt/intel_lrc.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index cd4262cc96e2..504e269bb166 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -5727,6 +5727,7 @@ intel_execlists_create_virtual(struct intel_engine_cs **siblings,
>   	intel_engine_init_active(&ve->base, ENGINE_VIRTUAL);
>   	intel_engine_init_breadcrumbs(&ve->base);
>   	intel_engine_init_execlists(&ve->base);
> +	ve->base.breadcrumbs.irq_armed = true;

Add a comment here saying this is a hack and why please. With that:

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko

>   
>   	ve->base.cops = &virtual_context_ops;
>   	ve->base.request_alloc = execlists_request_alloc;
> 
