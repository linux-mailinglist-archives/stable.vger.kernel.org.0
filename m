Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9023355787E
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 13:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiFWLOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 07:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiFWLOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 07:14:05 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51F410FDC;
        Thu, 23 Jun 2022 04:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655982843; x=1687518843;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ajFYZAC8MEA43zYcILf89zu5jxIuV92OVh4y+errMgM=;
  b=Zr8odk0HzDlad9zxYpR5T+2rSxtiH9M4NMv86S6g36yw5upJsGSP59jC
   ++WpQvCmqgBlXR/mexeKMq3PWdetmc7RW9yt7Q5PvtBRPnm+/CV/jltOW
   /70FWP6vx9rXuWQYGwEhoUV9HqN6KL68CPz65biDDejU8BUJJ40cZxtrS
   6Oss5C/krZ2IlH36muDG8yvO6f30kxTCO5J+nUuYRsMiwFzHPI7OWsZbb
   m3UZhfgnagvPvZ8zDI0raBGrzGHv5uwkA2DhkHzDiLge2RVTNapkx2yK/
   enXuigL/+9pUJlD3+LCjV8thZaVSPZJ5mAi8SZSYupVbzUcg9+U88y+Cj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="280737971"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="280737971"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 04:14:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="834592683"
Received: from hazegrou-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.216.121])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 04:13:59 -0700
Date:   Thu, 23 Jun 2022 13:13:56 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mauro.chehab@linux.intel.com,
        Andi Shyti <andi.shyti@linux.intel.com>,
        stable@vger.kernel.org,
        Thomas =?iso-8859-15?Q?Hellstr=F6m?= 
        <thomas.hellstrom@linux.intel.com>
Subject: Re: [PATCH 4/6] drm/i915/gt: Only invalidate TLBs exposed to user
 manipulation
Message-ID: <YrRK9Gaf/G4AXwYn@intel.intel>
References: <cover.1655306128.git.mchehab@kernel.org>
 <387b9a8d3e719ad2db4fce56c0bfc0f909fd6df6.1655306128.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <387b9a8d3e719ad2db4fce56c0bfc0f909fd6df6.1655306128.git.mchehab@kernel.org>
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

On Wed, Jun 15, 2022 at 04:27:38PM +0100, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Don't flush TLBs when the buffer is only used in the GGTT under full
> control of the kernel, as there's no risk of of concurrent access
> and stale access from prefetch.
> 
> We only need to invalidate the TLB if they are accessible by the user.
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

Thanks,
Andi
