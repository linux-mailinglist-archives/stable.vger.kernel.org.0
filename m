Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5A0160DC5
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 09:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgBQItt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 03:49:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39688 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728160AbgBQItt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 03:49:49 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01H8nLJR083593
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 03:49:48 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y6af2r9vt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 03:49:48 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <fbarrat@linux.ibm.com>;
        Mon, 17 Feb 2020 08:49:46 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 08:49:42 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01H8mk9O48431508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 08:48:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E48D6AE045;
        Mon, 17 Feb 2020 08:49:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8A6FAE051;
        Mon, 17 Feb 2020 08:49:41 +0000 (GMT)
Received: from pic2.home (unknown [9.145.20.186])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 08:49:41 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 5.5 096/542] powerpc/powernv/ioda: Fix ref count
 for devices with their own PE
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-96-sashal@kernel.org>
From:   Frederic Barrat <fbarrat@linux.ibm.com>
Date:   Mon, 17 Feb 2020 09:49:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214154854.6746-96-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021708-0016-0000-0000-000002E78497
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021708-0017-0000-0000-0000334A92CE
Message-Id: <0867167a-73b8-0735-78ce-0d984f7a80b5@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_04:2020-02-14,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=732 spamscore=0 clxscore=1031 impostorscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002170079
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 14/02/2020 à 16:41, Sasha Levin a écrit :
> From: Frederic Barrat <fbarrat@linux.ibm.com>
> 
> [ Upstream commit 05dd7da76986937fb288b4213b1fa10dbe0d1b33 ]


Hi,

Upstream commit 05dd7da76986937fb288b4213b1fa10dbe0d1b33 doesn't really 
need to go to stable (any of 4.19, 5.4 and 5.5). While it's probably 
safe, the patch replaces a refcount leak by another one, which makes 
sense as part of the full series merged in 5.6-rc1, but isn't terribly 
useful standalone on the current stable branches.

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
> index 4374836b033b4..67b836f102402 100644
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

