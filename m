Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7F76C74CA
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 01:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjCXA47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 20:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCXA47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 20:56:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BA3199D6;
        Thu, 23 Mar 2023 17:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679619418; x=1711155418;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tfCFzHtoYhPDMNyF0OvUPDP5DF5D0hdEmFTrK9vJ/Yk=;
  b=UsRhfFhu864TrtRVw5ETvsBTXz/NNoet5ZlRAyqmsypxl9cO/IzVnB1+
   1Hwanb/F+p17RKDWiyk9x7lkm048ISP1kaxaZ5il3H4T8C2s1ID0FPKdp
   L1faiKPTY3Q8BlfPHYCXl8UAA/UesHtBR46zU35xAA3uWzPfq4DBbayAD
   uEAwB/5S6qO7E0JSQ5SsL76U/y1DL0X+lvd6OzoA5AG0BmesWknNHDMkV
   wlylOQnvubtF3CJq2kz6DzR0MYAvKwI+uMByP7SCwnWttxF1GfqyqtDUQ
   dRM6hizhRjx61A0yJzz7l4XUnXTeZX+ZewQI1jsHRnQPCKU/aI8uplI1P
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="342050855"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="342050855"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 17:56:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="806471132"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="806471132"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by orsmga004.jf.intel.com with ESMTP; 23 Mar 2023 17:56:55 -0700
Date:   Thu, 23 Mar 2023 18:07:26 -0700
From:   Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, Ricardo Neri <ricardo.neri@intel.com>,
        linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Chen Yu <yu.c.chen@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/cacheinfo: Define per-CPU num_cache_leaves
Message-ID: <20230324010726.GA7459@ranerica-svr.sc.intel.com>
References: <20230314231658.30169-1-ricardo.neri-calderon@linux.intel.com>
 <2b1b5ded-522f-1fcf-6daa-354796bedb74@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b1b5ded-522f-1fcf-6daa-354796bedb74@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 09:44:04AM -0700, Dave Hansen wrote:
> On 3/14/23 16:16, Ricardo Neri wrote:
> > -static unsigned short num_cache_leaves;
> > +static DEFINE_PER_CPU(unsigned short, num_cache_leaves);
> > +
> > +static inline unsigned short get_num_cache_leaves(unsigned int cpu)
> > +{
> > +	return per_cpu(num_cache_leaves, cpu);
> > +}

Thank you very much for your feedback Dave!

> 
> I know it's in generic code, but we do already have this:
> 
> static DEFINE_PER_CPU(struct cpu_cacheinfo, ci_cpu_cacheinfo);
> 
> which has a num_leaves in it:
> 
> struct cpu_cacheinfo {
>         struct cacheinfo *info_list;
>         unsigned int num_levels;
>         unsigned int num_leaves;
>         bool cpu_map_populated;
> };
> 
> That's currently _populated_ from the arch code that you are modifying.
> Do we really need this data stored identically in two different per-cpu
> locations?

That is a good observation. As you state, the ci_cpu_cacheinfo is already
initialized in the arch code. I can certainly modify the patch to make use
of it instead adding a new per-CPU variable.

> 
> I'd also love to hear some more background on "Intel Meteor Lake" and
> _why_ it has an asymmetric cache topology.

Meteor Lake has cores in more than one die. The cache to which these cores
are connected is different in each die. This is reflected in CPUID leaf 4.

Thanks and BR,
Ricardo
