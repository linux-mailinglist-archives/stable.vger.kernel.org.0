Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6463FC147
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 09:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbfKNILm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 03:11:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726000AbfKNILk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 03:11:40 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAE88Oww098428
        for <stable@vger.kernel.org>; Thu, 14 Nov 2019 03:11:39 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w91dukcwu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 14 Nov 2019 03:11:39 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <rppt@linux.ibm.com>;
        Thu, 14 Nov 2019 08:11:36 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 08:11:34 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAE8AuTk36569358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 08:10:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA95252051;
        Thu, 14 Nov 2019 08:11:32 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.148.207.103])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 5609A5204F;
        Thu, 14 Nov 2019 08:11:31 +0000 (GMT)
Date:   Thu, 14 Nov 2019 09:11:28 +0100
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Max Filippov <jcmvbkbc@gmail.com>
Cc:     linux-xtensa@linux-xtensa.org, Chris Zankel <chris@zankel.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xtensa: use MEMBLOCK_ALLOC_ANYWHERE for KASAN shadow map
References: <20191114010824.29540-1-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114010824.29540-1-jcmvbkbc@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-GCONF: 00
x-cbid: 19111408-0012-0000-0000-0000036383F2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111408-0013-0000-0000-0000219EFBE0
Message-Id: <20191114081127.GB13537@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=807 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140077
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 13, 2019 at 05:08:24PM -0800, Max Filippov wrote:
> KASAN shadow map doesn't need to be accessible through the linear kernel
> mapping, allocate its pages with MEMBLOCK_ALLOC_ANYWHERE so that high
> memory can be used. This frees up to ~100MB of low memory on xtensa
> configurations with KASAN and high memory.
> 
> Cc: stable@vger.kernel.org # v5.1+
> Fixes: f240ec09bb8a ("memblock: replace memblock_alloc_base(ANYWHERE)
> 		     with memblock_phys_alloc")
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>

> ---
>  arch/xtensa/mm/kasan_init.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/xtensa/mm/kasan_init.c b/arch/xtensa/mm/kasan_init.c
> index 9c957791bb33..e3baa21ff24c 100644
> --- a/arch/xtensa/mm/kasan_init.c
> +++ b/arch/xtensa/mm/kasan_init.c
> @@ -60,7 +60,9 @@ static void __init populate(void *start, void *end)
>  
>  		for (k = 0; k < PTRS_PER_PTE; ++k, ++j) {
>  			phys_addr_t phys =
> -				memblock_phys_alloc(PAGE_SIZE, PAGE_SIZE);
> +				memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE,
> +							  0,
> +							  MEMBLOCK_ALLOC_ANYWHERE);
>  
>  			if (!phys)
>  				panic("Failed to allocate page table page\n");
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

