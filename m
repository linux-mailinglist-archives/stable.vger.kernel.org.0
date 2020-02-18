Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 534E9163527
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 22:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgBRVfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 16:35:32 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:14432
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726634AbgBRVfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 16:35:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7Hh9iVRPP9RLxy0f/g/4cba/ngM7HADfPLySNKJOcqeN91C1FvHR8L7DBI6oIlQ4t/LSLifbWjGau9/iZC4Iv5CtWoWYBVcPt58UBQml/OxTXi7TrLC8OEKY1Tg49W0p1QC4lYG77+g2xlcAUgDS5zagtEJWbxjCe/PRxcXCUvcsz89VdSoBXNUEibR47WP6yEufcGzz6/FQ8lZq/bs1lXRJjpWyXn+dI4GKRC0F/oBEzXmvT257hf0W3qrJqQVATQXlEWfj9ZcJqwRaezFGWpTMhz5f4zLrn1lI6k0GoDLAEdp4Rr1wfjg87o5UnNXrR5SH/y3efcidYZZi4mNFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+S8wZ/ftY8WNhKnbKcd4mYoQTIzxGj7dLTm7d0tAts=;
 b=nqd/IAC2qyqQ55PBjaCazZXhAv+MSbphyLezHXB6nNhEcNKpbVLu/Sl2JLH7C0oRAlgrrdfi0qGm/In5xU0S4Mhb3PJNKom64Q0y/j9pqMaQ1G2sbd6PRZv0yiZH6hQRIJmwPbDOHa+45EklaiScnKOjIInhKGkIJJa6JjkOd7jHM3ZzyCGHfBnTIt/+oIIo8Hqhp04YjAXSiu+/z0rtP0kFjqWu87PdVPDPeWhiX00Dn64u4TevvReHsjgHtrB92+ghNUIHYtIDLHkJosDeBgKQZ73/p23NP4+EHI/x5tgRKqwABP3hAp/XoXcEzZ1Oanzz+ooIB5flEFW6qe21tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+S8wZ/ftY8WNhKnbKcd4mYoQTIzxGj7dLTm7d0tAts=;
 b=VuOEkLcxd7Y+r++NDs700hmpxzf9443j7cV597pVQfykg8mmyAFs1E5/EjGPzAYNcDyP9zITTOS0xZAlUq0cFMjNTnKSZ0kfP7B96uq+u1RMlRu60hwSny+zc9w/3iP2OZ+00Lo5cM42KRgKuXYeWJtinphzxe5XSMDO7eAFnk0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (52.135.106.33) by
 SN6PR12MB2686.namprd12.prod.outlook.com (52.135.104.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.30; Tue, 18 Feb 2020 21:35:29 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b%7]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 21:35:29 +0000
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH v3] x86/cpu/amd: Enable the fixed Instructions Retired
 counter IRPERF
To:     Borislav Petkov <bp@alien8.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Babu Moger <babu.moger@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Frank van der Linden <fllinden@amazon.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Huang Rui <ray.huang@amd.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Jan Beulich <jbeulich@suse.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luwei Kang <luwei.kang@intel.com>,
        =?UTF-8?Q?Martin_Li=c5=a1ka?= <mliska@suse.cz>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200214201805.13830-1-kim.phillips@amd.com>
 <20200218112035.GB14449@zn.tnic>
Message-ID: <15f0ff78-1a94-cfa7-297b-c226cb98d10f@amd.com>
Date:   Tue, 18 Feb 2020 15:35:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200218112035.GB14449@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0109.namprd05.prod.outlook.com
 (2603:10b6:803:42::26) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
Received: from [10.236.136.247] (165.204.77.1) by SN4PR0501CA0109.namprd05.prod.outlook.com (2603:10b6:803:42::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.6 via Frontend Transport; Tue, 18 Feb 2020 21:35:26 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7153cd2c-2d87-485b-86f5-08d7b4ba78a9
X-MS-TrafficTypeDiagnostic: SN6PR12MB2686:|SN6PR12MB2686:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26868080463D9A72AFDEB51A87110@SN6PR12MB2686.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(189003)(199004)(8676002)(8936002)(44832011)(54906003)(7416002)(81156014)(81166006)(316002)(2616005)(16576012)(956004)(53546011)(16526019)(52116002)(478600001)(6486002)(31696002)(31686004)(4326008)(2906002)(6916009)(5660300002)(66946007)(36756003)(26005)(66556008)(66476007)(86362001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2686;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +i2dtM1MxwOUZMgoEPv/42q5KqfrL9OclwexdNROaZ+5m2ACfSpY9IE604I5h39jeqUUJeOnMFxsnWTvhoaGoN5m7Amsy3O350OJEQRo2c8LVt6VPbshzeWVgy/uTDFSnPHcP46hltA2UifZL4uULy4HZ1vHV9gD+Y060gI2cX9wg9gwCSJ3YUM63q7ThUv8LNkM8XPhQt1bap6iTZzh78r/sW/Of5OhTijDHXcDhwxPnitts+nx3t3Qp8cyyBlVgB1bavyqIFnJIAb93b6SrPKFNsgYfj0c3EYp3pCFBg0m6WS/OuCMITyrK+2HeHiN5pdMKIm4flBLkZ3AmHoIxH70UE1wYDREEF8PzBgYswovncoPuGBo1CGkL2vge5iNRer/ECV4Bikp3qDUwzyAASoFVT6VBeGPBc4KL8VvrabHbaqClCVRhW7y81pA5ptO
X-MS-Exchange-AntiSpam-MessageData: fye5WnUlqkJLsCP6L5HQ0LQ3XJetH/laujszLhnGwwY4+sYbG78nODhJfZ7/1m/v71fe6D5c4pcqFDYlfGpX/ZusQ+WFrfYXtGNl6Sx5NiDJnSPpG3kOEye8eZ0KSW+qrXkQMREQ7toCqDicXQbbWg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7153cd2c-2d87-485b-86f5-08d7b4ba78a9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2020 21:35:29.1239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wpMHILqZW6UW1fSIXBSnSCJH+ZKJajfAzQogdGlLZ61H4QqmDTklXNHZ92BK9PoDrUFg2GBSBDK2bL1y8BbHtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2686
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Borislav,

On 2/18/20 5:20 AM, Borislav Petkov wrote:
> On Fri, Feb 14, 2020 at 02:18:05PM -0600, Kim Phillips wrote:
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index f3327cb56edf..8979d6fcc79c 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -404,5 +404,6 @@
>>  #define X86_BUG_SWAPGS			X86_BUG(21) /* CPU is affected by speculation through SWAPGS */
>>  #define X86_BUG_TAA			X86_BUG(22) /* CPU is affected by TSX Async Abort(TAA) */
>>  #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
>> +#define X86_BUG_IRPERF			X86_BUG(24) /* CPU is affected by Instructions Retired counter Erratum 1054 */
> 
> Do you need this bug flag at all?
> 
> If the only reason for its existence is to check it before setting
> the MSR bit enabling IRPERF, then you don't need it. Or is there any
> particular reason why it should show in /proc/cpuinfo?
> 
> IOW, does this work too?

Yes, that works quite nicely, and saves us a bug bit.

The only reason to have it show in /proc/cpuinfo is for userspace,
but they can check for a nonzero count prior to using, instead.

Let me know if you'd like me to send a v4, or if you will just apply
this version of yours.

Thanks,

Kim
