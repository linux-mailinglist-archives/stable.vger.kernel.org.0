Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939F152EF7D
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 17:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350993AbiETPoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 11:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349157AbiETPoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 11:44:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BEB9D067;
        Fri, 20 May 2022 08:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653061457; x=1684597457;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sm6rTxFjZJcJqtXNux3YigLFzIK7e0k9ReiYe3hBU1c=;
  b=XQbtRWnEf7LrEzUXPP/g9dqCG9TbgGLNldJywYiN6hGSCLmo42hlK0M1
   V+6Xre2KP/DKIxHvo4b8V0J+pQYNIQZDPWFeTLNVC0jXUzagF96UQYKo6
   lTmBKJ/z7KEPZmmt+3k2xsrC9wgTsYZWyFDPFk0ZFyuuzk/0PZ59PSwTr
   DVpiBkkkUYGs0mA7vQzGLJOhL6LDCtMTxAxyniFm+kq2tmlNX6nRlJII5
   n8XC8hsjo1MnQZgsjYRyqwyzB02SN7rDCyhRqM12+heQeNR99fZ6sfo8H
   nluHdIH+YEXe5ShYGM62UeSZl1wG6RJ/Qz4yuT/Ma31lJhp7bD+f3n4pO
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="272766035"
X-IronPort-AV: E=Sophos;i="5.91,239,1647327600"; 
   d="scan'208";a="272766035"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 08:44:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,239,1647327600"; 
   d="scan'208";a="546737649"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.209.83.65])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 08:44:15 -0700
Message-ID: <12ba3f76f06d1336d78e4bfe0f36ba83fbf2f2d1.camel@linux.intel.com>
Subject: Re: [PATCH v2] x86/sgx: Set active memcg prior to shmem allocation
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     Shakeel Butt <shakeelb@google.com>
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
Date:   Fri, 20 May 2022 08:44:14 -0700
In-Reply-To: <CALvZod7+LyVDVvkdisSiQLySSnXjK5-VHbAwApE8TrHeUyAFxQ@mail.gmail.com>
References: <20220519210445.5310-1-kristen@linux.intel.com>
         <CALvZod7+LyVDVvkdisSiQLySSnXjK5-VHbAwApE8TrHeUyAFxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-05-19 at 14:22 -0700, Shakeel Butt wrote:
> On Thu, May 19, 2022 at 2:05 PM Kristen Carlson Accardi
> <kristen@linux.intel.com> wrote:
> > When the system runs out of enclave memory, SGX can reclaim EPC
> > pages
> > by swapping to normal RAM. These backing pages are allocated via a
> > per-enclave shared memory area. Since SGX allows unlimited over
> > commit on EPC memory, the reclaimer thread can allocate a large
> > number of backing RAM pages in response to EPC memory pressure.
> > 
> > When the shared memory backing RAM allocation occurs during
> > the reclaimer thread context, the shared memory is charged to
> > the root memory control group, and the shmem usage of the enclave
> > is not properly accounted for, making cgroups ineffective at
> > limiting the amount of RAM an enclave can consume.
> > 
> > For example, when using a cgroup to launch a set of test
> > enclaves, the kernel does not properly account for 50% - 75% of
> > shmem page allocations on average. In the worst case, when
> > nearly all allocations occur during the reclaimer thread, the
> > kernel accounts less than a percent of the amount of shmem used
> > by the enclave's cgroup to the correct cgroup.
> > 
> > SGX stores a list of mm_structs that are associated with
> > an enclave. Pick one of them during reclaim and charge that
> > mm's memcg with the shmem allocation. The one that gets picked
> > is arbitrary, but this list almost always only has one mm. The
> > cases where there is more than one mm with different memcg's
> > are not worth considering.
> > 
> > Create a new function - sgx_encl_alloc_backing(). This function
> > is used whenever a new backing storage page needs to be
> > allocated. Previously the same function was used for page
> > allocation as well as retrieving a previously allocated page.
> > Prior to backing page allocation, if there is a mm_struct
> > associated
> > with the enclave that is requesting the allocation, it is set
> > as the active memory control group.
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> 
> For the memcg part:
> 
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

Thanks!


