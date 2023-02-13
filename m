Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E077694D1A
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 17:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjBMQno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 11:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBMQnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 11:43:43 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07945DBD5
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 08:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676306623; x=1707842623;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=0n+HIBdxHdzt277lPdNmpKc0Tu1vAbJdNbPGnkpCCNw=;
  b=PPyPCrgi7wjuL8rhJ8/icbAKgLDCaUKQcgzoIsFVGgXi/ve7k1dbeIy/
   ytJn8RtM19yV2pqaC3JxRVEj4tknIb1ZGzZuSoAUm2KBmxJ4mPNjUv4KD
   RIOUUr+mzlxgIZAVkrJ5UkPXov92TqEliGFGyojzr2wVWzPTUYU4btBrJ
   t8j6zfE5AaNx3Aj/xhJt++LXNZ+rypdxpk11DyhuYvPuPTgAovIhLhOrr
   3oBh2qKEHnJMpXVav8uxTLW8nJ45kLKTfC/eJb20PlMCNGc2jvd5/bHRq
   A7dRvMAHjRrZTnKx8mupnTT7AOhnBDrmkxZoMQqWn9EwrUfkm3iz7dw68
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="318953356"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="318953356"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 08:43:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701329108"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="701329108"
Received: from tkatila-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.147])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 08:43:38 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Jim Cromie <jim.cromie@gmail.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        stable@vger.kernel.org, David Airlie <airlied@gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm: Disable dynamic debug as broken
In-Reply-To: <878rh5x032.fsf@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20230207143337.2126678-1-jani.nikula@intel.com>
 <Y+KOszHLodcTx9Sr@kroah.com> <878rh5x032.fsf@intel.com>
Date:   Mon, 13 Feb 2023 18:43:31 +0200
Message-ID: <875yc5v7m4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Feb 2023, Jani Nikula <jani.nikula@intel.com> wrote:
> On Tue, 07 Feb 2023, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrot=
e:
>> On Tue, Feb 07, 2023 at 04:33:37PM +0200, Jani Nikula wrote:
>>> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>>>=20
>>> CONFIG_DRM_USE_DYNAMIC_DEBUG breaks debug prints for (at least modular)
>>> drm drivers. The debug prints can be reinstated by manually frobbing
>>> /sys/module/drm/parameters/debug after the fact, but at that point the
>>> damage is done and all debugs from driver probe are lost. This makes
>>> drivers totally undebuggable.
>>>=20
>>> There's a more complete fix in progress [1], with further details, but
>>> we need this fixed in stable kernels. Mark the feature as broken and
>>> disable it by default, with hopes distros follow suit and disable it as
>>> well.
>>>=20
>>> [1] https://lore.kernel.org/r/20230125203743.564009-1-jim.cromie@gmail.=
com
>>>=20
>>> Fixes: 84ec67288c10 ("drm_print: wrap drm_*_dbg in dyndbg descriptor fa=
ctory macro")
>>> Cc: Jim Cromie <jim.cromie@gmail.com>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>>> Cc: Maxime Ripard <mripard@kernel.org>
>>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
>>> Cc: David Airlie <airlied@gmail.com>
>>> Cc: Daniel Vetter <daniel@ffwll.ch>
>>> Cc: dri-devel@lists.freedesktop.org
>>> Cc: <stable@vger.kernel.org> # v6.1+
>>> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>>> ---
>>>  drivers/gpu/drm/Kconfig | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
>>> index f42d4c6a19f2..dc0f94f02a82 100644
>>> --- a/drivers/gpu/drm/Kconfig
>>> +++ b/drivers/gpu/drm/Kconfig
>>> @@ -52,7 +52,8 @@ config DRM_DEBUG_MM
>>>=20=20
>>>  config DRM_USE_DYNAMIC_DEBUG
>>>  	bool "use dynamic debug to implement drm.debug"
>>> -	default y
>>> +	default n
>>> +	depends on BROKEN
>>>  	depends on DRM
>>>  	depends on DYNAMIC_DEBUG || DYNAMIC_DEBUG_CORE
>>>  	depends on JUMP_LABEL
>>
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Thanks Greg, any more acks from anyone?
>
> Maxime, since there's going to be an -rc8, I suggest taking this via
> drm-misc-fixes. Is that okay with you? (You're doing drm-misc-fixes this
> round, right?)

Pushed to drm-misc-fixes with Maxime's IRC ack and Jim's ack elsewhere
in the thread. Thanks.

BR,
Jani.


>
> BR,
> Jani.

--=20
Jani Nikula, Intel Open Source Graphics Center
