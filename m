Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73DA54DCE6
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 10:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiFPI3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 04:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359662AbiFPI3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 04:29:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096565DA6F;
        Thu, 16 Jun 2022 01:29:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITwq+Mbfvcj29sRAu75Op70X2WQyC7bJnZIwiH8QrYzMyCqxxCeRFvOeReXN4PnyKg1n/K6UFGu4hNTAmIHHxblgSCMyf2AcMBZBfmF0mz9l+1PFlMFiPMgK4J7BNv7KAZ69T6DXWMgmDt2a9iX0PbpBmYUPfSOvY9fjZtqSj4GT0UPE2r1Vz1Zzj9a5zFmZtqCAqcSABnPvePBp0RWxeCIXRU3cKPB+ZYXYcsPCYmUjJJASwVyhmZbA+8XqbtcWckw/dQDeqL6qwWeztjjHC6m2eF3lD8alD5RyJgejQl6fJZRFNGXVKyB+jjm+u7jyoWeXXW4lw0AAbJqzg2QNJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rS7yOKzT7/G8Zzxz54idBsHmMrKjS/hHGjLuE+219qg=;
 b=SyYk0aJlOxBeSPzYzLv6YIlgKTVoupzgCuFFTyZarz9JhFDMfhAEHgyy4A7EwiikyQxIQ2zgTdUo9fujmCLKeAJZlNEIBvid26Y/0BdvYt3eDG/Hjuqtr8pPeCzc5JTofuPRXVrjVVnyt7NejO1fxFGEJWS0+nWDOBK3w/vesEqGn8IHr6UgQ5ok+hjhbQS+otOnpbVwSWt/y5HjEhbuvDlzJMzMpyfNcBC8uvS1YgJzCI1cA/B5VZ3bmNXnZRwN5RGqRZqoM0QjtLk5oTQPRyf+BC9qEtLedW6oCNYiILzJLMPzXX3BQRkpdxpeITWNTkGPCGwwOAH30KUsd4CLUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rS7yOKzT7/G8Zzxz54idBsHmMrKjS/hHGjLuE+219qg=;
 b=PQE6DB2F0MJxn0oLxCbEpMKm5Edn6f0/t4RsF29soxq47LtYHitdiJE6wroKarOzscTb/050BofPPHfn79vMq/jUJZQgUASrSUSbTYbMoaUQO+TJD2xWLGukWMEbnf5lohtKBuE64hurYWtmMfLbMTC8QCsz+XTKeizmB26Fnsv3rPeAJEUx4iMvE3xYiMvNp/YvA80yFYWY0T0/ng3BVP649qqvVJgFkjaPc6ROSX5IOZf+4uZOOoS8N8/84Bq60Lx87G/3UORFBjA6dIEScUfwMTuWbs8FdOdkXLHeB+yEmJuuWtQ9yrHJIXnIyfQTNPiwKOSB7cA++YIiIE1Ulw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CY5PR12MB6252.namprd12.prod.outlook.com (2603:10b6:930:20::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Thu, 16 Jun 2022 08:29:41 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 08:29:41 +0000
Message-ID: <e2d8a005-90ca-7047-4594-6fa25c494ddb@nvidia.com>
Date:   Thu, 16 Jun 2022 09:29:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.4 00/15] 5.4.199-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220614183721.656018793@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220614183721.656018793@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::7) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3bbeee2-cf4e-4f67-1fe2-08da4f725bda
X-MS-TrafficTypeDiagnostic: CY5PR12MB6252:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB62528C739836AAEF0048E6AFD9AC9@CY5PR12MB6252.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e05JsT4GTYbf5P6XMLEXZcXBLxndX27uCuG4K1ULIIsGK/7QV8/Pl5Y2M/2Ef//QxPzT4NRjfhW+e40aBQ5JvC8EchUHypbAKN6N3oOB7wNDnHg35HNdhk67vxZjZwpj8HBROytyd1tP77uW7QmOAFXa0DkmT4bWThCABDsh4343FlhAIMalJ0WvjIeDM8xUQ74Okmthf4Q0NesQvz1SLhXyzP7yEQa1DnExukvcW87ND3aoTfczBIyITmukJZVdEzY9Ehz+UO7alaUDUtFEKMrOtW3gW6LCjSvv9a+8Fo95FlJO3zy+dsmKdMmwXQemUxyUei9YsOWOa48B+/42b6FsZQEruaB0l0dKGXCOIX+4K1CD6hyQS5y1wGgPON2pdjjO52Y0hWSMsPbq2nL4WuI5DkUNtpY+39tRRFtXuUf2SBb0T4pM2V09c/fTiELdDcILx+DV4VjeE+tPtQGq+v35bwyZGyqntdOeGyScJEGDBsfZ+gp1vmqIu54/1j89weMBA/giCIBZn+jSZpyVDUvu1KLpEeZXgHJRFFDosaq0BPttYLXYhmUF69kL4BxpSj4qpDoC5jTOxTC+8749YbvgAcmNLmkYIhTyrCVoiWPpzQa9p07Y1z8OWYmrlXevUrqIJACk7XWLu0aLGXMF8xPtMpbn3Dnvexatip6J2z4zXEj66x+0Ru+G5PWqfdRCG/U32UBkzHA/xM8C7ttGp2EyqRKDSGkemLPNbvE7NC7WMomFct8KlVl5mOaKaA6Z18tlQcqWm/lp4GMaDmE0GyNNpqGHzg/rZcZB/8ZTnmmmrw4DRHQuH0Yf9ab2AllXJAC20jcCGPpwGdTNHfBSIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(86362001)(38100700002)(31696002)(8936002)(508600001)(316002)(6486002)(2906002)(7416002)(966005)(8676002)(6666004)(36756003)(5660300002)(66476007)(66946007)(4326008)(186003)(66556008)(6506007)(53546011)(55236004)(2616005)(6512007)(26005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnhhSExmQUk0U1g4ZlNKYXU3cWs0NmRENmdzZTlWeUxLR285SlJMK3A2WGJN?=
 =?utf-8?B?MHhOK0NjOFBQSC93S0VlSEs3Wk1BQ3JLbGFXVUV2UVh4UEFOQUxGSmYxQnBH?=
 =?utf-8?B?cVU0bUMwU0RmY2NOcGp5M1RUTkZXUGZDNU1XMHQ2R1R4Tit4SG9yVXJtenhQ?=
 =?utf-8?B?Ui9Ka0VRMFg5ejdUd2dRSUQ4U1pMQ0VoblNCS2JUc1BpVXNlYTg0dmoxUlN4?=
 =?utf-8?B?dWRxN0V2Mi81RTBDcEE0bllnNFR5K0FEMEE1NmpCdGpDSEtJRFdROFpNRjVR?=
 =?utf-8?B?U3hkY0lsckh2OWZvc2EyYWFoVEltakFROXhxVHVOTERzbzFHUVVzRDh1eDBT?=
 =?utf-8?B?dk8zejdrUDk1dllMMGtNQkQrWW55UEZvY2xnd2xxakExOXBadzNEcjlRU0hR?=
 =?utf-8?B?dlBQeDA4WmIzYmJPQnRqRm1yVG80M3VsNWorazdTa25LV05XdFhweHlEQXRQ?=
 =?utf-8?B?aExtQmxjdXhETTA5cmdLK3lSRTJibEFnVHZYb2JTTUhzSnpobW5QbTFydHpn?=
 =?utf-8?B?c2RXVW9KK3I5Z0llOTRBcDQrZ0pNZDNJQzRLcXF0Mm5BOHIwV0ZDczJNclhE?=
 =?utf-8?B?V2dBNVRTUGtYRVpSakRMTlUwc0FYcEpUc0VvU3J5czhub3ZUV2JWSGhBUnFJ?=
 =?utf-8?B?bkh6RG9yL2o3MkxzSFFwbThKNVd6WUJBdnByKys1QmRmTVN0NlFPVXpZNXpo?=
 =?utf-8?B?MWtnQlM1Q0l5dmZob2txRE10aDhRQmxkUUtpTm84SXJqZVlyYjJGMDRkeGc1?=
 =?utf-8?B?WGRpaEd3M2lQYWdhZ2dWb25hWWpYR2grTTZrdS82dCt4d2tZNDJHMTRwRGlx?=
 =?utf-8?B?NFlYNFJENDN5dWU3VWVYMGR2SlhXSXVQRTcraXBaeHpYUkJyRkw1bzB1em5M?=
 =?utf-8?B?dXdxVXZlU0Fwa2VHZGF3YWlpeGplaXlpQk1oZzF1QXloRUJWR3Rjbmt6RHdy?=
 =?utf-8?B?bmtqRGpSNEM5V1NwMUVGUGR0TndyRFNhbVc4bGhPUExOa2xubDhlYmV3cjMy?=
 =?utf-8?B?dnUzNGVoczJrOHNMblJ5NGZYb095c2F3bFZ1eHdXMFpHMEpIL0tsbFJXM1Vx?=
 =?utf-8?B?eGowQkhhTERHZG5tL1JNTjNDUmRub3BQNm15TGVQdFBIeHpDOVlITExjYVA3?=
 =?utf-8?B?SXhWYThpU2k2RkxVc3NtS0RQUGlFcmN6VzN1VTR5eTd0L3RYYUt3Y2JYdHJm?=
 =?utf-8?B?a0VEeGxTSFl1RFdiRWcvamk5bm0zUnZQbjg1dlh1R1p0SEgwOWhtMDJFNGtD?=
 =?utf-8?B?UHZpakJSSEtqZzVDbWJPK3d0V3o2WnBsK2pmMDVGblFvazBQWURNNGh4V3Zs?=
 =?utf-8?B?QUJGTitEN2ErRHJLdmh3L2cxdE9TeU5XU3VxNnFXcFJUYmZOdUF1MXlIVFdO?=
 =?utf-8?B?b2Z5bFZJNTFkakNMa2VTM2dHYnNPdDhGZVRyY3Zna2dWZlVUN0VsL2gycm1W?=
 =?utf-8?B?WmNEQ2UxVUpiZW1oOHJTSmhOU2xxMTR3K3FvV1l2eDRVSUtwM1RvSms0Wm5P?=
 =?utf-8?B?M3doL2laYjlkcEZxcEtiMUdzU0JxQUxiZXBpenBJZkUyU3kyUGMxR3h3bm5p?=
 =?utf-8?B?ZkhaeHFEWWZKR2g0MWZtM0VmdlBRT1I4Ri9lV3dFRUtSbk5RRncxblNhdllZ?=
 =?utf-8?B?UCtta2c1K2VtWWVwL1oyRXZPeUZCaWgyVEdvZUpYalFQUHRDcDZmNWVEQXV4?=
 =?utf-8?B?NkFOaDNmd2xuUlY5Qm1iSzIyUWRMM3ZCZURCeGN6TGJScktEU3F6WVVqLy9C?=
 =?utf-8?B?ejBiWUVNQWxya2V3UWJEanRMRDNCTGdDWis1bTF1TGFlcGNmRTYzUEJzdFly?=
 =?utf-8?B?SFZ0bmErWHZzSEJvUEVHMXBlRm5UMDV0dnc3c3hsZXRoR21oTkJGdDFCQzBT?=
 =?utf-8?B?bzlwY0lGVjRBUUpWNmhobVVWdGZsazJWbjhNNHJKdS9KKy9YOFkyUDdRbUky?=
 =?utf-8?B?Qmc4K1JkR0RSUnIwbHVrZm4rdXVNa05aOWZNZ1NLTS9hbWs4bURPTVZHS0w5?=
 =?utf-8?B?MFBJQ25nMFpuK2NUVVorRHpTTGlMY1hRV0JON25aY1pmS2lGUTFYWkF2bmtC?=
 =?utf-8?B?WkU4ZlluSFlKRSt4VUZBTXp1SmRwZHFtRVBLYlppcStpeGFENHhZemZWdmdK?=
 =?utf-8?B?MDdCdXJ4VVdSMDFhQWYzRFpyc3VmaHFWR3ZuNGgydzFhaUNlM0ZmRVlncTVW?=
 =?utf-8?B?eEYwR0lFKzA1cjdGcGpqSzZOMTZXTjMzZWZKTGR0Q3llbDJzYTdKeUI5THRJ?=
 =?utf-8?B?dlU5TldTcFBScll2UGViUDIwRVY1NWwyNjYyNmlOWm5FVVJ0TmtTaGpMMm5v?=
 =?utf-8?B?RmJyNFdjSGNNNmhYZWNkS3FQNFJqYWh2SG8wQ21BNEFwUHZHV2MyMnJlSGpv?=
 =?utf-8?Q?QMsSM8JliHy1IR0k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3bbeee2-cf4e-4f67-1fe2-08da4f725bda
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 08:29:41.4577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVwo3l6uowgiiVlSWN6E4X9Zh8V3tTdw5YMEYMhrDKaehVJKWRIaOHE2OQBg4rheTAn9TXVhd1niEGVJVNL1ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6252
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
> This is the start of the stable review cycle for the 5.4.199 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.199-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
     10 builds:	10 pass, 0 fail
     26 boots:	26 pass, 0 fail
     59 tests:	59 pass, 0 fail

Linux version:	5.4.199-rc1-gd05ea6389e7e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra20-ventana,
                 tegra210-p2371-2180, tegra210-p3450-0000,
                 tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic
