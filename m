Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CE53F9A5E
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 15:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbhH0Nnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 09:43:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5072 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234444AbhH0Nni (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 09:43:38 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RDdZ8x119326;
        Fri, 27 Aug 2021 09:42:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gDVmiMQOp5gRkFPBSkvFKbmBsEXRl6iEYrUXExXiTiA=;
 b=BirEure/HNQT5EF+o/uON5Mry5pqmFySTwfYZqwlckEDNmq57WrWFkSZ2u7+PcEUzTFv
 t5sWteyrN+2bbYjgtJ2F2FskAl8KDw9kNR/Gh/A1FpfXTUTGXgQFOPa3ffNlDRYH+9N/
 96D177KznQCgQZKKqCjYk4x0wup139P0n3Ss60JUOLscQ0vkHiso1BCc6nitZ+2xyfsm
 3nByDlmaUj1mhkan1x7n2kGK2X3+6nxkpo/7bW405CtR60CFEBOW96jKTBc+55hI0wo/
 aHHOJU4gdcv7xIqhglWxzxQI3HeYjsoN7MhCTyI/gN3IBKza2BPlelEsM8Yv05jW8AIv Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aq0j8147v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 09:42:49 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RDePrh123095;
        Fri, 27 Aug 2021 09:42:48 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aq0j8146y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 09:42:48 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RDbaOo024245;
        Fri, 27 Aug 2021 13:42:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ajs493k8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 13:42:46 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RDghd936372766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 13:42:43 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 448C44C059;
        Fri, 27 Aug 2021 13:42:43 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B56084C046;
        Fri, 27 Aug 2021 13:42:42 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.50.110])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 13:42:42 +0000 (GMT)
Subject: Re: [PATCH 1/1] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
To:     Halil Pasic <pasic@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Michael Mueller <mimu@linux.ibm.com>
References: <20210827125429.1912577-1-pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <46d8c633-198e-01f5-061a-b300e9e5e002@de.ibm.com>
Date:   Fri, 27 Aug 2021 15:42:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827125429.1912577-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oBLcjvl_hmpEiIIiOgNJYQKmlw67pzZM
X-Proofpoint-ORIG-GUID: uV7niWo5u_G-I7UBcUDkDriJDBqvjrAX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_04:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 clxscore=1011 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270087
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 27.08.21 14:54, Halil Pasic wrote:
> While in practice vcpu->vcpu_idx ==  vcpu->vcp_id is often true,
> it may not always be, and we must not rely on this.
> 
> Currently kvm->arch.idle_mask is indexed by vcpu_id, which implies
> that code like
> for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
>                  vcpu = kvm_get_vcpu(kvm, vcpu_id);
> 		do_stuff(vcpu);
> }
> is not legit. The trouble is, we do actually use kvm->arch.idle_mask
> like this. To fix this problem we have two options. Either use
> kvm_get_vcpu_by_id(vcpu_id), which would loop to find the right vcpu_id,
> or switch to indexing via vcpu_idx. The latter is preferable for obvious
> reasons.
> 
> Let us make switch from indexing kvm->arch.idle_mask by vcpu_id to
> indexing it by vcpu_idx.  To keep gisa_int.kicked_mask indexed by the
> same index as idle_mask lets make the same change for it as well.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 1ee0bc559dc3 ("KVM: s390: get rid of local_int array")
> Cc: <stable@vger.kernel.org> # 3.15+

Reviewed-by: Christian Bornträger <borntraeger@de.ibm.com>
Will apply and wait for the nightly run.

> ---
>   arch/s390/include/asm/kvm_host.h |  1 +
>   arch/s390/kvm/interrupt.c        | 12 ++++++------
>   arch/s390/kvm/kvm-s390.c         |  2 +-
>   arch/s390/kvm/kvm-s390.h         |  2 +-
>   4 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 161a9e12bfb8..630eab0fa176 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -957,6 +957,7 @@ struct kvm_arch{
>   	atomic64_t cmma_dirty_pages;
>   	/* subset of available cpu features enabled by user space */
>   	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
> +	/* indexed by vcpu_idx */
>   	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
>   	struct kvm_s390_gisa_interrupt gisa_int;
>   	struct kvm_s390_pv pv;
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index d548d60caed2..16256e17a544 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -419,13 +419,13 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
>   static void __set_cpu_idle(struct kvm_vcpu *vcpu)
>   {
>   	kvm_s390_set_cpuflags(vcpu, CPUSTAT_WAIT);
> -	set_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
> +	set_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
>   }
>   
>   static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
>   {
>   	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
> -	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
> +	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
>   }
>   
>   static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
> @@ -3050,18 +3050,18 @@ int kvm_s390_get_irq_state(struct kvm_vcpu *vcpu, __u8 __user *buf, int len)
>   
>   static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
>   {
> -	int vcpu_id, online_vcpus = atomic_read(&kvm->online_vcpus);
> +	int vcpu_idx, online_vcpus = atomic_read(&kvm->online_vcpus);
>   	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
>   	struct kvm_vcpu *vcpu;
>   
> -	for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
> -		vcpu = kvm_get_vcpu(kvm, vcpu_id);
> +	for_each_set_bit(vcpu_idx, kvm->arch.idle_mask, online_vcpus) {
> +		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
>   		if (psw_ioint_disabled(vcpu))
>   			continue;
>   		deliverable_mask &= (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
>   		if (deliverable_mask) {
>   			/* lately kicked but not yet running */
> -			if (test_and_set_bit(vcpu_id, gi->kicked_mask))
> +			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
>   				return;
>   			kvm_s390_vcpu_wakeup(vcpu);
>   			return;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 4527ac7b5961..8580543c5bc3 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4044,7 +4044,7 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
>   		kvm_s390_patch_guest_per_regs(vcpu);
>   	}
>   
> -	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.gisa_int.kicked_mask);
> +	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.gisa_int.kicked_mask);
>   
>   	vcpu->arch.sie_block->icptcode = 0;
>   	cpuflags = atomic_read(&vcpu->arch.sie_block->cpuflags);
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 9fad25109b0d..ecd741ee3276 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -79,7 +79,7 @@ static inline int is_vcpu_stopped(struct kvm_vcpu *vcpu)
>   
>   static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
>   {
> -	return test_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
> +	return test_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
>   }
>   
>   static inline int kvm_is_ucontrol(struct kvm *kvm)
> 
> base-commit: 77dd11439b86e3f7990e4c0c9e0b67dca82750ba
> 
