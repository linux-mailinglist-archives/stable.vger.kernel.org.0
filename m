Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947644E550C
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 16:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237569AbiCWPV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 11:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiCWPV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 11:21:27 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81937654AE
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 08:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648048797; x=1679584797;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=SMBdZmZ570mnLhiMI9IlFDQAXa8938kaiujy1I1l7bs=;
  b=Xc83UlYlZS9vbqD7XLQvaNOqapKpqVj6oUn2CBSjQ058CmFVqJs0R6xt
   uETo9byq62eu7XQL0qOedht8ncg9wFEjb/6MtdyzvqVfuVt6XSQTRC3WX
   6Hf3KujQumSplfFWEgOCWkE5LCOcdsEd7BDR605cOLzWgBpK1hbOHDLaa
   r5D1cGP6VP+0J0UYqTdd0rKPxNQ7WuEj96woSvozTu85Wo1bL9stSx3k2
   gvzZUUq6eGyEMej5WoNdAe8Hf6JI/neaO3lQPi9pYaxMdiBmBO1Un61bA
   ebDt+aO62RqkmydbXFYw2BfMZWRsWW1tnuXyeKkF3sZKSTmG3Vs6z5jdc
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="238737914"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="238737914"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 08:19:57 -0700
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="544231903"
Received: from caliyanx-mobl.gar.corp.intel.com (HELO localhost) ([10.252.57.47])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 08:19:55 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org, Shawn C Lee <shawn.c.lee@intel.com>
Subject: Re: [PATCH] drm/edid: fix CEA extension byte #3 parsing
In-Reply-To: <Yjs4E5gl3KZoUOBR@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220323100438.1757295-1-jani.nikula@intel.com>
 <Yjs4E5gl3KZoUOBR@intel.com>
Date:   Wed, 23 Mar 2022 17:19:52 +0200
Message-ID: <87fsn8itlz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

Well, I just abstracted it all away in the CEA data block iteration
series [1].

It'll be possible to add a different iteration initializer depending on
what you want to iterate and where.

BR,
Jani.


>
> But for a bugfix we want to keep it simple.
>
> Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
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
