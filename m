Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541E960B4DA
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiJXSFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbiJXSFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:05:10 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24D31C209C;
        Mon, 24 Oct 2022 09:46:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEXehP5Qi1/YrfGwzVjfMNOlI1whfNRT42B4q5D5phf2iV4ODiGfET61xkoUAN2dhwqumFN6bga2tRN0mq+Eg+s+nqnxE37F1CjVxJJDr6CNtSLu2Cgw+AO8tWuD9s3y8L4L53Je0ud4wL1YBWc5iZOg9G8QI85rCs4Fytx6H9ZMoHGAZaDo3jjW1bElXy4C7QT2L5dqzt+Denk7zxCwzwwsRHuOK3Uo/RFY7r4oX+BkdI0btFKKPtLiIeH1ibC+G6basSeg/GGuw0czfTQ7nSxGa29URLsLbdyW7gXMjCp60tOulFR/TtHvOjm6JhbGVhSIi4XlWYcEPxYMpiK0vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0uRw1gaHMUm2sNcbhkrONBjsktauRfDTHW6sMUigR8=;
 b=Wup565WlBmzTBfgJ9ziqOSfV8Fn+1YAE2gmHCVaKj/hIb2uVeg19Otwnlw96d1Kbgqi/rU6PHcf8cSrSvtp3OZTLe4hI2iRpgWithUZJlcnj/C1yWtWsVqeS+7c6j+6bal8cGY+YNbFCW67NIP85J5qpinKS2dfdIeaoj9PAH7Uu3i9rVm9Mh1HGH365Ansh1kzBLOpywc+8BUBDTGKIPNRQi4AEDzNjydIDtmT6L/QaZpSsX1CsolD6cSX7G/GSI8T6rI74QBJJN+aohhRs8/eQMsQ4LonFBh3BBM0soVsQcKyXCtoCHJ+SRvTXoRo6FPu+K5axCxGwA1pzHpkXPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0uRw1gaHMUm2sNcbhkrONBjsktauRfDTHW6sMUigR8=;
 b=ut5JpsTo/aQ1UxVMYSLYFPS5W+bz62JHhSwjZBQMRO7ZN+bhA/op2wjhyaVNpq6WIkA3sUybcfCTD99ZV8WWEGmGOUWU2AGRLxScpHrvkwD5RpOR2EqKr34Uzv59zYMwtEhu2Uv+zLiJCvulDJd87B8Xm0aSHU2amKv8xSeSOuGiWi23CCs0liuq/SO+FeQU0kjb6WTz1kJInhzvVhJlLdwVliWmTmJIf8WpyQHEaZVjZ96mQALdibzw+BbZB3stqMhexekgggBOAseSwa6mMU1ucTqLdrr5VUwkrIF7lsSkVNUgMpD4wfDzQoxe6Nds/543f2yOQxQKPGpek4Gpww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DM6PR12MB4331.namprd12.prod.outlook.com (2603:10b6:5:21a::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.31; Mon, 24 Oct 2022 16:41:22 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66%6]) with mapi id 15.20.5746.023; Mon, 24 Oct 2022
 16:41:22 +0000
Message-ID: <b06e8bba-b1e8-b857-31fa-0edba34dedd1@nvidia.com>
Date:   Mon, 24 Oct 2022 17:41:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.19 000/717] 5.19.17-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20221022072415.034382448@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::31) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|DM6PR12MB4331:EE_
X-MS-Office365-Filtering-Correlation-Id: 6af019c5-3a86-45a9-fbe1-08dab5de958f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dIasdNwm2xRp8JaFIGzB2v+ISTr/JoSfHatz6U9Z8jFU7Ta2Y1o3dmnOF/oLJBGtfUEEunLv5CLtUci2MLTh+8FUqFQV9W46+8J8LcuPwS3zpQRkqk09iVqtkD0JaSddogP37ipVEJYthCO7nS4EmTWuh/66wkzHMP0d9pcL2bQTX+o9wLU6OSkYa/cFw02Plb9VyPNMWM5HdcSnd+g0ACTH1MAC19zqDUMm+6hZk+mjJm5n1A/00bBXeOsw9dLUa/dsDBEmV+wem/8JjPAtuqhYiDpqj/1xOcOqhyuBWEjOqueiaHO0YM5wr04e0lVd/2RYHi7zZcL8jN+9BvO1fzysubaTYvaJnFJApIoD0rif4XkUJS/ChdKI5EolEaNI2ZjC9WvODP5A8aaS3Jdw6XuVs++MmI33zjqwu4+EpcHejaZvRwkvWlizFxjqcJxcngzprASbIfkQLEqm6+iqXlSrtYrbafQ/gxhZAK0MiJyEC3hOIIWO/p+bb8z/g0TB475VGhMnG0tPS3yLTl1wwbK9sXIcazyJQfJFhEJ65A6C4AH6GgETP13sxNBfbZcox4vepx9cVy32kwB/dttCmxxpNG1ixEioe4GsJO39kXIyjIf6RseDqw8RK2BfHi7c1Szs3QU5FLsgFYDPdt98LmWyMWo/wZEFCjb6742M98Ir36OZT6Bxz0yoGa0+bbFbn6EDyjUruSzvFh7Ku56TtdBH4lEwkK3pRZnZ/tvROhb0osPt3SpWG5xKs8MiyyNPTQg+n9ILTFgMpHWCooJr8iX5JkwRsC+brDTNAr6ejZX+IU8gfwFv3xpxG4tVbyl42kzzliJhDXo2a6oVmQ84B3dyd/QyJZbsvfK5UAzzrRZQLq3gpngQP/KE5xgtSISS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199015)(53546011)(4326008)(66476007)(66946007)(316002)(6506007)(66556008)(8676002)(186003)(5660300002)(6666004)(2906002)(86362001)(41300700001)(31696002)(8936002)(2616005)(7416002)(36756003)(83380400001)(6512007)(478600001)(6486002)(38100700002)(31686004)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2lvVlJTcS9TdXhEZmpheUpBVXdiVGFBTk1oamtFZ1d0Wjd5eU8wMHlUSVRn?=
 =?utf-8?B?UmVEVjZkZ3krdWZNNTN5S0pmbmphZEg3eXhScjNMaHppa0RHWVg1T3l5RmpW?=
 =?utf-8?B?YkJaOWVCaktKRnIzMDF1bFp6MFhOTUk3dG1peWZvTmwrQ3dtNmN3RHRieVFj?=
 =?utf-8?B?UUhQK3VMVFZ4Mkhkbk5ERW9SMWxCOTFxUzA3anpwRjMyQWZRc2JpVmEzUlhE?=
 =?utf-8?B?T1FBczROUnJ0QnFYbTI5TVV3TjU2N1lUVU02TTl1d2dxUDQ3ajcwV1hRaEhK?=
 =?utf-8?B?YjhUQzMzTHdQbmpFSllnNE1tc3VobjFuYmVtQ1dZdTZuRjMwZjhHM2JoaS9Z?=
 =?utf-8?B?OUZlMFFmWWNZdFAxOTROOUJqRlFxNXZhaWJUeVBiUFdZVkl6MzNHeDlKMVpG?=
 =?utf-8?B?L1o3MUJvSjFYTml3YkQxdnFySHhlVTFyWjlpZy9sWTU4QkVTRWRWbnlwOWRu?=
 =?utf-8?B?c0pmNDZFTURmTmNyeDh3dVRKQ1VyOXdXdGVCOUs4TDdNN09xNFZmQVRmcjJu?=
 =?utf-8?B?eXZWMDlSVlpQcUc1TFh4aU9Cb2xVRFFBR1pyMnNVcDlJeG1xNDlPcFZ4clVU?=
 =?utf-8?B?K1dzaU9yeG12cmFhMUh1cHRKNDZNUCtqRGkrRjVJdld1bWRvN1FzalJXdXpP?=
 =?utf-8?B?QklhN1Q2Zmx1VnZwcHV5czF2ZWx5N2hBK2ZMc1pqOEkrZFFMWUJGNWJVOHVh?=
 =?utf-8?B?RjFRbDlXZnV0c29NUjVaUDZZbDQ4SlluZXBDUmRER3FiQnpnUjd4a2tyeFJ4?=
 =?utf-8?B?RkR1UVVheGdzcjhZNWJSTzBiQVUyOHBNbUZtYy9JV0NXWHZwRkx6Uy9GRTBo?=
 =?utf-8?B?bWhjZjlhTWJrbHlPM2MrNkgzdlRjcGpJSmVyVEhxNVQxZnJON3RoNkVYdFZp?=
 =?utf-8?B?c052bXRybHdQNU92Q3VmZkdSQXNQdk5HZ0gxaXo2dzFQelBLbUl5eGdsQnhI?=
 =?utf-8?B?aVFPMXg2Qm9sSzlFb0toNFNlK1VSeGpld1pCL0lUUS9abkRIMEZtUS9ucE80?=
 =?utf-8?B?KzRObndQeittY3FxNjRpSTVaT1IxV0tYWlFWSnVBVnNIbXErb0luVTNXdkZi?=
 =?utf-8?B?cDBOZHFSMExscXpnVUQ3RGlzbThOdTlzYURjeFp1V0VJZDA3bWlURWhab2R2?=
 =?utf-8?B?b2U5c0lvU2wyWlZkSUpzNUpJYmFNR2FnS3BIM2pZUnpjbFVlTHJCVmRSUlJp?=
 =?utf-8?B?K2pNeUFwbUFaZ3lDcEl4aTFLNlFRc250RnhQU2plMVdZZzV0YVgrMFpoRmNx?=
 =?utf-8?B?ZnQweURVV1ZrYWtBVDZxWDVEUnUrQ3lRTFRhcEtONi9IMllUZmF4MnZpRU5v?=
 =?utf-8?B?c2pQc3d0MUxnTy9lbXovbzdZRjRXSkgwRzNSQTNNZUY2dzZ5b0RYMnlhbzVu?=
 =?utf-8?B?YWh3K3dsWmphS1lDcmxHRlh6bSs4b2NCbXR2aHhJRUczL0h5bkVDenJpZG13?=
 =?utf-8?B?anZGcENwUU9TL25QbGI4ZDJmYzE4UHZ2bEVLY2lSV2c0Q0MzTXJBVVNHVHNX?=
 =?utf-8?B?MGFSdW5xOWUxa1UxK0lnVTA4OGVXczZVc1N6RFBzL3E4dUtSOWtwQ3lLRWVh?=
 =?utf-8?B?OUluUzUyeDk4WGI4UlRXZ3M0MTFXZE1ISjl6QWhycWpZeVpjTmE4UVJnNXFa?=
 =?utf-8?B?NzZCYkFZeE5OeGxhMUxwc1grSjN1TUNscHFSd2VGNDNjZmRNY29JeVNtY2p2?=
 =?utf-8?B?ZklMaDlDMVc3dXU1UHZrUWhvSzV5U2NkZ2pFN3VnV1RHSEhGWFM4QkVrU2dE?=
 =?utf-8?B?UE4rcUFjckUrb29XaVlUbjVhdjlCbnloVGFCMlFsMmVoV0kxanE5RGNIK2Vn?=
 =?utf-8?B?dDJkYmdlNVpsWC9laDd0QzMvZVd3Zy9XRmw2Q0VHbUNXSmE2aWZFcGtEZ0Ey?=
 =?utf-8?B?VWdtWUJlNnlGcEo0MlhGUURyeFRoVkczdXVpVXQrcnVIYm9PeDZpaXdPdXho?=
 =?utf-8?B?aFpNSkFyZGMwc2pLK3ZtMDJoeFBkczNJRHI0VDBuWFJIcm1vaEFKOVc4Y0Za?=
 =?utf-8?B?VDdXYTRyQVRZWHhVODhmVUZBeVp2V0Z5L0MvRFZPOHV1ek82eXVDcFArcDVk?=
 =?utf-8?B?WFNSQ0NFbktqbE1hUWtxZXMvbWllVzRXN0hSV3EzZFVOamV6N2JFbDl5QXpF?=
 =?utf-8?B?U05QV2doYjdyakZUcjNDK2ZJeC9VVWFwaTJmdEd4Z3JPQVgyV1FlUXcyMWda?=
 =?utf-8?B?cTQyTEhoS1FuNXhxaFMweW9FRDF6R3h5ektBV0lTTUg5TXZjSFRwQ0ZjM2I0?=
 =?utf-8?B?dW1VMzNyNE8zREFkSzBTTlhBWllBPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af019c5-3a86-45a9-fbe1-08dab5de958f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:41:22.5923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8z/g8/dsToTY8elxUjFcfxk7w1fEzsvM5OtnIOnBAs9bV+DVIkV3wHEh5jWVCXKliQMfN0tkeXYjDiCrqN6NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4331
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/10/2022 08:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.17 release.
> There are 717 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Note, this will be the LAST 5.19.y kernel to be released.  Please move
> to the 6.0.y kernel branch at this point in time, as after this is
> released, this branch will be end-of-life.
> 
> Responses should be made by Mon, 24 Oct 2022 07:19:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.17-rc1.gz
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

Linux version:	5.19.17-g2b525314c7b5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra210-p3450-0000: devices

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic
