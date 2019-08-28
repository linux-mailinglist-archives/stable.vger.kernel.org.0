Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338C0A0997
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 20:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfH1SfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 14:35:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbfH1SfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 14:35:13 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DA357882F2
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 18:35:12 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id l64so941180qkb.5
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 11:35:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=8hkCC+6RH1+I9XJYQP9KXoRyFfXCsCu2bKOzDa8PS88=;
        b=O3AuhQd7ecnZGs2DbKqDpx2WIL+WDqkxLaz3xEFoJ3Qmt5nJHPzhid/EqxUoIYNajk
         qyyGQOnNs6fZlR8zPHvusulDUFcKAPMSkeaDgUfEQKgQp5hq5Hg0PH0q2oPIbuCrKG6J
         spoo57t26sRYZAnvAhAFM3NxtT2wEltJW29KR5MBVHbX7zHjHDeH1VlpYol3HdDqW1rG
         7xBt1fE152jdS9e6DMZs1xbkVBc+xLQTGJ2mcgmU0E+3lQyWeFLR2+l4UlFoIQHL+mvh
         FDZe0BEImkJ9bJHurQXO9eyjKZLHGaunMkrtLsrwrAdg8KNWqnfTNHgqscxBUz7SyOwI
         oTBA==
X-Gm-Message-State: APjAAAXq6QmTvaPQYXn/AdxH/EZ8lx3wdNzkF30RVkqCyDVU2UEozusl
        gseUfCxXDUwvdRKf0hyEOa8ZDvE4NWc1BFtwsZlsJNJgK3kXZwG+MrK94kBc+MO6NbHW7YMrUg3
        Fi0ommo4A5QAw08co
X-Received: by 2002:a05:620a:12ca:: with SMTP id e10mr5385452qkl.125.1567017311911;
        Wed, 28 Aug 2019 11:35:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz7ND/gqvozXNHQF0iDa00e2Qalk9m406iRqhKzLGxN4k/iFpd/mKGIdU7I/ZXi5V7innUWBg==
X-Received: by 2002:a05:620a:12ca:: with SMTP id e10mr5385430qkl.125.1567017311648;
        Wed, 28 Aug 2019 11:35:11 -0700 (PDT)
Received: from dhcp-10-20-1-11.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id y1sm4929qti.49.2019.08.28.11.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 11:35:10 -0700 (PDT)
Message-ID: <1557c35b2c9293034003f1ab34e1280920b09655.camel@redhat.com>
Subject: Re: [PATCH] drm/i915: Limit MST to <= 8bpc once again
From:   Lyude Paul <lyude@redhat.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Geoffrey Bennett <gmux22@gmail.com>
Date:   Wed, 28 Aug 2019 14:35:09 -0400
In-Reply-To: <20190828102059.2512-1-ville.syrjala@linux.intel.com>
References: <20190828102059.2512-1-ville.syrjala@linux.intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Lyude Paul <lyude@redhat.com>

On Wed, 2019-08-28 at 13:20 +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> My attempt at allowing MST to use the higher color depths has
> regressed some configurations. Apparently people have setups
> where all MST streams will fit into the DP link with 8bpc but
> won't fit with higher color depths.
> 
> What we really should be doing is reducing the bpc for all the
> streams on the same link until they start to fit. But that requires
> a bit more work, so in the meantime let's revert back closer to
> the old behavior and limit MST to at most 8bpc.
> 
> Cc: stable@vger.kernel.org
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Geoffrey Bennett <gmux22@gmail.com>
> Fixes: f1477219869c ("drm/i915: Remove the 8bpc shackles from DP MST")
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111505
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_dp_mst.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> index 2c5ac3dd647f..6df240a01b8c 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> @@ -128,7 +128,15 @@ static int intel_dp_mst_compute_config(struct
> intel_encoder *encoder,
>  	limits.max_lane_count = intel_dp_max_lane_count(intel_dp);
>  
>  	limits.min_bpp = intel_dp_min_bpp(pipe_config);
> -	limits.max_bpp = pipe_config->pipe_bpp;
> +	/*
> +	 * FIXME: If all the streams can't fit into the link with
> +	 * their current pipe_bpp we should reduce pipe_bpp across
> +	 * the board until things start to fit. Until then we
> +	 * limit to <= 8bpc since that's what was hardcoded for all
> +	 * MST streams previously. This hack should be removed once
> +	 * we have the proper retry logic in place.
> +	 */
> +	limits.max_bpp = min(pipe_config->pipe_bpp, 24);
>  
>  	intel_dp_adjust_compliance_config(intel_dp, pipe_config, &limits);
>  
-- 
Cheers,
	Lyude Paul

