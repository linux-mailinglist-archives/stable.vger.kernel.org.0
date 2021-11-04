Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2246C44574E
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 17:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhKDQh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 12:37:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2654 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230345AbhKDQhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 12:37:54 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4G6XTW027061;
        Thu, 4 Nov 2021 16:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hhmNDCgXjQvoAX3ba1WOjDI+F6xGAojVC3VY2mG5XrM=;
 b=RVlzunmpCGb/yWgDPv78BgANxsEK3OwZAzW1ux67eQH9ZOazr2zga1W/2P4SrOqH1jx/
 m1Lpn5hoJtxL7orxJvTrrIi6wAbxsQ2b9RY4/WmblO1uyfO/2EOiVk3FFb6+Jn8vlC57
 ZWLw1yNjArHh04OefBmvBEezzU0cDVElTDLvVboB3NA2Vq/SBFwBlcwXEeI8uWfjw5Em
 qSU8pQkHar/SgwD7Rx0BTAmU707LV0ZdHxjyFwc3kzRQz7I1a0o1yemNrMXIp+qyuYhh
 /zRUz+xciQyf8dLsRMz18eGbA1mNMfmg+2/AVqflj/xTm4ei3ZXPirOLOX44pL4oKP45 rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mxh9n6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 16:35:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4GT7Lh145882;
        Thu, 4 Nov 2021 16:35:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3030.oracle.com with ESMTP id 3c27k8wycg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 16:35:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClQsqnBFpAHVOXKsfsmyaXhoe1CEevEzZPMDB7F1hGaZWf0++kf4VS169WLpK50B2zjOcbrfuO/rlmoFC69+vLc2FbHG1S9rkxkSV/Slbrk1AO482wMQUiY5iaptYVou8wRKu7F1JbI7RB1nigx1DVJXNeRrtI//kRCn8lNDPJMzRyxCzAC+gDi/Cjhf5qoW1tI8HYrdDjT41HfX9VZ6lPba7Fay32GXm+GhaUOj6+fOhibO7fV4v3VT8roRzXpGss61UI6iMWN9RffQtz8tK+8c2PrAvWAgoGzvNR8iI5sEhv+UXoSLxU0u2lcTAp6FTwIRj03GX0+XOobh6w2VwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhmNDCgXjQvoAX3ba1WOjDI+F6xGAojVC3VY2mG5XrM=;
 b=ZP+K4eLIvDz8+P1gINGcaG+u76lV3VenqMUBhFPy7tzsu7ITOKTIY+q7DC9cqLx9AyBDM7MHvHc8U2VF8AC4Ld8ZSX+Jx2vqTY8QiUenyjpKrv+q4dFIvdzGUoEi3tQm83np2E/rPFFYF+XPJjEOJ7U3UXxVNxpI0gVio4r3hFFPfIlwOHDbHNvBzUVnnEp3MJAwc2wzMI4ZFJGfw0nZfiEp5d1OH9xtDjGxW3uWnBn+XmTkTkktzAl37Pgt2O5GhvRVpNIItv7UBui/d2oHv50THSWcyznj+cRuXf5G6+EQdEHdRkUEgLfGJBETnN+meHY9tty25Oc9+LtTaucmXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhmNDCgXjQvoAX3ba1WOjDI+F6xGAojVC3VY2mG5XrM=;
 b=kjKlPv6Ndo/a9jd9MPhpYzunIZAvATfNWs29kom1hhUnYDWLtnybWDtFt071gAqyA9iyO4gJAPsixVxkRxWHAP9iiNHCPFBbsV2IeY19RQWKL1+ucPwmO6l2DGT/gucdnvjkpLdWDfBPHfLVOTZ91icNN6EKweT0ThN1DUEOscU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4398.namprd10.prod.outlook.com (2603:10b6:208:1dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Thu, 4 Nov
 2021 16:35:02 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329%5]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 16:35:02 +0000
Message-ID: <18c12ead-ddf1-9231-7f3b-aafddd349dcf@oracle.com>
Date:   Thu, 4 Nov 2021 12:34:56 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v4] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
References: <20211102091944.17487-1-jgross@suse.com>
 <f986a7c4-3032-fecd-2e19-4d63a2ee10c7@oracle.com>
 <f8e52acc-2566-1ed0-d2a3-21e2d468fab7@oracle.com>
 <3b1f1771-0a96-1f71-9c9d-9fb1a53a266e@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <3b1f1771-0a96-1f71-9c9d-9fb1a53a266e@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:a03:331::28) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.104.20] (138.3.200.20) by SJ0PR03CA0083.namprd03.prod.outlook.com (2603:10b6:a03:331::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13 via Frontend Transport; Thu, 4 Nov 2021 16:34:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10359bba-0687-49c4-cebd-08d99fb10c95
X-MS-TrafficTypeDiagnostic: MN2PR10MB4398:
X-Microsoft-Antispam-PRVS: <MN2PR10MB43987948BAFFEC62453296D38A8D9@MN2PR10MB4398.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJmzZnHJjFiQO2QIpiCxvne/qcZZgqhbNhNM8S7nt4k0mlHEWNXpppg5W4ZtxVqgN2T3PqhCIPXdniqaa1FqKVoGHqK6718B5uN0SkFBObrUlMRBay6N66sq5vLhQWgSduaWasGrjYEHn0bnm1LhqCyib2/2z/S+YlYydcJPfpW1aJlteYRHTc2VOkxXgGACL2d9Zv+9JJbw9QD7f2+v6gme0+y+zVLXcTWU65bXyC88iURVEHF/heFYyaUsEvrrmHrkmwUy0BlRbwPjWwyz9V+Wf8XRU2DthgSjGNNcU4DqmuTWYE7ZTWWVyJZkF4nl3q9hb1seBJq8VCRbWmCJ5POUhkcfDhmM/JkKEIThnpbiiwZe/W3lyiD4FveTIUuT9T8lbyL1GR2MQhAb/BoM9EnW+TIIdH3mJs9xq1D2lHFjGNPpCvZQXqvHnX+zl/GnPqAhhR4xNN/pWqaHhDwm08iZDhml6IMqsnt3VeJpeW9yq9yr0IkJEelgnx5ucOsL9PjUb5F3Nv/GHnK/UDc8paeS6xO1gMgOfcD+TBArz4wnSqBkhjeF+ld4Oi33mlg8C9bhxMuKcqz3Whb2zz7t1QltzIQwzC+hGsL5H3mBs4QOh6MluyWPpRRKklra7U6O7ClqDXBYeXujgmZYstuwC+BSInG1tiWs9niG97gC0IhrqaQPq0VaAY909+guuhrAkcSAtmv3ni2c5nyIbfp6nlELYJn4ltg8cOqcMKQLZwZ/g0lS0JiWlcf0OwhCsD8V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(4326008)(16576012)(8676002)(316002)(54906003)(6486002)(2906002)(44832011)(8936002)(38100700002)(31686004)(53546011)(5660300002)(956004)(6666004)(66574015)(36756003)(2616005)(186003)(26005)(508600001)(66556008)(66476007)(86362001)(31696002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDNvQVkvRWlSL3NyR1VuajRTdCthMFQ0SENucFQrRzRORTg0L2ZrQ0NGdGhP?=
 =?utf-8?B?bU1odDFaTlhhSFA0L3U5NHBMVUNwUS9DTE0wMVZmTmlWd1hOV0hkN0RYVnVV?=
 =?utf-8?B?cUVkTGF4K1ZoUkhsWWROcG9qK3VGa0l3SDZkdXNLZlNFSG9rdXZlekg1SDVO?=
 =?utf-8?B?ZGNiNHJNZ1Exb1pyeFdPVWJOT0VSTzBsRDJOZGpHT1AxWERHYjBFUGg1QnBo?=
 =?utf-8?B?cytWTStCMC9NcmFFaWw0eHlJU0pWVys3ZVE5RnNkU294Ykd0OGphUEl2ZkRy?=
 =?utf-8?B?N0JSS1Qwc0RGclBJYzNzL3cvendnY1B1THI5U0pkdHExUEFMOHpCcEprY21V?=
 =?utf-8?B?bjNSMFFHcCsrZTNLalhEOGFMMTJxUm04TFRZWXBsVUV2MmZ3SHNqeXRwK2JJ?=
 =?utf-8?B?Q1ZxVjRiNlh4TTBNUjl1ekw3dmJmWjJsSXM4SGVSMy8yQ3YxU0t2NzZ3Tkw0?=
 =?utf-8?B?UkdNSE0wZnRDazl4Y1FYNEExbnhJaHlIR0EvSW4rdjZFbm5FLzFuYi9SeDVq?=
 =?utf-8?B?MU9hYTkwbkhmdzAzQi9JMkV6eG9vb2ZUWEYvaUF3Um92cUtQN25oOXNNQlFp?=
 =?utf-8?B?YngxMElvdTVJNndyMlQrVmJmZ0lWbllYOE5vekFrMkVVZ3lJY09FZGlpSUpl?=
 =?utf-8?B?T3ZzUW03dm9ISDZ2Zit4VXpKR3ZqRzZtRFJpbkNrL3RIbi9XOVZaS3ppSlNk?=
 =?utf-8?B?Q3hhYmdiTVVWNDdMOGdjY3VVQnJyMTVsYmpxRFBlQWtweEtrVDZ6N04wN2FV?=
 =?utf-8?B?aDM3SWExNit5cWNGa1QvZEYzOEd4UHlBWXhMU0NMeWtrcllLVFhyK1NUSUpJ?=
 =?utf-8?B?Mkl3a1dVRHpWZ2pZTWZORnp4d3I1bFZyNGFPa3g2UWx1dGEwTkEvUG0wOVRZ?=
 =?utf-8?B?L2F1M00wUlB5Tyt3aEFVR1ArYm9CNVFaaVB4NTZDa2JDdzV5dnpkaW1DS3gz?=
 =?utf-8?B?ZHN5TGx1aXB1U0pXWldkSUNQRU41NWlyYktwaGZWUVdLSFcwRWE4ZjVqWWQy?=
 =?utf-8?B?bGtMRHl3dUZoejRVYldQR3JuQTdWZUFpYzlIa1ZSR0xrQm5RZEhaKzZNVmVw?=
 =?utf-8?B?NkN0dGhla0RISkdYMjNqVjY0cnFKVCsyVkwyRHZvdnpQVDNscjFkdEg2OFZO?=
 =?utf-8?B?SjNTaEZnQ1ptRTNKc0ZVTFVvczkxeVNrdVZJZzc4Ylo4eERtMVRtRU1xVFBG?=
 =?utf-8?B?ZHd0ZDBOYTRPNXpMdDQ4dGVDV1VCanlVTWYxcC9iU0Njem51RzhxT2Y3SVox?=
 =?utf-8?B?Qi9QZE10YTc2aGdYOUN5Tys2aGR6a0M5YUZyOU04SmJJU011bTRtM2phdUMx?=
 =?utf-8?B?aDlkVEl5Vmt6RTVHczU4ZndQaHVPT1lUcmNTcVhCMVJrRGxNK2pWRmpncXRH?=
 =?utf-8?B?TVZqZEtBM09Ib3hIUmNZN1orZlFjKzNualNjSXZYWERCY3QrSG5qb01zbStz?=
 =?utf-8?B?VC9LUGhmelplaXQ4R0l2c0pNVFRhTzBDZXlJNDE0UzkwUTA1TER6QlErdzBa?=
 =?utf-8?B?YnlBWWtlRExTcXpCczh0c3RiZHB6RjVXWCs1c0pPQkx5OXpiYUhVWU5nSWNv?=
 =?utf-8?B?M0t6eGpZYnplcndPWDlGb1l6MndKZXpuSit6UElTK2d0Y2pNNmNJMjRFR09h?=
 =?utf-8?B?VnZIWmdHVkRlQzRXNlF1RktQUDlxSDI0SWVZSHV5ek1mWkd0SDF4YnUxcWR2?=
 =?utf-8?B?cnNITjNnRE5VOVlkRTJibElzQjRqZ3BLOWc5TVFUM1puOEFMRi9jOUVtQW8w?=
 =?utf-8?B?NmFvY3VYbmtUNnZMMnJ2b3NEMUJWR2ZiN0dNK1loTnpYU0N4L3ZKeXBWNzdB?=
 =?utf-8?B?K1NycVcrdHFaNUVsMEE1bVl3UndiU1FoWDVXU3dhYXN1MnZtMCtNY1NlWmNx?=
 =?utf-8?B?c25OOE9lb2xvd3lvbklZbDZTQ3Q1K0FEMVJzREJSUVplbFBRTXpUMzJQYU56?=
 =?utf-8?B?WjNCcFYzek9zVnVxZGRzVm9pQkxIVVp2VXAxOW16VEtzMWdYWHlsTUtkbllR?=
 =?utf-8?B?S2piSy8ySlBnK1c1SHhVVDRidmhrWnhveDhDd1B1a3kzQUQvSFpDOTB4MzFL?=
 =?utf-8?B?V08rNjRVNlAwSVpRdVhOUFhNaHMzaEJaYXFXTUxzUENqOGlIYitETzVpS3FS?=
 =?utf-8?B?UFlMZ09OZEpwWWVHcGwzWWVYbU80NDJ0WlkwaDRaVWFCT1orS3NWUGhOM3dC?=
 =?utf-8?B?NnBpWjZnZnlWM3hiRUtwTVN1elhiaFRJTEYxbCtMTmEreEZJa1lNK2NSekdP?=
 =?utf-8?Q?82aBFmtk+umb5j9sQjTL9Y4rfkDUCDD6KfmoFrzoMU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10359bba-0687-49c4-cebd-08d99fb10c95
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 16:35:02.0182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SoN3R3B67Z5ljWjas3GRHnRDZNcPCSBC75cA2h3CI/UFFAv9ixtznOcYThQsnjRdvLr+KI9LVtAUR//vUKAGpvMcYivywtsBILwzAWgjrk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4398
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040062
X-Proofpoint-ORIG-GUID: WM7SLmzvSZ4tgtwDyxagxjxmPCIFQFUZ
X-Proofpoint-GUID: WM7SLmzvSZ4tgtwDyxagxjxmPCIFQFUZ
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/4/21 12:21 PM, Juergen Gross wrote:
> On 04.11.21 16:55, Boris Ostrovsky wrote:
>>
>> On 11/3/21 9:55 PM, Boris Ostrovsky wrote:
>>>
>>> On 11/2/21 5:19 AM, Juergen Gross wrote:
>>>> When running as PVH or HVM guest with actual memory < max memory the
>>>> hypervisor is using "populate on demand" in order to allow the guest
>>>> to balloon down from its maximum memory size. For this to work
>>>> correctly the guest must not touch more memory pages than its target
>>>> memory size as otherwise the PoD cache will be exhausted and the guest
>>>> is crashed as a result of that.
>>>>
>>>> In extreme cases ballooning down might not be finished today before
>>>> the init process is started, which can consume lots of memory.
>>>>
>>>> In order to avoid random boot crashes in such cases, add a late init
>>>> call to wait for ballooning down having finished for PVH/HVM guests.
>>>>
>>>> Warn on console if initial ballooning fails, panic() after stalling
>>>> for more than 3 minutes per default. Add a module parameter for
>>>> changing this timeout.
>>>>
>>>> Cc: <stable@vger.kernel.org>
>>>> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
>>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>>
>>>
>>>
>>> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>
>>
>> This appears to have noticeable effect on boot time (and boot experience in general).
>>
>>
>> I have
>>
>>
>>    memory=1024
>>    maxmem=8192
>>
>>
>> And my boot time (on an admittedly slow box) went from 33 to 45 seconds. And boot pauses in the middle while it is waiting for ballooning to complete.
>>
>>
>> [    5.062714] xen:balloon: Waiting for initial ballooning down having finished.
>> [    5.449696] random: crng init done
>> [   34.613050] xen:balloon: Initial ballooning down finished.
>
> This shows that before it was just by chance that the PoD cache wasn't
> exhausted.


True.


>
>> So at least I think we should consider bumping log level down from info.
>
> Which level would you prefer? warn?
>

Notice? Although that won't make much difference as WARN is the default level.


I suppose we can't turn scrubbing off at this point?


> And if so, would you mind doing this while committing (I have one day
> off tomorrow)?


Yes, of course.


-boris

