Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFE9570314
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 14:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiGKMok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 08:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiGKMoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 08:44:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F80F20F6D;
        Mon, 11 Jul 2022 05:44:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9HATa5u+6+9CiwoaxccEM8rJtMBnPvCtEfmjJdgutHvYVXbo1+40eR5xUhDXGEgNQVwu0bDVtoCDcja++Pnpuj3x1Ujq0xspoxxzIP5oHQZEDJ+pRSdcbcb/FIZel1q0cnvRe/DxDPvn5NV+vVwegf8yY2Pc3PYVfHukF9e/HakA4H0NiCul0zZIY47XiU0dcszTpKz5PgVVjoZYvHD/vUKJtiNU29zMWCDb6awwGNHQuZa6jjlglGD2pPEL4IVUfcs4+mk+uyQlCAP1JR9ti7p2y8vMI6EpjrkteWqnVzB3kUHNT8AZGVxLJdijZIBUEGJfvrFi0TrCLsMMccYvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rUlhp03MTKWpusw7v0d+KFX0mR4/0AbH61miRGzOACg=;
 b=BgxZpMN18yOEzMh87W5OktD+gifmQy7fLGRqanif1EFQEpMFH8kpDba1RxRMVwdI7cjE995ki0mbddRDmCUVOu2mtRJ85dsaRY7js3cA45WHVcw3JrQXrmoxAHbTC2mipSgwwOJ+Bph5hQTuYnYsQZfy+JI7kWjRlHn2oXiSlNLomPwbaM7IMSSss4+dsV4gIr2lfysee+hrQMSu3HR6h4740ilPRiTXEbwiwm1ZAAOOAgFoAUYgt2V1Nn0Ln72U12VxwubFOASf2fL3ixFd179ySPk6hAIchKTdJWbohAguHHbLWfGr5o1iPMcpJp6edWHuYaMjcVbyQ2m9hks2lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUlhp03MTKWpusw7v0d+KFX0mR4/0AbH61miRGzOACg=;
 b=XnhQGJP172y8w5QRb6vjADMyHiCl8TwiYa9Q+Ur3gOQOpUNghg1Bo5xooe8fx0WkYrNR9mUkwOrjxmf3fvzlQEzikQRH519W6hh2cW1/0lDlOX6g5HiG+xQY5WtQ9H/CkfPp3Nd3HsUtVXvB/2boo3pQ3Lc4sgsurqmsLZWXANbzbYM5sjI5W/7ACXuc4Bce+NVE1XISbPoGRT2AFuQPL7bIOGHPnsse1u3X5D27a6iCVhxjvY9+JSQduurzyRT/19cVq50Ap4AM2YC894mG7HBrDDINZytECNivaihX6Kmz4Gd7J+ZD/iEDpxhyQjbgyCvkPel67FwMYuEM366MZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DM4PR12MB5054.namprd12.prod.outlook.com (2603:10b6:5:389::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.16; Mon, 11 Jul 2022 12:44:08 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::b148:f3bb:5247:a55d]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::b148:f3bb:5247:a55d%2]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 12:44:08 +0000
Message-ID: <7c552ad4-81e9-2abe-3114-dd55c924844c@nvidia.com>
Date:   Mon, 11 Jul 2022 13:43:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 000/230] 5.15.54-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220711090604.055883544@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0156.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::17) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e119242-9c8c-437f-c128-08da633b0bbb
X-MS-TrafficTypeDiagnostic: DM4PR12MB5054:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPJz9PWq0g6Nt7X/OvUHSVwcVJ/9m5/EcB8HhndgXvGBslWiKtInC3hoAaJJPlSS7jKobn4KANQzmkFodSpP/UnjFE/bd8BtDo7LhDDdaUfEV2STB8grwsGSVSVaMSglMRN5fUxak4MrT8ACM7hXXBpkc6BfNQY95K0kuJ3fS4H2ZduWaPo2zMnTD1VT5tRamCN1xw3DUq9rpUBEle56q44vD8DZ/KlbEFGiOd+KFn34An+DPnYmJMXZaE8JNXdqgShTru5lWtp4c0izpYNJTQqGFEPQgBTxS0FtfAdoSSAtZCV0rFwY96oZd91JDr/35LbXymz10QmdcWv/YjhL7MXPMyc/F0vVPb7cfgVR50jNQn3yaLhFF+laHs7/yw2suBmhCYI4TM+zwZRZNi0LvcpJuBgc//R6B/A4+JDgFNft/s4Cxe1Xbj8aYjkpZVTZg/0fVjZDxotN53spWk4tLZTAsJpZiC2rr9eYYxF6UVFSStetMXs5BRRJ3B01GrPfd+9PYlHO0UEScnX7wh9SlkE7PXeypa5M0citUiBov0DpllpI0Q+HJ1GM8Zr/hII4HYGYxIpyanfDy7KVyCCJowwojnEz/kqwggCOAZ5XzYqXXu+K3CFyudpQxI5kcIId1+OyD2NY+c6mUcZ1FMQFnwmW3v2nZMfDioEucW3+odJK/sZr70FZH5TCXDx7yI30Mrpx21TJ+CE1gr8HgGiAEjSJjXJvcM7W+pPVDOgAjDyVEOdUd0k4XO2jAT5DS2B+iJyiGAO6FgyCpQPENnxQFt3+dI3ovN4DcGr3EsXQd5lLkoNnfSKfsUyNvzMXjYpd2T718FsgIdOqLJFheOFN4xu2+GUdq1B487SVSmAwsMb2YUpiuw/+ZZYnkk1N8OihUmrBmxpn/113va2o0KBY3wX2Qxpx4cUPBWyE8ezgZeA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(8936002)(7416002)(66556008)(4326008)(186003)(5660300002)(316002)(66476007)(8676002)(86362001)(41300700001)(31696002)(6666004)(6506007)(66946007)(6512007)(2616005)(53546011)(26005)(38100700002)(6486002)(478600001)(55236004)(31686004)(2906002)(36756003)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ci8reTRaTTZzSUdQcmVhRWdMUGxWMk5SUlFXbWpJY0ozbUNKNUcvUGpQbmZF?=
 =?utf-8?B?b3FLUG1nQmlyWFdFRHpSVFpETGZMd1lTdlFFWTVTQVdkZ1FqVVo1eGpvTjBu?=
 =?utf-8?B?UzFTYzJXUDhoekF0Y3ZTVjdONFVjNlFLODc4bjdHTUNYOGE4a01vcStMaWt5?=
 =?utf-8?B?ZmMyZVBlMFFodEFHYUw1cDYxSnJCK0ZDRVdGVEY0QlI1M3ZUYWdBWlJNaUMw?=
 =?utf-8?B?WEFxWWs5OXdoYk1CR0Q0S1d6MEpRRUVVSkZSQ0hIREVFYllqQ2hLRjRZaTNl?=
 =?utf-8?B?Yk9EWXJDallwajJrZHVaTURJS3FYNmxRR3pmRzk2aGhSclM2dmMyZUxJVHRz?=
 =?utf-8?B?N3RYYUpLbGJOM1hEVEN5OUpZR2RBZDVrcnRYVWNZL1pHbTB6MG9Sb3h2VEtx?=
 =?utf-8?B?bCtXUXVEeExHMWdQRkVVdnQxaDZuTHE4cmlxbFJoS3BnUGh4Y2dQUVVEdDgz?=
 =?utf-8?B?eEk5WUpFa2NzZmJGQW5iN0ZXblNhcUVuNHU1LzNyeDBEMGNzUGpEZEFVNTFq?=
 =?utf-8?B?cklQMzJhckhyNXVLSUdWanpsMytnWmNYblJmVjV3dU5HQ2wxNUIzMWpjQWdT?=
 =?utf-8?B?TWhFUkh4NzYrYkJlemR2T2I4UHZBSmtpcnVzVGtjQVB6Z1hOeGtsWENXMWVv?=
 =?utf-8?B?dzF5Y0l4aWg3SXRuL2I3b1hHd0F6T2kyRHFxLytFU3ZJbzNBcGtlQVQrb3FK?=
 =?utf-8?B?UHl5RE5NaURaYTFpdkhHcGhPdk1mcldQczBKalFWZTFyR0VKMFBwWWE0dVZs?=
 =?utf-8?B?M1pxYlVQUFlGd0hUcW9NZlBrcnNkLzFUM0hnd1ozUXdHM1UxSkZUQU95Umla?=
 =?utf-8?B?ZWVIdkxkVTgzS0pHZ1pIdzNVVGxaV0hRNi9hV2prL1QzY1FrNWY5a3dMNFVH?=
 =?utf-8?B?cE42d2xua2hmVDRxUjNSRFNWb3JFL3NHVzByMDB4YkpKd082TDBOYmU3L1U0?=
 =?utf-8?B?SnZES3FLMVdFSTF1eUxYZlZkdDFnc2QrZWJLd0xBYWpzNXMvWVFJNEtlTVc0?=
 =?utf-8?B?ak41M2I1VlQzWXdCRElaSVZYM3JacnkvRVl5bDJjZmx6Tm9ldjhrdGVlYXdu?=
 =?utf-8?B?QjRKN3BFRWNWaWlNMkVYc0xlTzNMYU93UnFUNTZ2dVRVNWlWMEdRVE1ZVzFN?=
 =?utf-8?B?SDE4VWNwcDFaQm5zY2d2WFJLVG5oRTBUd3BnemJLZVB6NEIrQkxKRHhlZEk1?=
 =?utf-8?B?a0VuYUV4UGdQMkJ3Y0FFcjRYc0Ywc24vMVRwR1dTNnB0SWZNK1V1dGR6Y0Zk?=
 =?utf-8?B?T2dsTlgxMVMwUEZOMFYrY2FJcFhqZWFwb2ZOMlpCNTQ1TXB5V283MHRKbVRZ?=
 =?utf-8?B?c29mOWhOTkh2UHNodW1Pbkl5NmdwTzRkVkowOHYyUGRVTUFCdDdhUEVNWEQ5?=
 =?utf-8?B?enl3Q1IxOUJucnlFMVBkRW9IaEp2ckZ0Z2NwcWo1eW1DSTZKMkxscnQvU3BZ?=
 =?utf-8?B?dVRsbG9YSlpXU1dJSTFoL0tNZzJ4ME1BK3c2YjNJWDRSam9OalROZEhKRVJi?=
 =?utf-8?B?U0pVTVNaSGV1N3JJTWNwb3U1UFFaSGR0NlUxdVhyazdvaGZvUnBGd2FYeGNO?=
 =?utf-8?B?MW05cDY3d1Zhb2xwWG0zYmhhZEE1MHJHNEcwU1FIVEtOZDhiNTNHUlFPZWVT?=
 =?utf-8?B?L3Qrb2JmK3JBbWsrL1ptRzFQWXZScXBEMXdUTi9XcGp4eXpGYzl4QXg1Z2dC?=
 =?utf-8?B?UXM3MG9ubHVNYThlRTc4MjAwQkttR2hwR3h3Q2IxVmRyVjhqQ0labGtDL0Jv?=
 =?utf-8?B?bER5QjJwMFlFU1VmZjUyVWN3ekpxaTc4a3FDLytVYVhzT2tUMHJuMHZXMHpn?=
 =?utf-8?B?Tm53TlhsSHpXY3A1NjQ2TXlUY3h0UVlKT0Q4dmZCYlBMd0VHdWUzMFZvTjV3?=
 =?utf-8?B?RDVmaFhJbWM1dlBvWmVGYldCbUE5VjB0NW0rTVo2c3RwS1dJMjkwOUpZekpH?=
 =?utf-8?B?ZjlUSHhLOVNYR2xUZ2I4dTB4bkNxS3hZNmN2ZWpHaWVkMmFkYmppbmxiL3E2?=
 =?utf-8?B?eS9mck1jdE1LWUlyZ3VmYmxXMmdzNWZVSHhNVFdwUWZnUXJlT0ppUktGTVM3?=
 =?utf-8?B?RWxKZjMzc29YY3RBNkVOSGllREJQWFBnWEphVUhLSXZCQTFGai9peTVzdTVu?=
 =?utf-8?Q?4A39IQDiFZ5ue4J6QAm+P3q2J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e119242-9c8c-437f-c128-08da633b0bbb
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 12:44:07.9920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WGV00erZcZdpObuLxvOzLscPq+URgoD/2umtjTFwTr0m7oZwPX1+VpKUccOW5J3uWCnLTtxeLu0rCobWMIcyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5054
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 11/07/2022 10:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 230 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> Mark Rutland <mark.rutland@arm.com>
>      irqchip/gic-v3: Ensure pseudo-NMIs have an ISB between ack and handling


The above change is missing a semi-colon and so is causing the following 
build error ...

drivers/irqchip/irq-gic-v3.c: In function 'gic_handle_nmi':
drivers/irqchip/irq-gic-v3.c:666:2: error: expected ';' before 'err'
   err = handle_domain_nmi(gic_data.domain, irqnr, regs);
   ^~~

> Hou Tao <houtao1@huawei.com>
>      bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC

And the above commit is generating the following build error ...

arch/arm64/net/bpf_jit_comp.c: In function 'build_insn':
arch/arm64/net/bpf_jit_comp.c:791:7: error: implicit declaration of 
function 'bpf_pseudo_func' [-Werror=implicit-function-declaration]
    if (bpf_pseudo_func(insn))
        ^~~~~~~~~~~~~~~

These are seen with ARM64 builds.

Cheers
Jon

-- 
nvpublic
