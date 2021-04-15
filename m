Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D67535FF5F
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 03:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbhDOBZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 21:25:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:40894 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhDOBZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 21:25:08 -0400
IronPort-SDR: NcwXokULmbWC23VDPr5qBju/kiqBIZD73OJupuPWIx7CVQuVe+NXbgzIgzujr72L3ArXpue7gM
 Um6XrFjFMjpQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="181896442"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="181896442"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 18:24:45 -0700
IronPort-SDR: TxnicHQOd+kPI+s4yQ1CNdFrc+jrklN7YEqFIsXwGXdPYrWK0qKXAHGJU5fkCeD1GbZIsb0vt4
 n7mWZRiNuXOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="389581652"
Received: from unknown (HELO coxu-arch-shz) ([10.239.160.30])
  by fmsmga007.fm.intel.com with ESMTP; 14 Apr 2021 18:24:43 -0700
Date:   Thu, 15 Apr 2021 09:24:43 +0800 (CST)
From:   Colin Xu <colin.xu@intel.com>
X-X-Sender: coxu_arch@coxu-arch-shz
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
cc:     intel-gvt-dev@lists.freedesktop.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/i915/gvt: Fix BDW command parser regression
In-Reply-To: <20210414084813.3763353-1-zhenyuw@linux.intel.com>
Message-ID: <alpine.LNX.2.22.419.2104150922140.5599@coxu-arch-shz>
References: <20210414084813.3763353-1-zhenyuw@linux.intel.com>
User-Agent: Alpine 2.22 (LNX 419 2020-04-12)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Apr 2021, Zhenyu Wang wrote:

> On BDW new Windows driver has brought extra registers to handle for
> LRM/LRR command in WA ctx. Add allowed registers in cmd parser for BDW.
>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: stable@vger.kernel.org
> Fixes: 73a37a43d1b0 ("drm/i915/gvt: filter cmds "lrr-src" and "lrr-dst" in cmd_handler")
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> ---
> drivers/gpu/drm/i915/gvt/cmd_parser.c | 19 +++++++++++++------
> 1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gvt/cmd_parser.c b/drivers/gpu/drm/i915/gvt/cmd_parser.c
> index fef1e857cefc..01c1d1b36acd 100644
> --- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
> +++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
> @@ -916,19 +916,26 @@ static int cmd_reg_handler(struct parser_exec_state *s,
>
> 	if (!strncmp(cmd, "srm", 3) ||
> 			!strncmp(cmd, "lrm", 3)) {
> -		if (offset != i915_mmio_reg_offset(GEN8_L3SQCREG4) &&
> -				offset != 0x21f0) {
> +		if (offset == i915_mmio_reg_offset(GEN8_L3SQCREG4) ||
> +		    offset == 0x21f0 ||
> +		    (IS_BROADWELL(gvt->gt->i915) &&
> +		     offset == i915_mmio_reg_offset(INSTPM)))
> +			return 0;
> +		else {
> 			gvt_vgpu_err("%s access to register (%x)\n",
> 					cmd, offset);
> 			return -EPERM;
> -		} else
> -			return 0;
> +		}
> 	}
>
> 	if (!strncmp(cmd, "lrr-src", 7) ||
> 			!strncmp(cmd, "lrr-dst", 7)) {
> -		gvt_vgpu_err("not allowed cmd %s\n", cmd);
> -		return -EPERM;
> +		if (IS_BROADWELL(gvt->gt->i915) && offset == 0x215c)
> +			return 0;
> +		else {
> +			gvt_vgpu_err("not allowed cmd %s reg (%x)\n", cmd, offset);
> +			return -EPERM;
> +		}
> 	}
>
> 	if (!strncmp(cmd, "pipe_ctrl", 9)) {
> -- 
> 2.31.0
>
> _______________________________________________
> intel-gvt-dev mailing list
> intel-gvt-dev@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev
>

Reviewed-by: Colin Xu <colin.xu@intel.com>

Thanks for the timely fix for BDW!
