Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75102604F4D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 20:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJSSET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 14:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJSSET (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 14:04:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE48110B14;
        Wed, 19 Oct 2022 11:04:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KaxHsaSmirUjbFIRxUepkJYMMNwqvHy4wMmqtxFuqMq23mjkaeuGUDNBgQOpVKfaPebe1TBfUSQs7A+Yyr6WcTIoGWwe7VszSIb+zPVBlF1R0RVrjOXRXbmjEtmEy/M3cerDdAMIvfkFvVXadbjM7GWmM3JJI1Ims/LAV8GVzmlnvC0+KgL8gPe/MwVqvEjT1VjZqLGvXM6pn7yYU6mCNELZMrnHR+b7eKAbEaM2rCaZKhH7aB5CFp5Ud7fV5RLqQiX4lVmlkWwParGKna1vHQT4Y8yoV100QPyPUY6RGz6qcCpJgI9XGjArZ6xnizUxplQS3bt4sJL/4j1gb+cy0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1lp3E4S7ledwpeKtu/yth5tJilRhTnqS3cN5ciLzik=;
 b=j+2z1yDoQ/oNZKQrYreUPzGsd4okHgBZbOZ5nvJ5il8vw5594vwKX+/cCFHwUpLWAl3gpci4gugTJJnWFG6G57pbGPlhdPn3YnIJI5C7Iu0ud2NglinBkq4fGMNzL+aWIX7kIDHRkbpJpvi2HzL71pq02SdG+8fZYPDL99hyOPQUfaP/uVrTAHfgdTmWLjda6kCFDztvO80rPDAoKYtRSS3XzzvaT5EjsVlmzJMSlWnHXnMrDUmqbIILgkM5tsyRdGtXPnQYmivoPxsUyv8QCfM0A80bq87pXEv0doFk46gANJtXBXHH5o/JTg3sSUAvtc8BX0NYN3Kn4J/a9rH4Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1lp3E4S7ledwpeKtu/yth5tJilRhTnqS3cN5ciLzik=;
 b=lE906chmawDu+X86WZytAz7bEbnoru89HJBYyu408nu5mNqNIYrhAAUkHK8FyCHWVpYjo+eyQBAEI1tywv3xj2FURz2ItTawwE3WQ5hOoZqfBNfzgC9W2N1KGB9Q1jJ3r2Dr1NTdpomUNotVkBkMC/aV9qaXR08ghObPA/xcXRk0jlUKfMd9q0X4ju5vOCvzvQE04o0Dz4AiFRh4T+RLLOTjDl0Se23Oj5uZPWrLzCRz/D1tXDKA2hvxSqwDRf4l/U4wcGuQ4VP3YffB4ZXwl+dEVoUihREVFmh+DaPsRFsEVts4X1/o2zUlb/yTCpTW1lWGouOLL15aavKSpJdJwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 BN9PR12MB5365.namprd12.prod.outlook.com (2603:10b6:408:102::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 18:04:16 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66%5]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 18:04:16 +0000
Message-ID: <6944bdcc-94d4-0e51-59ea-cedc86acc361@nvidia.com>
Date:   Wed, 19 Oct 2022 19:01:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20221019083249.951566199@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0166.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::10) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|BN9PR12MB5365:EE_
X-MS-Office365-Filtering-Correlation-Id: 61f949b3-5442-4de5-5513-08dab1fc5613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o6OkHlHVjExaOcg2oKVfZ7+JtJDznTtSxEPCjri6M7uzjBkihFErfgdvpmmawmHasiwM/+iEeffjbOfjKzU6TX5eYGaMWEBEQ9O4N7DpyBdhsm2t1xuP/2OGHUi1UdD0vuCceEBbqk0tRBJd07B8ZwHAin2ks1S4ZqvQfUWMVSLvbnWQLrkZXORDwUxdkOKs9vPx8buhC/Zq2OXG0Mbpt+QDTBosZr7/YyqU22dZ6eYvZYoZrkqW77KHQmyq4Oma9Lt6DYENwQN7iGDUBjiNytL4kwbyaP6Zt5sJ9LNnvej88FkLdkAA30fpBgVYa5e8LiptbCkg/GBSTA94MPIVD38G6+pizUxN/SXAJaiTm8meSM7v9ql79xviM5kyDrQwxP+r7oUkDoJtmqLb2Ladag26rtzI/Cqs2EkmSE9QqfPet059p3372UxrXdYQazEY8wKIjxf8b8xMDdzX4VGY9MAVRgmMTbY3B/0xzqEIxx8g5t3e9WqeEDKI74npDmSzk8BM3de1Uzn26F2UkrWMiXDAXR5Mr4G/popPQ9yzhGhu75Y0e0QAcrlLI+6x/zAqXD4jmXxSWS3xLngGClsFHMqUste+Zu7htrAegV9P9YMqf7NkQ3+tL0W8fsCdHs8sFKc/EnHlng3Hsc5AIOA/7J5oUobnAIvUDpGPmXVXPvi48NZgZwvVuTFNJhAX7WTztCHdtlDbOajhzVkNoLKsoQohllscb8pYTE9s84Cjjk6a+Vb//5LObMjpso4bZ/WRmcQphsWV8YF9oKSuPZT1axGLluUx0UKbe6eeHF5RlvwjqsYl89mkIGjhDCLSlI3/qkj8eBA6vC7Few5zU8+KIm847DJlI2lXc+/QQmX9IAF6cGuLbYLdGWniJPNBnc+v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(316002)(8936002)(6512007)(2616005)(2906002)(186003)(5660300002)(7416002)(66556008)(66476007)(8676002)(4326008)(66946007)(6666004)(83380400001)(41300700001)(86362001)(31696002)(6506007)(36756003)(53546011)(478600001)(38100700002)(31686004)(966005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHFTVlhsQWgwWjY2RDRUOTRLd1VhUTBCcjBCZUxhdU5hTFkvUHhuSituNkJp?=
 =?utf-8?B?bllaUS9UM1hXY3NPWXVRVU52cXI2SENsbHdOZ3J5NDZhcUVjaFQvVjNScFRX?=
 =?utf-8?B?SHZERUREVUU2SFdzRHVIYUQreTh4OXhuazlqVHFOZHJpZEVvQ2MxdVY4Umcy?=
 =?utf-8?B?dEVJV0RWVUZIc3ZKUjFGUGY3TjhIZVZJTXpFemJQTGpyb2JyWUpWb3BSNHJX?=
 =?utf-8?B?ZXNoOWdrUUpjR2FqV2p5SFp3UlZRWldVUm9lWi9XaFZwK3JhWStJci9sQUd4?=
 =?utf-8?B?YUVaakdmTkNkUUdaVjkyTlR1Z0tycGFRU3BDcEdlYW45b080cVhjVGZQUW5u?=
 =?utf-8?B?YnFFcGpvZm9UTkpCNFh4ay9QZjBNWG9MSnRQZ3RNcnI2M2EzOW9xbUpjamVK?=
 =?utf-8?B?TkZialQ0UFBLY3pkYWN5WG5YeTlHYlNzdFgxWVlTU2JGaWtzTHNpajZNMHhy?=
 =?utf-8?B?bFQ0UEZVaklIVWRQZlIyWDdMaWNOcFE5SEZRdzRadDdaUzNHTFM0Z2VQeEhK?=
 =?utf-8?B?UHMzcmFqZkJTbUVEOHVUa0pmTFlISkw5RXRVQzg0UzY2RnJ2TktNZ2tQQ3FU?=
 =?utf-8?B?aVpUK0I2UTArZ2ptTzEvdmxyMkh3RzYxTTNrMmNJWXJxREh1TWNFd0lRVkln?=
 =?utf-8?B?ZVplRmxSR2J3YjBvVXZhd0hteHJGaHA2Sk05WGxaMWVVK3pQME1nUEk0T2lx?=
 =?utf-8?B?SGkxRlNPcndkMXc3Nk50cEQzOHgxcmtQVWlua0U1WTRuUnNya0FXbUFkYjhL?=
 =?utf-8?B?YnRyWFJZQ0F4SzhYZjZUWDRkY3pZWVRCYWRtUGhlMU9FZFFhOE5NUzRlSERt?=
 =?utf-8?B?TjVIeUxieHI3S0ZqbHk2cys4NUNCV3lvaEdjWkxjSksrTVFxSXZucHhMT0ZB?=
 =?utf-8?B?WHBLNHRYbUZ3ODJZaHdXQXpQamtKQnU2SUlNRnRud21UcUVucnNwQlo3WDM2?=
 =?utf-8?B?TElMK0dNWnRyTlNHc1FtdEhHeDBCVVVVMXpiaTMxMlhEZnFoSjBJMFI2RDRH?=
 =?utf-8?B?eUFvUG9paUxaQ21hU09hZUU4b2prM3NOMVdaTTVSTGtJc29hTldUdzRJbkJM?=
 =?utf-8?B?RGprMU83bXVXZmFTb0VndUd6UktLRDFxQXhVaDNlR3RxS3llM2N4UG1lTHlC?=
 =?utf-8?B?M3NER0hMUFVnc3JuS1pmT0t4anFVNWJCaE1iZ0NVeDVDcnJ2bkY0UFNrRVhj?=
 =?utf-8?B?aWtqYXpZV01iTkoyZzM0R214bjlwS0NRRllqUWR5YTA5Yk5URUhIK0xkbk14?=
 =?utf-8?B?Yk43RE1RWWNRWDVhSzlKRGNBaEFOdStVb2xxOW9kV1IxVUo5dnNnalN0NUtK?=
 =?utf-8?B?MWh2S0REZkdTSkhFNUFGZUpJeEp2K0Nob2FGR2l1UVZrY0FMUXU1dkk0empU?=
 =?utf-8?B?M0krenlqSEVpNGFEQ2hWdmJVcldoTVlUcGNpUkxmS29tbXZBVkFHMjd0cm85?=
 =?utf-8?B?dVlGME4vaUVZMzVmWmhiaEFoNTNvVjVEVWpzVVdoZWRuc3p3ZllYT0tvdVll?=
 =?utf-8?B?RTZ1VTRPV0Y1RFRzTWJpUWkwWHlMamg5R0YyTjh6cmc2dTVCYjlSSnhqcE1H?=
 =?utf-8?B?dkFKOUxzL0NuSlJHZHZCeGJKNkt5OHEvSzRnNnhXWmZQZGxhVENsTXoxRGt6?=
 =?utf-8?B?UWdkbzNnTEdXYzd4KzBtMjd1UTZtVG9wVHIwNkZWNjBWMDdjeWg4UUc3bFVJ?=
 =?utf-8?B?Ui9jRUNQQllUTUcrVFFTOTVzMzAxR0c1UHNGOXgyNHVwWHM5OHJZRDBoMUJi?=
 =?utf-8?B?T2RzK1l6Mi9OcFlyM1hRaXFQSzl2alNrT29HQTh5b3h0SURFbnA3cUtub21B?=
 =?utf-8?B?aHhDZlFQY3dsaFpMM1RSMXNJSVVlMHd2UzN6UzZSUzRMdDJqNk5jdDc5YUtS?=
 =?utf-8?B?cmduOUQ2dUFKUGJYMHIxSlRaUWFJOUpweW9EL3FBS0dkazJkUm1GM1piWWRh?=
 =?utf-8?B?WGtTck1wQm03Ukthdkp0VW5CNyt0YWFnWGhIUkxZNXhZRnRGOVQvU3dZc1Vp?=
 =?utf-8?B?Vlg0WHBQNTlVakc4K3BHeSsxNHVjNHpMWTNHSkk2eEl2MFEyYVJaZFpaYkdh?=
 =?utf-8?B?WFRQeUE1d1M0ZTFBNHVDV2Z0K0VXTk85dHRud3NGVjRSNW9nWDJrcjFTNjNG?=
 =?utf-8?B?amdPbllER3o2ZVRaOXpQNkl1MWYzRkNSZkp0eHFyR1BTaTZ3RUNXRjlFYThK?=
 =?utf-8?B?WUlFSWZ2NWFPSkpRZ0U1MWgxUkZuS2w1RmVJR05vdGxmZDNOYVI0aDg4dk5q?=
 =?utf-8?B?T2xBaVhqd2UrN2lXN2JQRG5MdytnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61f949b3-5442-4de5-5513-08dab1fc5613
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 18:04:16.2672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbqZx5zh/MvVfD2o8CSU8XwSw157q3doBJMDc1WsLnWThUEgKPdmN5evN8piUDQHxyRPBl387lmDfWemqxB7hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5365
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/10/2022 09:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.3 release.
> There are 862 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Oct 2022 08:30:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.3-rc1.gz
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

Linux version:	6.0.3-rc1-g844297340351
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
