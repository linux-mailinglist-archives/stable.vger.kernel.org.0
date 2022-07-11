Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC9F57058C
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 16:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiGKO1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 10:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGKO1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 10:27:47 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238F83E777;
        Mon, 11 Jul 2022 07:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657549667; x=1689085667;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=N/5+FOmUbjUHJKfvtD9I2r0cQTVjN/Gvm2Dt7WX01LM=;
  b=L2fOLDwSIael7qTpTOJD7hEcZuRqUaCwhKBq+3kkdAGF43tz8o+66eBu
   TYWqS4UhicDsXpTdQ6eNkxOot4lowsHOIpn1BghFl563Rbv7zafdnOK+v
   bB9xYCeu22HEL1b+1bAkNGjOA+bWHj97ConZLAfnh41YhUtVag7nLmC2r
   iAOL7GWif4BYMDCpPUhNRW+GojlTOM1x0OtlGPCf68/99mpuUZPSo73tt
   c+9CPRORAQeDHd+oDm8iv4T4P7JlKVHdzmUF6T4AiGJkSrLCeQdsHtK4X
   RwzpW+JZ0rviFbGnEOe2LEgeEYrTPYp89RgFrNz9HI0m2NR+XXcJH5Rto
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="267713289"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="267713289"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 07:27:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="721614482"
Received: from tzanussi-mobl4.amr.corp.intel.com (HELO [10.209.163.145]) ([10.209.163.145])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 07:27:45 -0700
Message-ID: <7b562ff6-3f44-053b-d8e6-3c40be145446@linux.intel.com>
Date:   Mon, 11 Jul 2022 09:27:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] tracing/histograms: Fix memory leak problem
To:     Zheng Yejian <zhengyejian1@huawei.com>, rostedt@goodmis.org
Cc:     linux-kernel@vger.kernel.org, mingo@redhat.com,
        stable@vger.kernel.org, trix@redhat.com, zhangjinhao2@huawei.com
References: <20220708210335.79a38356@gandalf.local.home>
 <20220711014731.69520-1-zhengyejian1@huawei.com>
From:   "Zanussi, Tom" <tom.zanussi@linux.intel.com>
In-Reply-To: <20220711014731.69520-1-zhengyejian1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Yejian,

On 7/10/2022 8:47 PM, Zheng Yejian wrote:
> This reverts commit 46bbe5c671e06f070428b9be142cc4ee5cedebac.
> 
> As commit 46bbe5c671e0 ("tracing: fix double free") said, the
> "double free" problem reported by clang static analyzer is:
>   > In parse_var_defs() if there is a problem allocating
>   > var_defs.expr, the earlier var_defs.name is freed.
>   > This free is duplicated by free_var_defs() which frees
>   > the rest of the list.
> 
> However, if there is a problem allocating N-th var_defs.expr:
>   + in parse_var_defs(), the freed 'earlier var_defs.name' is
>     actually the N-th var_defs.name;
>   + then in free_var_defs(), the names from 0th to (N-1)-th are freed;
> 
>                         IF ALLOCATING PROBLEM HAPPENED HERE!!! -+
>                                                                  \
>                                                                   |
>           0th           1th                 (N-1)-th      N-th    V
>           +-------------+-------------+-----+-------------+-----------
> var_defs: | name | expr | name | expr | ... | name | expr | name | ///
>           +-------------+-------------+-----+-------------+-----------
> 
> These two frees don't act on same name, so there was no "double free"
> problem before. Conversely, after that commit, we get a "memory leak"
> problem because the above "N-th var_defs.name" is not freed.

Good catch, thanks for fixing it.

So I'm wondering if this means that that the original unnecessary bugfix
was based on a bug in the clang static analyzer or if that would just be
considered a false positive...

Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>

Tom  

> 
> If enable CONFIG_DEBUG_KMEMLEAK and inject a fault at where the N-th
> var_defs.expr allocated, then execute on shell like:
>   $ echo 'hist:key=call_site:val=$v1,$v2:v1=bytes_req,v2=bytes_alloc' > \
> /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
> 
> Then kmemleak reports:
>   unreferenced object 0xffff8fb100ef3518 (size 8):
>     comm "bash", pid 196, jiffies 4295681690 (age 28.538s)
>     hex dump (first 8 bytes):
>       76 31 00 00 b1 8f ff ff                          v1......
>     backtrace:
>       [<0000000038fe4895>] kstrdup+0x2d/0x60
>       [<00000000c99c049a>] event_hist_trigger_parse+0x206f/0x20e0
>       [<00000000ae70d2cc>] trigger_process_regex+0xc0/0x110
>       [<0000000066737a4c>] event_trigger_write+0x75/0xd0
>       [<000000007341e40c>] vfs_write+0xbb/0x2a0
>       [<0000000087fde4c2>] ksys_write+0x59/0xd0
>       [<00000000581e9cdf>] do_syscall_64+0x3a/0x80
>       [<00000000cf3b065c>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> Cc: stable@vger.kernel.org
> Fixes: 46bbe5c671e0 ("tracing: fix double free")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> ---
>  kernel/trace/trace_events_hist.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> Changes since v1:
> - Assign 'NULL' after 'kfree' for safety as suggested by Steven
> - Rename commit title and add Suggested-by tag
> 
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index 48e82e141d54..e87a46794079 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -4430,6 +4430,8 @@ static int parse_var_defs(struct hist_trigger_data *hist_data)
>  
>  			s = kstrdup(field_str, GFP_KERNEL);
>  			if (!s) {
> +				kfree(hist_data->attrs->var_defs.name[n_vars]);
> +				hist_data->attrs->var_defs.name[n_vars] = NULL;
>  				ret = -ENOMEM;
>  				goto free;
>  			}
