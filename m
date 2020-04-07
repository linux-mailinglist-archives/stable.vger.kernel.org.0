Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B691A089D
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 09:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgDGHtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 03:49:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57834 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726707AbgDGHtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 03:49:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586245754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=7rEjzhfmDzH2/E5oXHMzDphe6FC7SykAYUUlrnHma5c=;
        b=BwbmBvP0ePU6qGzN40e8yVjqJzwEs+zwCBanFPCHfDc+Jw5qYQXIYEaBW2g7Z5Bamsd/Ht
        NmUWLZCwHBkxSYqWIuzDJ8ViBYowYtWECni+sO7OZgimIivomIhozOnwi3tmdsgKxVzcmC
        9OwnHzX06PZ/subbNGRgUYPsWRJhLD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-tx4HQUmPPmeqrhtGR71X0Q-1; Tue, 07 Apr 2020 03:49:12 -0400
X-MC-Unique: tx4HQUmPPmeqrhtGR71X0Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8D99800D5F;
        Tue,  7 Apr 2020 07:49:10 +0000 (UTC)
Received: from [10.36.114.167] (ovpn-114-167.ams2.redhat.com [10.36.114.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4DB960BE1;
        Tue,  7 Apr 2020 07:49:08 +0000 (UTC)
Subject: Re: [PATCH v2 1/5] KVM: s390: vsie: Fix region 1 ASCE sanity shadow
 address checks
To:     Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, stable@vger.kernel.org
References: <20200403153050.20569-1-david@redhat.com>
 <20200403153050.20569-2-david@redhat.com>
 <ee3f6c69-4401-066d-6f87-806667facf35@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <c5c9fdcd-37ce-029d-a412-8987a901a116@redhat.com>
Date:   Tue, 7 Apr 2020 09:49:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <ee3f6c69-4401-066d-6f87-806667facf35@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07.04.20 09:33, Christian Borntraeger wrote:
> 
> On 03.04.20 17:30, David Hildenbrand wrote:
>> In case we have a region 1 ASCE, our shadow/g3 address can have any value.
>> Unfortunately, (-1UL << 64) is undefined and triggers sometimes,
>> rejecting valid shadow addresses when trying to walk our shadow table
>> hierarchy.
>>
>> The result is that the prefix cannot get mapped and will loop basically
>> forever trying to map it (-EAGAIN loop).
>>
>> After all, the broken check is only a sanity check, our table shadowing
>> code in kvm_s390_shadow_tables() already checks these conditions, injecting
>> proper translation exceptions. Turn it into a WARN_ON_ONCE().
> 
> After some testing I now triggered this warning:
> 
> [  541.633114] ------------[ cut here ]------------
> [  541.633128] WARNING: CPU: 38 PID: 2812 at arch/s390/mm/gmap.c:799 gmap_shadow_pgt_lookup+0x98/0x1a0
> [  541.633129] Modules linked in: vhost_net vhost macvtap macvlan tap kvm xt_CHECKSUM xt_MASQUERADE nf_nat_tftp nf_conntrack_tftp xt_CT tun bridge stp llc xt_tcpudp ip6t_REJECT nf_reject_ipv6 ip6t_rpfilter ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_nat ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat iptable_mangle iptable_raw iptable_security nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nfnetlink ip6table_filter ip6_tables iptable_filter rpcrdma sunrpc rdma_ucm rdma_cm iw_cm ib_cm configfs mlx5_ib s390_trng ghash_s390 prng aes_s390 ib_uverbs des_s390 ib_core libdes sha3_512_s390 genwqe_card sha3_256_s390 vfio_ccw crc_itu_t vfio_mdev sha512_s390 mdev vfio_iommu_type1 sha1_s390 vfio eadm_sch zcrypt_cex4 sch_fq_codel ip_tables x_tables mlx5_core sha256_s390 sha_common pkey zcrypt rng_core autofs4
> [  541.633164] CPU: 38 PID: 2812 Comm: CPU 0/KVM Not tainted 5.6.0+ #354
> [  541.633166] Hardware name: IBM 3906 M04 704 (LPAR)
> [  541.633167] Krnl PSW : 0704d00180000000 00000014e05dc454 (gmap_shadow_pgt_lookup+0x9c/0x1a0)
> [  541.633169]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
> [  541.633171] Krnl GPRS: 0000000000000000 0000001f00000000 0000001f487b8000 ffffffff80000000
> [  541.633172]            ffffffffffffffff 000003e003defa18 000003e003defa1c 000003e003defa18
> [  541.633173]            fffffffffffff000 000003e003defa18 000003e003defa28 0000001f70e06300
> [  541.633174]            0000001f43484000 00000000043ed200 000003e003def978 000003e003def920
> [  541.633203] Krnl Code: 00000014e05dc448: b9800038		ngr	%r3,%r8
>                           00000014e05dc44c: a7840014		brc	8,00000014e05dc474
>                          #00000014e05dc450: af000000		mc	0,0
>                          >00000014e05dc454: a728fff5		lhi	%r2,-11
>                           00000014e05dc458: a7180000		lhi	%r1,0
>                           00000014e05dc45c: b2fa0070		niai	7,0
>                           00000014e05dc460: 4010b04a		sth	%r1,74(%r11)
>                           00000014e05dc464: b9140022		lgfr	%r2,%r2
> [  541.633215] Call Trace:
> [  541.633218]  [<00000014e05dc454>] gmap_shadow_pgt_lookup+0x9c/0x1a0 
> [  541.633257]  [<000003ff804c57d6>] kvm_s390_shadow_fault+0x66/0x1e8 [kvm] 
> [  541.633265]  [<000003ff804c72dc>] vsie_run+0x43c/0x710 [kvm] 
> [  541.633273]  [<000003ff804c85ca>] kvm_s390_handle_vsie+0x632/0x750 [kvm] 
> [  541.633281]  [<000003ff804c123c>] kvm_s390_handle_b2+0x84/0x4e0 [kvm] 
> [  541.633289]  [<000003ff804b46b2>] kvm_handle_sie_intercept+0x172/0xcb8 [kvm] 
> [  541.633297]  [<000003ff804b18a8>] __vcpu_run+0x658/0xc90 [kvm] 
> [  541.633305]  [<000003ff804b2920>] kvm_arch_vcpu_ioctl_run+0x248/0x858 [kvm] 
> [  541.633313]  [<000003ff8049d454>] kvm_vcpu_ioctl+0x284/0x7b0 [kvm] 
> [  541.633316]  [<00000014e087d5ae>] ksys_ioctl+0xae/0xe8 
> [  541.633318]  [<00000014e087d652>] __s390x_sys_ioctl+0x2a/0x38 
> [  541.633323]  [<00000014e0ff02a2>] system_call+0x2a6/0x2c8 
> [  541.633323] Last Breaking-Event-Address:
> [  541.633334]  [<000003ff804983e0>] kvm_running_vcpu+0x3ea9ee997d8/0x3ea9ee99950 [kvm]
> [  541.633335] ---[ end trace f69b6021855ea189 ]---
> 
> 
> Unfortunately no dump at that point in time.
> I have other tests which are clearly fixed by this patch, so we should propbably go forward anyway.
> Question is, is this just another bug we need to fix or is the assumption that somebody else checked 
> all conditions so we can warn false?

Yeah, I think it is via

kvm_s390_shadow_fault()->gmap_shadow_pgt_lookup()->gmap_table_walk()

where we just peek if there is already something shadowed. If not, we go
via the full kvm_s390_shadow_tables() path.

So we could either do sanity checks in gmap_shadow_pgt_lookup(), or
rather drop the WARN_ON_ONCE. I think the latter makes sense, now that
we understood the problem.

-- 
Thanks,

David / dhildenb

