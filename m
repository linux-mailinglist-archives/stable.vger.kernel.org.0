Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6CE52E1EC
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 03:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239599AbiETBYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 21:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344195AbiETBYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 21:24:14 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BBD2AC7B;
        Thu, 19 May 2022 18:24:13 -0700 (PDT)
Date:   Thu, 19 May 2022 18:24:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653009850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8dIWBHJuUxrh6Wv36T47A+FcXJPl91XrE218hQx8ro0=;
        b=Vl7farxJ2q0Ic6HJwHmFW9rd1Zuol6JbtjZA9EGtxRUlqjION7Y1jxbPS4XUPWAWo8mRM6
        4NXVVVoXrjcR6/n1Mw0F/TvQnMpjoi4gfsY84Gn4R+GI4sop1Fyx4aGQwKFmGVMZIQIkJe
        +1kasV0MMBMhQXq+l8Y46LT5CKaikPg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mhocko@suse.com, hannes@cmpxchg.org,
        shakeelb@google.com
Subject: Re: [PATCH v2] x86/sgx: Set active memcg prior to shmem allocation
Message-ID: <YobttN5nRMwYbN4I@carbon>
References: <20220519210445.5310-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519210445.5310-1-kristen@linux.intel.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 02:04:45PM -0700, Kristen Carlson Accardi wrote:
> When the system runs out of enclave memory, SGX can reclaim EPC pages
> by swapping to normal RAM. These backing pages are allocated via a
> per-enclave shared memory area. Since SGX allows unlimited over
> commit on EPC memory, the reclaimer thread can allocate a large
> number of backing RAM pages in response to EPC memory pressure.
> 
> When the shared memory backing RAM allocation occurs during
> the reclaimer thread context, the shared memory is charged to
> the root memory control group, and the shmem usage of the enclave
> is not properly accounted for, making cgroups ineffective at
> limiting the amount of RAM an enclave can consume.
> 
> For example, when using a cgroup to launch a set of test
> enclaves, the kernel does not properly account for 50% - 75% of
> shmem page allocations on average. In the worst case, when
> nearly all allocations occur during the reclaimer thread, the
> kernel accounts less than a percent of the amount of shmem used
> by the enclave's cgroup to the correct cgroup.
> 
> SGX stores a list of mm_structs that are associated with
> an enclave. Pick one of them during reclaim and charge that
> mm's memcg with the shmem allocation. The one that gets picked
> is arbitrary, but this list almost always only has one mm. The
> cases where there is more than one mm with different memcg's
> are not worth considering.
> 
> Create a new function - sgx_encl_alloc_backing(). This function
> is used whenever a new backing storage page needs to be
> allocated. Previously the same function was used for page
> allocation as well as retrieving a previously allocated page.
> Prior to backing page allocation, if there is a mm_struct associated
> with the enclave that is requesting the allocation, it is set
> as the active memory control group.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
> V1 -> V2:
>  Changed sgx_encl_set_active_memcg() to simply return the correct
>  memcg for the enclave and renamed to sgx_encl_get_mem_cgroup().
> 
>  Created helper function current_is_ksgxd() to improve readability.
> 
>  Use mmget_not_zero()/mmput_async() when searching mm_list.
> 
>  Move call to set_active_memcg() to sgx_encl_alloc_backing() and
>  use mem_cgroup_put() to avoid leaking a memcg reference.
> 
>  Address review feedback regarding comments and commit log.
> 
>  arch/x86/kernel/cpu/sgx/encl.c | 109 ++++++++++++++++++++++++++++++++-
>  arch/x86/kernel/cpu/sgx/encl.h |  11 +++-
>  arch/x86/kernel/cpu/sgx/main.c |   4 +-
>  3 files changed, 118 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 001808e3901c..6d10202612d6 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -32,7 +32,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  	else
>  		page_index = PFN_DOWN(encl->size);
>  
> -	ret = sgx_encl_get_backing(encl, page_index, &b);
> +	ret = sgx_encl_lookup_backing(encl, page_index, &b);
>  	if (ret)
>  		return ret;
>  
> @@ -574,7 +574,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
>   *   0 on success,
>   *   -errno otherwise.
>   */
> -int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
> +static int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  			 struct sgx_backing *backing)
>  {
>  	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
> @@ -601,6 +601,111 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  	return 0;
>  }
>  
> +/*
> + * When called from ksgxd, returns the mem_cgroup of a struct mm stored
> + * in the enclave's mm_list. When not called from ksgxd, just returns
> + * the mem_cgroup of the current task.
> + */
> +static struct mem_cgroup *sgx_encl_get_mem_cgroup(struct sgx_encl *encl)
> +{
> +	struct mem_cgroup *memcg = NULL;
> +	struct sgx_encl_mm *encl_mm;
> +	int idx;
> +
> +	/*
> +	 * If called from normal task context, return the mem_cgroup
> +	 * of the current task's mm. The remainder of the handling is for
> +	 * ksgxd.
> +	 */
> +	if (!current_is_ksgxd())
> +		return get_mem_cgroup_from_mm(current->mm);
> +
> +	/*
> +	 * Search the enclave's mm_list to find an mm associated with
> +	 * this enclave to charge the allocation to.
> +	 */
> +	idx = srcu_read_lock(&encl->srcu);
> +
> +	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> +		if (!mmget_not_zero(encl_mm->mm))
> +			continue;
> +
> +		memcg = get_mem_cgroup_from_mm(encl_mm->mm);
> +
> +		mmput_async(encl_mm->mm);
> +
> +		break;
> +	}
> +
> +	srcu_read_unlock(&encl->srcu, idx);
> +
> +	/*
> +	 * In the rare case that there isn't an mm associated with
> +	 * the enclave, set memcg to the current active mem_cgroup.
> +	 * This will be the root mem_cgroup if there is no active
> +	 * mem_cgroup.
> +	 */
> +	if (!memcg)
> +		return get_mem_cgroup_from_mm(NULL);
> +
> +	return memcg;
> +}


You can simplify the function a bit. But it's up to you, not a strong
opinion.

static struct mem_cgroup *sgx_encl_get_mem_cgroup(struct sgx_encl *encl)
{
	struct mem_cgroup *memcg = NULL;
	struct sgx_encl_mm *encl_mm;
	int idx;

	if (current_is_ksgxd()) {
		/*
		 * Search the enclave's mm_list to find an mm associated with
		 * this enclave to charge the allocation to.
		 */
		idx = srcu_read_lock(&encl->srcu);
		list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
			if (!mmget_not_zero(encl_mm->mm))
				continue;

			memcg = get_mem_cgroup_from_mm(encl_mm->mm);
			mmput_async(encl_mm->mm);
			break;
		}
		srcu_read_unlock(&encl->srcu, idx);
	}

	return memcg ? memcg : get_mem_cgroup_from_mm(current->mm);
}

--

The rest of the patch looks good to me. Please, feel free to add:

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
