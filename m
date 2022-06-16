Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECEE54DCE0
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 10:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiFPI3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 04:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359692AbiFPI25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 04:28:57 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2046.outbound.protection.outlook.com [40.107.96.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC635BE6E;
        Thu, 16 Jun 2022 01:28:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X08Wy6BRxeTEtmQdkoEJIAD9acQkDTxgPUynnDdEAzhOYue+xvM/txeKwOQBNFRvXTm+JoN0b8+Ii3Fs6twEI5ojcPQ43YSXV+I89W2Fbj/RUHLS0eT0amZN7k8mwrjKS9qtMWU0CLeEmTfNCViumzBGVncUV265sZDIBZiajYSkVS7HlhSQ43lDurNqbGqfAgYKAr5yPAjvGNf+Nl/+TnjI8r0jPPd4Fanoo4wMB93jUlkVgbUafTLUCRjyhRHXNp4o1OvIjW9GWSNuLslpJY+DKYLoyfIxqMAaSKpCRyFMxCnqXGZKsHzm4bX1UA9jIsJj1sDGhL4oeVkuclUuSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EKWSnneBJDitEJ9ScuqMcCxMOCo5MQpjsqKInBWKhl0=;
 b=HstbNu1QWaukZNBG3/p8Be8jlsBBj+Zo+KN+tEGQQ1r5ULrRrIdWb3fleJnbLUq5WNFMSPmG/8aNMNk8R0fmpWCd68w8M6F6+QimuMkItvyQrRGpepBRkAp/+G1o6YHXDTjZmb/YUR/luJM35D08Dr5r1cW95iE9b8RU/zdh4lPUpgJJJpfeemigXvYYJYLyhzuB/ov7g+hlOdds++yDjF9tJQw7oa6tsuBZkmlThUYnrTOgn4RyNT4Gu4GQCQWQ66Buwnuooj8J9/dkT3WrxnsTfFb/X1StJ1QWHCgdSpqNIwI7Y83ZuPoCHe4P7GZ97t9ba2Vz6InkfBdeJV/Dmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EKWSnneBJDitEJ9ScuqMcCxMOCo5MQpjsqKInBWKhl0=;
 b=LLRVHFdSMnOy7scev0NgECHwx+L6segYrMk9l8yKlcPTFulUAr189XJ8ny/CQqiVuHB+D6U35pzg6gKUox27OXVQGkvTj3O/WD1MtvlvGpa1n3ZDI7qCTcz0NrIQIjHtKHOUHG6japx3Gbim+OXdWy1Sor5vp++UiWsjO0yiXnAjyxZrN+Mxq0/CvZMRxzBJhxfrrC66oHC+xVcJG9sSxNbWPFVncrZQu+8j38H8lrZlw5jTztuoaWORFVseBTHfv6WFm1gbLrOhetj1ItM9mBc9wjp2Z2TmknrdaFND3gcd4sIdsb5x1naAcczQlEIREMPjby5D0JULQHYdGuO2Dw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:bb::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.22; Thu, 16 Jun 2022 08:28:54 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 08:28:54 +0000
Message-ID: <1db50fc9-b5cf-51be-76d3-35ea62ecf734@nvidia.com>
Date:   Thu, 16 Jun 2022 09:28:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.14 00/20] 4.14.284-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220614183723.328825625@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220614183723.328825625@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0087.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::12) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26660a76-f87f-4dab-956e-08da4f723fe8
X-MS-TrafficTypeDiagnostic: DM4PR12MB6662:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB6662331B35FA1D692A656267D9AC9@DM4PR12MB6662.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BTicrKjarykL34NI2+JvQu42U0H3VlEMGNbTXJ8gF+rXUnEufK5aGTDsswBCozjKrxnc5gX19yzur4wajBqfjSu7juYlxQAXFNQTSyigaclXCowVy2SsFKL/G3tHoOkmpTMXkXJeXbh0Nt2ZRGdtDJSUU1Tedlbg8hd3G55tIj98B8jc8U5CYWLhs5+Z8qaqatha5BtfdtL6xgsRMl9AdbHnWmfU1hMRobGL8h0O2yXCXUbEc0bJhqmwlGxyjmOOw+JqYf2+NofthDABLGGrwxGeIgbMUziwGQnRYnPxA0BMQiRujzV9FBejcc3qD/a1tYakyVi4Qo6TCd5dCtcIISpvehANwYHNA8s7h4TkujIXFgnVayYUJC8ehqH+An7sbjiDKatXtQyCsWrxrNSx+zw6aQabC3De2LhN8jN0cW4oimq/FTzUa2/ISFicvUmQBFG5cYWvYtntghB/dhZRJ76n7FExxpYk1eVkvNEsNEMEYA410Tn/vxzh25NBiazr/CmxFRwG3cToFmfLhDjD3N43OrCbgqA6gqU59MEWJSIHQzpyS/nR6euvF6gvoMIrk/OoOXkSjlofVbPMByykQVXrHbhntFmV7mahZtrOkuyNckU5+TnnpEZTofzdYPrIyQu0zFWPS9hIiXYkSdkpMguVvQmyLK+UhpSGv1MRA/nV1nYWg9LD87uQvnBJF8oenft7fLA3oaHAfCiKiVdiNWsA0I08Zqk2+hV+Y0YJ1ws81a0mFMf4kIqVFBNNdNoCZlxlN324ytHU+ozyjxgzUdobsYyYl/PattyOL1hPXKSxl/X3rRi+xQjysBXZubY9am2vvfP58j2S6IeXt/wUfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(36756003)(31686004)(2906002)(966005)(8936002)(6486002)(316002)(6666004)(66946007)(508600001)(31696002)(66556008)(4326008)(8676002)(6506007)(66476007)(26005)(5660300002)(186003)(55236004)(2616005)(38100700002)(53546011)(86362001)(6512007)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUE5QXZIZzA2ZzhMaFRPRkUyTGVYWmR0T2swSWxObmM1dFdIakd3eGUwYjRG?=
 =?utf-8?B?Y0ZqQWkwc1M1VFBQeG5MM0FBbFBnTjljZFhhUHZlRDloYmFxQXlycUg3NUVZ?=
 =?utf-8?B?VVBVaEJnQnNBa0ViYVNKRndLVWs1WmdsOVV4Uk9iVEM5R3kzY3ZDcEZSZG1s?=
 =?utf-8?B?MkZ1bXBjRHl6eUM5NkFTZTlkeHVYamxESU1ENmRmZTY1cmV6ZkgrdzZJU0xr?=
 =?utf-8?B?Mmh2MU5XWHlYVUM0QkZiMHdZc29UMnlKQXpJRTQ0bGtlSGN4MUpUU0grdzdk?=
 =?utf-8?B?NFhJWTc5RlpFRzlrTEZZS1VyWGlSNW1VWXVDbGpDNlZLWFBLaEw3cUNCQU9z?=
 =?utf-8?B?L1B1NCtRM2w1ZGJkalpSSGdNanZiSzJhRFgxSmpEaEQxSFVYQ3l2QTZOTXhY?=
 =?utf-8?B?S0JMeFRyd2Z4VlJpVFd0WmUrRC9vTXBYRE9GWHVtTkZXOW5RQ2I1Q0FJS0dS?=
 =?utf-8?B?elRTYVVDUTJKMjJ0dzlwNmcxeDFRc2dHbUNOZTdhS0FRSHZLQmFOUGxqOUpk?=
 =?utf-8?B?TE4zcDFDL0gxak0rV3JLTER5N25XYmtROTRzb3Z1d1ZOYm1HYjByT0JvQ2Rm?=
 =?utf-8?B?V1V2bnBoT2xhcmY3UjUvc3BxSWZ3STJ3UFVaZnYvOWNmWmpJVTVSa09WODZp?=
 =?utf-8?B?MVdHRnJPVWdVWC9IdDhMT0tRcGc3OHNYREI4ZThRT0ZBRit3bVJreFBKcW9J?=
 =?utf-8?B?SUhQK2FXUzlPNUs2Z3A1VUdpeXhiUktHdWQ3dWRUREdKeVc1TlZKUG9DZW1s?=
 =?utf-8?B?bVIzbkZYVHIzTExPMGs4U3liUU9VbnlBdUFOcncySHFlZlhZdGw2eVd0c3Vu?=
 =?utf-8?B?NlhXMHMyNGRTN3JVR2wrbllhdXo0aUdLR1FVZjBzb3JlcXh5U2dkdW5jblNj?=
 =?utf-8?B?RERIaVNXM3Uxd2NIQm11eE53djVsaEI0dmtjNFBoOWJJenJrUGRBR1o4WFdt?=
 =?utf-8?B?ZUZXamhNV2N4bWF3TTF5azUxclBEWFc3emxQUVpMTm95SEl5alZmTDRwd1ZV?=
 =?utf-8?B?ZG01MFBXOUxZOEVPWk1xeFVJZXdOaEVvZVViV3lrT1FEZkplVml1TFdLQzZl?=
 =?utf-8?B?c3RKUThralZSVFYxOVpZbXBzdHkyOVlvTGRRbkNZc096dDVVWWRXM1lWWU5Y?=
 =?utf-8?B?Q0Q1dkFEUEYxN3ZwTndCY2N1UThKMmFjOFM0ajJrcEhqT0FYUDROR0orZktG?=
 =?utf-8?B?ekdvejVOek5ObGxaTHhBcUpJNCtHaVdZdTkvUVlIbm5OMENGSDEzNFhudnZl?=
 =?utf-8?B?Y0lTeCt1Z3BqOHcrT0t1OHdRWUJFeGJ1SnBNaEMzUzAzdlBJVURJelMzOWh0?=
 =?utf-8?B?Nm1mMEFrZkIwdkFIY3l1UHloU0dPSWJUMWFZYm83T2J1WDdXeGZxbFkyYUQ5?=
 =?utf-8?B?aEV4U2pxU2lKNXZ3aU96b2JUUU5DTHZ1RkJhRTZFYnRrMTIxb05FTkNmYmlN?=
 =?utf-8?B?VE9yZCtvem41ckFMWnJZaWdZVGYrSStHMG5hK0o2dThpbGxzT0dQME1RZ014?=
 =?utf-8?B?Y2pLSEhHM2h3VHF2MlhqN1MvWjQwMUNkTzFYTncxb3FrRnZuY1dGNkV3Q1RT?=
 =?utf-8?B?aG1RdStIMUxBQm9VM3lqVnFOTG9aZCswNlZlZmRzOGdWZExCbm9nNVVmak1p?=
 =?utf-8?B?MlpMaGNjQStHY2VjK2xCSnFGZUJVTHB4Z2E3anJqTlpuT2Vyc1p4OGQyRGpV?=
 =?utf-8?B?ajh4SjRhdk5iR3NnbG0zMlN5d204dzFqQ2thQmlGcHZ4NUFuTE1PY0tYN20y?=
 =?utf-8?B?Z2orS3QzMDJHSGltcThFWkxRUVlna01LN1BXNEx2Mm5jQ2R4UzBXOXhKNUFp?=
 =?utf-8?B?YnFkcyt6N2ZLQ0YxNjYzQ2R6Q1RMR0JqbmF1N1dOYW92emtBcE1HR1JJaVBU?=
 =?utf-8?B?K0lLbFkyRlZsR0ZNQ29GbGlKWmYxbFVxTHlESXM1cUdGQzljNitZSVFESGtj?=
 =?utf-8?B?cmdpREgrWnNRV0NZaDA3UWY2ZjZDbktyNE5zS3FVaWNtSDFCcXhwd3praVJ5?=
 =?utf-8?B?YzJxaHlqeFBkdmhOY1VzR25JWmtNSnhiY0tkdksxVEZxd3hwUGptYkpZeG9O?=
 =?utf-8?B?NWhTeWllMFRCYzVWWjFGeTVRTHFleUJQcU5icTFCQzhlYW9QZHkxQmRUUDNh?=
 =?utf-8?B?QXFpbjY1UTIxaW5yNTYrUnZyT00rSnQrVlZlSkJ0SWRpUVBFbFlxaEJ0dWl1?=
 =?utf-8?B?YnUvYnZnRVNwSkc4WlYwM0hFT21rWmlWSk9PU0lNeEw0SVprSER6Q1dqSUhF?=
 =?utf-8?B?Z1M2eTJMZkpqMEV1ai9ETkd2aFRZUHRWZTlWTUptVFdUeWh6WTgrSVdtbXBx?=
 =?utf-8?B?ZEMzWU4wNDlVZU5NZUhDU1lNdW4rNW5GQU9yNjYwVDJRRVJ2Q0daTms5R3Vn?=
 =?utf-8?Q?++PlSlIL9RcLr+sM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26660a76-f87f-4dab-956e-08da4f723fe8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 08:28:54.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bOXLUiu9z+cO5IHNnKI8juG8KzFCTvF6vKJh5iRsMEukXRxlvwpBlv69y8OchCTfcKQxxLjhFECbKmfcK9jnSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662
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
> This is the start of the stable review cycle for the 4.14.284 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.284-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
     8 builds:	8 pass, 0 fail
     16 boots:	16 pass, 0 fail
     32 tests:	32 pass, 0 fail

Linux version:	4.14.284-rc1-gbddb08ba46c8
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                 tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic
