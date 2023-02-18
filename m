Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E4269B7BB
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 03:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBRC0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 21:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBRC0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 21:26:08 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2077.outbound.protection.outlook.com [40.107.102.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F4E3CE1C;
        Fri, 17 Feb 2023 18:26:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPfnc+k2YlocXZqOExJifHnYDOkJF4qAUnrHMf3TOVjsifKIJSOmkAveawF0C9ARU3PuSq1HTDwS++miU89rAiFfc4GyX51gZvYAG5dK3kwWXl5/dMW6ztWkKvrdiCk7QUk1y1KbkCQ5qslISBrXhD5g+sRQ1xK8jrvprYwuQWuT1oFxmZPRM/b0rg9cNj6+yxFZqDdhrIUFNNqORVsNTfYAebyAxIzQzFGuCjvvb4AHvhAIfu2kUXNXCWapEdL7EwSxh8LqD+5KV0aUnc/fnO9JBslJyOh3aaJRtB5MfYrs9SqVoQBGgyqEg7d7MFNO9ToVkaQvknBmRY5O7604bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZlACXHid7PB8ZhBYFSbdIxkonLmG6T4hbrM7izHf+U=;
 b=NoDqtOjd1IkcFbW1AFftslEFBqsB8sjJkMtEA25QHiKL/7B0j+AhkLfIcLwm+RuReHsEag433SmF9f8LgfZhPV2SasbBDXdHC+Nyd3LJZ79SlWwz/jc/9ssUTezfn3/fYm06Dr4lmtc0kH7ZGakcoGhsIwAxnbY/FOMdljzLas10pQliIAbCErlPYSPp5+YW+wZiCmbHYV2cXUdQhN7AGpXLnpiBEKCOOF9lRegnrgM6ozTCoAKb6MCIyA0iJIyWDDLy7i3BB933107X8EiiNWJaV2zU/Ar5GoTEoItvxIFM3FxaC9MjS5hJJ/K0V0W74IWyecM0ATC7UTiO4qFMZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZlACXHid7PB8ZhBYFSbdIxkonLmG6T4hbrM7izHf+U=;
 b=Iy1XtdzTxyIhLZLopuE4jqJiARc/a6AEm/NOz+sE662JqfJiUTpqVBFTPBr6YnrcgeMJio15G6mDxSpdorAn6GGQfgwVXA/gmiyhoYfYmEXTxo6GuHcmYXexdH6hmngUoGnvelXAXhr470NYdosCBYN39Gwycw9y9XIiiCu01A8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DS7PR12MB6168.namprd12.prod.outlook.com (2603:10b6:8:97::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.15; Sat, 18 Feb 2023 02:25:59 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%6]) with mapi id 15.20.6111.013; Sat, 18 Feb 2023
 02:25:58 +0000
Message-ID: <03c045b5-73f8-0522-9966-472404068949@amd.com>
Date:   Fri, 17 Feb 2023 20:25:56 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 1/1] tpm: disable hwrng for fTPM on some AMD designs
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jason@zx2c4.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <20230214201955.7461-1-mario.limonciello@amd.com>
 <20230214201955.7461-2-mario.limonciello@amd.com>
 <50b5498c-38fb-e2e8-63f0-3d5bbc047737@leemhuis.info>
 <Y/ABPhpMQrQgQ72l@kernel.org>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <Y/ABPhpMQrQgQ72l@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:610:b0::23) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|DS7PR12MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: e726470e-e317-4265-e2bd-08db115778ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n+/IZ4f/Gtd09OykU2NUbUX5X5bdiBHrQtPn5y9Kwfxr8eozUnLya2MywzbZpZ+l4NAMGA99HYazdOiN9MTpbWqhrQ8aW8rTU3ZkMPyPzRUPlZ1jX0dCobm4rxCQjCNycviibOytF8nh/bSz84mSm6ioD8hCSlIPdo5dN+w3j6lVO9zpOMZtSHDGs0XopaZTQxh574r9o8Gs1QpI8C5psvmpo8rAJoo0zzPw3Uiv9paByS4wZSdDuzt4toxgaDvtpSDhpOF3aB9bl4JDsFG/FJoBTNreoPBCsTyBeZ6yRHmbL1pQ+NSsLiL5CGMriR+Wg8knAJA+4hWLJqPgqFv2hz/zaNSxoUUsDPk6F+Xtgj4BpCMRjCcYf3LjY3mFr4m3TuMONKppwf7r4nbYeKJIMVFBayw3snVctR5C22mOU7gk41rKvkDEzHx5MyWDgaBOILpax+Se1ajBOk8tVTCJx+FC2KZqe0RFtEknG9GO/v8xvJV8R8jnWUQn7Iz0x+z+FVcX/Yfa3fJy90OU4KM8DfkB6q0jw8hry1YzGEaSkkBISWMKEk4gK28cyAtYbov/QjAKmLi0nxAM3bzkHzG00DztC8+ME6SEyvOa6/BG3PUQgoHx+tnthwcdJcaP0v7wQGXQh+Vz2BfgbYzIqo9/00SXEQ7cEObEghHrbuOAkRv2eoV6nw68lGMazA5TK4s5Zyy7igbYdbqVBlGSt4Nm22tO1neZiMhSIiDRa65eiDw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199018)(86362001)(2906002)(31696002)(38100700002)(31686004)(110136005)(6486002)(53546011)(6512007)(6506007)(54906003)(186003)(478600001)(26005)(36756003)(83380400001)(66556008)(316002)(66476007)(4326008)(8676002)(66946007)(41300700001)(2616005)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUsyeTFySTYxWTFSWnl6RTk0UlMza1R0MDVQNFlQbU1VOXNTU1QvbWZpcDhw?=
 =?utf-8?B?MkpOOVZTaGhDWVpURFNPcnpvVGlsSlFmRkxMRS83SlFCWW9FZzUrNUpxS0Ix?=
 =?utf-8?B?MGRVWEhncUw0Z0VzTVkwUVBYOTRUdVhyTWxiSUNmYzIyWjJVQlBRRjJNeHhp?=
 =?utf-8?B?Z0oxMGtQUzRVK05kVitWTm1Ka1BReEZkWWdzMzdoNmI4UklMS3R0VlllVlFN?=
 =?utf-8?B?ejQ0clRXZGVKS0ZDTEFmdm5GKzFrTDJYclNtdUZreGMwcUV4dXgxNlJTczF0?=
 =?utf-8?B?QUU1MmcyWFg1Uk8rOXlyUEc0blRKVzZDd3FSMVJsdDc3T0RXbXhZWHplelRV?=
 =?utf-8?B?WlFPNzQydFphSjBOenhtWXN6VkRFV3FUdkt2RzNxdTdKQ0VzUWcvU3lDUXN0?=
 =?utf-8?B?QiszZEdqakZ0eCtxanlkM1k4RWdaYkVNbzBmOUMvSjRjcjBRektLZmQrSGFH?=
 =?utf-8?B?Rm1LUXJFcEZDRkx6bUx1RkcxMjB2NGhBQ1dUaHVVQTkrZGZGcEtQbEgxV09z?=
 =?utf-8?B?bGc5WVExeWlyWnVSRjRrRVB3R2kwbFhpRDRTNXNFUDBsdGVIZTAyVWF6WTFL?=
 =?utf-8?B?VURNZXdsNVk4eCtpM3N1dXJsRkV2U2FscmZVS3JUbU8zaGJnTlJiM09tNEZI?=
 =?utf-8?B?cDIyWURDMlZXZ1VxbHArOTk5VndPNGcxRWZXSWdob0pnUmZYKzhiTGJCcTlH?=
 =?utf-8?B?TkJhbVJVMFJPKzloYnIveGdzdTkzME9VUEJsK1FzL2gxUFd2UWlJSDdHUWhE?=
 =?utf-8?B?b0RwSlNad3BLTWVWU3FwQjd4NWZQb25LU1Z5SkNVMVJSMXIyd1BNNGIrVW1m?=
 =?utf-8?B?ZFRxYk5qOFJVUVFaNytsZDFscnNqSGhha3ZwRnA5eHoxN29UbVZNeWpaakcr?=
 =?utf-8?B?ZEtlM0N0djNHRGt3eWlzWWNBaVRzRmNWZ241ZXYwZHRkUU1LdUJ5dktuVDZp?=
 =?utf-8?B?VTN2a2JTeSt5VHZmaUwydWNGQjJUWE1aUEh3bVoxZUVVSmZ5a0pSV0J4SjJV?=
 =?utf-8?B?N1FmQWdCWGV1aVhwMkExbTJHcjR6azlCcVZyZEVsYjRIRkg0cVEwME16R0ZQ?=
 =?utf-8?B?blVQSFFFS2JxYzJGUStYeFdsN0VwMVN0ZXZ0TkVOMnVGOHBZN3VVenJ1SUVj?=
 =?utf-8?B?Y3NmVm05VmlVSzJUMEYwQjBudzVPU0RMWS93RmFvSTJBK0VCUEYxdlJHUTVt?=
 =?utf-8?B?RGJTNGlEMTNWdHk4S3R5b2tPMEwyNmZYb1h2Q1pST0xkV0JRQ0M1a0RBVWl0?=
 =?utf-8?B?TUtXVndXSndHVjNoK0pXWFNXajRCUS90WjNBdTlSdzRSQnM2clZsaGVsMXNv?=
 =?utf-8?B?bkpZOExadXJuYlI1cXQyckoyVjMvbDhkYlF5T1JFVzdqY3JGQzllYTlSYXRi?=
 =?utf-8?B?RzQ4TlYvWTN0UEpzc2hUTHVoNlBJc1JZSjIzL1hEaGRRc2FSUDdFWmoyMjlY?=
 =?utf-8?B?TWxMUnJSUUVsV2wzQW1NUG9sVjQ0ZWh1SXF6d29Yek1aelVnWHZyM2dMY3do?=
 =?utf-8?B?aXY5SE43c1ZOWk51M2RkNWt1KzVLM2ZqSnlicmUvMWdCcWRySDRZOW1xaUcv?=
 =?utf-8?B?Q0JBYytFSHNrNGhpbzZBbysyMmhPcDlWd2Z6clA5VElNbkhSSzZyN3lQLzJr?=
 =?utf-8?B?dWxNbUtubm1uSStnVFNvaUFBUXE5ZXMrbUxJdmtjaExWUk4xaityVE5NQWwv?=
 =?utf-8?B?NnloWGc0c0NYNFA1ZHRSbDZjOWFXNkFFSDV3Qm9XdW1xOEZ2NHRjWFRKd2JV?=
 =?utf-8?B?Y052QldCTWxNNElTZm5iaWtQWDVVVGcraVVZakpmeUNaL1pWZW9DYlUzU2Ux?=
 =?utf-8?B?bDA2U0ZORUN0aHFtYld3c1MxbFlKVGdJM3NKc2hTSTFwQzc4M0ZpamsvTXB1?=
 =?utf-8?B?QmVSamp5YmpxN0pNYUJORjJvM0R3UTBycld0a0c2amdTYlJERjBvTXVFcmkx?=
 =?utf-8?B?ZFJQWFYvUVFxOXhnQkVmQ1loYzV4WXRla0VQS0xVcC9SVXBKMWU0TkoyeGJ6?=
 =?utf-8?B?Z3J2QXRNa3VEZVNvS1kxSG1BVGJTb2p1N1pmeUdBYWxoSUNIRFRyanZ3SDY1?=
 =?utf-8?B?SGx4RWY2cUlPd09VY1AvdXdYYjlYb01kRDFTTnNlWHBNcktoQnZseVQvOHJX?=
 =?utf-8?Q?UpD8o47X9O9sHK0EbN2abUzUk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e726470e-e317-4265-e2bd-08db115778ac
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2023 02:25:58.8886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AGw+uHCF2o5XZaDspMyDbFCKYGzrIUXhA4SKS5ewgCaiGCWMgUJLAF2WFq1ksICapiE0wpbbxNsqVyZuOAry5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6168
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/17/2023 16:05, Jarkko Sakkinen wrote:

 > Perhaps tpm_amd_* ?

When Jason first proposed this patch I feel the intent was it could 
cover multiple deficiencies.
But as this is the only one for now, sure re-naming it is fine.

 >
 > Also, just a question: is there any legit use for fTPM's, which are not
 > updated? I.e. why would want tpm_crb to initialize with a dysfunctional
 > firmware?>
 > I.e. the existential question is: is it better to workaround the 
issue and
 > let pass through, or make the user aware that the firmware would really
 > need an update.
 >

On 2/17/2023 16:35, Jarkko Sakkinen wrote:
>>
>> Hmm, no reply since Mario posted this.
>>
>> Jarkko, James, what's your stance on this? Does the patch look fine from
>> your point of view? And does the situation justify merging this on the
>> last minute for 6.2? Or should we merge it early for 6.3 and then
>> backport to stable?
>>
>> Ciao, Thorsten
> 
> As I stated in earlier response: do we want to forbid tpm_crb in this case
> or do we want to pass-through with a faulty firmware?
> 
> Not weighting either choice here I just don't see any motivating points
> in the commit message to pick either, that's all.
> 
> BR, Jarkko

Even if you're not using RNG functionality you can still do plenty of 
other things with the TPM.  The RNG functionality is what tripped up 
this issue though.  All of these issues were only raised because the 
kernel started using it by default for RNG and userspace wants random 
numbers all the time.

If the firmware was easily updatable from all the OEMs I would lean on 
trying to encourage people to update.  But alas this has been available 
for over a year and a sizable number of OEMs haven't distributed a fix.

The major issue I see with forbidding tpm_crb is that users may have 
been using the fTPM for something and taking it away in an update could 
lead to a no-boot scenario if they're (for example) tying a policy to 
PCR values and can no longer access those.

If the consensus were to go that direction instead I would want to see a 
module parameter that lets users turn on the fTPM even knowing this 
problem exists so they could recover.  That all seems pretty expensive 
to me for this problem.
