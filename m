Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E7D4232D8
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 23:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbhJEVaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 17:30:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27130 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235957AbhJEVaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 17:30:15 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195LFsSY024348;
        Tue, 5 Oct 2021 21:28:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=iBaV51qMtP7RyQgfGWC46xfy78SlHAnhQOpMD7ttne8=;
 b=bC2n7cvnf0ZcELxn5PFem/xHXhfYktmhS0s4miGNBRovEYPsV/23f8KpwUyMzrNfMn7U
 5TxqVJk3R9yBSjvwxbGuTIak7IETtmtSMTrCYnYUOPtIMtfJQ9Q67ddfsPnH5Yx4RQrq
 s6XWUluod7gbCAaoJkjQ0lmkDVmOWvdxScVQQnbkPfhWVFLzf73QSIoLfGab7aDOs0cw
 BSuPMCNCs4ZDIKt1eEJaOHABnYzBCkDKCYU/jggU6CaNmthwtGl/0ylTidrHuL8E2rrR
 lD6hphaoTuukJ91r5CPootFD5jVyNUsn7ObC1C/3IFKg4cAj72XfUFWuEXuGUqLN2Ncf eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg454k82x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 21:28:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 195LEfaR016788;
        Tue, 5 Oct 2021 21:28:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3020.oracle.com with ESMTP id 3bf16tsmxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 21:28:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHS7YubRV9sDYbdDVyYP7RSx7tebXJ8CFKXmwzYZMASoDMp8kcYcc5T4ScFKakrWyQYFzRXyMoYb85z2kr0oyDCn6cCRNs2k2I22rjdOd20yGUW9UvPbBSxlTsx/J1McUZfPWPKHLcfKx9r5MLYJ9WL4F10M13xteL95LbLg/hhlPB3eQkjRmGsqUih6UFX5Fs/AVvvP8qZOaXS92LBRy/J+8+Jl1AjOcybaoYhtnMdlfC6erhkRxT8EKMU2ek5tnrgEYLdBRrz2iLuQ+2uKUvT6LBrszRkKJ5DNYdiTsY1W0tgBrQC1nObU9WyQonh61Z6bTApvQoQotrkmww+Wvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBaV51qMtP7RyQgfGWC46xfy78SlHAnhQOpMD7ttne8=;
 b=HXm4Mlq1bQE2sRUi8HsU+aYatzGCzMClNbZnebtE9sdPWvjUzt8RIZfF7KQy/hEGSwidxChL/bp5PgJP5hOaSdcklwjUeCJe0bpcZ9GSxQ1IXo2AY+I+X36/AmKTIe6pZX9bY9pVFj6aaHrN6uqtgODfWqhGF5JqNBNiPu3WYxd7qDXR3ri59OXQn9+/UXVoKbZjzRqmTv8+DbBxWkRzxi0yGrxHxoc+9nYe+bSK/SfMVIjNXmRODTYeFs9dSKS6ZOHPyo7qvUgEx+yW2Zowg+0/fwySLPeHIY+9ndk3tKQPcsTwpwHrP4CCwzXmxqhajKeM7igMsJY5FCiCQkNflQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBaV51qMtP7RyQgfGWC46xfy78SlHAnhQOpMD7ttne8=;
 b=G5EWK+HnoMJAollD/WeDr3coPuwV1nPxcRfARq5RaAdVRuFeCOGnspMLKokDCT6iraGDiyUm5mIWOZheFicAronpSc9/IT91phzsftMtMd69DTVEQU5stujaPz24rkcEUAxROBXtmddDqfsi5HahSfnGxK9qqUg/CdLr3GCUMnY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3349.namprd10.prod.outlook.com (2603:10b6:a03:155::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 21:28:06 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::bc59:71de:1590:cbf5]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::bc59:71de:1590:cbf5%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 21:28:06 +0000
Subject: Re: [PATCH] arm64/hugetlb: fix CMA gigantic page order for non-4K
 PAGE_SIZE
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Barry Song <song.bao.hua@hisilicon.com>, stable@vger.kernel.org
References: <20211005202529.213812-1-mike.kravetz@oracle.com>
 <20211005135435.341477bb4b50b84202c32450@linux-foundation.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <3747d914-c687-b983-c624-e3418b4d2448@oracle.com>
Date:   Tue, 5 Oct 2021 14:28:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20211005135435.341477bb4b50b84202c32450@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0279.namprd03.prod.outlook.com
 (2603:10b6:303:b5::14) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
Received: from [192.168.2.123] (50.38.35.18) by MW4PR03CA0279.namprd03.prod.outlook.com (2603:10b6:303:b5::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 21:28:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57f18dd7-f167-49a7-7bda-08d988470548
X-MS-TrafficTypeDiagnostic: BYAPR10MB3349:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3349A44D47153A097364F37CE2AF9@BYAPR10MB3349.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D/f6lW3aLtv+fv2MFwdc8e0jLgsVzo3L2UK2R6vCcuUnn+65CdypIHDGdEw51fEEf9gHYt6QZIQ6HCdLcGZcOLQGTGJpYndG0sAynZSPTvnjHBJKKarD79nXZeTNCaZBL6w4slswlLaHzyE5K0wu8jqkHLSQBzT5Yr+Pxj0fu7O9T2R/98nfj3/mJCl61w0taMlfyfFE1gXMO525r66hz0n+rTyPo+RG8iiVkAbU5DPIVPNzMILlTV8X1C7iKCVPgRgDXaOLdgoWjCreOo6bE+GWmtTj5I6d/3NgXDAx/Zo9PxZ7R5IkcgCqKAIxM0Lw/H0VHJ5kfxzXg7zl++mLufYMHCbCmfXipSn3koFYLE5wkXWf6AYyAfgOlYIAs92qhkIlp0YQFtpdYm2QlVUNB4SLmXQ3z9gG903B5EZiBqdtjsu8A37c9Yfzd1v5lQ/ZtyNsjt8A/yFSPiqfF0OF/+gNRIjMXZc9Rn7PHI/XNqLx27xA7zJteQm060O9rdkxWa/JTi8GW/a0LYSbR0ZFiEFJRXxen4vNbwielLvzLhvv4qtdZhyT4icwKr02BUVhadA9TKHJ11zXs27amNa3hYXSamAEmRosLSYdBLTAxbaAYSl3UFqU4g4Sm7X91rURSu72nFqbJww0vFCvvOidn+8t91oVVA/Wvj6ztcfDpqBlape3jmPpDVhQX5AVaHARux7WceTPFqPmlrH/uIeOiJ5tcVnK7nVAmRj6CK4roY04lnYhYFt0XJomu8B/Kxeax2zupUMgo9Yc0TlLQPYgeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(52116002)(26005)(8676002)(66476007)(66556008)(508600001)(53546011)(8936002)(4744005)(5660300002)(86362001)(186003)(2906002)(316002)(83380400001)(44832011)(6916009)(38350700002)(16576012)(6486002)(54906003)(4326008)(31696002)(38100700002)(956004)(2616005)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXcxR0pNbG1TUUZjc2tXVDhQN1BkYnBreXppNHNRVmxGQ1Z1T2dnYkR1eVdi?=
 =?utf-8?B?Zy9XM0dUY0hxYmhtMHd6V05jei9heWZWUEtsT29rWUtOd0JiVldaYllXY3lX?=
 =?utf-8?B?cG9ONlY3cXhxTVNhNFVUSGwwc3N4dk9rK1NnbUo5RC8wWnl0ZTZwWUJJZ1pP?=
 =?utf-8?B?d3YzcEdyaDhHOUZYS055YWIvckhCOUxvc25hcUt1bG1xTEdPSEJuQWtFYU9q?=
 =?utf-8?B?V3hickUrU3N6RVBmNjBoWVVqcGg0akRYMmtHZ2dNbnFZVDIzek9qa1VTVE1s?=
 =?utf-8?B?V1Mvbm9WWXBnWjJMdFFZN0FuS2lRQTVYNHFWR215WEc2aWx6aUtlR2lEaFVm?=
 =?utf-8?B?bnRMRjlTaGkxbzhtdDU0RDJ4eUZmbFh1ZXI2WDNXWjIwMjVFSjdWQjVBK1Nh?=
 =?utf-8?B?UnZxUjBmOWdQcG5HQitZbUNSc05pRXljbXhqbU5QdzUwajJySDQ2alJpN3Jl?=
 =?utf-8?B?UUZzSTQyZ0VpV1V2RUprRnMzR3pJVnBSYlR0NHNzVHFodDlVZXlVRjdMQ0VQ?=
 =?utf-8?B?VTN6cTBDV0h2STVoY2Fwcnh0dklCb3kzK3VBc3cweCtxclVENmYxbTYzZ0FN?=
 =?utf-8?B?Sml2cktmL2VtL2NpbjVBVHRueEFRUXNzRENNWk5vTUhtdTc2aVFyNTc5T3Rk?=
 =?utf-8?B?RzRZMUpXNXJ4YlY1c3BuYW0yREV5bmNHcU9udnlVNDBpT2Y2Y0xFcDRZRUFM?=
 =?utf-8?B?Sk1Lclh1Mzc4RE9kTmR3eDdQQ1hnK3JQb2QxQmhXcHY3cmxlQ1E0RGFtSHdL?=
 =?utf-8?B?SjlIVzA1N2lSWjJkV1RWREsyTnR5Y3A0VDN2ZCsrME1YR0MzU1JkeEVvZE5t?=
 =?utf-8?B?TG5KZUZ0U1Y5VW9HQ2NIZWJaU3JnN0dSMTBDRTdNR2ErdEV5eXYyYnV3SHFJ?=
 =?utf-8?B?QnVUUHY0R2wxZkpUN2Yrb0hJYVIvb3pHRmhNak9WeEpuL1RJNnM1VmtJdk10?=
 =?utf-8?B?M29QMWZwVWpqUUFUcHVPZk9wdkg5OTltQm40aytNZXRnRkFlcGZXeUFFcjdT?=
 =?utf-8?B?YVNvN1Z5UllhYjJOTFUxR0srQjI1Z3U5VTFQcE1wNi9DelJMcDRub2NRQ2I4?=
 =?utf-8?B?WTZvRytYNW9tNUQzem0yNnVPV1dyREt1QVdVb2NzSjBPOU02UHIxa2pqdXA3?=
 =?utf-8?B?MFpaRzNvVEpKb0k5WkJVWncxYkNPSWJlZVhyTXJ2ZzN3WVpnRnkyMWgvWTFw?=
 =?utf-8?B?aERNeFdqek1kejhWbWhyTlN2dnV2VzVWSzFUZjk0YWhWMlNvay9id3VkdWM3?=
 =?utf-8?B?ekMydy8xenZsdVJxZnQycU1sKzdKRlRXb0Jwb0N6dUVocDV2ZHVNRzVra05r?=
 =?utf-8?B?b0RyTGFkK1NEc2YxWnJHb1h4cytjNWlKQzRnS1hOZWlqVHp0a01XTWlXbmZJ?=
 =?utf-8?B?Y0x2VzA3bUhUYkkwM3NTZjNSbStCV0VDVkQ4TWd1emhraDl3MDZqUkRmemM1?=
 =?utf-8?B?dmZkcHFhd2RDNEExYWZIYXE3UEQyd3NPS1IzWnlNRjR5UWpJWWdkQzdrWVRW?=
 =?utf-8?B?eEl4STVKaytEazUvRHQ0MTVBeDFxeGkxTDBVL2NhSGNGb2V0K2k1a1BDMWlN?=
 =?utf-8?B?WHYxY2V2MUs4Vms2bExja3hDeUxWMmxzbDBLVithR3ZVOXNWVk1wR0M4d1JE?=
 =?utf-8?B?M1BydGlheXFpU1VOV0JXZEE3b1UvSzhqSTRNcGdyK2RCaTNsM3lBQzllWFhC?=
 =?utf-8?B?MDBsbHdVaS9mU1FsbkUwSFdDdy9aUFBCZWQwTTI5YlNNMzVCVXRXT1pzZC9E?=
 =?utf-8?Q?FgWbEsepcf7vNLTgPrRH9t9Xj/p089VxNJ/6agA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f18dd7-f167-49a7-7bda-08d988470548
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 21:28:06.5951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FfWZhybPs9lnIgG575dSGK6xhs+esNF4hk2uR3fZjSb4At3CmHfZmGT4TQ8c+k7Kjwtl9R2z9aw28vrri7uj4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3349
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10128 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050125
X-Proofpoint-GUID: 4LLraZR6XHvZfZCKjyyahzPyxHT8G1qm
X-Proofpoint-ORIG-GUID: 4LLraZR6XHvZfZCKjyyahzPyxHT8G1qm
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/21 1:54 PM, Andrew Morton wrote:
> On Tue,  5 Oct 2021 13:25:29 -0700 Mike Kravetz <mike.kravetz@oracle.com> wrote:
> 
>> For non-4K PAGE_SIZE configs, the largest gigantic huge page size is
>> CONT_PMD_SHIFT order.
> 
> What are the user visible effects of this bug?
> 
> 

Sorry,
I only recently got easy access to arm64 platforms.  This is what I saw
as a user:

The largest gigantic huge page size on arm64 with 64K PAGE_SIZE 64K is
16G.  Therefore, one should be able to specify 'hugetlb_cma=16G' on the
kernel command line so that 1 gigantic page can be allocated from CMA.
However, when adding such an option the following message is produced:

hugetlb_cma: cma area should be at least 8796093022208 MiB

This is because the calculation for non-4K gigantic page order is
incorrect in the arm64 specific routine arm64_hugetlb_cma_reserve().

Would you like me to send a new version with this in the commit message?
Or, is it easier for you to just add it?
-- 
Mike Kravetz
