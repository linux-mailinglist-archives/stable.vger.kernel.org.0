Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAAD5786F6
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 18:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbiGRQHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 12:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbiGRQHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 12:07:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687E92A710;
        Mon, 18 Jul 2022 09:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658160421; x=1689696421;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BGMaJTElQp6haGmkH8rT8RsSQevkIPle8322hFlFuJg=;
  b=aKOP8/gklL+5oQX4jxLl9VSJCrY2ECVl9OT4mukzlfyt76kOv7TtGMqt
   81Jt2hlaCS4O5KE8jF93/OY3T1edR8PxWJhLVy1OiLviglfQhXjreO9E1
   k1cZNcM8bo0SufhVWZV+48FXc+B5gFbwvUDS48T2mh8Yy2CxJA/rSW0qD
   aubJcbZeueG0LEnVXyqsQ0GtCNxO8zIIq6hWVwImybzM9La06EMMuWdy1
   5xMvxpu+ACpB/qN5UA9AZEMgu+4M9lwJyLij8rZh4J2gg4mb0WLfKULk6
   jXVactYuoBSBvyqS4oAKBliShTuGV8CIVQN6IvHZouT7Cyfa8szr0Ja4L
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="347947883"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="347947883"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 09:06:36 -0700
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="655347466"
Received: from maurocar-mobl2.ger.corp.intel.com (HELO maurocar-mobl2) ([10.249.35.85])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 09:06:33 -0700
Date:   Mon, 18 Jul 2022 18:06:30 +0200
From:   Mauro Carvalho Chehab <mauro.chehab@linux.intel.com>
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas =?UTF-8?B?SGVsbHN0?= =?UTF-8?B?csO2bQ==?= 
        <thomas.hellstrom@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-kernel@vger.kernel.org,
        Chris Wilson <chris.p.wilson@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>, stable@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH v2 05/21] drm/i915/gt: Skip TLB
 invalidations once wedged
Message-ID: <20220718180630.7bef2fd9@maurocar-mobl2>
In-Reply-To: <d51882e0-6864-7a49-ae16-f7213dc716c4@linux.intel.com>
References: <cover.1657800199.git.mchehab@kernel.org>
        <f20bd21c94610dae59824b8040e5a9400de6f963.1657800199.git.mchehab@kernel.org>
        <d51882e0-6864-7a49-ae16-f7213dc716c4@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Jul 2022 14:45:22 +0100
Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:

> On 14/07/2022 13:06, Mauro Carvalho Chehab wrote:
> > From: Chris Wilson <chris.p.wilson@intel.com>
> > 
> > Skip all further TLB invalidations once the device is wedged and
> > had been reset, as, on such cases, it can no longer process instructions
> > on the GPU and the user no longer has access to the TLB's in each engine.
> > 
> > That helps to reduce the performance regression introduced by TLB
> > invalidate logic.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")  
> 
> Is the claim of a performance regression this solved based on a wedged 
> GPU which does not work any more to the extend where mmio tlb 
> invalidation requests keep timing out? If so please clarify in the 
> commit text and then it looks good to me. Even if it is IMO a very 
> borderline situation to declare something a fix.

Indeed this helps on a borderline situation: if GT is wedged, TLB 
invalidation will timeout, so it makes sense to keep the patch with a
comment like:

    drm/i915/gt: Skip TLB invalidations once wedged
    
    Skip all further TLB invalidations once the device is wedged and
    had been reset, as, on such cases, it can no longer process instructions
    on the GPU and the user no longer has access to the TLB's in each engine.
    
    So, an attempt to do a TLB cache invalidation will produce a timeout.
    
    That helps to reduce the performance regression introduced by TLB
    invalidate logic.

Regards,
Mauro
