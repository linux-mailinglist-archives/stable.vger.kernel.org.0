Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A135FF1D9
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 17:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJNP5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 11:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJNP5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 11:57:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9B5F9846;
        Fri, 14 Oct 2022 08:57:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZU8AzkJjX5N1gMSzfc6YCNaa+prkf7NPv1BhXG5YgzC5G1mFC3cKxg3jv4b1gKmheqN4GfReorbng3DCit1gvb98lu85yu1xTNl/Va3AcU+C+PMUOMuKzF9WwYo0omJVaUXsZ/cP60eajc5gPzvbixeAjVVDyDMOPqEfRTmFSHREru81dpOKIR55bhG9KSMo3dUN23qWuCMM5MhWl4uK/5tnVeKVE6s1IH1Gxdbs405lbdPmoG6AIfbxiQhSaUaPwTAWvzY+N9B5AoBT9PKMGKW9/V/Fn3eup3gW49mVJDm2dGTwFOgJtBri6gIbGmwK/KuoYNSFWrtPWfrP3mn6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ysC67CmPXzddcPEPjnfS5jKn9kHmyQ/n5llhkZFMZM=;
 b=ISTRVOHfauXI+hxLi5DhZxZE8poJyrLBUkweMiuzbZT6UP7YR6PHjTSeuPcpmTlNYW7y4nV87L/byoslVyuy0FdiLpOP85/kS7OYOaC91rp1t2xPXst2TShOgH0bEKIe6U6meOLsTtYkcfDUkIKzHOZhNIUXA8k6as9/22Lp+USa8ziUnJ9dsvHaXcKnH4oERCtJ3t6ipOnUliIi+QoB6gzRBYbzJWXSy469D6WkDMQ8tfLLNR2jYJb0QTls9JZ625w5b6baOJtsB6RBgD/3cdmW3/91lGOaJwZVbcsNY84YR5EY5kHMYaWBGFHwDQyz3WyT4WmMcZ1d3cijAGvOLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ysC67CmPXzddcPEPjnfS5jKn9kHmyQ/n5llhkZFMZM=;
 b=fEa0lurAZcU0kSRt9+8eiyb50im+/eahZ+pHt5IiZ8nH437QQkcnPPi5hGFfa1zWJBSSZ7DKg/FI6TRHHtLwpSLUB+rTt/JI6qzQLs5rJV9Q0GXFe5UxdHzRh1SLnelNP6IjGl5HKsDyIho0ZraZRv7jdA1za1DxPrfkVttc62omhR0EGElVJk83HMIm3FWm+PiiHoxpZiTUDZg3shXYB5oV/A0ZQ5IrwHe2VOh/Iga6CtIVcHiFYOMDBG0BHKBBJa1YXIxluNJaWVP3gzv55ulTH2xvH2ZIVNSf/DyYh/8SknGAGz4pk7y+1Ylnaq34nw31NO4FH2OnH/qnfr6I3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 PH8PR12MB7302.namprd12.prod.outlook.com (2603:10b6:510:221::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Fri, 14 Oct
 2022 15:57:27 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66%5]) with mapi id 15.20.5723.029; Fri, 14 Oct 2022
 15:57:27 +0000
Message-ID: <536c7223-e161-eabe-1995-7798985911c6@nvidia.com>
Date:   Fri, 14 Oct 2022 16:57:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.19 00/33] 5.19.16-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20221013175145.236739253@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0678.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::18) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|PH8PR12MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: b6e881bb-fd0f-404d-f607-08daadfccadf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fgq4VLq57SYq2inKLuf2aYg/gIbeGU2PrKpnFBzdnl9/rxQp8USeb4RzTfeOmxsdT7IESgtVbkj4QoBQKh9JCX7PD5TqzRCGX4B7nl0WIZ9EB5GAjaHS40e5odq7H18kINYm9S98yydb1fNh6wqN3lajoHLAIngN1s5UooUl4AdCMhzTSM4NbaoqIlxERRpE2ds8yn5/OiJR55TM/CmeINe77cGa7WQQM5zaWCSb7FFPngVjmvjVNFWxhtyB41zGQFOVJ1vF6ycqJHZOjjC10QnabFiROVbXD7FjGS6QH7Paw18Mt/Woc9wS1F+4nGpayamRfOZzysmd1gxoafayawR9DgO128sZo5ee5V1A263y/kz1NUHKsdUnck8/csWADj9QyekY3ar2Ij3A1IW09l3g9uJxrQxPz+S1PBGBVhC0/9AvDajtoqW6KeB2gifF1pY8lqLBd8GQ2SYkPKFkHakNLg++d4E0D+PUgDmAyNMZe4iCyeJd0JWEpTjd6BSTiBnnDZa4T3v/l4g9/6djooOEnTNTjpPvL93zIxwEh9t018Sx1QSDG8oojS/17JJZiZDxeHFEIJKpmqKT07x2Z4ia+9fiQU5KZddaWNMGzUOm1Mwx9kS4oOLVyq89Tq2bzUxGkXAYTbdEAky0RZlBQ+CCx5DqzreEEu7T7NZcKj0xTdfMlzkftlnEXoUIqQg3eTfqMg6rCEIputIKD+q1y6+iiC6FEi3JsftdiPnuF01CVOkqQ5U3H7Eax3uVwx91n4Avs+qp1Q4cndhnwBs1SWwLX0ScIP3TtG7Av/FDhgxIfk+OKW4D9UPX3cRM2rbI6ZJL7obYlPrWoGWoIGhMSB6UEESkWB+on/hOwPoqqzqXSiqQVAZIe9O1f5K3i4Wn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199015)(6666004)(4326008)(41300700001)(66476007)(66556008)(8676002)(2906002)(66946007)(5660300002)(38100700002)(2616005)(186003)(7416002)(6506007)(83380400001)(53546011)(8936002)(6512007)(966005)(31686004)(36756003)(478600001)(6486002)(86362001)(316002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2pVeFZiOGJ3bnFUZGwwOUNBTDVsbmNsOHQ5eThLZmoxNFl1cTV4bmRjNmZo?=
 =?utf-8?B?VlphcUxyT1psak9JUzBDa2dTOEtMYTZFREdkSU4wQUZqc0szYy9oVWVzVnc0?=
 =?utf-8?B?T0tJN1VlQUllcUltaE9lSXFtSTJhelAyTzI3aHRzNXVZZVVjekR5L3FSa3Zy?=
 =?utf-8?B?MlhjdWlsWDZzMDkzdDZ3WFZLNGdzQk1vNHBkTVNmZ0tad2dlRzViTnByNzQ5?=
 =?utf-8?B?QXlObWpodElqVi9WOTNkVnFGZUt3U3gzcXNPbWRJTTUrYVc5VlQ1UUE1d0hD?=
 =?utf-8?B?eVVEZThwQXBhQlp1RTNxeE02N0Y1RlNRcGU1aTZ6bEZvZlJsM3l5OVNvTkVh?=
 =?utf-8?B?b003U0pOd3dQVlpvNWFucDhjODFGaHNjdFlNeWt2SXpIOTNXTzRJOUYxWmIr?=
 =?utf-8?B?S2VteFo1aEcwaEF1YWxtK2pxSGhZWmFLRWxiMFNWWHFreWZPUmFYZW81d3Nt?=
 =?utf-8?B?V2o3eFpwQVU0dFNIMnZIQzVBdVR1c2oyN2p2YzdSMi9CWEtlRDN2ZEZsQSto?=
 =?utf-8?B?T3doeWlGVzJ4NCtDb0M4ZE5KOGhrRVFXVmRqRS9PMTJUUEFIMUZRZXU0djNj?=
 =?utf-8?B?ODl5eDhvRFIwdG4wL3QwS3Ntb3JNalFTNnZLK2dYTWtpd2xzY2ZPWHNmUWlx?=
 =?utf-8?B?ZmFjR1Q5dEtHT3NKMlVramV1Q3B5eXEzRnNYTG5zV2F6U2lOWWhpRllKb2ZS?=
 =?utf-8?B?ZWN3UTMwSm94VDY1Um9NTkxBYjlYYUlFYzZiY2oxQ0NkaGQrL1J2ZktzWTVj?=
 =?utf-8?B?bk5KbVlGWG1rSHFwelpvQ1BVR1JqN2txM2hDZTJNeDEwNFZnWjl3Q2twSW9O?=
 =?utf-8?B?cStOVjlIaEYrRHF5bllQcG1uNnlKaklXbTNDRk5UWHp5akQybTJWMER5WEpN?=
 =?utf-8?B?eW1ZamFRY1Q4b21uUkJ2c2lFTVdWQkM3bkkvRU1WL1Fqd3lLSCtNeWJOMlN1?=
 =?utf-8?B?aXBpQ3plV1hLZFNWTGR3VTlyc2d3UGhlK1hDdElTbjcvOG44d1RHaTYzYmdW?=
 =?utf-8?B?cWM1bFppTWQxcDRhWHI5eVdXenZpT284WEhtMEZkT1kyL2wvZW43SGFCWG5B?=
 =?utf-8?B?ekx0M25iRVhhU09WSHI4ejZ4Q2RxNUxidFo0K2t3SkM4Y0RPQTJUNHNvRkt5?=
 =?utf-8?B?M2cvTGQzYVl5QUdxTlRyVzllNEVnMnJnZHI3ZkpJdTZzZGdVSUovRDZNaC9M?=
 =?utf-8?B?cUFCMVc2MkRmUHg3NmFSZzlyZmIwOFF4WEY4NzYwS2lXWGl6ejlHa2FTWGlX?=
 =?utf-8?B?NVlvVmlhZmlKSUJzZjJ3eWFWdG5FSlV0VTJ5K1BpbVB6dGRuNkRlcnRBaWs5?=
 =?utf-8?B?b05yNC95TzVyb2ExQ1g2VEJBaUhBcjA3VmhLYkt4c2JqaERDdTBuL0VQU3ZL?=
 =?utf-8?B?ckVsaVJrbExEV0ppaFAzMU1NVnU5MUUyQ0kvMHAxaWpPQnova3lpOWZBUmlK?=
 =?utf-8?B?ejVkQTd1NEQ3QUlpdTNQZTZ3UTF5eDFsS2QrSGliSHZjV0N4VTNHWWl2WS9Y?=
 =?utf-8?B?a2hxa2o3V1VKUUR4bnU5ZEh5bVlIQmRBVlBDQnJodGpoSDZUY2FiaEl3ejJl?=
 =?utf-8?B?SWpIZmJneWQvL0ZDT3F5UGFiWExLYnJydDNjckZnY2hDYVlIQUVTcCtJOGJa?=
 =?utf-8?B?MUpjRUxGTFVNVVVnSG9WZjRxd05JaE9LR0dxNEZVVHliYzBTb2NuMzdOd1J0?=
 =?utf-8?B?d3ZweHUzdldlWEUrTmZWZ3JRSVZJTTVBUlNQN1UxYnpwM0xMQ1VBNzE2UTNv?=
 =?utf-8?B?QkczcDFKbENuN2JNQmRCdEpUVnhlUFk0Q2xaWndZSVhZMkRoOStIbXJsaVVl?=
 =?utf-8?B?REtpWTFYTHV5RU9tWE85UVBKNkdnaGZuRHYrTExZRUlrTis2QUlrbEUwK1lV?=
 =?utf-8?B?OWIvNkhZRERLRTJTU1hpZEp4YzU5RVY0ekRjTlFLenJtSzVXZldyV1p5UnBu?=
 =?utf-8?B?WFhwOTE1UHhQWVRJVURBRnpWVFlwd00yTjNXWERvay9JMWdGVDljZkJHMHM2?=
 =?utf-8?B?WnlkRkQxVUZrUTdvQmJFYnFZWG8vOU8zdWp0MWN6VjJDeWE4R0svSmpnRFBn?=
 =?utf-8?B?cHhIbjlvSzVoRkMwcTlPQkRYcTNuT2lkMUtLVGs2akNGN2EyZ2FXUzBlSFk3?=
 =?utf-8?B?SFFBTWs0YW5FdzdlZ3dxN255c1FDelFZRjh3aGZESE4yQnlmdi8xc1dvRXFk?=
 =?utf-8?B?NHBIalBicmYvTkZTWEF0blErS25mcnl0dGM5YTJuVkcyR1RSN3c5VjUwQVBl?=
 =?utf-8?B?TWtZMkdVdDNMekJhblNpSWZJT25BPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e881bb-fd0f-404d-f607-08daadfccadf
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 15:57:27.6041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oxynr83mxJeWwPorz/866J90nLPHEywBjsgK2qwRtgNC3QPiXBSFtFgrG1yFrMN+WLParmbEhr6JJxd/7gvs/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7302
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/10/2022 18:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.16 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v5.19:
     11 builds:	11 pass, 0 fail
     28 boots:	28 pass, 0 fail
     130 tests:	129 pass, 1 fail

Linux version:	5.19.16-rc1-g72d24eaf389a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra210-p3450-0000: devices

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
