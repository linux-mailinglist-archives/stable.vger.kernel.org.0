Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB9629597F
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 09:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507005AbgJVHnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 03:43:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2506997AbgJVHnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 03:43:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603352581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vnbXhELlj+AcXeQ3lmNratHYc1tjTi2yfNOzHtOq0xM=;
        b=FGVJGx+w3cPkbq8PL8M2/IqC7m6fMRR8LzzBR836H0LqVlApTLsI7tFWFKrP/1NFA0+dyk
        M78KN5QJNYfTrzeUkRyFM/sKVBmZeJFgW480uSJXof0iCDr+9G4UY/IN3hly5zZIXEesh7
        F3BkA6/ArHizXc/+xMPGgQiSLOigh1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-fqlkgh5yPbG7fVWhfqY_VA-1; Thu, 22 Oct 2020 03:42:59 -0400
X-MC-Unique: fqlkgh5yPbG7fVWhfqY_VA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 825765F9C6;
        Thu, 22 Oct 2020 07:42:57 +0000 (UTC)
Received: from [10.40.195.27] (unknown [10.40.195.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A0141972A;
        Thu, 22 Oct 2020 07:42:48 +0000 (UTC)
Subject: Re: [PATCH] hugetlb_cgroup: fix reservation accounting
To:     Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Mina Almasry <almasrymina@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20201021204426.36069-1-mike.kravetz@oracle.com>
From:   Michal Privoznik <mprivozn@redhat.com>
Message-ID: <90f2a70d-7f94-ce28-ccd4-a69ef12a4b54@redhat.com>
Date:   Thu, 22 Oct 2020 09:42:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201021204426.36069-1-mike.kravetz@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/21/20 10:44 PM, Mike Kravetz wrote:
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
> ---
>   mm/hugetlb.c | 20 +++++++++++---------
>   1 file changed, 11 insertions(+), 9 deletions(-)

I just tested this and can confirm it fixes the problem:

Tested-by: Michal Privoznik <mprivozn@redhat.com>

Thank you!
Michal

