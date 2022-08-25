Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04185A14C9
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 16:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiHYOsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 10:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240693AbiHYOsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 10:48:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEEAB2860
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 07:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661438892; x=1692974892;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=Bxcfj15EA4On+ZizYl/NclYUnSWZECFeKGUNGdK+YL8=;
  b=jlRx7C3kBfYmdffdcSLxSHwwcnc3lCewAOGpxCfDtHDwP8LtQnTxYdgN
   9Ocs/wwiY7HZ8WRxyZ3bCLUEPb7TtMcCU1OkxYjpku4IfY1wRHtTndKTK
   JwXZCrAGNkaBlJh25+S58gV4fXYffcNcuOOyby4FSYiwEQjH6m+0hKRFQ
   UuoS7BBiwzECFD3nnY4B6HKQaaPyAyY61Hd1DUQJhFbk+kPQE1kyVVzay
   ghgYtUhjKDXM3Fl7CrX9t2D27707hhxkZA99BWpkOaYhEt+f/w+oP2LjJ
   z29+4TOdIWH+KUtJJ/oLAiCCh5Tz2rEIL78/Hfe87h1iRkRklTPnLvupd
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="292998000"
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="292998000"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 07:48:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="678485667"
Received: from jnikula-mobl4.fi.intel.com (HELO localhost) ([10.237.66.149])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 07:48:10 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Diego Santa Cruz <Diego.SantaCruz@spinetix.com>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/glk: ECS Liva Q2 needs GLK HDMI
 port timing quirk
In-Reply-To: <Ywdd+7ifzC7AknS7@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220616124137.3184371-1-jani.nikula@intel.com>
 <Ywdd+7ifzC7AknS7@intel.com>
Date:   Thu, 25 Aug 2022 17:48:07 +0300
Message-ID: <87sflkgz14.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Aug 2022, Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com=
> wrote:
> On Thu, Jun 16, 2022 at 03:41:37PM +0300, Jani Nikula wrote:
>> From: Diego Santa Cruz <Diego.SantaCruz@spinetix.com>
>>=20
>> The quirk added in upstream commit 90c3e2198777 ("drm/i915/glk: Add
>> Quirk for GLK NUC HDMI port issues.") is also required on the ECS Liva
>> Q2.
>>=20
>> Note: Would be nicer to figure out the extra delay required for the
>> retimer without quirks, however don't know how to check for that.
>>=20
>> Cc: stable@vger.kernel.org
>> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1326
>> Signed-off-by: Diego Santa Cruz <Diego.SantaCruz@spinetix.com>
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>
> Seems fine. Although I do wonder whether we could directly identify the
> bogus retimer chip via the dual mode adapter registers. I've asked for
> that in the bug.
>
> Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>

Thanks, pushed to drm-intel-next. Let's follow up with cleanups if the
folks in the bug ever reply.

BR,
Jani.

>
>> ---
>>  drivers/gpu/drm/i915/display/intel_quirks.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>=20
>> diff --git a/drivers/gpu/drm/i915/display/intel_quirks.c b/drivers/gpu/d=
rm/i915/display/intel_quirks.c
>> index c8488f5ebd04..e415cd7c0b84 100644
>> --- a/drivers/gpu/drm/i915/display/intel_quirks.c
>> +++ b/drivers/gpu/drm/i915/display/intel_quirks.c
>> @@ -191,6 +191,9 @@ static struct intel_quirk intel_quirks[] =3D {
>>  	/* ASRock ITX*/
>>  	{ 0x3185, 0x1849, 0x2212, quirk_increase_ddi_disabled_time },
>>  	{ 0x3184, 0x1849, 0x2212, quirk_increase_ddi_disabled_time },
>> +	/* ECS Liva Q2 */
>> +	{ 0x3185, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
>> +	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
>>  };
>>=20=20
>>  void intel_init_quirks(struct drm_i915_private *i915)
>> --=20
>> 2.30.2

--=20
Jani Nikula, Intel Open Source Graphics Center
