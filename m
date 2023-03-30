Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301406D0CF4
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 19:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjC3Rgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 13:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjC3Rgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 13:36:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B2B6A47;
        Thu, 30 Mar 2023 10:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680197797; x=1711733797;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=RBvzdW7pSSpZoGr/lhLmsN5VnHXIMJICoUqPvQK2N5Q=;
  b=DLeQPrASHVmaxAqKK9uD5xx4gmQBbCVnK3MqduChJqHDNvUszkwXDaf2
   snwReF1wD1JaLXm93RZHAhUA40ZOEapl+BOi6wf9PHVOihi+hj2RS34Yd
   RVGDfId3WNFMPN/kwPi0TJKMe84picJN8RpxZmPG9M9KS8+ULd/SVVeMP
   3s7L2irvS42FYA9brDYXkcF/3XeK4HKQWceF9K+yT2bTbZdMePk9WKD74
   0bNomyailRjP4J+ZLxZiKWnfsLTKo2E8mfxvMhrA31k87qyLXWFwxvGkC
   dlEEkMjHTZaUrfcZ2dOSYzeHOkMlRHUJiYFjNn/YXzVUF57xGQSwJwXS0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="342883002"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="342883002"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 10:36:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="678277381"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="678277381"
Received: from pabbey-mobl.amr.corp.intel.com ([10.212.62.67])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 10:36:35 -0700
Message-ID: <9e65a37b8220943a540cc3aaf660a79cef4041dc.camel@linux.intel.com>
Subject: Re: [PATCH] thermal: intel: powerclamp: Fix cpumask and max_idle
 module parameters
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     David Arcari <darcari@redhat.com>, linux-pm@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Chen Yu <yu.c.chen@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Thu, 30 Mar 2023 10:36:33 -0700
In-Reply-To: <20230330134218.1897786-1-darcari@redhat.com>
References: <20230330134218.1897786-1-darcari@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2023-03-30 at 09:42 -0400, David Arcari wrote:
Reviewed-by: Srinivas Pandruvada <>> When cpumask is specified as a module =
parameter the value is
> overwritten by the module init routine.=C2=A0 This can easily be fixed
> by checking to see if the mask has already been allocated in the
> init routine.
>=20
> When max_idle is specified as a module parameter a panic will occur.
> The problem is that the idle_injection_cpu_mask is not allocated
> until
> the module init routine executes. This can easily be fixed by
> allocating
> the cpumask if it's not already allocated.
>=20
> Fixes: ebf519710218 ("thermal: intel: powerclamp: Add two module
> parameters")
>=20
> Signed-off-by: David Arcari <darcari@redhat.com>
Reviewed-by: Srinivas Pandruvada<srinivas.pandruvada@linux.intel.com>

>=20
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Amit Kucheria <amitk@kernel.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: David Arcari <darcari@redhat.com>
> Cc: Chen Yu <yu.c.chen@intel.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
>=20
> ---
> =C2=A0drivers/thermal/intel/intel_powerclamp.c | 9 ++++++++-
> =C2=A01 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/thermal/intel/intel_powerclamp.c
> b/drivers/thermal/intel/intel_powerclamp.c
> index c7ba5680cd48..91fc7e239497 100644
> --- a/drivers/thermal/intel/intel_powerclamp.c
> +++ b/drivers/thermal/intel/intel_powerclamp.c
> @@ -235,6 +235,12 @@ static int max_idle_set(const char *arg, const
> struct kernel_param *kp)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto skip_limit_set;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!cpumask_available(idle_in=
jection_cpu_mask)) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0ret =3D
> allocate_copy_idle_injection_mask(cpu_present_mask);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0if (ret)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0goto skip=
_limit_set;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (check_invalid(idle_in=
jection_cpu_mask, new_max_idle)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ret =3D -EINVAL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto skip_limit_set;
> @@ -791,7 +797,8 @@ static int __init powerclamp_init(void)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return retval;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_lock(&powerclamp_lo=
ck);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0retval =3D allocate_copy_idle_=
injection_mask(cpu_present_mask);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!cpumask_available(idle_in=
jection_cpu_mask))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0retval =3D
> allocate_copy_idle_injection_mask(cpu_present_mask);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(&powerclamp_=
lock);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (retval)

