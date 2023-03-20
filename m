Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1086C06BA
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCTAFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCTAFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:05:39 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0377517165
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 17:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679270738; x=1710806738;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iYimstyp/pRnUkyJVlD+F+MoAZeB8XQ6Y5NtxxJFUlU=;
  b=lZNZBQ0zD88O5/1bZS8tXHku29jN/o2nnBzFGkG41kOUj1wB0PN8j2Uc
   YVppQ3EccKg3Z+ZNPLfVoTIcvgqDE2BWAZWXDqoBJLKMX4tSuslGH90tw
   Y4+eu9r5SJhmIA89dgoOFQnuxfSRfSiJ9Pg7An0Jm1wriHcBHDcyV/IuJ
   7BVAW0jVYXRutzVYuqw4P/37JxnBAMvwmIUPPwZ+9MWyccTxKK55+sYrv
   SCNR4Rx1WxprVHIvAJ6Y7miopE8+D+tDoqlnsS+niVGV9EuxKSjzc6Efm
   bTL4VHrAqT7zoik9LCRWQHAAIPljrr3Pvmab6ISBFFLVO+ITSpO8Quf2W
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="401125645"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="401125645"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 17:05:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="711123002"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="711123002"
Received: from msbunten-mobl1.amr.corp.intel.com (HELO intel.com) ([10.251.221.102])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 17:05:34 -0700
Date:   Mon, 20 Mar 2023 01:05:09 +0100
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Nirmoy Das <nirmoy.das@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        John Harrison <John.C.Harrison@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gem: Flush lmem contents after construction
Message-ID: <ZBejNeB9mox9kStu@ashyti-mobl2.lan>
References: <20230316165918.13074-1-nirmoy.das@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316165918.13074-1-nirmoy.das@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nirmoy,

On Thu, Mar 16, 2023 at 05:59:18PM +0100, Nirmoy Das wrote:
> From: Chris Wilson <chris.p.wilson@linux.intel.com>
> 
> i915_gem_object_create_lmem_from_data() lacks the flush of the data
> written to lmem to ensure the object is marked as dirty and the writes
> flushed to the backing store. Once created, we can immediately release
> the obj->mm.mapping caching of the vmap.
> 
> Fixes: 7acbbc7cf485 ("drm/i915/guc: put all guc objects in lmem when available")
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: John Harrison <John.C.Harrison@Intel.com>
> Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.16+
> Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Thanks,
Andi
