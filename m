Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC20559A9E
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 15:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiFXNn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 09:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiFXNn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 09:43:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1950E36E0B;
        Fri, 24 Jun 2022 06:43:24 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OC1k0f003805;
        Fri, 24 Jun 2022 13:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=jWmk6Q4yoc3qgqL/zIyiBnZCRlRwQayVV5PigidaIrI=;
 b=jA6fBaJg9XV9+yAvch6KxbD38dzAE+H1Q1+TevLN22+jGBLBYfu7o9xKKCphn8fU8lBV
 48UYXpKhjWAH7wwSwetdHhKf2TIKvv2wbG2gg/n74ySwDOok1Y0GMA1DIxEZMq9nNBk5
 BQNV7yQD9gRoAElrBLyqtrlZU/CzxsED1DknwS501bcbE+YbzqdBNcNRd/f63NDMhZyi
 r3ZyKZKu1/cDKFg+YquEYlGPnF/HmbMeeD1z8mJQKmjX+1JFcZrRIyOBr0v0Q8yuwzQL
 78UYHIcYTXiQkPDoeXBxpZeTMI+jEoJpn07vmaj4Slmp4muY8xous7cxW2dT1PHT5f8e Mw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwajc642s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 13:43:19 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25ODLif5029956;
        Fri, 24 Jun 2022 13:43:19 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 3gs6baj71k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 13:43:19 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25ODhIta34210160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 13:43:18 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33B9EAC059;
        Fri, 24 Jun 2022 13:43:18 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79986AC05B;
        Fri, 24 Jun 2022 13:43:17 +0000 (GMT)
Received: from localhost (unknown [9.65.252.72])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri, 24 Jun 2022 13:43:17 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/kvm: don't crash on missing rng, and use darn
In-Reply-To: <20220622105435.203922-1-Jason@zx2c4.com>
References: <20220622105435.203922-1-Jason@zx2c4.com>
Date:   Fri, 24 Jun 2022 10:43:15 -0300
Message-ID: <87a6a2qirw.fsf@linux.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lacKIRLlCWTPdIChVCI36vbKBWbY1VOg
X-Proofpoint-GUID: lacKIRLlCWTPdIChVCI36vbKBWbY1VOg
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_07,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=819 malwarescore=0 clxscore=1011 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206240052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> On POWER8 systems that don't have ibm,power-rng available, a guest that
> ignores the KVM_CAP_PPC_HWRNG flag and calls H_RANDOM anyway will
> dereference a NULL pointer. And on machines with darn instead of
> ibm,power-rng, H_RANDOM won't work at all.
>
> This patch kills two birds with one stone, by routing H_RANDOM calls to
> ppc_md.get_random_seed, and doing the real mode check inside of it.
>
> Cc: stable@vger.kernel.org # v4.1+
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Fixes: e928e9cb3601 ("KVM: PPC: Book3S HV: Add fast real-mode H_RANDOM implementation.")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>
> This patch must be applied ontop of:
> 1) https://github.com/linuxppc/linux/commit/f3eac426657d985b97c92fa5f7ae1d43f04721f3
> 2) https://lore.kernel.org/all/20220622102532.173393-1-Jason@zx2c4.com/
>
>
>  arch/powerpc/include/asm/archrandom.h |  5 ----
>  arch/powerpc/kvm/book3s_hv_builtin.c  |  5 ++--
>  arch/powerpc/platforms/powernv/rng.c  | 33 +++++++--------------------
>  3 files changed, 11 insertions(+), 32 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
> index 11d4815841ab..3af27bb84a3d 100644
> --- a/arch/powerpc/include/asm/archrandom.h
> +++ b/arch/powerpc/include/asm/archrandom.h
> @@ -38,12 +38,7 @@ static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
>  #endif /* CONFIG_ARCH_RANDOM */
>
>  #ifdef CONFIG_PPC_POWERNV
> -int pnv_hwrng_present(void);
>  int pnv_get_random_long(unsigned long *v);
> -int pnv_get_random_real_mode(unsigned long *v);
> -#else
> -static inline int pnv_hwrng_present(void) { return 0; }
> -static inline int pnv_get_random_real_mode(unsigned long *v) { return 0; }
>  #endif
>
>  #endif /* _ASM_POWERPC_ARCHRANDOM_H */
> diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
> index 799d40c2ab4f..1c6672826db5 100644
> --- a/arch/powerpc/kvm/book3s_hv_builtin.c
> +++ b/arch/powerpc/kvm/book3s_hv_builtin.c
> @@ -176,13 +176,14 @@ EXPORT_SYMBOL_GPL(kvmppc_hcall_impl_hv_realmode);
>
>  int kvmppc_hwrng_present(void)
>  {
> -	return pnv_hwrng_present();
> +	return ppc_md.get_random_seed != NULL;
>  }
>  EXPORT_SYMBOL_GPL(kvmppc_hwrng_present);
>
>  long kvmppc_rm_h_random(struct kvm_vcpu *vcpu)
>  {
> -	if (pnv_get_random_real_mode(&vcpu->arch.regs.gpr[4]))
> +	if (ppc_md.get_random_seed &&
> +	    ppc_md.get_random_seed(&vcpu->arch.regs.gpr[4]))
>  		return H_SUCCESS;

This is the same as arch_get_random_seed_long, perhaps you could use it
instead.

Otherwise, the archrandom.h include is not needed anymore and could be
replaced with #include <asm/machdep.h> for ppc_md.

>
>  	return H_HARDWARE;
> diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
> index 868bb9777425..c748567cd47e 100644
> --- a/arch/powerpc/platforms/powernv/rng.c
> +++ b/arch/powerpc/platforms/powernv/rng.c
> @@ -29,15 +29,6 @@ struct pnv_rng {
>
>  static DEFINE_PER_CPU(struct pnv_rng *, pnv_rng);
>
> -int pnv_hwrng_present(void)
> -{
> -	struct pnv_rng *rng;
> -
> -	rng = get_cpu_var(pnv_rng);
> -	put_cpu_var(rng);
> -	return rng != NULL;
> -}
> -
>  static unsigned long rng_whiten(struct pnv_rng *rng, unsigned long val)
>  {
>  	unsigned long parity;
> @@ -58,17 +49,6 @@ static unsigned long rng_whiten(struct pnv_rng *rng, unsigned long val)
>  	return val;
>  }
>
> -int pnv_get_random_real_mode(unsigned long *v)
> -{
> -	struct pnv_rng *rng;
> -
> -	rng = raw_cpu_read(pnv_rng);
> -
> -	*v = rng_whiten(rng, __raw_rm_readq(rng->regs_real));
> -
> -	return 1;
> -}
> -
>  static int pnv_get_random_darn(unsigned long *v)
>  {
>  	unsigned long val;
> @@ -105,11 +85,14 @@ int pnv_get_random_long(unsigned long *v)
>  {
>  	struct pnv_rng *rng;
>
> -	rng = get_cpu_var(pnv_rng);
> -
> -	*v = rng_whiten(rng, in_be64(rng->regs));
> -
> -	put_cpu_var(rng);
> +	if (mfmsr() & MSR_DR) {
> +		rng = raw_cpu_read(pnv_rng);
> +		*v = rng_whiten(rng, __raw_rm_readq(rng->regs_real));
> +	} else {
> +		rng = get_cpu_var(pnv_rng);
> +		*v = rng_whiten(rng, in_be64(rng->regs));
> +		put_cpu_var(rng);
> +	}
>
>  	return 1;
>  }
