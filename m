Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895061EAE50
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgFASw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:52:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:14845 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730089AbgFASwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:52:53 -0400
IronPort-SDR: f+K7HZdqaFA43dTBzfTm3gsWcbNCMOIR9sVCG1WnWjbUj33Jv0G44VBRYzofbo3nkQKD0kfWJN
 wVZwkYvr0vvQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2020 11:25:46 -0700
IronPort-SDR: xHkGQRrBic1IX0OqorcGrzrH+KJtjLIRqQ4CApsfreBrvBnwcs9qM33Xr+OWDiPY3EgTOEx6YZ
 GKR2eznzqfcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,461,1583222400"; 
   d="scan'208";a="303974099"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by orsmga008.jf.intel.com with ESMTP; 01 Jun 2020 11:25:45 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 7B6025C2C42; Mon,  1 Jun 2020 21:23:17 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Whitelist context-local timestamp in the gen9 cmdparser
In-Reply-To: <20200601161942.30854-1-chris@chris-wilson.co.uk>
References: <20200601161942.30854-1-chris@chris-wilson.co.uk>
Date:   Mon, 01 Jun 2020 21:23:17 +0300
Message-ID: <87d06iir1m.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> Allow batch buffers to read their own _local_ cumulative HW runtime of
> their logical context.
>
> Fixes: 0f2f39758341 ("drm/i915: Add gen9 BCS cmdparsing")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.4+

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/i915_cmd_parser.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
> index 189b573d02be..372354d33f55 100644
> --- a/drivers/gpu/drm/i915/i915_cmd_parser.c
> +++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
> @@ -572,6 +572,9 @@ struct drm_i915_reg_descriptor {
>  #define REG32(_reg, ...) \
>  	{ .addr = (_reg), __VA_ARGS__ }
>  
> +#define REG32_IDX(_reg, idx) \
> +	{ .addr = _reg(idx) }
> +
>  /*
>   * Convenience macro for adding 64-bit registers.
>   *
> @@ -669,6 +672,7 @@ static const struct drm_i915_reg_descriptor gen9_blt_regs[] = {
>  	REG64_IDX(RING_TIMESTAMP, BSD_RING_BASE),
>  	REG32(BCS_SWCTRL),
>  	REG64_IDX(RING_TIMESTAMP, BLT_RING_BASE),
> +	REG32_IDX(RING_CTX_TIMESTAMP, BLT_RING_BASE),
>  	REG64_IDX(BCS_GPR, 0),
>  	REG64_IDX(BCS_GPR, 1),
>  	REG64_IDX(BCS_GPR, 2),
> -- 
> 2.20.1
