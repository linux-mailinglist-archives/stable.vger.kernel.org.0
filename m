Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839B9444D25
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 02:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhKDB6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 21:58:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:52244 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231945AbhKDB57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 21:57:59 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A40jHnr020385;
        Thu, 4 Nov 2021 01:55:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=mtsdcrwN2psltZmt0adIPJ2dJJsOPTWwTR+VJ8YLfdg=;
 b=M5drTKj+8fDbvo7tBcrUdTgGX0yWBorNaSxQqVEPo/5YJi7MjIeL6RPMoiiyYUZtFMPV
 5XZnOdbYArMbuVMJu06SaHvBU8M3ItXZtoXxF2V+/48xhPJ4SLtjPs/ljsAWSezUfrw5
 Z+/B9NKTVBiKp73tRENmT98lMgjJmzhW8Wf+dzXbUyyk3/cvBeQukfq51lE+Izg/sqT9
 wJ77Y9QzbkOZY85aJotMGsKKGHIReOe/LV7azR/tb/SaH97R+L9zYX6zU5ZcRoBn8pHe
 3m60vnMjXbtPFX2/nfn740GkJ7Jfzu1sduBvwTZXjnP5SnGc4KKfyHtqwuPdimVwduuo qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3q1nd8f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 01:55:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A41pxYq098955;
        Thu, 4 Nov 2021 01:55:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 3c0wv76ve6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 01:55:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IN53X1iXaaet0wd+9hpr1wxKnjyGjZp4k1k6VaWKifZCJyTplMJW7yIc/TV6VhbIm6O4k9NeMu4RnR5F9j1VRfLxsTV0kM0sAKfbxrNOqPsP5G52yyo1G9xPeYVCvwUc09nGrnGdFV9awhMmQAN9mX7xVgvJCH9SPFtbn/1VyXKbqjlr7zXjxj8xzf8qhclUFnCP9H+zeu5wE0mUwDkfalKO7lhFhCmuMbHDalNxnuFul/SmzOp6zcShOjyW9gsU8uVDRE7EdW6qNOCUkEiBNgqaqDjoDI5Ux5AfY8+hsRv9MxJMzTSz/WfFxv14Gvrc9uiZJP2AjMOp6Limm2bNZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtsdcrwN2psltZmt0adIPJ2dJJsOPTWwTR+VJ8YLfdg=;
 b=I8exgqiCTmukDMrq5ZybIeHNqnXnyQfFXfEp0ntFpsJbmXl2xsnl8TjvKgC41f1nkcK8uqmVqdNSd+G+DTxxRsBptGOgnWkZM5Hf9GVicq9Jzz0rKdbIRdFxCOP+CIbexgON0nKpruvknePrdDsKVl1I5bkehW5VHIGAv52xfPo1Xi1wIf1IsSvQ25S9yFxOaPQmveNFVOd4c7rD4l6SIOIob4GjYGn00f/octhdSYDM/Rl7FxWp0WtXUILfPsuOMmjYBkRpwLeDZ/hiujRj2MS5QXJhphWF+wlv+9QA2w8gRgX5k3+R8saOwnP1Zhm1tigjmKl7ixU8uDotehRblQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtsdcrwN2psltZmt0adIPJ2dJJsOPTWwTR+VJ8YLfdg=;
 b=qsrP1Ns3LeSGxDh6AhsNFUvv/S4mymBEhMvzqqS3U9HmAhOoAvvMfR/OZAVo8elmhwRv8Luv0G4nHXQuO5wA7LYvV2MkhX4D4uYkF226ZZDravsL3Sg3w4EQJtYEFWMIIi77gJ9v+6sAifBk2U8/oLhuNlR/yF7XqmVqVDHkQ6w=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BL0PR10MB2866.namprd10.prod.outlook.com (2603:10b6:208:30::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Thu, 4 Nov
 2021 01:55:10 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329%5]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 01:55:10 +0000
Message-ID: <f986a7c4-3032-fecd-2e19-4d63a2ee10c7@oracle.com>
Date:   Wed, 3 Nov 2021 21:55:05 -0400
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
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <20211102091944.17487-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::25) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.107.153] (138.3.200.25) by BYAPR03CA0012.namprd03.prod.outlook.com (2603:10b6:a02:a8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 4 Nov 2021 01:55:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3ee48a6-7344-48ab-714d-08d99f36226d
X-MS-TrafficTypeDiagnostic: BL0PR10MB2866:
X-Microsoft-Antispam-PRVS: <BL0PR10MB28661F96FA9A38F099A3D3218A8D9@BL0PR10MB2866.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Soh9GpFSHkvrhJzOhbsgK/Crsa/tmOzMVHn+EHkUn4u6Db+i3SAOeeTz/MScnR7rKeW9NrKOMiCfArtmFOcAXPpK9e3zySG5ziBdrI9LPwQ3f0QiJs0e+/fNit0pVmMIMVF/xs8ZRzI/baGbPbTmDBmCTheVJzAvozPbGdlGtmwg7asV8jf0BwBWOtd2bQ167vzaeEz7fGPz2sJbgkmxcye9JlxW5vry1BqI0MWX179wR/r8WRvqZoU9PXC5aXDuLX4o1B2ExoRgc9GCE+JCbrOF3QqWywdloBOErp4LUgoEmewGwwE3KhYqtrOsQpany8R/DSNaz3gxvBwLh5IloraEw4XkNEdyZhq5Y2SSKcJ0ANPV+AyAjVLdYxuQ2oMzc/MNMWemVIPYAVHXCmYES7IMSp3ba4rEZtdThK3gWggtYlqj0jPQo+qLKhYC10GMChzk8nLbtLKYBH6cjA1xoVObAGEDXFyUo5oiFW+ZHU546m3kOfMUTFqLS6K1qTXaWuRtGWDvqtC83xKC3SELZSfcMG9Nw6xFrR9vxGPnURFvWT25wZYKTvwyK9LWzNr21HD1wjQVfX5P10XhsFJGtLacEbkZ3z3m2C4S02eGbbGpz33OD6P21ZplU+6A7VXMGbI6fU2/YQZG/3Xfas7Z6+l7C9qJVAcutzcuwIYtTcqvT+R6B2qOdR66aMlveMsR0u1eqenuQLgy/V9BB4JLt1U7yZ1OZKy1n75bVKShFtksqgSOzqYzEigv/SuSyqfd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(54906003)(83380400001)(31686004)(2906002)(86362001)(6666004)(26005)(31696002)(38100700002)(8936002)(4326008)(5660300002)(16576012)(66946007)(8676002)(508600001)(53546011)(44832011)(186003)(6486002)(66556008)(36756003)(2616005)(66476007)(66574015)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SStkL0FsZG1scFdPaEl1R29YSzUzUnprWXdPSUFydHY5aVQ4NmxONDhPOVVE?=
 =?utf-8?B?TXd4TytjLzVNdnAxWERkMlVRVm56ZnFVRUpuU3BpcGVNT1hmWEdGTTFwRnU4?=
 =?utf-8?B?RjUreE82M0xLeUVkK3J2N1NwNGNuTFNINkJFb2ozdG82ejYzREpEYlBNcDFq?=
 =?utf-8?B?d09xc0tXNi8vOVlhK2dXU2Q1SVF1TWlTRVV3K2NqenFwQUNtRm1GTElPSlMy?=
 =?utf-8?B?S2hPSTd5SHpacTBIOW5ZOFRXQ2FNYVliWUdOcWFSN2hiWGtsZ2JQZlBkcUxJ?=
 =?utf-8?B?UWREbDVTSWJxQ2hzUVRyTHhGTlBpSk4wM1FQWFpvQ04rZTFBVG9UcGliVy9w?=
 =?utf-8?B?RVY5UVVPdXJxa1orc055Tzh2RVF1QnU2aXJKT3BnMVVsei9HZHIvVS9rRVFV?=
 =?utf-8?B?bFBYeXZXajB6WUlYVDFmUkRVMDYxOUpoM044dHlWQ0pKLzZzdW1UZUxhU1RL?=
 =?utf-8?B?VzRpdjVsV1d6VWhHWWE1QmlwT0M3cmVUT2k4Yy9mcWxqWnhXMWJzUUhGdmw5?=
 =?utf-8?B?b0pUNitYT1pPM3pmQVIreFBScGU1dHEzMDFPcFluQ2pNUWw0dDFqMmxIRGcy?=
 =?utf-8?B?d3Fweld5K1FvdDEvOEhNeGVKRDRIaWZKRE9Ba0JRSXM3R00xRm9NZmV6NEhm?=
 =?utf-8?B?YUFvWElBZk52dUJzV1BBUkcwWUlDN2tsaFJpaW1wbFUrYmNpKzlMUm5GTlhW?=
 =?utf-8?B?ZmtaaFA4b2plMGhtVTRrUlVWSVpXS3p2Z2gweFlnNUljTFB4YURBejhEUVJk?=
 =?utf-8?B?SU82ZVV0NFZIaC9IS1dacFVZbGJTRmZrbnRyOXZSM016bzZTc3dxdFk4L1Fx?=
 =?utf-8?B?WEVTRFJrZDBoN294T2xkQUM5VkFzek9SSTJkaHphOFJoRE05R2xmbTNVNEoy?=
 =?utf-8?B?M01CQWlLeGtlZFRoL1c2emR4aXdZa1liWDZzenp1djRrVnZYWkgvMXdmY04v?=
 =?utf-8?B?YTd2V3dJb2NPV3BVL3N6TzVaejZUN2RMUC9GL3I4ZnQwUUJDclh0SWp3TkNu?=
 =?utf-8?B?eldha2JMeEFFVTc2ai9tejdJYUttcXg0RFVUVlFxV0Nqc1lQa0M3V3o3U01N?=
 =?utf-8?B?Wno3SXNKU3hWQ25LODNCcnZ1RjhvdU9pQkYrNjlaaElPeVM1Y1E2WW8wQ2dY?=
 =?utf-8?B?eStYL0VyeHcvZDZqa2VVdDJCVWg4TTNYZWRaY3Q3MnBFQmhabEJ5SktGcTV4?=
 =?utf-8?B?cDY0VUtZR0N6MUY1ZVMyd01QOFdRSlo0NG5rTUNTOXBHQzNpYk80Z2UwRlp1?=
 =?utf-8?B?YnJGelFvZksyK054MUtmZzRwdmU5cnJqUzZCVzYyR2l4SExvb3lmWlVTUnhs?=
 =?utf-8?B?ZzdPWFdrMHZzbU8vWjdZQXlSRHN6b2QyaHREbHdVZndaaTF6R2RlUHlvSm1x?=
 =?utf-8?B?c0ZWY3pVNzFiT0Y1blJYWUtqNFc1NlJLN0ZvN2hVMkdnSjZjZ2xxUFlUeVg0?=
 =?utf-8?B?ZGdLOFRUVU9FNDdCcDdGOW5KaWszWEltYys5d3BHdytTYXhIdzNuZms1N0Jo?=
 =?utf-8?B?ZmxJTzRsSWF0dFhPcitBWEpoNG1OamlCUk1jZG9paVIrOGR3Rm5ZVzdxeDFO?=
 =?utf-8?B?dU53SHFWZDRvR1VMdDZNNUU1VzZUeVVQenhYQTlFSnZLd1c5Y2Z1ZFQ2S3VC?=
 =?utf-8?B?TGxBd0lDN0kwQlBSNUQvT0xZdW5UbXllUno3ZHVJWW1HT2JLQ2pXakJ5ZVpZ?=
 =?utf-8?B?Ri9PcHV1aDRxS3hJU2ZNM1h2UTdWNUkvY0Z4WXRlMEQxbVdGL25BdHdpRmhO?=
 =?utf-8?B?cGZWeVBvcHNEc0c2cndVRGlBQ1R4eU84OGM2T2U0NmY3ZDNFaTFYUmIvaUl2?=
 =?utf-8?B?NWtWQW95anRHWWd5WHhVRElwZWYyQ0VLNEV1d2xyOFM4Mng5VlJtelUzZ3ho?=
 =?utf-8?B?eGVnemNJYlJtaTVDMHk2MFNoRlExRFZCbWlLRmxjcjRnWHJFYm9NNHkyUjlY?=
 =?utf-8?B?OHBoUXVNdnlRQys2RGlEazlHOHF4TndhaTBSWlNZNzhiRmxNS0NMRG5UU3ly?=
 =?utf-8?B?YkRLNmFJUUhsNjZland0OFZaV0JMYmZ4Z25JcExDNW1BMGJlTDF6MzZUZEdE?=
 =?utf-8?B?ZlJnS0lMNWRKQnM4cFZBSnBPVEhpNU9EZ3NXYXZvYUl4bWVSWnIrTnloVkJz?=
 =?utf-8?B?bTdQYVRkZjVzRXd4eG45dmJWeVl0WVI2NlZMSFoyN1BrL1JKVWRxOHpZUWtL?=
 =?utf-8?B?NTFKOUgvQUs5K1E4eHlDSVZPY2pqamx5UHdvNTNnWi9iNTJFTWVBMFJIaExY?=
 =?utf-8?Q?zJJh9mpn5jWreZfEkEuihqClHcwkjAJ1l8AHv+6HpM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ee48a6-7344-48ab-714d-08d99f36226d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 01:55:10.6125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 34X3JnH9j7h2utarHdGhzYhC5q8JXA4FpniZdmGy7YAb+8roYMxsSNcY+vTNMoye9LzffNZNQr5wlnWthyRUtXnm3jcwvYUcQhgsXvW1Fqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2866
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10157 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040007
X-Proofpoint-ORIG-GUID: NNkTtpbl3soZRXfNxlpO9Hy15d_yNAMq
X-Proofpoint-GUID: NNkTtpbl3soZRXfNxlpO9Hy15d_yNAMq
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/2/21 5:19 AM, Juergen Gross wrote:
> When running as PVH or HVM guest with actual memory < max memory the
> hypervisor is using "populate on demand" in order to allow the guest
> to balloon down from its maximum memory size. For this to work
> correctly the guest must not touch more memory pages than its target
> memory size as otherwise the PoD cache will be exhausted and the guest
> is crashed as a result of that.
>
> In extreme cases ballooning down might not be finished today before
> the init process is started, which can consume lots of memory.
>
> In order to avoid random boot crashes in such cases, add a late init
> call to wait for ballooning down having finished for PVH/HVM guests.
>
> Warn on console if initial ballooning fails, panic() after stalling
> for more than 3 minutes per default. Add a module parameter for
> changing this timeout.
>
> Cc: <stable@vger.kernel.org>
> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>



Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

