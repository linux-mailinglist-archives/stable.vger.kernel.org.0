Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A753BDFA0
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 01:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhGFXMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 19:12:20 -0400
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:39937
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229891AbhGFXMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 19:12:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuEdnYzhjqSlCH5uIDNz+inMOUUUtMsA5VTl9YorNCiHvRUK7+LoeAbgotZVJW/v/Azi/dXxXsyHixrkUbATgR7iUuWZXJDPw2QnSOT/0B9ZRswwz9uZBNCNgO/JRcQXor780ZNqCN04c/R8q9J50vEMuqsJOu8QBnHYBku/RR23wbVxe/JVe8COvRuEsmYbgqxueQvFHLX1HGBLTttp8h4QWdJVLvjtwvYZ5hJiCjnIR8cJPcSxR/gqk+xnKi1E7sygj4zqbOI9Sji+b8gW1VvZ99OGboFYkNIOc0sv8jm9jGsgXctArgHIsT6mqqGdODGJiuhcS1NAteVbNaZUng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozySP9ht8oQlxBoRaUiW+aODSD/gLWF6BHdCACNZGOo=;
 b=GiFmn0spZ643FWZx+JoLx2lTCnqqh8yGjTkFORsWSgfeJcn0Ykndm9goCCKbJbafUjbt+calGJsTz34e6bEpiSnIl9r1uPPj+mPZwhbcXIXCfKYaYCTxKxfKPKDyxcPgBT/QS/7STvJeG3MKWtmLf5ZRAy2XdtYf4WEf90xzmeY3pce9jL8eGudt57gydMKvKkZMiWkWlU6fue+aTumD3/2N2rYij46iMzvtMm8CD4pEWQQTOZGiicnl2Ey7flbgzrl2tjiSaj0XzyCmMZh798CjGgqrmD0h96eqzAyIZ9+Ritm4T7IF52hdGv73Tqik0RZOgxEnHFgpd1LBi/5QdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozySP9ht8oQlxBoRaUiW+aODSD/gLWF6BHdCACNZGOo=;
 b=Ehb47tjsFoGMxb5EYIGhaUBXjOEf/63hVDftUkDAo/IFFHG9GhbAZm093XEOrwwswcoRKBcxfL8T0Jpg9fp00gM+C0S9Dkar6EQFK4+xyGiVqD/qUQXI8WI7L1g5NQLFS+xu/H1SnTEV2w2xJkv5zrUs4WoYGgHYCLBlQ4JHsCM=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5129.namprd12.prod.outlook.com (2603:10b6:408:136::12)
 by BN9PR12MB5132.namprd12.prod.outlook.com (2603:10b6:408:119::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.27; Tue, 6 Jul
 2021 23:09:39 +0000
Received: from BN9PR12MB5129.namprd12.prod.outlook.com
 ([fe80::b891:a906:28f0:fdb]) by BN9PR12MB5129.namprd12.prod.outlook.com
 ([fe80::b891:a906:28f0:fdb%3]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 23:09:39 +0000
Subject: Re: [PATCH AUTOSEL 5.13 113/189] drm/amdgpu/gfx9: fix the doorbell
 missing when in CGPG issue.
To:     Alex Deucher <alexdeucher@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>
References: <20210706111409.2058071-1-sashal@kernel.org>
 <20210706111409.2058071-113-sashal@kernel.org>
 <CADnq5_ObmVRjwUB5Lw0bLZLL-+=CqvGkJZ+2DY5ZDh+uN-oo0g@mail.gmail.com>
From:   Felix Kuehling <felix.kuehling@amd.com>
Message-ID: <affee955-54bc-11c3-8ccd-5678f7aee687@amd.com>
Date:   Tue, 6 Jul 2021 19:09:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CADnq5_ObmVRjwUB5Lw0bLZLL-+=CqvGkJZ+2DY5ZDh+uN-oo0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: YTOPR0101CA0071.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::48) To BN9PR12MB5129.namprd12.prod.outlook.com
 (2603:10b6:408:136::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.100] (142.186.84.51) by YTOPR0101CA0071.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:14::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Tue, 6 Jul 2021 23:09:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95b2201b-86c2-40ef-5e7d-08d940d32136
X-MS-TrafficTypeDiagnostic: BN9PR12MB5132:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN9PR12MB5132B734E60EBE9FDFBB74FD921B9@BN9PR12MB5132.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:165;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QFOJDBtKSwaDma0Nh14lwT+A4BJiRvHXv4XKH2c3RL/J+AvQVcjHPkKhqusLHx1w8wsI/IJhN5MGxHWF3J7EkAFp+hcJRKBEXsJNcac/UtEfUDDC8tds6R1LqjbARqHek1RXvX23YXRZbCEYuyCEMmG41uy5VMSECnH3YBSlISDFAVwIk/o6zt4CmNNQNzXVUXaHBvoWvMSchJpJDAXvyJZ/LgbBedX6Fg6E1zwdvM/GVrl8Z91PJL46IShNpua6fJgwzjTlqTHYIz0V+SLEycZewnp3KEYFe8Vo6FOUIdQSAqNgheV7+MP4bPfbM49SV6npAgPibwh29RhwRp8BiwOjfoSYIv8t7zWCzZNfdKFT+lR1cN84hOp3uEVwu+mxLHqg7K3XszpAFG5DbILJuPRaKTI1W+mtDtd1//e/TRQ773pbVq4vHJGM2f3a9ZKqWUL8SogG3s+khVeW8j7Tq/YW3h5wyNTpE94L5oMd9vEY3698lnAQOeru5DXrK38EZva0fBrzKvmR80cphssTEbKNw9e2IPA2PtlooHfO6dsj8tHxWO/LOR8DL89fwdIwF7DsuNQ3JJYZfQ4RrvPyWd7o73xncjzWeS/SmAGxv4J9/YVnNV9J+og7OXgDT2O7q7OT8cnQy0QP9cBdXAwFPcG06mUjqzkzNirG2OrrSseH98Dcvf13Ff0W9l7lGQavjGMm0abnwz2hc+r9KNJEu5zfRNgy6zPwWDHeM6o/Zg8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5129.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(8676002)(5660300002)(186003)(2906002)(2616005)(38100700002)(66556008)(53546011)(86362001)(36756003)(478600001)(8936002)(316002)(83380400001)(16576012)(31696002)(31686004)(6486002)(110136005)(66946007)(44832011)(966005)(26005)(66476007)(54906003)(956004)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWtCakJCdXFHenA2MWRFT0dvSVVsZ2RKRWx0THQ3amFSY1I0RUpJUEZNajRE?=
 =?utf-8?B?WENPUUtsS3p2SER5U2p1NTJ0UUQyczFBZjR2by9Genh5WCtTdnd3bTRZZG1s?=
 =?utf-8?B?OFZQRi9ZRFBJdVBEbUpsS2c1dUhmR25qNzZ6RDdueE5vZy84RGZURGtVWTZu?=
 =?utf-8?B?MmFFd1dlVHIyRVdRSGpsM3VxMjlLMDErOVlncGs1RXF5bmF5RDl6WWN6Qlpz?=
 =?utf-8?B?SENCRzNmenJsNjlMTXBpUFh6YVF0KzI5R010c01XcFM5WTJ5UkNJUGJpK0pD?=
 =?utf-8?B?c2hHYlN3UlNRbjcwcC9MbTBKN2szd2ZQS1dPMnErb09FOXhvOFBaMEFSdE5n?=
 =?utf-8?B?MUpvcTgxcGFRMjJxWUg0T2JkR0pqR0gvRlQ2cjJER2luQitqWmtaYnJrY0Qz?=
 =?utf-8?B?MFk1NTFiUmRqNUxiQm9XNzVubFFNWnlTckdVSmxnQ0pFR2Vjd3VNbEN3UEdD?=
 =?utf-8?B?RUxTWlBwY05DcHIrTjkycDcxcDZmbjU3bzN6RE05UmFCR1hJdnBvaEcveW5I?=
 =?utf-8?B?TTZkc01mTVgxeHl2WlkrREh3T3BiQ3ZrSWRWR1JhS1piSkJ0SjNzdUpySmFh?=
 =?utf-8?B?cE9VaVgzc0FBaHRaV1lRNVpYZXZ2MGVkYjNzRXhDUGZFb0NHeDd3dHFTZTdj?=
 =?utf-8?B?YVRpNkxOWktTbkFwTlJ5dHV6STRxME0vL1RIVnVPSzNWOFFnSGhRVTdTREx4?=
 =?utf-8?B?SEhZYnBhSGdQSElBQ2g2RzM1N2FHOHR1R08weFJQMFIrTFFNNU84K3RTRlBE?=
 =?utf-8?B?cG5Pd1RRUnJFQ1N3aVJ3eGhydWRxM3g4SThDbjJFY05IcUpOSGZrMFJrSDhD?=
 =?utf-8?B?OEo3S1gyV25oSEZRVmtld21rNjZ5M2xhdFhBdTg5eFljNERrNUNaMmpUNjBw?=
 =?utf-8?B?TWJ1RjRuVWp4Nmp3UnpCa2REQ3ZYSlVMMjMrRzlkSXQ2dDd0OUhITmFOU01P?=
 =?utf-8?B?WEF4N3owYUk2RVNRYXh2ZUdBcElFMWtyaTVWZ1UwcW1HU041SHJyRFBLcm5Q?=
 =?utf-8?B?bmNhMXpmbU9XLy80SFdQNGx1cmJZbHB2RHVuUmFvMCtrZ3dBeDk2bi8vWmtt?=
 =?utf-8?B?K1VLeS9vQ05jay9qdWVudWFBTC9Ua3ozMGkyUGxoZ0I0YmtsMVprT3M0djRu?=
 =?utf-8?B?QXJmS0FzSWowWWFIemsrZEVpdFE5YmxCWW9qVEpYdThkMTlXTGJqaC9GeGJZ?=
 =?utf-8?B?N0tiaktvRzVvWjVqMis2NHVOMGd5MEZCdEZsSk50MllHdEFFR1cxZFF3cmhH?=
 =?utf-8?B?UU5QQjhFYVBRSnlYOS9HSjJyRWE2MDd5Y3pqbG1iZ003d1E3UUdUSjZsNk1J?=
 =?utf-8?B?ck5DbDB1ZExFR1N5WjQ2TEFLU2N0OVVtNng2ZE9GbytvRktvNUNQVmZtUmRP?=
 =?utf-8?B?WGI5Q3NVeHRlYWZ4dUduL3ZnZ1Q2aDl1YW5HMkxOeFFGbUpXRk42SjFFM2pY?=
 =?utf-8?B?a2FrLzR2am5VS2VXY2kveFZvSEdNTzlhQ2UzbERhNnNRMm1ITElXMStSUUtR?=
 =?utf-8?B?bEppSW5jVDVZcHRlaVRaUFN5WmlKTWI2dzRPZDV6YkREU1ZmenJmV040NXdq?=
 =?utf-8?B?Z1k0VUgxSGt0RldQUTVGTEthcFFweFc2VUtCZTAybU5YMHVjUitQc1lBek94?=
 =?utf-8?B?My9BRVI1QUlQd3BqZVZWOTVweTlOSHpkN1dnSGR3akVaY3pYSlhZYVJSSVB5?=
 =?utf-8?B?OHl3K3lzQjRKRmJaVEdLenBGWEtQVllnZ3BDaFJab3JCeFl1UlF6QnhFbDRU?=
 =?utf-8?Q?fKU01XowQSbP7rnIl+xvbaonVRS9ddxOTEFr+Dg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b2201b-86c2-40ef-5e7d-08d940d32136
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5129.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 23:09:39.0796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZp7UWEVMszyZAhcOt4Bkdt6Ko6PpRrKhON5lItFLU+2hrQY/NAfXhst5BY5+wz3RHjvwnrfEnrdwXEDvUAwiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5132
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2021-07-06 um 5:44 p.m. schrieb Alex Deucher:
> On Tue, Jul 6, 2021 at 7:16 AM Sasha Levin <sashal@kernel.org> wrote:
>> From: Yifan Zhang <yifan1.zhang@amd.com>
>>
>> [ Upstream commit 631003101c516ea29a74aee59666708857b9a805 ]
>>
>> If GC has entered CGPG, ringing doorbell > first page doesn't wakeup GC.
>> Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround this issue.
>>
>> Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
>> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
>> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> This should be dropped.  It was already reverted.

Patch 146 of this series is the corresponding revert.

Regards,
  Felix


>
> Alex
>
>
>> ---
>>  drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
>> index 516467e962b7..c09225d065c2 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
>> @@ -3673,8 +3673,12 @@ static int gfx_v9_0_kiq_init_register(struct amdgpu_ring *ring)
>>         if (ring->use_doorbell) {
>>                 WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_LOWER,
>>                                         (adev->doorbell_index.kiq * 2) << 2);
>> +               /* If GC has entered CGPG, ringing doorbell > first page doesn't
>> +                * wakeup GC. Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround
>> +                * this issue.
>> +                */
>>                 WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
>> -                                       (adev->doorbell_index.userqueue_end * 2) << 2);
>> +                                       (adev->doorbell.size - 4));
>>         }
>>
>>         WREG32_SOC15_RLC(GC, 0, mmCP_HQD_PQ_DOORBELL_CONTROL,
>> --
>> 2.30.2
>>
>> _______________________________________________
>> amd-gfx mailing list
>> amd-gfx@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
