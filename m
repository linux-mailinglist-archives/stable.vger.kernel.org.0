Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB7B48E4E0
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 08:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239467AbiANH3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 02:29:49 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60324 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239331AbiANH3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 02:29:49 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20E1OvTH005398;
        Fri, 14 Jan 2022 07:29:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 to : cc : from : subject : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=DHvwx8lq/jQO+xFwwUuUOqJ2d8deyYZv6ugcB8uqdpc=;
 b=CvUQhV4UaQwiqd1nRWhdYbKgo51eOS3VxodBKnQCFzqcyI4nugAyp/KNfrLHRvhUlWON
 Hosj2AQzesvWEhRGHyhtvoRRxNpYQjBpywYeYlOOiayq1VFKGw2ajPgPkbLGIhbSUQRa
 IeyJ0KTclbpjceZazV4J6JJAIt9AjbUFL9+FmJViDpcjI9UQX20f20lIehmFa08TbpxU
 cnqIAhC5gocdb/cIfdQp4g7aeOSasoRP6qpBNOd5O7BRQnbVn4Jyul4KSLESqKVChcas
 SrBep9xPV068Y0ZAkaT8ltjxWbrf+c/WgLrbOSXO2VsPbWeT03ZnVvvYDfy06hTz/Y5E 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3djgv6bg4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 07:29:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20E7G7S0027757;
        Fri, 14 Jan 2022 07:29:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 3df2e91d27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 07:29:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQg6rFu/el0RTfgvfK+zpIedDioqpj//FRjcyho2Mu7FWEm41+mBTOkLVy2nMZ9Uf3Ktom9Zk08rfebK08XYQfLdbf2A7t+9qyGxEY3HNqDdfEcX0XsRvjmobpJduVJ9G+mFgm3uf1Im5wzuU54W6pcddvHN4nBKNb2hS7Nczl3QW9vRssPshQDD3ehqIqsMAmIMbq7xtUv25v0YdxZ/5X+0Wcm4pZMwAlmazz+JPtmP9YrX2pVQvNWGNHRgu4TmKgXC+BbG+7AI1XQ8GB9ywu60N8u6pVtg+/qJdOHcrCzRt6ifUkPY+PQVLZl2lyu/7HjPE8w6LkcOIKO3uoFH1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DHvwx8lq/jQO+xFwwUuUOqJ2d8deyYZv6ugcB8uqdpc=;
 b=ZyoCMMgV1vF6ldXa2lEqmhWGYzTVBJOIonYi5zgw5o/i27t7W9Dxq4rPhQjUD2wET67Y63wxW0fthQ/YY6odyc4Od7inYuPJ27rk8o6UaZKLs60oq/JEr2nd6CUWl9ORFAK1xucbNQ7wqKXALCnC5L6LVz3435DsY1KCPt8pa1s5vYUBhMPngYl41LtZU5MFkmW+upYhQPeRutmA7RVljzvSaZLKZmHpECkW2ay7gn8qmhao7IbWCrFLngVH8Eagw7DodGh9Tncz575UUCVjqhcB8fIyj3GgfrihRJCXIrG/CW9JHVTSp31Nx+2Mnlfrsl/088g8j9iJ6Sp6uiUy+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHvwx8lq/jQO+xFwwUuUOqJ2d8deyYZv6ugcB8uqdpc=;
 b=modST8qqsvWKrRl8A9EGe8fTCcgN6GTr+3q3/KSBY+7xf35FSqRjyOXCv7LMo6/6IYASt3LaiivhyoN+AOlIB8k+QUPIk69JV5xIS4UilkyUbKG+WdipFqhzk0x6kVlBrGKggx5bj9ORtbt0/N9PZOFLeDgYQb3NK8ITwZ+Q1vI=
Received: from PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22)
 by DM5PR10MB1596.namprd10.prod.outlook.com (2603:10b6:3:14::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Fri, 14 Jan
 2022 07:29:42 +0000
Received: from PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::b815:57ec:4994:e5cb]) by PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::b815:57ec:4994:e5cb%9]) with mapi id 15.20.4888.011; Fri, 14 Jan 2022
 07:29:41 +0000
Message-ID: <6017b3e5-8ce2-1312-7f0b-b0d7991ee87e@oracle.com>
Date:   Fri, 14 Jan 2022 09:29:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: ro
To:     ardb@kernel.org
Cc:     stable@vger.kernel.org, benh@kernel.crashing.org,
        Karl Heubaum <karl.heubaum@oracle.com>
From:   Mihai Carabas <mihai.carabas@oracle.com>
Subject: efi/libstub: arm64: Double check image alignment at entry - checked
 against EFI_KIMG_ALIGN or SEGMENT_ALIGN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0296.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::31) To PH0PR10MB5894.namprd10.prod.outlook.com
 (2603:10b6:510:14b::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c853a2ca-dcdd-4833-9c44-08d9d72fa11e
X-MS-TrafficTypeDiagnostic: DM5PR10MB1596:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1596490C0CAA33C42A695BEA88549@DM5PR10MB1596.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OXGICtTRbQ0C9prTDAuOvR4LT+Uet9zENA2wffG6AOqZ5wZuod0lUcFtM8Xo4ECjnT/AtekWvi0HQEJjJs/uFh/qPc7tCIFaIfihU7qEHyEZyEOkaY9bN4SEa+Vmtwk1nA7JgHeONT4qZwhjqqLF3Hw9kEShrRFZ2GTH/cM2fBwfAepRtB9IQpzm8IQ8Pod3W5XDgOSgwO62F1oXTdl0yPSTAt/ISTmTqXw0G1m7bLZEPjBrgrfiNjd5tB9VDIDwJDXatfFd1GSKkukkE9RxhgRn3i5RQoXTF0yuQ0hazEDqyiOlsdcuODQhNfQ8yycNqdBSYyTXWoH6o4JDxTkkjAttOInQduSTwjjeiCWHvykXrgLstrnbb1r6F/yq6fZ/hjxfsxuHrbU7EyGGS3SDhTHlzYvzJqKMH4W+N6kSoAIWcUdLDThWkcm3UCoQHT4s2NBxiPpjZ8nL007rG5d0s6Fi2B6ZiHWwORkv+ru3vwV0oBJJu794dueBME/J+Lkq6FfuoeuMXeFyddAxRRUWrp/2EmqNhwMdbSGrxy26pDrbXPbA5plzb3scd27IatZhXbyc8AHITXCEpzbAIfaCT+8JUGqq5Ns9gckf/szkUfd4OKZXJB3DiKibFRFCWdO9h4GsEO2JM/XGS6VhRP/qif3EHreoF7uO7i1zr/nVMmPclGgwqS6tCD2QtHHNv65Sq4lXu+CT6CwWtpkkr+8GzdzmagA61DMnFNXMJY6rHOQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5894.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(4326008)(107886003)(38100700002)(83380400001)(86362001)(6506007)(44832011)(316002)(2906002)(26005)(36756003)(186003)(31696002)(6512007)(6916009)(8936002)(2616005)(66556008)(66476007)(66946007)(508600001)(4744005)(8676002)(5660300002)(31686004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2lZMXdIUWdTNVo3SFJrbEpDN24wMEs2eXJxNjVYczd1bEdEYWN1VGg3WEgr?=
 =?utf-8?B?MkJiMG9GVTJUNWZIVjYreVo4L1pjMGNEakcwRFI1OUxWTk9XVmpuMGdkSmhZ?=
 =?utf-8?B?YlNYSWtuQkxpbDgwUmtEeFMwRnhvTU1qeVpGeUNGWHZuYTdhSXRWZ1hTTzgx?=
 =?utf-8?B?aXVYWXh5c3ludjJUVXZvWENocDhRRFZRT1IwQjBrdzY1dWw4eE8vOCs1RnZC?=
 =?utf-8?B?bkRoTzdpc1NxR291OUNBUDVtaG5sdzg2WTgxaEM1NmZLZkJYTzE2djZZMWlT?=
 =?utf-8?B?anRNc2ZIbHg3aXkvV1hKNFRXWUFiSjlLNW9icHB0NC9wRm9lZi9pbDRxeU1v?=
 =?utf-8?B?ZVcweDh3eWNsbHdaOEhHUTZTU2cwZGErd2ZiVEtpMDVhVDZMN0ljamRnOGM2?=
 =?utf-8?B?RDNhK2labktQT1VsTlhPNmYvZFY5UVRmRTljK3Rtb1N3K1pHTHROQzRJbFVj?=
 =?utf-8?B?aFd4S0dDV0hrU0hxV3FQRlBpdlZKQlp2V2lCR1JvRURiNmxobnF0YnZ5Z3Fh?=
 =?utf-8?B?SVlKTDl2WTNtRkV5alFvTkdEeVpLNW04d09PYlpwdXdyNE55UkVYWGsxRWJz?=
 =?utf-8?B?aUU0M3BGSTg4YXYyYTE3enhHMzlaOGlwQnNPbk5jWTB2b3YwT05Vb0JEK0pt?=
 =?utf-8?B?VGhCeUU5MXh1clNUOCs2UE92NlphZkt6VSt6N0VpaDVYcE9iZVl1M2RGN0N6?=
 =?utf-8?B?UU1UM2Exc3hrblJyaDA3OHVmZ09la29vekN6Vi9OeHZSUnRHelBGQVZrWU12?=
 =?utf-8?B?d0NQenZwRFFLRXNmYUVDMDBVeGRBZVRTY0t5UUJQazlaenBEb0JPbi9xNHhq?=
 =?utf-8?B?RjlLT1ZzcitKWEtaQUc1R3V5VUxkUzNLVzJiMUZSSWFrWFFmaWNvakNSbHdP?=
 =?utf-8?B?a1h0MDVYQlNaQ2kvYzNocC8yeElZS2VPMnN5VWd3U0RuS2JjZDlURFJta0hC?=
 =?utf-8?B?dW5nYUl2a2RuWkczVDBxWlIzMklxWnkyRU90RU1CMys1bHdDVnZXREZhZkRz?=
 =?utf-8?B?ckRrZVpyMEU0U0dydW41RXI2b1d6MTdiMUE2VC81WFIzMjZoSFpUaUhZQVBN?=
 =?utf-8?B?QlNDNHJjdFFoQXM1Si9JbHN5WGdkeTM2cklFWW1MN1cwUkRBSTBpckFPZnY3?=
 =?utf-8?B?eUlQbDFBRHpjUXZjbjRsOHp2TFF5bEEvUENIMUtJQ3QvUE9KZFZmMW4rdmVn?=
 =?utf-8?B?aVIzVFc3RUdSaThTSUEvRThOaVVDMm9rdkpSdTVMTDRJOVlPcFI0K0pEYVAz?=
 =?utf-8?B?SmJENytQWWM2ZGNzSTliN2o3ODJUZjllZVVueHU2blU0QzUwK1l6TDBXSUNL?=
 =?utf-8?B?WVBLWVZacnY0TG8ramVJYmU3alFxY1g2ak1FSUtFWUlycjZtQjErWXpNZHFo?=
 =?utf-8?B?d2t1UUY1QnA2ODhGOHgxSlgrY1RoK0RsQkZtZFR2MklXeUsydjNUS1F1c1FG?=
 =?utf-8?B?MVFaNWNoUUtMaTN2RkY2VGVJL2ZBUjFKY3RUV2VKcjJkNlF4VjZhMm5aMmFI?=
 =?utf-8?B?NGtqUllESnZJVE03TWJ5RDBMZGxtUFRWRFd0WGVKMmVRQ2dsUVc0d3NsZVJt?=
 =?utf-8?B?R0hhOVd4NkdMcFdFdUJpdjE5WG9NbDBWQ00vL0JNZmE2dlpUbmwrZ2NMbnQ5?=
 =?utf-8?B?dmZiZnpTeUIvSDA4UXVhdDA0T3JwbDBDaW9XYTdZVjRKSm5CT1U3REFkVDNw?=
 =?utf-8?B?ZzFJNlZ0dWEwamVIbFZIMjJHcnFnNlFhSUN1TXlhUGQ1MWhCUFRzbUlaWXB5?=
 =?utf-8?B?cGkvKzNKRW1GNTdVVkY4MUFmaWxuU1F3SWtIV3FnZ25wQlZQWi93blJ5TWRT?=
 =?utf-8?B?UmlidzdXa0Z3V08ycVpWZ0hrajBzOTRwTy9uZ3h4WVd0d1RnQTNFUVZZakJa?=
 =?utf-8?B?dWE4bTNCRlNJL3F1anpZRlFJcmtTcGI5ZmtzTmRYU2laZnhBYWZVQTNZS2pP?=
 =?utf-8?B?K3NvRjNoWE5GRS9CWm9MUEE5aGduQ2ZNa0djSXVVQytCRElZWXhOUjcxTnNU?=
 =?utf-8?B?c3VIdWJHOGRhQjdUSDBQWFViNDFRRUJ4MXJHS0tzMDBYUFZXdSt4RWtpUDRt?=
 =?utf-8?B?Wk1SekFBc1paODR2aGRsTThGK0h1ck91Y2MzalJFK0hvcjdNMDRMTU1zTWNp?=
 =?utf-8?B?bm1hRXE0WEFGMkVXVEs0ZE45TnZmS1lmcERlLzJGMW1TZURLblFmak1mRDEw?=
 =?utf-8?B?Y0llOHFmQlNCVEVXKzhkMkg5MEQxM3Z6TUxWRUkrdmxuSDZ6WUQ4VHBzU016?=
 =?utf-8?B?YlExNkM5SFhDV3pnWmpPTVRjU2JBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c853a2ca-dcdd-4833-9c44-08d9d72fa11e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5894.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2022 07:29:41.7301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUF1/N0HIaiHGVTHpGETXanrORTpWXjHKkasRXkPentcyvNcGRjb2AxQoID8xRpu70ziH6W4OgC0fTqWfs5Cztu/s9BXIbV6PsttpkTb/+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1596
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10226 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=980 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201140051
X-Proofpoint-ORIG-GUID: bI6XCmKn6sFCIQeIWvZmD3e1FKXJyTqd
X-Proofpoint-GUID: bI6XCmKn6sFCIQeIWvZmD3e1FKXJyTqd
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Ard,

In patch 'efi/libstub: arm64: Double check image alignment at entry'
(c32ac11da3f83bb42b986702a9b92f0a14ed4182) you added the following check:

if (!IS_ALIGNED((u64)_text, EFI_KIMG_ALIGN))
     efi_err("FIRMWARE BUG: kernel image not aligned on %ldk boundary\n", +
EFI_KIMG_ALIGN >> 10);

Unfortunatelly the kernel is aligned at SEGMENT_SIZE and this is the size
populated in the PE headers:

arch/arm64/kernel/efi-header.S: .long   SEGMENT_ALIGN
// SectionAlignment

EFI_KIMG_ALIGN is defined as: (SEGMENT_ALIGN > THREAD_ALIGN ? SEGMENT_ALIGN
: THREAD_ALIGN)

So it depends on THREAD_ALIGN. On newer builds these message started to
appear even though the loader (Grub) is taking into account the PE header
(which is stating 64K).

Did you want to also modify the alignment in the headers/linkers or may be
check against SEGMENT_ALIGN?

Thank you,
Mihai


