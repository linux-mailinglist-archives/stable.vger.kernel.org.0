Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2387050DA1D
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 09:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbiDYHdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 03:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiDYHdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 03:33:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF059BF47;
        Mon, 25 Apr 2022 00:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650871816; x=1682407816;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v33AZ1EXAwq6WXUADhV0AAEUbQzxeq80/j/EQgk+qSk=;
  b=GcLe6cA8Oz831plPs1tKGai0rsyJvaxL+HIzHF4pm9QbxwB0/5Ph1bfZ
   hONxxu9hwQKzBUnT0nttmD5ToYxpvD4A4w8N0vsSnElYu4g2MFyl8HQuz
   0F9zT6WCWGaLe3EeMDOrFtcuVBYOpMBbH4tUwe35qevbZT7diowiwsTC9
   fqKuo0fln+m81N/eXOis7juto9TUTpZRcsngXAroNhAk1c94oJXuMipsG
   KKoTYi5VfKlCusJwPWU9qOGBFVujF+M31WHTvT/y1oGstXFxy1Cmu9r/l
   a/xq14s6yZjdCw+ir0Ol7J1G8ZBwoXwqMA0FutDH/hMh4+LFAr14bg729
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10327"; a="325656067"
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="325656067"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 00:30:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="531983853"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by orsmga006.jf.intel.com with ESMTP; 25 Apr 2022 00:30:12 -0700
Date:   Mon, 25 Apr 2022 15:30:11 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Waiman Long <longman@redhat.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, ying.huang@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: Remove redundant cpu/node masks setup in
 cpuset_init_smp()
Message-ID: <20220425073011.GJ46405@shbuild999.sh.intel.com>
References: <20220425020926.1264611-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425020926.1264611-1-longman@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Waiman,

Thanks for the patch!

On Sun, Apr 24, 2022 at 10:09:26PM -0400, Waiman Long wrote:
> There are 3 places where the cpu and node masks of the top cpuset can
> be initialized in the order they are executed:
>  1) start_kernel -> cpuset_init()
>  2) start_kernel -> cgroup_init() -> cpuset_bind()
>  3) kernel_init_freeable() -> do_basic_setup() -> cpuset_init_smp()
> 
> The first cpuset_init() function just sets all the bits in the masks.
> The last one executed is cpuset_init_smp() which sets up cpu and node
> masks suitable for v1, but not v2.  cpuset_bind() does the right setup
> for both v1 and v2 assuming that effective_mems and effective_cpus have
> been set up properly which is not strictly the case here. As a result,
> cpu and memory node hot add may fail to update the cpu and node masks
> of the top cpuset to include the newly added cpu or node in a cgroup
> v2 environment.
> 
> To fix this problem, the redundant cpus_allowed and mems_allowed
> mask setup in cpuset_init_smp() are removed. The effective_cpus and
> effective_mems setup there are moved to cpuset_bind().
> 
> cc: stable@vger.kernel.org
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 9390bfd9f1cd..a2e15a43397e 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2961,6 +2961,9 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
>  	percpu_down_write(&cpuset_rwsem);
>  	spin_lock_irq(&callback_lock);
>  
> +	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
> +	top_cpuset.effective_mems = node_states[N_MEMORY];
> +
>  	if (is_in_v2_mode()) {
>  		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
>  		top_cpuset.mems_allowed = node_possible_map;
> @@ -3390,13 +3393,6 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
>   */
>  void __init cpuset_init_smp(void)
>  {
> -	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
> -	top_cpuset.mems_allowed = node_states[N_MEMORY];
> -	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
> -
> -	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
> -	top_cpuset.effective_mems = node_states[N_MEMORY];

IIUC, the init order is:
	cpuset_bind()
	smp_init()
	cpuset_init_smp()

while all cpus except boot cpu is brought up in smp_init(), so I'm
thinking moving the cpus_allowed init from cpuset_init_smp() to
cpuset_bind() may cause some problem.

Thanks,
Feng
