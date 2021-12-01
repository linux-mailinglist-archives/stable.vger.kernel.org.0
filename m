Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CD9464F58
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 15:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349616AbhLAOJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 09:09:28 -0500
Received: from mail-bn8nam08on2054.outbound.protection.outlook.com ([40.107.100.54]:8800
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244709AbhLAOJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Dec 2021 09:09:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/M2MNngxTn1TSGHy7ekvY/m3AYw2L5+Ivi+hJudfNA07vtp1XV1X2sWsLhVL3jvR9uYAJb82Hg+SjqKjuzWqT/2RM0jZQarlBKISM91A5LKWso7UVmI5fx/6l7QlNaPjQrg1J1C5yDmqujcmbqn1fZpbMAJVx1Z2WEjd8D7SkQSEp9a0I71GlniZUDZ1cXCMuYK9gg/1WvQA3GyfppfAAGZjy2vHciYdIf/qPJJm5AWTS+W51KhT4dilIF3cotJ/d4DFAj+6Q6vuQzuDQPhXs3cn2Knjf9ZLzKXUKCS3hYvfylX2vL27iP12jX6rQfsoy4pg7s5X8n5/ZXyAtHTIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2SVQdCyY5kZZxPU5G3TsbEFAJD0NdFfH8XbKUIm+vg=;
 b=T6cG7gnlqpUKnd1XxpcaqWfv1gokd6vQvnD1BVq4jRJ+Vt0R3kdL5r4sNdmSUhgjkfo+6OJrUxMlszSHz0iu8zmDRe7vz1M7DhAnIwcoAHky4k1cQqzo/53xZFzmqx3Z4fWWmnqVagdvzoAo8RSQIHzfc9DEzjasay1R+xvBclpQV5RxfMuw6Wlq26wj6Hf7dyys8v8hKTGv9pNtPiPZb95kb8uf3l3FzXbP/9YfPdBnhydXl3kmV68WR1nHbj9Alde1RJGnxqfl8LB4M477RGqYPZeVae/00ELZdrFyEDNmgb+wbB7022XAATwRWpdhQUHQFmy25HLkLrUQ9EI25Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2SVQdCyY5kZZxPU5G3TsbEFAJD0NdFfH8XbKUIm+vg=;
 b=QlZ8NlBySrlkOu+KiaJ1Ofzl5ceCGnbD0nRms/FMWqBhnbzwzS02SZXh90jNbpGIfWG1HAs12Dn01K1AfTMm5r1352EmC+YXU5oVCBt76ln7fCuOj2Fa8CIo0898aLq4eyccnTKg1lKzHMaBZsafWdu5x+ZgdQNsdmCwdyf2tj4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:39a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Wed, 1 Dec
 2021 14:06:02 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.020; Wed, 1 Dec 2021
 14:06:02 +0000
Subject: Re: [PATCH v2] x86/sme: Explicitly map new EFI memmap table as
 encrypted
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
References: <8afff0c64feb6b96db36112cb865243f4ae280ca.1634922135.git.thomas.lendacky@amd.com>
 <c997e8a2-b364-2a8e-d247-438e9d937a1e@amd.com>
 <CAMj1kXGH7aGR==o1L2dnA9U9L==gM0__10UGznnyZwkHrT84sw@mail.gmail.com>
 <YXmEo8iMNIn1esYC@zn.tnic>
 <CAMj1kXEZkw99MPssHWFRL_k0okeGF47VYL+o8p72hBWkqW927g@mail.gmail.com>
 <f939e968-149f-1caf-c1fb-5939eafae31c@amd.com>
Message-ID: <15ceb556-0b56-2833-206e-0cf9b9d2cb45@amd.com>
Date:   Wed, 1 Dec 2021 08:05:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <f939e968-149f-1caf-c1fb-5939eafae31c@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0136.namprd02.prod.outlook.com
 (2603:10b6:208:35::41) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by BL0PR02CA0136.namprd02.prod.outlook.com (2603:10b6:208:35::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Wed, 1 Dec 2021 14:06:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d37dbd83-66e6-4026-d9ac-08d9b4d3b4b9
X-MS-TrafficTypeDiagnostic: DM4PR12MB5390:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5390F6E550223CF60D7F8A44EC689@DM4PR12MB5390.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o0GZBJYWmA1q7z6ny8fCpGBwJWwr16FWQ64YxN1z+s9LQRjGFZcuS1QmPCc2i3iVIY2SAphdxDFkClEEqGJ1IIiBQFYEy65I3yBh8IH7FbX3G5kYWuZ2LXXEivg2VJikyHg8GhJ4PCLCwHJiKt+a9ruh1Np+3W2erhdE6hIxjpTqp+r6EdA3P8UngvVpfr60mln40XXSr0dyxa1tGS30kEanvYqxnJpXh3m5EyBh4nZlbo3q+7yyI5F0exetYRTURGMM/JH9ModZQG9liTxOFEUfxu4HOKH8QqOJZMeu7gh2ICkFegvz3FDxHS5coxGTkD8EGSYn5annuX9TsLbCgm13S3hTJjHxmlov0+uiRtDj4CWA1MOY6VGDylt7pBxClMyeDhq0iFnT90c4QW1JJ/57Ifan6D44W6vp7h/LFz4/YRiVSFH+xk92wV4259cM+U55jkOhRMIqE0u4lRtTx9sOHCRYvaaAcLoyd+FVeRcs+Iir/8AH0jU3t/na03C6mVLdSHSw4y9Sz973YeZ7ktkODgInWCfcBfTgy26nRZlAlQpCHcaYJBDNbQ6eV7RNhpLjiiy8Xv45HmKNTCIXz0BvPEkmfI00G52EcpqTNjqjUdSRpb+eWh0Y6OogfosK3lLRq46kKTwjcKntm/67PtxeD4bAQoUvT0a/2ENYnhpmRpFHuIy5Y9LXydcCDvgO25m9Ytl4C6bjfrbtaHaOR/OfL3L5zCokIGUCPntSXn8fB0eOysXsH2NCy6rwY4KM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(2906002)(508600001)(83380400001)(110136005)(16576012)(8936002)(31696002)(7416002)(53546011)(2616005)(8676002)(956004)(66556008)(38100700002)(31686004)(66946007)(186003)(4326008)(54906003)(36756003)(6486002)(26005)(86362001)(66476007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enlrN0JGS28xK2JRN2N3ODd0cG5vMWRFaElQMVIwN2dLYlZ3c2NkK2g4dG1D?=
 =?utf-8?B?QnFkYTUxbnV2YUd1dk11UUVwYUJPbzVGUmd3YkVFelUxWktTcDVlVUUwSGRj?=
 =?utf-8?B?VEV3dVNXV1RzQjRpeXpZMDNjRVhvVlJZdFdXckZNL21DNm9Fc0FSa2ltR05q?=
 =?utf-8?B?aE5XaVpxajV1c2VmNTQ2Y2p6NlBueU1jL1EyTDdzVElpN1dQS0tobDQzazQ3?=
 =?utf-8?B?RXFoUFRQdFNRLzlnR29ENVRuVHFtQ3pxbWNNQWxIeVJIODlZbi9YdGlLWi80?=
 =?utf-8?B?dVllOTRpd3hHaG9sVXA0REdoeVJGL0tKSThHUG1OKzBNVHhxak1udEZma1Nz?=
 =?utf-8?B?ekVWVXl3bUZGY3piYWhOQ1R1MFgyK0hGbUpxTCtmakgyYWFhRWF3UDhlT0h0?=
 =?utf-8?B?RlJZVjdndDZoUnMxc3lIN3BTeU1NZ2R3WHNtUlBvamlDcGdXbTRKcmJ6ZkFp?=
 =?utf-8?B?MDZHQlFMdHZxZEQ0bitkUXJIN1hlNjgzUDRtellBVmRlekNvVnNUSHJrZ0Zo?=
 =?utf-8?B?U2pkMUlDUkllVE10dVBvdnhlbi92UVJvbXA5SWV4TjZIWGlwRGFZZU5UbDZR?=
 =?utf-8?B?QzFHcXZobWNObGdoMFR5UlJDWFhzaG1vdU50c1IwTTZhcWJoNEdhTiszM0Jm?=
 =?utf-8?B?ZHBYaUpPbzNxdDhUOTNYU0c1R2Yzb2RYcE5uL1pHcHFrN2xUd20xZGszTDlZ?=
 =?utf-8?B?N3pzUW1mSFp5bnd1eHIzVWN6VEwybTZBcTQyV1lIY1JLV2FKTWpOeFBDRnVI?=
 =?utf-8?B?bkY1bVkvNVg1Y2tGemFja2tpQ3JTNE40QzJTdTJCVG9WdFlRdDd4dVVjTGky?=
 =?utf-8?B?WUU4VmpkQVdxdGRNNHlGMU4vb004WjhTdGpoTm1SMXpJUkR3RXVZbnJLOHdT?=
 =?utf-8?B?d1gwdEUwUlJwM1E1UGpWU1NGZVRoNERsZGRzaGRndEtEbUFTd3BZTFIxZW1m?=
 =?utf-8?B?TWIxRnZxaDdLWUlRZGFFbXZEOUZYa2RSYkNEZ0ZacHBMY2lLZmxMWFZmbU5D?=
 =?utf-8?B?ZnlpVUI4WUZtM0pLM2pib1FOQ0JSQ25zcUFZSWNDaFVCdyt2NURoR3ZIWCt5?=
 =?utf-8?B?MjZucDZ2azRzSEl2N2FFZWxPNklCcTMxa1dEUjBTdEgxRDRJcFNjOWlBSzdl?=
 =?utf-8?B?cUtnRzJWUnlpc005QXhXUTRETERVZGFqTGo4dzNvWDh4N3R5dFMzU0JxMHN6?=
 =?utf-8?B?dHoxOXBUS2dYajE0ZGlkYys5RUFZNy9RV0R0THg3TE1kaW5zUzdES0xaQTBJ?=
 =?utf-8?B?M2t5am5xcWVJY0piZW1PZVN6Y3VDMGQ2QUx4OEVBOWxZbTFwTUF2WkZkTVda?=
 =?utf-8?B?Q3ZiRXhpRmMwcU4yTHdEM1IxYnBncUhQZ2pKUWd5eUd3VE00dEUzTm1MK2Zk?=
 =?utf-8?B?TkRnQVJUcXZ6UFJRaTg2bjFMUDZZTCtYV1hyVy9LOUtCUit0U0JRM0lLNW1C?=
 =?utf-8?B?bnllMUNzQkc1ektpdTh0cS8rL2ZjZWRCWUo4WTd6YzNyTTl4NUVhS0puTGE4?=
 =?utf-8?B?QkRsZWx1K2wzZElEUHBlZjFNcGZIQjdIcXd5Vk9aRVYxdVNLNDhDMFRyQlZl?=
 =?utf-8?B?WGRrSUVWL3RlYU1wcDJUaHcwWFhFQitKWFNhcXdRRzZpTzN3c3kyU2N6WFhh?=
 =?utf-8?B?amFWWTI5R3lSQ3h2WGFFcWlmZWtxdXdCYmhZOE0vWFNoZVdNUjZ4OGlqNWZO?=
 =?utf-8?B?b0VLWlBkdzQ0aVp4eFlPL21mU01JZ2E0QUowY0J2SnlCV3RWQTh0T2xvZEJD?=
 =?utf-8?B?T1dGWXVtRHovQW1hd1A5eVB2ZFhLZlpHa1JwWGc1Z3N5QWhVL2wzVTZ4cUJI?=
 =?utf-8?B?VTFmRkwzUXUzb3R2V3NZeVZ3TVRBckJzdWJyRmFSaGpmK1VmMFNQZGYzbnVS?=
 =?utf-8?B?WmM5N0VaNFBLcWpkeTFjZno2ellQbFF6b0RMRzhmYjRLRHpEK09FRFVzVnRk?=
 =?utf-8?B?c2t3U2FxcHI0eWtsSlZlQ0p5YTdsY2VKYlo4UVQyTVZaWERRb3RaOE44ZXpC?=
 =?utf-8?B?elJ1OUt0cnRIR3lCOExJZGNSZmUzVTVWSkJRYi90Z21qRGF0N2x4eHBla3dh?=
 =?utf-8?B?U2NHNFFZSW9JWTIrSEZDRG9oWkVrNVVYV0hNcEFFeCtObWptWmM4RGZKWHJt?=
 =?utf-8?B?bkpqbHpZTmlWbGxYVlA5dUZMbHJud2hFZFhBR2RNZEI2RnNzUkpoVmt3V3VL?=
 =?utf-8?Q?zAB3dWm0U6OYQRAdriomzfk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d37dbd83-66e6-4026-d9ac-08d9b4d3b4b9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 14:06:02.0480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tM81zmcX9FlBQdI/wNaFRh0go5fwWTrzlMj0EFbZ9Ao/IDQo463AsgOLwxkzeM5UO36VXhBAzqcmHbq0XL6R+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5390
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/21 12:04 PM, Tom Lendacky wrote:
> 
> 
> On 10/27/21 11:59 AM, Ard Biesheuvel wrote:
>> On Wed, 27 Oct 2021 at 18:56, Borislav Petkov <bp@alien8.de> wrote:
>>>
>>> On Wed, Oct 27, 2021 at 05:14:35PM +0200, Ard Biesheuvel wrote:
>>>> I could take it, but since it will ultimately go through -tip anyway,
>>>> perhaps better if they just take it directly? (This will change after
>>>> the next -rc1 though)
>>>>
>>>> Boris?
>>>
>>> Yeah, I'm being told this is not urgent enough to rush in now so you
>>> could queue it into your fixes branch for 5.16 once -rc1 is out and send
>>> it to Linus then. The stable tag is just so it gets backported to the
>>> respective trees.
>>>
>>> But if you prefer I should take it, then I can queue it after -rc1.
>>> It'll boil down to the same thing though.
>>>
>>
>> No, in that case, I can take it myself.
>>
>> Tom, does that work for you?
> 
> Yup, that works for me. Thanks guys!

I don't see this in any tree yet, so just a gentle reminder in case it 
dropped off the radar.

Thanks,
Tom

> 
> Tom
> 
>>
