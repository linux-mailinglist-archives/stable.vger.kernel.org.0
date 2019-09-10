Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB770AEB0A
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 15:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfIJNEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 09:04:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbfIJNEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 09:04:40 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 58B717DD11;
        Tue, 10 Sep 2019 13:04:39 +0000 (UTC)
Received: from [10.36.118.100] (unknown [10.36.118.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C3E61001B01;
        Tue, 10 Sep 2019 13:04:37 +0000 (UTC)
Subject: Re: [PATCH] KVM: s390: kvm_s390_vm_start_migration: check
 dirty_bitmap before using it as target for memset()
To:     Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com, frankja@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
References: <20190910130215.23647-1-imammedo@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <13e7fa0a-c18b-5ff3-a359-013b4019487f@redhat.com>
Date:   Tue, 10 Sep 2019 15:04:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190910130215.23647-1-imammedo@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 10 Sep 2019 13:04:39 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.09.19 15:02, Igor Mammedov wrote:
> If userspace doesn't set KVM_MEM_LOG_DIRTY_PAGES on memslot before calling
> kvm_s390_vm_start_migration(), kernel will oops with:
> 
>   Unable to handle kernel pointer dereference in virtual kernel address space
>   Failing address: 0000000000000000 TEID: 0000000000000483
>   Fault in home space mode while using kernel ASCE.
>   AS:0000000002a2000b R2:00000001bff8c00b R3:00000001bff88007 S:00000001bff91000 P:000000000000003d
>   Oops: 0004 ilc:2 [#1] SMP
>   ...
>   Call Trace:
>   ([<001fffff804ec552>] kvm_s390_vm_set_attr+0x347a/0x3828 [kvm])
>    [<001fffff804ecfc0>] kvm_arch_vm_ioctl+0x6c0/0x1998 [kvm]
>    [<001fffff804b67e4>] kvm_vm_ioctl+0x51c/0x11a8 [kvm]
>    [<00000000008ba572>] do_vfs_ioctl+0x1d2/0xe58
>    [<00000000008bb284>] ksys_ioctl+0x8c/0xb8
>    [<00000000008bb2e2>] sys_ioctl+0x32/0x40
>    [<000000000175552c>] system_call+0x2b8/0x2d8
>   INFO: lockdep is turned off.
>   Last Breaking-Event-Address:
>    [<0000000000dbaf60>] __memset+0xc/0xa0
> 
> due to ms->dirty_bitmap being NULL, which might crash the host.
> 
> Make sure that ms->dirty_bitmap is set before using it or
> print a warning and return -ENIVAL otherwise.
> 
> Fixes: afdad61615cc ("KVM: s390: Fix storage attributes migration with memory slots")
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
> Cc: stable@vger.kernel.org # v4.19+
> 
> v2:
>    - drop WARN()
> 
>  arch/s390/kvm/kvm-s390.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index f329dcb3f44c..2a40cd3e40b4 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1018,6 +1018,8 @@ static int kvm_s390_vm_start_migration(struct kvm *kvm)
>  	/* mark all the pages in active slots as dirty */
>  	for (slotnr = 0; slotnr < slots->used_slots; slotnr++) {
>  		ms = slots->memslots + slotnr;
> +		if (!ms->dirty_bitmap)
> +			return -EINVAL;
>  		/*
>  		 * The second half of the bitmap is only used on x86,
>  		 * and would be wasted otherwise, so we put it to good
> 

We properly hold the slots lock, so the bitmap cannot change while in
the loop.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 

Thanks,

David / dhildenb
