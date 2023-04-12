Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D6F6DF254
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 12:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjDLK5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 06:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjDLK5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 06:57:01 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00D37283
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 03:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681297019; x=1712833019;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=eAVhAyKlWSfWcuwpRUyUn3dwT8yYviAi7Ud2w47dyfw=;
  b=ZmuRnfe9dMlhhTLUr5lmHEXxm+I5duRov29C1aeT9R+qSuvvjLhFp9Ht
   iNKgg0TvEDV6DET9X9PIgpxXTGKcarx2oHj6Thl2WzSAHGY8cQWJ/iVyB
   +jvn/+bpebBXg2qYnpn1XYeOLpWXzF+F8yEUgL+NuU4NBNDNNhcQ+ZlFN
   /7HJg7/BReqDKcWduSKmVwAQlYS1wMOG6+uykijNLAX/lkxfXorzadPDV
   hSkf8rSwwQL/wqvadlUTqxXeOnOgbrkgiwUAXShOsN98Y4dywoM0Z332i
   xNgSqEIUR/RvmWQg6yXtJXubKDjB1heflyuz0g85HC4AmI6Zlom2rrbDl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="327971807"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="327971807"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 03:56:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="682451053"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="682451053"
Received: from zbiro-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.212.144])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 03:56:54 -0700
Date:   Wed, 12 Apr 2023 12:56:26 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     "Das, Nirmoy" <nirmoy.das@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, Andi Shyti <andi.shyti@kernel.org>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>
Subject: Re: [Intel-gfx] [PATCH v4 5/5] drm/i915/gt: Make sure that errors
 are propagated through request chains
Message-ID: <ZDaOWhKiG5jD7ftp@ashyti-mobl2.lan>
References: <20230308094106.203686-1-andi.shyti@linux.intel.com>
 <20230308094106.203686-6-andi.shyti@linux.intel.com>
 <1bee29d0-a5cc-9ff3-d164-f162259558e2@intel.com>
 <ZDVwMawvlOLZ2VZt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZDVwMawvlOLZ2VZt@intel.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Rodrigo,

> > > Currently, when we perform operations such as clearing or copying
> > > large blocks of memory, we generate multiple requests that are
> > > executed in a chain.
> > > 
> > > However, if one of these requests fails, we may not realize it
> > > unless it happens to be the last request in the chain. This is
> > > because errors are not properly propagated.
> > > 
> > > For this we need to keep propagating the chain of fence
> > > notification in order to always reach the final fence associated
> > > to the final request.
> > > 
> > > To address this issue, we need to ensure that the chain of fence
> > > notifications is always propagated so that we can reach the final
> > > fence associated with the last request. By doing so, we will be
> > > able to detect any memory operation  failures and determine
> > > whether the memory is still invalid.
> > > 
> > > On copy and clear migration signal fences upon completion.
> > > 
> > > On copy and clear migration, signal fences upon request
> > > completion to ensure that we have a reliable perpetuation of the
> > > operation outcome.
> > > 
> > > Fixes: cf586021642d80 ("drm/i915/gt: Pipelined page migration")
> > > Reported-by: Matthew Auld <matthew.auld@intel.com>
> > > Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> > > Cc: stable@vger.kernel.org
> > > Reviewed-by: Matthew Auld <matthew.auld@intel.com>
> > With  Matt's comment regarding missing lock in intel_context_migrate_clear
> > addressed, this is:
> > 
> > Acked-by: Nirmoy Das <nirmoy.das@intel.com>
> 
> Nack!
> 
> Please get some ack from Joonas or Tvrtko before merging this series.

There is no architectural change... of course, Joonas and Tvrtko
are more than welcome (and actually invited) to look into this
patch.

And, btw, there are still some discussions ongoing on this whole
series, so that I'm not going to merge it any time soon. I'm just
happy to revive the discussion.

> It is a big series targeting stable o.O where the revisions in the cover
> letter are not helping me to be confident that this is the right approach
> instead of simply reverting the original offending commit:
> 
> cf586021642d ("drm/i915/gt: Pipelined page migration")

Why should we remove all the migration completely? What about the
copy?

> It looks to me that we are adding magic on top of magic to workaround
> the deadlocks, but then adding more waits inside locks... And this with
> the hang checks vs heartbeats, is this really an issue on current upstream
> code? or was only on DII?

There is no real magic happening here. It's just that the error
message was not reaching the end of the operation while this
patch is passing it over.

> Where was the bug report to start with?

Matt has reported this, I will give to you the necessary links to
it offline.

Thanks for looking into this,
Andi
