Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8573B6C3106
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 12:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjCUL4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 07:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCUL4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 07:56:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9174AFCE;
        Tue, 21 Mar 2023 04:56:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWdFoQ4ySagV3UiSCRTvX5rOieYEFNUfHvf58AGHEEjS2fTDapoFX7ZUaMDAD/WJrPI7eX6lElOXaR4CfNWKAe6vMEnnCC768UuMQx9fvWIYezLlGLF/L6eh39Dq+7SlaJMjrSh0HK9OdRjE8ykssDJeSm7440pODrmGVON3SaC9QsYPGCTeSceSBrU/E5g92stgVbvzKRoxKRJXgYfXRzeWN67ftbzMyuO0MazGKLFFogKxGSmZsPtu/QyFAw6TqABjAht/5NNR3tio5B7YiH1VxIMr8AljGIcdfVLIRqchtElzd9ldabYdZJz66tLRjUXCO+5JrIen7wqGcPudvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uy6y9JbYAbs6a/0XCKlr0PEoXegLWDDx18ppM7uavZE=;
 b=iK7gFzML3c+E+6dUs81XJ7VCAM0MSd40QMLktR3xAE3ksleCoGQ96Bgw5hbKILKR/COQTaLQZlCSuOKh+adEdSRnlR3o+TuuUlannXFP26Mpvy43AAiuGR8+r9Ux1oH+ctFYkLk6X4BuXR0k4VdNlYuJBer0fwSRvkmIw4VxWSIMuvekmBbyuVKbBx6sGXhZnqfGJXnM05F+lTW155PIsixOwPqfC23z47IrMoT/4tQn+3gvL05E9Ok4eJZBTrlI+SXmMjYubKCyH7N2jb3vFiSsIh9cXD0r1rqzR26WG5TpxbkGOI5IGpJT9qdBh5trPH5PRzd/6IDI31uoZfeChw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uy6y9JbYAbs6a/0XCKlr0PEoXegLWDDx18ppM7uavZE=;
 b=qzVmY5BH7VReBN0SKWEcWa3Htm1UdI/tTr3Vg+27CE5QCcFSDy6Rj8wR905SUs5Y8f8prgl+JgPW0f9VwdTqdPiiiYx1fU3ChYKpzEY9D3GDCOYQROQT0SZlzHQbfhHBrP1PJKty8KwkYcndCL3T0fYuIrLBBchn+sANKni8QSM32zjnBIhxpZhkMZAf2tkf3SVsnH3PqH7DU4ZVigqnoEjAkbukMJBW6kD3bW/HI9zkofAZgSMBEWK2RdsEYrBaLeRGlGxhLoEb1QDfEEkXO0h5c+kf69VV15US3ynVizq5SDu+IrTF6X/yDDR/GHvfOnItdzB+UaR9tG0dqanIMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DS7PR12MB8273.namprd12.prod.outlook.com (2603:10b6:8:da::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 11:56:23 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07%9]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 11:56:23 +0000
Message-ID: <8ed70b3b-53d5-a67f-ed23-6d35853b77ac@nvidia.com>
Date:   Tue, 21 Mar 2023 11:56:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20230320145449.336983711@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0606.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::14) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|DS7PR12MB8273:EE_
X-MS-Office365-Filtering-Correlation-Id: c54e53ac-2e94-406d-acdd-08db2a034a7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w4JcgtC06avMK317DU72cylkXP6/lMtEFA8k76onAEUCzsP+EwpYcEguEFqHM5eTf/T0PY6tLBKPoDGSSPREPAsgAJaSyOE38BjnQ6iskAVxMMcDQfja1+qzEPvqk7BN5FkhkD2vK0kHz2mdNM0aT8ni2/oYsGW4UdAjy6iTNwFxUPE/RaOPk4V9463FOZhJQdCZEvXdnR8FR9XzNQLm26vZhm+aObHlt5ljC6vEUrATjd7rQk2ogmsZHMSESNBrFWm5G2bca4kpIazRULBTMb7RvxcVtjTV8TffQZlm3SPqpReaBejdPgAEH/hwm/jJJygSEK44P6gGkqb7fZiw/2EpsJcqV2TZoWsUBBWlWtR8oDJSk165GzMw8kZc/hZ78vVRO5jZm7KqU/SMdrZceq9z+dgYYAwP8SzGCrweiGl1MTRofGwp+VEek1XAua96flZTefxbzSLaunSpxy0aTzlV4WpJ9PtOnz+Aa8V9cb7JeTsEE4Lr2gPOLo4eeuj2JtEqwd9E1fAloXt0TL5eg6poi0ONfj4rlvNnhzBQVJNrKQHrasxWKvG1s5R+ol1zhEa79LfrtS/LB9prnZQRvdY80+PMF5vk/5h+44ZjOOlhJQ+rlkbb8UgcbOixkjBztzUwbXn7UI+3WcgOInlq3RDTlWpWIQQwKB3nDNu+jMJ3vpnADcu/wxMLsAmsiVy+gbs8BuVveQJZETwEB3rIh1GGaees/fOJCYQYUyOi+LK/6Cz3a5sEjbDYfzJjMho7c83k8tGRvCQ1FkxcHPl72g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199018)(31686004)(2616005)(966005)(316002)(6512007)(6666004)(55236004)(53546011)(6486002)(478600001)(26005)(6506007)(186003)(7416002)(31696002)(38100700002)(86362001)(4744005)(66946007)(5660300002)(41300700001)(4326008)(2906002)(8936002)(36756003)(66476007)(66556008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEI4UXVtVGpUNzFaSjVydFBxNDVEV1ArdDFoYUFjUFdqaDRvMFdkazBPZnky?=
 =?utf-8?B?NU9BdERENjhoQkVUbTBkRlJNRldIU1ZkaHVmR2dlMEpPQzFKbkpraGZvWCtk?=
 =?utf-8?B?UTRMbnZ6UjdpQTJMRjRYNjlpS2FaU0pRT3pKU2ZrdThjcUlnYmVieHFoWWRa?=
 =?utf-8?B?MTFLd2FtZEtpWVVHKzJHYVVrN1lqRnhUbjQ4MkM3ZkY2STExUUhZRGZoQjNY?=
 =?utf-8?B?K1IzUU10cHl3TFVCazkrdnJMWmY3aG9BbjZqaFlIUXlpckxmaVVVZXZCcjNX?=
 =?utf-8?B?MVZLeVUyR2RlZkt4UUZKU3FFTEFTK3RCR3c1b2o3N2FpMFUySFhqRFRPWkJr?=
 =?utf-8?B?VkdCZzFUemtyTEQwRXJpRTUvQlBSMmJQU1NNL3NwYVFZV1pjYmR0L3RJa2kx?=
 =?utf-8?B?QnhJa215cXA5QmRpYVd6TENFYWY2cWd3L3VLTWpQc042QmxNaE5pQm1RTVBj?=
 =?utf-8?B?c1hFSUx5UnVSVlF5MWhxRVVuUDFacDZFdVdHb0NsdmJPazBrdEpFd05iN0VS?=
 =?utf-8?B?OVVYS3J5ZXVnSEJJb3d0VUZoSzZjdTBPeUtvU1NaV1c3MlVtNldHTGdrblA1?=
 =?utf-8?B?cWRBZHFWUjJhcy82VnRZcXA2M0NWMllET3kxekxzT0xzU1BMUExKcVhVRVdq?=
 =?utf-8?B?ai81QllXTmR1UGhQNGtueThzekpJTHVPMUY3S3JPek1NeFhOSWZvUmhON1Av?=
 =?utf-8?B?czRVYlI3eWJsRFNsUDJzNEgyVWJ5ai9EMHdzNGp5bksweHgzUHZsK1R0Q2RY?=
 =?utf-8?B?dHlBOGY3enE4OHM2UWRBQjRDYzk5ZUhlZUgzYys0OEU0S0d3d3N2QU9DdmpC?=
 =?utf-8?B?R0NvYTlrMDBHSDMyOEhORmt1c09hZ3hFQ3VBV3o2dGE1Rk1KR0VPTFJ6RnZJ?=
 =?utf-8?B?aExDNFU4VDN0dXdpMWFzWVk5Q01QWEhITFpuMVFoVkJLQ1RYL3V3OG4vVits?=
 =?utf-8?B?eFlHMFVBZFJMcHVhOEdsSGRteGdkalM2S1FqaWc0RFIxUW4ybHBHeXE3MHhK?=
 =?utf-8?B?TTRjd2JHaW50bWxBMm1NaGJmQ2dZeFMzZzVzdzd5Mk1oNnRjelNjMWdsS1lJ?=
 =?utf-8?B?VFBPYmthZjljakxkZStSLzNYYi9RQlVCdjRTY0gwelllbjYxL2NxQy90ZHBa?=
 =?utf-8?B?c1NlVUZ1NWE5YzZxRjhSUWZqWTd5RlFjZnJuNnNvalhOWU1VZC9mYVF0UDJB?=
 =?utf-8?B?d08rQU5uRGFFSXl2S2duQ0FnMEVEeHU3RzYyUThWUGJWMmlZcU4wNzFNcHNE?=
 =?utf-8?B?WTRkYzdDWWVySVcrMzNXbWpDYkQ3YzUzNVBieFh3aVFuUkpqMjFBczFmMzV6?=
 =?utf-8?B?WGFsdEhHT2pYaUhBdDlLUmJVY1QrZFIzZ2MxVmVrNExMV0lMa1g0cFNWaHQz?=
 =?utf-8?B?cXBnMWo2TE9sdERjWjh1TTRnYjVjWkRiallVYVpadHpGbitxRnNSWGR4Z1Fp?=
 =?utf-8?B?K3lvMDRiLzNoNTJQUmFtR2s4ZmVwaFVHaGFhQzZqT1JDM25wZ3cyak1xUzh3?=
 =?utf-8?B?dGppNnFNSWNUQm1pM2ZrZVBkbEhIWUx3Qi80eSt2ejRRS3ZBZXVUTklvR2Y5?=
 =?utf-8?B?NUNhOHhZSWkwNWN4VldBcHM3Qkl4UktXL0d3dUFFVHVjOFpiZnpBbTVnZ0Mx?=
 =?utf-8?B?dERWVFRBeVBBaFk3aEw0WnhZdVhycDlFaW9VbVMzWFFOWk8zWUxsYTV3cVJP?=
 =?utf-8?B?NlB5YzFTRGNJT0ZPNWZuMk15bk11ZlFqVjJmZFBianJuSUNUNFo5dXBGc0lN?=
 =?utf-8?B?REpSL3RHQnYya3VjY3M4WVpaZ0lTVkNaSTQ5SWZ3Rys4a21MNzVuUUNlTHlF?=
 =?utf-8?B?cUdIcHV3OWJYWTZjYjcrSFRYYmVhbENjaEVuOE0xY0pVY1B5WDlBWXJ0ZHBh?=
 =?utf-8?B?c1BIY3RPVkIxMDJydjFITFVyNE5pUmdsN2JBb3hoNm9WQ0ZWZEhPSTU3aEFC?=
 =?utf-8?B?TmZLWVhEc3Z2TVI4b1QyQTVtVDR6WVYzQ2pLa2dvelRWU3ZKbXBPWUNkbk42?=
 =?utf-8?B?MGxVTmpONmM5NWhqd3RpL3ZzRmxFbCt1SHpTVXV1dGFvUWxVdlBjV2RJS2E2?=
 =?utf-8?B?OGFBN1hwK01RclB4QUlOY1FONE5OdkpId3BQeUVBSE5vM29hdm02YWJmSHJa?=
 =?utf-8?B?NTJ4R3JhQnhWSlV2djRuTkFST3pRelFvWmNicWdWTXNicTRwMzNKZWhVMlVw?=
 =?utf-8?B?cUE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c54e53ac-2e94-406d-acdd-08db2a034a7e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:56:22.8953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VepGsg+Bu2LWel9GI9YgrEn8ERsTaZaunYGmulB81g0z3FLzhh3PR5sqcBc26LxWcjspOz+jT8YSGIKxijSasg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8273
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/03/2023 14:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra.

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Due to infrastructure issues, no test report available, but all tests 
are passing.

Jon
-- 
nvpublic
