Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125DF183044
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 13:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgCLMc6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 12 Mar 2020 08:32:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:32061 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgCLMc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 08:32:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 05:32:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,544,1574150400"; 
   d="scan'208";a="277783817"
Received: from irsmsx101.ger.corp.intel.com ([163.33.3.153])
  by fmsmga002.fm.intel.com with ESMTP; 12 Mar 2020 05:32:55 -0700
Received: from irsmsx606.ger.corp.intel.com (163.33.146.139) by
 IRSMSX101.ger.corp.intel.com (163.33.3.153) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 12 Mar 2020 12:32:55 +0000
Received: from irsmsx601.ger.corp.intel.com (163.33.146.7) by
 IRSMSX606.ger.corp.intel.com (163.33.146.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Mar 2020 12:32:55 +0000
Received: from irsmsx601.ger.corp.intel.com ([163.33.146.7]) by
 irsmsx601.ger.corp.intel.com ([163.33.146.7]) with mapi id 15.01.1713.004;
 Thu, 12 Mar 2020 12:32:55 +0000
From:   "Mrozek, Michal" <michal.mrozek@intel.com>
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        "Intel-gfx@lists.freedesktop.org" <Intel-gfx@lists.freedesktop.org>
CC:     "Ursulin, Tvrtko" <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3] drm/i915/gen12: Disable preemption timeout
Thread-Topic: [PATCH v3] drm/i915/gen12: Disable preemption timeout
Thread-Index: AQHV+GV3gtM8E/6h2UaUOIIOSXsn3KhE46sw
Date:   Thu, 12 Mar 2020 12:32:54 +0000
Message-ID: <e757df2ebc75465eadb87c775a31f616@intel.com>
References: <20200310162428.4249-1-tvrtko.ursulin@linux.intel.com>
 <20200312115748.29970-1-tvrtko.ursulin@linux.intel.com>
In-Reply-To: <20200312115748.29970-1-tvrtko.ursulin@linux.intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Sent: Thursday, March 12, 2020 12:58 PM
> To: Intel-gfx@lists.freedesktop.org
> Cc: Ursulin, Tvrtko <tvrtko.ursulin@intel.com>; Chris Wilson <chris@chris-
> wilson.co.uk>; Joonas Lahtinen <joonas.lahtinen@linux.intel.com>; Mrozek,
> Michal <michal.mrozek@intel.com>; stable@vger.kernel.org
> Subject: [PATCH v3] drm/i915/gen12: Disable preemption timeout
> 
> From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> 
> Allow super long OpenCL workloads which cannot be preempted within the
> default timeout to run out of the box.
> 
> v2:
>  * Make it stick out more and apply only to RCS. (Chris)
> 
> v3:
>  * Mention platform override in kconfig. (Joonas)
> 
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Michal Mrozek <michal.mrozek@intel.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  drivers/gpu/drm/i915/Kconfig.profile      |  4 ++++
>  drivers/gpu/drm/i915/gt/intel_engine_cs.c | 13 +++++++++----
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/Kconfig.profile
> b/drivers/gpu/drm/i915/Kconfig.profile
> index ba8767fc0d6e..0bfd276c19fe 100644
> --- a/drivers/gpu/drm/i915/Kconfig.profile
> +++ b/drivers/gpu/drm/i915/Kconfig.profile
> @@ -41,6 +41,10 @@ config DRM_I915_PREEMPT_TIMEOUT
> 
>  	  May be 0 to disable the timeout.
> 
> +	  The compiled in default may get overridden at driver probe time on
> +	  certain platforms and certain engines which will be reflected in the
> +	  sysfs control.
> +
>  config DRM_I915_MAX_REQUEST_BUSYWAIT
>  	int "Busywait for request completion limit (ns)"
>  	default 8000 # nanoseconds
> diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> index 8eeec87b7d72..3aa8a652c16d 100644
> --- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> +++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> @@ -275,6 +275,7 @@ static void intel_engine_sanitize_mmio(struct
> intel_engine_cs *engine)  static int intel_engine_setup(struct intel_gt *gt, enum
> intel_engine_id id)  {
>  	const struct engine_info *info = &intel_engines[id];
> +	struct drm_i915_private *i915 = gt->i915;
>  	struct intel_engine_cs *engine;
> 
>  	BUILD_BUG_ON(MAX_ENGINE_CLASS >=
> BIT(GEN11_ENGINE_CLASS_WIDTH)); @@ -301,11 +302,11 @@ static int
> intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
>  	engine->id = id;
>  	engine->legacy_idx = INVALID_ENGINE;
>  	engine->mask = BIT(id);
> -	engine->i915 = gt->i915;
> +	engine->i915 = i915;
>  	engine->gt = gt;
>  	engine->uncore = gt->uncore;
>  	engine->hw_id = engine->guc_id = info->hw_id;
> -	engine->mmio_base = __engine_mmio_base(gt->i915, info-
> >mmio_bases);
> +	engine->mmio_base = __engine_mmio_base(i915, info->mmio_bases);
> 
>  	engine->class = info->class;
>  	engine->instance = info->instance;
> @@ -322,11 +323,15 @@ static int intel_engine_setup(struct intel_gt *gt, enum
> intel_engine_id id)
>  	engine->props.timeslice_duration_ms =
>  		CONFIG_DRM_I915_TIMESLICE_DURATION;
> 
> +	/* Override to uninterruptible for OpenCL workloads. */
> +	if (INTEL_GEN(i915) == 12 && engine->class == RENDER_CLASS)
> +		engine->props.preempt_timeout_ms = 0;
> +
>  	engine->context_size = intel_engine_context_size(gt, engine->class);
>  	if (WARN_ON(engine->context_size > BIT(20)))
>  		engine->context_size = 0;
>  	if (engine->context_size)
> -		DRIVER_CAPS(gt->i915)->has_logical_contexts = true;
> +		DRIVER_CAPS(i915)->has_logical_contexts = true;
> 
>  	/* Nothing to do here, execute in order of dependencies */
>  	engine->schedule = NULL;
> @@ -342,7 +347,7 @@ static int intel_engine_setup(struct intel_gt *gt, enum
> intel_engine_id id)
>  	gt->engine_class[info->class][info->instance] = engine;
>  	gt->engine[id] = engine;
> 
> -	gt->i915->engine[id] = engine;
> +	i915->engine[id] = engine;
> 
>  	return 0;
>  }
> --
> 2.20.1

Acked-by: Michal Mrozek <Michal.mrozek@intel.com>
