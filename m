Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A82256955C
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 00:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiGFWeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 18:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiGFWeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 18:34:17 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6788217071;
        Wed,  6 Jul 2022 15:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657146854; x=1688682854;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y009AxbqUawkHpqJbAAqpzeVgeaxIAMYGS73GgQJgqg=;
  b=FAS0ULx99j5UwtSYOg1+JfMFyTg0lHnwg8jMP3JSKyhudxQfP5mklele
   tp8cBXwD8VvQMl2T8RgC1HRJM7N7p1UPT5GCCb+2aLHUzDhNai/UdL1MM
   yO/zBhs39SFXdkXrAadOuWG1s7GODgNmZ1G4Y9k5zWGdagx3yVung/KHl
   W+rb1PWmEg0z6gX+HUoWpVyHEYw/cuFijRgaAEhLbNd6jGqVzgh6/lKUu
   A0FbjvVfZSSeLBYE0FTEEGY9MEAQ0kZFmmS8lKI7SCBfoPLQL3KuETcWe
   GNcdhaNsR3A6CjFtywEwwNnrdL01COd/XuppG1/dpBP6sYWxU40sIC2Vi
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="345571783"
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="345571783"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 15:34:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="650868414"
Received: from mropara-mobl1.ger.corp.intel.com (HELO intel.com) ([10.252.49.154])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 15:34:11 -0700
Date:   Thu, 7 Jul 2022 00:34:08 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Andi Shyti <andi.shyti@linux.intel.com>
Cc:     Intel GFX <intel-gfx@lists.freedesktop.org>,
        DRI Devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Stable <stable@vger.kernel.org>,
        Mark Janes <mark.janes@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH] drm/i915/gem: Really move i915_gem_context.link under
 ref protection
Message-ID: <YsYN4OMKanJMPcjv@alfio.lan>
References: <20220706152924.73926-1-andi.shyti@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706152924.73926-1-andi.shyti@linux.intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[...]

> @@ -1265,10 +1264,15 @@ static void i915_gem_context_release_work(struct work_struct *work)
>  	struct i915_gem_context *ctx = container_of(work, typeof(*ctx),
>  						    release_work);
>  	struct i915_address_space *vm;
> +	unsigned long flags;
>  
>  	trace_i915_context_free(ctx);
>  	GEM_BUG_ON(!i915_gem_context_is_closed(ctx));
>  
> +	spin_lock_irqsave(&ctx->i915->gem.contexts.lock, flags);
> +	list_del(&ctx->link);
> +	spin_unlock_irqrestore(&ctx->i915->gem.contexts.lock, flags);
> +

yah! this can't work from a worker.

Andi
