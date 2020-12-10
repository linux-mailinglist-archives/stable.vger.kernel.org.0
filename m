Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344F32D6219
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391158AbgLJQhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:37:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391437AbgLJQha (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 11:37:30 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAGVsdw159735;
        Thu, 10 Dec 2020 11:36:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dN9R56n8LBKD49/etkZ6uo0OmmDcJTzzH+j1i4Pij/U=;
 b=oZwcHl+RwOgQ+M4Czs2gngXHqxyHsKSDw5/EzvHMpZ0t+cOE02T+Q242Bt8eJG08rSy2
 KQbjBXUHF5VEABqeA+0nehCiGqdx0Z5XUoiaMCcfZ3X6eYfCsSU2RsTwyKZ0TlvqOv8C
 k3fuwaFc9jqyJ98Hy3aWiax15Y0v9XJ9kXc6XDeTg8yNVdyaLv0oEgvkWDtga5s2uWPz
 ne+NqW0xxiJfINWKlAHgrv4pKlclHzfi9+SQe/P3rQm90hrZILm2jtX0+/7qfpSAHFsw
 8w2G1ZkJ84VaYsumJLCKZuCspZ9hmYGpsWdQA3Od3kxEeEaDsNxOYQNGiZC099VJx51w og== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35bpq99paj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 11:36:43 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAGSL1Y024649;
        Thu, 10 Dec 2020 16:36:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8ru5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 16:36:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAGY9ee17760520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 16:34:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F9704204C;
        Thu, 10 Dec 2020 16:34:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDFF542047;
        Thu, 10 Dec 2020 16:34:08 +0000 (GMT)
Received: from [9.171.6.187] (unknown [9.171.6.187])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Dec 2020 16:34:08 +0000 (GMT)
Subject: Re: [PATCH 5.4 21/54] s390/pci: fix CPU address in MSI for directed
 IRQ
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
References: <20201210142602.037095225@linuxfoundation.org>
 <20201210142603.083190701@linuxfoundation.org>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <805f753f-f431-a032-383c-65130ef0b153@linux.ibm.com>
Date:   Thu, 10 Dec 2020 17:34:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201210142603.083190701@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_06:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 phishscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012100102
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

sorry to bother you but I missed that the smp_cpu_get_cpu_address()
address used here was only added with the
commit 42d211a1ae3b77 ("s390/cpuinfo: show processor physical address")
which landed in v5.7-rc1. This would therefore break if ever called
(luckily it would not be called on any shipped hardware) and
also causes a missing declaration warning as reported by
Naresh Kamboju thanks!
Since this is as of now just a spec fix, as on all known hardware
the Linux CPU Id always matches the CPU Address, I would
recommend to simply revert the commit.
Thanks in advance!

Best regards,
Niklas Schnelle

On 12/10/20 3:26 PM, Greg Kroah-Hartman wrote:
> From: Alexander Gordeev <agordeev@linux.ibm.com>
> 
> commit a2bd4097b3ec242f4de4924db463a9c94530e03a upstream.
> 
> The directed MSIs are delivered to CPUs whose address is
> written to the MSI message address. The current code assumes
> that a CPU logical number (as it is seen by the kernel)
> is also the CPU address.
> 
> The above assumption is not correct, as the CPU address
> is rather the value returned by STAP instruction. That
> value does not necessarily match the kernel logical CPU
> number.
> 
> Fixes: e979ce7bced2 ("s390/pci: provide support for CPU directed interrupts")
> Cc: <stable@vger.kernel.org> # v5.2+
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/s390/pci/pci_irq.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> --- a/arch/s390/pci/pci_irq.c
> +++ b/arch/s390/pci/pci_irq.c
> @@ -103,9 +103,10 @@ static int zpci_set_irq_affinity(struct
>  {
>  	struct msi_desc *entry = irq_get_msi_desc(data->irq);
>  	struct msi_msg msg = entry->msg;
> +	int cpu_addr = smp_cpu_get_cpu_address(cpumask_first(dest));
>  
>  	msg.address_lo &= 0xff0000ff;
> -	msg.address_lo |= (cpumask_first(dest) << 8);
> +	msg.address_lo |= (cpu_addr << 8);
>  	pci_write_msi_msg(data->irq, &msg);
>  
>  	return IRQ_SET_MASK_OK;
> @@ -238,6 +239,7 @@ int arch_setup_msi_irqs(struct pci_dev *
>  	unsigned long bit;
>  	struct msi_desc *msi;
>  	struct msi_msg msg;
> +	int cpu_addr;
>  	int rc, irq;
>  
>  	zdev->aisb = -1UL;
> @@ -287,9 +289,15 @@ int arch_setup_msi_irqs(struct pci_dev *
>  					 handle_percpu_irq);
>  		msg.data = hwirq - bit;
>  		if (irq_delivery == DIRECTED) {
> +			if (msi->affinity)
> +				cpu = cpumask_first(&msi->affinity->mask);
> +			else
> +				cpu = 0;
> +			cpu_addr = smp_cpu_get_cpu_address(cpu);
> +
>  			msg.address_lo = zdev->msi_addr & 0xff0000ff;
> -			msg.address_lo |= msi->affinity ?
> -				(cpumask_first(&msi->affinity->mask) << 8) : 0;
> +			msg.address_lo |= (cpu_addr << 8);
> +
>  			for_each_possible_cpu(cpu) {
>  				airq_iv_set_data(zpci_ibv[cpu], hwirq, irq);
>  			}
> 
> 
