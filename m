Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB5A57E129
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 14:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbiGVMAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 08:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiGVMAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 08:00:18 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B171B7EA;
        Fri, 22 Jul 2022 05:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658491215; x=1690027215;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=nRBWTIjqR+EBo83QXnR7YxxBrSXGYH7OV2uGt4ob61E=;
  b=UK5tnF1bJF4MAafHTS53h023yyOiDai9Td1R19AwJYX8KoKZnl4YsSBv
   yNMF5LKIX4uAPkJfCoi2k8tmmvitqVH0eOO4r97J/spCFZFVQQjrnab5T
   M4g7/sb7BUCixn44w1yDsVVUGLhbwlOlHjHGC4CH+VGqP2kd32qjdcUo6
   +7eqzQCD9nZ/I1l/PBkl3PZh6kpELhJpOr3hjWR+9uoUjVHqcW38bAuYX
   uwvoeApFqWUkqICPqotiz20l4T3Br85xI4uw5QLiC654ABI73t3uheOVK
   6/spCJrBVEoYMG7+1vPWMrO7tktfl9PQkLDYpglMQPLgL4AcPdlEJBACP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="288470404"
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="288470404"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 05:00:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="657189243"
Received: from dstoll-mobl.ger.corp.intel.com (HELO intel.com) ([10.252.44.132])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 05:00:10 -0700
Date:   Fri, 22 Jul 2022 14:00:09 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fei Yang <fei.yang@intel.com>,
        Thomas =?iso-8859-15?Q?Hellstr=F6m?= 
        <thomas.hellstrom@linux.intel.com>
Subject: Re: [PATCH v2 05/21] drm/i915/gt: Skip TLB invalidations once wedged
Message-ID: <YtqRSXXiON8Oed96@alfio.lan>
References: <cover.1657800199.git.mchehab@kernel.org>
 <f20bd21c94610dae59824b8040e5a9400de6f963.1657800199.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f20bd21c94610dae59824b8040e5a9400de6f963.1657800199.git.mchehab@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mauro,

On Thu, Jul 14, 2022 at 01:06:10PM +0100, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Skip all further TLB invalidations once the device is wedged and
> had been reset, as, on such cases, it can no longer process instructions
> on the GPU and the user no longer has access to the TLB's in each engine.
> 
> That helps to reduce the performance regression introduced by TLB
> invalidate logic.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Cc: Fei Yang <fei.yang@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

I haven't read any concern from Tvrtko here, in any case:

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

thanks,
Andi
