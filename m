Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1255E5406
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 21:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiIUTzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 15:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiIUTzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 15:55:12 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C517FA1D38;
        Wed, 21 Sep 2022 12:55:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHhuxCg4TgnXRHfYbgbZTk5ly1kZFDLtp3ulfumntcfCWDztcNfVjgLudfDHG8zFuWLBalY7Sa3X5Sv/c76hBQ1wuM5BrP2rLrOHxG6JKPrU7aSTcw4mGGzwdQPHmt4pczi+F29MR4OCFwSLXBFcP1y5rfZwPqGt795uAU8/6hghfwYzfFWtdFiHqyvrTQ9lmFFr8UnUbyikdcfQ9K3WsZ+7uQKMKo4bICSya7dXwA9ioaqM0XGh1uHrq3SYtc9CWeJ4C6Io0oi6XbV0AOEDVmZKfhaByc2prYwUYnyFFkJOrIjY5her29ioNVWLLSddhhvq/lluI8+lYnAbxYCSWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDRRL/OAkj2JK8wLYkpBIII6pdKeapW/GXsL93h0iKU=;
 b=gK2kh3DTvlT/qOL/kLdXa1StXvV9AGjFmol3rsNjUzJPYVO6w2s7h5w7rac6ikBZdbqFz2isBmBV754kCVXOW2yrI0dUFbFp25vJRhuUL899/jRCpCMIxsiSa3nZZ+VQUSDiiyhZ1MTF5qk7UWJToBIlg9fkhsxyxA4Dh2M/oOMC6wvv28seieFSKsom5HMyQqWFKbG/j0AGaEW391Ooy9PECa1bhAe4qI8Qn21k2IpT6KTPtBW9NB7q3wdxPOfMvQROTCqW1Qw3vwbqhaX+ZDJzApcKHO5TBviRtxuhGz4+sUXZQz7oiTDv0EG/nSHELEOKiAQvnE4R18zgLMtPrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDRRL/OAkj2JK8wLYkpBIII6pdKeapW/GXsL93h0iKU=;
 b=b0hzBoil+x5YMtr8KlPSw5TrbPMV1TH0BYtrskHc1r6dmqNVFopX4grQGMKWlrOFjnDBM9H0cmdXsOPpG8ftbuhqKxS3f2+zYZPTSUECV7oPC3DyjfDaX4R17wSj6i872kaIi/LHmAqsjpGvpHfz71ViDCvAYyS1B3RT4aUzXXs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 19:55:07 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%7]) with mapi id 15.20.5654.017; Wed, 21 Sep 2022
 19:55:07 +0000
Message-ID: <53e6d589-2470-5709-0db0-687ef1f35bf4@amd.com>
Date:   Wed, 21 Sep 2022 14:55:04 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>
Cc:     K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, andi@lisas.de,
        puwen@hygon.cn, peterz@infradead.org, rui.zhang@intel.com,
        gpiccoli@igalia.com, daniel.lezcano@linaro.org,
        ananth.narayan@amd.com, gautham.shenoy@amd.com,
        Calvin Ong <calvin.ong@amd.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <2b6143b6-9db4-05bc-1e8d-c5d129126f99@intel.com> <YytrV2UMah8555+s@zn.tnic>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <YytrV2UMah8555+s@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:36e::23) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|BL1PR12MB5753:EE_
X-MS-Office365-Filtering-Correlation-Id: b9282226-2268-41c1-d690-08da9c0b2ee8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jdi7IocV9O+upHeLlKpydmmGIug5Z4xA1MLCfYd3TRy7wgJjOtE42gEOW372jMl9V0AM/rsLrWfbt5Fp2q+tF22cY2sd7s0hzQjUPRRHMaosw3dmXs8Z5EH9+73dk3ivP7O0AYOsawalxIfTy8tLLW86x5yYcUmE81GRKUGwShKdN6sNaxr1AV1wIxrAF0WLPMhld4akrAwt6xHdtpXDpiH4WLm1OizauTcK2n8LrRM0R3EAHPIEOqR/3li27dQBo93twHKrmpvX6H+NF20fWZsGtfhw1MdJhaOQbCvud5pn0wRl9HYeHyhEbs1C6u8aH1KcnLPnJa9kDb76ow65+bSW38L+QrujAhgEEOu6Lp3LetauKu2y4o1QcDqFIQbPmf6PoICMfTJ08U36AIuYTzYCjPvOZf0sV0PqcK1+h+GXshrtMBFJo3GkVoXbkH8Xww3afgscqhreiCGonshqXOqedhaGXBusGh/aFSnaeXY9wc3NjJtGKVTaxbYXiEAlZa16LSeCXu8HCq1ni6I5mB4CnBrDTOZz8WpESmhhCY/9V7KObyBoCl0XnYv0dUW8pTH8WrWKujbCPrFXDIST7ZlAkMw7a/ZzE0akJYE4IMwjtI5XH3IY1BGgNIv+9wtJr9dlQ0fFrXovnZYmc7yULaQQ4EIkhlArrkfwloWmRfhtwn3wTN/n12mJLXNlbDMxmWrqYICC06iEeGm/l3WIy4uhf4SVEJQd9TTwWaUC5qpzZeL0MiDPaksd/+FuyxjQAlKcv+R3jslp+OBB6hEmkR1sWW/L6LsJOnDzBv/C6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(8676002)(31686004)(2906002)(36756003)(83380400001)(54906003)(110136005)(4744005)(31696002)(66476007)(6486002)(4326008)(66556008)(66946007)(316002)(5660300002)(478600001)(6666004)(86362001)(7416002)(8936002)(41300700001)(6506007)(53546011)(186003)(2616005)(6512007)(26005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0RTWCs4SDZJMVVHNklETGVlVWhzVTU4QVRnK0N0cmtTR21tbXNZV1R2Lzdr?=
 =?utf-8?B?RVJlc2NqdE11eHQ5ak1BTVVJMzBNVlRXNWJ5N1piWFg1enZxODcrYzBVYnlZ?=
 =?utf-8?B?QXJhWTVGZFY2WGhNcVRFVUR4YThyeWdzcU9USjZma0RrTGlQL3JuVVF1UGZn?=
 =?utf-8?B?eU9JaTlMSFU3RW5GU2hpVWoyWWJ3U0dPRXFXR3BaWFpYdWJ1M1ZEMDBaZ0k2?=
 =?utf-8?B?cXFUR0t0MTBaeFNNSWlUSS9NcmlhTHJVbjFsUlB5MW5JT09DeWFrYTk0Z1gz?=
 =?utf-8?B?Y1d0K3kvZk83aFhQV0wrYm9HVjlIV2lzQXNCTTlCeEZaUU56VVlhdXBtQjlG?=
 =?utf-8?B?RUJTMVMvL2kycURneWUwdHBuVCtaMFFuSm9uOWFBMXZLaFJwbDkvKzl2bGFZ?=
 =?utf-8?B?MHpoNVpla0FJa1g3NWZGSW51b1pVZHlpZFZqeVVXY1F2a2tsRmM5aVM1bHgz?=
 =?utf-8?B?MDd4alpUeVlKUjRneWhzUEliVlRUY1Z4bnA0d2RGalU2a0VBRUJzdHFZQ0ZM?=
 =?utf-8?B?blg4Y2ZiODJ0Y2JCUWtlQ0t6LzRmWWZFQ0JCRUVVOS96WXpYc1kvZ1RPZ0N2?=
 =?utf-8?B?Q09WbHNwazJTRGMxbTRQaE1RcGpXTTIrREFSRGtVNDhhZHJuTWc2OFN3M09T?=
 =?utf-8?B?SmNaZFU2aFJ5d2syNC9ObFVyUTlmWnVCMWRMUGtJT3l3T2d3UDB2SXA4UW94?=
 =?utf-8?B?UFNtWGIvRmoySlBneFhWdGRhL2lVMjlCRFVYbVhtRDQ5U1ZDVGxpc25PM1li?=
 =?utf-8?B?eEE0V1d5dVliazZkSzZycTk0SENzc3hnSGlGVzVNWjR0NkFqVmE1YU1FQkpY?=
 =?utf-8?B?a3BESDRNMGU5cm5IVDBiZjJKSUxpZHIybXFsNDFzNkRxRUZzT1NZM204SDlj?=
 =?utf-8?B?dk1IR0ljWFN0MFE1VkhxU1VwakhCK05kdExlWGU5ZVRScUp4RldCZmtwRDFV?=
 =?utf-8?B?d2xxaVJpaGZQZ3RVcHNpMnl5VURIV1FGTExkV3p0OWV2Q2dhMC9ieVFyeGlN?=
 =?utf-8?B?TG8rbU5YZWk1dk1Zd1hsWndXdnlRM0VYTE1vM0NJV3pweENhRVY0QnhUeWpT?=
 =?utf-8?B?WWgvL0l4SDZKMmMyc21KL01IU09iYVBHdVRUTHltNjlkTnpwZkVCbnVvTG13?=
 =?utf-8?B?WnZJVUt2MjFkUGtieGt0OHEyRlh2U2FhRUlqRDJ5RVBwK28wZVJHTk5iMXRD?=
 =?utf-8?B?Y2hnWkNHYXc4dVFQV3AvTVJXUHBmWnlYRjJMR1NvbWIrSzdDWExmUXpWR1px?=
 =?utf-8?B?SEZaSWpmdFR4V1JlbjVYWElEakkvSlJWUmJLZEpLNFBaZFIwZlRtZjhVbFRl?=
 =?utf-8?B?ZXJ0Mkw1WHhhMkE1ZDJGSW1lRnRsK3ZNWTFuOGl6RTIrMHVCdXN5QlBLeHhz?=
 =?utf-8?B?WW5aMTRSWGlEdU5TNGQ2Z0taQlgvZ1pINlZMUEwxK2JuTmRsc1cwK3VqcTNl?=
 =?utf-8?B?bzl3anZwRDlkbEc1dk1pZUliUHFYSW9sZ0RPUzRzZmMxVndoMVZ2TjVqQTBZ?=
 =?utf-8?B?WEJaNG82eXlJenpVYzN5Tmk5eTArSXA2S1pVWWladFdiRVo2YzhEVmYreGFz?=
 =?utf-8?B?cURaRWN0cExhWm1qZG52dHBGOTNtdWhXWEhhdkhMbit1Z1Fac2xrNTFDVG11?=
 =?utf-8?B?VGtmcFVtc1NpZGhkd29vMEtyeEJwOEFpdFhEUkFkQzBEVnhhTDVvbk8wT0RT?=
 =?utf-8?B?Ni9BMVJTUGpUNy83YklFSHR0bEs0ZHI4RTdlSXZaZFdIeWNvd1BKQnhJRWt4?=
 =?utf-8?B?L2UydkhiT1dNOE50QUdEMVdtNlZ5RlNMQmYveWxVcUI1M0o3MFlrdXF1TjNJ?=
 =?utf-8?B?ZFpCUlBJTHk1N2FJTU5KVElhZkp5TXlMTkF3a1hobGJCUFJybHBHNFA5d1g0?=
 =?utf-8?B?Z3lIVnlEZTlHdGxRWEpPREN4N0xYaTlyeGFEbW9NbWh6bERmbkxzRW5PMS9L?=
 =?utf-8?B?WlhHNSt1cDl6TWNNbWNEMC91K016d29kcVJwZzU3UXRjNTlDMndZazQ4b0tG?=
 =?utf-8?B?bGludnhibTFuRkZ6NlRtbXRCUStDaHNkUWgvZHl1MEJUTm5PbU5VbGZWR0Vt?=
 =?utf-8?B?T2Z3UFNoRW1RWU9IS0pZemtoYklXSUF1MmRQVmh0UXJONXhHTk9Fd0w4T2Z2?=
 =?utf-8?Q?6UAmwN57fXZVupl74nyRavi2F?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9282226-2268-41c1-d690-08da9c0b2ee8
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 19:55:07.4118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGhBGgu/tJmawF6iiXKL06KpL7BHsfiIX0RiFAwMQT+lAk8ddXF/pGF5mLVJvsDV779+LahLuO4lXgJ6+zU93A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5753
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/21/2022 14:51, Borislav Petkov wrote:
> On Wed, Sep 21, 2022 at 07:15:07AM -0700, Dave Hansen wrote:
>> In the end, the delay is because of buggy, circa 2006 chipsets?  So, we
>> use a CPU vendor specific check to approximate that the chipset is
>> recent and not affected by the bug?  If so, is there no better way to
>> check for a newer chipset than this?
> 
> So I did some git archeology but that particular addition is in some
> conglomerate, glued-together patch from 2007 which added the cpuidle
> tree:
> 
> commit 4f86d3a8e297205780cca027e974fd5f81064780
> Author: Len Brown <len.brown@intel.com>
> Date:   Wed Oct 3 18:58:00 2007 -0400
> 
>      cpuidle: consolidate 2.6.22 cpuidle branch into one patch
> 
> 
> so the most precise check here should be to limit that dummy read to
> that Intel chipset which needed it. Damned if I knew how to figure out
> which...
> 

Functionally most Intel platforms use intel_idle though these days 
though, right?
