Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60DC5604A2
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 17:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbiF2Pa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 11:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbiF2PaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 11:30:18 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B6837A3C;
        Wed, 29 Jun 2022 08:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656516617; x=1688052617;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SJ3zrtAdiRXrExOHH4PA7vzVduYFYbuyAhmqGXy7Ux8=;
  b=OMSifA62VOW+m83eB4idCvxhNIPy2Na8lQxFCjGC+Cxs3pb/JL+qdWl8
   4b8TFY0Iv6OdkNWyLDPK03X52nsy0Taen+1TmLkMZIQiR4Tgqp3H7BI/k
   NvIOYS6IPmmQp1LgvATsSUmsSm1kOXR8cmWnpeDEhpFx1O8KDyYXZdj6B
   7kDi4FvPlwApvYrqRliSJDiXs3PaIDgbgkHyR6MkfpOWmHDrTu6LbfLLX
   uzdNZy7bfXxkPF9Gxg/BA5dkvoTDohDEnUcQv6lTkHHCxoQl6caEUfuTG
   Bagnqz9TMSWxmPiTAWt9PIyUdsMB2N6eBawndOzXGrzzk1zJCvbmt39No
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="368372952"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="368372952"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 08:30:16 -0700
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="595274517"
Received: from maurocar-mobl2.ger.corp.intel.com (HELO maurocar-mobl2) ([10.249.42.133])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 08:30:10 -0700
Date:   Wed, 29 Jun 2022 17:30:07 +0200
From:   Mauro Carvalho Chehab <mauro.chehab@linux.intel.com>
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc:     Andi Shyti <andi.shyti@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chris Wilson <chris.p.wilson@intel.com>,
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
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org,
        Thomas =?UTF-8?B?SGVs?= =?UTF-8?B?bHN0csO2bQ==?= 
        <thomas.hellstrom@linux.intel.com>
Subject: Re: [PATCH 5/6] drm/i915/gt: Serialize GRDOM access between
 multiple engine resets
Message-ID: <20220629172955.64ffb5c3@maurocar-mobl2>
In-Reply-To: <d79492ad-b99a-f9a9-f64a-52b94db68a3b@linux.intel.com>
References: <cover.1655306128.git.mchehab@kernel.org>
        <5ee647f243a774927ec328bfca8212abc4957909.1655306128.git.mchehab@kernel.org>
        <YrRLyg1IJoZpVGfg@intel.intel>
        <160e613f-a0a8-18ff-5d4b-249d4280caa8@linux.intel.com>
        <20220627110056.6dfa4f9b@maurocar-mobl2>
        <d79492ad-b99a-f9a9-f64a-52b94db68a3b@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Jun 2022 16:49:23 +0100
Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:

>.. which for me means a different patch 1, followed by patch 6 (moved 
> to be patch 2) would be ideal stable material.
> 
> Then we have the current patch 2 which is open/unknown (to me at least).
> 
> And the rest seem like optimisations which shouldn't be tagged as fixes.
> 
> Apart from patch 5 which should be cc: stable, but no fixes as agreed.
> 
> Could you please double check if what I am suggesting here is feasible 
> to implement and if it is just send those minimal patches out alone?

Tested and porting just those 3 patches are enough to fix the Broadwell
bug.

So, I submitted a v2 of this series with just those. They all need to
be backported to stable.

I still think that other TLB patches are needed/desired upstream, but
I'll submit them on a separate series. Let's fix the regression first ;-)

Regards,
Mauro
