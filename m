Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98166691D52
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 11:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjBJKyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 05:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbjBJKyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 05:54:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4928B212A1
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 02:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676026456; x=1707562456;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=AqOM13J9VRPclf+hYsuTaxcBQktb1KPvyl1aqw26wok=;
  b=Siz8jNzpeYIJvAaGlB6IxdFeO+L1l9XtjsvfPjoHN34WMSke8fi15P1/
   CdRzwdTnfE5u1EIc60IqYEN6nKykx5czNAvxJIxlYU0KwQxKP0Dh9fEKy
   icE9k3HGerXXiW8l8H1QhyN4my4Uo7D4sCCdPV7trXD58kLs3N5M2w6zU
   FOHza3Wdbg38lQ3vxL8KtPEjDNtGfjUz3xnNx4Dca53/LJ9OHnZNJTqN4
   Ee1MMW/w7JTbKphY48sKVlyagvkQClFerNXJcOtuDd0vx3X8o0r7CgNqT
   T2yv0cPR5outUHyBUSZU7sxSqj1WIaX2HXmdiZtXC9kZ2jUGlD+HBiS19
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="394996940"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="394996940"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 02:54:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="645594214"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="645594214"
Received: from myegin-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.38.74])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 02:54:12 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Jim Cromie <jim.cromie@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: Re: [PATCH] drm: Disable dynamic debug as broken
In-Reply-To: <Y+KOszHLodcTx9Sr@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20230207143337.2126678-1-jani.nikula@intel.com>
 <Y+KOszHLodcTx9Sr@kroah.com>
Date:   Fri, 10 Feb 2023 12:54:09 +0200
Message-ID: <878rh5x032.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 07 Feb 2023, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Tue, Feb 07, 2023 at 04:33:37PM +0200, Jani Nikula wrote:
>> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>>=20
>> CONFIG_DRM_USE_DYNAMIC_DEBUG breaks debug prints for (at least modular)
>> drm drivers. The debug prints can be reinstated by manually frobbing
>> /sys/module/drm/parameters/debug after the fact, but at that point the
>> damage is done and all debugs from driver probe are lost. This makes
>> drivers totally undebuggable.
>>=20
>> There's a more complete fix in progress [1], with further details, but
>> we need this fixed in stable kernels. Mark the feature as broken and
>> disable it by default, with hopes distros follow suit and disable it as
>> well.
>>=20
>> [1] https://lore.kernel.org/r/20230125203743.564009-1-jim.cromie@gmail.c=
om
>>=20
>> Fixes: 84ec67288c10 ("drm_print: wrap drm_*_dbg in dyndbg descriptor fac=
tory macro")
>> Cc: Jim Cromie <jim.cromie@gmail.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>> Cc: Maxime Ripard <mripard@kernel.org>
>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Daniel Vetter <daniel@ffwll.ch>
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: <stable@vger.kernel.org> # v6.1+
>> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> ---
>>  drivers/gpu/drm/Kconfig | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
>> index f42d4c6a19f2..dc0f94f02a82 100644
>> --- a/drivers/gpu/drm/Kconfig
>> +++ b/drivers/gpu/drm/Kconfig
>> @@ -52,7 +52,8 @@ config DRM_DEBUG_MM
>>=20=20
>>  config DRM_USE_DYNAMIC_DEBUG
>>  	bool "use dynamic debug to implement drm.debug"
>> -	default y
>> +	default n
>> +	depends on BROKEN
>>  	depends on DRM
>>  	depends on DYNAMIC_DEBUG || DYNAMIC_DEBUG_CORE
>>  	depends on JUMP_LABEL
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks Greg, any more acks from anyone?

Maxime, since there's going to be an -rc8, I suggest taking this via
drm-misc-fixes. Is that okay with you? (You're doing drm-misc-fixes this
round, right?)

BR,
Jani.


--=20
Jani Nikula, Intel Open Source Graphics Center
