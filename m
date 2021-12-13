Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65DA472F18
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhLMOYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:24:51 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13522 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232951AbhLMOYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:24:50 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDDQ5tt011744;
        Mon, 13 Dec 2021 14:24:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ERL6uELDxfltCESEB6QQC1031pzv4xoFq79vztxSKcw=;
 b=aRmU2rjRZ5fSnr4pxQqRJC05Kak+TL3c+/hdvJEdngMP2lmK4od2Lvqw4bbpYmek54dp
 VbbE0e1NlA9QEk39o1PH6fxrJug0kxdj/UzmOoFI9z3bKybSy3Ty+Gxvu+RcES+8V9QI
 Y1yfkGDcByI4t3Wt0djCEMBRhPDamGkQp8S0io68fvS3WyeWNSPzJpvXzXySXHpU/x21
 h5nlN+0zP++2a9rERXqdNzj49HXC4txE1HDcZNca6zadJxg1mqGTVlT5IzTzpk9n+3rg
 /hI6WcWIlxxoubElReweKZua187+uazPzX5pt3FH0ZpmRexa5APRVPiWrtq5byL1ta0K nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3uk8ktf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 14:24:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BDEARNr009198;
        Mon, 13 Dec 2021 14:24:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by aserp3020.oracle.com with ESMTP id 3cvkt30vy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 14:24:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cz/EKg8TDiR7q8Ezg4k9ElarkLxnxPYeAVC9tO+51rEwpbjLC6AiKcTaBFu3c9H0ta0CHQ+kgEgqTisU5ITcEFa+CUxuRvXfU2G8HvTZNktw7+JdCobALi6pxgUyif9oBUlHs4HJ2IJ0mG1/xjZ6+9gy0X3WFqH4ib5MEbuV718Nja2lWwwDR8RRoQ5Y6ZKI6ckrHKCUdTkxVQhF7LhYpf/0mF4VvCK6AuDOPKn0NeZmJ5PaPPFCOdwNWDxrsQJpTLXCS6cOh+KoLxoYq3qqrQ5iCPbSAtq4JgjWAnDTVOwd51nm6Hvcox85XSqjW7c2PryNXs4wmwT40slD66+2vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERL6uELDxfltCESEB6QQC1031pzv4xoFq79vztxSKcw=;
 b=NTjtvCFaPKU1uQNLFpBt3kRYbuVkcNLGf5Y/NJeoQmvKIvdDOa2DAEm/b7JynJd/L2PV+zVJpEskDhjOlwUIqGiHQOO5KBOFpeVZeCPWRVg1s9IDVI1P2ybbrOnllledZ3hyfBPgCnAqsNaVnnPRodyrVZMaBNRNTKAtkj9AjGGYUos8XkWqeYoSk4sJT5vRylmaOlaOB58uts3RxtfIFRZiZMraFBA/dTEXjfgf63jZFBS5zZBJZKotbkvP26t/afNpgkhhK2IzmkW9lsYsz0T2caSB63tJLQhe/FCIC0SrROW9Pnv1cLlYkHg6r/Ssi7OZQ81iJm5kOhTIdth0dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERL6uELDxfltCESEB6QQC1031pzv4xoFq79vztxSKcw=;
 b=DfuyoL1KRouY7dMXHND2cfKaiUFP8YC2GQTRDoAgwu3HgAm8h/ZlRoCprR/Hw9MR3n/EQ1LjRkYuSaJCAriqhUHAkdAlI9X6U617KbVbm6r9kSMoXquaTR/l8hkcjhRKyMr3YGQGk9EcvWr8UaVIk8Ag+irgNnNJwN0eLadUV8k=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO1PR10MB4435.namprd10.prod.outlook.com (2603:10b6:303:6c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 14:24:32 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::54ed:be86:184c:7d00]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::54ed:be86:184c:7d00%8]) with mapi id 15.20.4778.018; Mon, 13 Dec 2021
 14:24:32 +0000
Message-ID: <90bbe424-a522-b225-35c2-a3b3693271c7@oracle.com>
Date:   Mon, 13 Dec 2021 08:24:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Content-Language: en-US
To:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, John.p.donnelly@oracle.com,
        kexec@lists.infradead.org, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com>
From:   john.p.donnelly@oracle.com
In-Reply-To: <20211213122712.23805-6-bhe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB6PR07CA0061.eurprd07.prod.outlook.com
 (2603:10a6:6:2a::23) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dea187a0-4a6e-4250-89b4-08d9be4447ba
X-MS-TrafficTypeDiagnostic: CO1PR10MB4435:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4435C3A077137465157C268EC7749@CO1PR10MB4435.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:255;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +drjMbitDBWUW0W64/SJy+iER67mw86fPELgG4c48jefCsSOJmJpRVSTKXm4jFSOKT1j8vE2gep93MyzyPziQPGDUUbH8TqsNw0G0My3D9W+RV1aorT0G22/gXpudAO0TDex/6U5/l3qQiQYlEO3tNS1Jxw52wJ8lY66gHWMt7/yo8C6tXzbW3VcLOlLtCAzXa2/2qIgywpW6SD/p8uBu+BvlaC42VjGKi4PQXKCOnJZHOuXLW2zUksj8wai0bFgehmDGFT/HPO3mZNxHOXiwRMSJgchPnGiu31IMlWdJk93CcwSB+ryV+WlDicQk9Z6bqUdag891+ifUnWlrz9QdxosOBj26Y2hWCC/Gt9Fq4Fbotf8u3ESYLFUnkzxow1eM9o6/qleVaqzINg724ySOe+GTJ0hDqp+knnvldYpxNqX42kSSUI1DE8M84+NtNoUWTuynTgzDfKIC+xkseklN8d/qOSeNxMrLWpC8QCLqSQvUsy9RXtl00EUAaxNVf8UJAbzSYFX1xnDpYgPV4zoaz54LRm+nVVqiiQveRgkdqxFipJIQpbxqd9TWrJhR5BDPJb9Y2EEThSFghqJ8pLNLaWl4i+nbSYuLdgUCKUc3GYsqJopeAdoDtL7ze3MWWzGgncWkU53h8I7eHtbLoOaf1RXCUQN0f5Pl5IziBxQrEh7W7yeCC3nR4/fZ26wiHq0vr9FAbXLKlsqYBoaYMq+bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(86362001)(6666004)(2616005)(36756003)(6512007)(83380400001)(4326008)(9686003)(508600001)(8676002)(6486002)(5660300002)(66946007)(8936002)(31686004)(26005)(186003)(66476007)(31696002)(54906003)(53546011)(6506007)(316002)(38100700002)(66556008)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2VtdUN1NXNFMGtSMnFDS1d2U0JpbStlOGZRZVU0VjFZQWh1ck5zTlIxUU4y?=
 =?utf-8?B?SFp3UTJMc04velRBTjlkYmZHZWFYanhZaHhPNWMzUEI4aVN4N0drLzVEUzlV?=
 =?utf-8?B?NlBTYTM2Mmd4K2RiYVMxenNUbC82bnZEa0pNSEVPend5U01FbS9KYWpwRE80?=
 =?utf-8?B?K3dueHVUK0hzRTdBQVYrVmtUeVhqMTRUYUk2WUVHWjhwaVlLbnd4a2VCR1Vt?=
 =?utf-8?B?clByUFdPM2J3V3E2aTNzZ1hyVVpMb0p1SFJDNElIYy9EU0hWWDZhVkRqaExu?=
 =?utf-8?B?Qk5QcWplTXpIcFF0Y2NIMVVCd213NXZ6Z1ltSEJuTUFndVNkUjV6SkhXQlZh?=
 =?utf-8?B?bXRMSEdVZDR2Z2xxV21pQ1dtajdGck1BY3BlS0xmMHJuUGQwZ2JHa2x0Y1l2?=
 =?utf-8?B?QnFlU3dwN2NLNTBoSGR2akNielVQckdLQUptSk51N24vaEVKNUQ5elZmbVM5?=
 =?utf-8?B?R3hELzhIMHBYVE1WTEhNTExoYWJMMnhQQVhaZ3ByVnN1V1ZjMUh1ZTR3ZXR1?=
 =?utf-8?B?dVZTcHZjRE92dGEycU0xajBGdnU3TkpZSmFra3hyK3hzMG0xakJHZnIzeGwv?=
 =?utf-8?B?R0s1T0VzQ1laU2wzbGFnZHBUcGx0NmlGRUQ5Sm16b2FyKzVPeFFjWnk5cHk5?=
 =?utf-8?B?K291S2c2UDBUMmp6YW1QWk5mU0tGakhkelhWTW1lSXBYaWRLbVR6V0tWbTRD?=
 =?utf-8?B?YlhXWTBwR3hTVGtZMmxWSzQwY3JUdEkzZFhWSDRBZE1NVGZ6RWwzMDh4bSs1?=
 =?utf-8?B?SXB2Tlc1TGlVcmdLbXpVSFpZejBTSHJQTVA2Ny96dkRqZ29lM0ZZaVpxcmRW?=
 =?utf-8?B?bVVBK3NPWGc1eUE4TFIvTUFlVXlza1BRLzRwOEpjT1dYaWlxWmRzUlo4dExo?=
 =?utf-8?B?QkpGeVBSR1ZoTjRhMk41WHdhYno2VVloUC8wdDFieU5Oa1p2QVpkU3pQU081?=
 =?utf-8?B?azZYZkNQdkdEUEdEVzk4UzdFSy9DdG0rdElVV1NwbFVqdkdNSGZUV25Xa1Jp?=
 =?utf-8?B?TkFibWtKRnM1WEY0RFc2NjNqQ3JpR1ZuYUU5dkpUOEw4QWJ6Zm1PL3ZaUVZU?=
 =?utf-8?B?aExPUm9pVzFWR241cDRQcmh6cEdyRUlEOUY5RmtvRzhGWmI1SlFYTjl2cGcz?=
 =?utf-8?B?N2Z1UHdWaTZlUmtSd3RmK085Ky9scUZUMFoySTdzNTBmRzErRXdpZU9QamhQ?=
 =?utf-8?B?eWJUNGF0NjVpTkJ6NXozeWRmVURacUFQNWdDWERPOUxnRHd4MDhnMEVvMTdn?=
 =?utf-8?B?aXRKOG0rU2UwTVRFMk9iem1iZWd1RnZ4N0h2dm03RG9nb2JWSmN2Y0ZnK29x?=
 =?utf-8?B?aGwrWEc4aTU5bEJ2R2t5NERIdFZnQnRaUXFIcm1HcnA3YjRzZmx2eXc3S3ZM?=
 =?utf-8?B?dzdkK0JSUDArQ09mTmtTazhPMXMvV3FUUmwrZXpIS2V4MExBSlVjNEQxcW05?=
 =?utf-8?B?SEZRZTd0RkczcE5kNUxqallTVmhYZGlQWXFhN0ZmV0oyRjdBbytaTDFBbzA5?=
 =?utf-8?B?UTRna29wUk8xSnJBQmZUaGxLU3JlZ0tZQlNlOWRzTm5qRjdTTnJEeHl3NHUx?=
 =?utf-8?B?Z3Y3eTEyQzBwbTdXVVJmM3NrTCt6WWZoTzdGSHlWM0N6YTZWMDEzekNLRk5M?=
 =?utf-8?B?a0EyL2dYNXpndFVUNnFBeWRJcmJiVGFBNUdDWDlubkdPVEFzSVQ5YWlTV2dL?=
 =?utf-8?B?UVJhNFczcjdNcmJwSHhKMVV3blRBVGJMREdtcHltZ25nLzc1bHJLbUp1dU9T?=
 =?utf-8?B?Q3VqTzVKYWpKLzZicXJFb1Zlbkk2WUxnNzc5aDRlTHpwZ0pkeFAwRGZwYzVY?=
 =?utf-8?B?Q25VcDdibjl3b2JNclc4ZE9rT0lkbm5iSGUxUGhla21hSTN0aWhIczR6Vnl5?=
 =?utf-8?B?Zmx1WnpqT050Wk90UFR4cEZieDFDdjc3ZjJZWTlMd0Qzc2hkQUpCQmZIbVFs?=
 =?utf-8?B?VFQ4TFMwVmRQZUo0bmI3bkZrcHorV2pjNW53Nzc1MlhBQlJiTCtnT3VxNGNB?=
 =?utf-8?B?YVlPalIzSzluTVhvckFZNVFpTmdOelluYmNlNW9SWWZnMUdqOXNrdHhpdHlJ?=
 =?utf-8?B?MTlHclQvL0hBZnoyRmJkeTI0YmZNWGN2UlZXQ0VUSmpmNHBQWUlna1lKOVcx?=
 =?utf-8?B?ZjFpNUpSOURtbUFrZ2ZRKytGM3loNXRpTmV5UXJtdkdLdW5NbTFxRkQzMGE5?=
 =?utf-8?B?RCtONkF3Yk5jUWxBdExGVXl4elhJTXpOb0lsL3NQWldNVFNNQy9pd3o1Y3RG?=
 =?utf-8?B?QmpjdFJveWJsaXA1cXEyN0xnVDRRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dea187a0-4a6e-4250-89b4-08d9be4447ba
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:24:32.1346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e3QOJutm1VZjtlFqg0IGERa7Wew7Tho11c+fYBc9r4zh7FGuHtUu5hf6XEz4miUINnz/9CvY9TSGwjCbbD14HSf4tF08ruQRGccGyFZq9cA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4435
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10196 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112130091
X-Proofpoint-GUID: VR6XnJmvztGOKdD22SKC8nwE-qkWRom9
X-Proofpoint-ORIG-GUID: VR6XnJmvztGOKdD22SKC8nwE-qkWRom9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 6:27 AM, Baoquan He wrote:
> Dma-kmalloc will be created as long as CONFIG_ZONE_DMA is enabled.
> However, it will fail if DMA zone has no managed pages. The failure
> can be seen in kdump kernel of x86_64 as below:
> 
>   CPU: 0 PID: 65 Comm: kworker/u2:1 Not tainted 5.14.0-rc2+ #9
>   Hardware name: Intel Corporation SandyBridge Platform/To be filled by O.E.M., BIOS RMLSDP.86I.R2.28.D690.1306271008 06/27/2013
>   Workqueue: events_unbound async_run_entry_fn
>   Call Trace:
>    dump_stack_lvl+0x57/0x72
>    warn_alloc.cold+0x72/0xd6
>    __alloc_pages_slowpath.constprop.0+0xf56/0xf70
>    __alloc_pages+0x23b/0x2b0
>    allocate_slab+0x406/0x630
>    ___slab_alloc+0x4b1/0x7e0
>    ? sr_probe+0x200/0x600
>    ? lock_acquire+0xc4/0x2e0
>    ? fs_reclaim_acquire+0x4d/0xe0
>    ? lock_is_held_type+0xa7/0x120
>    ? sr_probe+0x200/0x600
>    ? __slab_alloc+0x67/0x90
>    __slab_alloc+0x67/0x90
>    ? sr_probe+0x200/0x600
>    ? sr_probe+0x200/0x600
>    kmem_cache_alloc_trace+0x259/0x270
>    sr_probe+0x200/0x600
>    ......
>    bus_probe_device+0x9f/0xb0
>    device_add+0x3d2/0x970
>    ......
>    __scsi_add_device+0xea/0x100
>    ata_scsi_scan_host+0x97/0x1d0
>    async_run_entry_fn+0x30/0x130
>    process_one_work+0x2b0/0x5c0
>    worker_thread+0x55/0x3c0
>    ? process_one_work+0x5c0/0x5c0
>    kthread+0x149/0x170
>    ? set_kthread_struct+0x40/0x40
>    ret_from_fork+0x22/0x30
>   Mem-Info:
>   ......
> 
> The above failure happened when calling kmalloc() to allocate buffer with
> GFP_DMA. It requests to allocate slab page from DMA zone while no managed
> pages in there.
>   sr_probe()
>   --> get_capabilities()
>       --> buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
> 
> The DMA zone should be checked if it has managed pages, then try to create
> dma-kmalloc.
> 
> Fixes: 6f599d84231f ("x86/kdump: Always reserve the low 1M when the crashkernel option is specified")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baoquan He <bhe@redhat.com>

  Acked-by: John Donnelly <john.p.donnelly@oracle.com>
  Tested-by:  John Donnelly <john.p.donnelly@oracle.com>

> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> ---
>   mm/slab_common.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index e5d080a93009..ae4ef0f8903a 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -878,6 +878,9 @@ void __init create_kmalloc_caches(slab_flags_t flags)
>   {
>   	int i;
>   	enum kmalloc_cache_type type;
> +#ifdef CONFIG_ZONE_DMA
> +	bool managed_dma;
> +#endif
>   
>   	/*
>   	 * Including KMALLOC_CGROUP if CONFIG_MEMCG_KMEM defined
> @@ -905,10 +908,16 @@ void __init create_kmalloc_caches(slab_flags_t flags)
>   	slab_state = UP;
>   
>   #ifdef CONFIG_ZONE_DMA
> +	managed_dma = has_managed_dma();
> +
>   	for (i = 0; i <= KMALLOC_SHIFT_HIGH; i++) {
>   		struct kmem_cache *s = kmalloc_caches[KMALLOC_NORMAL][i];
>   
>   		if (s) {
> +			if (!managed_dma) {
> +				kmalloc_caches[KMALLOC_DMA][i] = kmalloc_caches[KMALLOC_NORMAL][i];
> +				continue;
> +			}
>   			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
>   				kmalloc_info[i].name[KMALLOC_DMA],
>   				kmalloc_info[i].size,

