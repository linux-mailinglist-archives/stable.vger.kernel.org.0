Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6BD57E11E
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 13:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbiGVL6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 07:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235242AbiGVL6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 07:58:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4333C0B60;
        Fri, 22 Jul 2022 04:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658491052; x=1690027052;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=+MHMFB3/SyMilPDULCXRco5YPvAqDbWUS0FUtek/FcA=;
  b=UQhUlN2VUuEjYoMoiSiGVLFgAB97UUOP0QiLky6eMlvOoI7PF+x2ySUT
   QM0NxAz+TIBD8K82BC+GXGEm5JsM0+8K45pQcy1epVoFBnZ9HgajbBKUr
   Ktes7ftyiVuCq2JA8IE7997c0l5R78jqsV+6Gc9pBp7EN1soSz6Un/gYz
   qe3fYPsS2DsTLDjLRn2Hc2KV6lFOD/3rrR3ejC/b33VKox5tqbPa2X1Pd
   Tpq3JkKoZdVN4wsQq2RiciVTXq95S8qz9659BfguevQvSRSNu/NNewb8A
   zhoIQKHTC3FSWw/Svf1T3saEgP07qmuBtHk96wXF87bKt2ugti8bbEBKz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="351292851"
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="351292851"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 04:57:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="626536572"
Received: from dstoll-mobl.ger.corp.intel.com (HELO intel.com) ([10.252.44.132])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 04:57:26 -0700
Date:   Fri, 22 Jul 2022 13:57:26 +0200
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
Subject: Re: [PATCH v2 03/21] drm/i915/gt: Invalidate TLB of the OA unit at
 TLB invalidations
Message-ID: <YtqQplx6IwYvpw6V@alfio.lan>
References: <cover.1657800199.git.mchehab@kernel.org>
 <44ec6a01ef2e82184abbb075b9c8a09297fa120c.1657800199.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44ec6a01ef2e82184abbb075b9c8a09297fa120c.1657800199.git.mchehab@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mauro and Chris,

On Thu, Jul 14, 2022 at 01:06:08PM +0100, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Ensure that the TLB of the OA unit is also invalidated
> on gen12 HW, as just invalidating the TLB of an engine is not
> enough.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Cc: Fei Yang <fei.yang@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Thanks,
Andi
