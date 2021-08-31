Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF653FC946
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 16:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhHaODR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 10:03:17 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:4148 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231199AbhHaODQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Aug 2021 10:03:16 -0400
Received: from bender.morinfr.org (unknown [82.64.86.27])
        by smtp4-g21.free.fr (Postfix) with ESMTPS id 4E8E619F553;
        Tue, 31 Aug 2021 16:01:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
        ; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=55Oic2tBQdEhKwkImI+q3MlSVJdEokDkBiFlL5mk7CE=; b=I7NOqWvE/o4ycQDxccwJ6VSIRI
        wuYlIWSu6fnwBGdndzr70GYLMn5cCo+Lh+/3fsK7B6cgU3buqMNhvK750jiCKE/OvRAya52uzzygb
        G8M31NDV7UKc/a4FzRDqCr4rI3HTgnGxZeVqypWRpxODpj0NYHk0Bt3NIRqTk7Y1A6d0=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.92)
        (envelope-from <guillaume@morinfr.org>)
        id 1mL4Ki-0002Qo-TR; Tue, 31 Aug 2021 16:01:48 +0200
Date:   Tue, 31 Aug 2021 16:01:48 +0200
From:   Guillaume Morin <guillaume@morinfr.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Shakeel Butt <shakeelb@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guillaume Morin <guillaume@morinfr.org>, stable@vger.kernel.org
Subject: Re: [PATCH] hugetlb: fix hugetlb cgroup refcounting during vma split
Message-ID: <20210831140147.GA18648@bender.morinfr.org>
Mail-Followup-To: Mike Kravetz <mike.kravetz@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Shakeel Butt <shakeelb@google.com>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guillaume Morin <guillaume@morinfr.org>, stable@vger.kernel.org
References: <20210830215015.155224-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830215015.155224-1-mike.kravetz@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30 Aug 14:50, Mike Kravetz wrote:
> Guillaume Morin reported hitting the following WARNING followed
> by GPF or NULL pointer deference either in cgroups_destroy or in
> the kill_css path.:
> 
> percpu ref (css_release) <= 0 (-1) after switching to atomic
> WARNING: CPU: 23 PID: 130 at lib/percpu-refcount.c:196 percpu_ref_switch_to_atomic_rcu+0x127/0x130
> CPU: 23 PID: 130 Comm: ksoftirqd/23 Kdump: loaded Tainted: G           O      5.10.60 #1
> RIP: 0010:percpu_ref_switch_to_atomic_rcu+0x127/0x130
> Call Trace:
>  rcu_core+0x30f/0x530
>  rcu_core_si+0xe/0x10
>  __do_softirq+0x103/0x2a2
>  ? sort_range+0x30/0x30
>  run_ksoftirqd+0x2b/0x40
>  smpboot_thread_fn+0x11a/0x170
>  kthread+0x10a/0x140
>  ? kthread_create_worker_on_cpu+0x70/0x70
>  ret_from_fork+0x22/0x30
> 
> Upon further examination, it was discovered that the css structure
> was associated with hugetlb reservations.
> 
> For private hugetlb mappings the vma points to a reserve map that
> contains a pointer to the css.  At mmap time, reservations are set up
> and a reference to the css is taken.  This reference is dropped in the
> vma close operation; hugetlb_vm_op_close.  However, if a vma is split
> no additional reference to the css is taken yet hugetlb_vm_op_close will
> be called twice for the split vma resulting in an underflow.
> 
> Fix by taking another reference in hugetlb_vm_op_open.  Note that the
> reference is only taken for the owner of the reserve map.  In the more
> common fork case, the pointer to the reserve map is cleared for
> non-owning vmas.
> 
> Fixes: e9fe92ae0cd2 ("hugetlb_cgroup: add reservation accounting for
> private mappings")
> Reported-by: Guillaume Morin <guillaume@morinfr.org>
> Suggested-by: Guillaume Morin <guillaume@morinfr.org>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: <stable@vger.kernel.org>

I verified that the patch does fix the underflow. I appreciate the help!

Feel free to add:
Tested-by: Guillaume Morin <guillaume@morinfr.org>

-- 
Guillaume Morin <guillaume@morinfr.org>
