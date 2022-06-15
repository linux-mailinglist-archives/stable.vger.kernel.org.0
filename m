Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AA454CF59
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 19:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiFORFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 13:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiFORFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 13:05:19 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515B44F9D0;
        Wed, 15 Jun 2022 10:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655312718; x=1686848718;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=1PYnn6PyVpQKqMIrBh21mNOeylsX7mB9wzgN758442Y=;
  b=L40+lCJw4uClwzbOQzgvm+7d7jLAWagigTI/O6kauFmIkzB01zwoWPGJ
   6t00BY4sH2J1rxK2xxWg9S0pQOK7coISzW5I9oPD21fk8fgRSngLDUNmG
   dopKsDtEG+GT983exOqRQybv4bvx5yKkooGWLhZFNUFdSwzwDJRikBMN9
   BmCKKts5VAfKJsqYCO4VBuVN+LH/qOwYp28qTnqqxeSoU6ukrI5iwZVe+
   /tLDonfoVjMxs4WMb4TvFtwdns3/i3vzj3zi4LGbcOVswuuYTs05OeHFl
   RhDflqA4fYcKxoah2hv22l6sd+2QVSbdW+q/7QqMsxtMsEDYzA4jJrTZV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="279752968"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="279752968"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 10:03:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="727500681"
Received: from orsosgc001.jf.intel.com ([10.165.21.154])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 10:03:16 -0700
Date:   Wed, 15 Jun 2022 10:03:15 -0700
From:   Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris.p.wilson@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Thomas =?utf-8?Q?Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        mauro.chehab@linux.intel.com,
        =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/6] drm/i915/gt: Invalidate TLB of the OA
 unit at TLB invalidations
Message-ID: <20220615170315.GK48807@orsosgc001.jf.intel.com>
References: <cover.1655306128.git.mchehab@kernel.org>
 <653bf9815d562f02c7247c6b66b85b243f3172e7.1655306128.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <653bf9815d562f02c7247c6b66b85b243f3172e7.1655306128.git.mchehab@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 15, 2022 at 04:27:36PM +0100, Mauro Carvalho Chehab wrote:
>From: Chris Wilson <chris.p.wilson@intel.com>
>
>On gen12 HW, ensure that the TLB of the OA unit is also invalidated
>as just invalidating the TLB of an engine is not enough.
>
>Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
>
>Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
>Cc: Fei Yang <fei.yang@intel.com>
>Cc: Andi Shyti <andi.shyti@linux.intel.com>
>Cc: stable@vger.kernel.org
>Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
>---
>
>See [PATCH 0/6] at: https://lore.kernel.org/all/cover.1655306128.git.mchehab@kernel.org/
>
> drivers/gpu/drm/i915/gt/intel_gt.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)
>
>diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
>index d5ed6a6ac67c..61b7ec5118f9 100644
>--- a/drivers/gpu/drm/i915/gt/intel_gt.c
>+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
>@@ -10,6 +10,7 @@
> #include "pxp/intel_pxp.h"
>
> #include "i915_drv.h"
>+#include "i915_perf_oa_regs.h"
> #include "intel_context.h"
> #include "intel_engine_pm.h"
> #include "intel_engine_regs.h"
>@@ -1259,6 +1260,15 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
> 		awake |= engine->mask;
> 	}
>
>+	/* Wa_2207587034:tgl,dg1,rkl,adl-s,adl-p */
>+	if (awake &&
>+	    (IS_TIGERLAKE(i915) ||
>+	     IS_DG1(i915) ||
>+	     IS_ROCKETLAKE(i915) ||
>+	     IS_ALDERLAKE_S(i915) ||
>+	     IS_ALDERLAKE_P(i915)))
>+		intel_uncore_write_fw(uncore, GEN12_OA_TLB_INV_CR, 1);
>+

This patch can be dropped since this is being done in i915/i915_perf.c 
-> gen12_oa_disable and is synchronized with OA use cases.

Regards,
Umesh


> 	for_each_engine_masked(engine, gt, awake, tmp) {
> 		struct reg_and_bit rb;
>
>-- 
>2.36.1
>
