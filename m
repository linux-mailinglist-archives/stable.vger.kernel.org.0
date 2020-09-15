Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E71269BEB
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 04:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgIOCg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 22:36:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:17151 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbgIOCg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 22:36:27 -0400
IronPort-SDR: aTqJKb0c8P2kAIFi4ZggYv7UalHIiiz3agPyJKLkdoya9NAEYm8EpAW8G4GIgPLZYBL46bgVCS
 8ZJ79nCBH7TQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="220746605"
X-IronPort-AV: E=Sophos;i="5.76,428,1592895600"; 
   d="scan'208";a="220746605"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 19:36:26 -0700
IronPort-SDR: ixB0LMLe/2ZDNWem+DwY/U8D0RVxMd8fTGPmERpyVC99QyqjlTUMfTrLg/PnmZaW+BCEcv+w/K
 CTL4g00vm9sA==
X-IronPort-AV: E=Sophos;i="5.76,428,1592895600"; 
   d="scan'208";a="330989158"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 19:36:25 -0700
Date:   Tue, 15 Sep 2020 10:35:23 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     stable@vger.kernel.org
Cc:     zhenyuw@linux.intel.com, julien@sroos.eu
Subject: Re: [PATCH] drm/i915/gvt: do not check len & max_len for lri
Message-ID: <20200915023522.GA15082@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200811071651.3446-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811071651.3446-1-yan.y.zhao@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ping for backport.

On Tue, Aug 11, 2020 at 03:16:51PM +0800, Yan Zhao wrote:
> hi
> This is the upstream commit dbafc67307ec06036b25b223a251af03fe07969a,
> and we'd like to backport it to v5.4.
> have done the code rebase for the attached patch.
> 
> lri usually of variable len and far exceeding 127 dwords.
> 
> Fixes: 00a33be40634 ("drm/i915/gvt: Add valid length check for MI variable commands")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> Link: http://patchwork.freedesktop.org/patch/msgid/20200304095121.21609-1-yan.y.zhao@intel.com
> ---
>  drivers/gpu/drm/i915/gvt/cmd_parser.c | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/cmd_parser.c b/drivers/gpu/drm/i915/gvt/cmd_parser.c
> index e753b1e706e2..582e28be383c 100644
> --- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
> +++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
> @@ -963,18 +963,6 @@ static int cmd_handler_lri(struct parser_exec_state *s)
>  	int i, ret = 0;
>  	int cmd_len = cmd_length(s);
>  	struct intel_gvt *gvt = s->vgpu->gvt;
> -	u32 valid_len = CMD_LEN(1);
> -
> -	/*
> -	 * Official intel docs are somewhat sloppy , check the definition of
> -	 * MI_LOAD_REGISTER_IMM.
> -	 */
> -	#define MAX_VALID_LEN 127
> -	if ((cmd_len < valid_len) || (cmd_len > MAX_VALID_LEN)) {
> -		gvt_err("len is not valid:  len=%u  valid_len=%u\n",
> -			cmd_len, valid_len);
> -		return -EFAULT;
> -	}
>  
>  	for (i = 1; i < cmd_len; i += 2) {
>  		if (IS_BROADWELL(gvt->dev_priv) && s->ring_id != RCS0) {
> -- 
> 2.17.1
> 
