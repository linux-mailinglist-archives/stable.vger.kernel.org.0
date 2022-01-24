Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBA8498283
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbiAXOik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:38:40 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1776 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234226AbiAXOij (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:38:39 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OE2FFv005513;
        Mon, 24 Jan 2022 14:38:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9vfw7JWU0hK2KpP27K2SV3P2vQtcH8Q3uPjSBQ4Kumw=;
 b=SkgF/hHqiT4bGD9yHhMhQqYrdUGLTcW0AeNRsgC6EVReo0jvpM6M7l3UjlaITk6Gr+Jq
 7Ek/svbMCbrYGKbne4Y56seFcxN8Y8wynO+5hhdydRQQC1bRkUVEr9pr/VShM74dFk8f
 d6QJaDl8AaV5lmqqXPYV8JoaQF8aziyxU5JmEiGMxbhj27WuIxovUhA8ltLO+jhVhRtA
 U/s0dAR5iODZ+1X6jwlKKs5Wwg0Ch593zkmOrJlcnXhP6Nu5hcHb30HsgkbKw4sUjkAk
 YiJ3DQfmCaD8EZIaQaA68Q5uTvikT5wsEb6gAPVKKAwoft/wqr4ifNvGP9XWIxzdbxdq 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dswh9g32k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 14:38:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20OEai8V143748;
        Mon, 24 Jan 2022 14:38:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 3dr9r43gvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 14:38:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCcZSBB8clQMva9ovhH28hkIWMwSdW47rgWoYC8NmQidTB3LWEBkgPPAajrSX6vJnpTsKJzfq4EHh4qVopiwCf4o75ozkmV4uKU9iVcyA3esmzMEjXTu1iCdFVZ2BP5nAbCMJzPZBVXHtWPERs+aINDvF4LUDUjveEMdqh0QXfN403/QzfOoFB2naixvGTVLAm3gyR3XCfIiWnGbIR0sErmCWY9FjWyiEF/5T887VYrf2Y3TikZj580c0xHyj2TRnS4IDiRe3A1MihLFgMZ9Esz2bEKMzdd1S7F6Eq+jViRL6ZqkA6Xv9RmYvY+w0u2PGsTkY52c0By+xHXd6nt4ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vfw7JWU0hK2KpP27K2SV3P2vQtcH8Q3uPjSBQ4Kumw=;
 b=T9GptKSsiPZOvrSW3Uaiemi02f5WDU7973fpkWGH+BBaRZ4ejYB0YuqRT5JfMdvge2ulzrehrGIENiICU3RK/2HMLUnJe1MRqsfxBrc84naHxaSOsVy4y9HsUxh1VUdnlL7///1i8lO6lqfKjRPkU3WHfdDN7uSvZGyjQD/wuvApp6SQ5kD0+emvDMP/SWlZlc7eZJr/lKAz7OId+Tqdn65Eb+P2ggT/3TDbdezCjHLvyn4Ffw+epvjyzuEafZSJ8oFy1H+eKzpcup31rDl7tuC13hASKeqFJQMKSJrVew4ZOg9MYc7Q8JPBuKNeVTIzzEO6VOWhmFDRaQaR+mjonw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vfw7JWU0hK2KpP27K2SV3P2vQtcH8Q3uPjSBQ4Kumw=;
 b=X2Ha4c9D9Fo05N/C6jvM11xAi5n4vQ/duHi9F2z1MFK+hHeWBe7kCG+8788lwq0MIzIHuOh0+nJJhbsHRnmnhLmD6Z1nk1XhTRlsc1Y0k69EXdBmkSPeHtDQRRT1/wICtSi+eNyOb6Tsi+KI66MIiYDLhuGcA8W7AriWbdem9lE=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by SA2PR10MB4764.namprd10.prod.outlook.com (2603:10b6:806:115::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Mon, 24 Jan
 2022 14:37:59 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::30b4:4c4c:82df:29f6]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::30b4:4c4c:82df:29f6%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 14:37:59 +0000
Message-ID: <d9eec78f-e0e8-cc6d-ffe4-fbd31c8bb6a9@oracle.com>
Date:   Mon, 24 Jan 2022 08:37:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: FAILED: patch "[PATCH] dma/pool: create dma atomic pool only if
 dma zone has managed" failed to apply to 5.4-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, bhe@redhat.com, 42.hyeyoo@gmail.com,
        David.Laight@ACULAB.COM, akpm@linux-foundation.org, bp@alien8.de,
        cl@linux.com, david@redhat.com, hch@lst.de, iamjoonsoo.kim@lge.com,
        m.szyprowski@samsung.com, penberg@kernel.org, rientjes@google.com,
        robin.murphy@arm.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
References: <164294819620733@kroah.com>
From:   john.p.donnelly@oracle.com
In-Reply-To: <164294819620733@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0352.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::15) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cbce40a-c1fa-4952-c6cf-08d9df471dff
X-MS-TrafficTypeDiagnostic: SA2PR10MB4764:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB47640747E7E7E0C19A191A37C75E9@SA2PR10MB4764.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WE9istnWk55QeSxvyJPSMxE0b04FyYaTiqc8COkArGBcvSE3O4O1hszF3r2NRFpQ0qaRp3BEHKjg5XflxCoaF1kspuyF0AAtOvM+6IR9HoOYjyr/gLUufX32aiBTXZc6i+HMj8NN6YNK3XrjpWclU66vK0httrZngE0BkBbeNmKiPCoOOhO6iPjlER1WgWaLRWTv38VIQwsMjM1gqHEBHgNAf1KUfzQ5ni2oMLMghl2Tm6hjk8+y+HaPGkMmvbXpZPyVm1WZ/fPRVFZOt+A3d6II/POkEE39KzAsvzBO/xQs5sXaD03AMAFBjYYaT5G1n8Wj2j4y6O3apwIQ//XYv5iJkz6nuVSairI/hgKJSvSNsg+DXnxWgPZ3jD5uaGr0FoLbCxzTrH/h9HcLnE30eUkgsWXAE13zqA7n3eJtFQhNcJD8z8VxnoEYJ48JLL4lMrAZLInf2dYnYC0J0SiFP/fMCkvJvoT365UMItfJsY29RnW0shzexMrSsuToTfBDsKgx315rShbFTwoTbSi7yCxphetMajGbmEvBqjraCHnNYBfH/qnB8uz4nOzesWrQ97Nmu9e02agpqZhoOVkfcntggE6sdjh9o0qGT8CvRDDLoVB83T1T5x8dm00IPl4NimEa6Ua6oNRdugBwpijuLxArAoX43/M0NkGmh6f4dwORkUAW14B3Kd8OEPkUd5WEE+pOHDyWZieVkJtPj4+4cHMdT6jJcSCfisxA8f4mGBmXbpCRHPv9dX9/Yk/lBlvcPLZsBIepbsmNc4+Il00z3afEPWtiWJDfvNmkNg6n4ieYFqkvNAMyRifrDudp64O3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(2616005)(66556008)(31686004)(53546011)(966005)(26005)(86362001)(9686003)(31696002)(6486002)(36756003)(38100700002)(5660300002)(8676002)(921005)(66946007)(6506007)(316002)(2906002)(66476007)(6666004)(186003)(83380400001)(6512007)(8936002)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHc5L0VKZzFNR05xd0FJSHZVMjQzb3RnaE11Rkd1WEZaMnRmQ3NHZnpIYkhZ?=
 =?utf-8?B?VjJIc0J0Y3ArTHRTM3Z2MG5EQmVJNUwrSUp0RWNyVGFnZ09MTWFheFFIRWN5?=
 =?utf-8?B?bXZ3YjFTV1NZTGowK0FWZFovOGpVTGFWbU5QM0pKckQ5bXVsSzJZOU9Ja0NR?=
 =?utf-8?B?UVlNUDNLaVo2UThyQmlvYWlZYnZheU5sQzRGd2RtVjZpTXBVQkp2QkFUT3NE?=
 =?utf-8?B?SlRUN25LYmo2cmE1N2J0czRUa0pBdVBFSk8vaVlWUG5QZDdvUEoyYllVS1ZZ?=
 =?utf-8?B?MGtvak5mb0R2RS92QmN2NGtWQzYxU1BWUHJBWnJsR3pFcmdBN3hZblQvYlIr?=
 =?utf-8?B?em5MVUs1b3h6OEF2K2twRzF0cmliUVFkbG9TYVNZelRqUGl1QSszS21mei9M?=
 =?utf-8?B?b09zd0xQaHFxejcyNEVveW1Sd2ZjMkV6d2IvVkFEVlcrV2RiaTF2dkgxY3Js?=
 =?utf-8?B?REZmRFM3eVVkQlN0a1NiMzdzMytHQmNnTGVudXd4enl1b2pacFlmU2hUaEho?=
 =?utf-8?B?WFZJTkkwZitWeXZMWVM3MjEybzRVRXNtbFQ5ZmJyRE5IZ2xwbGE4TVpzclN6?=
 =?utf-8?B?UGpxdnZTaStKVUFTamVObWVGSThuWDJta2xBMjdMWHE0elMxT09OTkZHeUZv?=
 =?utf-8?B?RzNjSUp4dDhmTFZDcW9iOGx5NjdBNVUydDU0VC9tVEp5S1BzUXNkbVlxNUF3?=
 =?utf-8?B?ci9MY2ZuQ2QxaEdRRHorZjk0ZkE5ZkhVWklrdktzOTE4T296d21kU2VBcFda?=
 =?utf-8?B?QTc5aGUxTkdySW05QUVxS1BpRlA4YTZxcFJRckt2bTFiMHJJWDBkNTc2ekZN?=
 =?utf-8?B?amQ3TFAxYStvbDRIbXV5L2dKbmY4ZTZlcEdEc3NiRFlleDNPc1VUMzZrT3RF?=
 =?utf-8?B?ekgwUzMzbGR5aTlrV1VjRW5pek1nU0lHbUQxMHlHVVY2eUFyeHlKV3QvR2ts?=
 =?utf-8?B?VXlCOTFTWnozZVFSTnh2UnUrVmpubmt6bEFjckJLa1NUVXJBWlEvOVAwdS9z?=
 =?utf-8?B?ckllKzRKM3BpbmdQNG5rUTJSUG43dVh6Q3pLQ0UxQlRDcmd4U3hHTVhqbmk1?=
 =?utf-8?B?a2N2dEFuQTNrQ3pxMTFON1JjNG1MRy8zYUtRRFlhVGVJZUtWQU1uTytFekox?=
 =?utf-8?B?QlBkMERZR3N1L2I3dldLZkJFSE15cWYvQTlGM25RbzVMby83eWFBVVl3Rksr?=
 =?utf-8?B?cXdKbXBMWm5mVU1mbmZ5aFlDZjhpdW9ta0tSQm1VTStyY0lWanZOMW94UVFW?=
 =?utf-8?B?c2dUVE1OR0V0MkJKRklJbGNTcTdmTUkyU1kvamRvVW45WkJJbHBvRHlCMi9v?=
 =?utf-8?B?VXpEOERnOCtSMVZ2QUJ1cHU4dEk2NDVUSGQ4eXJqQXphZ3FrQXFsMTQ0REdm?=
 =?utf-8?B?YmxpQ2Y5NWhXM1FWQldFQnAzbXlHdlhaYWt1TFg2RVFSZENmMUV2NURhc1du?=
 =?utf-8?B?UUNRaWNWYnc1RXpybXR5MVpCMVdPVHVPQ1hVNjJjamR1WnphajRwY2hiRGdw?=
 =?utf-8?B?Y2U4YW9rc082QWZxdGZublptc2FyM0NZT2s5OUcrNWlqbUZKTDV0cVk2aHF1?=
 =?utf-8?B?MFM2TjZOcmg3bXJ1S2xzUVlTSjJKV0UxK1pmQSt0cHBQREwwc2ZTZmNKRzc5?=
 =?utf-8?B?U2dhbVhwaW1TejRqczIzYTR3SUZHcm9JMUxHVmVYTVBFUFQrM1lRUXY2TFhl?=
 =?utf-8?B?SHNKUlY0WHlzRWdlZjZ0Nkp6OWhjODFmMi9GZm5HSjZNbHFZRnRSWHgyRkJL?=
 =?utf-8?B?VE1jaEI5bERxRG9aNDZqZ1dodHpZRWtYY0tDeVlkMmtPK2NiWHZEZlphWGlq?=
 =?utf-8?B?a2FZNHhwcHBXQVZrOFFkRmM0R2o4VldGOWhaZGZsV2wrZTMzcGFqVG9CK2ZB?=
 =?utf-8?B?NklHTk9IR0ZsVzZzV0JMWFgvOXFKWCtrSVN3OUk4SEYvemZ6b0NCWFk4RXRx?=
 =?utf-8?B?ZEZCT1pEQnkweUF6d0x4RWlMS1prR1lSSnp4QkY2TmUzNVl1Z01WTzFtWTBz?=
 =?utf-8?B?aHdFTU0zWVdpNHU5blFaakNkSHpBSXlHcWhvV09sVXFuNW5RbmRqZEt4OWkw?=
 =?utf-8?B?UlI5cC9YeU52ZjVmZE5zRmdsRHVOWWhPRzRQNlRsVTJJUHpUV012MEIyY1ky?=
 =?utf-8?B?LzBEN0pTVEdkZ3pFRGdCUkxQRExuR2xNNjFBWmN4S3UvTFh5TjhjQ3JDNU1q?=
 =?utf-8?B?WThzT21kYSt2aE1NUWRsNzcxOU9VVElTQXhiSnh5dzEySUFmRnZBMFkzWnhP?=
 =?utf-8?B?VmlubUppSWc1dFMxd1FYTWlXTXRnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cbce40a-c1fa-4952-c6cf-08d9df471dff
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 14:37:59.0328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SS8qA/6gaUEQRImGfL10X7+X7nDIxKyoi+GcjVoQK5f6hm2R4Ot/PC2YcAYBA5+BNUc6KxijWF9JIgvlhbkY+IyS06yQ4DS5o18rTCfXddI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4764
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240097
X-Proofpoint-ORIG-GUID: LdT6KK0bQGKQbJB2ODuuyUZ0paM9y56S
X-Proofpoint-GUID: LdT6KK0bQGKQbJB2ODuuyUZ0paM9y56S
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/23/22 8:29 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h


Hi,


FWIIW :

We picked up the suspect "Fixes"  commit :

2020-10-01 | x86/kdump: Always reserve the low 1M when the crashkernel 
option is specified

In an LTS update:  5.4.68,  and I do not see the issue reported in the 
summary :  "DMA: preallocated 128 KiB GFP_KERNEL pool for atomic 
allocations " , when a kdump is invoked. We test kdump quite regularly 
on a variety of platforms.

Baoquan's series may not be needed in 5.4.LTS.




> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From a674e48c5443d12a8a43c3ac42367aa39505d506 Mon Sep 17 00:00:00 2001
> From: Baoquan He <bhe@redhat.com>
> Date: Fri, 14 Jan 2022 14:07:41 -0800
> Subject: [PATCH] dma/pool: create dma atomic pool only if dma zone has managed
>   pages
> 
> Currently three dma atomic pools are initialized as long as the relevant
> kernel codes are built in.  While in kdump kernel of x86_64, this is not
> right when trying to create atomic_pool_dma, because there's no managed
> pages in DMA zone.  In the case, DMA zone only has low 1M memory
> presented and locked down by memblock allocator.  So no pages are added
> into buddy of DMA zone.  Please check commit f1d4d47c5851 ("x86/setup:
> Always reserve the first 1M of RAM").
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
>    __alloc_pages_slowpath.constprop.0+0xf29/0xf50
>    __alloc_pages+0x24d/0x2c0
>    alloc_page_interleave+0x13/0xb0
>    atomic_pool_expand+0x118/0x210
>    __dma_atomic_pool_init+0x45/0x93
>    dma_atomic_pool_init+0xdb/0x176
>    do_one_initcall+0x67/0x320
>    kernel_init_freeable+0x290/0x2dc
>    kernel_init+0xa/0x111
>    ret_from_fork+0x22/0x30
>   Mem-Info:
>   ......
>   DMA: failed to allocate 128 KiB GFP_KERNEL|GFP_DMA pool for atomic allocation
>   DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
> 
> Here, let's check if DMA zone has managed pages, then create
> atomic_pool_dma if yes.  Otherwise just skip it.
> 
> Link: https://urldefense.com/v3/__https://lkml.kernel.org/r/20211223094435.248523-3-bhe@redhat.com__;!!ACWV5N9M2RV99hQ!b4MXpPOLvHa3lqMG3cEpMMlmORCR1Snd7RudCeFoVW_R6IVpPpsNKHKxn6dlZ2w60Ky7$
> Fixes: 6f599d84231f ("x86/kdump: Always reserve the low 1M when the crashkernel option is specified")
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: John Donnelly  <john.p.donnelly@oracle.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
> index 5f84e6cdb78e..4d40dcce7604 100644
> --- a/kernel/dma/pool.c
> +++ b/kernel/dma/pool.c
> @@ -203,7 +203,7 @@ static int __init dma_atomic_pool_init(void)
>   						    GFP_KERNEL);
>   	if (!atomic_pool_kernel)
>   		ret = -ENOMEM;
> -	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
> +	if (has_managed_dma()) {
>   		atomic_pool_dma = __dma_atomic_pool_init(atomic_pool_size,
>   						GFP_KERNEL | GFP_DMA);
>   		if (!atomic_pool_dma)
> @@ -226,7 +226,7 @@ static inline struct gen_pool *dma_guess_pool(struct gen_pool *prev, gfp_t gfp)
>   	if (prev == NULL) {
>   		if (IS_ENABLED(CONFIG_ZONE_DMA32) && (gfp & GFP_DMA32))
>   			return atomic_pool_dma32;
> -		if (IS_ENABLED(CONFIG_ZONE_DMA) && (gfp & GFP_DMA))
> +		if (atomic_pool_dma && (gfp & GFP_DMA))
>   			return atomic_pool_dma;
>   		return atomic_pool_kernel;
>   	}
> 

