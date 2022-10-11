Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823895FB807
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 18:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJKQM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 12:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiJKQMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 12:12:24 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9645F10A;
        Tue, 11 Oct 2022 09:12:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSsHqki3PE2oa1tBFD4VGSmfG7M0HGgJs2NxTGySbbps1ShNqqdUjJOxoqWGqYnmh+kbWMAeDkb2srI953eJFp8xLw1fWPk12WI4QGUVUbfzqfKArwMDfWTvHZXDBVbV/8h2L2a9lvCRxAgekTo93eDfZGJeqryLy7h5Opvoa2jq3m10OnMdu4A1RNUgCM7sS1wgghPEJOoXfVuADihI+v3M/or4gu70bhqeK72wJN4WJsOSvUiO7llfLp9z1qwWyeH4rvChGABM7fJqKZCvgv5gp6mixjl2c0h5fWFvufmnIWQPbgtExudvurpmRxkD3DVYJ/E/VIpvFVajX3Q5Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZmYHII7lwVtCBEM4TUjSnOL+heU6p4avqRewv3gajKU=;
 b=Cg8+Ta2RlDNKsrujYgCNx2C2lGgs0sNn//9chhIq0QhOk8yPK23ClI2mF3QSskV9ceYHI+581WhoS6zZKfBYOMue/P/Hc4H1nCiu5gzYhOyX2eGVY/IXpo/gzNdV0EuaXZ9a/SdDqaEEz9J9zAzY3zOMiV3XQeBJPcSRezQ4RhT+cerVHJZSpFdkWqQK/4QhYgMDlixO9RNTiiYTDfCgf402x1ucT7pJcUbFV31poqjhobt+ppmW3d9IsOip2kpvg1FAJVQ0xvXiF/ww6cyX3gFO3aLJ6AFanbYajn47JigmAEFvTeeMvWfsUgNKkKGmpDBCqv/yj4FV9IgSOLwmYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmYHII7lwVtCBEM4TUjSnOL+heU6p4avqRewv3gajKU=;
 b=plytR6ANq3RzXQEEJB1OkuZVubIhDDWOkf4CHIt3ZGPc0jgFCK1NRUeWVJNhGVTlh/wU85CD2qOWCNMe+mt4rozn96ghofp1faxah0xuQPysmp2V7Jz0F5oYnmiuXaVHcC+pvbtB1+XfLhf7z+V0KCn3aRZ8dnHuNUHQPyrijLWs16GwcuPefX9Sdr6sSza06OFsn+xNHRIIMo/sWwzZ6qXSIQILv3fWxf6dPRkFgWwjLidv+GAg1By1neXb3woGmxkgNVVusuUgJyB017Xg5OBAU5qzurbxFVWunygwUaG9Asneu6gB8zdRPfJ55q0ZhzydHKY5A6L5KN0118LnNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 MN2PR12MB4223.namprd12.prod.outlook.com (2603:10b6:208:1d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Tue, 11 Oct
 2022 16:12:19 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66%5]) with mapi id 15.20.5709.015; Tue, 11 Oct 2022
 16:12:19 +0000
Message-ID: <bfda634a-c5d5-076d-eca4-d5c8fb1f45f8@nvidia.com>
Date:   Tue, 11 Oct 2022 17:12:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221010070330.159911806@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P195CA0088.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::29) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|MN2PR12MB4223:EE_
X-MS-Office365-Filtering-Correlation-Id: 32560bc3-bacb-4a46-b3c5-08daaba35ed8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TaEJuP1oXb7tm2bqgvEA2VdBg9uChc49vLo2qQhjFvXVVVvkgy0dJbQatTBDQtOxZTsUTNiQ8PbHiKX7zRIIKWq9VI79ytG0L02vWq6kcWI7oVZNfoEXXaf1E6/sOpVpiiXIX5PAsGI0a9uTMB7N5/eLNWvX+to6lyMnA4U+mmoeH9iERA0XRJpIfwLrPVPHoBSmJifVg81q3OBokV+MCnmRSbcqELyXfBkXJR6PdgmvvDBeW250OmqhktkB+iHP8eqCDdwY6NDlHPTVZlpIbbAN8X/KBSlRxJVDK1FvfqLVq7NOubniQhFtam8VqPtvPjRNwAvuAHgDPnQRPWdyT8oStBnC0pa2PA+cX7nTxvfI6XcjQMn5NMs3zqCK1WYqEsuPpPYxtTbjtYkwGzC0SDJcuB6ucPci/w177Ku70JiDaIHH9lEYh3xsZZgQdaLqYnqYFLxE3q68oXoQdgrjkxF/MGW4WJznC69VnAFMxgcg+cP6EG/vCZZun00jCfrjQ3xGelewhExwSF9uCzgIMwx66QEH56sIaP9ZC1cHLvJUR6XlNKceuxqTWwZaE/8IU2Egjg8lq3fIw6sZeIfzhWDMAsZAFNxVuB+9T0aPwX4/upGFiUR4uHIwIIrNtaMLS/BUJ5NTIPYIKJXTrTFw7qkUUofFsM1XocqF0F4f1BLzbIzZQU/LRsPUrm6q7vYRP6ksYbDt0YIVqGyzs4okCIvDpW81US1iO0h2pjPqu9AoWy225LGpn9xm6ctOEdYIrEO37QvI3Lj5zDrZkLRggdQ9XbaFsYNB7HnFMI0yJrN0xzE84eESR+Xb8zD0URjV1pZAYjrb1VRqjRKmrhzutjWc3sFBgGPcR/PPoXcy80g+CNvWLu+a9t+9p7EU3iwE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199015)(31696002)(86362001)(38100700002)(6512007)(6506007)(55236004)(53546011)(26005)(41300700001)(2616005)(66476007)(66556008)(66946007)(4326008)(8676002)(478600001)(6486002)(966005)(316002)(6666004)(2906002)(7416002)(5660300002)(8936002)(186003)(83380400001)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFRPUi95VkpZcU1tbnNrU2I5QTNRUHlueWpUTmpsb2Ntc3c3WUIxUTJnNUR1?=
 =?utf-8?B?SmV2MjZDbXloRmtWcnNYNzJJU0RQRS8reGdIOEc4WjREQTNpSmh1UGJjQTAv?=
 =?utf-8?B?OXNVdnUyU3I0cFQ1R1ZBTk5VSVo2V2Y0VUQzRTFqcGt4K1grL0NjcTNFMXh2?=
 =?utf-8?B?MXUwbXNydGUrbDZtZkRPWXUzSlFWUTZEbnBYclNVclJ1VkxoMndUUW9BeXA3?=
 =?utf-8?B?bDNZL0wybnkxcmdPNUEwcGZSUkN2cExGQnRLWkVrSHBwTjJCSElGMk5DMUo3?=
 =?utf-8?B?MTVFYUU2SS9TcDlKbEJ1RnRQbU9NQVBLMkFKM0tsdFBlQkZFYk1hajFzOTJ5?=
 =?utf-8?B?c0NBbkhWNlppUjNsa0luMXhpZXV5WWRkeWorMEVMQjdjN0NJWVlKd0VxQmlJ?=
 =?utf-8?B?Qkx1SG9HZkkxWU5rdDJaeGI5cVV5Q1V1ODhyR2pHN0hZamhCZ3FyMGRFYWcr?=
 =?utf-8?B?RHNXMlZCb0UzZUVra2VpbU5DN21XdnRkQVhIWkF3M09MdDFpYytmL2ZVTENT?=
 =?utf-8?B?cGlKWW8wWDJabjl5bUxJMnVYcjY1a0xCeG12QWl5ODFGalVUaEI0ejlLWU9t?=
 =?utf-8?B?T0pEaWxyREx0dzNHK3ViSjBZTnVyVFZPQkdueERrWmtKdUIzSll5SGZudDhG?=
 =?utf-8?B?TXVHTlp5eEY3MHU1cEE0SmppQjM5eGM5bCsrL2MwUjhMdUIrazJySHNNZXc1?=
 =?utf-8?B?N1VUUWVSSFNaK2Y0bVRoUjhnbjdOdmlnWWdweDl4MUtsTzFHUlBTVld4YUxM?=
 =?utf-8?B?bjlvTWxpekwrZndSNHVBQW1ZMmJlWGhCSHpkSDFYOUJDWW13ZStSeFpPZ1ox?=
 =?utf-8?B?dUtZUFJ5SkRRZUQwVjQ4Wm5tSUt2bEVTZXNBY0gzaVZWK3R2UGJVRmxCNm5r?=
 =?utf-8?B?QUtNcWFOWFk5T1gwd3JPNHdNVitvZ2V1WXd0RG8xZ2R3b3NHaGo3KzBXZnZK?=
 =?utf-8?B?dVdSYmkwK0RST3FlVWNPK2lhV0VWbUFsR29YbVU4YVZQZHY0NWRtUHBtU25x?=
 =?utf-8?B?N3dZTm5tNXlxcjQxeGQ1a0VRK0lDT014aVE4RVE2KzRGUndYTExUY3NqRC9S?=
 =?utf-8?B?SzRCQlBjR0MxNXpteDZKWFQvazByT1VPTHNHOERVSkdEL2tlM2R6UkU1TURN?=
 =?utf-8?B?T1FCWld3dGVLaXpGQVFFN20wUTZTc2J5WHJzV1dhdGVIa1l6WGpESmZubmhl?=
 =?utf-8?B?YlBRL293dnlFdy9DZEJsVElDWWdNa0grek4zM0dmWS9UTUQxLzZyYUN1cnNI?=
 =?utf-8?B?MWtNaDMydTYrWGpPQ0pMMzVKWXYrNGFvdk5NRGNBYUVnV0c3di9PMHJEcG1h?=
 =?utf-8?B?Y0lPdmlxSzQvTzI4eUVtSWxuOVBqVFprblBjQjdYV0RDVDBUNFk4d2wyRnhH?=
 =?utf-8?B?VFlyNmJieXNMTDdJODFQY1A0dWt3d1JtaWtUTnpMbUFYZ0hQdEJIeFhzemts?=
 =?utf-8?B?aW8vNkNzbng5LzNwdHpDSStQYUNEU2dkRkFvVTR4N0x3M1V4SzltSG5DSU1H?=
 =?utf-8?B?STV1eG9mbzhSODNTVmhXZ3lyL0k0NVZlOVZONkdLRE5Idnh5dE1yMWJMRlBz?=
 =?utf-8?B?T2h5cjZ3TFNIaEkyb2RGUlVwRFV0QUwrMXA3NW1JSzhuMElFSnI4b0JpRmY0?=
 =?utf-8?B?SWdLWjJvOEN0eDZUbndEZkFsYkJNVjFMajd4ajJ6cE1PYkRIeFRqVEIvUDJr?=
 =?utf-8?B?a2tRVnhpR2pDVzZUdE5YWTg0N0o5Zk84RnlMeFBrd2VhRW5hRkFVcnFJVGti?=
 =?utf-8?B?ajlDVVZIdXdST1B0Y3JQQ0JIaitwOGIrYlo4dVViOXZ1aUE4N0tTWlVPNzFr?=
 =?utf-8?B?eHpWc0V0QzZHaFp0K0h3OXgwNWRha2NMOXRibTNPT1RKTGE0SEpKYTFjRWwv?=
 =?utf-8?B?WVg1Z3gyOE13ZHo3SVY0UWNlbHI2eEVqbzdKVkZWNmZzKzFMZmRLdTNrMmt6?=
 =?utf-8?B?bWpxdVJWdm5NMHZmMm0wQzVYYnd5M2NwSXZGMUUrOERiN2RMN2NXNDYwUW1S?=
 =?utf-8?B?SHNrNmM1dVpPRGhGOVRtWjZPek5MTGFHK0Q4UTZVaG4zT2hLaVcvYlRlM0Zm?=
 =?utf-8?B?amd2YnhKczZYL3A1QzROQ3V3QnFKVk93aURWenhmK3ZwQkh1czVGd2djNjA3?=
 =?utf-8?B?TWRyc3JlbDdzb3phZHNSWnJIdUFjQ0R0dDlQcWdTb0RUZm1CQW5PWnJTWS9W?=
 =?utf-8?B?NVE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32560bc3-bacb-4a46-b3c5-08daaba35ed8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 16:12:18.9843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WeRGG974A07BUsFPFIUuV653yH5igxp1iEtc5G1IuGtzkh/SvisKdJT1Y8R+hOWCPbHq2YN2cQxwnPUPo5sZdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4223
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/10/2022 08:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.1-rc1.gz
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

Linux version:	6.0.1-rc1-g6556cadf037c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py
                 tegra210-p3450-0000: devices

Tested-by: Jon Hunter <jonathanh@nvidia.com>

A fix is available for the tegra210 failure and the other is a new 
kernel warning that is being discussed but nothing critical.

Jon

-- 
nvpublic
