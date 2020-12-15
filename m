Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01452DB626
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 22:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgLOVvs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 15 Dec 2020 16:51:48 -0500
Received: from mga07.intel.com ([134.134.136.100]:25460 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729920AbgLOVvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 16:51:42 -0500
IronPort-SDR: zyaRk/CvN+1A4TtdfMq3UZPjHXB+eRU80nWdna4capArFYZou+UrVRjYo/dT21Q2Gjk9oXQzmO
 YqV54HrDUMsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="239056056"
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="239056056"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 13:50:55 -0800
IronPort-SDR: hqM5EeESLg84gwPnKM4DQvb52gKJ0XJEMKkMb9b9b58E42vxikOFC4ieb3UdUbBCz59Yd3OvUY
 OGnbig/Xfnaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="385599985"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga002.fm.intel.com with ESMTP; 15 Dec 2020 13:50:54 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Dec 2020 13:50:54 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Dec 2020 13:50:54 -0800
Received: from fmsmsx611.amr.corp.intel.com ([10.18.126.91]) by
 fmsmsx611.amr.corp.intel.com ([10.18.126.91]) with mapi id 15.01.1713.004;
 Tue, 15 Dec 2020 13:50:54 -0800
From:   "Tang, CQ" <cq.tang@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drm/i915: Fix mismatch between misplaced vma check and
 vma insert
Thread-Topic: [PATCH] drm/i915: Fix mismatch between misplaced vma check and
 vma insert
Thread-Index: AQHW0yFaZRo6vG6Mak+aWPfGnGQ8fqn4shPA
Date:   Tue, 15 Dec 2020 21:50:53 +0000
Message-ID: <3e4fe0b2533e48d19d78f3a4752b6508@intel.com>
References: <20201215203111.650-1-chris@chris-wilson.co.uk>
In-Reply-To: <20201215203111.650-1-chris@chris-wilson.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Chris Wilson <chris@chris-wilson.co.uk>
> Sent: Tuesday, December 15, 2020 12:31 PM
> To: intel-gfx@lists.freedesktop.org
> Cc: Chris Wilson <chris@chris-wilson.co.uk>; Tang, CQ <cq.tang@intel.com>;
> stable@vger.kernel.org
> Subject: [PATCH] drm/i915: Fix mismatch between misplaced vma check and
> vma insert
> 
> When inserting a VMA, we restrict the placement to the low 4G unless the
> caller opts into using the full range. This was done to allow usersapce the
> opportunity to transition slowly from a 32b address space, and to avoid
> breaking inherent 32b assumptions of some commands.
> 
> However, for insert we limited ourselves to 4G-4K, but on verification we
> allowed the full 4G. This causes some attempts to bind a new buffer to
> sporadically fail with -ENOSPC, but at other times be bound successfully.
> 
> commit 48ea1e32c39d ("drm/i915/gen9: Set PIN_ZONE_4G end to 4GB - 1
> page") suggests that there is a genuine problem with stateless addressing
> that cannot utilize the last page in 4G and so we purposefully excluded it.
> 
> Reported-by: CQ Tang <cq.tang@intel.com>
> Fixes: 48ea1e32c39d ("drm/i915/gen9: Set PIN_ZONE_4G end to 4GB - 1
> page")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: CQ Tang <cq.tang@intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> index 193996144c84..2ff32daa50bd 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> @@ -382,7 +382,7 @@ eb_vma_misplaced(const struct
> drm_i915_gem_exec_object2 *entry,
>  		return true;
> 
>  	if (!(flags & EXEC_OBJECT_SUPPORTS_48B_ADDRESS) &&
> -	    (vma->node.start + vma->node.size - 1) >> 32)
> +	    (vma->node.start + vma->node.size + 4095) >> 32)

Why 4095 not 4096?

--CQ

>  		return true;
> 
>  	if (flags & __EXEC_OBJECT_NEEDS_MAP &&
> --
> 2.20.1

