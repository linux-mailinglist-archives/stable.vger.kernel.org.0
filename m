Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1B84ADAD9
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 15:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbiBHOKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 09:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbiBHOKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 09:10:39 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B36C03FECE
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 06:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644329438; x=1675865438;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=CCFgStHsQ7eIZNN6U3FNFaaYurrT5dw80GtTTN7klSY=;
  b=h7lTPtEByFE1S+q8GH+6U7fCaCeRkW0SDMFiCQvhxKJ104dU5JhTJQ7I
   RiEanM2ChwaOo4bAGlfX/Oyu/OMGtzptgnqbvuFsilFS+th3Rzug7hYdR
   dakcM5AaSmWiI7wr9fSXJmoDPPJ/h+xBvzHDJaZAdau6VTB0gIbJ0JeeW
   jQaHVPILiYV5sLH1P1Yvsk5/qTOSQ7OGQ/cs9dZSH4VEdNSJsUpoDo7W4
   /xPoPFbUXDK+FGFiraTNvp6wntY+Q2lz69Whg5l0kOmL/kj4vD+pkUOOo
   4fpYHWHHDcfhoM4FDjoemxKPkqxILlwu1us05tXUxx1Hdu6ZDZnDCGz5m
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="309697983"
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="309697983"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 06:10:38 -0800
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="540611368"
Received: from ijbeckin-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.19.63])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 06:10:36 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i195: Fix dbuf slice config lookup
In-Reply-To: <20220207132700.481-1-ville.syrjala@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220207132700.481-1-ville.syrjala@linux.intel.com>
Date:   Tue, 08 Feb 2022 16:10:33 +0200
Message-ID: <878rulqwiu.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
> Apparently I totally fumbled the loop condition when I
> removed the ARRAY_SIZE() stuff from the dbuf slice config
> lookup. Comparing the loop index with the active_pipes bitmask
> is utter nonsense, what we want to do is check to see if the
> mask is zero or not.
>
> Cc: stable@vger.kernel.org
> Fixes: 05e8155afe35 ("drm/i915: Use a sentinel to terminate the dbuf slic=
e arrays")
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/gpu/drm/i915/intel_pm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel=
_pm.c
> index 02084652fe3d..da721aea70ff 100644
> --- a/drivers/gpu/drm/i915/intel_pm.c
> +++ b/drivers/gpu/drm/i915/intel_pm.c
> @@ -4848,7 +4848,7 @@ static u8 compute_dbuf_slices(enum pipe pipe, u8 ac=
tive_pipes, bool join_mbus,
>  {
>  	int i;
>=20=20
> -	for (i =3D 0; i < dbuf_slices[i].active_pipes; i++) {
> +	for (i =3D 0; dbuf_slices[i].active_pipes !=3D 0; i++) {
>  		if (dbuf_slices[i].active_pipes =3D=3D active_pipes &&
>  		    dbuf_slices[i].join_mbus =3D=3D join_mbus)
>  			return dbuf_slices[i].dbuf_mask[pipe];

--=20
Jani Nikula, Intel Open Source Graphics Center
