Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCA0411C95
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346389AbhITRLK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Sep 2021 13:11:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:44361 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346719AbhITRI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:08:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10113"; a="308729698"
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="308729698"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 09:55:41 -0700
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="548864149"
Received: from svandens-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.216.120])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 09:55:37 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Lukasz Majczak <lma@semihalf.com>,
        Jose Roberto de Souza <jose.souza@intel.com>,
        Shawn C Lee <shawn.c.lee@intel.com>
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        upstream@semihalf.com, Lukasz Majczak <lma@semihalf.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] drm/i915/bdb: Fix version check
In-Reply-To: <20210920141101.194959-1-lma@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20210920141101.194959-1-lma@semihalf.com>
Date:   Mon, 20 Sep 2021 19:55:33 +0300
Message-ID: <87y27rtce2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sep 2021, Lukasz Majczak <lma@semihalf.com> wrote:
> With patch "drm/i915/vbt: Fix backlight parsing for VBT 234+"
> the size of bdb_lfp_backlight_data structure has been increased,
> causing if-statement in the parse_lfp_backlight function
> that comapres this structure size to the one retrieved from BDB,
> always to fail for older revisions.
> This patch fixes it by comparing a total size of all fileds from
> the structure (present before the change) with the value gathered from BDB.
> Tested on Chromebook Pixelbook (Nocturne) (reports bdb->version = 221)
>
> Cc: <stable@vger.kernel.org> # 5.4+

Not a review of the patch, I'll leave that to José, but 5.4 is not
right.

The commit is d381baad29b4 ("drm/i915/vbt: Fix backlight parsing for VBT
234+") which was merged in v5.11 and AFAICT has not been backported to
any stable kernel.

So this would be:

Fixes: d381baad29b4 ("drm/i915/vbt: Fix backlight parsing for VBT 234+")
Cc: <stable@vger.kernel.org> # v5.11+

BR,
Jani.




> Tested-by: Lukasz Majczak <lma@semihalf.com>
> Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> ---
>  drivers/gpu/drm/i915/display/intel_bios.c     | 4 +++-
>  drivers/gpu/drm/i915/display/intel_vbt_defs.h | 5 +++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
> index 3c25926092de..052a19b455d1 100644
> --- a/drivers/gpu/drm/i915/display/intel_bios.c
> +++ b/drivers/gpu/drm/i915/display/intel_bios.c
> @@ -452,7 +452,9 @@ parse_lfp_backlight(struct drm_i915_private *i915,
>  
>  	i915->vbt.backlight.type = INTEL_BACKLIGHT_DISPLAY_DDI;
>  	if (bdb->version >= 191 &&
> -	    get_blocksize(backlight_data) >= sizeof(*backlight_data)) {
> +	    get_blocksize(backlight_data) >= (sizeof(backlight_data->entry_size) +
> +					      sizeof(backlight_data->data) +
> +					      sizeof(backlight_data->level))) {
>  		const struct lfp_backlight_control_method *method;
>  
>  		method = &backlight_data->backlight_control[panel_type];
> diff --git a/drivers/gpu/drm/i915/display/intel_vbt_defs.h b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
> index 330077c2e588..fff456bf8783 100644
> --- a/drivers/gpu/drm/i915/display/intel_vbt_defs.h
> +++ b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
> @@ -814,6 +814,11 @@ struct lfp_brightness_level {
>  	u16 reserved;
>  } __packed;
>  
> +/*
> + * Changing struct bdb_lfp_backlight_data might affect its
> + * size comparation to the value hold in BDB.
> + * (e.g. in parse_lfp_backlight())
> + */
>  struct bdb_lfp_backlight_data {
>  	u8 entry_size;
>  	struct lfp_backlight_data_entry data[16];

-- 
Jani Nikula, Intel Open Source Graphics Center
