Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C3755403F
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 03:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243534AbiFVBwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 21:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiFVBwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 21:52:06 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AEB2C137;
        Tue, 21 Jun 2022 18:52:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A75i6YFrTfX/4kB+CvKGyYCI61LjEuy3Aa5kp7Jvuj6UdYU5R9NZ+HuDOoNDXnaYLl6zkBF8MAwF8EaQAog2lJbWzDjxFBE9gFc7iUo7D1sqB46GklvEERzAzC2r8W2wovHRv8ZjhkHVs+Cs6FzmAc7eGqnPByZphnxQXigUx+ndCaIniWMJnMMImdxrkAfMjxHmMAqpac53nFT5HafTouvWS7OgUnjV+n/j85KnfWKZbevbqYtfh7ejJL/OU0Wdkkm9As/Tz4juStbeUAAJZwhxHH/VChFrbkJuglZK3ZyDkoUbqRAxM0jy1ofH8HRhnp7gGmZ1GXomFnvqWp+Xeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzMREohOH+yLkQFqpl2z1G4si9ZeGOa0FYunVQgMKuI=;
 b=Ro3Sg8mAmkas2tsxM8hvFsqZQKFwcwgoi8jaLeQXaE4MsIBChgVS2B6asp/993RHpsC4llabx8FShVR5df1HErXfXBvwOCKDEgLRj52NtigIR16oCDw/tqHBB/obbbzgj29me3DFaDPfTd2UfQQZYRdX7Fr4dfcVjm7ljy52nZOobBDCYRwnWPeJZ53TdTAGgd5venGSEntTK3z0qgR3e8cDQpVwlxnl12n0jnDYGjXIyN5wQn/QH0f0BRXJpHEZgvFHoTvD7w/Xpt3n9nDDjIsU6mHhDCbQS/Galxts1mbEjlilm6p7cbEEE0zeXx6PJRrKauX49NtC0QuEY0z9Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzMREohOH+yLkQFqpl2z1G4si9ZeGOa0FYunVQgMKuI=;
 b=t3vnaEwLdH/TXSGRYFTYT1pZMbxzfMoUfIA+ca7aMLhJhBGLxy6uLLNO28t5nzmYWTCiEQBlKkYQtWRjLqq4DU6ImBZUF3xDIrWlpucroHR3L3YTdTE/rNGP1bh316JgmoM/MBQkrcQtEG9RJgO0ZqGfrjOHz0Rh0G4Z6I3zIS7xNkRjHz2uXTvTnw7vpC91n7E+tYpKVPduqufXODXFkjpLzrpfqjfqrWU+jJo8Sg6SGuRmOkhtu9rtXQ943pfcv5gMQZgXKYGmOf0jTXCFVuywTuuHUC3ZbbBNe4YPosCNk2OQCAs0lnh/iJhvgOCqB0s5t936P3i7ZaJei+RNIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) by
 DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Wed, 22 Jun 2022 01:52:03 +0000
Received: from DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::c44c:ea8d:1b00:5fdd]) by DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::c44c:ea8d:1b00:5fdd%6]) with mapi id 15.20.5353.017; Wed, 22 Jun 2022
 01:52:03 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, akpm@linux-foundation.org,
        stable@vger.kernel.org, guoren@kernel.org,
        huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15] mm: validate buddy page before using
Date:   Tue, 21 Jun 2022 21:52:00 -0400
X-Mailer: MailMate (1.14r5883)
Message-ID: <BBF61B1C-5D5F-418A-97E2-6BE291B06CDB@nvidia.com>
In-Reply-To: <249cf3e9-4a4f-5258-5d55-6c90f0137496@linux.alibaba.com>
References: <YrBJVAZWOzmDyUN3@kroah.com>
 <35bd7396-f5aa-e154-9495-0a36fc6f6a33@linux.alibaba.com>
 <YrBdKwFHfy9Lr14c@kroah.com>
 <8b16a502-5ad5-1efb-0d84-ed0a8ae63c0e@linux.alibaba.com>
 <YrBi1evI1/BF/WLV@kroah.com>
 <d52e17da-a382-0028-2b16-105ab7053028@linux.alibaba.com>
 <YrBnE6Q1pijgE3gR@kroah.com>
 <3371C275-E45D-445F-838E-D43C60BCD750@nvidia.com>
 <YrBuEvLX/ENMx6Zj@kroah.com>
 <62DC5603-F88E-40A3-A4AD-EEFA7027C399@nvidia.com>
 <YrDZL+h86q7iOGWq@kroah.com>
 <249cf3e9-4a4f-5258-5d55-6c90f0137496@linux.alibaba.com>
Content-Type: multipart/signed;
 boundary="=_MailMate_0F2474CE-53F0-477C-99A6-BD2CAC13FDD4_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: BL1PR13CA0447.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::32) To DS7PR12MB5744.namprd12.prod.outlook.com
 (2603:10b6:8:73::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d911b1cc-2b1f-433c-d5c2-08da53f1cdc7
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB63096EBBB4AB3FC31A1E1E0FC2B29@DS7PR12MB6309.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 64rxLE//g67Mfaoyfwpbt9Ukq2/MHeLseUZAo3CWSq73mA8tjASsucyP8GQ1g4Irr9lKKSTn30QiSsMFezDWEqiwVcXL0KE5qNRIUVRjvM04DpiCzCEh9q7M0OyIfzRS0NuYSAZY03jLPHcltUGO165CcREX2u5BSuU4GMG/VlnEoROCiTK2BiQYqVAimwctuU/AiB0kFHfjcEwGIZtiDhpyeXVQXYaHerpe1kgJ2DldvC0iOsKucuXzR0uGEgvIV6sT8etq+8a9xltOpBI4jerArp/L6tsPi7mm8mfwN3/bOBIf8PuQRaM+DHdVA1tA7an7LOu4OWNC0+/wmVEFzlUYAX1zY0Cw4EMEeknQWnIRpCMfHgNwfWjIIbkTxewoo8AHj6D3rXKi5K6MZuer/MCKW/cGGkvwI1AqavuZL09j2AHV1u/kf96b8Sxn0pSsj0moTSYjcNQ4D7XqwlMHZejIUS2SGAn6qW78ufzkYtN9Nh6JwFE7GsFy1KWW7iz5w3rNGLSuXwAargU746towrtkgSewZxZq+JOP4Cna/8s+UkMV/XaztbPO/CmDpJrOGgDm/CVHy/Ks95eHYRvYP4DmgsHd9Nsdgwn1x3SUNrsxRzmkKaB21N/e10EAxB7C6yx88rzTIGPBPHntNmyPvJtTZ7iSED8ns6288S0PG7u6CE13B0x3T7FgqpG45jcI6zeEFpb0jSTrhTDIke66jx14AzcYaq5w3w3uDfDoQLHQnuH758odnzi7AnU53QJDriffoyEALMSqgyxQOB0OUdM/RQoQ+wnyBIFGYxt55rFUQbChcLbyzpN+FfFgZl/vxlgBHOZ18B5xT1VfFigIP3pLPZNfotBKLmrfh9Ujqd4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5744.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(66476007)(36756003)(478600001)(2616005)(6916009)(966005)(6512007)(53546011)(66946007)(41300700001)(5660300002)(66556008)(33964004)(316002)(26005)(33656002)(6486002)(4326008)(83380400001)(8936002)(2906002)(235185007)(8676002)(6506007)(15650500001)(7416002)(186003)(21480400003)(38100700002)(86362001)(45980500001)(72826004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDcxYm4xTjRTMGV1dXpjQTdlS0k0OGlmQi9Nd3ZDeXN3aTFYaEtRL09IK0py?=
 =?utf-8?B?ZjdUc1I2eWdQZFZDM3hFeEEzc0N0dmhpT1VuMHhoK0ZxcEExa0Z4aWxxL1dq?=
 =?utf-8?B?OGFEbEdjc0RCY3JaM0N3WG1mSjFFdmdLTHJRbmtISlZwdXNwYXkvOVRrdDZL?=
 =?utf-8?B?K094UUkxcmsxdGppQ0ZEMVVCWU83a1ZabkJDY1FoVlY2K3ZQK1ZmMk81Vmcy?=
 =?utf-8?B?TjRydXViZUFmTkJnY3BpU2JOQ2VLSDE0UG91RytxdGltWThlWFpxNzAyRjFw?=
 =?utf-8?B?WVZHVysxN3JBdVFxWjYzWXhGQko5U1psMTlaMmlDM3dQVG00ZzRzTXRIZXlQ?=
 =?utf-8?B?d1VWSXAydytiRWlLajhnWnlGVHNxUkpUY0x0c3piNVBjRlFxbmRuOG5ZMDRJ?=
 =?utf-8?B?eWFxcTRwc2xFTE1PZHZ1ME4wYjVZNFVhOWllMTRLUDlGUmJTR0l3ZUh4aEpM?=
 =?utf-8?B?S3hPTSsvTllMT0tjRnF3eTh4TDh3UnZPK3Vsc0lxcStiSjR0NUJ5TUpUenZM?=
 =?utf-8?B?QTlUVERoMGd3ZXFUbEs3ZEUzdUNXK2ljcjRMUndTNnR0cUd5WmE1Z3JVQ29m?=
 =?utf-8?B?aTR3MjkxQm53ZGhBWWZnNkN1bzk2MnY2TnN0MDVKTk01VXVTZ0lIMzNuZCt1?=
 =?utf-8?B?L0xEWDJBbkVBUDZZbWVGZlo3TXhtSW4wWHY1L0lPMWQvdGsxaFd5alFQM0tG?=
 =?utf-8?B?bDRPRWhZTTBkUDZITnU3Y2J3TitaTm1tcXhMRmtTUCtiZWxzVlM5NGJvR0ZI?=
 =?utf-8?B?MVRUNXpFMzdkc0kxSW9JMXdvdFlFUEpSWXpFWGp4ZXY1RUZnTXJWL3JpLzBu?=
 =?utf-8?B?VGE0V1FXQzI5YVhyaG0ya0lWbTM5bEpUSUp0bTkyeGxkZjJ1blBUWVM4YVBL?=
 =?utf-8?B?eG5YTmFuM0FPelFWOHJZWkhQdUd3S3Iwd1l4d0tpK3RhZENVWnlFYjEyN2RI?=
 =?utf-8?B?MS9TeEdQcWg2Z3FTYlFzUnUyU1NZWWFLd0NlVWFPSGtLanB5bzNFd1FGR2FU?=
 =?utf-8?B?U3B0M2pjdXhnVzY5enZ5YkpTWG1qY3pjSGVrN2Ivc001clZlcm84VThTQ21E?=
 =?utf-8?B?eFFYaUpCakNqZTNHc3FOM0dQQnNnK2dsY0RzRVFidXNZdFFGQ0oydjUrM3BZ?=
 =?utf-8?B?Znh2WXJYSmNuQnpNUU1tYTQzQnY0cVZ3ckpBZkt4Sm9meTlVVmNiZHdQYVh0?=
 =?utf-8?B?TStzUFdyUGM0RElEZmpMUkRkTzhaeDFNU0ZiYmNSWWdYN1pLVERseDVBU3NL?=
 =?utf-8?B?QlNmdkoyaHpOZ0RLUTArclcyd2dhNkd0dWR6eGJHWW53Z0kyS2hDS091ZDBW?=
 =?utf-8?B?RWxXaHhtVEVzc3pnNXNlQ0ZINGNERkhGdzg4TTNUOHZ0QSt5dHRVY2ZyVS93?=
 =?utf-8?B?NTFucW9MY2IvcXZkZjFkK1RoTC91aUNYRWRXM3ZxNTBiSkhrNjgyVU91Z0ll?=
 =?utf-8?B?NzBVSGcwSDV5WDZJTVgrVHZjVG1oQllycmF4UEc1MlNrYXJTTmh0djRXeVdm?=
 =?utf-8?B?MVcvRkZlU0VkYytRUS8zSXlVSXNnZWdCRlh6YTRMV0RYM3JseDJtait4S3Vt?=
 =?utf-8?B?bW5DR0JaQWxuY05lVlduQzg5RzQyOTFZblFvbTlJdlE3SlBVWkVIMk5ncFR0?=
 =?utf-8?B?Y0Rycmh2SEttVXhvTzlEUFJXSW14andCOFdwcGMyeXRFSGpyU3BBbVkwN0sr?=
 =?utf-8?B?UWtkK0hEK0ZySWNVOVhESVJsZW5MYnhNdTFZUW4rZkVqOTNUdmRyVkFyZkRX?=
 =?utf-8?B?K2lyWnJvcDVtODFyR3VPME1WZWN4WVNaM2lUQlEzc1QzOFdPdHZOd1dHL2dt?=
 =?utf-8?B?MjQ4WU94eHJLRXhZQUl2UUgrV2VyeXZwaWxteDd5ZjhzcTFwVVNKNG02VFFE?=
 =?utf-8?B?RjFubG1hdzA0RVdGZWVCVTQ4R2dkSnhXNDFUQzVsNU1lemkweGJzR3Jqb1FB?=
 =?utf-8?B?STluY1Zya01iQUZWc3VHd0k4bTlMMkkrTEI2QUJhdjNuamlZMGRhRktSRTI1?=
 =?utf-8?B?WHZOY0xJL2hIWWhXNU5sUWZpRk00WXp5RitlOWU2cVhxL3ZaaFFwdFByYkFl?=
 =?utf-8?B?RFpDbDNPWkxXRk0rMXpJSmYvaktpZmpTRk1IWGNVSUh6STNzYTkyVjBtc3Ex?=
 =?utf-8?B?Q2RHRituaVFtVm1xeGVmL1pFem1yYloreEtKK1dnbnl3TmVIbnlteHhVb2xr?=
 =?utf-8?B?RVRmRXQzN0VvaU90SkxNM25KeTE5OGJ2em5WRHRmQUMyZ1Nwc3dKMmtBa3NK?=
 =?utf-8?B?TVlla3VoRUZma2MvSnpUZEdPNjZUc2ZPU1c5ZWRmRDlWVkZoeisrUTdrQ3Br?=
 =?utf-8?B?eFJuQkpCbTFrUDZsZXR3bTZKcFNKU0kvZTFpVitkZXY2SmdKZzZ0QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d911b1cc-2b1f-433c-d5c2-08da53f1cdc7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5744.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 01:52:03.2089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O70WYwDORfLbKMo5CO45HJI/QM13aEWnLoiZJHOK46M8kLNR4nwyeGINMPEbgPnY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6309
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_0F2474CE-53F0-477C-99A6-BD2CAC13FDD4_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 21 Jun 2022, at 21:37, Xianting Tian wrote:

> =E5=9C=A8 2022/6/21 =E4=B8=8A=E5=8D=884:31, Greg KH =E5=86=99=E9=81=93:=

>> On Mon, Jun 20, 2022 at 10:13:59AM -0400, Zi Yan wrote:
>>> On 20 Jun 2022, at 8:54, Greg KH wrote:
>>>
>>>> On Mon, Jun 20, 2022 at 08:45:13AM -0400, Zi Yan wrote:
>>>>> On 20 Jun 2022, at 8:24, Greg KH wrote:
>>>>>
>>>>>> On Mon, Jun 20, 2022 at 08:18:40PM +0800, Xianting Tian wrote:
>>>>>>> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=888:06, Greg KH =E5=86=99=E9=81=
=93:
>>>>>>>> On Mon, Jun 20, 2022 at 07:57:05PM +0800, Xianting Tian wrote:
>>>>>>>>> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=887:42, Greg KH =E5=86=99=E9=
=81=93:
>>>>>>>>>> On Mon, Jun 20, 2022 at 06:54:44PM +0800, Xianting Tian wrote:=

>>>>>>>>>>> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=886:17, Greg KH =E5=86=99=
=E9=81=93:
>>>>>>>>>>>> On Fri, Jun 17, 2022 at 12:17:45AM +0800, Xianting Tian wrot=
e:
>>>>>>>>>>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before=
 check its migratetype.")
>>>>>>>>>>>>> fixes a bug in 1dd214b8f21c and there is a similar bug in d=
9dddbf55667 that
>>>>>>>>>>>>> can be fixed in a similar way too.
>>>>>>>>>>>>>
>>>>>>>>>>>>> In unset_migratetype_isolate(), we also need the fix, so mo=
ve page_is_buddy()
>>>>>>>>>>>>> from mm/page_alloc.c to mm/internal.h
>>>>>>>>>>>>>
>>>>>>>>>>>>> In addition, for RISC-V arch the first 2MB RAM could be res=
erved for opensbi,
>>>>>>>>>>>>> so it would have pfn_base=3D512 and mem_map began with 512t=
h PFN when
>>>>>>>>>>>>> CONFIG_FLATMEM=3Dy.
>>>>>>>>>>>>> But __find_buddy_pfn algorithm thinks the start pfn 0, it c=
ould get 0 pfn or
>>>>>>>>>>>>> less than the pfn_base value. We need page_is_buddy() to ve=
rify the buddy to
>>>>>>>>>>>>> prevent accessing an invalid buddy.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging betwee=
n isolated and other pageblocks")
>>>>>>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>>>>>>> Reported-by: zjb194813@alibaba-inc.com
>>>>>>>>>>>>> Reported-by: tianhu.hh@alibaba-inc.com
>>>>>>>>>>>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.c=
om>
>>>>>>>>>>>>> ---
>>>>>>>>>>>>>      mm/internal.h       | 34 +++++++++++++++++++++++++++++=
+++++
>>>>>>>>>>>>>      mm/page_alloc.c     | 37 +++--------------------------=
--------
>>>>>>>>>>>>>      mm/page_isolation.c |  3 ++-
>>>>>>>>>>>>>      3 files changed, 39 insertions(+), 35 deletions(-)
>>>>>>>>>>>> What is the commit id of this in Linus's tree?
>>>>>>>>>>> It is also this one=EF=BC=8C
>>>>>>>>>>>
>>>>>>>>>>> commit 787af64d05cd528aac9ad16752d11bb1c6061bb9
>>>>>>>>>>> Author: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>> Date:=C2=A0=C2=A0 Wed Mar 30 15:45:43 2022 -0700
>>>>>>>>>>>
>>>>>>>>>>>    =C2=A0=C2=A0=C2=A0 mm: page_alloc: validate buddy before c=
heck its migratetype.
>>>>>>>>>>>
>>>>>>>>>>>    =C2=A0=C2=A0=C2=A0 Whenever a buddy page is found, page_is=
_buddy() should be called to
>>>>>>>>>>>    =C2=A0=C2=A0=C2=A0 check its validity.=C2=A0 Add the missi=
ng check during pageblock merge check.
>>>>>>>>>>>
>>>>>>>>>>>    =C2=A0=C2=A0=C2=A0 Fixes: 1dd214b8f21c ("mm: page_alloc: a=
void merging non-fallbackable
>>>>>>>>>>> pageblocks with others")
>>>>>>>>>>>    =C2=A0=C2=A0=C2=A0 Link:
>>>>>>>>>>> https://lore.kernel.org/all/20220330154208.71aca532@gandalf.l=
ocal.home/
>>>>>>>>>>>    =C2=A0=C2=A0=C2=A0 Reported-and-tested-by: Steven Rostedt =
<rostedt@goodmis.org>
>>>>>>>>>>>    =C2=A0=C2=A0=C2=A0 Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>    =C2=A0=C2=A0=C2=A0 Signed-off-by: Linus Torvalds <torvalds=
@linux-foundation.org>
>>>>>>>>>> This commit looks nothing like what you posted here.
>>>>>>>>>>
>>>>>>>>>> Why the vast difference with no explaination as to why these a=
re so
>>>>>>>>>> different from the other backports you provided here?  Also wh=
y is the
>>>>>>>>>> subject lines changed?
>>>>>>>>> Yes, the changes of 5.15 are not same with others branches, bec=
ause we need
>>>>>>>>> additional fix for 5.15,
>>>>>>>>>
>>>>>>>>> You can check it in the thread:
>>>>>>>>>
>>>>>>>>> https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A5A2-318C74=
8691FC@nvidia.com/ <https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A=
5A2-318C748691FC@nvidia.com/>
>>>>>>>>>
>>>>>>>>> Right. But pfn_valid_within() was removed since 5.15. So your f=
ix is
>>>>>>>>> required for kernels between 5.15 and 5.17 (inclusive).
>>>>>>>> What is "your fix" here?
>>>>>>>>
>>>>>>>> This change differs a lot from what is in Linus's tree now, so t=
his all
>>>>>>>> needs to be resend and fixed up as I mention above if we are goi=
ng to be
>>>>>>>> able to take this.  As-is, it's all not correct so are dropped.
>>>>>>> I think, for branches except 5.15,=C2=A0 you can just backport Zi=
 Yan's commit
>>>>>>> 787af64d05cd in Linus tree. I won't send more patches further,
>>>>>> So just for 5.18?  I am confused.
>>>>>>
>>>>>>> For 5.15, because it need additional fix except commit 787af64d05=
cd,=C2=A0 I will
>>>>>>> send a new patch as your comments.
>>>>>>>
>>>>>>> Is it ok for you?
>>>>>> No, please send fixed up patches for all branches you want them ap=
plied
>>>>>> to as I do not understand what to do here at all, sorry.
>>>>> Hi Greg,
>>>>>
>>>>> The fixes sent by Xianting do not exist in Linus=E2=80=99s tree, si=
nce the bug is
>>>>> fixed by another commit, which was not intended to fix the bug from=
 the commit
>>>>> d9dddbf55667. These fixes only target the stable branches.
>>>> Then that all needs to be documented very very very well as to why w=
e
>>>> can't just take the commit that is in Linus's tree.
>>>>
>>>> Why can't we take that commit instead?
>>> The situation is a little complicated.
>>>
>>> The bug from commit d9dddbf55667 was not discovered back then. The co=
mmit 1dd214b8f21c
>>> was trying to get migratetype merging more rigid and made the bug eas=
y to get
>>> hit, but none of us were aware of that the bug also exists in commit =
d9dddbf55667.
>>> Then the commit 787af64d05cd fixed the bug, but since the original co=
de was
>>> changed by commit 1dd214b8f21c, thus, it does not directly apply to
>>> commit d9dddbf55667. So I do not think it makes sense to use the orig=
inal commits
>>> 1dd214b8f21c and 787af64d05cd, since the former makes a non bug fixin=
g change and
>>> the latter fixes the bug revealed by the former.
>> That is exactly what we want to apply, we almost never want to apply
>> stuff that is not upstream.  When we do apply "custom" patches, they a=
re
>> almost always wrong.  We have a long history of this, please let's jus=
t
>> take the originals please.
>>
>>> As a result, Xianting's patches fix the bug directly, looking more re=
asonable to me.
>> Again, please no, let's take the originals and keep in step with what =
is
>> in Linus's tree which makes maintance and tracking and everything so
>> much easier over time.
> If so, I think we only can backport 787af64d from Linus tree to all sta=
ble branches. Our ultimate purpose is to solve the problem, I think @Zi Y=
an will agree?

=46rom my understanding, Greg wants us to backport commit 1dd214b8f21c an=
d
787af64d05cd. Since you cannot take the original 787af64d05cd, which appl=
ies
to different code than the old kernel code.

In addition, to fix the issue in mm/page_isolation.c, I think
commit bb0e28eb5bc2 and 8170ac4700d2 are also needed to be backported.

--
Best Regards,
Yan, Zi

--=_MailMate_0F2474CE-53F0-477C-99A6-BD2CAC13FDD4_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAmKydcAPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqKSgcQAJ/voZBquCcl7qIfzteFjLh4GbYRgqlEUkWv
SGZ2+bZr7LojzfkP+3IO9gzOXOuKTWWep96YpI+WZuwGGRGK9EslKeB5p8TeBeR7
vOXszhp/qQAqIRtii0KnTYK9VwrLgH0/9G+Ap6MFeRfCGut56qLQgXCdS01qvKdQ
tQZd5Je8HSuuHtjGnZyY2EM6WHgJ3Hqu0mMnKIsJycBjjK5EyjCJvi6LMjDzyCyF
GHlbchXQuZDGZGchysLnLldSu9EHbSFh8z6dR3/C903GW1iNSf1kxkZwYBLFyzC6
tKdXGbGOUbM54lQxieR7GHK0k30HVkrSbmYE6SKezit8D0qm+k/bqY2Vbr9pb7Vq
WzEYPKW2LljTLKY3LDimLoXgIIyJdRS2dm43iq6V110i75FjfJkfleFG4/yX/B9r
AzzmIQXH+eE//tG37Mdnb1UL88H439oWu0H7sP2E5bWIR5BeAqXhLmCUQh6IrXYQ
fXaS+HzDlzyI/P1wdZQHWzIMoX3TfOpqvF54lanpMl1lCBm8H0JVmfxEBCiVJeu/
9xw3CodEMVnDhL3HdJgISmDRWpHEQ1K/C1pUAJKAU2BM15w882F6AGWOYgGXsiub
OskHumpn+2i0gzrbexXqMYs/Kib6hlGPlgSH8MGJIZeLw22htX5e4Zu3Y83WPdHk
p0VrdjYm
=i0FJ
-----END PGP SIGNATURE-----

--=_MailMate_0F2474CE-53F0-477C-99A6-BD2CAC13FDD4_=--
