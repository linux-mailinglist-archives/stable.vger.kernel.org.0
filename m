Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4A6609B2F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 09:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJXHUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 03:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiJXHUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 03:20:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC39205CF
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 00:20:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+Fpt/Gex+BxHwSQKVFf66SujgM1DaLnG7njAyIHpOrl86j96QLkyHF3V/UIhfKloSzemabuLevpOoOXP8vC7F+BkhQkbpMFWsMztGUAxhE0oKPkl2ZAtNFDYbUje8UM1vtLxATl8B7sjOebfa/jzdp3zrRSFrslfh5newEnoCbjRUj3ykVG8FL0gi/Q/qYf54R25Y7eLev8y3c24FhsW4TV88OHFp0FhE4+KC58re0fWq8oou1cYzBw/bKdE4IlbvStnj5zbaWk4O34w/InyjPNagSWtZ8xojoYjdCmSq4aGPGD8HZz9nosVAkE96Y7h/ibVRxGiI2u1L74/pnXJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6pdL2xv74N8xtyZIGzqpc36SjiQMcRClcb01XHJBT+k=;
 b=TZm+BsZlWDNhILJolfCUsKXAXVlcj8QqVQhgkc0nFz94PUrppJUhukzMJwNTaJZ9b0+6Bz6/YW/iJwiW1UNwDzveAsM4TEvNFR68yFL6/dTZk3vBQ3mZkzZN/BaGXL6EPmNvsJbxkrS5uPsCHbCxZJt0yq51pzPs9RasyNL6V8fzCQduMoL94hU1UC8d81GljnmWs+9vBuEjEhpfCIFGow4uTzCdvLL4JL15aTQEAsGyYMeJ6uN7iaGOl2FAoxfJIgEz7Wuf/7ernSyup8fout40di9rTOt95hvDV5OzFJWxst7lSp9CvfH+wxaZ8JYHmj8vHTAqmLGeorrHxblwiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pdL2xv74N8xtyZIGzqpc36SjiQMcRClcb01XHJBT+k=;
 b=4deKENYT2gA36fuCHazhGF4Ooqqf6Qk/vlmrqpFunUDM5+mj7MNynUrcayiVnASw17GalaPti5Mr/zRtxc493xHQGQF+mvBnR4yhBkVzJEvYId3ZMCz2q6f1rtrJzE65oslV452MKcmG9nUFICAint/OfJdiAZBV39ono/DdvY4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) by
 CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Mon, 24 Oct 2022 07:20:27 +0000
Received: from DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::d309:77d2:93d8:2425]) by DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::d309:77d2:93d8:2425%7]) with mapi id 15.20.5746.026; Mon, 24 Oct 2022
 07:20:26 +0000
Message-ID: <1976c670-d9b4-1071-a703-59dbdc7374ff@amd.com>
Date:   Mon, 24 Oct 2022 03:20:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 2/2] drm/amdgpu: use DRM_SCHED_FENCE_DONT_PIPELINE for VM
 updates
Content-Language: en-CA
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20221014081553.114899-1-christian.koenig@amd.com>
 <20221014081553.114899-2-christian.koenig@amd.com>
 <fd55eef9-1ce1-3f4c-d6ff-a5a230828b8e@amd.com>
 <7d482756-b5a0-328c-9e9c-ef0e31c4225a@amd.com>
From:   Luben Tuikov <luben.tuikov@amd.com>
In-Reply-To: <7d482756-b5a0-328c-9e9c-ef0e31c4225a@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT3PR01CA0059.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::6) To DM6PR12MB3370.namprd12.prod.outlook.com
 (2603:10b6:5:38::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:EE_|CY5PR12MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: 070d4e34-cc50-45e9-1e75-08dab5903946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ql+geGH4l4wI2bgOgTKM0yYGK9gXRnQHGrvSrdCIvV240SMOZ/BNNKykt70TPUPOW5UAIvQriksTJED2PjEZQwiUcpyUNsiRWjPabrGLNhNjHdCLxlZniUIJLNT5H6ozg7Uo6fEiSouP4UUGWXDGnXA8gZhhcTSLCvi4TQi89r9uTgEJGVb01vOOX7TyGBQbWgGU2AkKqgw+4Ikg5ZZ/Ns4L4GRlKOQqdYJQXhxgjQo8Fbqyg8UXLIjaZ+wfFGJwYFUmoSxyppyfWxz9SK+Qb4mTQ01C+aWnp5HLRFIYB9qJA+sTonwSU16TJXnsCePHAia9FA1YBKiPqw5t893RAiOwQYCqrLpq/xpJYabqhdLUC/rfirBbemrPMIJ5wTOWD5ehxr1+m0jsBot4Y5+so5WaJhEUJMWFbj7HjjrhEsyEEWW8M2Mv5kIxW9AhsRQpSzUOjf5Wks3Xvt/3+h/qaqJrDJHoBTTB0vTDTOqGLaOtJc9H+G58BTvedudS2PsTkdSL6Pp2EVWdtTrIIkGGOgUp264Q8gdOchha0sa51j2o/IlbKyxEzMpMhni4LlqKuh58xOz/LbO3l2/h8epuVwq2HahUt0WBKCF7BpjzOORjzgml+/ujp/QpfCr5aUPjH/xys/KxS20Bqwi+fybI2gsbKt8wSTQFDLeP4oPfOKtRWWzj+0ShrjAilnP4+5FutDBJ51DffbJNtHmFWO1WtG3Xzw3PmWaSZqRy2UzigM5P6Kr4JPTIGQTDn2Dzk4szAdwFA/m0RMFv2GM+zpKfdwVfESOxDLYCc+rux/WqOAI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199015)(2616005)(6506007)(31686004)(186003)(83380400001)(26005)(53546011)(6512007)(6666004)(8676002)(41300700001)(31696002)(4326008)(86362001)(5660300002)(478600001)(6486002)(66574015)(316002)(4001150100001)(2906002)(36756003)(44832011)(66556008)(66946007)(110136005)(66476007)(8936002)(15650500001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UW9ra09MOS9ZM3drcTVMUTBpdUJKbnpCTGYwQTZpS2xTQVpOOXVIQVlra2F1?=
 =?utf-8?B?ekpodCtMaHdBNXZMOWk5S25BRUdsL1FXa2k2cDYzUm1Kc1R5MDRPUU1OU1Bo?=
 =?utf-8?B?SFE5U1RjeFJpSmtDckszRkluY2Z1QnRtK2FsUmlSZUk3amFkTktDQVpPS1Fq?=
 =?utf-8?B?VUcyQ2owL0t2OG5qbTVtMWk1TWIvQjBkQWp5UmZuNmVSOWpYQzNES0VGdzJo?=
 =?utf-8?B?ZDNjN0JUa1ErLzNYblBmbWhmSjhuZFpNYm5WTTJwcjBNNGdqSmkvdmJPNStI?=
 =?utf-8?B?OGVnczh6eU95SW16UUlqWEYzdStnQjVtcjdETGJPcFVVUnVVdXc0bld2UnI1?=
 =?utf-8?B?SFRxMDJiVzAvWG4rTy9RTFVNRjY0TFpieGFZY2pRNTdqRjdUS3htM1l3em0r?=
 =?utf-8?B?bVJCMkpvalNqYm1yelJXOEdCdjBqZ1NnYkV2R2xKbTEzdW5YejRUelM5SDlt?=
 =?utf-8?B?V1dzN1F2Vld0WXMzMXEyM1Z4RmJSaGhRTE1pak9mNHJETFlUWjAyaE9oZEJV?=
 =?utf-8?B?UUpxZWJCTUMyY0xuR0dmbDRPeHlxL1lOR1ExTzBnVVBDaE5OUzROVzZtUkVQ?=
 =?utf-8?B?RHV4MkR2OHVLV3h4anFLWUNoempic3Y2K2FFTnRhRDhTSFNkeVhWVDd4VjNh?=
 =?utf-8?B?eFdhamdoRXlDaGRBNDdTVkFYUkRqV3ZkWE5HZkE3czU5RUVWNjg1U3htMUlL?=
 =?utf-8?B?NkQ0QXEyelpsUncwSkhPN2E4QW5COHVpZHdmdU1zM0ZYR1YveURuUnNRMmRq?=
 =?utf-8?B?Q2VjYm1vV3lsNDFDd2hYTXRMZU1KbzBCSHVhSGRGb1BsZlgwUUxnU25mNXNV?=
 =?utf-8?B?NktNaHJHclNha1JWRkpaZEF3NCtLcXZBbnAxVWRab3FuVW9iT2xCRENSNUZz?=
 =?utf-8?B?cDRRMnhLMy9vNU1NckFkSzdMc21sekJWcHVoNXhPaFE1MzNHV01OK2RLUElD?=
 =?utf-8?B?aW5SUVpDRGtjR2hxYXQrYmZHZnZhS3p5cmZUaTNhSUlmT0h2eVlBMEpkTzRm?=
 =?utf-8?B?cDY5eEZ1MjM1bWYwcnM0NUUwUy85MUQwOUVuOXROdUx5WURvbW4zOUIrRGFV?=
 =?utf-8?B?R3RXSElZT204OTVPbFNNQ253UHlKQ29PWExXcXZJWW96cnJtc1BNVzR6UVBm?=
 =?utf-8?B?a0I1Ym5JUkJmQTN3Qmw3Z29vUXVuSDdtalBGelRQeUtsSFo2SWJJaTkvVGNE?=
 =?utf-8?B?R3hZM1hEUkQ1VU9LYThrTkgxZnBORlJrVmNOSktiM1RvcENQZmJXeVYrV0hK?=
 =?utf-8?B?M2JPbFRudWw1aENVMU9hclMzTVExM09TaC9VNUhVQkI3aWtJSnJ3SHd1aHd3?=
 =?utf-8?B?MFNYa1IwaVdQRlcvU0hYTXA4WFI0SXU5SXFhNHhpOURCUzd5UjNJdlV2VVVw?=
 =?utf-8?B?NC91c2hiN3hkSHhlZ3B1RWNEQ2JWblhoUksrVlNxQlFyc002SUFIMEw2aEhB?=
 =?utf-8?B?dERrMGlsRTRxTmFiaE9zZlJPZ2RVTXhLM00vVmE3dHRMcmhMUU5FNWlTa09s?=
 =?utf-8?B?RzNFOWNrVDJ6NVdwU1I4bTNwaGdkVkdEdEdwSEZtWUh2R2dIcVI2dHZTZDNn?=
 =?utf-8?B?eTVPMG41WnpFaWJyenhCWWo5OFNGLzNNaUFSc1RlSHFTdlA5cnRkOHZDWmpW?=
 =?utf-8?B?YzJwTEc2MFRyeDdCV3dLTStlZ05WOHdxazVFVTJRWGNSZml1OXBKWnBjR1RS?=
 =?utf-8?B?amtmbFhqeEJrOHdQZlAwMVJLVnNxd1BsRmJqQVJZOWRiQi8vOUxNcnVHcTNR?=
 =?utf-8?B?LzkzcDlSVVVHTGdrNWxueXViVVkvY1FyWFovL3IvOTlhRlB5MkdpNjU3bkZq?=
 =?utf-8?B?ckFOaHduSDcrdTV1Vy83WE1IMmcyemxBZ2xDK2dNVEljOEViWVJ6V3ZJbHRX?=
 =?utf-8?B?VmdqKzlrRFdlbGQ5UENRMGsvMmsrNFRQVmd2T2I3R1NiSHd3RFpKSVloOENR?=
 =?utf-8?B?bmJQQ3dRdWpLRnNsaVpZOXVxd21IYVVNZ1ZzQXNIVUdHRWJFRGY5d2RGRkVh?=
 =?utf-8?B?bGdxckh1TGpzVUNSUlpiQzcrTGxjWVI4TUgrS3dTZGR6cTA5UkRKaFdGVk1o?=
 =?utf-8?B?R2ZiQXBqL3pjVWd1OVhOSkJJRlRUM200b2Nwbndra0kxSEhJNWRKYjh2Qmhw?=
 =?utf-8?Q?pf9KaHV506MVk+hOiyX1gq/Z7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 070d4e34-cc50-45e9-1e75-08dab5903946
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 07:20:26.8567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQlNfBLXzVf/GhHeDlBBtudsgB6KqAxpH8Q4dLTP8CS1Z/RzDnyhmv3l61wLm18E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6179
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-10-17 02:27, Christian König wrote:
> Am 17.10.22 um 07:29 schrieb Luben Tuikov:
>> Hi Christian,
>>
>> On 2022-10-14 04:15, Christian König wrote:
>>> Make sure that we always have a CPU round trip to let the submission
>>> code correctly decide if a TLB flush is necessary or not.
>>>
>>> Signed-off-by: Christian König <christian.koenig@amd.com>
>>> CC: stable@vger.kernel.org # 5.19+
>>> ---
>>>   drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 9 ++++++++-
>>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
>>> index 2b0669c464f6..69e105fa41f6 100644
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
>>> @@ -116,8 +116,15 @@ static int amdgpu_vm_sdma_commit(struct amdgpu_vm_update_params *p,
>>>   				   DMA_RESV_USAGE_BOOKKEEP);
>>>   	}
>>>   
>>> -	if (fence && !p->immediate)
>>> +	if (fence && !p->immediate) {
>>> +		/*
>>> +		 * Most hw generations now have a separate queue for page table
>>> +		 * updates, but when the queue is shared with userspace we need
>>> +		 * the extra CPU round trip to correctly flush the TLB.
>>> +		 */
>>> +		set_bit(DRM_SCHED_FENCE_DONT_PIPELINE, &f->flags);
>>>   		swap(*fence, f);
>>> +	}
>> Do you ever turn that bit off?
> 
> No, I just rely on the fact that the flags are zero initialized.

Acked-by: Luben Tuikov <luben.tuikov@amd.com>

Regards,
Luben

