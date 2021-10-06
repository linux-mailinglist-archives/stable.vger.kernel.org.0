Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4222F42355C
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 03:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbhJFBNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 21:13:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41290 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233994AbhJFBNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 21:13:47 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1960NenW022627;
        Wed, 6 Oct 2021 01:11:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=YDorkgV8Tn0yuTU7JoLBMjLy5LntqUHBOqBVAOnX2W4=;
 b=uoJjetCCzLFm6TyoTMn6NijQphFeAdPYl3PIdMPSW4OGinAe1uQEllMmQ0jJ9PRvJiL/
 5OIZckiLZTc4+kngCI1qU0EIgVAbxjyBvVSpZhfqiBHF0pE6dl2rQPx7E6VU0qxy/Az9
 lb0f2VWwSLK2D/1ZsrNqu4Ah116ej3N16HpgTCGxzME02WWQXYtEB4ZJVBu5eLrmHXvt
 xluH9NZ6B+U1Krtl6k0ng8CY3RT79sWfSCcQUiS0PECbilYUhdUQFA7JSnRUv7Ldef7N
 1Pt7kllYcSXwghTxtbDJ5Bf7JpfUfBbLokqiEESu1nBcnVGPLhtOW+1H3qOOyjurMOmB wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg454mbs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 01:11:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1961A0IT195397;
        Wed, 6 Oct 2021 01:11:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 3bev7u426v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 01:11:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWbCYa10xmwuUdFbIvceXpYWgt3qnP7RqhD1UmHqtVfnaV2Y9tnJvF+aRxGcyMSG8MaYPqy8STPo30z4qAqXKr4T/OoJQb1kveKTHxl4N4OyjlLRpm8+sFavp+yzYPwQ8emR/kDmpm29BpgeqgEJI38w5/5Hg67IPfOeMBSpTGuXNp0TvnLoNDUxai9lQwOTHwnsaSvW9ymlenNHi3lOiRSo9S9mFSlHfgELUFuzCdtXeTuiI7BvO2ATPeCrnNf+//1hKlO82/KbqVXn9RwQ8NUregMfg+rhwfL4jIGAajdBI7io/p4F/uffMQWpaxnoMAm4hIqrH39mhIugMjMJxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDorkgV8Tn0yuTU7JoLBMjLy5LntqUHBOqBVAOnX2W4=;
 b=ibrnUAa0coErFGcKgP3KcvmUnMfZTEjUiMKy+zXZoNk+xgGFSbJ6A1yOVNjG0wtAMwT8dYNa8IlHlooZa1CQUx0bVMC2cWQuPvkdPUYFpoxPTKIxS3Wd+AIZIg7pzYtsZ34XTtcIPu9SDLLwXYRA1OiVF6CxmYDAdPHt705tfftwWgzKirq0pt0q4Up28eVcqFY5i9ImbVX4ROLN2ncuvLfHjfg8IGpyonzXDiHJd9SXobIt3pso/2eaq1jaX5LDypKaxqZqDUvKElsocaNLpuKPWo3FtRQQfpM9WqOu+numAk9tKoD1zFzqlLH60CXacKlUqUg62KeySa0zz2hW9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDorkgV8Tn0yuTU7JoLBMjLy5LntqUHBOqBVAOnX2W4=;
 b=Os8d3kiG71yQFQ18xGejpokUzroOaYrdGgJCfKZ63+EoH4WP2bhBsLiKASRHEAjFEi4+tGC7OcSSAou8DrReKUr/XcET4Ln37v97xxTcOrZA+rcCGqycZyLSms3okj6v/mG0n24wrPOZgBtkIqyB/oDPv+A93Rwju2LPtivM3AI=
Authentication-Results: invisiblethingslab.com; dkim=none (message not signed)
 header.d=none;invisiblethingslab.com; dmarc=none action=none
 header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4192.namprd10.prod.outlook.com (2603:10b6:208:1d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Wed, 6 Oct
 2021 01:11:45 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329%5]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 01:11:45 +0000
Subject: Re: [PATCH] xen/balloon: fix cancelled balloon action
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
References: <20211005133433.32008-1-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <efaa22aa-2785-b03a-3c14-0ec232429945@oracle.com>
Date:   Tue, 5 Oct 2021 21:11:41 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20211005133433.32008-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0201CA0017.namprd02.prod.outlook.com
 (2603:10b6:803:2b::27) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.102.28] (138.3.201.28) by SN4PR0201CA0017.namprd02.prod.outlook.com (2603:10b6:803:2b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Wed, 6 Oct 2021 01:11:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39cc25cb-6488-427a-c708-08d98866438f
X-MS-TrafficTypeDiagnostic: MN2PR10MB4192:
X-Microsoft-Antispam-PRVS: <MN2PR10MB4192298781617BEC8F6CC2908AB09@MN2PR10MB4192.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2RWjbLedxCXn7r9Aqj2/a/QmrrUHtRG1l89N8aoMGaVWdU0iTXr7wNv1bp5PH9VHPl+lR2BOnFAsOPJaM1BMsbqwmCn895LUeR+XUSV1BKAbSdeOYtXOnnQ9LKIodNsi1l9Yb9DNI6+l7WE3Y93KW1gfO43aL3DE9d+1f3qdN0S7ccIB7cKkj4mSgFk8pAZEAIhR8yVSHKYgh3Rz8XS6xnwhgkQuBQkhF7sXDmQbwt9TgOy7doYUjZbUezuIVCldgTbA2D2aCpltYzpilTLxmQo+6Fg095G5r1q/8awlRuaHGX39EiXlqY7UnYvbHI7Kvwem7nXuIUS6S/3YYlgzi13n/oR6joqTb1tB8xfAGm49+RjX9wloAaXxtJdXQay/pHsyctzr9v9Y1Dagk0isWCRHYY+hoNaKn0udl7pSa1KYHbGZp2wiuIVR8Vh0izVY/gStyZfugpkhAAvBLdqi9hOwtPjbbJzqtOzJ2+v8Z0ZYfK512xuahCK3+t28Q3MzYxuZ7sZJwAq/H6Hn0krS+KYIFWNZ0/FAMvgVgpU8e9csHzQC6FvfIRTnVWMs/3f2VyDfGQSVRgImkDRvASip+xfsAwhV7C/AQs4M4fRBW0aowG3Td2DDhUxAIxKTThBGCv6k4LjPQKpDyMgk+A1U5H4oD4WA6dOCo1BYveoEzP/YhT9DG6yJajL1HWan4pYDXMkm1Rbiik5hA8Ywg3MGuzff7dvV9z4VxfOgVUGS62970i/UtjrLiPuMgZ7ISxyL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(186003)(66476007)(31696002)(36756003)(86362001)(53546011)(6666004)(66946007)(4326008)(31686004)(8676002)(6486002)(956004)(26005)(38100700002)(5660300002)(508600001)(44832011)(16576012)(8936002)(54906003)(4744005)(316002)(2906002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zi9qc3lKTHE2WUxqTWZleFRkYjJZcWIyWWlvUEZkRDFmbkhjenVPNXcrbjJP?=
 =?utf-8?B?TXBWRnRkV2F2TFMxOWtrNnJiNit1cnJROERWYjRTNlR2WkUya2ZiV0VQemhq?=
 =?utf-8?B?MFJDSHVrcHVjUEVybUoyZk54L0lYdG92NjhVcGNBMGpLVUVwbEpaSDU2ZEpu?=
 =?utf-8?B?WFM0VnhrbWY4UFk4cWxYK2gwQVhicVNTVmVaNTVrQUhNYU43Qm1sS1NEZjd6?=
 =?utf-8?B?Q3dXczh6ZHpnSmQzNGJzWW9FaFVUNnJ4VVA5eS9yNzhwaGYycHJweksrVm5R?=
 =?utf-8?B?UEZxY3lNenI5eUduT3VZMmF1TU44VnUrYlZuZWxVMi94VUlYV1BlUjlDcGJ1?=
 =?utf-8?B?djZSZDV1aFl3dDFwSUNCcVVxZHZEYjdmbk1rNG84eVJoejBXSmU1bmdkL2lj?=
 =?utf-8?B?aUhvd3NqUHZ4UU9VV1hESXJRTnU2UGhmNkZlY3FjV2ZnWGRCS1pSb3VlY2M3?=
 =?utf-8?B?eGdqYmJwb3QyL2UyQ0VEYVBFa0dGb3ZHWWREVkZTa0hGV0VNZFk3NmtzSk1P?=
 =?utf-8?B?b0xwWlFGbXN3RVRaakRYTGZLR2NaWGtwVU1ZMjlzdzZ0YnNGaEE4T0JZTzRZ?=
 =?utf-8?B?OWVsanc3MGV6cG9WT21DR3pHaUdyb0hCZXhqMHFScE1WTE53aFZRK0N3SFl6?=
 =?utf-8?B?UlI5SGdUenFsR2ZKUzJZZDM3YmN3OUVVQ2R4eHFEWGNDdC94ODQvMzBva1dS?=
 =?utf-8?B?aWZLa09Yb09kc2FzWXFleXZHNys4aGlaUVF4S05mSEQ2R0tUWGxjQmtON0No?=
 =?utf-8?B?VXJxdVA1SmJOWFZNUW1tYmp1MXlBU040TTRsTWNVeWdtekNhMkxhZVRMZmhS?=
 =?utf-8?B?dWRwTDJnTmFEelFjMUp2UWZCYjVSWS9Yd0hvdnRROVZiQ0lQdW5HZDB2dnU3?=
 =?utf-8?B?a1pXaU9RQjl1ajgvRzlRbVcycThZaldsMStoTDMzN0FQTkJoeWwyOUpZZW4v?=
 =?utf-8?B?RGZ1bEJWS3RIZm1sZ1Z4amJHb05PS3BURExLa2ZEdUt0NHZpamFsQ1puVEF1?=
 =?utf-8?B?NGtueGVvVEQ1VHRybnJYcW9MR1FyM3dBQzJ0cFkrVU9oNGNQdnVjZnB1cUxO?=
 =?utf-8?B?aUJGSEpGcFZnTXlYMEtWZzlMZkhhVzhIaEYwZ0tBS1JaSVlqQitNTTNKTjNl?=
 =?utf-8?B?MzgrUmFuTENUWWwxcWdCSEcrQndXa2x0UklLQmIrbnpDZkdHNVFvSTNzWWw3?=
 =?utf-8?B?a0laTlB5QzIvVU5KZnl5OWVGcHNESXhLci9rVW9YdjBGcktaZU13M2RuN29x?=
 =?utf-8?B?VWJpS0hVVnRuNlRXRytPcmpRZ1hrRktZdVVoWDJhS1p6YTBWM3BFK3lzVE04?=
 =?utf-8?B?RkgzbGVqeUIxbGxwMjVLSVd5VFl5T2tmQ1E0d1NWS2NXYmVyd0FaelpNd3do?=
 =?utf-8?B?azcrdkkycS9FNks0eHZRR1VHRUZ2ZkpuOFdKT25XaUMrQTlxM0liNjIwUzhZ?=
 =?utf-8?B?Q0Y3c1BQSmQ0dW9CTVovVWdOTmVVdW9uUEg5RWRML0p5aEZ2WjM4MVUyMHV2?=
 =?utf-8?B?amNXYnMvU0p0b21wK1Nib1JEblNyRE14QVhLdkxDWkRTT2VVRWNuVHZtdWRv?=
 =?utf-8?B?eWptT2JJazJmZksvS0xrMU54S2RaRU5CdHdlRWpsRUlQNEhQK05KQ01uN1py?=
 =?utf-8?B?YTVrY0J3c3RKTHZpQW94RHlWM3JpV1J0NlJUaWsyRXhqMzg4eUZ6NWdyOWJZ?=
 =?utf-8?B?aU5Zei9leHI3Qlkrb01nOXJ2bGpBa2VJUXphQWtPTUVJRHBkcDM3b0kxM0pk?=
 =?utf-8?Q?XimDfQbqNAxqewK1OuRLrDxdhG23fkSE/DqtxBh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39cc25cb-6488-427a-c708-08d98866438f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 01:11:45.3543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrVF9eLBOeT9ZAiFmIThBuDpKLYtDE96ALsOM/6jSDXdaed05JwFATG23T96Od8QH0dL9cU/NqmRxshGTfrlkEzTfyLPaxDule6UJ28Yu0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4192
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10128 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110060006
X-Proofpoint-GUID: jUsOfhKauYI8EwCyZDm6VomFZGcHwVOU
X-Proofpoint-ORIG-GUID: jUsOfhKauYI8EwCyZDm6VomFZGcHwVOU
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/5/21 9:34 AM, Juergen Gross wrote:
> In case a ballooning action is cancelled the new kernel thread handling
> the ballooning might end up in a busy loop.
>
> Fix that by handling the cancelled action gracefully.
>
> While at it introduce a short wait for the BP_WAIT case.
>
> Cc: stable@vger.kernel.org
> Fixes: 8480ed9c2bbd56 ("xen/balloon: use a kernel thread instead a workqueue")
> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>


Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


