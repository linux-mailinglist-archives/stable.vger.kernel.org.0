Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512BE54DCBB
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 10:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358862AbiFPIVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 04:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiFPIVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 04:21:35 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852645D658;
        Thu, 16 Jun 2022 01:21:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8TeDOyFxzWMnKyMA4gB9aM/AEQ7HaQb+2B/Zh2YLjngT2VvJqHXu5VxSub9IcrnUsb7qLKOVOaoR/IWf/TSnvGaqhIFzP/g0okFY+xb08NmxYFgiB0YqxcKD+2R10u2/oRNOrJwh48Yh5pddhw7o+uy7lVTRt6KFbxl8olQg5dWeCG3EShQgxeDMuz5xAGk3pJkhgWoR33RFgoVKAlRdOAumgi/OGb6cPMPme9q8wjamPQIdy4NWSyKmxMInXZpzGhDB8EZ6yHKROceP7ohqnr8pTsgbzYcHPzUC8+UlVOTiNY9DWmXfjoXyQfwKcINuCNYvv2Gx9LmIyF/Bz8qTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xpDJR3Axed+5HnJwBFUw0sYqz44nD1fTlCkrVYN2Cmg=;
 b=a+jq7FgztGn+isQX95X/I7DTFPZgQx0jU2h22DgmfFD+vyPFUNHq3plmoy0gJ+OBwV54aTXZpLUbuENCxwYb6DXrhFshS8NRZtKaIShbEmms2K2hZ/QvnqLZQC1fefnbQWoCkFKS4jxQXhT/oSpjHm88dL2l8ljX4OLdZxTSxPmGRisxcYvwB084i4kr6yN2ultZ06xynrXgqObOadW3IN1SXGh4nWNy6uiuEhppf+6hy5y+AGB4GD8mdD6k8/KiyD236bc1rEcPmY0oI7/LAvkQc33n5NZxVQx0Fx3RnUL5aKnxYxLfXyGCxk9y6rw2in4z3TKMR3tOTG8qbH37nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpDJR3Axed+5HnJwBFUw0sYqz44nD1fTlCkrVYN2Cmg=;
 b=oTv92HrvT+HsycM6WPaYfYbHfUXNj+AIzIOQFVFvLIMXdLL0i6sBMsBVhymMsn59x4YEkiYrcI0FDNEtGeJBm7XbxZs/c0yl2Qi44qIMv9aDpNFuzwVAVVlkx0Midwc5FdwBTC2LsvHuMa+aZEnnU8rMtHKZ1fVy/87s4zUMKweUKcDTQRiCZXtVWFcJut5NksoGLd3zfyPPqrLwTsY37ZgZJGgFJyXvDAvDo1VDTFsDUnB5YzFY6D5v50YbzUCKxsE49nggLGE53RYIdRC00vZg5zDspcuCEJ1DdfIKKTjF1xi6e5BTYTDlSov750z8GZ2QINDtWsCjbHRIuKLoog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 MW3PR12MB4393.namprd12.prod.outlook.com (2603:10b6:303:2c::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Thu, 16 Jun 2022 08:21:32 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 08:21:32 +0000
Message-ID: <afee065e-2022-14f4-a4a5-0b2599744f5f@nvidia.com>
Date:   Thu, 16 Jun 2022 09:21:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.9 00/20] 4.9.319-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220614183722.061550591@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220614183722.061550591@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0077.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::8) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 438dc7db-0c14-4bd5-3080-08da4f71385f
X-MS-TrafficTypeDiagnostic: MW3PR12MB4393:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB43934C12024702414B443B93D9AC9@MW3PR12MB4393.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ip7p84Csnusxw0vQOxK/FBHozoY/DMXtFOEZAGFM+u/c2ejoKQZFrK+hFeY2kz0wxfVTf6VWoClPp6CLvCH1FhXCUiIrFclVmA7pJdphSYc3dOQmoBfLNbVvV8cJGy10LnjAxpJZ5lviBRjkoB2lqvNdlFYeRvNAWpOdHZvi7PmoHqup7rumVEjMGvnzB6TomwbKWCiSCw0eSbe/fQXv6Ajr9yzf03gSzVjbCUyrmxRG/JgIc3CSvElDzxkRHkrljgfAqqHkd9JDusiHHaxD/LHeSQ4RaWotLwn6Z5byz8URATr6gbeUxSqLPvGyTWXlUd7tJXYSVMAjo6dL5skY5uy69jqEDH8QiGPfp1QRy158g4NUhF+i+86iNisPu83uMBHmEIUaO1xvjt/8qbGjaIBdJWU8v/fNL8Ybb7fQ61Lkfw/8ul1NRja+8UkSuYYIbnJ34RDxjfh88px8Cv3LxA11yem7KI69kqnBB2cMyQQSD/amUdLnFgs0LCuqVnE+AEabuZy3s6hZeqtWXRpuhRXK6yKJvyDwnRFrz1fjRN/yk280cKn04MYwVzGhSjvobmr02Z7WlpbPP7ANb1R8IJRhU7sXnIX/W67vSjsdwZRFvpV2aCJO3vY79AlXlUut94hnGaD/YTmhVsMJs06FIzpi4r2UxxDNhlZxDavMSnHG9V4FlhA2mUIPdeZd1zDsRGNFrwge4xKomnjLD4BZch5bxvqs8G4RE7Z5D/IxjqRTg+vCQfk74+yFP6aJiuV7C1lUYk8+dTfwSGATJS3+6fpZHOSw2DDuOagiOd/ivD+iFugWuTZV3bNfkDUUW081eROhYLjOEce0MVTwM0dNeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(38100700002)(186003)(86362001)(2616005)(2906002)(31696002)(66946007)(66556008)(31686004)(36756003)(8676002)(316002)(4326008)(66476007)(53546011)(966005)(508600001)(6512007)(6486002)(26005)(6666004)(8936002)(7416002)(55236004)(5660300002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REpyYUFtUkZDanlHb2w2d3I1YkJ5YzJMZ3JsRWs0ZzVucG4rRkdVQzFJNjhj?=
 =?utf-8?B?MHRCWnYxU3hWdHJ4cFhoOGVTb2MyMnRhTDRiR0lNb21MOU52eWsxOW5taDRO?=
 =?utf-8?B?S0FraU1Wa3YrZXlLc2JEU29wK3RObFNNbmFaeUpHYitYVkdlamVsNVd6N1Rw?=
 =?utf-8?B?d1RYeEJLYmR0bE82Sk5IMklOUjdyaGpjMUNydzA2NkJCeHJLWEpFMHVLNTk4?=
 =?utf-8?B?dTVRRUlMVGdqeFZicDh5ekFBTEJ5L21xa0szNG5iTTJHT3EvVzRjdjlhcEh0?=
 =?utf-8?B?anZUWXhBTDJsWmpBa0Y3U1FYT0ZTb3JTeGhROEErckxkRnhMbzdqeXJwZVd3?=
 =?utf-8?B?czRxUGFWSmpwVVdRMDVpS2RtSDFIRWlZN2FxdWloWW84aCtIdWZtZHc2VHNy?=
 =?utf-8?B?TXIxNHc3d20yQ0k1SDdIMmVPeHJRMlBwWE5MZ2FpeFN6YWxSb3E3L0RSUm0z?=
 =?utf-8?B?aEJiOHNhOURFbVFlNlZQZkxQSTVzSEdPOXlFZS9meENNd1MxN2NnR1dYdFBI?=
 =?utf-8?B?ZGY1QkpWSHdsV3NnYzdheS9vNHhzS09ZNjVXL1d2Z2xSNld3UWpBdUF1SE1j?=
 =?utf-8?B?amRlVUdwblZKZ0hIODR1VytmTDB2UDVSOGVqbyt1V3kvYnRnb0hPMFV3a2hq?=
 =?utf-8?B?ckVGK3hwektlalZwMEJmTStoSm0vK29yR2tLOFA5L1htd1I3Yk1jYUFkRWoy?=
 =?utf-8?B?UTZDQ3R4alNsci9XTTNyQTBvUVRRdWE5emxCN2dkVXVIUGpQajUvVEoyU3RK?=
 =?utf-8?B?YWRzVDNPaTlpajFVSm9VOUhKbmFxcHg5MEthNURCTFoxY2M5STVMMG02Y2ZP?=
 =?utf-8?B?U2U1THFVM1UzU1d4aHp6bVhxdUluaWZUNnZydGFYN3BkQXovUHlGVFE1WU9T?=
 =?utf-8?B?bnZSVXpqMG5CNlU3VGs2bGs3MWQzRDRZSUtxczlma055Qm11eDNIVXlZbHE4?=
 =?utf-8?B?SUtRT3NUcm1lanZvYXB6eitpLzBOSlhFM1ZYRDg2L1VKZG1CRmFlcVEwQ1Rz?=
 =?utf-8?B?Z0VKd0lZSm96d1YzanRCMXZ2MWlBc2R5YW83Qlh3UktkTElnS3dBWVFkbWQ2?=
 =?utf-8?B?alJGaTZHWHpWR3dWa2dTS3BhcFAxZ2VHK1hvZlA5TldsbStYZ0kzZnd3ejEw?=
 =?utf-8?B?RlI3SUt6bnhIZXRSVHFsbXpVc0NOUGhpZ09SNVpVQTFEcHJiZVRyOFMySDB1?=
 =?utf-8?B?UVowS3hwNitHTk9OZ0ZCUEIyOEk1TldpbmFqYkpFci9pVFpnOWEvdUdtTDZt?=
 =?utf-8?B?cjFjRHdCek8rSGNkaHZlQklQN3dtTXdwR3JUQldGYlJIMXlkWUM5ZjlPREQx?=
 =?utf-8?B?NFhZc3pVLzhxTk5HYjQ5SW5DUzAyeUV0YlFGS3RPN3NEQlJoY09FZERDbzZT?=
 =?utf-8?B?Y25MNkxaNlR3dGxMOFpUa2w0V1haRGtaWDFCdEk5U09yd1ZlcXcwMnNSYjN1?=
 =?utf-8?B?QjN6NjJQZGNMbHYwaHlaVEhJUGxSQ3dZOUpxU29VcWVJR0QzUkg0T1dzWUNF?=
 =?utf-8?B?bmY4OFVKME52djFZU1RTenJQckowczJnaEtkaFg0N0dNTHovVitIWWZNbTEw?=
 =?utf-8?B?dTZGeHZuQUZwdEpIRjJhU1JmSSs4Um9nWkJ4UDd2dEQxT2kxWlo5TlIzZDkx?=
 =?utf-8?B?R1Jsb1FQSDJpbVcyeVljaHEvdkx2Y29KQWh5aktzY2NzRzI2NmlQbmtNQit6?=
 =?utf-8?B?eFpva1o5eW1Pbk4rOEh6eXBpZTJCcHo0T2dMSmkvU3pkYW92WWd5ZmIybTQz?=
 =?utf-8?B?N0xCM1laa1V6VmRTQ0dZcGdpekwxdlJzSXZhNU9MMVZHVEtwTUIvU1ZRUHN0?=
 =?utf-8?B?c0ZZNEhwZTd2WHppL2ViWjlxUGJjV3B4TXFxU3d0SnhFUmpzSGwxRm1ySDJZ?=
 =?utf-8?B?K3lENFhOZkp6T3F0bkl5L2NZRjlHWjYxck1PRitPeDZFaXo5VGZ0ZmVtNEJL?=
 =?utf-8?B?MU4ybi9YQXNyMjBvQU9qR1hqZFVYRTRndWEzRFYrdlN1MnRodWdwWXZNaE1q?=
 =?utf-8?B?WWZrV0d5UzNYR0t2RDZibGRaYjdWcE1zRWtZdGhwWEd3VW9NZlJodnFLNGRw?=
 =?utf-8?B?aEZvTUh0S0I0UktNNDljekk0THB2RnErUk1YQUdaMW1CTjFIWXV2azRnL0Vw?=
 =?utf-8?B?VFB0cmdyQXRGU0dsVU5uelFNOGFlYms1MytrK3VkR2NoREJqaXhwR1M3UjM0?=
 =?utf-8?B?N3U3MW1oYStLdVdLSjRRaGd5ejhucmdiWC9UUkwxdnI5bFIvZWJIbjBaNWdl?=
 =?utf-8?B?QXlsbGpkTEVhQVRwY0sya25GVEE5ak5qRndwVkp4R3RZMXhPWFI2MXl2Qk5x?=
 =?utf-8?B?U2JPSUxyckM0Wk5JS0JrdGpPVnNqaUVjdG1Ock03ZmZLRWFrVnlTS3NwV3RY?=
 =?utf-8?Q?GH7TGm1A9ft5PeuY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 438dc7db-0c14-4bd5-3080-08da4f71385f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 08:21:32.4351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXroOubicMRePQRuN2Bloup6T4CNU7ujZmLeDHjw95+9asdWUyc1uGYOlfHHBfk5qlY375lmm8sAQtvzfLz1UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4393
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


On 14/06/2022 19:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.319 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.319-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
     8 builds:	8 pass, 0 fail
     16 boots:	16 pass, 0 fail
     32 tests:	32 pass, 0 fail

Linux version:	4.9.319-rc1-g2b5bd1d9ab58
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                 tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
