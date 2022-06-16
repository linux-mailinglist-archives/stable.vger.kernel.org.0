Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A27B54DD8A
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 10:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376599AbiFPIuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 04:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376606AbiFPIuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 04:50:05 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2043.outbound.protection.outlook.com [40.107.212.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31E45E769;
        Thu, 16 Jun 2022 01:48:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5nG3mUNPbs+yz22pS8FUzIY04z2SUb1+ZPM328+8oRzjBljBEDsljS/u8ZZCOUy+1IEJy2Pzt2uTH4lDbnwPDioTpls6x2St5nooLT0ZAcizcUm1vXEn+jy40eijIYrBaMvs4wonVwl6nQ5qxYQLySVLQGSdkuYPqci3UVZo9gQzXQSEvg7YbGGrdGK/sNlK3HdATGkZQ3hGIz+SVCaXZY6BDzlCD52IsbOv+qUAuy6AyKw5shO67M7yrO8KIA4+ZmjehCAzB/8nNTk//EhUgw3ASdRNvkwuR+NPL0TEf9W4iP/Jf5XLs1aaTr6pAywBs+77D0vECZdkFraoJwV/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FhMJ0LAaUU7QStWqenq5kIAuLLSLFd6cSZIxQ3s2+E=;
 b=cgdpnSGoqcfdyI/E5GZot67v0HjU5rqZS8+P/k3Su0FdYn64AP6+44WYx74zec6rMBBVXssxlhEPqOPmFq4as4QH/zCxOqK9mh+6S55A5lrs3IOSYOloLbYVVoQfG49K/vnb4xS3G63YLcsXAC8nq2tVLMFTmtmcgcs9Tj8AGa4sivnRtg3pJ8bvT+YIZEz6YrnEbFLBnHLHgcBXCeYtgHOJuvomSvgrpbvzBdi+60KRhdtgmi/EFlVqzRnFj37FFwKV0+5L2ytKaL5Ub7oKXFsbJD8kmTKWeNHPUpCt6FYz412clvVPoC61AUKd1e/gF7v76Ypz4gdPId2E+nVRyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FhMJ0LAaUU7QStWqenq5kIAuLLSLFd6cSZIxQ3s2+E=;
 b=PEdPVX6/3HcqIlFlzRYzLw2uGUu5IXs5n49ZFi5jw3sjJ7TyVdNhSGbtgksQOjGmR9IzR+A916wH+ok2Fex19p5K7Ld3zoN+SUoD8ySV8DymcwPPgM4nZOQ2WhmHJ0JjaIb6tZDsJz9lGKe1oXDrAtexFTHxz2aMlwCZV4mu0nfz1b//EzW+o0esAisZ4S4YXOiGxSOCYtxy0aScy48T12aHdm2z7yB6MlDp2avhBK9ZxC/Ip/xBHPpbv3DzLynVpVkfoLs0p2zOi2WCO2Loq4Z85Ash2b77B4yARPBzV3Fz6nVkP6LqO5CX0DfNHopCYMzd5fo+csKd5+CLNGzbxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CH0PR12MB5140.namprd12.prod.outlook.com (2603:10b6:610:bf::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Thu, 16 Jun 2022 08:48:44 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 08:48:44 +0000
Message-ID: <9e43b35e-31da-7e51-006c-1aa69acb10d4@nvidia.com>
Date:   Thu, 16 Jun 2022 09:48:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 00/11] 5.10.123-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220614183719.878453780@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220614183719.878453780@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0036.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::12) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0bad1b3-465b-4a0f-a33a-08da4f750501
X-MS-TrafficTypeDiagnostic: CH0PR12MB5140:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5140299D3EC4FDAEE7B10844D9AC9@CH0PR12MB5140.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uf45kg96riW84DWtqyB01lOsPCkTduhPEVx5bNDrLg6cpaOvOkedPUiRZ01CNZDPDg54JXiUlPhJIqESuGs0v3mN3edIT/VjAwUjOWlO3P09m+5IxgObe54Uk/h+HYnAy8Yy+sTVuxo6GzSwDDclRAGAmnYOG0/wk7lDL74zorwkR5x+9vpNi9Jvo/QluS8c7RkRfgZJaJf2DeG5/ptdHk4e+TBjQ9JKXtlMt6NdYkEKU4aYiDQFQ47dR0aYimN0hrqBs8EDtTAjTWgYrgPW2adgjUs9OKuZxDkVze7a6PnAvMjgqNYBJL+bDFI4U0vpGB4rYtQyjfSyIbE6Mx90ZXxFHP6tpGKeZRx6xW8KPn6sb4m/4kvj2KIWl+DfeCYoKW3K6XjlHe57YsTVfpzX0rIg6HRjb3q4EhQnjO1GNAteyWdeSa1izb+lVwqFbItsV+t+zcm4px4n8XC0Ui3eDQIaYwOIe6Ipt1apLZhdpIPlKxugNiz5gwElIiSan4LuL9kjb05B0advZnxLs3TeiO2xUYS2WqofCM8FgTTyNhOkiwMRXyUzmkJhWIHCDC3QXv+OAk1zg6km3cpLkgR1Vy3DjgSnMw/3MsXn6AynYbPlTurTX/BwP3a0VggzNHAP6EeZ+644VKg3lRFerz1CDIbZJ4Wzn6BOF80nVLN/6zCWsnoogqpNtPGw+W2QRyjy5QhB1lyxMDMnX3qcvgaP09rKyadLA8Y8kDgYKHpujZMvwr2YmBb3oBAqJAgZ+rnBZdO9WKwQ5NLQO+1lpkhn7QIwIn61S1e1cQl21RmYFajNkS6nW+HnaW4XCv6NFE8fwJLjNgdgOGBAFxx5Fa/z1o0D3/wK1tB7EyUsIIkpW/I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(4326008)(66946007)(8676002)(66476007)(2906002)(5660300002)(86362001)(7416002)(66556008)(31696002)(8936002)(38100700002)(36756003)(53546011)(6512007)(55236004)(83380400001)(966005)(2616005)(6486002)(508600001)(6506007)(26005)(186003)(6666004)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1E5RHc0Zk9LOVd3cytSNEtlUVFhdkkycmZrcVBiakVsRDJyc3V1Umk2THFt?=
 =?utf-8?B?eXV0QTYwYlN1b0tMK0thNE9aNVRrTVM5TmE4T3BUMmhaR0pGUGJWWHVxM1FU?=
 =?utf-8?B?eWdNWngzTUY5MTdldDFrWGM3bHZnYlZTSEhGcTFRc0dpUUg0VTlURG02VHVB?=
 =?utf-8?B?NHhxYkUvMS8wVTBhVmlBRXBqR3RYem0yZlZhdlFqdEovUXpLQkZOaTNtUDdT?=
 =?utf-8?B?SStMNWMvbTVJVXlKQjJtcXp5bmphY0lOWFpsMjhmOUZjOUdQZHZ5cUtrWW45?=
 =?utf-8?B?bG8xQ0YzSHQ0dUJFUlVnazVNbVAwanRuVUorTWs5MXNpbDlOQlVDZHpVVkxm?=
 =?utf-8?B?Y2NQTXBNTmRvQnFhamR6ZXBhWU1GYnlFZ2FWQWhBZHgyRkQ3TUlVa2JHSm5J?=
 =?utf-8?B?YjJEOXQrekRSaHBrT0xGWUkwS3k3MldsNzIxd3JvWEJPNjB2WnBvd2Vabm9W?=
 =?utf-8?B?RGxYQ3BKSGNaTmM5emtUbHhoeFk4b2ZjcHMwTnFKSmt3VTg1eWZPQVl6VXZV?=
 =?utf-8?B?OWlDRTlpcHJTWWM0Wm5ORkg3bWYrUDFkckNYT1Q1VjBaaS8wUFJndnV2RGRq?=
 =?utf-8?B?L0psNUxjU2ZaTE1heVNCdnJ2TlVNUVUzWUpITnRxSG4wdWNYTnhRakdTanh1?=
 =?utf-8?B?dkxWaGZXV1BPQ3pJT2dJNVVqSHBJci9TR3BvZ1lPTnIwaEJMVHc2STB2U2Vu?=
 =?utf-8?B?YTVEZGtsTnpuYTFSbmtJT0owZlNIbDhRMURrWVBaN1JYdGloSFdWVGFLMFFC?=
 =?utf-8?B?ck0zK2FXREVCYmxwNXNta3ljSXdPN2pqaVFNL0k4WEdpeUFFdmNsV0cveGFX?=
 =?utf-8?B?eVE5WUcrY053alorTFQwUkFWaWphREtJczlFYW43U21PRS84RS84bWpNQ280?=
 =?utf-8?B?UDlEL01xdjluN1QzQ0IyRFhPM0hnL0tLenRSZ3daUmZ5L2Fna2x0SEdNWDZP?=
 =?utf-8?B?SUNYRldYQng4UUxPYklxUU0vTE54VVBsZlRRazZkTVpqc2hkblNsVDhKUmJn?=
 =?utf-8?B?am1pdDJZR0N6S2hORndmNTByRVRQQUNUYVRobFJoZ3ZZM2VIRFBIMUpzdVhE?=
 =?utf-8?B?em5od3UwckdjaiszbWdIR01QMDloNGlhay9tVTZGRk9VT2dGMG5UbmVRWFpt?=
 =?utf-8?B?TjcyVWdTeTAzRDdpOUlQOGh5Z3BEZUY0T0lMT1RIdG1jQ2JzcG9BeVRpSGJx?=
 =?utf-8?B?Q2VlNUF0VkNaNEttaDUzdFpxOVg5Y0pweTFBQVJqWDhPSUtOMkN4OU4xaWR6?=
 =?utf-8?B?OWJxWkhPY2hyc3JVTjJtZEhuS25ibnphSEFFNkMzM2lScjVhWkhHelZ1N2xG?=
 =?utf-8?B?cjg1S2E1L0J4YzBjS2o5dFVLc2xpWlFJZ2NqcGdhUmZCUXdabUtqVlRTZzYv?=
 =?utf-8?B?aGtmKy9mdy84Kys1ejVZR21BeStDcjM5cG4wcmkxZmZCNS9GUGR4cWlJRXJj?=
 =?utf-8?B?S2o4ZjJoamh5WDlPdDcyRGw2WmJXUU8wbk45YVJSSWY3Y3VVTVZUOUxLMW9T?=
 =?utf-8?B?K1lMeFcrTmcwNnQzbE1rM0ZjeEJPTTNoeVVMT2NIM1RveElXNVQ4a0NyaldJ?=
 =?utf-8?B?RnIzVFJlWms2TTJGZWN4Q0tDVHlhRHhJYW1PL3lVaThzM0hVNk1DcXk0SERn?=
 =?utf-8?B?YWtYZ0FuczVzTU5MaVg5K01QRlpucVJxVVdoN2JXQjhKZE01MVQ1TEVhMG5r?=
 =?utf-8?B?WFpRcVZxajg0dmxFcUhrRTdHQ2FUZGlJR1liTFVUVUNZdExKR1o2dzhTTFlP?=
 =?utf-8?B?NExFTjZ2bWZiRGNJaHpOMjJnRS94ZXFabUxQcHc1dG9sWkNxVnhpRWhyaXZ1?=
 =?utf-8?B?a3EralhQRzVIVzJFQ2E5NDNPSDlRckFHVVRVWTZXYlBiNkVjdTIvd1FUTnBX?=
 =?utf-8?B?amxrT0RpMkJycnJ4RlJiVS9lbmpvUDFWMStPTmQvaVFKb1hPK3A5S2NCZERs?=
 =?utf-8?B?UmZOc2pkb3VUUzFMN2hlOWhYY2docGhNandBQnZtVUs0R0thU21LazdlWGJs?=
 =?utf-8?B?OExSTmlyenJ0ODBlOWlIRnVUV255bkp6aHYrWHhyVmppd29RNVA1djJIcm1W?=
 =?utf-8?B?NnZ2QlcrYm5uVC9JSkE1K0paczRpWDltczl6b1dqdzVJc2o1eGRicXM4NURr?=
 =?utf-8?B?aFdhSjdEQ21DbUtwVXIvNmVlNkZDNFFFbUFkaThVTUFpMWpCUk9tSW1nT0c3?=
 =?utf-8?B?WFhFcUxSbVdSTlBEdHlUNVZnUVA4bzJiZSsxQlJUc1EzUzd3Q3Z6TFl2K0xI?=
 =?utf-8?B?ZWEyN1BGRkwxZE5ZWHNCWUNxOUNRODJ2VW9PTno2TXRvWTBtdlVDMFV2dzBv?=
 =?utf-8?B?VXJNdFdEei9BRHhLZ2YrYVVoeDJRNjRiVVBkSldvWTdWL3J2aERTajkxdFk2?=
 =?utf-8?Q?zkHhsNb2dYbAsSIE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0bad1b3-465b-4a0f-a33a-08da4f750501
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 08:48:44.1045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iivzWmKaUZgI1OFoncGLzHIoFPJF1/s1QolBrf9CtxroKr7V8sAOd27Z1npKdOwMDa5AlB8hOT8WrdvGzbHH3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5140
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


On 14/06/2022 19:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.123 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No new regressions for Tegra. I am seeing the following kernel warning 
that is causing a boot test to fail, but this has been happening for a 
few releases now (I would have reported it earlier but we have been 
having some infrastructure issues) ...

  WARNING KERN urandom_read_iter: 82 callbacks suppressed

This appears to be introduced by commit "random: convert to using 
fops->read_iter()" [0]. Interestingly, I am not seeing this in the 
mainline as far as I can tell and so I am not sure if there is something 
else that is missing?


Test results for stable-v5.10:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     75 tests:	74 pass, 1 fail

Linux version:	5.10.123-rc1-gf67ea0f67087
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

[0] 
https://lore.kernel.org/lkml/20220527084907.568432116@linuxfoundation.org/

-- 
nvpublic
