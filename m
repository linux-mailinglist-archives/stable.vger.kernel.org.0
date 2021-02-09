Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71907315089
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 14:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhBINla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 08:41:30 -0500
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:10401
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231609AbhBINj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 08:39:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c84Flbuebn1aEX9iDlL9aJIhYR6Nomdn8SVbT1TAdhKoKWFKTp1xuYA0gQoeTorJUrIPoUpDFLllkJBbr+uVDO8fCQljUQiG+UfmKY/fg71sXr/l4oCzC2F1HmmsxLkVgfyW8NnX/BiMcx/Sag/d1m+E2A/MKIP5MXKEYEQkbLyuP5sfTT1DzzncDFLhpBrhEJQLfHgjHRzGp3DyFSfq2zF3B/ku8z+NFu1QJ9mlrZrlVVPeooMJHqg6gE/fCLmxBUgm/HcNuwxm23VAIWZ34+eDQNR6k0tuvcV/VY4a90Taq5X+zPGM5JRtJV7CaghEuDPo5lcAqAw+KfAs5FIgBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Du6wsHCbus5oxp/G3WQX7nqD6tUNi+zlSnlTWdukCVo=;
 b=DyOolsP2VFryz5VSKjLEm/2PcQ7cfAN8Wv1QhgOxyfkLfL9jhfOwFQrQybOwQm3F62EqOGloLIY/isJ+9ZhtxzKVoRlD5i+jYDTCj1dsZr49N5RrSiUSL3TTIUw31SSfHXSP26oPcdmKgcvH/gVGUA2qYKsMAp/AFFlJ0gmQSr+1GtSIqtpO9hHSQ9kXdcFwKy2Ku1m5Pbx8EFoVwxVfq9BdzB5elmMcCvcKXqW07IqEeRfLbchGShVlmglLUf5hhCUzHYKgH2L57oSgzHb+4NkQptFNoG6RTX9v8N01ZpnFMvgtHpSnflZLPy2kwsPHyE0x5HfyRpWrPT1UXWnCjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kunbus.com; dmarc=pass action=none header.from=kunbus.com;
 dkim=pass header.d=kunbus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kunbus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Du6wsHCbus5oxp/G3WQX7nqD6tUNi+zlSnlTWdukCVo=;
 b=d3ajrpEY80GonAaJMIzDpOueXHU4JwmxvKQdkBmLrlKcd9+IZKp4ooKGaRZfRwr0phAPfUw17n1mPBDRkBlAXkY8CX8PUh3z+3wyniL8oJlS7ye15Dtt/kgPT1kkvW8cCVpRjQVp3cPSrvvBQQvkPAvSLpWKoi3VOT8nrxFfpBs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kunbus.com;
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:a0::11)
 by PR3P193MB0538.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:3c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 13:39:10 +0000
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73]) by PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73%5]) with mapi id 15.20.3784.027; Tue, 9 Feb 2021
 13:39:10 +0000
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
 <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
 <YByrCnswkIlz1w1t@kernel.org>
 <ee4adfbb99273e1bdceca210bc1fa5f16a50c415.camel@HansenPartnership.com>
 <20210205172528.GP4718@ziepe.ca>
 <08ce58ab-3513-5d98-16a5-b197276f6bce@kunbus.com>
 <20210209133653.GC4718@ziepe.ca>
From:   Lino Sanfilippo <l.sanfilippo@kunbus.com>
Message-ID: <01641acd-1485-213e-2bf6-8c380bc3cec6@kunbus.com>
Date:   Tue, 9 Feb 2021 14:39:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210209133653.GC4718@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [87.130.101.138]
X-ClientProxiedBy: AM0PR03CA0009.eurprd03.prod.outlook.com
 (2603:10a6:208:14::22) To PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:a0::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.23.16.111] (87.130.101.138) by AM0PR03CA0009.eurprd03.prod.outlook.com (2603:10a6:208:14::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 13:39:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5ffe33f-1a39-4261-118d-08d8cd001499
X-MS-TrafficTypeDiagnostic: PR3P193MB0538:
X-Microsoft-Antispam-PRVS: <PR3P193MB0538426C6EFCE9E41FC92AC6FA8E9@PR3P193MB0538.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w6f/v8B5d2Ml4f7BYE74uSa6XXbWfAF9iFgP8yzNd9IYL+fq3Kd2n68wVMoY3ZnpUiD4njBxRWCSsmZB0otmzNNc+Ka8PCE6SzJQPWNOvcJlYVzZBpKmWfL3LProDdT4vQExP0HxSKEvhJ4foAqQajrQc57SILlOdUNCK5rj4iQ7acXUHwei+qpwa/OBDrK8YT0T8vhzn8PCR0waKFJHK9nDYrlARAyarueaKLPf29aaPwPz9p85OGLHVAq5GW0IEdT2FC3TIEuoSYmwlUI89tM45gKL5ZMo+RJRSdgm6iVdVof+46DY+hlmmHi6eDU1/vUDIZIP5DRb4rSlObKFKDxBmwARDcvStZUtinDMc0PfSsZ5fWuP1b9riIpJVol5xLDEUipjbga7KvMq20+EcqXJp7+XrsT/iMwuvv1TREyn6wP8HCN69EINFd/RAh/Oj6Bwrp8GOiJIS1LsT/1Zkdpz59NycjIVEOaDq7UHRvS7AQEOZd3DVO/m271006GDNK6Eitw+LyvIwR4XEAuefxx4v8bh8v9CI8Y7+F5PZcTspBaQhjF7Jt9zDQjycOS/i1Q4cz5jEhOBrY9xW3IhqYE+TzJr+Qdvd3ZZ6mKzG+E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3P193MB0894.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(136003)(39830400003)(478600001)(5660300002)(4326008)(31686004)(66946007)(8936002)(316002)(31696002)(66556008)(4744005)(66476007)(2616005)(16576012)(956004)(6486002)(53546011)(86362001)(54906003)(186003)(2906002)(6916009)(52116002)(16526019)(8676002)(26005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?djBEd21zZ0t5Wml0WXlCb2dGZTloend1S3k0RnRNMWRBdUpORXJiWnJlYTFH?=
 =?utf-8?B?NkRKUTVWU2Vnclo1WUxGNDNINWo5MXhzS1lqcnZTZ2VaUExOdDRYWTJZWXov?=
 =?utf-8?B?UktnZktmZC9VRjdhL1hZcURJMk00S3dlTGhTcHFqUUNjUGRiVHVkYzMwYVFt?=
 =?utf-8?B?Mjc0RlM3R2NhTlYvcm1IcDVDZ0Q2SnQ4ZUxiVGFpeVpydnBHcGQ4T1VVVXE3?=
 =?utf-8?B?NDQra1NoZFM2V2l3UDA5TDNIZnVSb1NDTmQrKy9CenBJZ0VvRCtsKzJFcmxS?=
 =?utf-8?B?cW0zckJzSFBobEI4ZHRwQTJHOEVhZ05kdE5GUFMxaTZtYStteUJKeGZhbG91?=
 =?utf-8?B?Mnc4ay9XQXdUeWQzSFE4dnJ2Rmw5dGZjOWwwajRjYXA2V0dnN3JTZ2pnQ3NR?=
 =?utf-8?B?YUM0cVpLam1VWFQzSnhKYTFDcVhiQjVIVDIvc1drMU51VUQzckQ1Snp3WmdZ?=
 =?utf-8?B?RitVVjdZV1plL0hxVGhpZjdiUkdMWGVXc3A3OWhwemRlUjdTN2l2UHhWc0pn?=
 =?utf-8?B?RzQrRm9GNUQxN0o4MHdJR0VXcCtPTGN4MnVReHEyR1BMT3pKSXIzcWFnQWxP?=
 =?utf-8?B?My82U1JWNkkwc29sbDF5eDVtVi83NU9MSWZvbFAzK2lrWVdZOWsyVW1uRk1B?=
 =?utf-8?B?WUNlVlduWDMxbERvUFhCK0o5SklObzRPbjB6WmIyTG12aVZjZXhab1hWVkRW?=
 =?utf-8?B?ZFVBYXVhclhnUE9FVmxFdDJjdHRJYkVjTkVTL0Y2YlNkZVNlb2xSdXJKRURk?=
 =?utf-8?B?b2prOUNTeU9VcFM5ZTJVRXV4c1VFSVRWUFVRS2U1RVBHbkl6Q3Q1V1pES3Vu?=
 =?utf-8?B?UktXSE1JTjBkdWM0SklnZXNqOVUvRGh3eUJYMDlUcncybVFxM1JlQWpzTVNo?=
 =?utf-8?B?Z0tWRFhselgxM1Z1RVgyUHNUejh1azNiUHdJY0M0WGZIOVduTHpEck9OZm1D?=
 =?utf-8?B?WDljUnJ0S09IcUJ2czJFZWRuZjlFUi94Q3BzOEVZTWFoQS9uOTJaazhWRmJx?=
 =?utf-8?B?YXlZZ0E1d2ZiZ1U4dGl2aXh6N1FMU0JQSzYzVTkxYldrOUowWEZ0Ujh1QnNC?=
 =?utf-8?B?V3ZwYTNwSVFRbENjSUNldy9WeVhYVXJ0SXVmMjlxQmxoOEZ1NHdiYVNMbDBD?=
 =?utf-8?B?M2grMUlTRWtEYUR6aVN0SlRreGFmNUkydjV5emJKMGhXakFidkNJNURXbS9U?=
 =?utf-8?B?cmpnVGprazNyTGJiSVgza3NSTjJ1bVRISHBFbFBHc3dHSE11cEhYR05hRStZ?=
 =?utf-8?B?YkRJQVFCcTJsV0k4MlRwMzFuRVRPUkRUc0pTTWdvUy9iMmtuVDdwUnlNWkd3?=
 =?utf-8?B?dXJpdTNUUEtoUlNvUFRQcUUvUFpNLzdTWHNTeWNCRFBqWmxIYWVCY2RqN0g0?=
 =?utf-8?B?N01jN1k5L3YvNm9neE1sQnpRR2NwVWJyV2pBVWFDbTFPZ3YvR0RaNjdyTU95?=
 =?utf-8?B?YVF2ZmpoTXJ3WDBiSjQ5MWc5U1VYU3E5Ui9JRklybGhzenhONjJKVVBKZWxh?=
 =?utf-8?B?TkdxMmIvVHJUOGVERDFyYm44MDJaZzlNNjJoVHlzbW8wVmZ6Vm8zSlduK1Yx?=
 =?utf-8?B?VHZTUzlONU9NWGxGQnEzWDJZMGNEZm1NbE9QUm80WUsxcThzUm9GTnRCTEUw?=
 =?utf-8?B?d0RBYU05Q29NQVM0N2llajVaWDdPU0dnK1BwRGF6QWxNOFpyYW83Wjg0QTN6?=
 =?utf-8?B?R0U1UGZhNlVwRTJSS0hpcGlYZUQ2R3FXNTF0UUgweVVnLzZuZkY4WUxhYkVQ?=
 =?utf-8?Q?YWP+YiEuKthnFr3Vr6YWqK1ez9JiQtXeBt40Z1j?=
X-OriginatorOrg: kunbus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ffe33f-1a39-4261-118d-08d8cd001499
X-MS-Exchange-CrossTenant-AuthSource: PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 13:39:10.3579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: aaa4d814-e659-4b0a-9698-1c671f11520b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZitQkwFj3ZX0sXTew2hpX5RiMfglHKtht6QL2ymx4fBVVNeuMyb/8PDvavmJd4ULUjWXhm6/T4phT+7Pq5/e9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P193MB0538
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 09.02.21 14:36, Jason Gunthorpe wrote:

>>>  EXPORT_SYMBOL_GPL(tpm_chip_unregister);
>>>
>>
>> I tested the solution you scetched and it fixes the issue for me. Will you send a (real) patch for this?
> 
> No, feel free to bundle this up with any fixes needed and send it with
> a Signed-off-by from both of us
> 
> I did it pretty fast so it will need a careful read that there isn't a
> typo
> 

Ok, will do so.

Regards,
Lino
