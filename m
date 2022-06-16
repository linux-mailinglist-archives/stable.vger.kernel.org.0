Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCEA54E1B7
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbiFPNRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376829AbiFPNRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:17:23 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4F73FBE9;
        Thu, 16 Jun 2022 06:17:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkMXomd/CN4pTNVI94Hy78D5LCiB9jRoXqD+1sfSHeDuDW4vxGKPZE7ImmNovWf+ffLJcIK+/dR8HDciAQcUXs+C1ZO5Xl579bzrnml4GMWcx2prqCFiQK8mK6EIcURnXokInEcamgPYL8VP14B9+fJmIuPqyLDkdxZVu6kkiinqXA1h7Hem6LOXxL7EKRfsOofMJPCwm5AhvcQ2TfmgqvhtIErKHS6TRlg+ON1h8KcQk13hN1RLmFRAuJn79SEQsTP+WvqdQ/EQr/JzHFkJ6UodapbrUplAfxRkBcojXwrTBFwb8MH63nWCBvyU4dR10PNh815FKf7dVXzCyKs/LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7Ox2eKBnmSr9wuYPI6OATS+RBjK8N/a6wskghYVf18=;
 b=MMgMut4L3729dsNdLyiJYrxFyAl3CEhybVMxIxaSFM6LIeza5qz/x2tExFtP8ZmSyCPHMJEZY7gvKRKgo/CF2wFVPfZ4uoDSQ45UkKGMd6fR9+cCKuGDETF2AnPdwIGBJH7zi1yu+490dC4Rb2Q/B4MChH+afqA5i6nmZm56D3DyDbQ4iLmQR3l2V2ml3TRFCqSU0ka6VF2M7pe+FEBafII42/Jgq/y+CjMZKnTQ61fKwWaOkasdf5S2XVCl50ZAhOENGY53zKQ8W0NoYcyoHYlX35tVAp7fF7H0Kboj3Q2RP6/TaxBEM1fK7n3KEPU+NlyMVJs+vxMs+WlJQJjO2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7Ox2eKBnmSr9wuYPI6OATS+RBjK8N/a6wskghYVf18=;
 b=hMVAS+FYDOkUJ3WD6wvCyxLaApVqEdSGGSJ1xoj+L0PhWuhcgfWuK0d+Y3z2z+BoDDoQxycmrqEc+LmN8Lx5RbRQZinTneQORnCpntE38df+xKmxx3tW+HVcestQ2MR1RuOtWyrdNXa3d84n7BCpNDjde8Pd7H1AE79kYjmAJl31TrUmEeIxKEZoVTSRTDOzi1bVffe2ad0UEk/Mcz1QRSwF/3C9fwv9lWk8ZBDe0ECXhVqyezH9Sr54q9S0Nvtw4z+QK6uSKhL2sT73l/51QAUkj8SMeNNnlL8RFJba7jn5puK4kEWV1/m5Q72aAHFzslnx+OhK3LiYAcCD8BQlUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CY4PR1201MB2550.namprd12.prod.outlook.com (2603:10b6:903:ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 13:17:19 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 13:17:19 +0000
Message-ID: <81bda7cc-fd95-8f54-4ad7-3fad9a81b831@nvidia.com>
Date:   Thu, 16 Jun 2022 14:17:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 00/11] 5.10.123-rc1 review
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220614183719.878453780@linuxfoundation.org>
 <9e43b35e-31da-7e51-006c-1aa69acb10d4@nvidia.com>
 <YqssBl7QRyp0nytW@zx2c4.com>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <YqssBl7QRyp0nytW@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0079.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::12) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9b6f8f9-d737-4c5c-016b-08da4f9a8a59
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2550:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB25506FE77F8DF25EA8CC65A3D9AC9@CY4PR1201MB2550.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9s/XFZpniSTPYIffuaJSpkUpZxifLZsoZisBTBfQo5M5U79ZI0wL+BTEqNeRLtorBzRJkF7w2NNxelo0aukf8suUY1oIHWqTNuMEMyywzEin6k6R8dB2fbsABbBYwaLrDRapEDkPouQ79UHOWd+GKBYaGbODlofTBhmoVzLjhbU1hz5S1LVd8Ux7/Phi6Zyu69LlkfvW8QHzGBq4er4YgiRWu2F3XljJ4/pwVPQGnTtWFhJM4fXY1cLxG195DxIzrzPIYNM0ktbpE0h1zsC042i4PXNYcjiPjSI7c8Bm46WXcp5pbCQx3IgqHcV7Fx3fBd5hnJ1gRbexdRspWm7L3Nvu0JVy+SqRdlKI5q0KRaUIqRwaNRvQcP2djQNjFoO6wpEwL6svYty9kkwB1dJcRF9XJFklj+vQ/IHG1+d9Xg531Wqmq54/V8Hlhd5ShRN4nARhKB+OEKHuyOWMDtLaQOXXXw7VTc8Uka1SJDruDX1ELO8iJ+xBlhZjp/WqST6VjGLO5ylurtNCTJQCdi+Utb3EaeJAxaVRlF9GuN2Xtf7eBp67v1aHpfzBwGhDOaHkGKYnuZxJA8DpMNkqrwOF0cyh6xXyHIk88+Z+6ajYjzDbsf9x1TaI9jef17sfBidzPPF+CN0KDrp6v5dK0Lm1bEGQz94Zvt/IWv31XnhlWZGQirXDa6Yb9ATdv/Sg/M8T7jU492aeRT4z0Q3cbGMZDAB8EDI2/5gR5ZicAkhnlZA9Kz7i/rIMP8em739bPosEQ90BbvHYWP1bcCbNzzJKpnveqenGtPscsHuJEDXak3p7wZEXKdwsQKLIbyyMACWX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(86362001)(6506007)(83380400001)(66556008)(8936002)(5660300002)(66946007)(53546011)(55236004)(31696002)(6512007)(66476007)(4326008)(6916009)(316002)(966005)(26005)(36756003)(2616005)(2906002)(7416002)(38100700002)(186003)(31686004)(508600001)(6666004)(6486002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0x5MHNGTHp2QmM5em9GWjdpVEJwYlhqY2xCNVdJcStVUFd6NXhKMVdxei9j?=
 =?utf-8?B?THJoTXY1YlNDSXMxQU9TbUFZdlFqci8xcnRic0JzRm00dWs5VFRKbUhkdnpS?=
 =?utf-8?B?Z2s4dUxFVEhtNEJzbmtkbEthanN5dEh2aUNtZnBEWkhsYno0RWFHRU91ZUtr?=
 =?utf-8?B?aVZMclFzZFA5R0ExQWNEc0liU3F4a3orN1A1cWx2dW1JRXczT2R5TS9KNkZL?=
 =?utf-8?B?MzRCaXhKOHljMGNEM0FSL2NJU2tya0pYdDBBck5GN0ZEUEpwMWxaVGpXUng3?=
 =?utf-8?B?cCszNEdVUnBERGN4dFZFaW9FUUQ4eWFWU3BSSFNYdXpXWkhTelU4NWR6S0tp?=
 =?utf-8?B?TUd5RW9UcTlkK09KM1pZdFpXR2RPSjE5RVFzeVpEWjhVZ0NOZWJFK0ZUd01K?=
 =?utf-8?B?SmoyV2d1L285QjhpaWRhNHEycmYyVSt3ZlR4ZUVJaVpDcW1LVmR0ZmhXeHYy?=
 =?utf-8?B?TmtXQWNxdE53aUhhSVYrV3NhaXlhUHlwWDV3MUFrc2JkaER5b09tSUJzT0hY?=
 =?utf-8?B?bms2bkxDalA0dzVrN3FObDdZbWN5QTUxWldvTWFOVThtQ0JjVEdSU3BMenE0?=
 =?utf-8?B?UXdDTnppVGpJZFZJakloVk5WQ25CQU1TMExBbHZiMFJoUGxEYm5ydFUxN1Vr?=
 =?utf-8?B?S3RVb1U3MFM3dThrRnhUWlVzdlNFRHNoeTJjV1BFcWJOaU1uekUzVkcwaFBX?=
 =?utf-8?B?MFQ3SzVyci84R2RqelJDVStMNU85MFZ2Tjd4VVA3dk03dkpCczlTVXpYejY0?=
 =?utf-8?B?U2gzMzZCQVYwS2dKS1FZVUo1Y2xXYjZxd2FjYWt1cE04OE9MUkZHM2hHYUsw?=
 =?utf-8?B?a3ZxdkIrMXhjU3huQ0FMNzg1LzZEUmZ6MWFkSE5Kb0d4OHhIRXBqdWlGNTJk?=
 =?utf-8?B?ZWQ4VjBDcGhub2orSlA0U1l1TzQyWUhwc3ZWY1lMaG5MSVlsWlBQVG9Xc2FB?=
 =?utf-8?B?R2JlZXFEUWdKM1VPTFBrSHZ5TlJZM0xsblVoZ05oMlZEaVkxQjY5WDlHSU5h?=
 =?utf-8?B?NXRDb3lGZ3JqdHQ0c1ducHIzZkRlYTJqODJOQTZMR0tCclJWakxLZWpGckVv?=
 =?utf-8?B?V1JFMTZNMnU4a1JsU3NkckFpZHlKYmlUSDhLUFJwTSs3UWo2SEllTFlpREJ6?=
 =?utf-8?B?MFFhRE1NcS9uQkxuUTdpKy9jcWI3a0NyblpoVnhrSWFLcmdZK2pWR0RKQzk3?=
 =?utf-8?B?cTN4ajdENjJqL1hoMjh4ejRXbmVJWXoxaGh2M2FJR0NXNkdZQlNYaUs5R2VB?=
 =?utf-8?B?ckFyc0x6ampFNk00SlIrNVFQTlBOdkZTcG5IVGFjaEc0bjdOVTRUcE1sdis5?=
 =?utf-8?B?WXgyMGlMajhCNWVicTBvaTU4bHdYTmVWZEsyM0hnVTA0VXFONEpST20vdW12?=
 =?utf-8?B?Y2c4TlJadzFYRGNrSEJOZ1hlQ3RMZ2JWZkVZN2lKVFc4L3JMUFZDbytvR2Yx?=
 =?utf-8?B?U3RUQ2tKWnhFRlNOTzhkSjJaVXJtT2JORm5JUHRKVytRYTVEaURXUm5QREgy?=
 =?utf-8?B?d1NRc0g1WkpqMjhZUzRxV3duMUs4NStuZWF6S2lSWnMzT3JqNVp3eWFwb1ZT?=
 =?utf-8?B?Zk9UUy9zZXlmWVpxd1BxbVpXVlkvOG5XTXhlbXNWQ1c1VGl6NHhQWjBaaGw3?=
 =?utf-8?B?eXI3TmoyMVpUclVFd2s1UkNzTCtNd0Exd1lPckdTQ2RsVnl5Q3JZMjUxVlFW?=
 =?utf-8?B?akQ2cGZLWkJ4Y3d3RzF0TjdudGVNSE1mbVAzVlNBU2hsb2wya095OUwzWHYv?=
 =?utf-8?B?LzUzZ1BrMU5CQ1BuRmhRaWU3ZGFEN3pYbVl5VC9YOExhNS9tQnNncTJhdC9q?=
 =?utf-8?B?bVkydXRQZFI3bDR2c0pFNjY2aG0xVlphcHpjaTdwSWNuRXl0WHpOT0FpcjBY?=
 =?utf-8?B?RnlUSUdCaGIvUGFyWXZkdm9VK2poU0JaTGVMU0dQWi9zSy9UcUpvSmw3OFVq?=
 =?utf-8?B?TWtjaWxYMDhCU2tNWFNDb2RIQS9ZV0Nnc3ZuNHNUQlVKUGZlNm1RY2RzQnI0?=
 =?utf-8?B?RE10cjBWKzZFZHozbzJCSVdBR0xrWU1ibzVWMTN3NWRCb1pUOWdaREJxN00r?=
 =?utf-8?B?dnRXZHc1TmVhaExNOTRVYWFEZFh2eU90RURnREZRZUdyWWo4VDF4a25XK0VB?=
 =?utf-8?B?RlliaWFzTnNiaHhsM2dDa1ZXcG5ZdWJVcW1zUjdGandUcmtVZ2ZYYWttbloz?=
 =?utf-8?B?THRlcXczRjYrWS9MN2pTcTRqYW50YlBaa0lTUzdFcm9ZY2ZBc1cyTVdGYnE4?=
 =?utf-8?B?NGY0U214RmY1cXJqd0t1bVlCZGpLM1NSekY0a20xTHV1d3R0c2dVRkFhMG11?=
 =?utf-8?B?Y1ZUWE13VGZabEdvLzlFUGZEVGpUaDBkU2tNaE9DUU5QT0JKVit3UXhVYzR3?=
 =?utf-8?Q?8e8wJDcXEul8zSQs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b6f8f9-d737-4c5c-016b-08da4f9a8a59
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 13:17:19.3179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OylIZ+v5h8GAriAnhSzsOVuej1YcQ6J4861p1UtNB6516GSq0opsJ3ACfRJS1ppk1VJrKwPQ0G7G4VE04VHqeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2550
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jason,

On 16/06/2022 14:11, Jason A. Donenfeld wrote:
> Hi Jon,
> 
> On Thu, Jun 16, 2022 at 09:48:37AM +0100, Jon Hunter wrote:
>> No new regressions for Tegra. I am seeing the following kernel warning
>> that is causing a boot test to fail, but this has been happening for a
>> few releases now (I would have reported it earlier but we have been
>> having some infrastructure issues) ...
>>
>>    WARNING KERN urandom_read_iter: 82 callbacks suppressed
>>
>> This appears to be introduced by commit "random: convert to using
>> fops->read_iter()" [0]. Interestingly, I am not seeing this in the
>> mainline as far as I can tell and so I am not sure if there is something
>> else that is missing?
>>
>>
>> Test results for stable-v5.10:
>>       10 builds:	10 pass, 0 fail
>>       28 boots:	28 pass, 0 fail
>>       75 tests:	74 pass, 1 fail
>>
>> Linux version:	5.10.123-rc1-gf67ea0f67087
>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>                   tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>                   tegra20-ventana, tegra210-p2371-2180,
>>                   tegra210-p3450-0000, tegra30-cardhu-a04
>>
>> Test failures:	tegra194-p2972-0000: boot.py
>>
>> Tested-by: Jon Hunter <jonathanh@nvidia.com>
>>
>> Jon
>>
>> [0]
>> https://lore.kernel.org/lkml/20220527084907.568432116@linuxfoundation.org/
> 
> Please CC me on RNG issues.

Yes no problem.

> I'm surprised that this message results in a failure. It's not a
> WARN_ON() or a BUG() that's being triggered here. This is just the
> simple `pr_warn("%s: %d callbacks suppressed\n")` in lib/ratelimit.c,
> which really shouldn't be causing your CI to fail. Sounds like your
> harness could use some adjusting.

It is not a hard failure, but any new warning will be flagged and cause 
this particular test to fail. So all I could see is that a new warning 
was occurring and wanted to understand what was going on. We can ignore 
the warning if necessary.

> Nonetheless, you have found a 4 year old bug in the urandom warning
> accounting that was recently made more easily triggerable by a newer
> commit, though not the one you mentioned. I'll fix this up and keep you
> CC'd on the patch, which should make it into stable as well.

OK, great! Happy to test anything on my end.

Cheers
Jon

-- 
nvpublic
