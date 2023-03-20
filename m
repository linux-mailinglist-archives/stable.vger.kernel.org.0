Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C776C1CDE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 17:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbjCTQxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 12:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjCTQws (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 12:52:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16A935B7;
        Mon, 20 Mar 2023 09:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679330679; x=1710866679;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VWMmKe8dB+OCRGaP8uSzxpVD7Giih1Qhtp6CldTlh6E=;
  b=g4wa/+HcM2S7SBAGAQdQqmsfO8xZRNAZuRsXOa5BiCJ097Y+a4HYvVLx
   Gm7V6ip92Dd05X2yPz/qbO2HfnZwlLEawtg1g1YI3mdzYjBvBSRflYns0
   WLbvvuhBaL9cFnaTY51C0mGkv/CS0JpnMMOLN1bB3BvSjUw0Qrg5jQ9N0
   7KHW0zjtARWR7MQ10ckP6YzCNP0viL2xS3fs5lqZmanmafGAq3BPK+jMd
   VOoJu9pG/Ed8OieWWoyUyESNOZD62Ks2asDZp6+Rtfn+4hJayohA2P4AI
   s0bFyUMiDsJxmuuPIlUlr8f+R5cZLrXyeQzy+a+yuJ2k0abYAAv85a9Nh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="366433606"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="366433606"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 09:44:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="824547056"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="824547056"
Received: from vrchili-mobl2.amr.corp.intel.com (HELO [10.209.117.85]) ([10.209.117.85])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 09:44:05 -0700
Message-ID: <2b1b5ded-522f-1fcf-6daa-354796bedb74@intel.com>
Date:   Mon, 20 Mar 2023 09:44:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] x86/cacheinfo: Define per-CPU num_cache_leaves
Content-Language: en-US
To:     Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        x86@kernel.org
Cc:     Ricardo Neri <ricardo.neri@intel.com>,
        linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Chen Yu <yu.c.chen@intel.com>,
        stable@vger.kernel.org
References: <20230314231658.30169-1-ricardo.neri-calderon@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230314231658.30169-1-ricardo.neri-calderon@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/14/23 16:16, Ricardo Neri wrote:
> -static unsigned short num_cache_leaves;
> +static DEFINE_PER_CPU(unsigned short, num_cache_leaves);
> +
> +static inline unsigned short get_num_cache_leaves(unsigned int cpu)
> +{
> +	return per_cpu(num_cache_leaves, cpu);
> +}

I know it's in generic code, but we do already have this:

static DEFINE_PER_CPU(struct cpu_cacheinfo, ci_cpu_cacheinfo);

which has a num_leaves in it:

struct cpu_cacheinfo {
        struct cacheinfo *info_list;
        unsigned int num_levels;
        unsigned int num_leaves;
        bool cpu_map_populated;
};

That's currently _populated_ from the arch code that you are modifying.
Do we really need this data stored identically in two different per-cpu
locations?

I'd also love to hear some more background on "Intel Meteor Lake" and
_why_ it has an asymmetric cache topology.
