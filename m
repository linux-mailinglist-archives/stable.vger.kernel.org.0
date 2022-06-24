Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2401559581
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 10:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiFXIe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 04:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiFXIe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 04:34:27 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2414A3D6;
        Fri, 24 Jun 2022 01:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656059667; x=1687595667;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GL7gNHkZqM1sWdOok001Mz0b5ZGecYzNGjnRUb23NBQ=;
  b=A8gxWgVNKoGYCXxxommMEyl9F2eyFoyZfJK3OUxc6YBCOSv8BsYgIo5Z
   FLSVRp0cBQaKJ9lNZtPDTCkRQ0c9/2nlELekYKb/ex+PDbhIan+ywwoUm
   vJ+PNfIbqEriUtRjnFUSIn1lObYOwMvHvhQV1NNCxRWnhWt4snVqxE7ge
   fhXXe0Sh0/3TdZCSrllSJiORNG7VBdjbNLkkLaEMfzmokg7zXb/uS+2S8
   ww9xT0MYlP3p8A/MA+gYxxcURlU6plD80EmkdZ+C0JFyRQfiEf9pWvUFF
   Dcon13CnfCxineRuG5PyiRyEFIjAHj9BOIGgAIqAOKgUIvsOY5KvXFQHI
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="282038036"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="282038036"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 01:34:26 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="915596863"
Received: from acamigob-mobl.amr.corp.intel.com (HELO [10.212.103.132]) ([10.212.103.132])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 01:34:22 -0700
Message-ID: <160e613f-a0a8-18ff-5d4b-249d4280caa8@linux.intel.com>
Date:   Fri, 24 Jun 2022 09:34:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5/6] drm/i915/gt: Serialize GRDOM access between multiple
 engine resets
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
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
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mauro.chehab@linux.intel.com,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>
References: <cover.1655306128.git.mchehab@kernel.org>
 <5ee647f243a774927ec328bfca8212abc4957909.1655306128.git.mchehab@kernel.org>
 <YrRLyg1IJoZpVGfg@intel.intel>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <YrRLyg1IJoZpVGfg@intel.intel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 23/06/2022 12:17, Andi Shyti wrote:
> Hi Mauro,
> 
> On Wed, Jun 15, 2022 at 04:27:39PM +0100, Mauro Carvalho Chehab wrote:
>> From: Chris Wilson <chris.p.wilson@intel.com>
>>
>> Don't allow two engines to be reset in parallel, as they would both
>> try to select a reset bit (and send requests to common registers)
>> and wait on that register, at the same time. Serialize control of
>> the reset requests/acks using the uncore->lock, which will also ensure
>> that no other GT state changes at the same time as the actual reset.
>>
>> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
>>
>> Reported-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
>> Cc: Andi Shyti <andi.shyti@intel.com>
>> Cc: stable@vger.kernel.org
>> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> 
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Notice I had a bunch of questions and asks in this series so please do 
not merge until those are addressed.

In this particular patch (and some others) for instance Fixes: tag, at 
least against that sha, shouldn't be there.

Regards,

Tvrtko
