Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6123EB40A
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 12:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240128AbhHMKap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 06:30:45 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49730 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239277AbhHMKao (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 06:30:44 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DABgpn005976;
        Fri, 13 Aug 2021 10:30:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=v2iMJQm6OTPX+nCjbKMs9D2EyOZ5TIsES/TLwMaKb4I=;
 b=uQdaSCGhSLX97SBl7Whe8F3AfPcXCQ0llvZ+LOSFbdDbNIVmKLjoCxuf8hQ853Jusk7O
 VhHOwTeLThXXLqb4xXtTEisI5db/OMO/N/lWXUmZX8jEwadGAcArsw4ko7qsGyhKaaWF
 DltsoKeaYJ9Dk/H2wNPcvJranVZE5OqHCkOsLH6ghBKJ4JYoD8CCcf8hqGapnF1atz20
 TRI/MswUSiTheYNVKa+xxYXBiMElf0qwzO7OyAU4VcFYCrK9L1O9EF3zRkQ1LTDlQqTG
 XQGyDjsQIoRSnxYRXUhTnGPxvru/HRCn/8PVP8+JU3oSDhVC1HXJgovIJ0o3UVlIy+hb 3g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=v2iMJQm6OTPX+nCjbKMs9D2EyOZ5TIsES/TLwMaKb4I=;
 b=XSVUVZTBxLu84xDPHvht9GuS5SPAR2vWKeaCje3oTsbCgRlw8gMQcd32WTbIW7s6PKcp
 Ei4k6ZvYqUxln8AXd4Yf7sfFmFZiBFjKfPuJHG+D4KguUxrXVe0xc7zpHs/InVj8swPz
 llsYaF8Jgo214WQRSPI7j3ltGaQRPB5ek1ZjghPLJtPDHqJf4ECWFA/T8vrmwC1ZN26e
 KT/O8tGk5h+DSDv2OKDWaaEMpV3uJi9DQDpAZ8vTwiSifwCKMuQTEOuS4LBZfBJhXjRL
 3GQD3XfOchEzzZsIkrfHmnvXZ4f/2xKAbvmNkp2SfNKhAiPsxUFA57NawtoVsj3LPydJ mA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aceudw1mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 10:30:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DAChQc097814;
        Fri, 13 Aug 2021 10:30:11 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by aserp3020.oracle.com with ESMTP id 3accrdt1mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 10:30:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOOSeFAV8jjI9Kzyly4shSmlKDa2cKA9RHfpj/hsMk9XWs4cIabwNfC+dniWZBwaO8NxQY7wzX9VxjonU29sCJtAQqLv7ah1TLRLI7qW4U6ytS9kf99qEbcdEA+uMUuuLso5nhQdnlSp6SUY0WaX3fhjqv3Ui2d2/pddCLeXaa3Q+F14e8nKfyh2wMS9d9rLVosRCY3hlhWgkzKm+kbkxPWe8wrWqE+cWeZI/MzyJ8nK5I58NvkZaZVkAnvmR7ZwQTe6NLsFRf3np9+oHR6ek0LbnGw1M85qeaBYshhff0AZozWLc78JA+0OigzijiZXNpUjF4P9oUrdGsD6To8S5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2iMJQm6OTPX+nCjbKMs9D2EyOZ5TIsES/TLwMaKb4I=;
 b=I+gWIlKbkXae9JzC89cGs7wuIAPiM9Jxt00+h8hk8cjs+mLJ97Q1TUDLB+0A5AcyPfEgFgw8CkQe+sN9fScTMaYodeyFTTaX4F9wcS3ZEWTiesWHuaSWMe0v2ucCumI1ZjPrfEUsIBzuTOOZCvj4BYBFaEeztf8RGhoRlHlQd9BhJKj4ZAseFQeqviayEscKBD+YNlu+oJN4wwVWRuht8IKgDtnRV/xPYw2JHQ7NMBrRnYx8diXci5UkGMkZ8x+cdtc25EsVm/MbfFU49HR7XQCIV+9vifk+ioepQc7FNZ7ZWtv0tjTDSu7Dauh0V6j0kNd3du7/p/ZcFsp3RhSclg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2iMJQm6OTPX+nCjbKMs9D2EyOZ5TIsES/TLwMaKb4I=;
 b=t+3JnfWK0AIVKsPQ10WkXcWpmVVEYxNnsOL81Cxx8Ps1xwIEucX7K6ZZOEsNrQmgvsD4+Q4GT98PvALPW8vWrT1Lu6X0rEIvRDoiAsP83dx3hM+DCSyIzBx5y1A46bc39UeRgnhqv36+XVMZOiVc2LZA23BNI1aW5daKWXVDPxU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB3854.namprd10.prod.outlook.com (2603:10b6:208:1b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Fri, 13 Aug
 2021 10:30:09 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 10:30:09 +0000
Subject: Re: [PATCH 4/7] btrfs: qgroup: try to flush qgroup space when we get
 -EDQUOT
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
References: <cover.1628845854.git.anand.jain@oracle.com>
 <740e4978ebebfc08491db3f52264f7b5ba60ed96.1628845854.git.anand.jain@oracle.com>
 <0711671b-b08c-ee78-7271-b756dd1b579e@gmx.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <b49529b9-3f1c-be5f-f95a-dadceae057ec@oracle.com>
Date:   Fri, 13 Aug 2021 18:30:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <0711671b-b08c-ee78-7271-b756dd1b579e@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0159.apcprd03.prod.outlook.com
 (2603:1096:4:c9::14) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.109] (39.109.186.25) by SG2PR03CA0159.apcprd03.prod.outlook.com (2603:1096:4:c9::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Fri, 13 Aug 2021 10:30:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ef7f2cb-5847-4ee0-8225-08d95e455367
X-MS-TrafficTypeDiagnostic: MN2PR10MB3854:
X-Microsoft-Antispam-PRVS: <MN2PR10MB3854B8C6AEADB0CA277E2A49E5FA9@MN2PR10MB3854.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QL8jJwzzZZ43Q2gYnQlW2C9prl6rJfLonNPfqdpcdh4KhTJUk5Envq3irhMYIyDynCp3Y7Oe2AJHvUtAGGpgz00b0Seps+E0nLO7HDcU2sq/8nGMi/IZW6znxfoUPqVv/K9Qu2bRfPk0DnyurHMRxduMYsUcMW5cSP8VDSqLhrXz6MH25YWU5Z2tkiTXR165KawlpGEpPE0gq9USczmRWhT1pux96SbMAnhXsNoyqbkbvvMqtCyOCfNFB9LsWWwzSQpD58ATsFWIFevTCyvHlSiAbfEUaC7b/79CnGc3jkrYIvIyEf5WJQTHZyjK23OrUBMGNZIuUD9mTBoBk4a7EC0d+28s7zz94QUSawMk8VLAEuIAAEmhA7CK89MBBSPXkV3JbvNoS85zBnZVahTgwrBa3UgltkQ2byWkVWId3HBejk6f9yfaPi8LF6b1tQlXQhncV9wFb7u2RcHV+6tcLh14w1bzA6tm5BwVgbbY02ggMBA75jLqSSA6SBhtOzpWQnayIw8w0C/53k+l8DCOuL6AegRG0yPDnVoZqoqh36KvCMq+zpuM97BuAcwQPATsWetzOZibAT8FlRJTe9CAnMqnHhevQinQJH5LQn0Ox8xqPu78dUHzzg/rUIzitlGZ/W6CDbsriQgvsaAh+PSU5CTQthijHUeczdl0DoclCNDBN7MbcpsqAYqJHYqynD8OVbQn0sm5lm7acqGXxFcedJatrbD9u2O/GrYHH+FGLKE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(366004)(39860400002)(6486002)(36756003)(44832011)(26005)(66476007)(66556008)(66946007)(38100700002)(31686004)(4001150100001)(4326008)(2906002)(186003)(8676002)(31696002)(54906003)(478600001)(956004)(83380400001)(2616005)(5660300002)(8936002)(316002)(16576012)(53546011)(6666004)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWdwQitnMjA4UHNkQlpvc2RPeEIrRXBIQmNERWwzWGJYd2ExRUhEWWsvcjNO?=
 =?utf-8?B?SlF4R1drYStzdXE0QkpmRlNLb1U5MEdKbjF2MzhoQ0xiVkZmMHN6NFNhVVUv?=
 =?utf-8?B?TFJUQ3Z5cUFQNFdCcnBuT29FT0djbzFUS1pRRDF5N2N5QnduUUdadU1KR2ts?=
 =?utf-8?B?OFNYRU9vajZ6ZU9jaEZvMUp3b1NHRHRHZDR6aWhHUitNS0ZHTVRyR3Vkd0JU?=
 =?utf-8?B?emVaSE5IN3FhQk1PVjhxVi9KRmwvVlZadkxMZHZuekFuc3Y1c1RyK2dURkpT?=
 =?utf-8?B?RnZtU2gzQ1d3LzVSQlVLYnZQcEx4V1FFRUNXY0VzTVZxbFlBWnFwVlNRVXgx?=
 =?utf-8?B?N1ZlcGV6RnVkMlJ1b3luOVlRMytmQ09LQitSRW1BaDRDRjBaeXBrOGl4cWwz?=
 =?utf-8?B?ZjYxanZ1cVlpV0szcE1XeWJ6QTkrWk9KdCtQbE9QMTNjMFdyVVViVXpQVGtz?=
 =?utf-8?B?SVg0RkFvQkcxT050VFVKcWhadXdNS2JoNmdEU1h5Z1gwcVlaaENsNGxtT2VL?=
 =?utf-8?B?QUtFMEFOd01iZjJlcDYvVG00dmtUM1hRNHJnT2I4dExoaWg1bEJSaUdITkZ0?=
 =?utf-8?B?SDVMWHVvVkRHN2UxK1R1UWJMbHdSRmozK0hNSW05aldMOHJlcHFkbWEvakRZ?=
 =?utf-8?B?VHlDQTRhN2ptQUZDcmIwQ0JUU1VLZEJhOXFXR1pneUttamNiU0ZQNng3eE02?=
 =?utf-8?B?YUVFUmRYaFlqUXRjejJ5TmdKWHZ1REV5cnhmMjEvNHI3a0RoOExtV25OU2p5?=
 =?utf-8?B?RFA5YlpwZnNCQ3Znd2Y1VWorRmtuSUFPZ1NidGM5ZnBVY0ZUUzdxbFY2WGtp?=
 =?utf-8?B?UlAzVUlzT255ZXhoMm1BVDYwM3RnUVZmWnZhMzgreGtpVjBCL2dDeXBtd0NQ?=
 =?utf-8?B?bzY5SjFyUXR6SFdBRjdNVjk0cU9jaWcwVHc0SDNLZExycHdaTFdQOTVwNTB3?=
 =?utf-8?B?OUx0c0VaUU5rcFpiRXE1ckt0d0V2UEFYR0VZRHVZMnhYZFRoU0NucFRaNHVa?=
 =?utf-8?B?ZTNua3JlZG1Gd0t0YS9rbGRhcnVsZ3BXb1ZRUE5iZnR2N01jb21pemR6aFcw?=
 =?utf-8?B?WFJuMHBnZFFQSWJ4cVlleTEwbWVxWi9ZMkRtbURLc0lPaVJncUhmWFRvUzd1?=
 =?utf-8?B?UFNaVE1xb0Zkbk1zUndEbVRWSEIrM3lreEc2WGJMWXVRSmJJZmx3V3lXZmZq?=
 =?utf-8?B?MkMxU2VVa3hkR1lLNE5sMFIxcVBUenA2VWYrYnNWUERjVTlsMXIwaGQ3OGVI?=
 =?utf-8?B?dnoxaWpnQ3lWZVFRMVlUbXFMaTlVVmZCVStBWW9iMTB6cUFhQ25va3lldVVT?=
 =?utf-8?B?aVZteVNwUTFVWkw2Z2IyTFJIbVVQeHI5enpBK3ZqTWZmYS9kcUdTZE1ZZDA1?=
 =?utf-8?B?MXZZNjlhQkxTUUVROXdveTBXNzJsY3BqVTJKUWd5ZGRLV2pOZi9HRXRwS1Nk?=
 =?utf-8?B?VHFwTFVERWRRNHh1Sk1tUko0ZDZjWEJGbElmYW4rdzJzYnNlUmxBaWRPU1VM?=
 =?utf-8?B?NjhWMG9xSkJxUDlOVzFTaDBFb3p2Uzg0SVZsbkR5TkQrNm91NVhyRVVDZDRr?=
 =?utf-8?B?TjA1V2l3SnNUWlN4Q1djaGVVZ2lZU1RxZ0lCRVAzOHZtekVQVkd0cEVHdzF5?=
 =?utf-8?B?OGFRNjJjeHpXd3pjTTFqVHYwSXFvN3hhL09QT2o5TmNYWU81bCtlQkFYOWNk?=
 =?utf-8?B?SllLMlR2aVNEQ0tQR0RYSFRYc3pTTGsybUFCYmVPb2FzeTUya2ZGcHNuVHZD?=
 =?utf-8?Q?L45L4JcFuSCZQGW5ku+BCaFE9GUgKqAA7+gr5jG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef7f2cb-5847-4ee0-8225-08d95e455367
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 10:30:09.7779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LESMwyHARtXfBdtTKgO3QOyBz9iwQBVGjqgkr/9HflOBEz197hMILUq1HgK8+Yp7BNXdA+MDF6AWfd2m3BvyHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3854
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130062
X-Proofpoint-ORIG-GUID: 6u-rWcgNgOZ2ND2n1ARe-tdToZTLciEu
X-Proofpoint-GUID: 6u-rWcgNgOZ2ND2n1ARe-tdToZTLciEu
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 13/08/2021 18:26, Qu Wenruo wrote:
> 
> 
> On 2021/8/13 下午5:55, Anand Jain wrote:
>> From: Qu Wenruo <wqu@suse.com>
>>
>> commit c53e9653605dbf708f5be02902de51831be4b009 upstream
> 
> This lacks certain upstream fixes for it:
> 
> f9baa501b4fd6962257853d46ddffbc21f27e344 btrfs: fix deadlock when
> cloning inline extents and using qgroups
> 
> 4d14c5cde5c268a2bc26addecf09489cb953ef64 btrfs: don't flush from
> btrfs_delayed_inode_reserve_metadata
> 
> 6f23277a49e68f8a9355385c846939ad0b1261e7 btrfs: qgroup: don't commit
> transaction when we already hold the handle
> 
> All these fixes are to ensure we don't try to flush in context where we
> shouldn't.
> 
> Without them, it can hit various deadlock.
>

Qu,

    Thanks for taking a look. I will send it in v2.

-Anand


> Thanks,
> Qu
>>
>> [PROBLEM]
>> There are known problem related to how btrfs handles qgroup reserved
>> space.  One of the most obvious case is the the test case btrfs/153,
>> which do fallocate, then write into the preallocated range.
>>
>>    btrfs/153 1s ... - output mismatch (see 
>> xfstests-dev/results//btrfs/153.out.bad)
>>        --- tests/btrfs/153.out     2019-10-22 15:18:14.068965341 +0800
>>        +++ xfstests-dev/results//btrfs/153.out.bad      2020-07-01 
>> 20:24:40.730000089 +0800
>>        @@ -1,2 +1,5 @@
>>         QA output created by 153
>>        +pwrite: Disk quota exceeded
>>        +/mnt/scratch/testfile2: Disk quota exceeded
>>        +/mnt/scratch/testfile2: Disk quota exceeded
>>         Silence is golden
>>        ...
>>        (Run 'diff -u xfstests-dev/tests/btrfs/153.out 
>> xfstests-dev/results//btrfs/153.out.bad'  to see the entire diff)
>>
>> [CAUSE]
>> Since commit c6887cd11149 ("Btrfs: don't do nocow check unless we have 
>> to"),
>> we always reserve space no matter if it's COW or not.
>>
>> Such behavior change is mostly for performance, and reverting it is not
>> a good idea anyway.
>>
>> For preallcoated extent, we reserve qgroup data space for it already,
>> and since we also reserve data space for qgroup at buffered write time,
>> it needs twice the space for us to write into preallocated space.
>>
>> This leads to the -EDQUOT in buffered write routine.
>>
>> And we can't follow the same solution, unlike data/meta space check,
>> qgroup reserved space is shared between data/metadata.
>> The EDQUOT can happen at the metadata reservation, so doing NODATACOW
>> check after qgroup reservation failure is not a solution.
>>
>> [FIX]
>> To solve the problem, we don't return -EDQUOT directly, but every time
>> we got a -EDQUOT, we try to flush qgroup space:
>>
>> - Flush all inodes of the root
>>    NODATACOW writes will free the qgroup reserved at run_dealloc_range().
>>    However we don't have the infrastructure to only flush NODATACOW
>>    inodes, here we flush all inodes anyway.
>>
>> - Wait for ordered extents
>>    This would convert the preallocated metadata space into per-trans
>>    metadata, which can be freed in later transaction commit.
>>
>> - Commit transaction
>>    This will free all per-trans metadata space.
>>
>> Also we don't want to trigger flush multiple times, so here we introduce
>> a per-root wait list and a new root status, to ensure only one thread
>> starts the flushing.
>>
>> Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
>> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/ctree.h   |   3 ++
>>   fs/btrfs/disk-io.c |   1 +
>>   fs/btrfs/qgroup.c  | 100 +++++++++++++++++++++++++++++++++++++++++----
>>   3 files changed, 96 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 7960359dbc70..5448dc62e915 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -945,6 +945,8 @@ enum {
>>       BTRFS_ROOT_DEAD_TREE,
>>       /* The root has a log tree. Used only for subvolume roots. */
>>       BTRFS_ROOT_HAS_LOG_TREE,
>> +    /* Qgroup flushing is in progress */
>> +    BTRFS_ROOT_QGROUP_FLUSHING,
>>   };
>>
>>   /*
>> @@ -1097,6 +1099,7 @@ struct btrfs_root {
>>       spinlock_t qgroup_meta_rsv_lock;
>>       u64 qgroup_meta_rsv_pertrans;
>>       u64 qgroup_meta_rsv_prealloc;
>> +    wait_queue_head_t qgroup_flush_wait;
>>
>>       /* Number of active swapfiles */
>>       atomic_t nr_swapfiles;
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index e6aa94a583e9..e3bcab38a166 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1154,6 +1154,7 @@ static void __setup_root(struct btrfs_root 
>> *root, struct btrfs_fs_info *fs_info,
>>       mutex_init(&root->log_mutex);
>>       mutex_init(&root->ordered_extent_mutex);
>>       mutex_init(&root->delalloc_mutex);
>> +    init_waitqueue_head(&root->qgroup_flush_wait);
>>       init_waitqueue_head(&root->log_writer_wait);
>>       init_waitqueue_head(&root->log_commit_wait[0]);
>>       init_waitqueue_head(&root->log_commit_wait[1]);
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 50c45b4fcfd4..b312ac645e08 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -3479,17 +3479,58 @@ static int qgroup_unreserve_range(struct 
>> btrfs_inode *inode,
>>   }
>>
>>   /*
>> - * Reserve qgroup space for range [start, start + len).
>> + * Try to free some space for qgroup.
>>    *
>> - * This function will either reserve space from related qgroups or doing
>> - * nothing if the range is already reserved.
>> + * For qgroup, there are only 3 ways to free qgroup space:
>> + * - Flush nodatacow write
>> + *   Any nodatacow write will free its reserved data space at 
>> run_delalloc_range().
>> + *   In theory, we should only flush nodatacow inodes, but it's not yet
>> + *   possible, so we need to flush the whole root.
>>    *
>> - * Return 0 for successful reserve
>> - * Return <0 for error (including -EQUOT)
>> + * - Wait for ordered extents
>> + *   When ordered extents are finished, their reserved metadata is 
>> finally
>> + *   converted to per_trans status, which can be freed by later commit
>> + *   transaction.
>>    *
>> - * NOTE: this function may sleep for memory allocation.
>> + * - Commit transaction
>> + *   This would free the meta_per_trans space.
>> + *   In theory this shouldn't provide much space, but any more qgroup 
>> space
>> + *   is needed.
>>    */
>> -int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
>> +static int try_flush_qgroup(struct btrfs_root *root)
>> +{
>> +    struct btrfs_trans_handle *trans;
>> +    int ret;
>> +
>> +    /*
>> +     * We don't want to run flush again and again, so if there is a 
>> running
>> +     * one, we won't try to start a new flush, but exit directly.
>> +     */
>> +    if (test_and_set_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state)) {
>> +        wait_event(root->qgroup_flush_wait,
>> +            !test_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state));
>> +        return 0;
>> +    }
>> +
>> +    ret = btrfs_start_delalloc_snapshot(root);
>> +    if (ret < 0)
>> +        goto out;
>> +    btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
>> +
>> +    trans = btrfs_join_transaction(root);
>> +    if (IS_ERR(trans)) {
>> +        ret = PTR_ERR(trans);
>> +        goto out;
>> +    }
>> +
>> +    ret = btrfs_commit_transaction(trans);
>> +out:
>> +    clear_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state);
>> +    wake_up(&root->qgroup_flush_wait);
>> +    return ret;
>> +}
>> +
>> +static int qgroup_reserve_data(struct btrfs_inode *inode,
>>               struct extent_changeset **reserved_ret, u64 start,
>>               u64 len)
>>   {
>> @@ -3542,6 +3583,34 @@ int btrfs_qgroup_reserve_data(struct 
>> btrfs_inode *inode,
>>       return ret;
>>   }
>>
>> +/*
>> + * Reserve qgroup space for range [start, start + len).
>> + *
>> + * This function will either reserve space from related qgroups or do 
>> nothing
>> + * if the range is already reserved.
>> + *
>> + * Return 0 for successful reservation
>> + * Return <0 for error (including -EQUOT)
>> + *
>> + * NOTE: This function may sleep for memory allocation, dirty page 
>> flushing and
>> + *     commit transaction. So caller should not hold any dirty page 
>> locked.
>> + */
>> +int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
>> +            struct extent_changeset **reserved_ret, u64 start,
>> +            u64 len)
>> +{
>> +    int ret;
>> +
>> +    ret = qgroup_reserve_data(inode, reserved_ret, start, len);
>> +    if (ret <= 0 && ret != -EDQUOT)
>> +        return ret;
>> +
>> +    ret = try_flush_qgroup(inode->root);
>> +    if (ret < 0)
>> +        return ret;
>> +    return qgroup_reserve_data(inode, reserved_ret, start, len);
>> +}
>> +
>>   /* Free ranges specified by @reserved, normally in error path */
>>   static int qgroup_free_reserved_data(struct btrfs_inode *inode,
>>               struct extent_changeset *reserved, u64 start, u64 len)
>> @@ -3712,7 +3781,7 @@ static int sub_root_meta_rsv(struct btrfs_root 
>> *root, int num_bytes,
>>       return num_bytes;
>>   }
>>
>> -int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
>> +static int qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
>>                   enum btrfs_qgroup_rsv_type type, bool enforce)
>>   {
>>       struct btrfs_fs_info *fs_info = root->fs_info;
>> @@ -3739,6 +3808,21 @@ int __btrfs_qgroup_reserve_meta(struct 
>> btrfs_root *root, int num_bytes,
>>       return ret;
>>   }
>>
>> +int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
>> +                enum btrfs_qgroup_rsv_type type, bool enforce)
>> +{
>> +    int ret;
>> +
>> +    ret = qgroup_reserve_meta(root, num_bytes, type, enforce);
>> +    if (ret <= 0 && ret != -EDQUOT)
>> +        return ret;
>> +
>> +    ret = try_flush_qgroup(root);
>> +    if (ret < 0)
>> +        return ret;
>> +    return qgroup_reserve_meta(root, num_bytes, type, enforce);
>> +}
>> +
>>   void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root)
>>   {
>>       struct btrfs_fs_info *fs_info = root->fs_info;
>>
