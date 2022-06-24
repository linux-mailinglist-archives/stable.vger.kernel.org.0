Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7765596B8
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 11:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiFXJcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 05:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbiFXJcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 05:32:05 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE3C55365;
        Fri, 24 Jun 2022 02:32:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGbgx83GO5P7KgDIzBq7fNzZzEA6UfrT3rF+YS9RXWX/gr4UrytafHrOLvoNplm9z2Z4Xl29Bt++nEKd/jgBNVCHV/b/ZRBNzi+idgzYN7wRsoJ7m4zx9rJZHLkTREtenecJtpfv4makLyB9A/OlQXci9WbuipDaO6KP0ZVFwY0WufM4TzDJOJKtHsXWZsgndRPwFTlbb+QJRnsoH4DVVVKaT3AlVSCpJA2c0W70WgBtgtMY1gEkial8MrxzQ0342wSWV33mc1h6lJYtEi9eCcOQQTMBV1Rpgp9NznU1/1cBB7SdswiecVJP2NRmSz0zdyG7tYzIQ84aV3Eqz3wiuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVqcDqjV/gdjIp+zKdSvDNZNXoM1n+kMzsD/p3Onz3E=;
 b=drf2nI4qjO5eqKf2Kg68dx6GEBFp16tCTFvjIEhLHRzgn5kpSIqrIYgEyohCNX6/wMxVuSc6mV8pWaY5//0J8x7sFiAc0DTTr3k8GXzICFPGrJUb3Bj2bZoWeVfWfSClf1O+yMmWXvifHPcZIBhCTLJdLcC1UqZ+h4gvjQVxa5dDkSeETBnJAS9VbkBVVsAfBQEAG+6c1o0F7KHIFzUhVCGl2EqDG0FeyPpPCUD1pX8EE4tg8nzKwmUn7w6WEW4UlvS5VVsXO1l+A6ojE4AF/b4rCyuab4gKR2Luyudi7IysI40/nm7Pv09DSfz+uY2p261GNDwoo1op0d22piBT2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVqcDqjV/gdjIp+zKdSvDNZNXoM1n+kMzsD/p3Onz3E=;
 b=M1AG3uDbRFhHwNW17UUx+ldaX6ml6Hdd80p+hs5U50x+ycVKBp3p1yPJYe/J2F/eIA2oVbTbw8mOL5s1+jkH1AaDgqB5hapEMACeOMNmHfuyaJx5l98F5fjEeIuVuz6JWnGIdfl48lFjSCCcyUEU62Vb5IweO6XoDOclgl0puhRAaeDKvsBCE41MHznpWlDVFzaoIzFpBXXEbdslIy1DUEAjRp/YhnExm6woIe+vNLranFRTRHtCuvqrw0gZcYh4U1K4w961qsp42OmqaP9W/lU1gkYuA+lPQ4bw4b0gpBRqbZUYxjSohHDosOcWUJO2Oi3iRPxRhubjC4HhcR0AIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 BN9PR12MB5212.namprd12.prod.outlook.com (2603:10b6:408:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Fri, 24 Jun
 2022 09:32:01 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::190c:967c:2b86:24a8]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::190c:967c:2b86:24a8%4]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 09:32:01 +0000
Message-ID: <cf8908bd-42d4-79c8-436f-23cf8287b171@nvidia.com>
Date:   Fri, 24 Jun 2022 10:31:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 00/11] 5.10.125-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220623164322.296526800@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220623164322.296526800@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0073.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::13) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41794660-7d55-48ba-fdc2-08da55c46439
X-MS-TrafficTypeDiagnostic: BN9PR12MB5212:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pjXpYehXq4/nML9aiD66rugBqUM4sZLrANHj5x5YZP2xNGnMUNSkfMs3CgjYKsusia8U0Nr0Cchf6kre5FrjKRr9yGAUHEtW6giX9aj5Xq+hh3AK8nI9ASl2VqPawweH8M0om6XSWcVeotfKUS0dQ+LUa+3Nv/wuKvHlkWTwJwGEMQEQmDkxtQ0HlLK23pj72f2KmSIAlb7XMS77lTmGgeDxgGHuNT+dYBoUp+XwsfFVGCFTGzqBkQuJHVzrckB9v5+PJnBgrI6UXWgz1r58i3le4mtjI6hHQRnQkPvypsFhxTvjsplcTa+0c3bOS9wkyoz54cIz+LwFw7Xfth/H/1PTuUbZY1c2gZ1O5+VbYu2bzshiyKp/ve+5kJGcMj3ri7OJF7KlK4ldanpFBrsu6XuIaecPlOjBPreaAdvkNaYlc3i+XpdUp35lJpyFc4NUQ7FAY6oyJ2WmFXP9RFjcfUwyRQZop7hcJDD6zGucn3uQLSao846OvQZ6jKLyFWfTyaeD7z/RH2/yute14Y/+TZET5DCkuZ5rnqzyVj2vBAxWnucX3VMt2CdNm7wOIboeLINzako5KQxw06+oSkVplSAZHXmiOFdA7lIGdFXN1+Y1JtaMkq00Aew3D8NWlfaEO/s3aFijIaiX/AF15eQlqN1Nwqj1ZJgWSuAW6X7YmdxIYvKBJuOdrQp1+yZ2zb0DXwK/oOlN0qZFFErBsoOWpdIbKu5920W4YcjfOmiYdjtYN8p6Lu6EuAhQhptnojh5iP+e7VQFpMkl6Sp3iFizuoFQMgYf/uwfBVWn5+wUeNpXW4k3V1kDOKGCRnK7ARF8tXQ3G8UYZ9tp0udU+6CLRb5de0B0LP72UjEzKpd+X2SLmfZale44L0uxpjPZlnGgJEiypBO0layE5iqph+wmgyyL+hjzns7c6aRRxZJfA+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(2616005)(83380400001)(38100700002)(31686004)(31696002)(186003)(7416002)(5660300002)(2906002)(8936002)(55236004)(53546011)(6506007)(66946007)(41300700001)(478600001)(66556008)(6512007)(316002)(4326008)(6486002)(26005)(966005)(66476007)(8676002)(6666004)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tk5CdmYrb3JEK0RSa25CTHBWblZ1aXA4MmlrODFFVFhYYUErbndBZ3BIQ2hm?=
 =?utf-8?B?Vk82SWxtMFg4MnczYkRaMXA0Z2tBWXBVRXhyYWROTU1RTWo2VXJRUFpqQWlE?=
 =?utf-8?B?b1p3eG81NlczcTNOM0VJTTg2aGhWKzRTYmdDdU00UGRCVFZvSFFYamtPVTFw?=
 =?utf-8?B?RE1qQnFHYlhEWHZPbHkyL1V6SUM3d2FpdXlRdjFIYlZQQk96UUJBSjJKUUx2?=
 =?utf-8?B?emt4NUt2M1IyRExHL2hURHJ6WXRBWitVVXFIay8vQURJcUt0cVF0NHljMENw?=
 =?utf-8?B?eGl0RjBZaWZHVW1CNHhpR1IwTXRRYWt4cUt3V2FZbWk2RGo1SG9lSzZ1K0FZ?=
 =?utf-8?B?bmpncG5SVCtCNHplSGlub0d0dEtOTWJTdEQ0eW45UU1HcGY4YkhRN2hGcytU?=
 =?utf-8?B?TXZGMk0vWVhLZVNoSmJrMEFjemx1eDc1ZU1rMXJ3ZDhRUXJvd1VKbXZMQnhh?=
 =?utf-8?B?UWFTdmpRdkxQYnZyR1VMQ1RvYXBpcUJOL29ibi9OR0djSFBnTk5XTUpyWkVQ?=
 =?utf-8?B?cVREcW81azdJSk5JdWM5SHI3RXVaVDZ2bTd4VEZRVGNxR0pNMWVCcjFHY0NX?=
 =?utf-8?B?RTJlcWVGYVhBVmRTQnlSdkVpZXJzSFhpcmJCa0V2YVNLS0czdzJDR3VoVEhT?=
 =?utf-8?B?RHNGL3ZxdnBrVzY5UTVpNENXRWJvOFU3dFVVWm9idC9raHNBMFpFNGZxMFdX?=
 =?utf-8?B?dXRpdG93VStES0FhV29TSVdVZnhud3MwOTFXQ2ZBS08wc3lKTGh2aGx2NytQ?=
 =?utf-8?B?N3VuNVErejUwbDN6YXByUVZlcWt6VWx4WWx4SWdQanNqY05wdHdtcEZSU0x2?=
 =?utf-8?B?QU9YUVNOSTNHcE13ZjE2R3NCOURyclZUVUpTdjdEVDdQWmpiV0ZYcmtQNHZV?=
 =?utf-8?B?NUZ3YWNhdkNkblNETTFFakthMHBUNnoydEsxeDhrdkF4NE9McDRKSmxZajVH?=
 =?utf-8?B?NHQ3M3FQakFHQWNQN0tNWWNxUzJncDR6QUlpMjhNejJhbTRuNHdpWXlCMGRJ?=
 =?utf-8?B?VmdRZEE0UEFGTTMwQ1o0L2t0dm1uQmIrM2VCUTN0d3pKaDNoQkNLN3NRSEFT?=
 =?utf-8?B?NVFPZDg1TkFUUXh6OFFaT1hRWkdhd0hmcitqbE4xb2xiT0ZZdDdTZUJZTWRP?=
 =?utf-8?B?SE54ZFAyQ0c2YWsvZTdJVXNmUmt0ZGlRNU1saXZjZnVUYmlOdzZMTThicmpB?=
 =?utf-8?B?QnZBOU4yR3B5WXlkdjNKcm1Ha3ZabGNQaEZscUpMMnhCOU9kdkZNKzBvWmtT?=
 =?utf-8?B?Rmc1OXM0enlrTXFKN1BuZW1tekpGajBISFZWM3g5VFVnVHY2YUcrNHJoUXp2?=
 =?utf-8?B?WmRTS3BmSmVFU1ZsOWVDbG5NVDVmbHZKR3cxWTJtUkQ4ZStxU0IxYjQvTmll?=
 =?utf-8?B?MXhNNDRKOWZjT0NLeFdRdUpwOW9CTXdTSHNmYXJ3ZDBBQ3ZhRXgwcVRMUEZa?=
 =?utf-8?B?VWNWK3dUSTVhbFY5SDl1TVJhRk1lMjQ5c1NrNVkydWp5RmdKOVhhU2k3Mjkv?=
 =?utf-8?B?dUZPWERtS3FpaWpoNG1LcjROZERoMlkyOTF5c0VvWWwvdFdaZVo0VzM5YXJx?=
 =?utf-8?B?QVlEcEJkSWJPZFFXd2d4WldPTGhNUEhSVDZJWENReGE0aWFPVjl0UVBHaXJt?=
 =?utf-8?B?ZW9iN1RhK2MwRGM1SlhFUjdWd1Z4YWVxV0V0QXJ1UHVVc0ZjK3ZBQWs4Nk9t?=
 =?utf-8?B?ZUs2Uml4STdPTGo4RTh0L2tPL1Fka25wSHFrRFpXZGFyZXpaQkdQb053a0Uy?=
 =?utf-8?B?am8rSU8xQ1ZjVVJSb0t1MmZCTE81cllicFVTN3BscytrWnh1UXMzVU9Bak1x?=
 =?utf-8?B?MlNoY0JXNjRrekZXeURpa2xKeW5WNDZFcWVRNFgxdmNISlY4Z1BtNjgyNWF6?=
 =?utf-8?B?MTBOallQekwzd3VaSDJXalpmWWxmMEVPZVg4MmZHMXQ1M0tWbC96bE1FdlJR?=
 =?utf-8?B?blA5U01LZHNraTBjRTQ0YWNoQXhxajVXcm1XZHA0eWxlQXBMTUZ0S2dJQWxp?=
 =?utf-8?B?VjVCTEk3QU1vWlQ0bXBWSENaYXF3Qk9SQnd4bUt4c244QnBLZnpacW9hdUpU?=
 =?utf-8?B?OHJLS01oRzh1U3BIRnBVdGZXNXRGUk1mbStIRkVPN1lNd2ZRdXVYYUorOUFl?=
 =?utf-8?B?bHFzbVFxaHRrcjY4OGRpVG1UNjRRTzE1eVNmb1QyUmYwb3NUTnpSZ1kxOXRF?=
 =?utf-8?B?d3c9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41794660-7d55-48ba-fdc2-08da55c46439
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 09:32:01.2944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TgkBjUTx5jKQ6qMSqjcG1zYy2fiEI2RZkVEdM5g8m1Jor5/5YFeHUCw6r7a7ZzFzQBmlQzUR3VPs74DX7gSB1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5212
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


On 23/06/2022 17:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.125 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.125-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v5.10:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     75 tests:	74 pass, 1 fail

Linux version:	5.10.125-rc1-g99120abeed34
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
