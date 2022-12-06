Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26BC64486F
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 16:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiLFPzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 10:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiLFPzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 10:55:20 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6FE389F
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 07:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670342119; x=1701878119;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J3NYwLu91EjPQ96UY02h+ARHsQfFo3tfOpX+MUpAGfQ=;
  b=iyLZUt3tQW1zMp8hjHE6hTDzT9zV/f2ETXy8ODLUuMzGHVn71Vk1YjnE
   5ZoEzZ+scJiVqrxPql/u5f89N7Tgv4b29tmc3InD0cwmNIgObEHxNKCGr
   L6IDb4BeDNv95R9t5bTkAA93ejhguQU3V+K0IreRIKNWFqXILwVCwgh+z
   U3051Rdru1TK5fEb0lw5Uv+yqt1qtvbqJHpQr+32t69Vt4tercU+/6kW1
   1aMWwr1QwV3jaoFb3xx2prqSsTRPvte5H++WaNLxtj5T1VVrGjfwUrFbL
   Tl3EPjTKXwVmJM63MoVyQDlXi7+3LMlNE6GJoegG4HuuPrxQR/FRCy/G2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="314297630"
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="314297630"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 07:55:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="820623538"
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="820623538"
Received: from jhaapako-mobl1.ger.corp.intel.com (HELO intel.com) ([10.251.214.21])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 07:55:16 -0800
Date:   Tue, 6 Dec 2022 16:55:12 +0100
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Matthew Auld <matthew.auld@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris.p.wilson@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v6 1/3] drm/i915/migrate: Account for the reserved_space
Message-ID: <Y49l4EPck4bNJFSF@ashyti-mobl2.lan>
References: <20221202122844.428006-1-matthew.auld@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202122844.428006-1-matthew.auld@intel.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Matt,

On Fri, Dec 02, 2022 at 12:28:42PM +0000, Matthew Auld wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> If the ring is nearly full when calling into emit_pte(), we might
> incorrectly trample the reserved_space when constructing the packet to
> emit the PTEs. This then triggers the GEM_BUG_ON(rq->reserved_space >
> ring->space) when later submitting the request, since the request itself
> doesn't have enough space left in the ring to emit things like
> workarounds, breadcrumbs etc.
> 
> v2: Fix the whitespace errors
> 
> Testcase: igt@i915_selftests@live_emit_pte_full_ring
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7535
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6889
> Fixes: cf586021642d ("drm/i915/gt: Pipelined page migration")
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Signed-off-by: Matthew Auld <matthew.auld@intel.com>
> Cc: Andrzej Hajda <andrzej.hajda@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: Nirmoy Das <nirmoy.das@intel.com>
> Cc: <stable@vger.kernel.org> # v5.15+
> Tested-by: Nirmoy Das <nirmoy.das@intel.com>
> Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Thanks,
Andi
