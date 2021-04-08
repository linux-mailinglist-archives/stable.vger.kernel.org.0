Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBAC358F4A
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 23:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhDHViD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 17:38:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:55548 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232404AbhDHViD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Apr 2021 17:38:03 -0400
IronPort-SDR: cPWbDu6A/RZQbXA33ZaULKlI51bdbnX9OlyLKL5gAWwIbhaBb6bAGZLSsiWQq+aAQzDbH8a7a8
 shygouTW8ogw==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="254971705"
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="254971705"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 14:37:51 -0700
IronPort-SDR: liih20CqRgUu+I/aveZgYLoxeabzKmjS+ppLcW32yCEPAhtje/pIeqKdYSlT1GBgoz7G15hIK8
 0vh8guKWsDXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="448815701"
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Apr 2021 14:37:50 -0700
Date:   Thu, 8 Apr 2021 14:36:40 -0700
From:   Alison Schofield <alison.schofield@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>, brice.goglin@gmail.com
Subject: Re: [PATCH v3] x86, sched: Treat Intel SNC topology as default, COD
 as exception
Message-ID: <20210408213640.GA24727@alison-desk.jf.intel.com>
References: <20210310190233.31752-1-alison.schofield@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310190233.31752-1-alison.schofield@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ping - any feedback?
Thanks!

On Wed, Mar 10, 2021 at 11:02:33AM -0800, Alison Schofield wrote:
> Commit 1340ccfa9a9a ("x86,sched: Allow topologies where NUMA nodes
> share an LLC") added a vendor and model specific check to never
> call topology_sane() for Intel Skylake Server systems where NUMA
> nodes share an LLC.
> 
> Intel Ice Lake and Sapphire Rapids CPUs also enumerate an LLC that is
> shared by multiple NUMA nodes. The LLC on these CPUs is shared for
> off-package data access but private to the NUMA node for on-package
> access. Rather than managing a list of allowable SNC topologies, make
> this SNC topology the default, and treat Intel's Cluster-On-Die (COD)
> topology as the exception.
> 
> In SNC mode, Sky Lake, Ice Lake, and Sapphire Rapids servers do not
> emit this warning:
> 
> sched: CPU #3's llc-sibling CPU #0 is not on the same node! [node: 1 != 0]. Ignoring dependency.
> 
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Cc: stable@vger.kernel.org
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@linux.intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: brice.goglin@gmail.com
> ---
> 
> Changes v2->v3:
> - This is a v3 of this patch: https://lore.kernel.org/lkml/20210216195804.24204-1-alison.schofield@intel.com/
> - Implemented PeterZ suggestion, and his code, to check for COD instead
>   of SNC.
> - Updated commit message and log.
> - Added 'Cc stable.
> 
> Changes v1->v2:
> - Implemented the minimal required change of adding the new models to
>   the existing vendor and model specific check.
> 
> - Side effect of going minimalist: no longer labelled an X86_BUG (TonyL)
> 
> - Considered PeterZ suggestion of checking for COD CPUs, rather than
>   SNC CPUs. That meant this snc_cpu list would go away, and so it never
>   needs updating. That ups the stakes for this patch wrt LOC changed
>   and testing needed. It actually drove me back to this simplest soln.
> 
> - Considered DaveH suggestion to remove the check altogether and recognize
>   these topologies as sane. Not running with that further here. This patch
>   is what is needed now. The broader discussion of sane topologies can
>   carry on independent of this update.
> 
> - Updated commit message and log.
> 
> 
>  arch/x86/kernel/smpboot.c | 90 ++++++++++++++++++++-------------------
>  1 file changed, 46 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 02813a7f3a7c..147b2f3a2a09 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -458,29 +458,52 @@ static bool match_smt(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
>  	return false;
>  }
>  
> +static bool match_die(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
> +{
> +	if (c->phys_proc_id == o->phys_proc_id &&
> +	    c->cpu_die_id == o->cpu_die_id)
> +		return true;
> +	return false;
> +}
> +
> +/*
> + * Unlike the other levels, we do not enforce keeping a
> + * multicore group inside a NUMA node.  If this happens, we will
> + * discard the MC level of the topology later.
> + */
> +static bool match_pkg(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
> +{
> +	if (c->phys_proc_id == o->phys_proc_id)
> +		return true;
> +	return false;
> +}
> +
>  /*
> - * Define snc_cpu[] for SNC (Sub-NUMA Cluster) CPUs.
> + * Define intel_cod_cpu[] for Intel COD (Cluster-on-Die) CPUs.
>   *
> - * These are Intel CPUs that enumerate an LLC that is shared by
> - * multiple NUMA nodes. The LLC on these systems is shared for
> - * off-package data access but private to the NUMA node (half
> - * of the package) for on-package access.
> + * Any Intel CPU that has multiple nodes per package and does not
> + * match intel_cod_cpu[] has the SNC (Sub-NUMA Cluster) topology.
>   *
> - * CPUID (the source of the information about the LLC) can only
> - * enumerate the cache as being shared *or* unshared, but not
> - * this particular configuration. The CPU in this case enumerates
> - * the cache to be shared across the entire package (spanning both
> - * NUMA nodes).
> + * When in SNC mode, these CPUs enumerate an LLC that is shared
> + * by multiple NUMA nodes. The LLC is shared for off-package data
> + * access but private to the NUMA node (half of the package) for
> + * on-package access. CPUID (the source of the information about
> + * the LLC) can only enumerate the cache as shared or unshared,
> + * but not this particular configuration.
>   */
>  
> -static const struct x86_cpu_id snc_cpu[] = {
> -	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X, NULL),
> +static const struct x86_cpu_id intel_cod_cpu[] = {
> +	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X, 0),	/* COD */
> +	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X, 0),	/* COD */
> +	X86_MATCH_INTEL_FAM6_MODEL(ANY, 1),		/* SNC */
>  	{}
>  };
>  
>  static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
>  {
> +	const struct x86_cpu_id *id = x86_match_cpu(intel_cod_cpu);
>  	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
> +	bool intel_snc = id && id->driver_data;
>  
>  	/* Do not match if we do not have a valid APICID for cpu: */
>  	if (per_cpu(cpu_llc_id, cpu1) == BAD_APICID)
> @@ -495,32 +518,12 @@ static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
>  	 * means 'c' does not share the LLC of 'o'. This will be
>  	 * reflected to userspace.
>  	 */
> -	if (!topology_same_node(c, o) && x86_match_cpu(snc_cpu))
> +	if (match_pkg(c, o) && !topology_same_node(c, o) && intel_snc)
>  		return false;
>  
>  	return topology_sane(c, o, "llc");
>  }
>  
> -/*
> - * Unlike the other levels, we do not enforce keeping a
> - * multicore group inside a NUMA node.  If this happens, we will
> - * discard the MC level of the topology later.
> - */
> -static bool match_pkg(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
> -{
> -	if (c->phys_proc_id == o->phys_proc_id)
> -		return true;
> -	return false;
> -}
> -
> -static bool match_die(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
> -{
> -	if ((c->phys_proc_id == o->phys_proc_id) &&
> -		(c->cpu_die_id == o->cpu_die_id))
> -		return true;
> -	return false;
> -}
> -
>  
>  #if defined(CONFIG_SCHED_SMT) || defined(CONFIG_SCHED_MC)
>  static inline int x86_sched_itmt_flags(void)
> @@ -592,14 +595,23 @@ void set_cpu_sibling_map(int cpu)
>  	for_each_cpu(i, cpu_sibling_setup_mask) {
>  		o = &cpu_data(i);
>  
> +		if (match_pkg(c, o) && !topology_same_node(c, o))
> +			x86_has_numa_in_package = true;
> +
>  		if ((i == cpu) || (has_smt && match_smt(c, o)))
>  			link_mask(topology_sibling_cpumask, cpu, i);
>  
>  		if ((i == cpu) || (has_mp && match_llc(c, o)))
>  			link_mask(cpu_llc_shared_mask, cpu, i);
>  
> +		if ((i == cpu) || (has_mp && match_die(c, o)))
> +			link_mask(topology_die_cpumask, cpu, i);
>  	}
>  
> +	threads = cpumask_weight(topology_sibling_cpumask(cpu));
> +	if (threads > __max_smt_threads)
> +		__max_smt_threads = threads;
> +
>  	/*
>  	 * This needs a separate iteration over the cpus because we rely on all
>  	 * topology_sibling_cpumask links to be set-up.
> @@ -613,8 +625,7 @@ void set_cpu_sibling_map(int cpu)
>  			/*
>  			 *  Does this new cpu bringup a new core?
>  			 */
> -			if (cpumask_weight(
> -			    topology_sibling_cpumask(cpu)) == 1) {
> +			if (threads == 1) {
>  				/*
>  				 * for each core in package, increment
>  				 * the booted_cores for this new cpu
> @@ -631,16 +642,7 @@ void set_cpu_sibling_map(int cpu)
>  			} else if (i != cpu && !c->booted_cores)
>  				c->booted_cores = cpu_data(i).booted_cores;
>  		}
> -		if (match_pkg(c, o) && !topology_same_node(c, o))
> -			x86_has_numa_in_package = true;
> -
> -		if ((i == cpu) || (has_mp && match_die(c, o)))
> -			link_mask(topology_die_cpumask, cpu, i);
>  	}
> -
> -	threads = cpumask_weight(topology_sibling_cpumask(cpu));
> -	if (threads > __max_smt_threads)
> -		__max_smt_threads = threads;
>  }
>  
>  /* maps the cpu to the sched domain representing multi-core */
> -- 
> 2.20.1
> 
