Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECB945DD4D
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 16:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355922AbhKYP02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 10:26:28 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:51970 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355934AbhKYPY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 10:24:27 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1APDT54B001707;
        Thu, 25 Nov 2021 15:21:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=lAFi+9QQ5wBoZ0S2Yq68JR+rDQ6U57ejFyK9Div3QZU=;
 b=ORzscM82IyI+DOUcx4ehP58wIpfOoDL0enD/M1sWDFJ85OCr5OV6lW6/wKNgNW6/teER
 epmwnVUkevMbjz8NiGxNKLCKeQyzGJ47GW9gFQaSFpGJWE+Pig4WVvs/9PK7H/Yg0l6l
 IDopU8mINJ/Jp3mjlabMPkmSc6x8KbYqOXpzEOsmbfPLwywErxWD8l7ngxorDXRhRc0H
 kb+MKE8BeqhXDqMByNHvbOP3gv5R8sO4+to3tkR30IuSUDhMrhyExrWkreT/YdGoiQGc
 OOsg85r9cM1HTIMD1H+TzwURbP5mo2Y7Wydig38z8CYM+9Y6iWTcFeTh1G4YloWJSHCi cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3chmfn7vdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Nov 2021 15:21:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1APFFQLu134833;
        Thu, 25 Nov 2021 15:21:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3020.oracle.com with ESMTP id 3chtx809qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Nov 2021 15:21:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/znt3qpWfCkkM+4JxktmV/zhCEPFBeGNJ6voteumoYqo/XbsgO6zQl0q9SP+KAYtNn7ZbP0ZJ9sBmAVYvoNcR/J3OHM1FfHjX9nYPOAICJBJXiBGYo2GLxXGqOkjpYkzyB8kBLmTXiedG0X4LNv88ukRvuJIsauqVppIFpkaGJylBU3aRhI1O+BCA7guSD2OjS7lj4xssVmFD8TgPjYJCuiXbFuX+QeQwUUrgZmBq7Cd7DbTK5ylDP6A77TpCa5CFr77g3Sh9Htrs+qmqEloF5kn7vXZwJvaOLd8HSaRLYQUutOr7vGjFdfKl+T0gpJyDfQoUdre7KkHrZJvYRhkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lAFi+9QQ5wBoZ0S2Yq68JR+rDQ6U57ejFyK9Div3QZU=;
 b=g6UPfDfb4ew4aW90oihxC7+YiT3sQEbl2EtQevwtno3yv5E/8wkiDEFo7VH4P6kZ5Kgb+TT3bREdJSrUD4nx4WnoHouOMgKzAKL2AOcpU+McRWFcJwMqomuafBAkNO80+jTXDKOKPmdKdwYX2XmKTpFKz+xP8sRAX9TfqLzCZlHYdgEZjR9LeqDogf2Azy72WTB2AyiTdYXwwq6LoTo07rCGjekYU/eAGIEVg+f+VdzpwsGAQWDkicKJDn9I0mdMcFq2IJMSbsaTv7Yykqc1puXDYjPTjOWZQ4X6BqyEsn70KqurpvqBtAlzEUjcy76+BOQZD5IZ96iA/auSEGm34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAFi+9QQ5wBoZ0S2Yq68JR+rDQ6U57ejFyK9Div3QZU=;
 b=xhUlw46fJzM7VgodHNTqY89tzmMIxcPV8UCGS7svzN4GLcC6xLX6/CJVvVUp/fQ5ppAg17x4Y9/7oN0A+xzcHRbjIs3Mj+DOJABAz/Q9JlGzsjhblge9td0uRQk3Q0kVNoVSWGBYaswlgXXHxpLNewvJBsQNNaRsjJZ9S0dGRsU=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4383.namprd10.prod.outlook.com (2603:10b6:208:1d4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 25 Nov
 2021 15:20:58 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12%4]) with mapi id 15.20.4713.025; Thu, 25 Nov 2021
 15:20:58 +0000
Message-ID: <54e872a6-7531-68ba-4cee-f333be2305fa@oracle.com>
Date:   Thu, 25 Nov 2021 10:20:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v4] xen: detect uninitialized xenbus in xenbus_init
Content-Language: en-US
To:     Stefano Stabellini <sstabellini@kernel.org>, jgross@suse.com
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        jbeulich@suse.com,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org
References: <20211123210748.1910236-1-sstabellini@kernel.org>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <20211123210748.1910236-1-sstabellini@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0049.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::24) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.106.108] (138.3.200.44) by SJ0PR03CA0049.namprd03.prod.outlook.com (2603:10b6:a03:33e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Thu, 25 Nov 2021 15:20:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09169b10-c57b-4ba9-6fc1-08d9b0272e9d
X-MS-TrafficTypeDiagnostic: MN2PR10MB4383:
X-Microsoft-Antispam-PRVS: <MN2PR10MB43836B336D45D1F2AFC4DD668A629@MN2PR10MB4383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hF9MD2tWOf5rxJ4INVOOSMBldGdfKq7Yjs1VVyegzs1Wign7rL0gUxjVOJrY0OuNvzWCK0RFEm5MQgpETzEjYr2nRryqQq7EsEl8SXyDehu7xhOOyhmeoP06Lc8rFeHZOQJ70kICLBm8N+kp64NRNHN0+utFxyezMvNLpWxyHw56mcK30ctJZ7LdqcdL511wDfvKdlKC9iJM5BNL3KouDPbVOM1JSoePo8NUNf2lPiRZTNqFkuHBXew/sOeFj7xoiw8svyYSowEJilO9VkLN+PcWRZTIdpz/a/3JVcEr9gsjP/fzu2o3P49oNZQWMqhNP6/y5T1YSm4Ou/VmMphK2ZrkBy00AyOnFf9U2SmGJx+Ru9zMvPyq7fdTvHaRP3JhtYUCLqLgtojpuhRYyeCUVWtuR8LXp0pcmVEZMhbm8liIGtlM/6872gRDpq1Npphh2u9S+ZADHzQ1zV37ONCbktAERcaOoXLkT8FTYOBwFG6dj5DgLxiM4J0hD9yJpVOKBMP0WVZhz7WvGV9pJ60yaXaMJ8+z3UPS3IBgV981Jb5PxtDBShcF2o0xKFnjmoFAddc290TQmowxOdRT5Q1LTsFxWKpjSG7t1OpX5d+z6AKqvBAbgUp24fWHICQccbeoTj5XSu/JDxgBQcPNBJLsrZo1EogJImFd0QCFHuz6RLC0foioY8bPKuQ6R5RyNmVpjgmmuBPeGeiT5Gom9kqfZSbrWsIc2Sadaz1B7Vvnv7g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(44832011)(4326008)(2616005)(31696002)(66946007)(66556008)(186003)(316002)(6486002)(5660300002)(16576012)(38100700002)(508600001)(956004)(2906002)(66476007)(4744005)(86362001)(26005)(8676002)(53546011)(8936002)(6666004)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEQ5RzR2bHRUSHdtWG8yQisxRTFwUFpnejZBT2xpa2VtNkdnWnBEaUFTR0ho?=
 =?utf-8?B?WkxmV0ZpZHpMWjRTS3A0aE1td1JPV0FucFFiNE5PODIxOFl2bC9XU21hK1Z0?=
 =?utf-8?B?RFFKT2NRM2dxM1FNRURJSlhuWkxid0NHbElROVVUOHJXcnEzeVRqUzRwTUVJ?=
 =?utf-8?B?OHJXQ01WT1JNeG1NVXkxYzE4U0lCQ2ljV3BoaFY4TlJhd1kzSzhVZit1UUI5?=
 =?utf-8?B?UFg4bnZhSGRrdUIvaDJiVUFieDNoMm1iblNnMlVoQkh5NFFPYUNwK3ZZN2hX?=
 =?utf-8?B?QTM3cUpJdHR4N2lqc2pEYVFkOEw0NGhXbWVwVzRBNUpSMEhneXE0aVAraUt5?=
 =?utf-8?B?TWpMcGpodUdrWDdOMHo2Tk1xZmx4ZmpQN3lzclNYazM1VzJzRlRiNVU1SzdS?=
 =?utf-8?B?YzlVbWduZVZEMms0a2lnNCtsbWM4N3JhODRtc1Z6bDMwd2ora3E1RTl2ZmhP?=
 =?utf-8?B?VjJoTCthMFpCZzNkOUVCRUpyN2t4aUdQemtrMmVPNUM1SmQzOHR0dStIYkQ5?=
 =?utf-8?B?U1VoQXcwbCtYKy8wOE53d2dYUUZnVEhvL3F5VEJXa1NMbUJhczZISEFqSll6?=
 =?utf-8?B?Nm1xTGczTWpabFROMlJ2MldjRU83dTZVUllhQWVFRnlBd3BGRDJaa2hqa09N?=
 =?utf-8?B?QVVUbFRDd0FsNERPMWx2aGlPNkJWR2sxb2laeHY0dCtqc1RoWEVpUVpCSk40?=
 =?utf-8?B?KzNDSFFqcXRrS3lESVcyeE9IL3BTWEhGd3NFbVM5M25LRFdUM3NVenlQbjF0?=
 =?utf-8?B?bzhGQXpGVTFza0VIWmorWGJzdWkrS1ZEVzl5QjUyMHl5bnd2MStaeFJmMFdj?=
 =?utf-8?B?d1h3SGZ3MDdhdi9aUzc1MlVWZW1CeWtIbWU0bXNiaDROeDJjd21YZGxTbVpz?=
 =?utf-8?B?VTI0VW4zelhQc1MyQXU2RzBoVFp3aE83OC9mYWluK1RRM201NXZJclpwVFZj?=
 =?utf-8?B?clJUUlI1ZzhVUjdNWUtKVThkSHhRREdZbk9YUHVsN0FuT0RrMjJGN3lRNlRR?=
 =?utf-8?B?R0V3MGZKMkdyOHpLSEFJckFYOEdVaFQ4d0djUy9SRC9XMEhzRUp4SGE0Qmh4?=
 =?utf-8?B?SmV3T09LanYrQVkwYXdPcHpoNER2RGlYZExiZFlHTkUxeVpRaHNUcTF1eTZC?=
 =?utf-8?B?Y3VnUVBkS3BaMytyTDJOMmNFbzBmbWRsL0FYZHJVZmtDV2VSN2QrUGh5Y01a?=
 =?utf-8?B?Y29vV1Zza2lTOHB6SVBuVFZuUWNZclMzRkxVSTlORlFBNzE2YmROUHJIaUs5?=
 =?utf-8?B?SkxIOHUySmlPK2xEOGs5MVEzVjMvTERRNUhjNnVDaDFaZUZUVXFGVm1zQjR2?=
 =?utf-8?B?VERMQS94dEUzL2JUY2dUVStzcHEyQUcyM1k4YUZ0d2hPTlJ2RHVSdjRmalNw?=
 =?utf-8?B?T1RTeVo3cGZQY2J5bVIrSDBTcFJSVjhta1I2VlBjNVAvU1liRXM1ZHBtVnpo?=
 =?utf-8?B?aThUNHMrMW9Cb283dTFyTmI4MmtEOGl0Slh6RFZ1TWtVVVdpcktOWWIyeTFO?=
 =?utf-8?B?VmpJSVVCVlIzZnc1alJuRGlUbWRVaUlTU0JBV3NWNGZJR2Q2VGpuV1VCVE02?=
 =?utf-8?B?U3RaWFAxdDhrWCt0RG40ekkyM0c2NWdJaGJwd0JydjJnaUhCUVM3bDZCREsr?=
 =?utf-8?B?VTJXNFAzeWF2UTlrLzFzb21ZVW5yVGo4aEFweHZwV2dvOEVPdklSZkVHYkMr?=
 =?utf-8?B?ZmtOQ1ljS2Y2QjZUNWEwMmlMcVQ0UmFLYzkwVXJVVWQ2V21jQzZCVC9jazI5?=
 =?utf-8?B?NHVRM2h2WXdUZlJoSC91RmtsbC9vSVBXZ000d0pySkJRcmVhNUZKV3RubkRS?=
 =?utf-8?B?aUtyOHZLaXc3ZE4ycndxbTRSSUZSMWZlZTRSazAyWmVuL1o5RlAwSUkyR1ZM?=
 =?utf-8?B?YTNBQ2lybU9tY3d0bDlOME1nZGlxZDhaVmlYTmNyblh4dlRISlhqVFZFN282?=
 =?utf-8?B?RjFNY05EdTdieDA4ZFNQQnJSdDh0ampBbkFUU3I2ZDhaejgrNFo4NnJGYUNt?=
 =?utf-8?B?VFJPNEdXTHFFNWZpbStWQk5WeDdncTg5Sk90Y3RhU0llSzdrZWVuQ2VOclZP?=
 =?utf-8?B?cEdncWNhNThiYVhoeXlhVmUxWUQwOHA0VHRuNFRvcHhJUlNKT1dpVDlER2JV?=
 =?utf-8?B?SU41UkFYL2R3WTR3ZnRrRDZiWHc2TWZkcGpkWm5MeWdyYndKUGtBLzlyQndj?=
 =?utf-8?B?ZG5NNzhHcjErd28yOFpnNFpnWnpleVBQNG5WOWlueDZhSDJRQkxwR3ZjRlYr?=
 =?utf-8?B?WTVBbjJROUtxMUlYYy8yUVEzQmJnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09169b10-c57b-4ba9-6fc1-08d9b0272e9d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 15:20:58.3720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xo4gk7qnMMctrtpFHmXFpgGTx5zbK5jL75yAl+2wkuTRq7s55ZBTD65ui1q6ms94bkDcuU6zn4zZIweyMqbGNfMRFL3YzP8r2cDdoMTCHuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4383
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10179 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111250085
X-Proofpoint-ORIG-GUID: pnDtrLdeU98Io3rOv_HuJp9gfcEpXX5x
X-Proofpoint-GUID: pnDtrLdeU98Io3rOv_HuJp9gfcEpXX5x
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/23/21 4:07 PM, Stefano Stabellini wrote:
> From: Stefano Stabellini <stefano.stabellini@xilinx.com>
>
> If the xenstore page hasn't been allocated properly, reading the value
> of the related hvm_param (HVM_PARAM_STORE_PFN) won't actually return
> error. Instead, it will succeed and return zero. Instead of attempting
> to xen_remap a bad guest physical address, detect this condition and
> return early.
>
> Note that although a guest physical address of zero for
> HVM_PARAM_STORE_PFN is theoretically possible, it is not a good choice
> and zero has never been validly used in that capacity.
>
> Also recognize all bits set as an invalid value.
>
> For 32-bit Linux, any pfn above ULONG_MAX would get truncated. Pfns
> above ULONG_MAX should never be passed by the Xen tools to HVM guests
> anyway, so check for this condition and return early.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>


Applied to for-linus-5.16c


-boris

