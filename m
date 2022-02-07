Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E7F4AC6A8
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 18:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346071AbiBGRAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 12:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391740AbiBGQr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 11:47:58 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48521C0401D5
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 08:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644252478; x=1675788478;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=RoNEdmj3fJhDnp6obfu/M+jqOlEzSacb5uBPv2jSv1s=;
  b=N0RYnErb/yHB5DAs7bZWr8ukQcGJ79kq4OFGVYTW82KpYznj4s+sYrsH
   liaUAOp+YU8iznXJVF5con8T5JWon7Y3RXzv7cp088078cYNdK0u4qiIN
   gG8sfVSWvdRUjTzK/LbzX61DThelIfAqI4YRG6Oct6PCDrz1P/9OZ/MWK
   L5vThpccAnrfW0JZE9jPw4W0ucy4jwBa2ecAe746fgcIfHLFeFxXxHSJM
   3XivtIbTOzYapPAeIg/brPvYOFr34p+YQf8vM8iVqlYtBEh9waAwp+17P
   3FkLY3k3uVPqjKPCEP+++0KQk7hM4LDJ4UxNDu7kYV8DXwTD5+WwfzJgu
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10250"; a="247590795"
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="247590795"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 08:47:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="536263960"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by fmsmga007.fm.intel.com with SMTP; 07 Feb 2022 08:47:56 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 07 Feb 2022 18:47:55 +0200
Date:   Mon, 7 Feb 2022 18:47:55 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/i195: Fix dbuf slice config lookup
Message-ID: <YgFNOzZDOWn7UryH@intel.com>
References: <20220207132700.481-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220207132700.481-1-ville.syrjala@linux.intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 03:26:59PM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Apparently I totally fumbled the loop condition when I
> removed the ARRAY_SIZE() stuff from the dbuf slice config
> lookup. Comparing the loop index with the active_pipes bitmask
> is utter nonsense, what we want to do is check to see if the
> mask is zero or not.
> 
> Cc: stable@vger.kernel.org
> Fixes: 05e8155afe35 ("drm/i915: Use a sentinel to terminate the dbuf slice arrays")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/intel_pm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
> index 02084652fe3d..da721aea70ff 100644
> --- a/drivers/gpu/drm/i915/intel_pm.c
> +++ b/drivers/gpu/drm/i915/intel_pm.c
> @@ -4848,7 +4848,7 @@ static u8 compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus,
>  {
>  	int i;
>  
> -	for (i = 0; i < dbuf_slices[i].active_pipes; i++) {
> +	for (i = 0; dbuf_slices[i].active_pipes != 0; i++) {

Actually looks like the tables just happened to be ordered
the right way that the code never did the wrong thing until
commit eef173954432 ("drm/i915: Allow !join_mbus cases for adlp+
dbuf configuration"). So this just needs backporting alongside
that commit (which I flagged for 5.14+), but no crucial need to
backport further than that.

-- 
Ville Syrjälä
Intel
