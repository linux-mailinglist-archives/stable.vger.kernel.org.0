Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7570552E035
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 01:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245647AbiESXBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 19:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243647AbiESXBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 19:01:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166CC24BC2;
        Thu, 19 May 2022 16:01:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0798B828B0;
        Thu, 19 May 2022 23:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D794C385AA;
        Thu, 19 May 2022 23:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653001289;
        bh=omajtcogrQYaXP4cqKjhNTb/VO5d+uoMyeRqV8OjHds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U+sFKkAHVZoDq+648Cf2hd05C5GVSTK7z2SZl5k4GbPlQ1Hk/LG3AO8iVNUKPUfS1
         6lwVDQX4Dd/VcJt/1vvQnOHYWDLSXHTgnbBbWekKhKAhBp+9Xmuty+IF8Z3LCZ+6jE
         31bxfqyBVH/WApZckKys6FFlOmPsm/y2Gj/aCAgw=
Date:   Fri, 20 May 2022 01:01:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mhocko@suse.com, roman.gushchin@linux.dev,
        hannes@cmpxchg.org, shakeelb@google.com
Subject: Re: [PATCH v2] x86/sgx: Set active memcg prior to shmem allocation
Message-ID: <YobMRaJBS1/FsQQG@kroah.com>
References: <20220519210445.5310-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519210445.5310-1-kristen@linux.intel.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
