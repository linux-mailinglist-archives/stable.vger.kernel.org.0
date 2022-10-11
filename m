Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF14B5FB7FE
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 18:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiJKQKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 12:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiJKQKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 12:10:06 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6419C326F1;
        Tue, 11 Oct 2022 09:10:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLO8taJm51EDgo1gjHtMA/Y6HRVStoyfKwcAi7grYpWZcu4hutqRxyWGh7+HyOvgDSOvTaz4zI0RDssEdONfsynSn2TkAe5zHbZJn+htkJfGjXosL3OEMQjbUKKeLiulfE70bvgjl/sphSW6ldmU4ThTb+UgH+RN2xC6kUz6asL5LYZCGcd4ZV9XE5L3/6GImhunv5o04I+rFCd06xex5E3pg7+/GhmQrU5rnmy6JhP0MGyhw7lOrvxNVA0E6eCITS9IJ0WQqvB7wgdMyPgDHF3ENKELMMA9UZ3oOr3UQaQJ7HgoIOdeQu5abFYAXAeirQFOT2BL3Cenvpg/HJh5Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LTAimMgwk49UT395M/BB+xNuyhrfHzuBsX/+AGCTEvc=;
 b=bVnfZb4HGW9C3aoo6dawoG+PayHS7Asv/otSFNeEkjrUQGMQWzV0Q7Upg+pXlz8Wj9eYpjf1BuygT2aQ7fyQgDeEECFFDVu3ITxyiqtgta3DrAGHE5Jfh+3bytBSCljX/kwR6Lxnb6bBlx7Eehh/HKFxMuF8qPRYCOsHClubGyJ1wpQf83Ii9yCtFy9HeOYjSPjPi4VgNDsuwjlEhjfFB4x9xhls1isFdDC7+Wq4iTwldBsqEpgHGP8OnnNsHtuM8hwe47yQMKQ1WzI2oBqMwGasscGuL1HKfKqsQpSrB+PqOuKbxdv68ulia82cSzOt1xSaZme87tEY6ejQrMQu2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTAimMgwk49UT395M/BB+xNuyhrfHzuBsX/+AGCTEvc=;
 b=qSJQum4K+946jceh9S5dVcziwN6B/mlkOH5WeqhtKsVXsUkHXDuC5uObtHRemNT8srAL2ZhNVftvdT9xnM0CAvW5xsX9PJUpGhKh3f8aLAPaPpqYIxJQUkrmubJhZ5Qw1tqrUDVa15S3M+bCbF1WTolFbazmCcOw7xd1ervu10Ul9vV24HMdleqLcNTfAbUbWfGLp3cHnOU+eH8R3Kl44xIl+ztbvmpymPgfugdB0aHkVFVHMNKHjcH61/aQB8frbfeTff6l8YSOt7sk98hCD7L6Y+eREoV+pwGGmTPBx+wh93/oQu2P249C82tCX+2066rbxIA3/8NTf2/JE8yKUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 PH8PR12MB7445.namprd12.prod.outlook.com (2603:10b6:510:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Tue, 11 Oct
 2022 16:10:03 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66%5]) with mapi id 15.20.5709.015; Tue, 11 Oct 2022
 16:10:03 +0000
Message-ID: <0ca79140-d79f-2caf-7935-46bf3c958de3@nvidia.com>
Date:   Tue, 11 Oct 2022 17:09:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.19 00/46] 5.19.15-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20221010191212.200768859@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221010191212.200768859@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0080.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::21) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|PH8PR12MB7445:EE_
X-MS-Office365-Filtering-Correlation-Id: f31ddda0-4c64-46f8-b284-08daaba30e38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OKJLwCMrnriSwJBNv+CVDaP3gkBszspRrId+k6nkcb8MnM/LEDY1a+SCDkJNPEOyZ2wfYbaPG6UHMBsFiBcxk9vfsVhRYNuIbrQGl0nP58qfNeRhoKP463/YqVP+PNByE4zsK+OqsZycYtriUPTKbOkdUFt9dRNSDGIp4mcZ6sE5u83DioantTl8dutZTXs5/Z8aMZ/1SLvl5ToFA5M0pIlsDVZIT9bEKoywB8VbbXveiqABXbo0ULMjLA9XQrWPLianc116x2awT+6d8jyKFGv/d4U/U4tRyN3Ax2ys+sO5DnfD50sjMMyNqmjWUgmdS7pgivE/6UNSy3x0RMlCg48gCbsHtEf0J1264DAr79Jy9OE78vU11dNj4nDbNfwc1ZUe0ig9l7MoggvaAWjpiw07MLCLTgtqY68i65V2ILIGhW0pl4LAN7W/WrPK730oQm59KjREdOljLSvCQVtYxUxxrfV3KI8ke6zJ8AlxFp2OxsnWL9LGlmbD95p1lU5HjGP0fnZigRZkb5QS4kp4lWvVo6GWJ2OceJEJIgktG7wZZycaQFZ6CAwvONY1DCVeIUOpAa90d8wudiFTx9SFWlmMFjfIgjqi0iQG6Rd2Fl9CkLJVLrR6nSJRBZcKO9isqcIhKs6Hm7LRzZzVjuhpZlh/0/sdwoBdXtEDq0rtUZqNnwsb5fFIQf2h2KGZivlfmM9Ex+9b8cKWICZvoGUadOvqAW/5p57pN4sYMU9w+SgX/YspRncJu4TvSnoEp4NT1bcksTb1JSXgKwRdzgHyvtlmVvLjVyTsy17pqgUsCr5gj7+eqgIN1KCnvGsuvCw+nK131fsmTWEjJSFIi4Us0toV8cqQQMFpQhzx3xpDnMsRuG8dYh6XzEXEDozzLwRh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199015)(36756003)(86362001)(38100700002)(316002)(8676002)(6486002)(8936002)(2906002)(5660300002)(66556008)(66476007)(4326008)(66946007)(41300700001)(31696002)(83380400001)(6666004)(55236004)(53546011)(6506007)(966005)(478600001)(2616005)(186003)(26005)(6512007)(7416002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2xTUUtyeURjdXBIc08yeW4rOWpEN3UzWVY5amZoZEw5Nkt6cEwrN1UyaXBs?=
 =?utf-8?B?NmswQk1LU05RK21QQTJqaWt2WHJYSkllLzF6citQM2tEUnpwb2RHRnlwSm9s?=
 =?utf-8?B?c3h6SWxhY2ZyT3A1bVArbjNxYU4zTldlUnVuWE85WDFOK0dYUEFyd3RSNXIw?=
 =?utf-8?B?bHV3Q3V3TjBRM2JPa0hYZ1gxb1VOMEEySmpOaGMyQ0k0RitNNEFGMUVZU2Rq?=
 =?utf-8?B?dmdVRVB4bVpJM3BjRVNZdjNkWUk4c3Q5ZzJJL2Z2Q1B2K0Y3L29NVm5TTlNZ?=
 =?utf-8?B?bktWcjk0MHc0QmxycGFTeHgvMkhGa1o2dFF0Sy91MWxTSEhOTUNPNW45UXJC?=
 =?utf-8?B?ZmxXSCttVW1iQXZZck1zOTdRN3p2YTRqcEc1K0VhQ0trNGg1b280S0Ura0tQ?=
 =?utf-8?B?NGFYRkQyeUZkdmpUNjNSSmpPRkk2VXVDaHh4MGdJTFhCUm9ZNTM0TGw4c1Qr?=
 =?utf-8?B?NUlQMWJlSzZsdTNyQm92U3VVZzl1NEtrSjlBY2dNOGxORFlscXJVTEtwT2ZT?=
 =?utf-8?B?cU1PMXByeGVRM25QWGNWeDBtd1NIRFh5YzVDcFFRT21ldDBpTEhXWGxhbVl4?=
 =?utf-8?B?VjBteE1sSEdTZ2RlNTJlN2JYZGFrZ3RKN29za1ZZYjdSczl4VHhyTW9UL2cw?=
 =?utf-8?B?RHVLbVRHSmpCV2lHd2tQcjZZUmZWQjNiNWJ0allUbHlkQlUzQnVoZThWU1dJ?=
 =?utf-8?B?SnRYajRhajArUVFvM2NPWWhzUjgzdVFXdExUS3dMNWRsbm1tUXBoTExvR09l?=
 =?utf-8?B?eWhXN3FRakQ0dVpzL2VvczRwYm1NT2YvUDNzcEs2ajRWU0Y0SjVETnpucGNo?=
 =?utf-8?B?K09NZzJQSEQ4VlFtYTR6VUEwcUJLV1BVcWhMczBlK0ppS3ZiWUhMSnBneWx4?=
 =?utf-8?B?dVd3SHpDNk9DTTZJYnVrNktOMkk1Z2d5VDJ4OHVDaTRyQ1ptNTA3Y2l2ZE8v?=
 =?utf-8?B?R3o1TWVaSGtzNEN5ZHZ6aHZ6ZjBtb000M01KanhuczNjOFVGNS9NdFRqSG9S?=
 =?utf-8?B?L2NCVXY1RDQ0WTFvN21STXB5YnBpTTRVUHUzVlhsR29DMTJUUWlhZU1KbEhv?=
 =?utf-8?B?V3JTRE0wQzdlOW1jWE5GN24vcStaZUdlR2h6YkNqYkxic3lqL3ZsWlBDMVI1?=
 =?utf-8?B?TzMzNkFNSSsrNyswN2hBQ3NGYkNDNFlNK0t4Mk03VFhpdno2Tkc5azdjL3hu?=
 =?utf-8?B?VUFPR2lublVSc0N6cVpqSXBlWUdSV3NpK1VmVDVXZlRKNmpyTjUvRW9NWk9n?=
 =?utf-8?B?WVN3QjBLdUdaQnAxLzIrb2tFSXNBRW5rN01QYkVkeEYxSEdBZFRDQU16R3dN?=
 =?utf-8?B?NmJtS01uWTJPb2xkNWhLYklPUzA4cVVwZGk0MHQwYTdMMWQ4ejRRQVV3eXkx?=
 =?utf-8?B?UmRkRzdGU3crUTA0d2xjL1VVaExkaWpoRXk0MSs1VnFpZDVQY1lyQnN3UkNU?=
 =?utf-8?B?Q2d4dDNCZ1JYL3ZxUWZ1aG9HQUZBY1MreEQzU255TDdHemJrTTVvSU96OUhZ?=
 =?utf-8?B?WEtKUnZ0N0tEbVJWbU1jWUJmVGRsSGU0akptM1RmLzJ6NHFYTThIU044RENu?=
 =?utf-8?B?OVo0dVBFaWZBOGk3WmMxd2xMc1dPRFZFNVNJRzc2SXNiQlcxNUpaYnlBTW5X?=
 =?utf-8?B?VHFlaWpwS3lGSVpRQ3dURkFWSWxVQUR3VDBVNWFTM3MveXEvN2ZodGMxTFZ0?=
 =?utf-8?B?ZytkR2hNNUZrVWJXMlhGanRSckJ5OUNPZzVPNXhVOXZJb2xCMjBidS8zaU1W?=
 =?utf-8?B?ZG9kTENpNWdHU3A5LzBVQTdkdlp3ZkhTK1YzeHcwZWNaQi9wamtIWUIzOFRR?=
 =?utf-8?B?TGhvYVVNaDNMNGE3V055amhtKzA2TjlPUE5YWXpRTlNpUVNzSGZ1V25zbnpz?=
 =?utf-8?B?TzloNTdnc1lobjdNMnE0WktoTHFNanpWMDVPQkRIY2dIazVQL3NwVnZrN2U4?=
 =?utf-8?B?ZmxHcU5kL092UUd3bHdkRkJDbWRuL3FGdmZUZjFtMjZtYmllR3VHTDd4Mzh6?=
 =?utf-8?B?Z0ZZRVRpV0R4TVhsS2JPODVhbitld016Mlo5RXZ1NEZ2VG9UQTFJM1ErdEtF?=
 =?utf-8?B?UVBoU2JvZnJSOEJWOUJZM1lHZkRoc3RLakd2MzJLcGdZWWwrSUh4cHVETFph?=
 =?utf-8?B?TzZ2Z0luZmlsT29IOEtpQXF5c09JazZ1NStITXVHOEp5Snl2Z1VqUHFYNUwy?=
 =?utf-8?B?a1E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f31ddda0-4c64-46f8-b284-08daaba30e38
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 16:10:03.5461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DMtGcPoLd86VIc2/RCUE/b7tMiOLR4J/NhbuwRHuCsJEgkpFZPMLJbIWry6rU6MFT7a2yJN/9YrO+tJENxPfFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7445
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/10/2022 20:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.15-rc2.gz
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

Linux version:	5.19.15-rc2-g08ca61ba8d0a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra210-p3450-0000: devices

Tested-by: Jon Hunter <jonathanh@nvidia.com>

We have a fix for the above failure and should land for v6.1.

Jon

-- 
nvpublic
