Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E774664620
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 17:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbjAJQcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 11:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbjAJQcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 11:32:14 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2072.outbound.protection.outlook.com [40.107.95.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75FF81D6A;
        Tue, 10 Jan 2023 08:32:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHGXr3DM2gxucTH2EJ/HfoF1B+isFdcqGY9aueBmM2le/3SHN9S/IYZ1+8MzT4+v8UQwMVjgx/UF3sacIiyWMj5RQX+c6G4sw9XcDCzsu6yFWpWjuJDgEyYbOX96mNGlFxGom3Kft/tBHu/GiWQw/4RNAWEb9ZqLPSjK7M531I/6Dj8V3ojKQqU7TbS7nWb/fcW4rGl+9qFe3+WYl79nzR6Jl2SluLZY+Re5/CSdDVIV/8zf0BCI9CkIjbCumGcWdjjvAyyaSjadi9jNsuursBRE1dxdbglGUWtvRU1/vbGJ0FgHQk625Y3KuUL+UCYOTNCpQ9ZS2OI9n+56t1pkTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Ijm61E6Ut+morJMADhRiYH+j1/fSdFrXv/nikmbmNE=;
 b=eDpAsxsIaFEcfoBCsMMJ/13QgvBNBdiJ3mBgU/ZUQHSc+TEAqNyddbUSN3N1a9W+CixXuqjmVAqd2tz6W+T/mUEaOPdtnDcqUUv5dd8ItSAjeG0R7OPSZKHMzc5MJ2aIILcEa5GjSVx6hgUPXQfusivR3eaavWyyksH/u5q6K70FIuRTDEkbNCHciKsNvPkxEt2DuUG6l/gAZuU86ROdjdk+GaTphoDI9yCzaeSbFuQuVvLUsYwTe+qMtN+l/MQpzNdlJbnSinZM0zi1bXLTC4mko9KWuxbcI6oBIXNlk9LUVyKqnJkm0b99xU3zPQOjJuFD45wOeVIuj30E3JAwaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Ijm61E6Ut+morJMADhRiYH+j1/fSdFrXv/nikmbmNE=;
 b=TcoWbRFahUuBuSChX8VihW5QCiMqUVhkK4KOcAtBKrVtwwfWOnlcIInSjIliNkdeia5pjalA7na8UqLiwh6V/TvlVR/ptVPHH2Wj0JLS4y66D50ZSWIq1DAAUEvehPYrxea/g6VJHhKLDesomlso1qd6Pp7KiaMt+jrhKB+k7ZI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BL1PR12MB5207.namprd12.prod.outlook.com (2603:10b6:208:318::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 16:32:10 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%4]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 16:32:10 +0000
Message-ID: <74745684-785e-71b2-288e-91fbcf1b555b@amd.com>
Date:   Tue, 10 Jan 2023 10:32:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] KVM: sev: Fix int overflow in send|recieve_update_data
 ioctls
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230109160808.3618132-1-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230109160808.3618132-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::33) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BL1PR12MB5207:EE_
X-MS-Office365-Filtering-Correlation-Id: eb8fc2a1-d4b3-4b06-0b50-08daf32838de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j42s+2y7G5m8kCT+01pbJQJOkJT0Hz6pTZCAVbsYBk1Qj1vO3/8YsM/ahR86okgzUYhZ+oJ46j6fpK2pN7oHPFk8w2/0HZq/4wsn5jXvt77lyumXgGzJQAKLlAcOiC3SC3QuVX5fkgQhR/8CCZOfvzMQ0KHeTxB5/yBE85GsPsxRLbReywM+xC6t93JbG/L0v72/5nFx6p5RIEnwxYwxcp5J/uIW69loNhWZgV9HcBuMTAiUg5Zw6S88AUH6saIVlvy2e6iz+eubuxCLREXmiElQjQTI7oFcW1HGVooEvss3E0bBXbNmdtzj/91jpQRvnltzQTr0NodlUQPnOsEmk68fzwooerCvNuFdzm5AJELxrEJguVTHkWkLcqii1J3XDIBb42RUTGkzkrSXBa6sphGEgyxhQXdWS6Q+miKtKtw9SX1NUVV82k9psGGlfMeOynVpmFnegMPVgZp/dU0Xx2cLVDsfTluYZOpDdGy10g9LrJwguiXgNg1YNml4zCUGu0vj/GyBEqS6RFCXlwQknIdGeTB4aUTBiA9wq8WV3RipnBd2zt777Z1/3CFEbpOQDVfDk3CbgeBJTfgpSXRUX+EgkQUvboI/e8l3+cqhpSZHsQJ8bEvoxLjDWNNrLwRBZlaF5zlheUSpATycpSzwkCUNtlLlo2xuQ4JQzWHsKTb3KNSQpXALmdIf76dYlpOefytnS7LvWoRYbszckIfpqI5q6p6oE/C5ju6Ru6fMK/I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(451199015)(8676002)(186003)(316002)(5660300002)(26005)(6512007)(6486002)(478600001)(2616005)(41300700001)(31696002)(66556008)(66946007)(54906003)(66476007)(4326008)(8936002)(83380400001)(36756003)(86362001)(53546011)(31686004)(6506007)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFFmTW0vSHBPeDkzRWljcTNteDVweHVLSS9YVlZ5RlVmL2FKV2I4ZVpXSzFX?=
 =?utf-8?B?QU1MNDdSdXR3MWlFSyt4eDhuNFF1NWpoVEI4UEdvcnBlWU8wTDdtOWsxelpT?=
 =?utf-8?B?a2xsMUlYREFRTExIVU1BUlNaZjNkNkR2eFlSa0g0R0EvNU1lOG1YUG1MeGFo?=
 =?utf-8?B?RUVrUEdmMUhpSVdWYXB5MkNIUTFXcnlxc0dWSnA1MTVIb2luaUdNVGh6WWdU?=
 =?utf-8?B?Ymd6SDcrbWd5a1M5Tk41Ujl2cjhsOUVGUWovUjdob0xUQ0JDM3hLZ3BSWFhB?=
 =?utf-8?B?YVJ5bjI1NHMvdG1oOWR5cDNkeXZtVXZvS3FhbFQzS2pXUFZIV0hzWlBVSHZi?=
 =?utf-8?B?K2ZaLy9yMzJ2WWlTT1NLNUlraWJtcXpJUlBqSzBhK3FJeHZLZmdVdmZoSUlw?=
 =?utf-8?B?TTJjbjY1VFNqaVNqNHNOc2lFL2ZObG11bTRhRUhIZUZLVDlxM2laN3lrNnhs?=
 =?utf-8?B?eCs4cndEQWYwMVJUU0NQdVluNkY1SFlKWDRMb0d0MFJ2Y2tucjVWdTlHbWFm?=
 =?utf-8?B?NnlqNWtET3hzVVh6cDNCOU1UaGpyWTEvdUx0Unc5ZVNyNkRHa0xIeUZCaDEz?=
 =?utf-8?B?YUFtTWxBVlhuYWQ3RVhRbXNLZlcrRGZtSk5tVGhWQWkyKytlaHUyR3lvRVlN?=
 =?utf-8?B?emJUUnkwaEdZb3NyanZITjdOWUxUZEQwckx3WXVKN0ZsaE9icVFJektUT0N1?=
 =?utf-8?B?U1pVNFNlcDVxKzRJMkg1Y2JBbC9uMXR6cDFwSHdSVWl2T0ltTXE1eUs2azFN?=
 =?utf-8?B?OStzYlBvYkprb2ROYnFCTkpPMGx0ZWFBZDF2aDkyWit1Y0c5ZC9ydHNDSFdu?=
 =?utf-8?B?eWZTMGtxU25UMWJUWFpqL1h0TUJjSE9TQnVYVWJCWUdoMUVRQVRtd1o1R3Nq?=
 =?utf-8?B?dVdIMjJCNERtNlB3aDF3ZVBwS0I3UU1QbE9TUVQxOXBNQ09Td2QxdVlkQzJO?=
 =?utf-8?B?R3JLWnJVZ29CNDY0ZHE3ZE1iZDdPSEUvVWNGK3ZlYU5lejkvenczNlBKYkQw?=
 =?utf-8?B?bDNjNGM4Sjh1QmVweXFQb3lQZVNYZlpRQVJKcW43YzM5ekJNWmMySHFBd0Nj?=
 =?utf-8?B?dkRBRkp0eUN5MUdWbnZsRktDL1ozNWlyWjJGRjdpQkNRR1ovU1U3cDh2aWRa?=
 =?utf-8?B?RTFpZXdvYys4MzZQYkxjMHNPei9pVVpKSExGQUpQbkhJdGVyNytCSHlBb2lo?=
 =?utf-8?B?NGI1RlQySHdqcDN3Yk5QbjlPUkdScFNaZ3hIWG5uWWtPeWlUcW1GdWczUWM1?=
 =?utf-8?B?Zk5RRVlXSVpoZ09HTndNaFFOWnFGdHNWaFZNUVVDNkxiVGxJRGVrREMvRktk?=
 =?utf-8?B?Mk1kV09lQnVKdysxWHBEdnltVjNGbFVFOEhQRyszR0JTUDBSUEl2SHVVZHpM?=
 =?utf-8?B?Y0tSL0xUUUJzQ28xOXkyUk54ejlqSmdmMjRlaGxQVDlpQnRSU2NmTFZucW9q?=
 =?utf-8?B?KzliU1BqdU1QNGhuc3hadTlTdkFNcXdMM0ZYMFJRZGc1cjJHeDIzeFc3Smc1?=
 =?utf-8?B?bkdGREpJVUtyKzRLd3lFUEd1Ukp0RE5hUHNjcTFJd0pRZHJIeEs1T2J3a1Fv?=
 =?utf-8?B?OXN6SDYzVXJwQ0QvTWw5VElZSWFVeWtqaVZ1U3E4SndrRlRCUUZGUklXZ0Vj?=
 =?utf-8?B?cnlrT3ZjYnd1Rll3REpneFVJakhMcngyVjJHTk1Wc2MrQlVLeUx0WVRYOEpp?=
 =?utf-8?B?Y0tiZHB3Zkl4SUxnWGw0cGJMTWQ5WlJTOHF2T0pYOEczclFrUVQreUp1MFcz?=
 =?utf-8?B?OGlyQldOVjRZWlhZU2RNdHFiMWVqSGprdkFDcm9IcXoyME5xUkV3OWhaVTYz?=
 =?utf-8?B?dDdOTzJVUEpTcFRZSkZhalNMN0Jjdnk3eXEweGRZNStXU2tSK0c0YVNJNGl2?=
 =?utf-8?B?NDVyYlNLNDdRS083TEtIVEl2aS9uQVoxUXpERkJ3VmcycGhpb0gya1k5dTZP?=
 =?utf-8?B?YzR3MklVTFZCRGMvUlphMEVIRk9BV3FKaVEwV1c2bGZqdXNBMmUyZGlOQmo2?=
 =?utf-8?B?c2RnbHpWMEJqUnY4ejhiU0JIOXlseHJiWkNyTVAzZytuT0txdU9vT0ZPR3N0?=
 =?utf-8?B?dVJsSzlRYXNzeDQybEdPOFYzeloyQzVTeDQrNk9kRFc5WU1hcis1LzdyajBY?=
 =?utf-8?Q?cxt7F9+zyUa9N424yj7aMd3j6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb8fc2a1-d4b3-4b06-0b50-08daf32838de
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 16:32:10.6226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EW2YZttxPm8Vz9vdWWUj3pjsQyxcIbgRFuRfYGwFSu7mLr+fLubnNuxMzKlhE0LLUj6YmRIO+DVppUiCczrTvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5207
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/9/23 10:08, Peter Gonda wrote:
> KVM_SEV_SEND_UPDATE_DATA and KVM_SEV_RECEIVE_UPDATE_DATA have an integer
> overflow issue. Params.guest_len and offset are both 32bite wide, with a
> large params.guest_len the check to confirm a page boundary is not
> crossed can falsely pass:
> 
>      /* Check if we are crossing the page boundary *
>      offset = params.guest_uaddr & (PAGE_SIZE - 1);
>      if ((params.guest_len + offset > PAGE_SIZE))
> 
> Add an additional check to this conditional to confirm that
> params.guest_len itself is not greater than PAGE_SIZE.
> 
> The current code is can only overflow with a params.guest_len of greater
> than 0xfffff000. And the FW spec says these commands fail with lengths
> greater than 16KB. So this issue should not be a security concern
> 
> Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
> Fixes: d3d1af85e2c7 ("KVM: SVM: Add KVM_SEND_UPDATE_DATA command")
> Reported-by: Andy Nguyen <theflow@google.com>
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   arch/x86/kvm/svm/sev.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 273cba809328..9451de72f917 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1294,7 +1294,7 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   	/* Check if we are crossing the page boundary */
>   	offset = params.guest_uaddr & (PAGE_SIZE - 1);
> -	if ((params.guest_len + offset > PAGE_SIZE))
> +	if (params.guest_len > PAGE_SIZE || (params.guest_len + offset > PAGE_SIZE))

I see the original if statement had double parentheses, which looks
strange. Should this if (and the one below) be:

	if (params.guest_len > PAGE_SIZE || (params.guest_len + offset) > PAGE_SIZE)

Thanks,
Tom

>   		return -EINVAL;
>   
>   	/* Pin guest memory */
> @@ -1474,7 +1474,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   	/* Check if we are crossing the page boundary */
>   	offset = params.guest_uaddr & (PAGE_SIZE - 1);
> -	if ((params.guest_len + offset > PAGE_SIZE))
> +	if (params.guest_len > PAGE_SIZE || (params.guest_len + offset > PAGE_SIZE))
>   		return -EINVAL;
>   
>   	hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
