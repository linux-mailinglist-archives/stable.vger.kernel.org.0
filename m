Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B671B249D
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 13:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgDULG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 07:06:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDULG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 07:06:57 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LB2uML056306
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 07:06:56 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30ghmc3me3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 07:06:56 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <fbarrat@linux.ibm.com>;
        Tue, 21 Apr 2020 12:06:48 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 Apr 2020 12:06:45 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03LB6opL36307070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 11:06:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EAADA4065;
        Tue, 21 Apr 2020 11:06:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D60F3A4060;
        Tue, 21 Apr 2020 11:06:49 +0000 (GMT)
Received: from pic2.home (unknown [9.145.42.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Apr 2020 11:06:49 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 4.19 41/47] powerpc/powernv/ioda: Fix ref count
 for devices with their own PE
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
References: <20200418144227.9802-1-sashal@kernel.org>
 <20200418144227.9802-41-sashal@kernel.org>
From:   Frederic Barrat <fbarrat@linux.ibm.com>
Date:   Tue, 21 Apr 2020 13:06:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418144227.9802-41-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042111-0028-0000-0000-000003FC42BE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042111-0029-0000-0000-000024C205FC
Message-Id: <132624ab-a9ce-cde2-a99c-e86f341195fb@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_04:2020-04-20,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1031 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004210084
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 18/04/2020 à 16:42, Sasha Levin a écrit :
> From: Frederic Barrat <fbarrat@linux.ibm.com>
> 
> [ Upstream commit 05dd7da76986937fb288b4213b1fa10dbe0d1b33 ]

Like for kernel 5.4, the patches 41, 42, 43 of this series are not 
desirable for stable.

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
> index ecd211c5f24a5..19cd6affdd5fb 100644
> --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> @@ -1071,14 +1071,13 @@ static struct pnv_ioda_pe *pnv_ioda_setup_dev_PE(struct pci_dev *dev)
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
> @@ -1093,7 +1092,6 @@ static struct pnv_ioda_pe *pnv_ioda_setup_dev_PE(struct pci_dev *dev)
>   		pnv_ioda_free_pe(pe);
>   		pdn->pe_number = IODA_INVALID_PE;
>   		pe->pdev = NULL;
> -		pci_dev_put(dev);
>   		return NULL;
>   	}
>   
> @@ -1213,6 +1211,14 @@ static struct pnv_ioda_pe *pnv_ioda_setup_npu_PE(struct pci_dev *npu_pdev)
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
> @@ -1236,7 +1242,6 @@ static struct pnv_ioda_pe *pnv_ioda_setup_npu_PE(struct pci_dev *npu_pdev)
>   			 */
>   			dev_info(&npu_pdev->dev,
>   				"Associating to existing PE %x\n", pe_num);
> -			pci_dev_get(npu_pdev);
>   			npu_pdn = pci_get_pdn(npu_pdev);
>   			rid = npu_pdev->bus->number << 8 | npu_pdn->devfn;
>   			npu_pdn->pe_number = pe_num;
> 

