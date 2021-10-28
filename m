Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DAB43E815
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 20:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJ1SP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 14:15:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57938 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230121AbhJ1SP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 14:15:56 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SHJJOi030823;
        Thu, 28 Oct 2021 18:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=n2MbTc19cbFW3BYU2IBRk5XhrVaUi1awGIXDuwFqQrY=;
 b=sXuCi0sZ03hebw4GpgFqkCcTPpXTYV3VQdffMRxeoFc9KaHfGqpu5RM1WMZe1oSGBuyY
 e1OSUbzU1Z/bUEIvfPxeWBMkU7N0vrStgKx1BMYwQubyJbX6kxmvfD0DgmqEHeQfcHVx
 bUeRzMsti8iO7t0vWw+N6IHk//oV1dbneyol9FaqGsEUgOkPSZOdWiwqvGjs/w9ZI+XI
 LJ0NKJGXO+WN1ebNbRGpJKP2f2NX2ntXBji2ynR62i+BwzO2vuaK3fdO3b1uqth+uDxa
 OdTreVv2+scJKpa5Na7/PO3Znh6ZCY/vynfC6yoUZqw0SvFJA+/PWZIxMATF71FDwhdr TQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3byhy9kytp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 18:13:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19SHu2Fi037748;
        Thu, 28 Oct 2021 18:13:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3020.oracle.com with ESMTP id 3bx4gt6ww0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 18:13:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0HIg9xbmauhc9QhR1aiBDyvSSYX7r79eF/uHGi2Kbrdn8/tN858OvQX4+QCqZszellM9wD2HL4PT8oh3srw56YnNosjt7xhe16C2yFwYK1xRVY3k0FsXE3F9rvztUrcq7AouXtO9uavJPkJvrNGtgszkOwWbKUXSeh5bv8mEhL7fkSprykzEEC1uwWLyMHLpJO6BdZWkpkAR7Epnck72JdzIC046IRb6E01EwlrKRd/iYULwhPeANRHeEP/ZeQk4kKU0KwH6Nlzkk2AYfqEVVbwvws2oZMcFMzSf1amqqfYFjVWj5c7Fg4BVKozM+cbXry4X6Nzobhfa4QXYiX4FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2MbTc19cbFW3BYU2IBRk5XhrVaUi1awGIXDuwFqQrY=;
 b=ZCGkGvffI4p40hAmdUEddTPGdZFN45b8rdnJwjM4sOb0wUysMIPt/IqpZ2t/WukjRTtzkSeEYAarldhl/2/YfuRmCud+REeYxPRIq3qG/p2KBHQX9Hm6P3ajSVlQNLiSmqmRmIGTQUpHngayvsu++re+nPDPFU3QlXBgNXhfVKLmp7e9kiqF6bFVwWIXY/1OUVmjmg1NxwBRFH4yMl3okWMgupVgLzn09nTTNFWpeMpdb6ZepEIFXQAVUhe9UkPoYbJ8xpIIxSLxbSuf0nqtbq3z1Xx5jzESXQlYNkRj1GbWuZZTZGFMj/2eba6pSKzQEVBf3IFGNsNStlC47OrqXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2MbTc19cbFW3BYU2IBRk5XhrVaUi1awGIXDuwFqQrY=;
 b=I46Rp9bgRv+yNdR0KltVLDau7NsOZ1G0AvMYyGd4TsU6oatiaUI/XIlj3eCdIN9XIwkRfQeG6oQQcYUK/ghS6K0EkwfsygBxkCwE2oL3ciCylhPoE8Hmw/LmMebdgeuaeLjbZcmSljpq1O10+ub/AR8Wn5puGH2sboYN2VAome4=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4111.namprd10.prod.outlook.com (2603:10b6:208:111::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Thu, 28 Oct
 2021 18:13:16 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329%6]) with mapi id 15.20.4649.015; Thu, 28 Oct 2021
 18:13:16 +0000
Message-ID: <86df4640-b1b0-d3ee-119a-b6bf608f6d97@oracle.com>
Date:   Thu, 28 Oct 2021 14:13:11 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
References: <20211028105952.10011-1-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <20211028105952.10011-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0229.namprd04.prod.outlook.com
 (2603:10b6:806:127::24) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.110.188] (138.3.200.60) by SN7PR04CA0229.namprd04.prod.outlook.com (2603:10b6:806:127::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 18:13:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5822cb4c-d5bb-43d5-9ceb-08d99a3e9d03
X-MS-TrafficTypeDiagnostic: MN2PR10MB4111:
X-Microsoft-Antispam-PRVS: <MN2PR10MB4111A5C6C189060AC2C7D3768A869@MN2PR10MB4111.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nAzxwAHJLNMbjCtEbIQyyP/AyjtLPOhOrcXjyFUtESPeEXedAioS8A+HrGRA0BzxgoHLznsO5UxuA5CeKr6WXAgPwRVzcYIEkqCx4wC0S91qjItWUO6EB7CHsE2+rBWe4xLlU8DpmchBPj1ZIZMr3Bx5wbzcWkb8Nd6erm/86tLV+1IJm17XmpOBNyT7y8IK9/T4isEmwkG6OdL2mPZTgei5ArP8pbcQBoaccWH/lq3KFmL7RWPzDdy8ZXJQ5LTdHgg+g5c/5QNEhj4pASTEIr6Y4dzN7aX1GgZ1KCrcSWcT7xjYqcJi7uA1rns6G47Pv+JEjyGB4aO5ngabJJgtCgEXUmXVmo6B6zambWjMnOf6Yom8/XmlYUAC9sTIn/SqgXlaatjIsIVvK7NxE7A/pc0hM1b3LDlJ8gPyj3BlZCrrRges5wjhphCKeX6Izk0OZ80WmGS7sjfGa3ToeE8xRpDGIYGDXydHLHUpXnDlQaYsef7NFNBuHkFCQl1KcQXuztDAP70JUMjsSTlL/F7ZA1cDMAIb+CEKN8RIywHjNL4EbgMUc7wtPT3Hhx4KRwZ1XgUcAqAf/S1yOtd62XZw8SxL3BrpnNCAY7TLPiJwynkiq3aLnLV1cSJsSn6dud4L7nuFeNZGbM8RXKkTqZolU9CzTNLV9HJeRtGE2I6O7q/ZaKoL9XYu1Y9u/XJZKHB+aq+MuotJrw82jhZEEKo7fieBaw/l1CTKSt7lYaepggA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(16576012)(508600001)(53546011)(66946007)(31686004)(66556008)(8676002)(316002)(31696002)(54906003)(36756003)(86362001)(558084003)(6666004)(6486002)(2616005)(5660300002)(2906002)(44832011)(8936002)(956004)(38100700002)(4326008)(26005)(66476007)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGZlMkxobkI2d3p1ZnpCQTdhUnpaV2s1My9UMm1zQzlSOVV3dUhBd29odUly?=
 =?utf-8?B?WVFScmIzeW52V3pwcFBoY0M3QlVtQTVGa2hCbmJzQ1dwaXBtNkt0ZVlpcEZL?=
 =?utf-8?B?ejNZU0tySnNOSmZudjZUKzY3MkhWRkM3TUpaTUVFdDVqYytlQ2dwMVhWZnpj?=
 =?utf-8?B?S25hcnZRZmpaL2REVlIyU3NLWlZQVDZ0cU4rQzhmQ2pQVUw4YjgwanlqTW5v?=
 =?utf-8?B?ZHdDV0FtbEV0WXhzaHNKc2RwMkx6a3FDeUN1UFRyK1A2SHpmcGJaRjYrMCsv?=
 =?utf-8?B?QXhkdTRQK3duVEpxeStWOFJoRXE0ZG9IOGYvQ2phMGtaSHl6aHdjT1hnVDQ0?=
 =?utf-8?B?ZlNmNUd6NlFZUjc1ZVJZbERYeEEzWldURWwwS2JQNzR5YmFXeVRVNW8vMldP?=
 =?utf-8?B?UnhnVXVKOThMcGJnR25Gc0tpSUN2VVFrVmNFR2FjdnpQZ3hQMktqQVV2a2hN?=
 =?utf-8?B?WDZYcFhDQU5ia3dNTmFmbmlubUFLRGVQZllHN1hxdG1iQ01LOTM2bXB4QURx?=
 =?utf-8?B?ZzFRZTJSeTlIZnUvSlgxTkU5OHR0blJmVVhaWDQ0Z1MwWHl2b01RNUpPQmFC?=
 =?utf-8?B?cE9hbUx5OEFvdVYwbnY3cmxIZDE3Q3pWeHhXYTVjUTMvdWdCcVZzNkFkSDBt?=
 =?utf-8?B?UFhWSnhQRTBkZHZubmdqOWFhRHBUalJpa2J2SkFuRFkxZnYxU3BhamlkTTBJ?=
 =?utf-8?B?aDlzdk9ZN0NtdC92ZlNoU1Z6S2ZNUDRybktMaHRoTEsxQmczRkNkazE4VzJv?=
 =?utf-8?B?cG1lZ1VMaUp0dklQdlVBNk4xN3AxcExJa1ZvK2hsdTlWRTV2SldRb0FhWitP?=
 =?utf-8?B?dVl5R1o5THMxdEVGNS9iMFVpVHQvSHZQanE1d3RsYmd2d3prT0l0TURPRTVw?=
 =?utf-8?B?bHpreGxEUlYxdjI0b1VuWTV6T0k3R2FkZldOVVVScUpaY0t2NFd5aWpTTmJ0?=
 =?utf-8?B?ZjFzNGhuWnFNQ1ROVXlBbXdVM0F3QjBBNjBLdE5oSUc1MmxvY2ZjbStzNHpa?=
 =?utf-8?B?U2lQTkxQTGp3VGhvY2VRSk92M04wNzZmV3JPbVg3bzhxREZjOGtkSjc2ZWhB?=
 =?utf-8?B?a2liZW1ZWkNPbTV4azM3dzJxR1orUExhUU94aFc0VjROMUtQcldxOWJkaTZO?=
 =?utf-8?B?MVFXa0lUVmRsWVQ2ZkFBUlowb3prODI3aytxRDdXbDc2d1pVaFpFQXhxZzg2?=
 =?utf-8?B?ZVZMNWVmdkJJTmE5NkZ4YXpqVG5CSDltSE1IZVZ2VTI4T1RwTjdwZnNTUjY0?=
 =?utf-8?B?L0JSVXBlKyt4UXBvc3FvSlVucDBmb21maWl5ZXhJeThqcmFNOWJXME5YczdE?=
 =?utf-8?B?QW1GbyttbVB5d2JtMW4yeW1NdUw5emNac1hKNnVZL1V2QVh2Y25NN2JBK1hn?=
 =?utf-8?B?WjdsZGhmaGRvdVFDK2ZFL2VFakdrNU54Qm1EOXhLSldZTjJkUUt0QWorZ09V?=
 =?utf-8?B?QXQxZnUzMS8xNkwwSlVaanpkZDRvc2RERVZGS3gwL3hkWitOa05VVE9KQkI3?=
 =?utf-8?B?MVpyc1FEbnRtT24zS040d2RTK29oQ294bFpxSWozK3FyOUgweExKdEZ1TzJD?=
 =?utf-8?B?NXlFdDZmS1BZdXBVaG5ySDE3TWczeTNnVVBudGdlcy81ZmQwallQb1FkYi9Q?=
 =?utf-8?B?dVgrTlh4Mjk3Q1pJazFCalZkY2JUZDBVK0l3djI3S0xyMzU5dUtYVEhieFBs?=
 =?utf-8?B?VllHK1M0TjlRYnplUnhvM3BFWjV0VE9EaDA0bVpIaXhQUDdBcXR1NGd5V0tB?=
 =?utf-8?B?ZENyV0pBZ3ZNSXNlbVMwYnF6Z1hGRi9nV1ZtRWI3YmRPdVBUSjVYTjlJeHE5?=
 =?utf-8?B?Zngvb1JqMUoyd3lhSnl2ajBVamhQcEVOTGVhdDNtYWpYbHN6QnlocmhDQ1R2?=
 =?utf-8?B?K1lKZkhBWStRYzYwRmx3R1E3akZ0dVRNVjVpa2NsdWdjUmk4SHJ3NUtqT3NC?=
 =?utf-8?B?dE5xT2IyaE4yYmNuVE9EK0ZwdUJocW5JNVgyNUZmQmhoUlkyRkdEdG5jTEM2?=
 =?utf-8?B?QUFzUTZVR1RJaWxDK3RzL1EwT0tPYTJDV1pRSWVVZG9JYUlmUTJpcEdFRnJ2?=
 =?utf-8?B?ZFh5SEhkQnpCL1JtY3UzaTlOZlF2TmdHdTRIT2tYOGh1T29KVlVOU3BCZG9I?=
 =?utf-8?B?cGxJT3ZScHZFbXh3MkZqaUdBUnJTa2k0TUdHUnBVYy9XVmJCWWp6b0pjTm42?=
 =?utf-8?B?a1VXZzRDdlhoRHY5WTMxMkMreWNvbGdPYkNhNldVRWRHR0FjNHFIS1VxSnhO?=
 =?utf-8?B?RUVTVXpoZmtIYkpNNGRvVlMyTzZBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5822cb4c-d5bb-43d5-9ceb-08d99a3e9d03
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 18:13:16.4476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +wRpRGeER8v3nTpdxhdOB7EQ4STXuHgttjkT5Ofvgjb9bUUYB2NK8JhcWIg9z1t8C3GASsnvsvUHKviUnaEu7kvzbFjIDmS3vvy+Q/CL6tU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4111
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10151 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280095
X-Proofpoint-ORIG-GUID: MBXg1uUgs8IUfF3jm2otdfABloUDyh7a
X-Proofpoint-GUID: MBXg1uUgs8IUfF3jm2otdfABloUDyh7a
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/28/21 6:59 AM, Juergen Gross wrote:
> +
> +	while (current_credit())
> +		schedule_timeout_interruptible(HZ / 10);


Should we be concerned that we may get stuck here forever if for some reason we can't balloon down everything?


-boris


