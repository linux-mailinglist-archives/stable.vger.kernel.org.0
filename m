Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A99295E3D
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 14:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898045AbgJVMV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 08:21:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31024 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503993AbgJVMVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 08:21:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603369284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=euAFIBXlvXDybxKcUe+tcQ4NLZzwD/QgxcNGj7ZymUE=;
        b=Y/0Q1YiWBX2uw7dOMa1Z12Bty/HjGI243quu9WsoCQ0j2P23d89MbBBFjhw2P8PX9bwiHm
        Nr0hHFamesirlHoXkdZ4EGNpEwPCP0ZWcgkivbjGIgIPwEki3KQ3xITV8D9M9sFDHRAMfh
        vXoK8OgY6qLuOt0ViOVorJP34JndMr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-3qAsfDymPuu52pwRmY_ejg-1; Thu, 22 Oct 2020 08:21:20 -0400
X-MC-Unique: 3qAsfDymPuu52pwRmY_ejg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F2E5188C126;
        Thu, 22 Oct 2020 12:21:18 +0000 (UTC)
Received: from redhat.com (ovpn-113-117.ams2.redhat.com [10.36.113.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDA305B4A3;
        Thu, 22 Oct 2020 12:21:10 +0000 (UTC)
Date:   Thu, 22 Oct 2020 08:21:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Mina Almasry <almasrymina@google.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] hugetlb_cgroup: fix reservation accounting
Message-ID: <20201022081538-mutt-send-email-mst@kernel.org>
References: <20201021204426.36069-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021204426.36069-1-mike.kravetz@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 21, 2020 at 01:44:26PM -0700, Mike Kravetz wrote:
> Michal Privoznik was using "free page reporting" in QEMU/virtio-balloon
> with hugetlbfs and hit the warning below.  QEMU with free page hinting
> uses fallocate(FALLOC_FL_PUNCH_HOLE) to discard pages that are reported
> as free by a VM. The reporting granularity is in pageblock granularity.
> So when the guest reports 2M chunks, we fallocate(FALLOC_FL_PUNCH_HOLE)
> one huge page in QEMU.
> 
> [  315.251417] ------------[ cut here ]------------
> [  315.251424] WARNING: CPU: 7 PID: 6636 at mm/page_counter.c:57 page_counter_uncharge+0x4b/0x50
> [  315.251425] Modules linked in: ...
> [  315.251466] CPU: 7 PID: 6636 Comm: qemu-system-x86 Not tainted 5.9.0 #137
> [  315.251467] Hardware name: Gigabyte Technology Co., Ltd. X570 AORUS PRO/X570 AORUS PRO, BIOS F21 07/31/2020
> [  315.251469] RIP: 0010:page_counter_uncharge+0x4b/0x50
> ...
> [  315.251479] Call Trace:
> [  315.251485]  hugetlb_cgroup_uncharge_file_region+0x4b/0x80
> [  315.251487]  region_del+0x1d3/0x300
> [  315.251489]  hugetlb_unreserve_pages+0x39/0xb0
> [  315.251492]  remove_inode_hugepages+0x1a8/0x3d0
> [  315.251495]  ? tlb_finish_mmu+0x7a/0x1d0
> [  315.251497]  hugetlbfs_fallocate+0x3c4/0x5c0
> [  315.251519]  ? kvm_arch_vcpu_ioctl_run+0x614/0x1700 [kvm]
> [  315.251522]  ? file_has_perm+0xa2/0xb0
> [  315.251524]  ? inode_security+0xc/0x60
> [  315.251525]  ? selinux_file_permission+0x4e/0x120
> [  315.251527]  vfs_fallocate+0x146/0x290
> [  315.251529]  __x64_sys_fallocate+0x3e/0x70
> [  315.251531]  do_syscall_64+0x33/0x40
> [  315.251533]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> ...
> [  315.251542] ---[ end trace 4c88c62ccb1349c9 ]---
> 
> Investigation of the issue uncovered bugs in hugetlb cgroup reservation
> accounting.  This patch addresses the found issues.
> 
> Fixes: 075a61d07a8e ("hugetlb_cgroup: add accounting for shared mappings")
> Cc: <stable@vger.kernel.org>
> Reported-by: Michal Privoznik <mprivozn@redhat.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  mm/hugetlb.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 67fc6383995b..b853a11de14f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -655,6 +655,8 @@ static long region_del(struct resv_map *resv, long f, long t)
>  			}
>  
>  			del += t - f;
> +			hugetlb_cgroup_uncharge_file_region(
> +				resv, rg, t - f);
>  
>  			/* New entry for end of split region */
>  			nrg->from = t;
> @@ -667,9 +669,6 @@ static long region_del(struct resv_map *resv, long f, long t)
>  			/* Original entry is trimmed */
>  			rg->to = f;
>  
> -			hugetlb_cgroup_uncharge_file_region(
> -				resv, rg, nrg->to - nrg->from);
> -
>  			list_add(&nrg->link, &rg->link);
>  			nrg = NULL;
>  			break;
> @@ -685,17 +684,17 @@ static long region_del(struct resv_map *resv, long f, long t)
>  		}
>  
>  		if (f <= rg->from) {	/* Trim beginning of region */
> -			del += t - rg->from;
> -			rg->from = t;
> -
>  			hugetlb_cgroup_uncharge_file_region(resv, rg,
>  							    t - rg->from);
> -		} else {		/* Trim end of region */
> -			del += rg->to - f;
> -			rg->to = f;
>  
> +			del += t - rg->from;
> +			rg->from = t;
> +		} else {		/* Trim end of region */
>  			hugetlb_cgroup_uncharge_file_region(resv, rg,
>  							    rg->to - f);
> +
> +			del += rg->to - f;
> +			rg->to = f;
>  		}
>  	}
>  
> @@ -2454,6 +2453,9 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
>  
>  		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
>  		hugetlb_acct_memory(h, -rsv_adjust);
> +		if (deferred_reserve)
> +			hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
> +					pages_per_huge_page(h), page);
>  	}
>  	return page;
>  
> -- 
> 2.25.4

