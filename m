Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83DE551935
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiFTMpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238541AbiFTMpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:45:23 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2072.outbound.protection.outlook.com [40.107.212.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB62DFE3;
        Mon, 20 Jun 2022 05:45:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e11FduOQS5qGwYok1R+U5/9vNyJyznsvWLwi+HO5cglBSzUrvyQUD/kkBD3sH2KujOH403wZyAH+a/MIRMIpdTUVtqJwOlYwMZb7ZO/ngwkWlQDXwvSOOiwDe/nSAprVMiL4Rnh5ZtuGk7KJgzPZ1Khqp4xim5SbyoPDVvrN1A1s8eDGJEbcgede9qnMn89o9LdI5dkcAqIxg27/YhfZsAyG9lEXavsIkuFaNqp1DD4iwVODHKP9QtzcN/3qCRGKRH4S8EIlvBEqDEcFncAq1WfNysIyMRNojDmEWG4/U9wneT7k/XhnQxxLWJOoMy3KVCj9L1FoRQHuaOzVJ5ersw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+jSwt+1nRnARCEbsafIHPacCLj1uYul/uP/Rk2hqJo8=;
 b=S44oiZE2Yb/ORN36XjNCN8/KYhCwHTNVNvyCi93EISz+1x+SRwcjn8tm3eQrWR0+u5uYjTkYAZNi3thkkU1fO/VP/c9344vKIebk4eaNdoVqifq5JrlK8I2Fc+sj5i9Fs2Db281wc8LBhJuSkIqaJPLbb+CN7l+DMWhIDwVPq4zikPQgqaxm/FdmNo/PKhuPririE8rEkqJXQuxtEhHDWjPKWQHNQ75l8/8m7FJ/u89Yxuv+NL0QrtEn60+2uUn3uGXOs8H5xiU1IxbArkPZWLZEzLRDVIsk4m6siXGClxG3Q/nk+ermpXsu5JorCpETnIzZPzElhIb14Gmiz0du2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+jSwt+1nRnARCEbsafIHPacCLj1uYul/uP/Rk2hqJo8=;
 b=l/BZCgcchlqGpLjkTPuku7UieVACb0kXJUWl1SzoJBulNVmRDsY1r4iQepwC/cb+oDY/a+hOmoWwhYyi7U7ZP/SYKy3zacVVVyIpvt7VumQ+9ugj7f3bAHlZzYAcPhJCD9910cGgf8itRVplEFBrr8bolVwLfipxDoOsCvmrgaqOHkCFZif8JQOkSzVSVA6+atLzyoEt2tLRNWwoDIdK0plLCDT6SK/fEWq0MjGeXXu+L65xZwNDdW1TGZaJI6qa0sfeT7B1JL0Z+hTYfv1qR5JNfHrDLjotjZlIMS+hlgru6XZNLiIbFjnC/43naWn5ZsYTAIoAYIzeF/H5CrZiYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) by
 MN2PR12MB3712.namprd12.prod.outlook.com (2603:10b6:208:164::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Mon, 20 Jun
 2022 12:45:16 +0000
Received: from DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::c44c:ea8d:1b00:5fdd]) by DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::c44c:ea8d:1b00:5fdd%6]) with mapi id 15.20.5353.017; Mon, 20 Jun 2022
 12:45:16 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        guoren@kernel.org, huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15] mm: validate buddy page before using
Date:   Mon, 20 Jun 2022 08:45:13 -0400
X-Mailer: MailMate (1.14r5883)
Message-ID: <3371C275-E45D-445F-838E-D43C60BCD750@nvidia.com>
In-Reply-To: <YrBnE6Q1pijgE3gR@kroah.com>
References: <20220616161746.3565225-1-xianting.tian@linux.alibaba.com>
 <20220616161746.3565225-6-xianting.tian@linux.alibaba.com>
 <YrBJVAZWOzmDyUN3@kroah.com>
 <35bd7396-f5aa-e154-9495-0a36fc6f6a33@linux.alibaba.com>
 <YrBdKwFHfy9Lr14c@kroah.com>
 <8b16a502-5ad5-1efb-0d84-ed0a8ae63c0e@linux.alibaba.com>
 <YrBi1evI1/BF/WLV@kroah.com>
 <d52e17da-a382-0028-2b16-105ab7053028@linux.alibaba.com>
 <YrBnE6Q1pijgE3gR@kroah.com>
Content-Type: multipart/signed;
 boundary="=_MailMate_A21F6E8A-6CBA-4ABA-9237-C3DE02B44441_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: BL0PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:208:2d::41) To DS7PR12MB5744.namprd12.prod.outlook.com
 (2603:10b6:8:73::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cbb41d0-a1e0-4871-120b-08da52bab9eb
X-MS-TrafficTypeDiagnostic: MN2PR12MB3712:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB371232B5DA664B24BB23F00CC2B09@MN2PR12MB3712.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtKqkK8pSAckS2xO/dhWmuXMcxqeQG3f5dK2hS4uWnVrX21b6s3NlQ/5XPl/DxwKi5iv6crsshCLEMLL7xq58iFEYHh4pTSNx7ZQS7LCaJns6brh9c19Z4Ou0Ok6iR9C4Ok/O+QMT/SSAU2e+5qqqe9PvN/egwrZ6fniNBCXUuvwt2YozFn7Yv7oJRTStz5Hj6XfW0tYK/UhRU2VdeCLOKm5Og7SKYXVJP7swD+yRF4jp6ZQF+ntI0N4BFAmN/s8JMMMFUAEGdBXjVmkeYwwud7QQq5sqofKNdkoTNwrvysOEe/GNrq5Saja02AlhvLc02IHaKwZjjWVecDnnqNXjqh3RueskOriDKHm7Zi2onNOSSLclfYgPEjVESCT6xxCS/DUi0RZ0E3/pHg4Ea0pDM66xSBJ6HWt1nPBZIHbLYnQ28OMbk5TxH4YTzRN8h+PWwlXG2WSi94eE5F/O6mcbGDRtZ1NZ7nOWJTIPe0k843Dm6BtXaK8icJ7P/gkAX4pe1ashrBrA0Xkq3RlDy/JJCBEKhkFnregOFu8+G7CpvHEIHHfU2C6bPxaXAQ+AUpCZ6c69KjvdW3hwIBLcgZNhqKM6A/5pdSr5tlPPCHPqPcxvLZzZcNcIJ//ML6YD2l2L7vt3UvOdwvFX+mJLwKnMiZmZ//BzhLMwwJyi3n5ckxN9/o6Vc7V48E3Z4blcUD3NOUJ+se5WO/ggd5i5/qi98Bbwo1vpnX6kV98D8w98DyF5WK4yjUOaalwT7RMwdLnb2th/plhSxAAojz8mAYR0feycnEPjyMXkLQwzLKpCFq3pFHLAlIVBfn/A9Jp/Gan7F3okoHM34k8L7XcB1NxgXqs9mu4gcVkNcwD1QbSF+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5744.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(966005)(6486002)(478600001)(316002)(15650500001)(2906002)(36756003)(6916009)(53546011)(6512007)(8936002)(5660300002)(235185007)(7416002)(4326008)(26005)(66946007)(33656002)(41300700001)(2616005)(8676002)(66556008)(66476007)(86362001)(83380400001)(21480400003)(186003)(38100700002)(6666004)(6506007)(33964004)(72826004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHJER2lQNE1JMkFiR1d0WnlBYTJ4WjYweDRLS091Q2NrMVNBdDlrNjJnSnZO?=
 =?utf-8?B?WVFsVExzemlVNE9iaHBSTDZWYWdXQ05XdWt3ZEpaTlFmMHhxN3RLYnhtcUJo?=
 =?utf-8?B?WVZQVGsxNDdPTnRKODFMRjVjQ1lYMXRiVDN3N1hicHVmanFZZVh6Tk1YZHBE?=
 =?utf-8?B?aXdGOWdLdG1FVWx6VjhMVWdGNDVHd1AxVjdVaXRKOUFtWTZ0L2psd3ZweHRx?=
 =?utf-8?B?T0V6NzhVM2ZLdU9HejUzekdMclFJR1pRZCtQZTJOZjcvaTBxVWRXdzMvcTRT?=
 =?utf-8?B?TUJ1dGRNbWxTdk54K25ZVzNTUitpdnppMmNHcEx4Q056dndydG1aUnlSYWlG?=
 =?utf-8?B?eGNIcGNGNmZvRStKMy8yblBxRUloVFpsZzVPQnBkY0RZYnh3ckJhZzZ1cERO?=
 =?utf-8?B?VVBselF0MXQzaWYyMDdWbUR3MW9Ga0JmWmlrYlhkbGl0dzB5d0VjNmFsRjZ2?=
 =?utf-8?B?cms5TWVtb2RTSW1FL0cwbmZDVDZtYXFZamM2dE4rbTRaYXJOa2htbnFXZVpJ?=
 =?utf-8?B?WnpETUhyUGJzUjBVOWIzNkQ4TDJ2bjRwUkZRZE9vMEpkQlNBcGhYN3lSTVZo?=
 =?utf-8?B?TTFPMGpDbGhmakFJdGNGbnJTNnhkeFE0bzJsYXJYUWRyUlZURE5lTUJ3V2lH?=
 =?utf-8?B?VzJhMzAxRnExWFhhMVNXaXo3OFBNUG1VaWdMS3BRSmgwTmhqZXBkSFNnUWJL?=
 =?utf-8?B?dGUxQUgrd3RXaHJRaGtrVnAyWE5jbm5Dc3NvRWFzVExOZUZZenJHZzhqZUoz?=
 =?utf-8?B?cUtXUFA4T1AzdzlLQUZueisrZHhKNkVndXBqRUprSGp1bDRvdW16SlZBNmJ1?=
 =?utf-8?B?MnMwUFlIUDByV1diajY4SE9WVC8vS2hzZDNMZFNMOHFuRUZ4bnBUSGxienBE?=
 =?utf-8?B?RlRvV2krbGVoVlJWTWpKL00yQ1JyNWpXaElDSGRWdEVZUEhKK0ZwZzBjM0hR?=
 =?utf-8?B?NmpkUTRydDFxNDJta1ZacVBLTnRBRHI3SWYwcHF5YTZXdjN3d2xkeVhOL3NS?=
 =?utf-8?B?WEMyRXlJTE8weTFrbm9EQkRMRHVDY2hmOGFkTnh1VFRwVHdKUC9WTjZCd1ZT?=
 =?utf-8?B?VTNVUXpvMDJKb2t5dTRVSTVOVGJ6SDlxWWZxdWthQVMreHNTN2ZWWnl5RUk4?=
 =?utf-8?B?K09yRjhKL3VFNyswK1c3Vlp2QXNFbllHRlJSdVp6bkkySTZNUG5ZUHpoem04?=
 =?utf-8?B?SFdiWjA0U045dm9GdEhzclFDV0JqTENUYklKVHIyVHZ1eFdDaEV2YjNxY3BN?=
 =?utf-8?B?TTlNVm5LQWJ2VXpFT3dHVWl2RmZpem0vM25TR0txZmh1dUFZQ1EyUkVoeHRo?=
 =?utf-8?B?bnpBaWlLNkpLc2RvWUpYSHYreUdqbU44b0JjUWNNMUtlRmJ5bFhwbTJuQ1FJ?=
 =?utf-8?B?Vng4SlBqY3BsWTJqSHVValYvbUdCdVE4SitLUnp3Wk9pMVZBay9TUjRRdFMr?=
 =?utf-8?B?UE92WGZOZTdZd3ovSW9YS1VZL3hlRmlvdjZhMHl1K0pwd2RzZExURUxHZ0Fs?=
 =?utf-8?B?SjFvWW15dHdYcnhNMXJPYlA3V25KUWs5R1I4R3V2Rm1UK2d5djlpZkJHM2lz?=
 =?utf-8?B?bzBIVTc5aEdwT0lYK3M2MkZvc213UlJLMy9Yc2NIOE1QdDhpSHQxT3FZVVV0?=
 =?utf-8?B?d2p4a1QrNHRVTjJCRkFoeTY3bGRVUVZLem1uMGkzRXJLa1FFSm1ZOGZ1ZDdW?=
 =?utf-8?B?Z0d2dHNzNk9MNkFrTFZYRDZtT01PV1pRMXFBY2MwcUY4bWNCUTRIZlVVbno3?=
 =?utf-8?B?QmFiNWhqTmRCTE5TN3JiVFRWSU0rTDRwM3pTcU9UNlkrNk1yUXQ1RUh1eGFX?=
 =?utf-8?B?UVN0bWwza1NVdzdTRmRTMlFzWlVoek1VWDRyaHlNVFN3d2E1Q1lUam5WdzJw?=
 =?utf-8?B?QUtHMkxnaFVhUkZPU0lvelBBQTVmMjgwTEwrYWZUUlFsZ0U0YXRsN1dUOGFC?=
 =?utf-8?B?dHB0ZGZMemlBVHA5WG40Z1llcjlSWSthOGYvSjV6WHE3SGZOSnBMZ1dvTkFv?=
 =?utf-8?B?MEo4YlcwM2o3NnZTUkswTWZWRWxacmRqbDZEYzNwdkQ0L0ZzeUNEaFd2d0Iw?=
 =?utf-8?B?Znkzd1paUEluM2tNQjdzQU5SbkxzK1ZiVFVhdDVOV0dyVlIzSDNvaXVaK3Zu?=
 =?utf-8?B?MWxwUzQ5ZE0wYWQ1YS9uVTdDRE5vRHZodWRpTzRWNTZFZ1BzZUpRenQzNzJE?=
 =?utf-8?B?N21acXFhREtXcnF5M0FseUUyQzY5dlJ0S3kvV1VkKytPd3d1TmRXbTExYTB3?=
 =?utf-8?B?Wk91UDYva3FoTjRZOCs2Q0g5Nng3ZGpCdUhHbzhmTUprQm1hZXBidnNGT3Y2?=
 =?utf-8?B?Z3N6ZXJ0UEI2dklqdVIzOXBkZ2FjTE84ejVkdFM4VTRDdlNIM1hHUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cbb41d0-a1e0-4871-120b-08da52bab9eb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5744.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 12:45:16.4650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: goIK7J5xwkAzfnYEvq6N7uTrgJudtL7/cUZckoZXAbMkWNuM5TJW5IL2F57+QI27
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3712
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_A21F6E8A-6CBA-4ABA-9237-C3DE02B44441_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 20 Jun 2022, at 8:24, Greg KH wrote:

> On Mon, Jun 20, 2022 at 08:18:40PM +0800, Xianting Tian wrote:
>>
>> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=888:06, Greg KH =E5=86=99=E9=81=93=
:
>>> On Mon, Jun 20, 2022 at 07:57:05PM +0800, Xianting Tian wrote:
>>>> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=887:42, Greg KH =E5=86=99=E9=81=93=
:
>>>>> On Mon, Jun 20, 2022 at 06:54:44PM +0800, Xianting Tian wrote:
>>>>>> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=886:17, Greg KH =E5=86=99=E9=81=
=93:
>>>>>>> On Fri, Jun 17, 2022 at 12:17:45AM +0800, Xianting Tian wrote:
>>>>>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before chec=
k its migratetype.")
>>>>>>>> fixes a bug in 1dd214b8f21c and there is a similar bug in d9dddb=
f55667 that
>>>>>>>> can be fixed in a similar way too.
>>>>>>>>
>>>>>>>> In unset_migratetype_isolate(), we also need the fix, so move pa=
ge_is_buddy()
>>>>>>>> from mm/page_alloc.c to mm/internal.h
>>>>>>>>
>>>>>>>> In addition, for RISC-V arch the first 2MB RAM could be reserved=
 for opensbi,
>>>>>>>> so it would have pfn_base=3D512 and mem_map began with 512th PFN=
 when
>>>>>>>> CONFIG_FLATMEM=3Dy.
>>>>>>>> But __find_buddy_pfn algorithm thinks the start pfn 0, it could =
get 0 pfn or
>>>>>>>> less than the pfn_base value. We need page_is_buddy() to verify =
the buddy to
>>>>>>>> prevent accessing an invalid buddy.
>>>>>>>>
>>>>>>>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between iso=
lated and other pageblocks")
>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>> Reported-by: zjb194813@alibaba-inc.com
>>>>>>>> Reported-by: tianhu.hh@alibaba-inc.com
>>>>>>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>>>>>>>> ---
>>>>>>>>     mm/internal.h       | 34 ++++++++++++++++++++++++++++++++++
>>>>>>>>     mm/page_alloc.c     | 37 +++--------------------------------=
--
>>>>>>>>     mm/page_isolation.c |  3 ++-
>>>>>>>>     3 files changed, 39 insertions(+), 35 deletions(-)
>>>>>>> What is the commit id of this in Linus's tree?
>>>>>> It is also this one=EF=BC=8C
>>>>>>
>>>>>> commit 787af64d05cd528aac9ad16752d11bb1c6061bb9
>>>>>> Author: Zi Yan <ziy@nvidia.com>
>>>>>> Date:=C2=A0=C2=A0 Wed Mar 30 15:45:43 2022 -0700
>>>>>>
>>>>>>   =C2=A0=C2=A0=C2=A0 mm: page_alloc: validate buddy before check i=
ts migratetype.
>>>>>>
>>>>>>   =C2=A0=C2=A0=C2=A0 Whenever a buddy page is found, page_is_buddy=
() should be called to
>>>>>>   =C2=A0=C2=A0=C2=A0 check its validity.=C2=A0 Add the missing che=
ck during pageblock merge check.
>>>>>>
>>>>>>   =C2=A0=C2=A0=C2=A0 Fixes: 1dd214b8f21c ("mm: page_alloc: avoid m=
erging non-fallbackable
>>>>>> pageblocks with others")
>>>>>>   =C2=A0=C2=A0=C2=A0 Link:
>>>>>> https://lore.kernel.org/all/20220330154208.71aca532@gandalf.local.=
home/
>>>>>>   =C2=A0=C2=A0=C2=A0 Reported-and-tested-by: Steven Rostedt <roste=
dt@goodmis.org>
>>>>>>   =C2=A0=C2=A0=C2=A0 Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>>   =C2=A0=C2=A0=C2=A0 Signed-off-by: Linus Torvalds <torvalds@linux=
-foundation.org>
>>>>> This commit looks nothing like what you posted here.
>>>>>
>>>>> Why the vast difference with no explaination as to why these are so=

>>>>> different from the other backports you provided here?  Also why is =
the
>>>>> subject lines changed?
>>>> Yes, the changes of 5.15 are not same with others branches, because =
we need
>>>> additional fix for 5.15,
>>>>
>>>> You can check it in the thread:
>>>>
>>>> https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A5A2-318C748691F=
C@nvidia.com/ <https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A5A2-3=
18C748691FC@nvidia.com/>
>>>>
>>>> Right. But pfn_valid_within() was removed since 5.15. So your fix is=

>>>> required for kernels between 5.15 and 5.17 (inclusive).
>>> What is "your fix" here?
>>>
>>> This change differs a lot from what is in Linus's tree now, so this a=
ll
>>> needs to be resend and fixed up as I mention above if we are going to=
 be
>>> able to take this.  As-is, it's all not correct so are dropped.
>>
>> I think, for branches except 5.15,=C2=A0 you can just backport Zi Yan'=
s commit
>> 787af64d05cd in Linus tree. I won't send more patches further,
>
> So just for 5.18?  I am confused.
>
>> For 5.15, because it need additional fix except commit 787af64d05cd,=C2=
=A0 I will
>> send a new patch as your comments.
>>
>> Is it ok for you?
>
> No, please send fixed up patches for all branches you want them applied=

> to as I do not understand what to do here at all, sorry.

Hi Greg,

The fixes sent by Xianting do not exist in Linus=E2=80=99s tree, since th=
e bug is
fixed by another commit, which was not intended to fix the bug from the c=
ommit
d9dddbf55667. These fixes only target the stable branches.

--
Best Regards,
Yan, Zi

--=_MailMate_A21F6E8A-6CBA-4ABA-9237-C3DE02B44441_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAmKwa9kPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqKhHAP/A2/pC6MPPHy67na84zxze/KPEUeSjea+lLs
Qq70EupeqTBLbzh7wwxuWMTGL2m24KWfqMawzG+uO5tr1WFza4Liwau8El2+eGvM
M7IHnxIQo1l5hKbhtZZp3rkuT8EuenMu+8FjG9/rbJCpWUdplw4pwNhT/okKqzCD
f6ayNFZvY4I1i5e5vReUCvRjNE8W97aFWsS+oVGrbKTqMpdhNTgeOF0PqgZkXeCr
BEpnn9SpXqzvxsUZhPJgfs/3lsWAEnBNQ0am+jNptwNN/gTN1kLUHvbJJBQW807Y
77NWdyQdOltc9yPY7BpEQHxoyFZst2XAyacRvOYjfot9Uqezat8KhWJTl5zr6Pmu
VrCEcrSUpLGRq7mYG50Yj9BNrIrQvyQqQcQVhzhm2c4deCFFwOBxeAsHqi4y2pPH
udRG9A+9zTpppAk2VI6H9nUxsg+P86nGatwIDjCDF/c5Q4j6KEYJ5C7bFl88UEly
buxxbSx+qDH6TKgs05fBcCuIoRvMmofD6qQVIjZWKx3cZGTdPNPQw54mwvBLN5Jg
zq+jpQyu2mXJ1CFu71a4XUpgn7Ky/FfrsFpSe5xD7w6T5ZGy/2yJ4TF2sxr0HvGA
SIyJQ8PftR1xPDfcn0uCBrdF1NwQOMNW6hp+7CgNkROT7/Dt30EK+APD/8W1OqH4
hpMYOfqj
=nqbz
-----END PGP SIGNATURE-----

--=_MailMate_A21F6E8A-6CBA-4ABA-9237-C3DE02B44441_=--
