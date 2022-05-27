Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156E45360E3
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiE0L51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353292AbiE0L4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:22 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C068131F1A;
        Fri, 27 May 2022 04:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653652231; x=1685188231;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Pv1I1Nns+I2QLs1eslBaZaz+CjfC1UGQQpD+Gz2iAk=;
  b=mxqncneW1ZdY+V8kbWzw9qroLJxt1MrrZoNgFtcZORF5DiF1j0koNcNA
   Q1LQRi+wG0OVVt8zRBlKVlDlYq/WdPw1mRAumNAWxOyB34jwp5up2KjQG
   pbCibHeTevO7ZDlibNYrXnShjdjxEYl/mWpuylJdMO92w0BTsarujgK5T
   mQnA0KYO8lAPrkdwE9ZRKpiDn5HX7B0vY3wV8/ulyfzn1atR8fVb6x6cs
   MiOVhtZ0i+RhBhsXMQFiHdm/evR9Z3yzwVfYvS+Q1XHcj7wtNFFJli9JN
   BZYfAJU+RUa//mwviEz6q6Jf4I0NWrsNaehmZnsZdrgf82QKQKRW5UoJb
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="262078060"
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="262078060"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 04:50:30 -0700
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="705112301"
Received: from tdietric-mobl.ger.corp.intel.com (HELO linux.intel.com) ([10.252.54.13])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 04:50:26 -0700
Received: from localhost ([127.0.0.1] helo=maurocar-mobl2)
        by linux.intel.com with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <mauro.chehab@linux.intel.com>)
        id 1nuYU2-000PFu-Ro;
        Fri, 27 May 2022 13:50:22 +0200
Date:   Fri, 27 May 2022 13:50:22 +0200
From:   Mauro Carvalho Chehab <mauro.chehab@linux.intel.com>
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Jani Nikula <jani.nikula@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: don't flush TLB on GEN8
Message-ID: <20220527135022.0dd0891d@maurocar-mobl2>
In-Reply-To: <d981f429-d01f-4576-2e5c-0ae153d24df1@linux.intel.com>
References: <b6417c5bf1b0ee8e093712264f325bd1268ed1e4.1653642514.git.mchehab@kernel.org>
        <d981f429-d01f-4576-2e5c-0ae153d24df1@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 27 May 2022 11:55:42 +0100
Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:

> On 27/05/2022 10:09, Mauro Carvalho Chehab wrote:
> > i915 selftest hangcheck is causing the i915 driver timeouts, as
> > reported by Intel CI:
> > 
> > 	http://gfx-ci.fi.intel.com/cibuglog-ng/issuefilterassoc/24297?query_key=42a999f48fa6ecce068bc8126c069be7c31153b4
> > 
> > When such test runs, the only output is:
> > 
> > 	[   68.811639] i915: Performing live selftests with st_random_seed=0xe138eac7 st_timeout=500
> > 	[   68.811792] i915: Running hangcheck
> > 	[   68.811859] i915: Running intel_hangcheck_live_selftests/igt_hang_sanitycheck
> > 	[   68.816910] i915 0000:00:02.0: [drm] Cannot find any crtc or sizes
> > 	[   68.841597] i915: Running intel_hangcheck_live_selftests/igt_reset_nop
> > 	[   69.346347] igt_reset_nop: 80 resets
> > 	[   69.362695] i915: Running intel_hangcheck_live_selftests/igt_reset_nop_engine
> > 	[   69.863559] igt_reset_nop_engine(rcs0): 709 resets
> > 	[   70.364924] igt_reset_nop_engine(bcs0): 903 resets
> > 	[   70.866005] igt_reset_nop_engine(vcs0): 659 resets
> > 	[   71.367934] igt_reset_nop_engine(vcs1): 549 resets
> > 	[   71.869259] igt_reset_nop_engine(vecs0): 553 resets
> > 	[   71.882592] i915: Running intel_hangcheck_live_selftests/igt_reset_idle_engine
> > 	[   72.383554] rcs0: Completed 16605 idle resets
> > 	[   72.884599] bcs0: Completed 18641 idle resets
> > 	[   73.385592] vcs0: Completed 17517 idle resets
> > 	[   73.886658] vcs1: Completed 15474 idle resets
> > 	[   74.387600] vecs0: Completed 17983 idle resets
> > 	[   74.387667] i915: Running intel_hangcheck_live_selftests/igt_reset_active_engine
> > 	[   74.889017] rcs0: Completed 747 active resets
> > 	[   75.174240] intel_engine_reset(bcs0) failed, err:-110
> > 	[   75.174301] bcs0: Completed 525 active resets
> > 
> > After that, the machine just silently hangs.
> > 
> > The root cause is that the flush TLB logic is not working as
> > expected on GEN8.
> > 
> > Tested on an Intel NUC5i7RYB with an i7-5557U Broadwell CPU.
> > 
> > This patch partially reverts the logic by skipping GEN8 from
> > the TLB cache flush.  
> 
> Since I am pretty sure no such failures were spotted when merging the 
> feature I assume the failure is sporadic and/or limited to some 
> configurations? Do you have any details there? Because it is an 
> important security issue we should not revert it lightly.

It occurs every time here:
	https://intel-gfx-ci.01.org/tree/drm-tip/fi-bdw-5557u.html

It also happens on my own NUC5i7RYB every time when the TLB patch is 
applied. Reverting it (or applying this fix) is enough for hangcheck
to pass.

I suspect that TLB flush never happens there, causing ETIMEOUT at
hangcheck.

It could indeed be limited to some specific setups. I dunno.
The only Gen8 machine I have access is my own NUC. So, I can't
test it elsewhere.

Regards,
Mauro


