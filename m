Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D9064748A
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 17:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiLHQpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 11:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiLHQpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 11:45:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6900AAD997
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 08:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670517880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1l8k42ZbsEJYEYSTw8FtE3/FUSY7dX6qzGCzbPDDRj8=;
        b=DECkojCIznejQz1h6vujsEuxYunu1pQBrNfcurwL2CKamRRR1DNMvq9gNP3yTUGcXe6BdC
        tpg71hv0BXqAculRnTdTJi/P9dL6sl4cBZFlMD1EPTBfK6zHhkovOkhZS6fI6/5YC36+t1
        tlahv6aF77xap2+ni8umuf89zrHcRVo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-5-A2oWprTKPV2wrj_HsT6V0A-1; Thu, 08 Dec 2022 11:44:38 -0500
X-MC-Unique: A2oWprTKPV2wrj_HsT6V0A-1
Received: by mail-wm1-f69.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso1067769wmh.2
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 08:44:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1l8k42ZbsEJYEYSTw8FtE3/FUSY7dX6qzGCzbPDDRj8=;
        b=QWzvQZf1FU5rG9gB+ttEik8AOs4F0AU0hfT5T260YVPk2f4kYePM2bZQig5yT3huW/
         YLfEYgzcES2ZUcAPVylFb3waFakx+TVMeZsIyNo2Lm8Q9THkiJG71edUg1SCCUjjPpFI
         FrJctt1L388eBj0MzkRg7F/7lfXB47Yh4joPd23l3zi8TMV6ZeZVtyCrumr1kb4N/m98
         BACGQqWod1DQ9RblgmXn5GL5JmkjRwpHwRqCl28Tnf3GQqze1S+Pyrxwv+hPhlcihQFB
         rmEEj39l5yjh3F2WYqVOdM8BBQgd9r4jItFu4DT4L4uVB6q8uGZ4mzw2Z0Gj6igKAzZX
         9BTw==
X-Gm-Message-State: ANoB5pmdpyfAu9Qnf6fUvaUc5KdARnk9gxzkOCFA5Jw6uMSscVGxOm67
        rGUzsKLN2NK6bRX6yYNMcKNXCRzYVixvIt/8zAIPelt0M5E9Ymj8J8i70FRJXacjoDXozC4QIHS
        pni55eiboKt3mKYlZ
X-Received: by 2002:a05:600c:4f05:b0:3d0:3d33:a629 with SMTP id l5-20020a05600c4f0500b003d03d33a629mr44320907wmq.126.1670517877726;
        Thu, 08 Dec 2022 08:44:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5r/uL+uiuGQyKClT4NrDXeEElwlcukfDdB27dVx2wb+66kgFv3zStJgj2Nnh6eiYXwJLX/zQ==
X-Received: by 2002:a05:600c:4f05:b0:3d0:3d33:a629 with SMTP id l5-20020a05600c4f0500b003d03d33a629mr44320901wmq.126.1670517877479;
        Thu, 08 Dec 2022 08:44:37 -0800 (PST)
Received: from ?IPV6:2003:cb:c704:6c00:f39d:87c2:dd6c:4e98? (p200300cbc7046c00f39d87c2dd6c4e98.dip0.t-ipconnect.de. [2003:cb:c704:6c00:f39d:87c2:dd6c:4e98])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d424b000000b00241cfe6e286sm23250692wrr.98.2022.12.08.08.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 08:44:37 -0800 (PST)
Message-ID: <b9162f04-7d8e-1ada-f428-85fd84327d1c@redhat.com>
Date:   Thu, 8 Dec 2022 17:44:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20221208114137.35035-1-david@redhat.com> <Y5IQzJkBSYwPOtiP@x1n>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
In-Reply-To: <Y5IQzJkBSYwPOtiP@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.12.22 17:29, Peter Xu wrote:
> On Thu, Dec 08, 2022 at 12:41:37PM +0100, David Hildenbrand wrote:
>> Currently, we don't enable writenotify when enabling userfaultfd-wp on
>> a shared writable mapping (for now only shmem and hugetlb). The consequence
>> is that vma->vm_page_prot will still include write permissions, to be set
>> as default for all PTEs that get remapped (e.g., mprotect(), NUMA hinting,
>> page migration, ...).
>>
>> So far, vma->vm_page_prot is assumed to be a safe default, meaning that
>> we only add permissions (e.g., mkwrite) but not remove permissions (e.g.,
>> wrprotect). For example, when enabling softdirty tracking, we enable
>> writenotify. With uffd-wp on shared mappings, that changed. More details
>> on vma->vm_page_prot semantics were summarized in [1].
>>
>> This is problematic for uffd-wp: we'd have to manually check for
>> a uffd-wp PTEs/PMDs and manually write-protect PTEs/PMDs, which is error
>> prone. Prone to such issues is any code that uses vma->vm_page_prot to set
>> PTE permissions: primarily pte_modify() and mk_pte().
>>
>> Instead, let's enable writenotify such that PTEs/PMDs/... will be mapped
>> write-protected as default and we will only allow selected PTEs that are
>> definitely safe to be mapped without write-protection (see
>> can_change_pte_writable()) to be writable. In the future, we might want
>> to enable write-bit recovery -- e.g., can_change_pte_writable() -- at
>> more locations, for example, also when removing uffd-wp protection.
>>
>> This fixes two known cases:
>>
>> (a) remove_migration_pte() mapping uffd-wp'ed PTEs writable, resulting
>>      in uffd-wp not triggering on write access.
>> (b) do_numa_page() / do_huge_pmd_numa_page() mapping uffd-wp'ed PTEs/PMDs
>>      writable, resulting in uffd-wp not triggering on write access.
>>
>> Note that do_numa_page() / do_huge_pmd_numa_page() can be reached even
>> without NUMA hinting (which currently doesn't seem to be applicable to
>> shmem), for example, by using uffd-wp with a PROT_WRITE shmem VMA.
>> On such a VMA, userfaultfd-wp is currently non-functional.
>>
>> Note that when enabling userfaultfd-wp, there is no need to walk page
>> tables to enforce the new default protection for the PTEs: we know that
>> they cannot be uffd-wp'ed yet, because that can only happen after
>> enabling uffd-wp for the VMA in general.
>>
>> Also note that this makes mprotect() on ranges with uffd-wp'ed PTEs not
>> accidentally set the write bit -- which would result in uffd-wp not
>> triggering on later write access. This commit makes uffd-wp on shmem behave
>> just like uffd-wp on anonymous memory (iow, less special) in that regard,
>> even though, mixing mprotect with uffd-wp is controversial.
>>
>> [1] https://lkml.kernel.org/r/92173bad-caa3-6b43-9d1e-9a471fdbc184@redhat.com
>>
>> Reported-by: Ives van Hoorne <ives@codesandbox.io>
>> Debugged-by: Peter Xu <peterx@redhat.com>
>> Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
>> Cc: stable@vger.kernel.org
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Hugh Dickins <hugh@veritas.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
>> Cc: Nadav Amit <nadav.amit@gmail.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> Acked-by: Peter Xu <peterx@redhat.com>
> 
> One trivial nit.
> 
>> ---
>>
>> As discussed in [2], this is supposed to replace the fix by Peter:
>>    [PATCH v3 1/2] mm/migrate: Fix read-only page got writable when recover
>>    pte
>>
>> This survives vm/selftests and my reproducers:
>> * migrating pages that are uffd-wp'ed using mbind() on a machine with 2
>>    NUMA nodes
>> * Using a PROT_WRITE mapping with uffd-wp
>> * Using a PROT_READ|PROT_WRITE mapping with uffd-wp'ed pages and
>>    mprotect()'ing it PROT_WRITE
>> * Using a PROT_READ|PROT_WRITE mapping with uffd-wp'ed pages and
>>    temporarily mprotect()'ing it PROT_READ
>>
>> uffd-wp properly triggers in all cases. On v8.1-rc8, all mre reproducers
>> fail.
>>
>> It would be good to get some more testing feedback and review.
>>
>> [2] https://lkml.kernel.org/r/20221202122748.113774-1-david@redhat.com
>>
>> ---
>>   fs/userfaultfd.c | 28 ++++++++++++++++++++++------
>>   mm/mmap.c        |  4 ++++
>>   2 files changed, 26 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
>> index 98ac37e34e3d..fb0733f2e623 100644
>> --- a/fs/userfaultfd.c
>> +++ b/fs/userfaultfd.c
>> @@ -108,6 +108,21 @@ static bool userfaultfd_is_initialized(struct userfaultfd_ctx *ctx)
>>   	return ctx->features & UFFD_FEATURE_INITIALIZED;
>>   }
>>   
>> +static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
>> +				     vm_flags_t flags)
>> +{
>> +	const bool uffd_wp = !!((vma->vm_flags | flags) & VM_UFFD_WP);
> 
> IIUC this can be "uffd_wp_changed" then switch "|" to "^".  But not a hot
> path at all, so shouldn't matter a lot.

Yes, let's do that (we can also remove the !! here):

This hunk will be:


diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 98ac37e34e3d..a988485ada05 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -108,6 +108,21 @@ static bool userfaultfd_is_initialized(struct userfaultfd_ctx *ctx)
  	return ctx->features & UFFD_FEATURE_INITIALIZED;
  }
  
+static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
+				     vm_flags_t flags)
+{
+	const bool uffd_wp_changed = (vma->vm_flags ^ flags) & VM_UFFD_WP;
+
+	vma->vm_flags = flags;
+	/*
+	 * For shared mappings, we want to enable writenotify while
+	 * userfaultfd-wp is enabled (see vma_wants_writenotify()). We'll simply
+	 * recalculate vma->vm_page_prot whenever userfaultfd-wp changes.
+	 */
+	if ((vma->vm_flags & VM_SHARED) && uffd_wp_changed)
+		vma_set_page_prot(vma);
+}
+


I'll wait for some more (+retest) before I resend tomorrow.

Thanks!


-- 
Thanks,

David / dhildenb

