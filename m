Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B223A4E6167
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 10:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347265AbiCXJ7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 05:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239661AbiCXJ7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 05:59:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF7C2E0B3
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 02:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648115902; x=1679651902;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=GpKEE2QTesoO89Aioo+z0+/n7ZOxg8pX8kUhvD7a9S0=;
  b=T8M6skPWAbWOGGz3ICa9w8C1qYPj8v/QYu1xuxHKT7PRJQpp2w1HIbc1
   A1P0ehsQKs2rKspvwxhSWiXf6yojMgylT5Tq2sHGDvDVNl1fD2AerXUby
   Q/PTWLN+a3KpltB34wLUxee7rB9850BcNlYMXJShAJeKiCsvhnCoApVsV
   3oUMdL6XQo4QMAShJfSCUZe66IQTIAXJ2+BLN3c6ecvOxSohXiie8K8Do
   94fk8pd9UrcTvhh3OxkWJ/tORvByK64iw9uI/8xKceB2nzPfdScMia7Je
   nk6lfwKZgvckBd19UwybjaUqt+7WStSg/QQZKZIjU6wyhItQbbisbSHmN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="258287780"
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="258287780"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 02:58:21 -0700
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="519719819"
Received: from cnalawad-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.131])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 02:58:19 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org, Shawn C Lee <shawn.c.lee@intel.com>
Subject: Re: [PATCH] drm/edid: fix CEA extension byte #3 parsing
In-Reply-To: <Yjs4E5gl3KZoUOBR@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220323100438.1757295-1-jani.nikula@intel.com>
 <Yjs4E5gl3KZoUOBR@intel.com>
Date:   Thu, 24 Mar 2022 11:58:17 +0200
Message-ID: <87tubnhdty.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Mar 2022, Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com=
> wrote:
> On Wed, Mar 23, 2022 at 12:04:38PM +0200, Jani Nikula wrote:
>> Only an EDID CEA extension has byte #3, while the CTA DisplayID Data
>> Block does not. Don't interpret bogus data for color formats.
>
> I think what we might want eventually is a cleaner split between
> the CTA data blocks vs. the rest of the EDID CTA ext block. Only
> the former is relevant for DisplayID.
>
> But for a bugfix we want to keep it simple.
>
> Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>

Thanks, pushed to drm-misc-next-fixes.

BR,
Jani.

>
>>=20
>> For most displays it's probably an unlikely scenario you'd have a CTA
>> DisplayID Data Block without a CEA extension, but they do exist.
>>=20
>> Fixes: e28ad544f462 ("drm/edid: parse CEA blocks embedded in DisplayID")
>> Cc: <stable@vger.kernel.org> # v4.15
>> Cc: Shawn C Lee <shawn.c.lee@intel.com>
>> Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>>=20
>> ---
>>=20
>> commit e28ad544f462 was merged in v5.3, but it has Cc: stable for v4.15.
>>=20
>> This is also fixed in my CEA data block iteration series [1], but we'll
>> want the simple fix for stable first.
>>=20
>> Hum, CTA is formerly CEA, I and the code seem to use both, should we use
>> only one or the other?
>
> And before CEA it was called EIA (IIRC). Dunno if we also use that name
> somewhere.
>
> If someone cares enough I guess we could rename everything to "cta".
>
>>=20
>> [1] https://patchwork.freedesktop.org/series/101659/
>> ---
>>  drivers/gpu/drm/drm_edid.c | 12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
>> index 561f53831e29..ccf7031a6797 100644
>> --- a/drivers/gpu/drm/drm_edid.c
>> +++ b/drivers/gpu/drm/drm_edid.c
>> @@ -5187,10 +5187,14 @@ static void drm_parse_cea_ext(struct drm_connect=
or *connector,
>>=20=20
>>  	/* The existence of a CEA block should imply RGB support */
>>  	info->color_formats =3D DRM_COLOR_FORMAT_RGB444;
>> -	if (edid_ext[3] & EDID_CEA_YCRCB444)
>> -		info->color_formats |=3D DRM_COLOR_FORMAT_YCBCR444;
>> -	if (edid_ext[3] & EDID_CEA_YCRCB422)
>> -		info->color_formats |=3D DRM_COLOR_FORMAT_YCBCR422;
>> +
>> +	/* CTA DisplayID Data Block does not have byte #3 */
>> +	if (edid_ext[0] =3D=3D CEA_EXT) {
>> +		if (edid_ext[3] & EDID_CEA_YCRCB444)
>> +			info->color_formats |=3D DRM_COLOR_FORMAT_YCBCR444;
>> +		if (edid_ext[3] & EDID_CEA_YCRCB422)
>> +			info->color_formats |=3D DRM_COLOR_FORMAT_YCBCR422;
>> +	}
>>=20=20
>>  	if (cea_db_offsets(edid_ext, &start, &end))
>>  		return;
>> --=20
>> 2.30.2

--=20
Jani Nikula, Intel Open Source Graphics Center
