Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71710AED81
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 16:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732596AbfIJOoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 10:44:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfIJOoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 10:44:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96B5A10C696B;
        Tue, 10 Sep 2019 14:44:25 +0000 (UTC)
Received: from gondolin (ovpn-117-116.ams2.redhat.com [10.36.117.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E2E560BF7;
        Tue, 10 Sep 2019 14:44:19 +0000 (UTC)
Date:   Tue, 10 Sep 2019 16:44:15 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        david@redhat.com, frankja@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: kvm_s390_vm_start_migration: check
 dirty_bitmap before using it as target for memset()
Message-ID: <20190910164415.3ef74c39.cohuck@redhat.com>
In-Reply-To: <20190910130215.23647-1-imammedo@redhat.com>
References: <20190910130215.23647-1-imammedo@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Tue, 10 Sep 2019 14:44:25 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Sep 2019 09:02:15 -0400
Igor Mammedov <imammedo@redhat.com> wrote:

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

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
