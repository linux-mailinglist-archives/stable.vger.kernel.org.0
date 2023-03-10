Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C8B6B4B29
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbjCJPcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbjCJPcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:32:21 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0677412D41A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678461618; x=1709997618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XV8dT9fCGcS7xhq94/G+Dh0DOiv5/8aVRqju9CQaf1g=;
  b=OQh+RLSEfoCr+rnvd34VeIkW9FQauwj4CJThq95mYoQWRQWHO8ZLb4MN
   ZgxabY+/sfNtBKKd66I9sYzJmTMPMadWwBMgmyN7atSfYf83y5anAmQBA
   sTv1Rt5pkolvsx+TlKmrj+bb8XKgsUZwVaCgsbyVZdMTwrDvnG5amCyHQ
   9JFZiC0hFHWx5PsItSy6/EiAHInN++E9fNlMJauFbn7FtzyG6+XYh06kx
   fTmkwA5LO3Sji/T6aD8FdGvUD8JcNDpCHeH1t4FIQRPuWbk+9su9U1gTk
   sec7R0R5NSoKnycyKvxjf6YArqKqotyge34WJviF9hWgBTbhEoAkXKN4O
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="325098535"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="325098535"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 07:20:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="708039065"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="708039065"
Received: from jkrzyszt-mobl1.ger.corp.intel.com ([10.213.20.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 07:19:58 -0800
From:   Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/active: Fix missing debug object activation
Date:   Fri, 10 Mar 2023 16:19:55 +0100
Message-ID: <2135859.irdbgypaU6@jkrzyszt-mobl1.ger.corp.intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20230310141138.6592-1-nirmoy.das@intel.com>
References: <20230310141138.6592-1-nirmoy.das@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nirmoy,

On Friday, 10 March 2023 15:11:38 CET Nirmoy Das wrote:
> debug_active_activate() expected ref->count to be zero
> which is not true anymore as __i915_active_activate() calls
> debug_active_activate() after incrementing the count.
>=20
> Fixes: 04240e30ed06 ("drm/i915: Skip taking acquire mutex for no ref->act=
ive=20
callback")
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Thomas Hellstr=F6m <thomas.hellstrom@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.10+
> Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_active.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/
i915_active.c
> index a9fea115f2d2..1c3066eb359a 100644
> --- a/drivers/gpu/drm/i915/i915_active.c
> +++ b/drivers/gpu/drm/i915/i915_active.c
> @@ -92,7 +92,7 @@ static void debug_active_init(struct i915_active *ref)
>  static void debug_active_activate(struct i915_active *ref)
>  {
>  	lockdep_assert_held(&ref->tree_lock);
> -	if (!atomic_read(&ref->count)) /* before the first inc */
> +	if (atomic_read(&ref->count) =3D=3D 1) /* after the first inc */

While that's obviously better than never calling debug_active_activate(), I=
'm=20
wondering how likely we can still miss it because the counter being=20
incremented, e.g. via i915_active_acquire_if_busy(), by a concurrent thread=
=2E =20
Since __i915_active_activate() is the only user and its decision making ste=
p=20
is serialized against itself with a spinlock, couldn't we better call=20
debug_object_activate() unconditionally here?

Thanks,
Janusz

>  		debug_object_activate(ref, &active_debug_desc);
>  }
> =20
>=20




