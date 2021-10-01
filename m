Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4941EED8
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 15:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhJANrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 09:47:07 -0400
Received: from mail-sn1anam02on2057.outbound.protection.outlook.com ([40.107.96.57]:34242
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230160AbhJANrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 09:47:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nej3DAYHDy9OhCxiLydSC3uleZSpWsdKVDGoNoYbfSCIzt0bHy28PoB9tGZHIXgWcxv6FosHuhOXPiI3tv9Ifg46IdA3Lq0INCWZ2Dnql4LN8agr7wbCW/6nGGkI9LQmS2Fu7k55a4KuU1KL8EnR1gZxKHS/in3MrzyLXz60Dvlm/bZ0TxczirviZaR3VBAcBc7fw8k2G/2eIwsJi6iJp99NyWtM9RI1W698Ae+T82W+7pf7DRPDUk2Rj/H945H1+BjeZp8149i5kbKJxJYTKdu78BQHngWIipRVcCJ4YthoBMMw5u8bERom+gADQnsNGl+9xmFqoRVlJNIQUbSNPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUs2HC6d6X5FMHYVZZqCckMyJ+KbVta8GvL+tqUY4Oo=;
 b=IsQdDLGJkXHlxEatxpAolYpqLMbmkSRctUZdVXY5S/yFLDFtHdWs2afqRBVll5nXGMyKqikAlvFMposvrLkK1Omu4ClE4HGxZoa10JoognicQw+FGQIbrdnmu2/imk5n0nlHkPt4bTR0jH3aScRxPd3dq0fmqX+HD8tMQle2edjKgHqjKw5n8LMUIytUm4fdMsex3wMtBbKiBcO9mi9mGrUovl1FIWvggQBfbh2u/M/VyaQJHG3qIs5pe5jZBGZJ9/0V7tE5mnlL11BYziu1PASDw2jOK4HMLr0+Wi+QaRKr6N6xpdeRVQ0L4aUaP3+fEmtv76Lz8Ebsyd58HrEJOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUs2HC6d6X5FMHYVZZqCckMyJ+KbVta8GvL+tqUY4Oo=;
 b=VU4VGKmGkjOwKEcx6CDh9vijSebpYI+dCo6MEHmFvRJY2KECPvCMycxZl7gU2y3pHDHtDimiP1rRPfUST7A+A3GRdM4gzbHz4idnvd9dvfu5GVToS8JarlyMwd3wFv8KADa6W9krCoZhs8/4ufTNQpPxvkpp9Hy9eyx9CrhgroE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Fri, 1 Oct
 2021 13:45:20 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%7]) with mapi id 15.20.4544.022; Fri, 1 Oct 2021
 13:45:20 +0000
Subject: Re: [PATCH] x86/sev: Return an error on a returned non-zero
 SW_EXITINFO1[31:0]
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org
References: <efc772af831e9e7f517f0439b13b41f56bad8784.1633063321.git.thomas.lendacky@amd.com>
 <YVbYWz+8J7iMTJjc@zn.tnic>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <00d48af4-1683-350c-c334-08968d455e4c@amd.com>
Date:   Fri, 1 Oct 2021 08:45:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YVbYWz+8J7iMTJjc@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0095.namprd04.prod.outlook.com
 (2603:10b6:805:f2::36) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN6PR04CA0095.namprd04.prod.outlook.com (2603:10b6:805:f2::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 13:45:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39fdd7b8-bddd-441f-4ad1-08d984e1b5bf
X-MS-TrafficTypeDiagnostic: DM4PR12MB5133:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5133A0FA4A147DC49D33B142ECAB9@DM4PR12MB5133.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gB9KDBjm6bvNfNie9+Eb1CpecCtCJ1k18TK9MIgsPCiXCbVJepuXFqdbAurmbbMGyJNwRqCp1rsv9jV4eXvQnzh+7oWOKqz6NN22GqBTu1e/IKPDgWcVHttD3gVIbZreS4+tiK+k5cqjQuDwCl1UTq8Zbk7J4tv35tJQzSjZomtxCAgI28RVuXupdWlbgs+nftxrYjAMhAFxhhBwv7+PG3/dzvCVxg/zFX77fc2A02+kUPmeBNglb2o1lBaWbFqXBycn3YcipTCw9Ge/lTlvE84XOH2RWI681Vm2B6mTqtIr12wktU8kWLSUVt8+mTfg6nXKDSQExxjhZlikdy913cmdHyxaRS0rXE1eaRRyi1Bwdb7vPmn+kDPBgDOMf+LypQS+wpZCxE2ED077YQy9YhCTJz9kpEGV/rii5YI9/dBBU4qUQY28PKM2EMAYLX8tFtVNjgd0MNZtnzrJmwZXgb4xXBDcQ/K/koisOI8XPwEmes/gxSWLWYYF67iF1AeYUfcAkbdwbD4wYLc7LBB6x12uPFaz6OJtCVBdoFMskW7rTEOxU1hmOyV+rTmrYvzq52vxf3PyxKg+CkjbB6j65Yoz95GX9UjdUAseiwnwNB8ZnNPzS03eUibfiY2lPxTKrMCLeMcYbJyqMn6s4n6yYkyNH5GxO6pwmYOWr6gMDwYkcM7cndC6OH+KOdkq92yWH2gNmCEO638Ehdaz8arDIhsmmkQLJl7Hq7WFfGQnoG3IAvcgNLqnlFyEZnwIJvS3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8936002)(26005)(36756003)(6916009)(2906002)(86362001)(4744005)(38100700002)(31696002)(66946007)(5660300002)(6506007)(316002)(66476007)(66556008)(53546011)(6512007)(54906003)(4326008)(31686004)(6486002)(83380400001)(508600001)(956004)(2616005)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVhxRzlvaTVCS0VaZDluRldGa1ZoVE03YU5qQ2M0dVRVTkMwMTNxMWdsOTRR?=
 =?utf-8?B?dHZESmZlYjY3ZUt3Y2lrS3dpeXdVVmoxUjR1UnhpWFZKZGdUSnJ5ZUdjOFR1?=
 =?utf-8?B?WHJ6dkFRbmdvRW1ralVwandFVlRoMTR1eUpCak54SWE1RU01UmsrWEJ5R2NN?=
 =?utf-8?B?UCticURlSUZqTGVqQTRaSVVueGhHdjZ6ZmtPaVQ3UnVBa2JvWGF2ekdmUmUy?=
 =?utf-8?B?Z0xUZ2QrRWdxeXM1TmQ0S01LK28yeE5QZW1BOVRqSUdwdXlFSE1oMWQ5dFJF?=
 =?utf-8?B?OTFQZHM4aUdKUlVROHNwMXhBcG80OUY0cGZTQ2t3aDU5MDA2eVNhSGVmenll?=
 =?utf-8?B?UTd2UzVMQi9QL3pJOWU4MklXOE8vQVkwVStDL1UzbTY3UkF5WmtiYmxqRUZi?=
 =?utf-8?B?Qi9pL3RFMGhPM3VJaUxOSmhzTG9IQ05ENkhSRW94TUxiVGtGWHVFYnljaHhQ?=
 =?utf-8?B?MnNLRWdiN2lIMm0yMzV1Y3p3dkJ4TUZOU01RMDhzZHBKVnlyYmpmVTdyQ0s4?=
 =?utf-8?B?OUxkeWlQU1ZKMVlpb1laelhHaEpyWEhpZ3h2MDJYWmtGOHUrRHJqR3BsVmIv?=
 =?utf-8?B?a09EdGxqdHlIUmhKQWowMlQ2YnJrTlNiV3MrSVB0TjBzemF3eEM5NWFlanFJ?=
 =?utf-8?B?WTdPeG1TV2p3ajNKWFRUNVQybW9Jd2VuNmszZVJpcVJqZGV1eGczTFRQTjJa?=
 =?utf-8?B?bU5QNzZ6N05sdWc2b2NJNHFMMml0MmxwVlhtYTRubjBIM1QxTDdIdFB1c1la?=
 =?utf-8?B?OHJudURFSUpqRHc5bmd0UGIzQkRYR2FlQW9keVNzM0JTaE4xM0VRYkErK2tt?=
 =?utf-8?B?QTNKSzVzdThTaUN0eE8xa1dDRTdUUjhiSGd1S1g0bXA3WjFTalBTellIWmFJ?=
 =?utf-8?B?cFJoK25hY21Wc3A5TnZGUWJaeUhZb2gxdCt0bmRIeHE4bkI1cnE1RDZjbnlu?=
 =?utf-8?B?V2pjRGlid1ZPYzFBM2NHQjJvcXJEVnIvU0sydXhuazlpb2lLaWFyVmdvQ1hD?=
 =?utf-8?B?R05vY3A5WXJLdUx3Ri9mZThGRlJaMk94UVRDMHM0UzZmbCt4RjN3S0Rkd1VR?=
 =?utf-8?B?V1ZRQUExa0ZabVFKcmp5NGpvQ2NpVUluc2k4RXg2cnlvQ3F3V0s4MDgrcUxE?=
 =?utf-8?B?eitCS2Y3WFlKZ3hkVHlkZ3N6REJpbzg0NzFKckNsc2NyZkdraFRUWW40SFpH?=
 =?utf-8?B?NW5pMmFZRnBzOWdxc3J2cTIzUW5MWW80ZWgyUnpJa3dNUlU4b0NCQTg0UVBP?=
 =?utf-8?B?VG5WZ1RwZVE0WHhxeHM5ckUwZk4xTjhhYUFVNlk5ZlMwbmhwN2RzWmtId0V4?=
 =?utf-8?B?ZEJxd1NxL3didmRHZEN3YU5CcTRsK3V6cXFkc3F4eHdpWTlqczc3akVjdGhL?=
 =?utf-8?B?QWRJNHlDQzl2cDJIeGM3NmV2NHIxcnRZTDJ2M3JtNi9ybTF2WTlEYlZvYm40?=
 =?utf-8?B?MEVyMElRdFlVRTZTSnd6Y2xNZW8wYi9LRnJIb3FHcWxBQytQeVFpYTFrLzVi?=
 =?utf-8?B?OElxWWV4SmZ4YXJDZjduSkIvVHljbFFJbWdoYWxUUitlcUhKVms0WkE5U3U0?=
 =?utf-8?B?TzVwS1J2bFN6ZVpmQWlrM0s0dGhiTHBKZVlkakZoOW1wbHZDQ3pqODUxMCsv?=
 =?utf-8?B?QW03LzFKMk11cjdad1pHclI4Y01EYkhMT09iTkhiNUNJUkdTR2RJbzVZLzVh?=
 =?utf-8?B?WnkvY250b2l5WUl5cXI3QzVhaFRZU08yS0tQaElzcURRdDhCb0cxWm9maVVS?=
 =?utf-8?Q?5drNWro096CWJmwVwUDR48OBRgO8Rd53gb9t5hm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39fdd7b8-bddd-441f-4ad1-08d984e1b5bf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 13:45:20.2501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: THgXYNqHzp/FSW8rF02xI/kHY299npOXhD6dHSNmHprZN+fEfcgfmwXW6y50xKsZzmu8LWO+lt+sSwUkhsUyEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/1/21 4:43 AM, Borislav Petkov wrote:
> On Thu, Sep 30, 2021 at 11:42:01PM -0500, Tom Lendacky wrote:
>> After returning from a VMGEXIT NAE event, SW_EXITINFO1[31:0] is checked
>> for a value of 1, which indicates an error and that SW_EXITINFO2 contains
>> exception information. However, future versions of the GHCB specification
>> may define new values for SW_EXITINFO1[31:0], so really any non-zero value
>> should be treated as an error.
>>
> 
> So I wanna do this ontop. Might wanna apply it and look at the result -
> it shows better what the changes are.

Yup, looks good to me.

> 
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Fri, 1 Oct 2021 11:41:05 +0200
> Subject: [PATCH] x86/sev: Carve out HV call return value verification
> 
> Carve out the verification of the HV call return value into a separate
> helper and make it more readable.
> 
> No it more readable.

I'm assuming you don't want this last sentence...

Thanks,
Tom

> 
