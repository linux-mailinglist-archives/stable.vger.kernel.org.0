Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462E7557886
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 13:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiFWLRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 07:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiFWLRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 07:17:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170094B437;
        Thu, 23 Jun 2022 04:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655983058; x=1687519058;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=5Z1glAH6RldXiFGaCnDodkfVEScRoth80xEGCnd7XKU=;
  b=Sf1gCsZK8z5Vq40daXHSbngDHDKKFUxKoJaPfULPZt0C2Nr59TfSjfP9
   g1CMz98bmRssyygGjgN2rfQCEejOtE3QhVpn4WIFyophkbqiuAHNmEs7W
   zhNkL2JCR0YdxCdOnY98b+OAfbH49tTuUhEL1mRmXjo3J+AwLe1tvOMdD
   I1FY/3+MQqLm5fTf0+UXX3UO9W1O2hRJZW29W4e5MBNls/GzvgdF6SVQD
   MnKyS3RiXvjF66UZCLynx6ll6JldECHlaSTTR07jTSULDn072sHs79sUP
   pvnma3hEFPZSKsFVKJ8lT4fq7o7A3l5YvkU3ELBUt03YMvYH+z/nTFltV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="278241099"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="278241099"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 04:17:37 -0700
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="644690773"
Received: from hazegrou-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.216.121])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 04:17:32 -0700
Date:   Thu, 23 Jun 2022 13:17:30 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mauro.chehab@linux.intel.com,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org,
        Thomas =?iso-8859-15?Q?Hellstr=F6m?= 
        <thomas.hellstrom@linux.intel.com>
Subject: Re: [PATCH 5/6] drm/i915/gt: Serialize GRDOM access between multiple
 engine resets
Message-ID: <YrRLyg1IJoZpVGfg@intel.intel>
References: <cover.1655306128.git.mchehab@kernel.org>
 <5ee647f243a774927ec328bfca8212abc4957909.1655306128.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5ee647f243a774927ec328bfca8212abc4957909.1655306128.git.mchehab@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mauro,

On Wed, Jun 15, 2022 at 04:27:39PM +0100, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Don't allow two engines to be reset in parallel, as they would both
> try to select a reset bit (and send requests to common registers)
> and wait on that register, at the same time. Serialize control of
> the reset requests/acks using the uncore->lock, which will also ensure
> that no other GT state changes at the same time as the actual reset.
> 
> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
> 
> Reported-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Andi Shyti <andi.shyti@intel.com>
> Cc: stable@vger.kernel.org
> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Thanks,
Andi
