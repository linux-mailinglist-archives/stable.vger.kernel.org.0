Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F2B397827
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 18:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhFAQiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 12:38:21 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:37063
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231918AbhFAQiU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 12:38:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oF3Gb63ulld6iLo7vHsI+3nz2MKloKbaf8ibZHPOspJNc5XGu/YsXJYxavja6s8s0P/GvqR9d3vk6hkKIL6O74gzCTOIKDleFCP4QxZRuFohm08/V9EKEPY8skwcwnYhQIH9BxGoRT2CKnbRx9ghlB06j+1Na8Yd7AzTe4ThLVkFjnJUbwz046+hFEfkfqwB1OfClts77Uwv8DrPTJmUewBZmpqezrnm5HwGmRrlAG8huEpYqRXqjbKHnEYqoGZJz7aDGQfwQXAImrhficz1ZDU4TiX7kLp00J2q18TjafoIe2yYQ3fzI3nyI8HU6cmc8Ae+yLjfLgSlX4gD3fVkcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GsdBc8n5XPgCtR5m+YRKkzDXHZBbAjhhFPWM0wStbI=;
 b=PltW5JoLhh5egnbah+s5DHyCejrzqqhiiNHWsUwXeF+Dg32h0s8Ss75f9ZR0GT40CpKvvb+9YAOgQ6gzGBYrkzf3mCPqB4PWIlz2RlQ+c9nufqEEBU9xzg0YnTMrqZ5P6r1y3wKDsocsgHVmTe+ktyJIHkALJ0N3rHHQVuHWUPLFtbHovIX5x5Oodweac7/ixHUlZDBL5S2CVQ/DpIuKj7nFiOheJgf/o3ojigqKL5DGXcQOfi+6vhWASryGIAeC7eX3CfyEMsxrTLKsaQP2xunEbG1IDIBZNQ9F5+UmrD211FA1xeNO2xFL8O4ScyBytGVlIDzntqRqvt+2l4jBUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GsdBc8n5XPgCtR5m+YRKkzDXHZBbAjhhFPWM0wStbI=;
 b=TA8RpTSTXIW+SwYKcetx6eYKy5xob4wEjps/o5a0UJT45nhBDVI+zRvFGJYiuFYjFEyddpYN8crAjr8HScL6tWm5B5Z30mr2mo9Q7TmyE6ao3lMqwDuUQeuKQuXmmDqL2njqaqx6cVFQB5H7H3Cc2we+nErxI6ET3h93YAUI9/I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.20; Tue, 1 Jun 2021 16:36:35 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 16:36:35 +0000
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     Pu Wen <puwen@hygon.cn>, Joerg Roedel <jroedel@suse.de>,
        x86@kernel.org, joro@8bytes.org, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, sashal@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20210526072424.22453-1-puwen@hygon.cn>
 <YK6E5NnmRpYYDMTA@google.com> <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
 <YLSuRBzM6piigP8t@suse.de> <e1ad087e-a951-4128-923e-867a8b38ecec@hygon.cn>
 <YLZGuTYXDin2K9wx@zn.tnic> <YLZc3sFKSjpd2yPS@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <dbc4e48f-187a-4b2d-2625-b62d334f60b2@amd.com>
Date:   Tue, 1 Jun 2021 11:36:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YLZc3sFKSjpd2yPS@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:806:a7::20) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR10CA0015.namprd10.prod.outlook.com (2603:10b6:806:a7::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend Transport; Tue, 1 Jun 2021 16:36:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8a2d9b9-b774-4adf-71ba-08d9251b6b5d
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2988CBE42326C60CD4658FBFEC3E9@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6nYlBwge119La6/Vw3CJ1h19Wcig48OQPWUcwEp7dIui5Rjo8PDD81za1SQHAIypcj31rTF/aG3ufRSOTFvcqKaL/B4E2MzVMWImwXSeQpWqxsm9+d8Hv0uuFBi7y9PZ6soxtPEfBSjPHeRhJyTqsDa+bvC0vKPXrajWPrQiXggIOBPJFIl2WswVIzvuIbAp3nNuuijZt0e+gR5JPuOjToGFnu5P9nnBplR+DGfQjbF9PzU3gfPWopndqVlrrkt7AHf+MjSfBpE+1OrN61zPsXQBHpSaPDXkHWClFRFdQGEbYIGnH07jKfI7WUGrfsRNyBN6zrlbBsAY7y/zcYKR/4znoU3YDBXIgKMgqX2fnwf1uUMACkm+Y3rHdQRGUNe+bCZgRG0qquzTV8m3CL+d18dj81TnXOLEEVdp1x9aKqO4f01OXR9dn01kbeKdzfz6dybPH67DY+gNZNMxX11QNZTsgNE7FystZmgzxCu5MiiDqqWVtHTKIAUu9sQ5AE80lfeQAH6QRnhRFKDWNBbEejVtbkF0lFCnSlsHlFgI72kY2Fl/EeDubv71idRObrCuBKnDvNW6NdwKIosEux2gxRmgN1a5bnbMJ7w4QmNLmNRBSOOIl4nP0JDFrR9vCN6cdvmTSbxIx9Gm4CWj5VQcM0i0agsHZmqo5Q603MN/ysR5eZWwjYsqwqJXgBZHvwUJPCN6k9wEHipOSc3JaVBzAWNI2GL4FIKHX/72f8Yr4eIg6SH5s/QAQh5wtjQXAVBokPF2XmOE/PBf5uN6AEqe0k6Mq8vbfmWvMSukR1n2S07Cn/7rnxqPuHrwNChVlm76
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(4326008)(6506007)(53546011)(26005)(478600001)(966005)(5660300002)(54906003)(16526019)(110136005)(66946007)(66476007)(45080400002)(36756003)(2906002)(66556008)(6512007)(316002)(83380400001)(6486002)(186003)(31686004)(7416002)(31696002)(956004)(38100700002)(8936002)(8676002)(86362001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UUhFK1pQaHBuWDZzbkdTOHFTd0lFQmExR1NVYXN3QnE4d3F2M2RJWEVvb3A1?=
 =?utf-8?B?dm9RdGpqTU8zMzRuMlhFVjBhbE1TYmg5R2kxc3BBZkRlaDBYQUZGNEFOdFRm?=
 =?utf-8?B?aUpsRTFIclhKNitJa2JhWmlLMkVoTmJvZGlQYjQ3aElMdTNOZ3pmaW9Jekk2?=
 =?utf-8?B?ZjRrSU9WV1lLU3FhK0ZTd3E4WVNsQVRwSlNBUkJJYzlRNmExQzhaZElZampk?=
 =?utf-8?B?OEVlV0JWVk9iMmNSYTR0OVBsQXJzdmxDOStCWEM4M0tOVVRHVXM2U292MWEy?=
 =?utf-8?B?a1hIMlZKRk5PcXRGVzE0RVNZSVZVcVpOMkxoWm9jekw1ai96UW16UE9Gckoz?=
 =?utf-8?B?SUx6V3BZN2RESlhSdXNEbUk5WFNyMVF5bUI1RXBVd2VCbi84V0Q5M0EyTHBC?=
 =?utf-8?B?S3BENGQ4YzV4YjhBbFBIc2s1aXByUFV4b2hhaUFVVnVuU1Eza3hPbmVZZ08y?=
 =?utf-8?B?alh0VFZVS2lSSTRoMnlkRk1sMjlOKzlybXkxdHZuUHV2TG1KTXVCSzE0V1dL?=
 =?utf-8?B?YktQVHR6M25YR3ppTm51Q0VHQ05EaVB3WUtvaklVTDJrdnFQVUdKaS82RTAw?=
 =?utf-8?B?NXNaVlRhbDcweVM2WmRxNjF4Vk1hZmE3OElCM2lLQ21pRElKdS8wTDhmYmRh?=
 =?utf-8?B?TFFjbmI1K3BFSHdFRDFZVWJvN20xd0l5MjArM1JPYVJ5YzV5YlJmUFRCSHMw?=
 =?utf-8?B?N3VxcVFnWWo1Tm9qLzFYckd4ZWc0dVp6MjRxVEZEVmU3dXFLWFBZQ1hHMEVv?=
 =?utf-8?B?U1hCVlE3YUNCdW1QM2E5OE41VCtuWnRqVmFFRzN5SEloMzA1cEJxbWFzNk50?=
 =?utf-8?B?THNzOFJybkFFSlRLZzFXYUk0QnU1TkFVRjVKaWQ5bzhuSFZYMmtOektVUDN2?=
 =?utf-8?B?b3FxMFhIR2loa0dpdHdReEd4cWNOTjMzMCs1VVZWUHJXMkFMUFVITlF5c1BV?=
 =?utf-8?B?RUwyZzhIZHM5VmdzTWpWc2JQTkF5ci9HODZ3RXBITXk3SjFmWjFWbmY3bktv?=
 =?utf-8?B?MzYvRkIxOHpkTWdyakIrTFBGaVk4dkNybTZaalRabUl4THc2ei90YXJTbHdF?=
 =?utf-8?B?V2VUU0ZPL2ZwbUJsUmtiUDhLbWh5TTRqcFdpQkZ6VWJiejQ4SFArN3V0djhU?=
 =?utf-8?B?SUVSd3VvWjlmTEk2V1pRdk1uY0htazNNMWozYTQrYTkxc0FqZUF0T3Jqd3Ay?=
 =?utf-8?B?Q1RBSUFpbUU0clFrR2tGczRuN0hwZUtwWG9sZkVYRlFzZlJHdEZkVCtqVnlL?=
 =?utf-8?B?V0N6aTNsKzNKcHFacXR4MXpmSk5nbHJoZmdnYTFwRTJ1Q2VpNTRVUFFRTUk4?=
 =?utf-8?B?azZhenhXZ2xyVnVGTmpJT1ZBNW5Da011T0FOa012anlhNXBBL3J2SGowUjVT?=
 =?utf-8?B?Tjc3QjB3dTBVVTZVOGF1MXpxK2NwZjM3UlpJaWpvUUEzWE1ISGxXVGVESWdz?=
 =?utf-8?B?cDBUeVhVZUZMVDBEVjgxdWFSUTNFQy95VHZxcy9HbFBNTHRaWDNpVGNCek84?=
 =?utf-8?B?YkpzMGN5Q1dZU01PODh2dUpCZFVxUHdHam4wL1RqcXBMeGJvUTltVFpwemNW?=
 =?utf-8?B?YUlTT3kzOHVVcGh3N0VWNkJvSTc0WWhXS0xTWkVoa2VBZ1dicXJVS1JWVUN5?=
 =?utf-8?B?M1RkanIzK0xjd2dMS2dTSXZSWkFBckFYVzFWeUhrSmc1bVFHWmZxL2d5QVFD?=
 =?utf-8?B?UnVmbVIzTnp1aEpCdGJEVkxpYy9ScWNPWHA5M1N1NnRYbjN0NmFoR0Z6c0Er?=
 =?utf-8?Q?+rF+VkdL+msdvN3AJRGOV21ybBy5/fefvD2qKRG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a2d9b9-b774-4adf-71ba-08d9251b6b5d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 16:36:34.8505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUEqZI4JqiVRbnC6ALTUpJhVkNChAr2IAqrYk6v8ehuWXqa7ugJMm9l71g3kFQCRkuP2FVXEDPFxB/qOaxcc2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/1/21 11:14 AM, Sean Christopherson wrote:
> On Tue, Jun 01, 2021, Borislav Petkov wrote:
>> On Mon, May 31, 2021 at 10:56:50PM +0800, Pu Wen wrote:
>>> Thanks for your suggestion, I'll try to set up early #GP handler to fix
>>> the problem.
>>
>> Why? AFAICT, you only need to return early in sme_enable() if CPUID is
>> not "AuthenticAMD". Just do that please.
> 
> I don't think that would suffice, presumably MSR_AMD64_SEV doesn't exist on older
> AMD CPUs either.  E.g. there's no mention of MSR 0xC001_0131 in the dev's guide
> from 2015[*].

That is the reason for checking the maximum supported leaf being at least
0x8000001f. If that leaf is supported, we expect the SEV status MSR to be
valid. The problem is that the Hygon ucode does not support the MSR in
question. I'm not sure what it would take for that to be added to their
ucode and just always return 0.

> 
> I also don't see the point in checking the vendor string.  A malicious hypervisor
> can lie about CPUID.0x0 just as easily as it can lie about CPUID.0x8000001f, so
> for SEV the options are to either trust the hypervisor or eat #GPs on RDMSR for
> non-SEV CPUs.  If we go with "trust the hypervisor", then the original patch of
> hoisting the CPUID.0x8000001f check up is simpler than checking the vendor string.

Because a hypervisor can put anything it wants in the CPUID 0x0 /
0x80000000 fields, I don't think we can just check for "AuthenticAMD".

If we want the read of CPUID 0x8000001f done before reading the SEV status
MSR, then the original patch is close, but slightly flawed, e.g. only SME
can be indicated but then MSR_AMD64_SEV can say SEV active.

If we want to introduce support for handling/detecting #GP, this might
become overly complicated because of the very early, identity mapped state
the code is in - especially for backport to stable.

Thanks,
Tom

> 
> 
> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.amd.com%2Fsystem%2Ffiles%2FTechDocs%2F48751_16h_bkdg.pdf&amp;data=04%7C01%7Cthomas.lendacky%40amd.com%7C6025fb08694e4e6b74bb08d92518549a%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637581608717458896%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=CeJXPNxAOPiXQYYXxDKqSrcVBbiY%2FrkQ%2FmPzbRXbSHQ%3D&amp;reserved=0
> 
