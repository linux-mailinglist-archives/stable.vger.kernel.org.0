Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AB03FA539
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 13:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhH1LI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Aug 2021 07:08:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20344 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233732AbhH1LI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Aug 2021 07:08:27 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17SB7VoI136137;
        Sat, 28 Aug 2021 07:07:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kpd3suGXbrkdM8iW+jjf4KzAG/Cih0t8ovp5ZZwZbQ0=;
 b=FKNNyZLPon/lgNmo8HsGTK38OaR8vdkkgkFmGf1V2m/5jkGXu807mZCkRmdRrnFSiXlT
 /MLfNTHnIhbbbZqO0c5crlq5BdIUIMZSvd9AE7MG9UGf++lXUh3DbBgdd4s2Xx+bYewZ
 JuReeAU88H46JdDwi3sRedvihk1MeGf9lwqbcJtt0kE8V+eCL8YcAtg3N3COZQvn5o8c
 rpDlJeLj2OMVA0HcP5yLhwNBVnllVJwlLphETs431+O3QzzOd6tbQO0gIUdCGCGZzkPN
 aN03kidof4804fvNH3f5WuIsWPHWAQHhcDCMB+FS5pXqhMak++LftEmpE08Qy8TWIjxi kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aqjungx6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Aug 2021 07:07:36 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17SB7XXQ136268;
        Sat, 28 Aug 2021 07:07:36 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aqjungx11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Aug 2021 07:07:35 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17SB1pN9006018;
        Sat, 28 Aug 2021 11:04:49 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3aqcs88ct0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Aug 2021 11:04:49 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17SB0tqE61735290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 11:00:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABCC3A42AE;
        Sat, 28 Aug 2021 11:04:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1136AA42B5;
        Sat, 28 Aug 2021 11:04:45 +0000 (GMT)
Received: from ant.fritz.box (unknown [9.145.66.174])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 28 Aug 2021 11:04:44 +0000 (GMT)
Subject: Re: [PATCH 1/1] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
To:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210827125429.1912577-1-pasic@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Message-ID: <e3759bf8-012b-149f-ed98-0663e4a3431b@linux.ibm.com>
Date:   Sat, 28 Aug 2021 13:04:44 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827125429.1912577-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wYKbXj4c6MbsqjqEjjXR-ch9WhdMCIRt
X-Proofpoint-ORIG-GUID: 9nG_gdqpRwlHeqIiyg6CAZGz0muQ9xgw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-28_02:2021-08-27,2021-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108280068
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

Reviewed-by: Michael Mueller <mimu@linux.ibm.com>

I did also run some tests and have prepared a qemu that will choose
vcpu_id's that are not equal to the index in the kernel.

Michael

> 
