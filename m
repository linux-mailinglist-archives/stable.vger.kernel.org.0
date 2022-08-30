Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4546E5A60A7
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 12:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiH3KXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 06:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiH3KWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 06:22:48 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE03A120A2;
        Tue, 30 Aug 2022 03:21:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmlhFnqY3ghb8zkSUBjxUszKiZI3wBnO+P7XxPl0ULpE9c+Gp2duFUwP7SCRzNj5SQ8P6mOYYJv7eb0AgwPZtxu3YTJOZSshE2vAmFL2Wt32aqbPZh8z9UeZlAncOlMX180lnqxGGmBkBi6Wi4HE3mMeAjZW/u9Pp8cJGT1nYuatatB8Cm+YQkYw0wenhgEB7YmGdhkEiVhRODVB8o9rFYWWp68B/gFtrnlBebArsp5teoOO1iFnRDCJp3Qcj4Z7b3PopfhvW3lhEhNNsc9yBsz7GC+0iH0v/SE3vQyQt43chb16gy+/0hFRtxfoVrTtAcU8uKcCJnhESxYj/1CC4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W55V0t2bw81uhkh5bWk3oyoreH1A/Xs4buoJW1XU9xo=;
 b=dTolQPU8/zZ94iX3ObD1zTmCb7CTSRIB5gv9kNis3oqLAKQmx4nqiX0iRl2o/NgUM94pRaHl/+WAI/KGSwfUBL2yAdRLWoEl9Q5cIxR42+IMnPzy1WZdL3XtjJ05mn9jKYQbt6xCZj8CT/fah3bzHD3427rdHKu9pm7aQC3m4uEmgUmkslkIYKDOGPCwqGVK2V6kR5mpxBulzOBKyLQZuQgks9PJY1kg/uJi4wsf0ppNO6kFJ9mZwfg5Xe+jdtD6DMEep8F1WFjW3TB4N4PogCkTOZMmdhfcKocZJKthYbY25O+wZEcBJT1VZgi1jdE0oDGyO883XpSWZS6oCK2o4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W55V0t2bw81uhkh5bWk3oyoreH1A/Xs4buoJW1XU9xo=;
 b=Z7jTkPj8a+Vg9Zg9iTsEPXIJLnGh4mzHoRY0vj0/HYgWrQW3nJ7xzlx3AYh3M2BZlzaynDQfeBsEAJ576gP2UAp1iuYJUz22ZkwFIcQUiZwfIXLu0f5qbd3Trep15tElye+FCrnc9NiGWBq4jW4o6ue5UXfzekjeOtKJ0EIeOMFml71Dle6R2233fYq6P2g8a7rx7GfP3wyhXDKb6vrPCysX+3NtsDveZRsCNxW3FACwKWi2aRNcltwvy0mFTZJXIbsp24hoCeXQwi9u34Z6VFQVKZEsSGPEURjNcuXFucDRjfzyJ41eeCftJXpW7HTeyfaM90hYifoGaf882QzIag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DS0PR12MB6582.namprd12.prod.outlook.com (2603:10b6:8:d2::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.21; Tue, 30 Aug 2022 10:21:57 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599%3]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 10:21:57 +0000
Message-ID: <676cd5b3-8b7e-0f18-b165-84c27a317f2b@nvidia.com>
Date:   Tue, 30 Aug 2022 11:21:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 00/86] 5.10.140-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220829105756.500128871@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P193CA0082.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::23) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1f7fb44-4df8-4af8-4dab-08da8a7177af
X-MS-TrafficTypeDiagnostic: DS0PR12MB6582:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tp9WMb82hgOjpQ76BhXMfV8qULyGSXTNDqunZSYiCzMWOcGAqjnE2E5lHc1ULkAdJvr8SfDfPxwnVH3LAsdeOjdHASkmLGR8GxbEtU5FluPxt7L5550b4tqsoHjUkOFPlZUlgcUeeZ19IHR+uU3Iob51kVRZ55iJKFzGvr/drAqvswmroOGV/f/9i4fyjH0++tOTUulfMnt7jS0jVDXyzt89BzH7BJ6DTPiArY4oaJSqAW7G5iFKvi9365tmBMmr2C+aMb+LSxV6citmPnE+ASQ2oavW0UZ0E/DgFd0PNNie7sxTigmEDKavZqmYUhhh4zvX9tERvVTIObA3uPgRBU9pUPJxhrR1a1s9YIAAWitlJFlaWahW+w80xwJQADVfNSobl/lXLuoP3L10CkOhsfG4//w88tDn966pBkiYIkAcnEGRVvh2JzEkBjoJIzKkfJ0QT2Y09RLbW1h84H3u5iG9jpive8vJg+FEP86Ysq0tc6E1G3uI6WyMEsIZUH3ZmCQIkR40sljj7peApMSRa/WqNxFyL6A4xrVLf5ssv3ZO6YiOC9tf/EckTLaf3LWoQjB1sg90X3Y1vOa9fmc46vmtuPn9X21ltm0Pj9BuAkR7Dh1kBit9LR1ahIzwuNK5I7I2OtdkyEi1e4wNF+ZbtbAyA2oNn6APvwCOz6qx0GsU+905YVgcAaPI3LVkfLNifo3f8vD185+aoRQ5tAbNDYsf2bRVLr67uRFfsmoep/oZIeGUUBqSf+m3eR0cLPHyttQIXyiBhQMYu09/S98u0SjmiUe1hHIykJnK5cx7/bW2vbjuRudQODRV7e0GsLi+Cpf/dDQhMBAAncZwwRBHQeyDYuhuNQT8D6hkAw1RUM1UxurCNbpW0wDsdgN6rj/r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(7416002)(5660300002)(8936002)(41300700001)(186003)(55236004)(2616005)(86362001)(31696002)(6506007)(6666004)(26005)(2906002)(6512007)(53546011)(36756003)(316002)(31686004)(478600001)(4326008)(966005)(8676002)(6486002)(38100700002)(66476007)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWxJVFlWV0V2aWZ2dGFZM3RlMUlFbUl0ZlArb3NWYW5oZGRFVloyelpFMDNX?=
 =?utf-8?B?L1Btcm0zRmk3Tjk2UzI1aVRHZ1l6eDBtSXZadG10L3ZzR1NWNFd4TndwbG9K?=
 =?utf-8?B?VFdPY2lOZEpUclRRWDdjZi9rYnhOTW45bXg5RjAyQWhjalc1MnVhMDZYM3dh?=
 =?utf-8?B?Q1RsdjVlOVZUMktiRUhFU3BMM0M5dnJsSjduRzBZVmtrdkY5UnBLT0NLaW9Y?=
 =?utf-8?B?NXFsN1VzbWdrQjNNOU1OelF5VXJIaFI5aUY4ZXpZWmNyZXgvOUtBbnZjRHVW?=
 =?utf-8?B?NHU2dFpnd0VieEFJeFZiOUJqMFVheEptUDZPWllhVXAzWE5pVkFXMFpFN3d3?=
 =?utf-8?B?T3pJOEQwVkxYT1I4S1RHYXhTUklXanltckJWZnV0ajVJYlJUR1lrejRJNDF3?=
 =?utf-8?B?a2NoMm9SZmdHWUowMzZHbTZqbmE2ZG9idkJPSkptMWhjUTExcm52MStrR1Nw?=
 =?utf-8?B?YVVYbmVLTFdrMEtYeVNpZ21zWEs4TFdrOUh6bUhHUUQrZEhRUXF1ZUs4SXZW?=
 =?utf-8?B?U1RaKzNFM2hBam0rK2srRnpJT1c2cEwweS92c2pBQk5iTmJYUi9MaHUrcTNo?=
 =?utf-8?B?dU1nREJacWliYTA0KzVpMFYzZExQZGhWalBEQ3RWOTVVVGdkcUx6OXdEZWtM?=
 =?utf-8?B?eWJWdzh4R1RiZ0VMNC9OcW15czI0TU9tT2xkWEFEQUh6TmhaWWtOeWtZZFRX?=
 =?utf-8?B?bElpZTNPaEMvVVFFQlNQZVp0SDBEQWVoNSs1NmhhdmhkUlVyVWd2WS9zZlo0?=
 =?utf-8?B?Z1dvS2VpWlFqTEd4ZEpwaVU1ZzhJTUhyTjVFNGRsUVpNSjAvR1JWbTRRaE9S?=
 =?utf-8?B?cHl5SndoWnE0b2lXaG9GTitCa01ySFQ2RDY2Q0RFcDhzRU5VUzNHZHFWOTcw?=
 =?utf-8?B?WU56clBLWStHL2pzRjRoRzZDTWJreURzTHhNR2dHcWxtbWZLbnJUS1l2eGxW?=
 =?utf-8?B?OWRiRnlQc2RZZ1JPcTdRZ1lzYzBneGRIRFJnM3lINy9tNVQ5ZFB4MEF0aTVY?=
 =?utf-8?B?enllYTl3NmlCcE5jcGc1VjhTcDFRQWM2a3BPSEJjeW1wZ1lFYVVpRjkzVXF1?=
 =?utf-8?B?ZUhpZUsrK0JKbVN1L3U5aWpHTS9ucDJBUXVReFlPMEVma2k1Uk5YMkRLUU9E?=
 =?utf-8?B?MEhJZ1FsdkZ4YTR1bkM4aHlQdFNnL2N3ckJMOVkzRE5QcTUyTUlYdGxBS25m?=
 =?utf-8?B?SXZiNXl0d21kdVRiOU12Vk0xRTNMc3ZLenRwdTVmdlh0RnczZFlBVTZoTkh5?=
 =?utf-8?B?eFVIbDhzT0x2ZUlBc0N4VjlLUCtTekZzVUN0WllpNVluOG5ieTRPTHNBZzNB?=
 =?utf-8?B?VGZWUkp0K1QzMktNWGljelVPWi9EcFIwS0ZoVzN1enFtZlJ3eTN0cHFLVEVs?=
 =?utf-8?B?YjV4UGIyL0Zvd1drcFNLQm9FL0lwNEZBTTVVdG53WWJyeHI2WHhHTy82ZGdk?=
 =?utf-8?B?N043WHNzSnVzR2czQ1FCT2lLSm9VL3ZnWlk2WmYrRFRXd1Q2QXZXa3VOVHdz?=
 =?utf-8?B?aS9ieTVQa3ZmUXMvM09GT3dTbEFuaDBOOEEyT21qaTQ1c0dzQVA5WFhkVjhV?=
 =?utf-8?B?ZU5pU1NISzdZRkoxMlVXT2VRbkY3TzdiaTJqT2xnYVpacFV0bDRJNE9vU3dQ?=
 =?utf-8?B?ZzJYRnlUZ0lpbGkrbjA1dWxQNExHYUZBTXNoQ05yc0szRDJTQUQwMGxRcEdE?=
 =?utf-8?B?R2RZa2U2L2pZSkN5ODlPOE1NSXJLMEZiUEZUT09UZlpVV2I0ZkdabllBNVBI?=
 =?utf-8?B?aG5rQUJUYVBZSmR0ejFGWStsSWlQSk56Qzl3T3FRNEV0NnNjL0pSR3BRU0pz?=
 =?utf-8?B?VFpiSVdYeFhXV1BHMytDRlJ1YjFBNHA5Unh3N2hOaFY5SEh0a2lKeTVxWkth?=
 =?utf-8?B?MEwzMU8zOWFZYk9tMSt6ZTdDM0NRV1VPV0VMMitpWks1N2d0bmlqRUc3UWFB?=
 =?utf-8?B?ZkdEK1Q3YlRZSHFMRUJhZ2FlV1RWakFaRUI3ZDRYa0hLSkhDVGN2ZE11Zkcw?=
 =?utf-8?B?a3BibzBmQmJoL3RvekRTOGdJQkVoRGxEYlVrcThrWnUwRmNWRnZYOWVxVnlN?=
 =?utf-8?B?WVpZK09pY3YxdUNEaVlxZ3A1YUdsbjhhQ3k4RmdiRWp4a2VNM1NnN2hmK0NG?=
 =?utf-8?Q?ID5E4neEUXKNfwOYaBdznWrn+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f7fb44-4df8-4af8-4dab-08da8a7177af
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 10:21:57.6834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cFv5B3ipMn3j+77rDKtMgyYAIzd+ZJVINvX6WO0aaun0k2h3EZT8s6WMqbAslSeKyLeuJ3snzG+PYofVbD+xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6582
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/08/2022 11:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.140 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.140-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests passing for Tegra ...

Test results for stable-v5.10:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     75 tests:	75 pass, 0 fail

Linux version:	5.10.140-rc1-g10c6bbc07890
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
