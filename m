Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645603F1A71
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 15:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbhHSNfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 09:35:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239665AbhHSNfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 09:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629380114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+Tl/O2UL95HsN9NSAci3PkitvsT8uG7yyX9Sw+EVEY=;
        b=EdPXQaKDq0Egjd/6P3xgBfpMaAb6c/p06CzIhiYdP1CT/5ClwS3Ue/NE9e1P45KfrNyv1l
        jhVmzLGW11YvCcWdPP/eTd/Wp/lxPyfPeo7Us368XcAbXxHLpOsdZgAkuKsz8Ozla+mSnu
        sSBQ9ikVKlSHdOHYWMgoQMqsoRJmqYw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-1g5ZbXUzM-ymurLsJ1vpHA-1; Thu, 19 Aug 2021 09:35:13 -0400
X-MC-Unique: 1g5ZbXUzM-ymurLsJ1vpHA-1
Received: by mail-wr1-f70.google.com with SMTP id f25-20020a5d58f9000000b00157197bd8efso379004wrd.13
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 06:35:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=S+Tl/O2UL95HsN9NSAci3PkitvsT8uG7yyX9Sw+EVEY=;
        b=JjfN4ijuuF6epE/5W98Pu2gWR2RlnGXq0s1S+ipp4uipeIQXmZYBscwjYemVjtPbvb
         HADPVm1NFt0WgRw1yumSbek1/QRT04i6q4dllyxqdPEKrFL8flasLTli96+O5/a3ChgU
         Y/PCWJksD1EAEScSoquZHbuk4uZPYD1qFpebCoPtWi+SKcWOkQU3Bb6fUGFs9JsjMXuC
         aE1kKf7l5y/lbiL6PUT7eHNC+IcP/SzcqK1vXLwR8A7VPjQHI3ZgJqvSMlOx1H9k/RBk
         dSRyrrwoqcaVkMWdDTQFf/kg63+jgyb3vXPf1ZPVeSEv/85dHzqyFsY22DJGNhukgwbv
         rMWw==
X-Gm-Message-State: AOAM533F/Kj3N6qy8o+fdStc3keXd3pU+ljyO7YnW1r8Js8u92SwYJLb
        loGMeelDwlBgF6drUsRPTfBct59PEZPFJtkN3tNwd+XsMZ0gLHmjS8iuuzreX0sM2n02K9/Yaht
        Rwn48fxuwKg5AXv3ux6PMearOMzExjWj1WaT9/92vhvXrT2linza/ZEAEWZuxQOlX
X-Received: by 2002:a05:600c:210a:: with SMTP id u10mr13912667wml.162.1629380112442;
        Thu, 19 Aug 2021 06:35:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoKtiSGvFPCIpB5RUG1rMBbQAQd/0uA6x4ZuORYE20CS6Wsk1/Sw74TxpctCpR33DxsA8WNg==
X-Received: by 2002:a05:600c:210a:: with SMTP id u10mr13912624wml.162.1629380112054;
        Thu, 19 Aug 2021 06:35:12 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6bd1.dip0.t-ipconnect.de. [91.12.107.209])
        by smtp.gmail.com with ESMTPSA id q3sm2402775wmf.37.2021.08.19.06.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 06:35:11 -0700 (PDT)
Subject: Re: [PATCH v2] x86/mm: fix kern_addr_valid to cope with existing but
 not present entries
To:     Mike Rapoport <rppt@kernel.org>, x86@kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20210819132717.19358-1-rppt@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <68248e54-fcaf-0360-6a40-ef621fa03742@redhat.com>
Date:   Thu, 19 Aug 2021 15:35:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210819132717.19358-1-rppt@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.08.21 15:27, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Jiri Olsa reported a fault when running:
> 
> 	# cat /proc/kallsyms | grep ksys_read
> 	ffffffff8136d580 T ksys_read
> 	# objdump -d --start-address=0xffffffff8136d580 --stop-address=0xffffffff8136d590 /proc/kcore
> 
> 	/proc/kcore:     file format elf64-x86-64
> 
> 	Segmentation fault
> 
> krava33 login: [   68.330612] general protection fault, probably for non-canonical address 0xf887ffcbff000: 0000 [#1] SMP PTI
> [   68.333118] CPU: 12 PID: 1079 Comm: objdump Not tainted 5.14.0-rc5qemu+ #508
> [   68.334922] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-4.fc34 04/01/2014
> [   68.336945] RIP: 0010:kern_addr_valid+0x150/0x300
> [   68.338082] Code: 1f 40 00 48 8b 0d e8 12 61 01 48 85 f6 0f 85 ca 00 00 00 48 81 e1 00 f0 ff ff 48 21 c1 48 b8 00 00 00 00 80 88 ff ff 48 01 ca <48> 8b 3c 02 48 f7 c7 9f ff ff ff 0f 84 d8 fe ff ff 48 89 f8 0f 1f
> [   68.342220] RSP: 0018:ffffc90000bcbc38 EFLAGS: 00010206
> [   68.343428] RAX: ffff888000000000 RBX: 0000000000001000 RCX: 000ffffffcbff000
> [   68.345029] RDX: 000ffffffcbff000 RSI: 0000000000000000 RDI: 800ffffffcbff062
> [   68.346599] RBP: ffffc90000bcbea8 R08: 0000000000001000 R09: 0000000000000000
> [   68.349000] R10: 0000000000000000 R11: 0000000000001000 R12: 00007fcc0fd80010
> [   68.350804] R13: ffffffff83400000 R14: 0000000000400000 R15: ffffffff843d23e0
> [   68.352609] FS:  00007fcc111fcc80(0000) GS:ffff888275e00000(0000) knlGS:0000000000000000
> [   68.354638] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   68.356104] CR2: 00007fcc0fd80000 CR3: 000000011226e004 CR4: 0000000000770ee0
> [   68.357896] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   68.359694] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   68.361597] PKRU: 55555554
> [   68.362460] Call Trace:
> [   68.363252]  read_kcore+0x57f/0x920
> [   68.364289]  ? rcu_read_lock_sched_held+0x12/0x80
> [   68.365630]  ? rcu_read_lock_sched_held+0x12/0x80
> [   68.366955]  ? rcu_read_lock_sched_held+0x12/0x80
> [   68.368277]  ? trace_hardirqs_on+0x1b/0xd0
> [   68.369462]  ? rcu_read_lock_sched_held+0x12/0x80
> [   68.370793]  ? lock_acquire+0x195/0x2f0
> [   68.371920]  ? lock_acquire+0x195/0x2f0
> [   68.373035]  ? rcu_read_lock_sched_held+0x12/0x80
> [   68.374364]  ? lock_acquire+0x195/0x2f0
> [   68.375498]  ? rcu_read_lock_sched_held+0x12/0x80
> [   68.376831]  ? rcu_read_lock_sched_held+0x12/0x80
> [   68.379883]  ? rcu_read_lock_sched_held+0x12/0x80
> [   68.381268]  ? lock_release+0x22b/0x3e0
> [   68.382458]  ? _raw_spin_unlock+0x1f/0x30
> [   68.383685]  ? __handle_mm_fault+0xcfc/0x15f0
> [   68.384994]  ? rcu_read_lock_sched_held+0x12/0x80
> [   68.386389]  ? lock_acquire+0x195/0x2f0
> [   68.387573]  ? rcu_read_lock_sched_held+0x12/0x80
> [   68.388969]  ? lock_release+0x22b/0x3e0
> [   68.390145]  proc_reg_read+0x55/0xa0
> [   68.391257]  ? vfs_read+0x78/0x1b0
> [   68.392336]  vfs_read+0xa7/0x1b0
> [   68.393328]  ksys_read+0x68/0xe0
> [   68.394308]  do_syscall_64+0x3b/0x90
> [   68.395391]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   68.396804] RIP: 0033:0x7fcc11cf92e2
> [   68.397824] Code: c0 e9 b2 fe ff ff 50 48 8d 3d ea 2e 0a 00 e8 95 e9 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
> [   68.402420] RSP: 002b:00007ffd6e0f8da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [   68.404357] RAX: ffffffffffffffda RBX: 0000565439305b20 RCX: 00007fcc11cf92e2
> [   68.406061] RDX: 0000000000800000 RSI: 00007fcc0f980010 RDI: 0000000000000003
> [   68.407747] RBP: 00007fcc11dcd300 R08: 0000000000000003 R09: 00007fcc0d980010
> [   68.410937] R10: 0000000003826000 R11: 0000000000000246 R12: 00007fcc0f980010
> [   68.412624] R13: 0000000000000d68 R14: 00007fcc11dcc700 R15: 0000000000800000
> [   68.414322] Modules linked in: intel_rapl_msr intel_rapl_common nfit kvm_intel kvm irqbypass rapl iTCO_wdt iTCO_vendor_support i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram xfs crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
> [   68.419591] ---[ end trace e2c30f827226966b ]---
> [   68.420969] RIP: 0010:kern_addr_valid+0x150/0x300
> [   68.422308] Code: 1f 40 00 48 8b 0d e8 12 61 01 48 85 f6 0f 85 ca 00 00 00 48 81 e1 00 f0 ff ff 48 21 c1 48 b8 00 00 00 00 80 88 ff ff 48 01 ca <48> 8b 3c 02 48 f7 c7 9f ff ff ff 0f 84 d8 fe ff ff 48 89 f8 0f 1f
> [   68.426826] RSP: 0018:ffffc90000bcbc38 EFLAGS: 00010206
> [   68.428150] RAX: ffff888000000000 RBX: 0000000000001000 RCX: 000ffffffcbff000
> [   68.429813] RDX: 000ffffffcbff000 RSI: 0000000000000000 RDI: 800ffffffcbff062
> [   68.431465] RBP: ffffc90000bcbea8 R08: 0000000000001000 R09: 0000000000000000
> [   68.433115] R10: 0000000000000000 R11: 0000000000001000 R12: 00007fcc0fd80010
> [   68.434768] R13: ffffffff83400000 R14: 0000000000400000 R15: ffffffff843d23e0
> [   68.436423] FS:  00007fcc111fcc80(0000) GS:ffff888275e00000(0000) knlGS:0000000000000000
> [   68.438354] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   68.442077] CR2: 00007fcc0fd80000 CR3: 000000011226e004 CR4: 0000000000770ee0
> [   68.443727] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   68.445370] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   68.447010] PKRU: 55555554
> 
> The fault happens because kern_addr_valid() dereferences existent but not
> present PMD in the high kernel mappings.
> 
> Such PMDs are created when free_kernel_image_pages() frees regions larger
> than 2Mb. In this case a part of the freed memory is mapped with PMDs and
> the set_memory_np_noalias() -> ... -> __change_page_attr() sequence will
> mark the PMD as not present rather than wipe it completely.
> 
> Make kern_addr_valid() to check whether higher level page table entries are
> present before trying to dereference them to fix this issue and to avoid
> similar issues in the future.
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Cc: <stable@vger.kernel.org>	# 4.4+
> ---
> 
> v2:
> * drop pXd_none() checks and leave only pXd_present(), per David
> 
> v1: https://lore.kernel.org/lkml/20210817135854.25407-1-rppt@kernel.org
> 
>   arch/x86/mm/init_64.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index ddeaba947eb3..879886c6cc53 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1433,18 +1433,18 @@ int kern_addr_valid(unsigned long addr)
>   		return 0;
>   
>   	p4d = p4d_offset(pgd, addr);
> -	if (p4d_none(*p4d))
> +	if (!p4d_present(*p4d))
>   		return 0;
>   
>   	pud = pud_offset(p4d, addr);
> -	if (pud_none(*pud))
> +	if (!pud_present(*pud))
>   		return 0;
>   
>   	if (pud_large(*pud))
>   		return pfn_valid(pud_pfn(*pud));
>   
>   	pmd = pmd_offset(pud, addr);
> -	if (pmd_none(*pmd))
> +	if (!pmd_present(*pmd))
>   		return 0;
>   
>   	if (pmd_large(*pmd))
> 

Hopefully we won't have other similar BUGs in the code because we leave 
fake swap entries lying around in the direct map.

Thanks!

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

