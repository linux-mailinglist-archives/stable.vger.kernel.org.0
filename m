Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FEB6B09CB
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCHNuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbjCHNtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:49:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3D4900AC;
        Wed,  8 Mar 2023 05:49:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfP59tABrAzA7BK3ZvmBq+gGBoRljvMXkcHKyJJmAh7nNEFY/Lp3MtF21bzKeJH3mlVn1j1KAJRhRBj0THJb65hzmo/NIMZIs3DkzNM1hq1VvfmYs7UstktgPs8kP2aQLop6pAJ1/kL0Mzb9uEBbnlKcUJE49X4+KGeKjlMTO57VtcWOsK6hWAQeicB6rkRdTREm+0Fl/LoQs9jFVSy6+hmAuR+N4pPri9+/jPOEyCpMOJhJjnE6aOfMXfyCYCeFYVo8UrIhuzcYFROJjGhJkhRlxbCTTN5I3b/RfmisY1TxBFDwEtG1Lr629xPU+N4o4RMtefSrQkDdwl8dSO46Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjDvhHFuIqO+68yPhkgOtUD17SnTf1C8t5IV2DJITjM=;
 b=XxdnWJOz+IcUyHTVetIvBbR8YD7me7+el7QLua5O3ByimILHa2/Il+qeWMLAMVD3a9KnSJcF7v1Zgya9z573GERp8zYOA0EseYMNmSA9J3q8oLnElkFyKM2rHBK8yd7E8GGc/z14+MmefisoI1f9aCnUeGRs6HjylM3GnjhbtJ90NdY6s2EgzdIofcew1gSoj3j/GNlNxBiLDmjORaesPa4bahZ+2tBgjHdgudKxfojW68Vtas0/pv/pGh+6IKcx0zOx1t9gbZJme40qO+mD0fCxu/UbFjNtNrwxtpL76xqgtl8IYMO1hRs2Y6hEjFpmRJSF/b0gt3ie8Ye6YWlLoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjDvhHFuIqO+68yPhkgOtUD17SnTf1C8t5IV2DJITjM=;
 b=HFoetddLLXXwiDIQHSvRUxsLJt1Ixh96rtCRdRKTTPPPihs9S/+uG0938TCxHAdfQGtltKU5aiSkKX/gOMlc4AXv4SFDmk5qAH4KayMvg1uwDtyGk1YQ4sfD++NDxCia3EtSidgGSucv5Jl0dR2q2sN+iY1Foy8aq31mGmPEXnSMuEmPqZF6nO4rP+XIhm/xgieQXj3Qy7XHaXdvxmsnm4F1GgikVWOJmDkBoSyneTPwrqBcpF8MsaVGiyAbwoBER6HHvcfoSy5JhKxKUovW6DSBKGLKGr2JSN/EIWwTS/t+JgrJugLML8oFsi5mlGrFmZrLzC84JGsEt3iOYTM6rg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 MN2PR12MB4440.namprd12.prod.outlook.com (2603:10b6:208:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Wed, 8 Mar
 2023 13:49:38 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07%9]) with mapi id 15.20.6156.031; Wed, 8 Mar 2023
 13:49:38 +0000
Message-ID: <6883f095-cf2b-2c45-5786-a46ba1c13dd7@nvidia.com>
Date:   Wed, 8 Mar 2023 13:49:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230308091912.362228731@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0265.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::18) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|MN2PR12MB4440:EE_
X-MS-Office365-Filtering-Correlation-Id: 66ad3889-111b-464f-4250-08db1fdbf56b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lAhaj8fAq4+r0P9P2c9VpHWax4M+DPy4kkC1t9mQf525/xtELAzonB+ovYQesCTbZ6Aj7/wPxx4PY8F9zHQfHa5WUJq0GMKuP6dOfnYT9OVz56yPc1o7Pd7G0l8I2DFSI8wb7aHQNf+FreITJOV6lPjaazd1FpCswqGv/CCZah3QVH3Z/Z7NtRBcKSgII7pQYUCIfRJBQ3PlZnolCis/IJDLS4IKP62ZDrpjirQeXRWi5CHAWVnGv5+2DasVuuO28FXd0K/A/S5eNiJY3+sLD1I8uG26PNJ/HuzL2alFGMFiQvBirIJfai7gCRQ13oQouloNE0olStoLH+02KFBk+IUc6wgLTM5UEAhKA2Zgii5+vjpw8jIOqiDopxWQ3sJSnx2eZ2cEfYdfwzD7CfzPoXHNLq7XHcEFIx1DietCKzdEnHIG9ZU9Rvn/aGudEbyTQxrWB4UtR4jL6hvcYWDkEOhckcicotFwec5iOk5gxcXc9Z5JVOOE3Eka54bKMZ/emSmS2lLK2pp2x5FnrYfWWwmAedJ+T7q3v+8ncTn0WdkggOD/WXx1GeAo+sSitXpNetCqtmkA0rRaAzUyrJXiBU6g4csXHFRH83V9SWGAGQfyuJPge0/e2xl+kCzVUQF1SARS3WX0oAmA9XxE/Viw3+5jCdaDuhR+BKw+CcrghTTb2uUZGixqtHMKOZB4OVagwcbTrCIAvPb/YU1/2q4kfQkQpQYkTMRoznvXNxGF21gLjszwlOeYMbFvVN/e9w1qAt1zbRfZEMe2s3ze+dVMKyixhZL3kymTGF1Kdtb8YgBiTg4otW2wpotJbD5p1KT/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199018)(8936002)(966005)(6486002)(7416002)(5660300002)(186003)(478600001)(6666004)(36756003)(53546011)(6506007)(6512007)(6636002)(2616005)(31686004)(110136005)(316002)(86362001)(41300700001)(38100700002)(66556008)(8676002)(66946007)(66476007)(4326008)(2906002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekdUMCtoK2cxam83bW5mK1dhS3VYS2kzQ2pqZmdycGNOSXdJdzYwUEwzUlpx?=
 =?utf-8?B?bE5aL2wyYmRjaU94OFE3cStvR2trV2tSZjZLZERjZHhWaVNJT2dqNTVneG9G?=
 =?utf-8?B?TXN1Vlcrd09jeGRvRThRa1lnNlQra1BQUzd3ZFN5cXdzYllHc2R1RVhPZytO?=
 =?utf-8?B?QWlNZytEdEhORXNrTHBMQjlFRGtKbG1EaEg2anltSkp1Y3FiWmJwbG81QUta?=
 =?utf-8?B?OGVRRm1oemNlcjFHTExhblQrL0JPS2l6T0RFY2Y3Umo3VjUrMk8vOTRtUHpR?=
 =?utf-8?B?ZDdnL2RVbnYrc0tYYysyUWd1TUw4TnovUm44UW9MZ1FIOG52M1Q4Zy82L3Iy?=
 =?utf-8?B?bDdkWEk5OXA4L0k5SWlHMGU3VTR0UHAwNTlZVXBhanZBeGpsRXFXSUpqWTBL?=
 =?utf-8?B?cmUvMEJLTVlhRUNKcHR0Q21TaVB3cE44a3BKek5KWldNajBjTm5jcmRabngr?=
 =?utf-8?B?dkJENENPdklTbTFtcmF0UU9mdVhJV0hoazhURU5zWUV0WUl6eTVxSVRnSlFW?=
 =?utf-8?B?MkR4Y21Id1JuL0JjdHN5L2lPRjNiWnZmSk1lWmdscWNiRDZJUitKNlh5NVBx?=
 =?utf-8?B?cDJwdVVNcy91Q1IwQi9JMDFBOUt0ZG9GZ3BIZUV4K2I4SUFHQzZxOVl1OVkv?=
 =?utf-8?B?QWIvVlpuVVF4THZEWTZvUHF5OFFwWkFvNVF3YnQ1c2kveTZ6YUtxSlVFa1B1?=
 =?utf-8?B?Vlo3SFY5YS9mWWxlMk93SVJMK2d6ZzV1WkN5N0RkQldZU29QR1dGWHV6Q2ZN?=
 =?utf-8?B?bURFK0FkcEtSelc4YlNKTWlqdXgzZUtmYzJqRzdpMzRhcXZ3UTVlN1o5bTdL?=
 =?utf-8?B?RmtUSkZsN2xnN09RS3c4bGtiZXllcmxtbFBkd1JpaUxwSVdURWJWOEg1QlFl?=
 =?utf-8?B?Y3RKWi9VbHFHMGszaFRZVE9EMzNFMHB0U3FZY3FjWXpPN2dycFJoT0VidVFl?=
 =?utf-8?B?VURFZ0JvOC9senNRcGpwekJySzlncE5tWCtyd0orUEVpY09jMHR1NnFaTHRr?=
 =?utf-8?B?WDNUZDJMNlNSL2RxaVNCRVY5RFFtSU4wRDBwVG53WFFpVXdyelRZTTZteGlq?=
 =?utf-8?B?RWZHMk9tYXBhWE9scTNWTi94eVp3NE1PR0ZDOFFaaExtZGNTNWowdmNad2JB?=
 =?utf-8?B?bElzWkhsTmc3eGo5UzdNeEU0alprRGYvd2VPTU5iajU4bVhoK3o1ZTBJNStS?=
 =?utf-8?B?KzdYOTRTU2lrc20zZEovMnBTOUE0eHR1aHluUC9hZlhTb0IzTVdvV0tBSk8w?=
 =?utf-8?B?MTdacjIrakJxN1NtM09Bd1g5emFzQXlweUlSTjRhTDllRmVRNHR5bWZPbHp1?=
 =?utf-8?B?VVFKakVVcHRCNi9lNDJOMm0xRkMyYlRWdE55a0w5SFhXTnpaaUtDZHNpVy83?=
 =?utf-8?B?QWpISnJGcTlodnlmcEY2U1BkSW93cFBLN21BYkl1eWlHWEc0Q3ppV2l0dC8z?=
 =?utf-8?B?MkFOdEtPODVEZ004N0xoczBuT3VNYkNSSzZsR3d1NkxqZWdleHYvSnBaeFdS?=
 =?utf-8?B?a0RjM2JOQS9rUkQ5anFhdmo4ckg0dE1UaW1SL3BVNGtScWVrZUlKVzFwNWxp?=
 =?utf-8?B?azRaNnYwQTVtQldYRHh6NExUdTZHT3BWUXA1T00vK0RVaUVOV09GTEdPbWlw?=
 =?utf-8?B?TVRhcFNoN1RLS1FmOElOY0pLNkFqNmRaQVNheUpheURHVVUxNk5jakxjQ2FE?=
 =?utf-8?B?bmdJYkxXemVaVVhaT2g1TGJ2VnM4MTUwbVN1bnoyT0dSd09vV2hGWTNkc0Fq?=
 =?utf-8?B?RmcvaGo0M2FEb2doK2tUdFMremdYbm1yZFdrcW13eUZQK3pibjdrWUEybW9h?=
 =?utf-8?B?ZmQxOU04NTZPM1Q0V3lhYjZGMURaT2UxSUl4QnY2RTJCdGZoeWdiTldiZ1VV?=
 =?utf-8?B?YmYvdlpYMkJWTWYvYkQ3ZGZNaUxZeURQM1p5ZDZDdW1qT1dYVFRxbSs0b0lM?=
 =?utf-8?B?a0xxWlZRdDlxZlowbFYwRjduWHV1cHhQNVBlc3lucHV0NGJKQnptTExSclhJ?=
 =?utf-8?B?amZmd0JQSDlOZ2FKOHNOaTZldGtPUy9XY291SHArdDJlRm1SUzNXZnZNNUtE?=
 =?utf-8?B?Tm1BZUZ1VTk4ODBMa0s2VWtYQzhvWS9OSm9OblNKU0hXQWU2UVR5MVJGbWpN?=
 =?utf-8?B?bUZkbHM2aGREZmlFcWFzWHlCY3BrSTFYTDFKZjBNRW1MMk55bFlHM0ZiTXpK?=
 =?utf-8?B?Q243aWkwSjQxRWtUZHorSHBvK0NYcWVlNVNBbFFlZUZwNlNlM3JPcjh4N0dO?=
 =?utf-8?B?VkFqd2xXNEx0OWFlTG4zS0l6c0J3PT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ad3889-111b-464f-4250-08db1fdbf56b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 13:49:38.1771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xWjTTQ97o4PerpuXeQ0hMmdEhZYAnevNO1VlNk22PNkuUM8rVz2pwnYaD75/sM2NL0/Hwx73YdEWiBTsLUAKrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4440
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 08/03/2023 09:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> Thierry Reding <treding@nvidia.com>
>      arm64: tegra: Bump #address-cells and #size-cells


The above change introduced a regression for Tegra, which Thierry has 
since fixed [0]. Please can you drop this for now?

Thanks
Jon

https://lore.kernel.org/linux-tegra/20230302094213.3874449-1-thierry.reding@gmail.com/
-- 
nvpublic
