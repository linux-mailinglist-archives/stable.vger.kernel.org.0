Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A6B557895
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 13:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiFWLS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 07:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiFWLS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 07:18:57 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F276D4BBA0;
        Thu, 23 Jun 2022 04:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655983137; x=1687519137;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZDmviisAQFt/A72ntxTrOHQF561xAWJ5eMxmpFohiy4=;
  b=Knkz5DmEYNKy7rBucfltf1wCQeZbmZDlm5A1yZf2G1qwGJvcSwr5dTjU
   3XgrSCdTKAmfljqiWg2i9L1mCLlHFl4tV7Z3Mjt6mDBXjaRzDHHYqgYJ5
   y//d80sRddUagmpAsiu2RLCEJqbYMDqX4OPRAvpPSYG/vd3swOAcMA9y7
   ey5pV9rxCSVAlm5mtmc2Od2o5KulmgpdAsGuDYd7UJ/A+VcgU2M/BG6gz
   wMpOr2dEzTNEC+zy0cHV395IsvTylmMPx9muvjFbvu9lkfsX9/6iyEUG4
   eJ7hAY2xS4UJo5W7sTs4lniyyK1P9FzJbUmQzaKnQVJIrmMC0SiJ1GcZd
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="344682191"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="344682191"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 04:18:56 -0700
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="644691087"
Received: from hazegrou-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.216.121])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 04:18:50 -0700
Date:   Thu, 23 Jun 2022 13:18:47 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Fei Yang <fei.yang@intel.com>,
        =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Thomas =?iso-8859-15?Q?Hellstr=F6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mauro.chehab@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 6/6] drm/i915/gt: Serialize TLB invalidates with GT resets
Message-ID: <YrRMF9fY46KJcMG/@intel.intel>
References: <cover.1655306128.git.mchehab@kernel.org>
 <cd5696e3800fd29114ddf0cebc950b57a17bc1b8.1655306128.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd5696e3800fd29114ddf0cebc950b57a17bc1b8.1655306128.git.mchehab@kernel.org>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mauro,

On Wed, Jun 15, 2022 at 04:27:40PM +0100, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Avoid trying to invalidate the TLB in the middle of performing an
> engine reset, as this may result in the reset timing out. Currently,
> the TLB invalidate is only serialised by its own mutex, forgoing the
> uncore lock, but we can take the uncore->lock as well to serialise
> the mmio access, thereby serialising with the GDRST.
> 
> Tested on a NUC5i7RYB, BIOS RYBDWi35.86A.0380.2019.0517.1530 with
> i915 selftest/hangcheck.
> 
> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
> 
> Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Reviewed-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: stable@vger.kernel.org
> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Thanks,
Andi
