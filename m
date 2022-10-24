Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF3260BC10
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbiJXVYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiJXVYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:24:14 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2042.outbound.protection.outlook.com [40.107.101.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E689F204AC9;
        Mon, 24 Oct 2022 12:30:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtgKwmF0l/CvQiGc6jbJGzQopXSRkXL30tWGvUZerHt0WsTU1OE2F8PZ++BgVY6USFj8wMbu7PGW3ew/fQHtm2rOlLyBzomarWd+kMVbI1xELJRU5rTfHj8mdGcC/SNvEiSpz0ywEgGyLNb0qgCHFqyJVMzTcaX1nqPBhIvPY7McYY3ACLaxX+oXngz1dEmsFPZXKYjL7NpWqmfyXgY5lr2WNaOkW5r/hQH0rIHsIKINdVybwt3HC9gyAglCx1fEw8wGDc6Rm5F05O9H6+nEQwErUIiLlBE5s9d0+qhM9BYaMv7cAGULG0EBFjsm3KTsl+bbOk1NtdRL2o77a+bVtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OihZybG2E9XgJgLg+2STNo+igkFycv9RLNhn28lZKKg=;
 b=ev3yDUPKkstZ58FQYJecMGrJy2ZTeu8+cFB+3fCtbKlOhj7v4wacAPCWO2GZUSzEfHqCw5TxLva1hxL/hfIk3x3RvWhf+MAXemJ5dk+5RnUtK1rx9K7jOaH8W67gx4mG1mtBkUrlCeaWPu7SVUA+AJvjFyb418fy+OgmCbjW/K1osOQM8LEDJrDfnjZ1UlIjRuPg1u+k3cU1u4G5/qlToVbeCwY0LtZfEYHwT0gGGwG0biGrmeN6ns1dPwGPaQu5yrKaiusnNQs9bScX2dIHotRoyDwNHKmHrQNHX1MdYa3bqIO9yvslSm8r0NfY+YQl7px419x6xEwIluhNX1U3QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OihZybG2E9XgJgLg+2STNo+igkFycv9RLNhn28lZKKg=;
 b=b1OxNd2orNxr+lxyqHOn+Dsjqf2+8jRgRXQGqoh9uVhv6VSmHSNb18/DGji/SLbatUyqC1Emw7GZTmAqayZzj3lzO5MaPpLTO2Ph9Ab5eUbhwRn8/q8OWdtt8/rjxbXd+7T4EKXqKQ1QAJYMhSoq7RuhJENNZRSOGZe4SgziJO4JmnaqB49Xf5xZdHx9UHxq4HsQxZfFuggy7Btv4gpSxabCI/kZYcNyyw9XkgDmeEInUHI9J6g2ffPr3H2FvLrU69vYuKlbbM5x85voNmYMiljVyOI/+CmELUhfMOysrUgaFmGT3w+DtyLf2kDAwwi6S+VF+xpI/aj3m37VspHp3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 BN9PR12MB5067.namprd12.prod.outlook.com (2603:10b6:408:134::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Mon, 24 Oct
 2022 19:21:33 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66%6]) with mapi id 15.20.5746.023; Mon, 24 Oct 2022
 19:21:32 +0000
Message-ID: <f668441f-761e-7929-1e97-e48ca1150473@nvidia.com>
Date:   Mon, 24 Oct 2022 20:21:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20221024112934.415391158@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0014.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::12) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|BN9PR12MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: a9eda405-1768-4eef-2ee8-08dab5f4f5b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BUpTU8MFqGaJclo7+wkgTZGd3v/vDxdbQ3epXQtdrbKDOXYy/uOVOa5vuYTm2PU2DZK2CasCRAeJnsNufpwHyvF3dSoNERa7GT0ccFGL2NZlPFWlfnl+Vn6HkhBFuMexCob2PYhwPhInGM+Yaqyu6zvA+NI9yv61OjVCYcxO1cmtErwHdIvvS6KrLEJHY1My7vu8TH+FOqAI9D/tZfoMXh501LGALXIRrd6ESqjGtR7Br4HTFN5ZfFbDUm74lXvPvvVeAZT64b8OBr3PUjA1UqVHPvF+MkM4MCxfTlAP4EqrjgekTmKOX97buQrpkhrbI1NfgDSoUPkDYL4vhBTi2tkRp2zAVmL/l3yBxPSUafx/3N8Kefix6iZF5N9VFTh1ab7/F1r55e0/cUAgIonNm6FZYGKOwovmXacY5WaHDLxejfmg2vz5wr44TsFa0mkixtqsXkCF5sVEAueMnSy0zbbnSyRMe5Z8UH0LYpyQ05kzxscfzPHGvXPNTwfDwds4IvTxaouzgTls9nxoTQcfAhfDhpfnKp2lM72O1JaPSvpZ3jm9bMePBSm7cKfk1LYM8Hh+m5qrseEhMBanhRoJ8YuuJtP/7w4hpJIFUZNIk3a8SE1L/SdOfjQGKm0E+tX4e/tUgqcQoEHX9bEeTYX4xRuGxS5nrec2PD29utOoGIRUeLfP16h+lB/unMLGdi2HHKymAF1TGi9bVrNp3vunSAzAk8VnYz6nrUQy5WDj77A07EGo3UEc3NSrgcysfj9QvKcBpvB6p8wsHj+RHryoOPMsXHWxg3qbl+L2suRRBtu0rkMkSS3vd+9JOtwwkDVTQojosNq4FOK5qJOn1diCiHRQv8DEznqicY6to92Weieww5vlvHyfzMLq9zakBuhs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199015)(478600001)(83380400001)(66556008)(8676002)(6486002)(2616005)(31696002)(66946007)(8936002)(86362001)(186003)(5660300002)(966005)(66476007)(316002)(6506007)(36756003)(6512007)(6666004)(2906002)(41300700001)(7416002)(4326008)(53546011)(31686004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWRlc1ZMWTdWVTNwV2RUb25ONzdHcFBaMUprblNnS0ZGM29OZzI5ZmhORStM?=
 =?utf-8?B?ZmplZkNzTUtjYTFNUngzR2R4b0MwaHVnZFNSU29PY21lL0VRLzBBUW9rcnpY?=
 =?utf-8?B?Nk1HYVFqNTQ2RVRmM3dnMGZ2b09HbUMwR29YZ3hKTytQOE9NVmo4YU1qcFpR?=
 =?utf-8?B?Q09lTXR1Q3crSWZyWkpJRGg0SjIreXEvZ3QxMFJ2eXh1WVowaWN4Z0lmTHpk?=
 =?utf-8?B?RHNLMDJ3ZWtiRkRETmJlMWJ3cTNJemlIYUY1QW1DZldnaGxhZ1hRYUdVRU5I?=
 =?utf-8?B?ZzdRZ2tFVHRXam5pV09TUjlCTjl2OGc0Ukxadi8xUGNwN2tTU1huN2RNTWVN?=
 =?utf-8?B?NjUrK0wrU0FHajU1OGVzQkRxLzRScm5va1VBaXdsL1FqZTJMdTZqT0F2c1JP?=
 =?utf-8?B?SWI3QlQ1aFFXejNQWWxQNUFucnR4cG54cElHbFQ5YjJXUzRET29YTjJwVWNX?=
 =?utf-8?B?NzdiVG5rVFJncGFsbEZHQXVBYWs1Vmg3TGlTYzA2RzdOZENXTy9jcW1hVHgv?=
 =?utf-8?B?NVRFVlNKOHZJRUhtdUIwZHFBQ0Z4RTdEQ3VUa0sxSERteVBvYTJONjlzWjdB?=
 =?utf-8?B?MWRTbEZyR244WGxVZ0I2V1JZdHQ5aGpkVUN1elhUTmt3N1YxbzBuRE1UVEh4?=
 =?utf-8?B?U1VLNlFWbTNUNVRBVW16ajVFL24ycnZveDZwY0RqRmZPUHFKNDlwMEhrb2Jn?=
 =?utf-8?B?TFJiT1ptNW1YZnBnOXl2a0tEOUVTeXY4RXdaM2xQNUZHN0p2MS9wT2lCNFRO?=
 =?utf-8?B?K0UxbUtoYUlSZnN4YnNkMUlBNktRSXV6ekk2dG9KVUNheWNBU2lHMjRUMXlO?=
 =?utf-8?B?SUM3VUE5ZFY4VXNYYkxPR2xRNzRESkNZdTZXdm9wNytFRytiLzB5d1JxR2kx?=
 =?utf-8?B?UXIxa1V5ajBqR081a25YRG9WK3JzRU5xcW9BNHBwUGlMU0VlbnhZUHJzWnBP?=
 =?utf-8?B?OVNTYVVKNTg2eU9uZ1FvNHFHK2NpTE5OQWxqaVFBUHp5SDV5ZWg1eHpGNm5Y?=
 =?utf-8?B?Y1FZdnhuV3h1SSt5T3dYMGxqRlh0ZWdxWmFOTE9FN1VoZWNzeDIxdi9yUmU4?=
 =?utf-8?B?eW9uNXY2VnF6Vmh5Q2s1d1l3SURZZGcvMzdiZEhYbTFCNGYwOWxsa1F0Wk5C?=
 =?utf-8?B?V2NaS010a25sbXFmZW9IeGduRmZNUlpnOFBVdUpFeEY4aFJvZW43RDJ1Yzhh?=
 =?utf-8?B?OE9UaWxwcWVwdjRwczZ3Z0thS2ZzQ2pUczZER0JydExkRGRzSDRsVW5VM0ho?=
 =?utf-8?B?ajBLVkNoOHloZWkyNVV4TDF1R0hPR2xBYU5MWlVCcjhKcUtGZTJjd0lLalBC?=
 =?utf-8?B?M0Z5ZmxEc0YvdFVCdHFlZGI2SEVIVzRTMGwyQ3M4R253RUZRWDhXMzVZSmE3?=
 =?utf-8?B?dTZMYzA4c0V6cFlEdytMTlBweGhhSHNlOS9PYVM1d2h6WS9MN1F4SHk3RXNm?=
 =?utf-8?B?UGxtVVVsSDJMSEh1cHNBbkQzMGJwaE1Tcko2Nm0vWEhkNS91NWNmb2NEZUJF?=
 =?utf-8?B?OGtydFAvc0wybHFrUEJqaXZGdXFENndhNDFQWWEweFBQbnora0tMT3FlVXF4?=
 =?utf-8?B?OTAralYwYTN6aENOa3dHR1VPa0d5SjNGY0F4TkY2WWhjZlE3YXVpRTN0TElj?=
 =?utf-8?B?VThtY0NuZGdTTmhLZmNMamt1RXkyeUZOT1hXUy9Nb01lYXY1WjRXS2VyZGEv?=
 =?utf-8?B?NjFOanpWMDJtQzlTdUlqOTJKeGkrVGUvOEZIUDFOUlFKMW90RTFMS0RmdHBM?=
 =?utf-8?B?NE9wNVUzWERIWkVuSTkxN2sxUFc2RXZCZndPTWh3M2FUUThLM2tucFdTekhy?=
 =?utf-8?B?T3g0TjVPR1docGVGNWIwcCtWeEt3UXBqV0xVRi9mYjlxQ0FTMklHYkN6Uzk1?=
 =?utf-8?B?eGUxVWhqYnBpZHk5YndHYmN3UXBMMFhuY1pRWHNOUExQRWxYTEM0RHBGd2xB?=
 =?utf-8?B?WitGTWtsUkVWMTZxL1V5YVdFVWRMd2NGWnR2dWlXSVlaR1FtbkpTOUVKSGFa?=
 =?utf-8?B?SThIVmh2VmRFOE1ud1ZTNGRHajREejNpMFQ2ZTVraitLUWI2WTlmendrakVC?=
 =?utf-8?B?R0dNcFprb004MzJLRVMvdTI4bEVlemdDamNDeVhlUkttZGc4MUQvRUtlVWRZ?=
 =?utf-8?B?WmJocTN3YmRXSzM0QUFPeVliWEJlWWFVb0xvZTZTQlc2eUFCNUlzUHk5cFJw?=
 =?utf-8?B?bGx6WWVmQzhCb1ZWdTYwSWF5UVdUYWJyVnV1VUYzREpCT2Rwd2RsZ0tJVDhF?=
 =?utf-8?B?dUc3TFJueUN3WThQN2RCdzNHKzVBPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9eda405-1768-4eef-2ee8-08dab5f4f5b4
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 19:21:32.8200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GIZftkc2MK/wuknd1Zcbvg7g+WcRqmvfS/Ej157dkPHD3Ncy/QgsCbOrsGZAlz4S5dvHw41ChcYz9/R53L/DDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5067
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/10/2022 12:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v6.0:
     11 builds:	11 pass, 0 fail
     28 boots:	28 pass, 0 fail
     130 tests:	128 pass, 2 fail

Linux version:	6.0.4-rc1-gd4150c7b49be
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py
                 tegra210-p3450-0000: devices

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic
