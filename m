Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDF04457F4
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 18:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhKDRKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 13:10:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37204 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232034AbhKDRKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 13:10:06 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4GwXMe032494;
        Thu, 4 Nov 2021 17:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dg7qnGWqYcfGB4K778L7/rd3o+DSNONsoBxzoHeq1iU=;
 b=SBPguLS/rl7IJZJTLaSIL59WXicQB884HRyO92stgJgowyusHB6oW8AXuxZYZrv2Q1/d
 WgKQAe1iBYU03oRDRSxSCYJpMbwXa7I8dOTcAbGkv0k7QgkD4Hx9Y9nDi4IJGQxjahx8
 zkSmSNBEVkF23Xv7F0bbjQS0QDO0gpv3YRSlG9gjxZh16s7dAJNcr8mr0zGcBH0B/VCo
 UYktzCmxxG6EeOZFD6S9SKm7xkrum+Yisoc1iyM/yPhCuIyvrL+e8sB1Y4y8zI+3NEiw
 oZKKLsPP8JYA7z1uH9cB+/PqIdCi6/aLqGzzB/oYJi8skGtevHiCCy3Eg6TuYVSTvGIL sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3ju72en5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 17:07:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4H196c079510;
        Thu, 4 Nov 2021 17:06:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3c27k8y5tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 17:06:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRzaq0J1iDVEU969VfgFI7v3i+pqseECzxfVBmBdu/1XOiCKYVlcL/1n3RlzQnRN2/1NH39IiDRDsPJswixuUPOyA8Ka3XmfA5aVXS7opQcRtvPhtIM5fNUDv9EFzzIhqFnMozt65osSYc2w04D/HsTG8bP88wKmegwOww0uD1ddgb//G//OTjQNCjkuwqM0nTQlZhzzuQCwyNk/eYfdkyVv9c1Bg77zs8izTm3V3WZJY0dsIZA4rOBujzT9LGBOdZpepzIpCPPVxy1gCNt38SDWVoXdhedO1iTF+Dnw6w9HPOYxmxnR9ezb+RASB4egP/39XHMv3cVqHgDc+qn2fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dg7qnGWqYcfGB4K778L7/rd3o+DSNONsoBxzoHeq1iU=;
 b=A9U0JPFe4o9URpWBaQwSF6bRAPKQY/EfME1S5KEkm9VGQjZyeXes3OZqgBVZFbq1rYizczWZleiF5kVKwfIv9VV1hgRxV+a7wBInkj6KKjJpQrS9tsRPHMz+Mx2ZGQo80Fv81sxyxFQXIZEfKu82igP12Sfy/x6ALQqUuKx7ufd3vJi9zyi91WLtD15GYfv2n4YD6OoJTN4o4qqcrrtKbG9Y+ftAsaEFuIa6bjx1Wppry4K5c9G3fxB1ZNOAnyR46u9MwuDNIVwSwdO6SjLgIoHc2Vu8PnWm+mQFz6p5yU5tWMQ8/B0LIowDw2T4xl4vMtO2k3ecDkDkNl3mAr/aBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dg7qnGWqYcfGB4K778L7/rd3o+DSNONsoBxzoHeq1iU=;
 b=eMTRlbQyFKR6oL76SOJJyLeeQ83S1mjTlP+lX7grAQNdGRXEzD467lrfKlo5nCOWL2LCWDAj2L8Fk4uLuIQw2ctgPrJs08wPtlnvZDGLPrcY1Js0TS2r1wjlPbZZdWc7nTQUIjIbzjQudsh6fU45qE7E1N0VRF8/+j8YSb2tA10=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB3935.namprd10.prod.outlook.com (2603:10b6:208:1bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 17:05:58 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329%5]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 17:05:58 +0000
Message-ID: <0a37429c-05ed-74a2-81c6-7e187d0adc12@oracle.com>
Date:   Thu, 4 Nov 2021 13:05:52 -0400
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
 <18c12ead-ddf1-9231-7f3b-aafddd349dcf@oracle.com>
 <2f3addff-fbe0-8ef0-6407-e879c0e9827f@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <2f3addff-fbe0-8ef0-6407-e879c0e9827f@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0120.namprd04.prod.outlook.com
 (2603:10b6:806:122::35) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.104.20] (138.3.200.20) by SN7PR04CA0120.namprd04.prod.outlook.com (2603:10b6:806:122::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 17:05:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8b8cb64-42f6-4360-c699-08d99fb55efa
X-MS-TrafficTypeDiagnostic: MN2PR10MB3935:
X-Microsoft-Antispam-PRVS: <MN2PR10MB3935E9F57F3E73A31D266DF68A8D9@MN2PR10MB3935.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dlBbCOgWkAOzYJn7w9mJlRZauEN4T1CKWKyJejTT1J5zc7LrH0Avvp2J+yr9mbm5/jxKLDxNozcUE5dRcoCYOjVrnc2Ha7o5BoMLHiolZzMTNNbqro2gHbKvI/uIpe045JPhUiIVpki/Begrwfcvrsqtr3fy64HgF3lON1A5t+m12kUR6lNMKAu0nAY0Y8zt0L6sjaO3HjNf0Zn9ugbCoiZghGaX7bnuL7ggGuFQgzULHL28dU7jTRBbU5wVL2/tw4kM3Nv4LiWaXqAe47HWEVnWcEdB2h2R22PiXEYI/XvXnTliCOdlgabKiQ6afdomMQ1UIfh6dBbzhaSxTfbJuug3DaPRUsG0VHqD54X9oznMHOoEmVf+w32NslyN4LE07IF3R127kFNoE3Zeszd2HIh5zPFbj+4qEZI2wEZMuR2lXtASWL2gQZTlpqYS7W/A1l9UeifYpd7NPyO1nEDcchdHkmKziC2BfjYaB57G8+yq5hbfJSWcHR8fAH6YI1prU2xm5N35Ww8b35qNv33TPRnu7rGyhGSJ8yovdY0bmWvj0A0H1OyqT70cmMT+nYK1eQTEj+2vLZlPXjht+qtTuZenQ91AF/yjzZHlCdneyOr5CoKPtrtV6/t+oIpKwnrc0fOjBUYG/XWKE5LJafA/DzOLhEJi/iMYMgkKhoRq/Vf7YBODje0+jCK/AIxWrw2CGRBKg4jSE0ijLqxs5maQMYW6BcAmbq+VI02Rx/m+s6Uoe8t6Wjm0X8YFaWq1uQbC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(86362001)(31696002)(558084003)(26005)(6486002)(16576012)(2616005)(4326008)(54906003)(83380400001)(36756003)(66946007)(38100700002)(6666004)(44832011)(8676002)(66556008)(66476007)(508600001)(31686004)(186003)(8936002)(956004)(316002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnFoLzBsc1JwSDErSlQzRU9aUllna2crMzJjOEdhNzVxOUp6TjVmRk1ZRFVK?=
 =?utf-8?B?NVdNVzlLY2E1aDJqaFhnK1hoMlhyOHQycCtvSTd2a3VnNmVldE1uSFlSd2ZT?=
 =?utf-8?B?aTVWcFdsczEvTWlkYjkzZjNBYXdFald4Zy9uR3ZVc2d6MEE4NVZiU3huQzNS?=
 =?utf-8?B?UTdRN3Q3Q2dJaGRsb2IvVHFMMTRmRFl5UU5uR0NEMHQwbTNwVjRhRzErM3d1?=
 =?utf-8?B?cDBZOU5md3FCQWgwRkFUVXBpTzgxKzRuYXZwcHVYTnRQSlVYWXd3TUxTby9L?=
 =?utf-8?B?bmE4NGtGemt3UDZadTlyQnRwLzEwN2xhU2pZVXJzVG1lTzlyNTV0ZzFRclE2?=
 =?utf-8?B?Y1I4bncwVEplMloreWpOOE9GbzkzREFsV0RYWDREUHZWcmk1aHloQmZ5L3Yw?=
 =?utf-8?B?YjNsdnIzTGFTd0cwM1lRQk1KTTkraEpIVjNtYzFXVVkzWEhZL3EzbFl3dzNp?=
 =?utf-8?B?SnVDc3J3NXdHaXFacFVtdGl2bks1bmtEMXdnU3IxYXVOOWkxenN0bUFLQmpM?=
 =?utf-8?B?VjYzTkpyTm04QjhxY1RyLzdiQk1FVUhWbHROc0VMeWdIb25MZUZNV0JBWStm?=
 =?utf-8?B?RWpTNm9CUThmTFN0dVJWWmUvTW82aCs2L3cvOFQwTHJTVjlVb05vZnVtOEhw?=
 =?utf-8?B?THNLWE0vYUdBY1E5UXhkcURTT3FKdEFOMGhKOXVmMzhlSEl3UEQ0VUx4UC9H?=
 =?utf-8?B?eTlhUHVZdHdONTFHZElvUFZPRGV4WnN5Y2g4Nk5ra1lzT01RUEdwZUNnSFBY?=
 =?utf-8?B?MFNoWTBTYWJtaG4raEdWWkVDaXVIeHlKbExsYlNvUm9USTJlMm4vUXdQNFQ3?=
 =?utf-8?B?d3lCNUFwazcvMEZUbmZOS1A5YndGQkRaTVYzVkxGV21Id3Q0L3ArdFVOOG10?=
 =?utf-8?B?b0RwaDZoT1NJc29qblZJdkgzSTJ4TFQ5aERnaXovUlMxT09iZ2pBOHgzR3Bv?=
 =?utf-8?B?amIwd0hWdXJjYm80MndDdlRpT0tMT0NNWStNdUdNNW1mcEh1OHJJQytnY0gy?=
 =?utf-8?B?VXdqbnpvRHBkYlVTMkp3c0REZDZXQy9ONTFGdlUwc1JCYitac0IvSlc5bEEw?=
 =?utf-8?B?ZHY3Z094bldRYk83cGxZTHlUZXBjWVYyMlB1YzVnUUtRQmdTU3NlYWFVSnh5?=
 =?utf-8?B?c0dRSitzWjBaN0tJRVJudks0QzNRZDFoMlpkSDQxZW94dHlYUE1YcCtMbjNM?=
 =?utf-8?B?bG44MnBDOGEwSnAyN0lsK0huMlROdVpKMVJ1YUJpWjJDMThmSktNeDVIM3FW?=
 =?utf-8?B?YkdHZzRkejlHcEVNSm91TXNUalhJY2M3WHJuVWFwNDFqeTZmNXhaZkpZQlA4?=
 =?utf-8?B?a1N0VmFrSW80SUNzK1MzNS9vUkN6WnMxVjVUd2hQV0NDZGZPaEEyQXJPeFRW?=
 =?utf-8?B?YjVBOHlMOFR5bWdBM1ZLYk56SFJOMlE1a3U1dkUxMlIwY1JDWGx4M1NGUzdk?=
 =?utf-8?B?S1VjYVduTm5OWjVYeks5TEs5R2UyWTVZNkFsd3d5VTJKUEFrTE8xVnRpV3d4?=
 =?utf-8?B?bnBWWUpjSDlmQ1V6S1JkRm9vSnpwY3F0cmVjYTNrL0xlV2N0S3ZaSldic3Fh?=
 =?utf-8?B?WGJ6NDhJb2JFR0Z5OUFUeGJzOXhnV2dPWDlQb2dDdURBRzdQR3VHZmZZdmFG?=
 =?utf-8?B?blB5TTlBM2hkZVZaZDNFaDdoL1BZR0VwVzVsTzhXb3FaSUhiclpKcksxQXNW?=
 =?utf-8?B?MjdIMFJoMmcyN0tJS2VOVjE1SWduY2NleU9CSzJoSU1xNTF5b2s0eWQ3YkJh?=
 =?utf-8?B?bWRYTHlCOFkzTDExTk5FSTRpbFRmb1BWZkhyWUVhNy85N1ZudGtMcUZqVk1N?=
 =?utf-8?B?L3hRck82eWJJYXZ4TFRsYmJZelBXbnozUXN3WVU2RDJ5bllJT21TczFzZkRq?=
 =?utf-8?B?NFViMVg4OFRaWE1ZNHNQUWpyemlQQzgraDZEM0lFdkFDU3hteXdGZjV2eERo?=
 =?utf-8?B?SzZKdFVYUHJWWndVWVBIeGVuU2NUcXJ5UTJuVUdMcXRLRVdDVkdPT3d4MVB6?=
 =?utf-8?B?Z1NwamZYaWU2Q1pJZXdFdXNHc1NEWEtiaERmWGxqT2RrOWNSUFVZMUFQNUJX?=
 =?utf-8?B?UzhFSDBncjJGU2ljNllhTVlYSUpWMXE4SWhadVVCeDBhNjIrOUlQd0k3bXFQ?=
 =?utf-8?B?cWxmdWxRVlZ3cWlRZnptc2NBbG5mY015bFRxNmVPZDVLTmwwWlBxVzZEcVVn?=
 =?utf-8?B?ek5jbnlxRzJFQWdrWjcvTWdXUWt0RlZWa1NodjJhVUh4aFdlaWU5dzFuVUdO?=
 =?utf-8?Q?ySGlYrM9xV1tSAQFX1U/caGl0PaGMYvMaDCpSrJioY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b8cb64-42f6-4360-c699-08d99fb55efa
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 17:05:58.2280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HpWphvP1ymcJw6q7pq70bCCYidKUoH/bKLpgNojlpsMgq4RHk/57eHFdwp+wGF65rpL000nzZXff/h+cVFMtPCzspHgMKG6qtri9leN3BME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3935
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040064
X-Proofpoint-GUID: eMqr_Z7NuTGNfxv0icKfOtEOybzoGgFl
X-Proofpoint-ORIG-GUID: eMqr_Z7NuTGNfxv0icKfOtEOybzoGgFl
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



>
>>> And if so, would you mind doing this while committing (I have one day
>>> off tomorrow)?
>>
>>
>> Yes, of course.
>
> Thanks.


So I'll change this to pr_notice, even though it's not the best solution.


-boris

