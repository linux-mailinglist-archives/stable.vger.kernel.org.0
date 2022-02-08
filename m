Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A244ADADD
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 15:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbiBHOKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 09:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbiBHOKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 09:10:54 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD84CC03FECE
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 06:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644329453; x=1675865453;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=E1K+sHYbK65H5t95EPLiCLfu64EIAFVb2ZZ4GzT2YH0=;
  b=Z+pPqcJJS1H7fpQpiha8JWPKDKvdAnhOIqBnyrueWissTSMiz6ZtMiiW
   gMuFcUep2vrt6jcVYALZG5s8Fcwpg4kqxesFsCpxB/jBjJhtWzCDmEs1i
   smrTeyc+DojIgcL/VBe6TzpR7vckLetAfxQte0/t/hdom5j1VKipoEll+
   xxnuSaQFVZf+O5AdAEgIH6+Re/p+rBB0q7jAa9ulZlL4J4pgLnoPKENyo
   BSA+zGUc+HZCfA8sDRNa/QZOS0sFsC/Hn8fo42BnVQ3EucTVqPf5jCaDc
   PjReM0KDz6iAURzHn3C3URaFcS0CFhwyXguWP7Bf/8GLFiVfmysG4dpU4
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="228922830"
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="228922830"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 06:10:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="525561121"
Received: from ijbeckin-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.19.63])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 06:10:51 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915: Fix mbus join config lookup
In-Reply-To: <20220207132700.481-2-ville.syrjala@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220207132700.481-1-ville.syrjala@linux.intel.com>
 <20220207132700.481-2-ville.syrjala@linux.intel.com>
Date:   Tue, 08 Feb 2022 16:10:49 +0200
Message-ID: <875yppqwie.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Feb 2022, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>
> The bogus loop from compute_dbuf_slices() was copied into
> check_mbus_joined() as well. So this lookup is wrong as well.
> Fix it.
>
> Cc: stable@vger.kernel.org
> Fixes: f4dc00863226 ("drm/i915/adl_p: MBUS programming")
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/gpu/drm/i915/intel_pm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel=
_pm.c
> index da721aea70ff..23d4bb011fc8 100644
> --- a/drivers/gpu/drm/i915/intel_pm.c
> +++ b/drivers/gpu/drm/i915/intel_pm.c
> @@ -4831,7 +4831,7 @@ static bool check_mbus_joined(u8 active_pipes,
>  {
>  	int i;
>=20=20
> -	for (i =3D 0; i < dbuf_slices[i].active_pipes; i++) {
> +	for (i =3D 0; dbuf_slices[i].active_pipes !=3D 0; i++) {
>  		if (dbuf_slices[i].active_pipes =3D=3D active_pipes)
>  			return dbuf_slices[i].join_mbus;
>  	}

--=20
Jani Nikula, Intel Open Source Graphics Center
