Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62863472F0C
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhLMOXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:23:48 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:56518 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234786AbhLMOXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:23:48 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDDQ5tV011744;
        Mon, 13 Dec 2021 14:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=XWm4A5fAPoZqDfpJiDE0db0FAczCxmp+FTYfvct/6Rc=;
 b=palPGs9kgpNSDxCdF7QGHsfZLhEt5IGmMbL8zQ/Du279JpwIUHNC8N9i+RlgFmHnME5F
 MeH3JdzrtDfiGfer+NLxDFVVqW8KMoXF/+hLbiJniWPjHKe6Peztm7i2dGO3fVEZ06Sd
 rrLXkxJPfRJAb5++j6wLuSo4DR5X+uw0W1TKMf10S7uKYUWXtxEm1S26LwpFGp/DEIZ+
 axLUZ6shUoZb/2Qmwkwrf2+g2ArAn5MiDvLmx7Ox3QfqEcFrm7zMItzdWFz8Q8h1OYnQ
 a1wzuHMwkaCkjIM0HVFCPmH/w4jkr/1onNX4PetXBhOVbacl5QJtwAYaUp0vcRKa+GZr mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3uk8kpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 14:23:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BDEARWw009138;
        Mon, 13 Dec 2021 14:23:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3020.oracle.com with ESMTP id 3cvkt30uqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 14:23:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpyrQmAgnKI3StF19CX2QvDqpumhGts9mGpFt91XECnHOCVkbEzgJ1LpUI3K4c6wqNA+hTmYbUiuduSUu7XFdbyaHWs0CPGysvmnWTj7oVbIh/ZDel8/CEFX6URTpKdqOErk0qzik590GToJeKTOrYnHgZAHmih4RKxHSLBS3JaDcEv34AL1V+dtuAVzybKNlfrudtTO3qfQn69BdPym5BaPNeqoy8uPd02fgn2zhOFOXtl6u/oQCZPe2rICfOXu3zZZI9T+ptZAPmnBOaqRX60CaqQ67d5auV+Ss8/uVqDitXHHVT8wMXFk9je0dnF55F/G7/xZg4rA6SWe2yQi3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XWm4A5fAPoZqDfpJiDE0db0FAczCxmp+FTYfvct/6Rc=;
 b=eFcyPUSzAf7E8blf/riWqUmjK71t7aAtloTSdOzL4Wk3rKThwa5MC5tTm1y8jTAT66pIiWd4jnW5z0j6XmdO/p5TY6W/Qed9vF55SIXDyge+8bpWszPEjaXcEaJcCt5QqxWsUBxMmznpgSaMSfObZUVYdpw3fZ9+LcZye6GRIjNe7tS9uk/d/QO5q1VNuTZNYMQmPB4941aOvDLruc1+0NF/AYIQFideFYMgojUKF6dQnt8eX32ml438ZDO137jNx89/wg5aYtIAdgQYMMP4rpb0jvHJAqViTOgoekWyOIE7kLDWbyjeX0QZQe8yd3nT6a/EX5adJYjWdHTfIg7cyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWm4A5fAPoZqDfpJiDE0db0FAczCxmp+FTYfvct/6Rc=;
 b=o3wJ7y3bWnQXmcAgJLZ1Pkg/aWKTY7AZKFMkWBaZy84J2pj/75gg2eN5k/6IQ2/vWWKI7bSYdnau4X8Jeyw8pr+4asqOr311mxEgqbPmitWSnT0qgdpL95NYib7B37Zw43Sd8G+mFbFZKKCOiLYSIhSLSZ+OHegye+zrCJhlTlo=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR10MB1759.namprd10.prod.outlook.com (2603:10b6:301:8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Mon, 13 Dec
 2021 14:23:29 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::54ed:be86:184c:7d00]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::54ed:be86:184c:7d00%8]) with mapi id 15.20.4778.018; Mon, 13 Dec 2021
 14:23:28 +0000
Message-ID: <f7cb4884-72c5-dab3-c2e0-323d826febae@oracle.com>
Date:   Mon, 13 Dec 2021 08:23:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v3 4/5] dma/pool: create dma atomic pool only if dma zone
 has managed pages
Content-Language: en-US
To:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, John.p.donnelly@oracle.com,
        kexec@lists.infradead.org, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        iommu@lists.linux-foundation.org
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-5-bhe@redhat.com>
From:   john.p.donnelly@oracle.com
In-Reply-To: <20211213122712.23805-5-bhe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB6PR0202CA0047.eurprd02.prod.outlook.com
 (2603:10a6:4:a5::33) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7aefb268-0c4a-45fb-bd3c-08d9be442206
X-MS-TrafficTypeDiagnostic: MWHPR10MB1759:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB175920286189F7F9111222FAC7749@MWHPR10MB1759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n1gQcwFHPyxXHv+iLKt/fqRVOKO4WHSEfBR2o2GzMV5c3dZTdSbwQrdEj2TQVUe8eObxRCmjQ7qSYFT87yiFxO7QJ2CCmqrv2b300cjShNRpif+M+7yhpV2Q9rVXkkvU1w+Y2mZXApVk3nfQYkCH8XTzLDWpKLqoC06G1WbTFnCd6piKQw6gdCXMyxzHQhLqMbJDHwgfwu6JbhHSuy88irzZwi2bb4nM2yMfr35V2iYiLd22MBuXrULaClfSRJ03+3dQOay/O11QvghkhEuZQTED5MNTu2zEOMWcJDivbiehBLWhNdxem1e4Lh5weuRjQS98k34XZEP41BvOxNt4YcKWjoiaGDOgNtZTc/XzbO3LNVtdex/ODYjsgm5nsJlDSEDlJJV/T7t2OAPl7TsxHmSwlI45v87JmLhfHOq/KidHlqFdYPOgIDWpLU2FrXuKoBI0XARY3muECgTKIU/7bQ9Lfp1a9WEIwyg/tEsADqTjBk6cMQ9BY6nuG+o6SZAwG6GwMCDznhxTB8QEbijHI28jMD6AIYT3UjOx82RgCehN2X2cHNf32stS2wuJYQz/u9tn8l/wAIVORptzYrgtMtEkQyiQu4UFeJy8c+L5zUhSc0VVdeV0wtg4+N4GVgaMRwjoC4ttj44TywdxYVwQlJ3UeWNTRt/RAmExH2+K0kplypFS6SQgEtBUChV6BU9eoyq8RmVrPvz6efBgHlJiRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(6486002)(6512007)(9686003)(36756003)(6506007)(31686004)(66946007)(53546011)(8936002)(38100700002)(508600001)(5660300002)(66556008)(66476007)(316002)(2616005)(54906003)(86362001)(186003)(26005)(4326008)(83380400001)(6666004)(7416002)(31696002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ty9SZkhTSytvQWszODVPejF1RmN5RkhreGdxV3Q1VVAzQ0FsOVNaczdsWFcv?=
 =?utf-8?B?ajNFWlZoblozS3IvQzhaZ2E0Z2RWTytydkNoeC9MSnZaWVN0Z3hXYTg0TGRO?=
 =?utf-8?B?V2RURU8rVkNJZHg1Vk9pdE1NOUUzVkxHSjQ1ZXRtR1NHdVYvRUFYUnllcjFJ?=
 =?utf-8?B?UHovRVpEZHAzSHBmNndrTHp2VUlUSkdvQllBcXhoakpIZlNzeHgwVUJqTlpS?=
 =?utf-8?B?R2hvUWJwRmswbkUwMnQrUlJQYk9GL0preXpIOG01U0hscG9BMC9oMHlTeG5i?=
 =?utf-8?B?YUVsazVoOG5xUytTVmh4YWdUendlNjI1VjdnN1NETzBSdVg0M0FkSWV6K1pK?=
 =?utf-8?B?RGg1UkV0aVo1VHVOVnpQekhaRXhuMlE1NS9JTGRqc0xid0xMMTVvN005VmZi?=
 =?utf-8?B?aGdRQjVtdUZsc1Y4a2pGRkZsWUdxNUZMZU5qaTh1TWF4NFhoU2Jua0NOTUli?=
 =?utf-8?B?VWxBQlhoaURFVWJnZkxDVHpieGo5NjBJTXJPbXY2SXlTTjc5SXNCNEYwaURR?=
 =?utf-8?B?TklQdXFHN0FiUHZ1em5EV2ZSVjNoSTFnc2hOaVFrbVNmVmZwMC9qWGxvSUht?=
 =?utf-8?B?bmVVWk1Jd3VWdklwbTg2eWplYTNqdGZqS0xSS0lLajdKRFhIOVZ6NXoxL09v?=
 =?utf-8?B?MVlEQzdacUNoZUg4Rmhkc3QwOHQwZU9RblBVaG4zTWkyWXpIRnc2ZlhFRXVM?=
 =?utf-8?B?RDROeTBQZHIzVndJSnc2MU53N3hIZzZhZ1ljNWRWTmhjSDBwQ1ZuOHBhbGpo?=
 =?utf-8?B?ZWw0OXFLWDYzUVZmU0p4K3FWb3IzMEpJTk9mVEZtQkMwaUhGcWFrc1ZLN0Jt?=
 =?utf-8?B?MjJhYkNLbjBualBzSHpwK1grQ1ZBcGI3dndidDhVODIyR3B2bmRvZDFQT3Rh?=
 =?utf-8?B?MHRBZlExWC9zVEpRMXdsb1ZsRkt5TGF5VTJKRW95YlBwd3RXWnFmS0tlQnBS?=
 =?utf-8?B?Q0FPU01jRW56Q3l5QTVrMXdKenV3dEhBdHhhM0ZwV2hKZURFSCtwOUhiZDZi?=
 =?utf-8?B?a2V4VkZndjF4c2NxSyt2d0E0MkNtRFVPa3R1Z3NlcUhGS2N5bGlhNzVBZ0VJ?=
 =?utf-8?B?ZDM4Wlhta2xqRlI2dE04MUpXMHlvUG9vMDhuVVB6eXRsTHB6VmNVQ0lEK0lP?=
 =?utf-8?B?eVlENURWSjVzUXdOMXZxb1pRaEtKME5DRnFIYmpBUEcrREZWM21KbDhJS1dr?=
 =?utf-8?B?RHlhcEFUZWNOdzB4MU5aTENlUDlhS05TK0VIMVRlY3hjVEIyRDhFZzN3TDlK?=
 =?utf-8?B?THpxajdBM0QzbHZVWml3d1RQN3Y2OXV6TVNDaWFmZm44eFQ4NkJTVTFkVkF5?=
 =?utf-8?B?bCtFemd0RHlEK3Zhemx3N2IrUGRNSGZMK2tTdUpjN1BFUlQ5ZGxIVENFaE4w?=
 =?utf-8?B?UWRGM1dzOHIzRlZnSlE5YWVYUE9Kb0tyYnk5MkNXWDAyK21NanZLNmlST3Q0?=
 =?utf-8?B?MVpCcmU2KytJdThKekRwMm5lYWl1bkxaSU5jOHhxc3M3SUVJVDBmY09RVjRT?=
 =?utf-8?B?YkZKVVowV1BrUlluVlpkRkNaL1JiRnRnRWI2dXRkMzBPdHhzQ0R5S1BFaWFp?=
 =?utf-8?B?WXpoSUwycTVmZ3FXZVk5c1luRVBiSjJQbGhsWmxCbmN0R3ZTSVk2QkRtYUpD?=
 =?utf-8?B?TDFsWTJaOVhCc01KSTF0T3F3b2IrOHNtTEMydTd0R1dEMHo0NFJ3Y0JrelI1?=
 =?utf-8?B?WmFzQ0Q1d3hRNThZSm5YaDlCdVYvSVpTWDJoSk1PWTArUnNNTUZBeHdyTnM0?=
 =?utf-8?B?Y2RMYkd2b09Fa08vSDk4VitqTEkydmxZdjdtdWVkN2tDemJKUE9kK2pUSi9p?=
 =?utf-8?B?ZEgzVURCd1diY1hyU1hRVStaUzBsT0loay9tUG0vSm9scUt1OE9ZOHVEd0lT?=
 =?utf-8?B?L2wwL3dFNGIxV0VHbkpucnFJVVZ1Rjl1SFJSMkhrV1hKN3VWeGtSVWJWUjFr?=
 =?utf-8?B?MWEydStIald3VzZkMVM1TkVDVnJFV0ZRdDRzem0wQjRiVzFDVEtSQkxsbzkr?=
 =?utf-8?B?TDBQTDdscjdNN1pkcUcrOCtYUG4veEN5dE04TGkxWVJlcnppRktjQm5KRnhO?=
 =?utf-8?B?M1VONWJpN3MxMUJydUdvV3MwdW5Ta1NOdEh4U2hYUkdTZ3VoRmo4MXB6Vi84?=
 =?utf-8?B?a2ZON2lXa1BSblB6TUlwWnVzY082UTg3RHlOUDFvRkQxdmd4bDgrM28weHFu?=
 =?utf-8?B?MUFsUFhXSTIyUkF3aHV1NXgvQ3Q1M0J6UUtCS2I3eS9qUE44anQwSUJTQ3JM?=
 =?utf-8?B?UW5xYmlLeUViSitDVEVwYnpJdG13PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aefb268-0c4a-45fb-bd3c-08d9be442206
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:23:28.8838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKqPb33m+Ba/LFNzhV+OMfypVv3e+H95tHxyRSWm86dxLg14u/n4hPEjwCXkgaytWDv7qQdmXbm4vi/Zc/lTJkKvcE6HmHxNAiiXGVkuAJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1759
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10196 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112130091
X-Proofpoint-GUID: 6SNsDVUKNphjraKQSJ0BARU3u8bAnTGR
X-Proofpoint-ORIG-GUID: 6SNsDVUKNphjraKQSJ0BARU3u8bAnTGR
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 6:27 AM, Baoquan He wrote:
> Currently three dma atomic pools are initialized as long as the relevant
> kernel codes are built in. While in kdump kernel of x86_64, this is not
> right when trying to create atomic_pool_dma, because there's no managed
> pages in DMA zone. In the case, DMA zone only has low 1M memory presented
> and locked down by memblock allocator. So no pages are added into buddy
> of DMA zone. Please check commit f1d4d47c5851 ("x86/setup: Always reserve
> the first 1M of RAM").
> 
> Then in kdump kernel of x86_64, it always prints below failure message:
> 
>   DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocations
>   swapper/0: page allocation failure: order:5, mode:0xcc1(GFP_KERNEL|GFP_DMA), nodemask=(null),cpuset=/,mems_allowed=0
>   CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-0.rc5.20210611git929d931f2b40.42.fc35.x86_64 #1
>   Hardware name: Dell Inc. PowerEdge R910/0P658H, BIOS 2.12.0 06/04/2018
>   Call Trace:
>    dump_stack+0x7f/0xa1
>    warn_alloc.cold+0x72/0xd6
>    ? _raw_spin_unlock_irq+0x24/0x40
>    ? __alloc_pages_direct_compact+0x90/0x1b0
>    __alloc_pages_slowpath.constprop.0+0xf29/0xf50
>    ? __cond_resched+0x16/0x50
>    ? prepare_alloc_pages.constprop.0+0x19d/0x1b0
>    __alloc_pages+0x24d/0x2c0
>    ? __dma_atomic_pool_init+0x93/0x93
>    alloc_page_interleave+0x13/0xb0
>    atomic_pool_expand+0x118/0x210
>    ? __dma_atomic_pool_init+0x93/0x93
>    __dma_atomic_pool_init+0x45/0x93
>    dma_atomic_pool_init+0xdb/0x176
>    do_one_initcall+0x67/0x320
>    ? rcu_read_lock_sched_held+0x3f/0x80
>    kernel_init_freeable+0x290/0x2dc
>    ? rest_init+0x24f/0x24f
>    kernel_init+0xa/0x111
>    ret_from_fork+0x22/0x30
>   Mem-Info:
>   ......
>   DMA: failed to allocate 128 KiB GFP_KERNEL|GFP_DMA pool for atomic allocation
>   DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
> 
> Here, let's check if DMA zone has managed pages, then create atomic_pool_dma
> if yes. Otherwise just skip it.
> 
> Fixes: 6f599d84231f ("x86/kdump: Always reserve the low 1M when the crashkernel option is specified")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baoquan He <bhe@redhat.com>



  Acked-by: John Donnelly <john.p.donnelly@oracle.com>
  Tested-by:  John Donnelly <john.p.donnelly@oracle.com>


> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: iommu@lists.linux-foundation.org
> ---
>   kernel/dma/pool.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
> index 5a85804b5beb..00df3edd6c5d 100644
> --- a/kernel/dma/pool.c
> +++ b/kernel/dma/pool.c
> @@ -206,7 +206,7 @@ static int __init dma_atomic_pool_init(void)
>   						    GFP_KERNEL);
>   	if (!atomic_pool_kernel)
>   		ret = -ENOMEM;
> -	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
> +	if (has_managed_dma()) {
>   		atomic_pool_dma = __dma_atomic_pool_init(atomic_pool_size,
>   						GFP_KERNEL | GFP_DMA);
>   		if (!atomic_pool_dma)
> @@ -229,7 +229,7 @@ static inline struct gen_pool *dma_guess_pool(struct gen_pool *prev, gfp_t gfp)
>   	if (prev == NULL) {
>   		if (IS_ENABLED(CONFIG_ZONE_DMA32) && (gfp & GFP_DMA32))
>   			return atomic_pool_dma32;
> -		if (IS_ENABLED(CONFIG_ZONE_DMA) && (gfp & GFP_DMA))
> +		if (atomic_pool_dma && (gfp & GFP_DMA))
>   			return atomic_pool_dma;
>   		return atomic_pool_kernel;
>   	}

