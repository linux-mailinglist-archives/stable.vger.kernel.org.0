Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC0B472DBA
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 14:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbhLMNqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 08:46:49 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41302 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232047AbhLMNqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 08:46:49 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDBRDIG026927;
        Mon, 13 Dec 2021 13:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xABObrLcZa46vsqfgUDXjHQL8uUQc1toHRg3k3cX1JQ=;
 b=PARiGgm+UTyImXn162iUmczZCuTWHqG3z/kJavQLoheI+2pNnXUJVir4RdJp64wCUhbO
 KzEaR0m0HS+v4UTwC+ShkTBxC+9RReOrtB/F8Q0ihpubQIw36J7gq08fk2eZak/89IUI
 x57ATxc/6JSbqtX+rtfo0ctt6BaQszZ4kump3o386IKvyvUxB+yVQ66ACf9NpH77tvsx
 p20G0IJQ1J8rRfcoqMLLsHcfamXETFYdqfQxAgXLwuafAJNBZ41kbNOUyTdyKXTGyZWR
 D30pXGny5trx4TqhmPDiMNJlaC9XLODT46i/GdddR9gmUWgKC0ptdg7DRefsvvPp6JGK bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx5ak895h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 13:46:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BDDflwA087802;
        Mon, 13 Dec 2021 13:46:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 3cvj1c9xvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 13:46:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nqaj67qQ1UD7j+dIabI8dgkq9AgjaOIvz4vbLbDkPfIGsuDDjSdDr6wTBKYGinR1pOKT0M1WMD3yJ2HhhPYhtIVtOV0o/yCkmutVvEyDyqYxRszt6/MPyOms1Y5097RxkRSzgyjqglFBZIRWK7b2XINzN/soK0mxYSrwdQGgdxCqR9UiRIk/HiR6HJOazdmfV8gJfOzg62mew2VnzSCElQgHg5j2Qx/CEU2mkDW1u2RaV7rJJP5x9/1wH/RRpnIAgq3rDvFIfmRRZRrjr8G/ubHBuoCyfQlRHSL2fNjPYYs/CUVEuds3Du5n+zXoJmodsX/jFl1FcJ0awy0KXAAPxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xABObrLcZa46vsqfgUDXjHQL8uUQc1toHRg3k3cX1JQ=;
 b=DLk05DlmvY0TCjn8IhcZCfBDK54pLL5ukGBKtCoRdlW4Oq1fOl3zSC8C3xdVVX5s0N8WAZb5CwL5QmDu9zqHzdNUA5zS2MjkDE0hN90O/x/87gHBjF/ZbmlM6dAw0AgOdVvc0TiGQ3iZ3iV1HX/bAIaBvVrM6Mqi5ZP7SXYVGk5CcrB9VhkrfEh1Eare9xdIDPbLyb8haSn/VzSQGQOmQKqnDgTL3v2hW9tGQ9KDDqWxsI/784957Gz3Bm7IT8BPEb1PuNPo+Pa9BBOKPgzCjEppJmD+PuZE4ccM5ujDq2H6+HIkgZXk+JmYggcwGbQNFx2jEeYVU/PwxnqTJu66Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xABObrLcZa46vsqfgUDXjHQL8uUQc1toHRg3k3cX1JQ=;
 b=hTJKyOY+1Qnq7UnwEUAYjbcYWgvgyn2MkdHh4kPV2GFPzR6C/TWU5rnjcgvvxFo85QSOb9THi5yDVr+7pvQWiNF8ZgXbMxYYJAQrimlL2WEjPaf79ESc5iVidAj2s5O6ebv2E2XLokKoeeEl9Obs/QqIXU+ky8mpIjneDi4i5C0=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BL0PR10MB2785.namprd10.prod.outlook.com (2603:10b6:208:73::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Mon, 13 Dec
 2021 13:46:36 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12%4]) with mapi id 15.20.4778.018; Mon, 13 Dec 2021
 13:46:36 +0000
Message-ID: <c59fa2ee-f22e-eff6-8a4e-0f8ac3981f07@oracle.com>
Date:   Mon, 13 Dec 2021 08:46:31 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH] xen/gntdev: fix unmap notification order
Content-Language: en-US
To:     Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     jgross@suse.com, sstabellini@kernel.org,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        stable@vger.kernel.org
References: <20211210092817.580718-1-andr2000@gmail.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <20211210092817.580718-1-andr2000@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::28) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d178a71e-a388-45ae-7ada-08d9be3efb79
X-MS-TrafficTypeDiagnostic: BL0PR10MB2785:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2785B5CC920B64E6FD6315A48A749@BL0PR10MB2785.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4mOVuPMskdpuj/ebFYElwyXq9dBPpJ2xZ2SZA7xRHc4Dqk20fyuldM5cQ74Zkz8XetuexS+J5d5W7jQiOoM3VqpOKOgqP5ZMvxQ7IX6vRBS0d9r4/m08jF+SwCnTJYVg76XrNrndNZBtIPbE4ClB+l9ttFlQUqiWK7XlDhYKidvT10zFEhy9KxxLeJeROt3J+uTq7PCBB/Hr6Krvyedasz6+su0GgFSz/0yt+ranZ7OSxl9RuWDGBQALljuZtU0Vfz5a9NUlx3ccofmhhapcUOU//3fgNqiD2igwmRTOXK8OADGEU7YfvYm27zQDNibDbaoWpzPkml7G4R2pXVksTK8+iqn4IN9lmX5DLiHuu6DIF1e3BakKFFQjKrHjS89qKGwynSYu3ogdAFRta67+pTcFRAeDJ4FURhQi4A/oFg8aBVL6i7BouE6LcrSeYAv/cUErPhil8eqVchoE3mtqNISTguhyCz9LX1SGZ+uwq8EMzc1xY00NsR2yVW7Vr5xzUt8hzyqAS1rC8/S0Op/n6SLAnxXeD2lKYi8ZVQgE+0LZqmT1+tbpdeKN3e04g5/hm1uJVmRUukGwsuVltzwjvOp9vCC4tn0e81oaLX4dckqkgCrtxyrZtfVpWFKqYsWxOVUiZNncD5Z54x65s765TzDAwEobYIqYrQwNBOmPIv/91+OvP7neVtx1WrBHB1gKO4Hm+jUjbtLD6DuHGu5WWU9kDlNugveQU7sQFGgIJr6JW4YUBv+RCzO9SDcUleDy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(15650500001)(38100700002)(186003)(31686004)(316002)(8676002)(36756003)(66946007)(6486002)(26005)(5660300002)(86362001)(2906002)(6666004)(44832011)(508600001)(8936002)(2616005)(6512007)(31696002)(4326008)(83380400001)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlJYMjhlUHN2d29UQXFobytpb3F1REVESm5lbk1jUFB2cU8zWkE1TjU2ZzdU?=
 =?utf-8?B?aEhsR0VmbkVrSkpwbUh2ZlhGb3dEUEFmR3lmcjVaTWdHSjB4RXpnck82NTMx?=
 =?utf-8?B?TVpUUG5ranhqNnoyWVBRNzBCR3pmcDZIL0JzeHdqa1VBRE1VVkRmZUZEYXYx?=
 =?utf-8?B?c3lxUFFnRjJLU2VkcSs1QXh0ZXQ2eTkvR3hrMm91OGd3VVl6R1pRSm80ZkNL?=
 =?utf-8?B?aEFMamVwUmhieWtkVjJBUVROMVFOUTMzZ2tndkxUTmRzeDNMaXIzajhEMXJu?=
 =?utf-8?B?R0c3UWt4VVpPMnlISDZ6aHdlV3dtc1VWZlkxYzRaQ0xQNVdCazlrYlY5UnBB?=
 =?utf-8?B?S3J0b1ZlUzdCNE5FVmJhYVFVYVdDOStlU2tHOVpWYlpTUU9iZHpYalgvcmJO?=
 =?utf-8?B?VFlXUmFnbTYyT1ZFblZJRGt3WjRKSWJwSGFIYWNCUFJPaVlRVjlhM0lub3Vm?=
 =?utf-8?B?UVVUaFlwTHVnQUJXNXYxVFBkODZ0M3Nod3BDdFo2enNWYUNLZmU2UEZzUE5k?=
 =?utf-8?B?OWRiWXpzNFRZRWpnYk5jbHNzek0zZUZCdjArWTBiUWdpTHc1Yzl4TUI4N2VC?=
 =?utf-8?B?eHJmY3ZsSkpwSEZwN1gxOGZtT3A3Z0xralBQV1oybVZ2Q1JSNUxOL2J6ZmRk?=
 =?utf-8?B?RjJyRENCNEtvYzE5U3grNnJVQi91SG1ta3I3MTJ2MXpJVE0wT3hqVE1aRnRa?=
 =?utf-8?B?TUhlbDNsVmJaa1l5VmZBOGdYQ2FFbHRPOEdiZEU0WHZReFBsZiszSUxHVkFq?=
 =?utf-8?B?UmpsalYvdE14cTFCNFFXNzVQZDljejZXbUJSaHVsYTVEMEl2OWN3ZnNyVlB4?=
 =?utf-8?B?dDhZTDZZZXpIVk9aZ0lCSHdpQXBQS0UyNG0zUG5oTlYzRWMyeURERzJQT2JX?=
 =?utf-8?B?cjA5T1cyZTROTmljYnlqVlh1OTIyQ1dhV0NmMndYVitGakZGVjhkRmRBT21O?=
 =?utf-8?B?Y2tiOEJxOFZkNVZHZUE5aGIwZ1NyTTBVdWU5dVNVRFg1L3p0OTZoaTZhOGFJ?=
 =?utf-8?B?WU0rOVhZNEU3Qks1UXQxT0VRbGRMY2IrS2NYMHcyRmV6Qkc4bHBUMlBkSHlU?=
 =?utf-8?B?V0VYQXE2WktMQ0hveXhHUEF3TWYvWllsYTFURk91bU9QaFZKNHQzK045LzRx?=
 =?utf-8?B?dUJqclVsd1A2Uko3UmFaaHhiMVd5VzdoekVxb3I4M3NGRmd6cDlxMmdEaFJV?=
 =?utf-8?B?SzJKZ2NNREcyNUwvQkVCNU5NczVaOFNnLzYxZmU1dE94Ti9JRSthRUF0TXhD?=
 =?utf-8?B?eDIzTHQwNkdXVWtLZFFUbDY5d2M1ZTR6TE9IbEw3ZDVJTHZUc0NKRlJtTUR3?=
 =?utf-8?B?bHkzRmJtNlRIbVFpZ0RqekZadGovcTZOMnZ4Yk1JUDlJRER2a0wxL2NSeFdR?=
 =?utf-8?B?aDE2N2tJUlRMUFVmcFZadWpCQU9KT0FhMElUUklLYUhnOXZLa2w4QXNDc2hX?=
 =?utf-8?B?dTlidkszR1ZQMitab05ib1lCTGhDWDhmRVc3U2tNOGs0NXJoTnpCaEpDc0Y4?=
 =?utf-8?B?RFNCbmFlRG9PWmJEUkdvb0tiK1hCd2gxOTh2MXh5L1MxYzNXT2crSXNOOEZB?=
 =?utf-8?B?bkx3QVV4bll1Yi9HTjRZdHFNTHpnRDljTFRxS3JWZmFJYnNnall0RUtuQ0lx?=
 =?utf-8?B?YTlsRHZHd2Npb0Q0UVRTUG9qa1J2ekFXblVsRlhvTWczOVV4SU5objBVMnFS?=
 =?utf-8?B?dkZTMEZSTVdzd2RGVVVFQzdvaU94OHFTMzZPdXQ1Z1hrOHdmRmd2SlRiWEZw?=
 =?utf-8?B?dmtkRjdjVDZYYS9vTElEWSs5NW1DbFFjZGJzencxOFoyaVRCazNhMlBCZFhh?=
 =?utf-8?B?REQwZlBOVS9hRGFRMmhJd2hieVZnc09Wcjl0M0pZdGo5c3R5aWQrM1ZhZjBD?=
 =?utf-8?B?UWFUeVN5RUYxU2p6bjBKUytYQ21RSS80OHkrUFUzSjYxRVpSdUN5UURVQXZT?=
 =?utf-8?B?R0NwcUVhOXVyRkpEemJVNWpUQ0dieGJ1MEQzeGlRY2wwQ3ZFM1A4UFNLS3U1?=
 =?utf-8?B?WXpGK21GMDIyaHp4dGJnS0tiemQvRUx3dXp0UG9pNVErb2Fpb01zYnhWVkNt?=
 =?utf-8?B?ejJscm9XUGZzcGlRVUZvMEc4S1IvR2Z0OXpHMzhTczg3V2VvSkxjVVE2WUNG?=
 =?utf-8?B?bGNQMWJzVmdDNS9vTkZqcGJoQlByMFNOQ0xuM2dHSkVqMGp0MDllZHJXV3VK?=
 =?utf-8?B?bVpFbUN1bER2OGFSdWpiVFlIbXJkWFVZZDdQZms5eUJoL0ZPZjhMVTlwSjRV?=
 =?utf-8?B?dG9mR09xZ0NRY3VSd3Y0bFIrZEtBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d178a71e-a388-45ae-7ada-08d9be3efb79
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 13:46:36.7680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bngYBodl0HZeuw984MCyTqmH/Be8PdJ6GlFFMjsy/7wke280LpuPTXa1K+BPyDQBTeXSOVm8Rmj8I1lWlsZazLMKo2yxvcUr9cf/e6d8iOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2785
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10196 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112130087
X-Proofpoint-GUID: 1SbUEeN1LtsQLUajcInKZNXiYA30yCZr
X-Proofpoint-ORIG-GUID: 1SbUEeN1LtsQLUajcInKZNXiYA30yCZr
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/10/21 4:28 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> While working with Xen's libxenvchan library I have faced an issue with
> unmap notifications sent in wrong order if both UNMAP_NOTIFY_SEND_EVENT
> and UNMAP_NOTIFY_CLEAR_BYTE were requested: first we send an event channel
> notification and then clear the notification byte which renders in the below
> inconsistency (cli_live is the byte which was requested to be cleared on unmap):
>
> [  444.514243] gntdev_put_map UNMAP_NOTIFY_SEND_EVENT map->notify.event 6
> libxenvchan_is_open cli_live 1
> [  444.515239] __unmap_grant_pages UNMAP_NOTIFY_CLEAR_BYTE at 14
>
> Thus it is not possible to reliably implement the checks like
> - wait for the notification (UNMAP_NOTIFY_SEND_EVENT)
> - check the variable (UNMAP_NOTIFY_CLEAR_BYTE)
> because it is possible that the variable gets checked before it is cleared
> by the kernel.
>
> To fix that we need to re-order the notifications, so the variable is first
> gets cleared and then the event channel notification is sent.
> With this fix I can see the correct order of execution:
>
> [   54.522611] __unmap_grant_pages UNMAP_NOTIFY_CLEAR_BYTE at 14
> [   54.537966] gntdev_put_map UNMAP_NOTIFY_SEND_EVENT map->notify.event 6
> libxenvchan_is_open cli_live 0
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>



Applied to for-linus-5.16c


-boris

