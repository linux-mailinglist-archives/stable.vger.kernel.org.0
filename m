Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C48A26F5F6
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 08:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIRGfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 02:35:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725886AbgIRGfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 02:35:19 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08I6Vtd1076891;
        Fri, 18 Sep 2020 02:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ElRNygLTk5cj/N20j1+KOLxchczmloacugV3rJOWm3A=;
 b=dQV3RDvSXQwQbSWwF+ynPOAvOm2aEXjQiza8MydhlqtG9ArioM7nYuc4ZxaoYKCEsghu
 qCGg6e1hRCRL2E6e3j+203AR1KoDmAdI9ydZkRJcqLIjFvuI/n424YMu5GGSVGyW3xuG
 lR5Pu57Exi7UGo8Dv7ed5RDaksK5QPm6l2jCdTm6tuN7V0ibVcRxShNVcwX3g3OAcfAB
 0hiVlaVnFulbpy3z3QxOljhTZk0+uxXBdCuNKZOBaXUF/Fv1rxmJE8Ww9T4gl/cFcvEz
 OOz1ojSqHYjUSsfbg3tT85UZ3muXUNU1EE1gVlrT9KXLA6Trn3Yt2y/lBEY+Z9RnCuh2 hg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33mqp5g3cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 02:35:11 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08I6SHkX001345;
        Fri, 18 Sep 2020 06:35:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 33k9geaqcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 06:35:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08I6Z6xN20447668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 06:35:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E352FA4065;
        Fri, 18 Sep 2020 06:35:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E3F4A4064;
        Fri, 18 Sep 2020 06:35:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.94.88])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Sep 2020 06:35:06 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 5.4 101/330] powerpc/powernv/ioda: Fix ref count
 for devices with their own PE
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
References: <20200918020110.2063155-1-sashal@kernel.org>
 <20200918020110.2063155-101-sashal@kernel.org>
From:   Frederic Barrat <fbarrat@linux.ibm.com>
Message-ID: <52532d8a-8e90-8a68-07bd-5a3e08c58475@linux.ibm.com>
Date:   Fri, 18 Sep 2020 08:35:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200918020110.2063155-101-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-18_06:2020-09-16,2020-09-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=978
 impostorscore=0 suspectscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 clxscore=1031 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180053
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 18/09/2020 à 03:57, Sasha Levin a écrit :
> From: Frederic Barrat <fbarrat@linux.ibm.com>
> 
> [ Upstream commit 05dd7da76986937fb288b4213b1fa10dbe0d1b33 ]
>

This patch is not desirable for stable, for 5.4 and 4.19 (it was already 
flagged by autosel back in April. Not sure why it's showing again now)

   Fred


> The pci_dn structure used to store a pointer to the struct pci_dev, so
> taking a reference on the device was required. However, the pci_dev
> pointer was later removed from the pci_dn structure, but the reference
> was kept for the npu device.
> See commit 902bdc57451c ("powerpc/powernv/idoa: Remove unnecessary
> pcidev from pci_dn").
> 
> We don't need to take a reference on the device when assigning the PE
> as the struct pnv_ioda_pe is cleaned up at the same time as
> the (physical) device is released. Doing so prevents the device from
> being released, which is a problem for opencapi devices, since we want
> to be able to remove them through PCI hotplug.
> 
> Now the ugly part: nvlink npu devices are not meant to be
> released. Because of the above, we've always leaked a reference and
> simply removing it now is dangerous and would likely require more
> work. There's currently no release device callback for nvlink devices
> for example. So to be safe, this patch leaks a reference on the npu
> device, but only for nvlink and not opencapi.
> 
> Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
> Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20191121134918.7155-2-fbarrat@linux.ibm.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/powerpc/platforms/powernv/pci-ioda.c | 19 ++++++++++++-------
>   1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
> index 058223233088e..e9cda7e316a50 100644
> --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> @@ -1062,14 +1062,13 @@ static struct pnv_ioda_pe *pnv_ioda_setup_dev_PE(struct pci_dev *dev)
>   		return NULL;
>   	}
>   
> -	/* NOTE: We get only one ref to the pci_dev for the pdn, not for the
> -	 * pointer in the PE data structure, both should be destroyed at the
> -	 * same time. However, this needs to be looked at more closely again
> -	 * once we actually start removing things (Hotplug, SR-IOV, ...)
> +	/* NOTE: We don't get a reference for the pointer in the PE
> +	 * data structure, both the device and PE structures should be
> +	 * destroyed at the same time. However, removing nvlink
> +	 * devices will need some work.
>   	 *
>   	 * At some point we want to remove the PDN completely anyways
>   	 */
> -	pci_dev_get(dev);
>   	pdn->pe_number = pe->pe_number;
>   	pe->flags = PNV_IODA_PE_DEV;
>   	pe->pdev = dev;
> @@ -1084,7 +1083,6 @@ static struct pnv_ioda_pe *pnv_ioda_setup_dev_PE(struct pci_dev *dev)
>   		pnv_ioda_free_pe(pe);
>   		pdn->pe_number = IODA_INVALID_PE;
>   		pe->pdev = NULL;
> -		pci_dev_put(dev);
>   		return NULL;
>   	}
>   
> @@ -1205,6 +1203,14 @@ static struct pnv_ioda_pe *pnv_ioda_setup_npu_PE(struct pci_dev *npu_pdev)
>   	struct pci_controller *hose = pci_bus_to_host(npu_pdev->bus);
>   	struct pnv_phb *phb = hose->private_data;
>   
> +	/*
> +	 * Intentionally leak a reference on the npu device (for
> +	 * nvlink only; this is not an opencapi path) to make sure it
> +	 * never goes away, as it's been the case all along and some
> +	 * work is needed otherwise.
> +	 */
> +	pci_dev_get(npu_pdev);
> +
>   	/*
>   	 * Due to a hardware errata PE#0 on the NPU is reserved for
>   	 * error handling. This means we only have three PEs remaining
> @@ -1228,7 +1234,6 @@ static struct pnv_ioda_pe *pnv_ioda_setup_npu_PE(struct pci_dev *npu_pdev)
>   			 */
>   			dev_info(&npu_pdev->dev,
>   				"Associating to existing PE %x\n", pe_num);
> -			pci_dev_get(npu_pdev);
>   			npu_pdn = pci_get_pdn(npu_pdev);
>   			rid = npu_pdev->bus->number << 8 | npu_pdn->devfn;
>   			npu_pdn->pe_number = pe_num;
> 
