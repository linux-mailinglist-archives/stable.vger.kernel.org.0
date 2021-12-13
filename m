Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E7C472EFA
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbhLMOWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:22:33 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2308 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239167AbhLMOWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:22:31 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDBRFAu028110;
        Mon, 13 Dec 2021 14:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8UkAJbTvQuZHkFPrIjOMQn6E8AX15Vu1tyXfM3kZAzM=;
 b=gVEcedlTjuilaeSo3X3yFMpsQbAQNT7MB1cJ4m2UxnliX0DExVKPgvsCVRYS/qWGJq8A
 Tyo1M8XsgPcyW4JJLV1x/XaoKuU7AOEbxpg82JRMNoP7NgZlKkkW5aweNAsHrD8hphMJ
 Cc0PjhsUCfMpr3TqgPEHJ3+//5q2YNnlwhVmUb9/mzdLNGdvS2Hl/EeEmC8nkDe3R0LP
 BSRCGNI81rvHB6Iytk0GCEiIXMWMOIKAyWscsbT6VYiCWuFvdQ2J2ZUiXi9gSa+Q89Nf
 HWgvpWDlwodLQLs/9YrQfFD61rncfoQzjDXA+QiQSXCU8iEcd5BytQ/DqyqCgl66r4VK pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx5ak8c0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 14:22:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BDEBlYh050616;
        Mon, 13 Dec 2021 14:22:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3030.oracle.com with ESMTP id 3cvj1cb8f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 14:22:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UA1t8yTNbBF6FfCq2HifvFJYin0aC6yLTyLHt/EIm6toggB3yrT7EWAh4vYJ2xHu53gguOmemFdBxRyQIsnA6Ol/2G5RygY/e+nU7nQ4UD+XgwiLZ4n2nTgYVxHoSNs3KnUTvVf2YX0BAYS/0HsRlYY4t+x3TreOoclykCBSDTG8NOw4VoaFYIMlT7yuz8+dX7bQNtG3mgSigr9aTc4FBVRWTHk2zS7BCWMccnDFpwOCL74Uhp8YoQt747Eon7JE036R2g6fuW8MOd0Cs0jFQm1L8YASwJisdwKAGc6MECh/h0AKDxfFVrC5ns6MLwNIPnpVN8VHwBJcMFuroFOL3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UkAJbTvQuZHkFPrIjOMQn6E8AX15Vu1tyXfM3kZAzM=;
 b=Cl5tMpQi722QuZI/CvooICxesuknO5VI/9AP1WtVQ8gNc7tGFdsbkL0CVbqPeDO1B0YuLrSq3T9RUZWfPw7WWIGEF0/OwWkHgCupdM0z4Ua68hYRTIKy2e9wZ0qWR1Plh+PVRTYovsoc+wnMTE5IdFWGaSKtrxowkG3O1/HZv+uSj0xXNkAsOO8ZDUHnGqHx7pimC4vyV5pR7JxGF7rWy738adl6iZRxgxJ2eoEL3mBT+FS9A71AauRxtNwQbOTp2EHJktiBrK4dXD4PQ+KDFfJPe0ne8yCvVm9UlTkP4wwYN4cDgCVRzJ+7EwHWuVoXtOxArDA3KzgBqf5W61VgJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UkAJbTvQuZHkFPrIjOMQn6E8AX15Vu1tyXfM3kZAzM=;
 b=TtU8pbVME7R32iVp001soWglKpacqhE8TpHBd2CGyWZ+8tYwg2Wx2ee3gytvNnMbK2TCAdTBDBZOQWd6e6PDBDNOfkKvljyDAViKR+bJUtPZYWpiufCCh1LMvciUjZrtjwm7/WyYfotyb1wQ+FSTsegfuZutaIHf/2xWpxJO3pc=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR10MB1517.namprd10.prod.outlook.com (2603:10b6:300:23::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 14:22:19 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::54ed:be86:184c:7d00]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::54ed:be86:184c:7d00%8]) with mapi id 15.20.4778.018; Mon, 13 Dec 2021
 14:22:19 +0000
Message-ID: <ab387012-c1a8-c3f0-8c84-dadf82ce2d9e@oracle.com>
Date:   Mon, 13 Dec 2021 08:22:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v3 3/5] mm_zone: add function to check if managed dma zone
 exists
Content-Language: en-US
To:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, John.p.donnelly@oracle.com,
        kexec@lists.infradead.org, stable@vger.kernel.org
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-4-bhe@redhat.com>
From:   john.p.donnelly@oracle.com
In-Reply-To: <20211213122712.23805-4-bhe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0143.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::28) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 137eeb7f-b26a-4964-65ff-08d9be43f867
X-MS-TrafficTypeDiagnostic: MWHPR10MB1517:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1517D0B1ED50F3DA2E3AC4E5C7749@MWHPR10MB1517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iSXVLebMqSY3BTShmsf/hdZuUvcN94xsdYZcIk6AhqvXFOCO+s72H3f4lksae72jm1d0TfM7t3qN8renu94JosO0yJPQsRAKF0JA9ajtdlb+ZV14kOG/SU4BmJdJd7lh9f1txn6o2eVcwUsAO+wrfESoHkjwlzRntFglsPwOf2XoVCgSAglsSooFb0+rIaY/1PbkQqgICYtESLBVEl8Mmi4VuZvXL3un4C1kR0PU3ILzKCHz/MiFEejDa+8yvazMUoo32HCI8YuZzZ/nip1UqIlQsZHbLY27v2cJXthjamA/XJHgoUu+M93NARHFD2lAvaKOg2lML5HCczAWteFEhYwLo4/N7rSlhlhaesZQYRDvK28AGwo306B2NMc6a9M/q8riNpupX1gWCixaxCqPMbxrsqDbOXLyL/i+8i5I7xdrvsYOKb8gpRQF9vddPAz4ripL60tPeZC1rlr+aTrM6xe4SAQPOnd6n/T+NqG0SJW2O0tKOLPhrnxVQ2dNl86jltma4SbmOehn4VmrR3lFBQQrtwobFpTFk+9Z54pafl5cTlLmtAH8HDTWmbPHUisKVTHRfnsBXbiFbKZIYdIB/Nam+yluBzf+QNAgguxmH6vu4QhJxUZrjDHqJA9SyhG5PkHtnNNEW9L13zAFYmEwuVpSv0pwpJyjqDFRn0hwNF6vUwG7Bii2JTVLbVttd1A71JEDzLI5QCSEyhgwaaCQzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(2616005)(53546011)(6666004)(31696002)(9686003)(6512007)(36756003)(5660300002)(83380400001)(4326008)(2906002)(8936002)(26005)(316002)(66946007)(8676002)(38100700002)(66476007)(66556008)(186003)(86362001)(31686004)(508600001)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3lDcmdxQ0NFQzNOdWtVdUZ4VFJzMGZWbjM0Vis3ZU5KUHMwd25iRG9BMVFW?=
 =?utf-8?B?MkFHYWZ1bXBFQ1BnYkFXZkY5U3NBVk1ndDB2eTNGZkJzZTdJelEya3FsZEdT?=
 =?utf-8?B?V282d2VoMHp0UGJhNUEwTmpleTZ0TW9aRm00QlVWZXJUaVNFQ0N0ZnFSNUlT?=
 =?utf-8?B?WlJleWRWYUZOMUloZVF1RTluQ2RJaFl5SWRyazZuM0NXbEpKeVQxZUFNSUl0?=
 =?utf-8?B?UUh6eWxyMURVeU5LMTFVdktnRUZPMWZSMERMakExZDdNemJFaGR4WkhXNlNL?=
 =?utf-8?B?MkpNUHh5NjVhbllnR2ExbXE5TjRtSGttd1VIZldTRk1nMG9MVTZqZ2ZySnBP?=
 =?utf-8?B?TThhams2QklDTi82eGFyVnlzUTBBT2hkcTNTRllXd3R4bGc2OGdKOWh3Q0VU?=
 =?utf-8?B?MWtOdlVqOUJUaG9Ga3ErRjJCbWd5NUpIM3hmc3VyRmZLYy9UYVJDVDczTDJm?=
 =?utf-8?B?WCtISm1vOTM5Q3lTN0dGd1JGZTI0dGxiRDNQblRQQ0tWKzF4WGsvQzUxb2cw?=
 =?utf-8?B?SzBjdVA2a1lDelJwUStBRnR4T3JmTitKQ0N6Z0w2NHVVUE56MFZkZ3pjRXN4?=
 =?utf-8?B?RDl3WitSMVYzYThuMllIWEd5ZlpMcW01YU5Jb1lCYzRRYWpRbWZVeWlRSVZE?=
 =?utf-8?B?dTdYZ1pkUkZCb3VMN1Uyb3lsMndjbGlQNHUvU2RObDlRTGJBeUdpaGQrVStM?=
 =?utf-8?B?Y004VWovSzRJYUdiUjd2T2hnV3h1bHl6ODBpR0tST3JiZm15Ri85VkdGWDdw?=
 =?utf-8?B?bnQ2R0lmaU9vUkJSU3MvRGhOTzY3ZWVsZEhoZW9iYjV2SHNyOFBJbFoxRFlZ?=
 =?utf-8?B?R1Y0RkhkM2pLRzZnclYrQVlXemlYWlkrMWZsaEtOZE8xaEFFdG9WbkZDeXdn?=
 =?utf-8?B?S29xeE05MUwyN09hVmdmZjREdlJNUW1jNGQ3RWJMclk1V3hFNGt4SG1mbjhT?=
 =?utf-8?B?T0J6T3pPOEN6UW13ZlZOZnZJeWttRXN1RnZ3MnU1ZmtvL2JOYjNYdVNEVmtm?=
 =?utf-8?B?TkN2NElUeUw2ZVRPL0pkMlhpc1lKT1BqZnl4elpvTS9mMmc3TytMR1U2TU1M?=
 =?utf-8?B?dlIwenpaaElrTm1MWFZWaGtTWmV4dEFPNjlYTTZGeDhVdnRmWm9YUGJodlBh?=
 =?utf-8?B?eG05ejg4Skdud3VXM0xUeE9SeEcyRnJxcHM5VnEwZnpkZ1Z4dHZ1SEVOazN1?=
 =?utf-8?B?YVE2Z0hsZ09pUVRSdkVJVTdHRjVLKzNLVVNaT3hiMVBNMldZaGFtVlAzOVJY?=
 =?utf-8?B?Z1FWeHVtMFFXZWQwQW9MRzF4VUY1OWw5QVp5REJRNlpNSldoMVJNaWhrUXBr?=
 =?utf-8?B?Tk1YMWlJYWtvUlVtTSt1Nk1wQTc5VUhrVTdhTFhsbjNpK1JWOFJOdUlIcS9M?=
 =?utf-8?B?UjNUM3N0UTk2clowQkNpWk9lSFI1aVkvQlRDbktBQmY2N1h0MjFOSTc2bGs3?=
 =?utf-8?B?dnNlNlJFNk42dzhGdmoyNzkzSTNVUzllWUltREVSOVpDV2xyYnZrWlp0bTBG?=
 =?utf-8?B?ak9HclR2N1FCUXNLSE1XZ1N2WUZadUVxT3F4RUt0YW9sR2w2MmNxeU1MYjhx?=
 =?utf-8?B?bDRiSjhMK0lrT0lTdjE1dTl5K0pLMWpoMlNVOEEyVlliY3R0Lzg5RzJ1RXRQ?=
 =?utf-8?B?Q2VwaFo0ZHBTckNYVitQMnUxOTd2cG53Q3c0VTNwVHQrYzR4UUFZQXh6Risx?=
 =?utf-8?B?V1c0TnRJM0x5anhyVm9sRXMvVUh2YmFmdkowMXB2M0dDeEhjZkZSZ2Q1bkpq?=
 =?utf-8?B?SkJ1QjhVaWdHcVNSdGdTVnFDdmZYTml3a1VjaXF6emxPMS9vcVNWN0kxV0lw?=
 =?utf-8?B?UEN6U2VESTVaa1Rvcm55ZFlUampEeTJ5cW1LL2NaQzRzekdJR1I4cUFMRXVh?=
 =?utf-8?B?U3diUjhvU09STkNteHFSTnZMb0VSSG1kVXJRTUU2TWovc2Q4WXNIWVVBUUZo?=
 =?utf-8?B?NzAreWc0TVVsMWQ3Vm5SZFM1a3d6UDY0akllSjd4Znk0V1JYd0JTRTg0VTl4?=
 =?utf-8?B?QWFVeXo5cjhCdkI2Q3d2RmE1YWZqL2R5bWRzb0s4MUNQdk5zL3dNTlhWejB1?=
 =?utf-8?B?TWxkLzdBb29ldGxtNEFCWDhQQ2w3cCsySFNobUtXcVdZV0xhSU1ISm5YUktM?=
 =?utf-8?B?Z2dtejdkZC9ac3d4ZzhNZmFtR2ZLalZxRFBRSllSb1MvK1pIblMyNXYraml4?=
 =?utf-8?B?OTFCdDlNUm96WDhRSExXNXRRQ29UeUozZ2dDK1dQaHhzRkc2QVV3QkdqZVdu?=
 =?utf-8?B?aDJMN2FMd2dGMmJhSXM4Y0o2NGJnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 137eeb7f-b26a-4964-65ff-08d9be43f867
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:22:19.1747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F8su5N+k2ueIFuc8mJIyWJBlZ6GLBoxgDM+8wXS2w29ODDSjHyRZyJtBBsJRl/yYmV0nKPKp2ISP0EL9cufgF8TqgbRDy7zwWPzc6/P1NE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1517
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10196 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112130091
X-Proofpoint-GUID: PgvKXQbGvP6No9dexDukjrHphqIn6DPo
X-Proofpoint-ORIG-GUID: PgvKXQbGvP6No9dexDukjrHphqIn6DPo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 6:27 AM, Baoquan He wrote:
> In some places of the current kernel, it assumes that dma zone must have
> managed pages if CONFIG_ZONE_DMA is enabled. While this is not always true.
> E.g in kdump kernel of x86_64, only low 1M is presented and locked down
> at very early stage of boot, so that there's no managed pages at all in
> DMA zone. This exception will always cause page allocation failure if page
> is requested from DMA zone.
> 
> Here add function has_managed_dma() and the relevant helper functions to
> check if there's DMA zone with managed pages. It will be used in later
> patches.
> 
> Fixes: 6f599d84231f ("x86/kdump: Always reserve the low 1M when the crashkernel option is specified")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baoquan He <bhe@redhat.com>

 >
  Acked-by: John Donnelly <john.p.donnelly@oracle.com>
  Tested-by:  John Donnelly <john.p.donnelly@oracle.com>

> ---
> v2->v3:
>   Rewrite has_managed_dma() in a simpler and more efficient way which is
>   sugggested by DavidH.
> 
>   include/linux/mmzone.h |  9 +++++++++
>   mm/page_alloc.c        | 15 +++++++++++++++
>   2 files changed, 24 insertions(+)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 58e744b78c2c..6e1b726e9adf 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1046,6 +1046,15 @@ static inline int is_highmem_idx(enum zone_type idx)
>   #endif
>   }
>   
> +#ifdef CONFIG_ZONE_DMA
> +bool has_managed_dma(void);
> +#else
> +static inline bool has_managed_dma(void)
> +{
> +	return false;
> +}
> +#endif
> +
>   /**
>    * is_highmem - helper function to quickly check if a struct zone is a
>    *              highmem zone or not.  This is an attempt to keep references
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c5952749ad40..7c7a0b5de2ff 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -9460,3 +9460,18 @@ bool take_page_off_buddy(struct page *page)
>   	return ret;
>   }
>   #endif
> +
> +#ifdef CONFIG_ZONE_DMA
> +bool has_managed_dma(void)
> +{
> +	struct pglist_data *pgdat;
> +
> +	for_each_online_pgdat(pgdat) {
> +		struct zone *zone = &pgdat->node_zones[ZONE_DMA];
> +
> +		if (managed_zone(zone))
> +			return true;
> +	}
> +	return false;
> +}
> +#endif /* CONFIG_ZONE_DMA */

