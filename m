Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71D052DF2B
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 23:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245144AbiESVWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 17:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245146AbiESVWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 17:22:39 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C0FF74A6
        for <stable@vger.kernel.org>; Thu, 19 May 2022 14:22:38 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a23-20020a17090acb9700b001df4e9f4870so6327791pju.1
        for <stable@vger.kernel.org>; Thu, 19 May 2022 14:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vaIdWn5NisS2gtNC+4QuEM/yuAIO9HPKMDavTWW4Ekc=;
        b=EyHJA8M1GvT4SIkxiah4waFP9OR51GmVpDw//ROU9NH/exnIKANQ9jOXBq+BbXndEC
         eXYB2fi+M3QNst1/gLj+y9bT/ofqyl8ZRSIDPe7mD0VypLwML8AOJInmCUHK/Jb0pZ5w
         LtyvQoGnvfKmtVw4AACmXU2dapqTxa0TnLdSCN1cFwB0vbhD9TYP9ViOKWeTh67Vcv4v
         PkBeIswiPwKKOpWzjRFxhUbqYUvYO2gPikMxYWDj/KwAirf9OmOxML+zjEG3ZqKUe5cH
         OQde/0u95JXdx5PhSwnkK1qVBYulPRsYQS5ARqPaTR50a63X2lkqnedXu7hI5srLtzZg
         Bokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vaIdWn5NisS2gtNC+4QuEM/yuAIO9HPKMDavTWW4Ekc=;
        b=NnIF6JEVSwwNsc4NmLtn5lY/Wlf6hqt7e+yd8+f7sTn/EYJGXXHJ0JEPaL/402aC3X
         wfZfENmsFiRonAIUuCHxdDcQYbw9BAFBA5jD1NFXoKWnEpKUjcFnU6HMz5VUTgSD+GIF
         ZpRMtYL4MfiIif7wRxMsVliWzkhHlptXO3o3PgHKVZO2CoV3ZxAc5naBYhZ7mkwmot9u
         aDW61ZoXo85tpbpMnMP+EidLdDcRlJe6/WvaSFvg+WYZxl3WjJTP2OM1p1SetqwUMJcr
         D0Z+AfOymfz7+Q7Bm9BzTsnRpHh2TzcPdZDrxQsl6xenUEUkkVE6j6iUubbXkBvuhzNJ
         yXiA==
X-Gm-Message-State: AOAM532JfvRVKdrivXCRseGJjjdzsizdw99fe7IuQaa5tkuKQYhwC0RQ
        oaxOX/4KYm2LwAei2ujPVsZcYH5dTuNZ94Oj9mV2jQ==
X-Google-Smtp-Source: ABdhPJz+tdX15lgd8Da2jX/rg521Vunwu7uLMab1OAo0EgYaRfZ2wiGY4e98Cjd5vnaf4I0wXhCbHYWbs161c8m1KPQ=
X-Received: by 2002:a17:902:b094:b0:15c:dee8:74c8 with SMTP id
 p20-20020a170902b09400b0015cdee874c8mr6544695plr.6.1652995357361; Thu, 19 May
 2022 14:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220519210445.5310-1-kristen@linux.intel.com>
In-Reply-To: <20220519210445.5310-1-kristen@linux.intel.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 19 May 2022 14:22:26 -0700
Message-ID: <CALvZod7+LyVDVvkdisSiQLySSnXjK5-VHbAwApE8TrHeUyAFxQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/sgx: Set active memcg prior to shmem allocation
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 2:05 PM Kristen Carlson Accardi
<kristen@linux.intel.com> wrote:
>
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

For the memcg part:

Reviewed-by: Shakeel Butt <shakeelb@google.com>
