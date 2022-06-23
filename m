Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18BB557859
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 13:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiFWLEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 07:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiFWLEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 07:04:45 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED91C4B431;
        Thu, 23 Jun 2022 04:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655982284; x=1687518284;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=uvRiXn0RqPUIUKiZwsBd2d49wVVCGlUjadwpX0J+dbo=;
  b=Jp+G15SqRh8yL6m561GCX/n6GhdPqTb7RGvVb92r34FqXZ5Lt/L2iGi3
   j0dwYgQq6rvlZxnhYxkMowIk4h7kvk2eRCeZdrLuhLzABdDLnr2ZybjnO
   PuFcbW0gdwFjp9PD31wwip4+30ryxOaQuZOIlReWcwK+lZr/VQK92+2nk
   3/0LBEby79s1tqc8b4C3y1m5PDPRmJzkNmoCuWNXT5GmuHv2GVJ6V0e0N
   Lee1iVqsCaOIdwgp0xHo+HflLhksaIsCosxsDsJ7+8v0WRpae/l3ys6jk
   8iTdOwgLmbzG6NBrQmLUFePN6IRFYLRrjImnPjcJeX5ycFYmkcA6NwgyK
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="260505005"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="260505005"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 04:04:41 -0700
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="644684867"
Received: from hazegrou-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.216.121])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 04:04:35 -0700
Date:   Thu, 23 Jun 2022 13:04:32 +0200
From:   Andi Shyti <andi.shyti@intel.com>
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
        Jason Ekstrand <jason@jlekstrand.net>,
        John Harrison <John.C.Harrison@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mauro.chehab@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/6] drm/i915/gt: Ignore TLB invalidations on idle engines
Message-ID: <YrRIwEXMvlXlXBX2@intel.intel>
References: <cover.1655306128.git.mchehab@kernel.org>
 <ce7ddc900a5421e577ef446b6834ee69663c2d9a.1655306128.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce7ddc900a5421e577ef446b6834ee69663c2d9a.1655306128.git.mchehab@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mauro,

On Wed, Jun 15, 2022 at 04:27:35PM +0100, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> As an extension of the current skip TLB invalidations,
> check if the device is powered down prior to any engine activity,
> 
> as, on such cases, all the TLBs were already invalidated, so an
> explicit TLB invalidation is not needed.
> 
> This becomes more significant  with GuC, as it can only do so when
> the connection to the GuC is awake.
> 
> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
> 
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Cc: Fei Yang <fei.yang@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: stable@vger.kernel.org
> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Andi
