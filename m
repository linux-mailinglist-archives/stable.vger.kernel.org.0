Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0ED551F69
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240472AbiFTO4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240201AbiFTOzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 10:55:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7462408C;
        Mon, 20 Jun 2022 07:14:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhR6GqT7rQed3mzzhcdoov697vPSbLJyTi9QL2bSZlNFbn6v2QFe5MukYTopHU79LsU215057+ZMVTCGLTC/PuNC1CKK+nJonvqHh7mxEq70a9hSW0UZc0lVQRWbcPQOF4tKuoMhU02VnVTRQWTKdBp48RrR1VSwzD3vH4rsGvkV2yR3KM4JnsiVvrJj2NYCRgQxV5YD1W9UDEI4dPgIwuJ4j4PUMu2JWicM81rpoo9AZqxl/UOB5Yd8CRYreLMwDGK3IDMUy3UnliSZON6xwW6vqF6jK6OJ38AzslFIw/AZMkfOW4C6yCk/oBaAVFgqHhJxUYAHBerX5n/BaTpsPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgeDMGCFcyOYdT5+3VrGQK9X7HeDKJZaqSUyJaup9r0=;
 b=leIGdAPwptYJdfde9hJZnVACnKi1cQ6ojMB9QCdxQnYsIOxL2P9Pd40Y4ss0tADQV15/LQmrIV1gcWx5Grob3Fv/KCZFCtPKQKQ53UKj8rrgdDo4ydYdfYrD+mkC+vM6nHNE0In5F7tg2X72LU2Fya7P4IRvsxfZCO0PMA6MonqafOi5CXc4s44sJEMRSocF+L7Dm7P4Su6iS+muoMTmMb+7mCfRsx7OCLcxudYByMc8aCUA35bVdiKSiFNZgOLpg5/Cp7yGIDKonOvAQKTaBngcKjsZAJ5hNkStthZ4SzJeDU4k3JngnI8rOMUrk47kB6TxngIOlLYTpg89xnPQ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgeDMGCFcyOYdT5+3VrGQK9X7HeDKJZaqSUyJaup9r0=;
 b=oKdQlnq7ZrobU43c+yRcbVbybcY/SxmwgvsTThVJ8rcRtRtEYlQewFECwKapchSdO9xsZiBqDftif8ojE4AeReZiEPV5IRbLNHfDJM1E9ek89WNuscZUFBYghS6WUPW1daFmmqec7Abbl6ziG5qctWs/1Gim7TIWD+jOa5zyK+oaXt1SCHiMkkNdNQCnyJKmaIzjNQSrZvz94pL/iu87zos1pAU2R33dpmZ/N3ZKAI+76XpKzD+ELzLKh3Fsl/dQugsSifUqUm84dyZ1+52XrouHKXKIokzZJAVUQUslf+6vp4Z/AntmbwkDgpVMKKzvfypcd9tDdUtHTXuxbKufzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) by
 CY4PR12MB1783.namprd12.prod.outlook.com (2603:10b6:903:121::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 14:14:02 +0000
Received: from DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::c44c:ea8d:1b00:5fdd]) by DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::c44c:ea8d:1b00:5fdd%6]) with mapi id 15.20.5353.017; Mon, 20 Jun 2022
 14:14:02 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        guoren@kernel.org, huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15] mm: validate buddy page before using
Date:   Mon, 20 Jun 2022 10:13:59 -0400
X-Mailer: MailMate (1.14r5898)
Message-ID: <62DC5603-F88E-40A3-A4AD-EEFA7027C399@nvidia.com>
In-Reply-To: <YrBuEvLX/ENMx6Zj@kroah.com>
References: <20220616161746.3565225-1-xianting.tian@linux.alibaba.com>
 <20220616161746.3565225-6-xianting.tian@linux.alibaba.com>
 <YrBJVAZWOzmDyUN3@kroah.com>
 <35bd7396-f5aa-e154-9495-0a36fc6f6a33@linux.alibaba.com>
 <YrBdKwFHfy9Lr14c@kroah.com>
 <8b16a502-5ad5-1efb-0d84-ed0a8ae63c0e@linux.alibaba.com>
 <YrBi1evI1/BF/WLV@kroah.com>
 <d52e17da-a382-0028-2b16-105ab7053028@linux.alibaba.com>
 <YrBnE6Q1pijgE3gR@kroah.com>
 <3371C275-E45D-445F-838E-D43C60BCD750@nvidia.com>
 <YrBuEvLX/ENMx6Zj@kroah.com>
Content-Type: multipart/signed;
 boundary="=_MailMate_34E3D0F5-4432-4B1B-9E12-E5D94C5962DF_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: MN2PR15CA0037.namprd15.prod.outlook.com
 (2603:10b6:208:237::6) To DS7PR12MB5744.namprd12.prod.outlook.com
 (2603:10b6:8:73::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f9059e0-9289-43e7-a363-08da52c72040
X-MS-TrafficTypeDiagnostic: CY4PR12MB1783:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB17838B0975A684D91A869067C2B09@CY4PR12MB1783.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NMQKFoityxEvI/dO4u5FrzgFg7yATIDx4ED4MLvu8eI9Lu1jWmdmIrE4J+uY7gTBFYxaEgC2anIKa40rwgI9ISI6d3s4ufXEQTzhpRhrFHn7iYBwoStu5TOfz124x0dD36yc2o/83KgyoV/hX8P1HYr6Ij5ueN4P+a9gmncO71QJCZfW0H5tgLa5wNQbq69GooEoE568BunameERlzU6Tm4YHdntU7RL0k/AXdG47rWDa/lGkLtor9rnEn2ffSoTJZprzrm6Yg0AYixa9JAJtPvHlUp0LLO1KgkbVeNuZ6Bvv+snhnop6iCkiTvtqTbMrNLjw4OGxA06I1c6tEWA2br2cl1eYlxJRYqGvjpnlUNr6uN8OV9JD6SRo5JSAERNJvQ+pHd+mEImmKXrVEhVZXjllqoEEsj93co3RiY8XORjpeKzcq9AjpbVUXiyaJpURkK8yFsKrM53oH9LyvA6hMpoynQSkPp7Dvzrdhc6B/bDznndoLjZaiRuqrKEBJYT5ro4LQW42YdUjwnHrh0ToIL1OvGq/5AAoTJxHL1PuvBVZVGuy7/uEKs4JkKmVucqu2EIbqQpx7/h3WzoWAaeeAS9FJorV1rbvMnt1nxLJFx/VVZIZbDrpzaeJpKXphnfupfdCIxXUdFkpg0x0dGZYredgjNL7PGp9ZaKl124RHc+7y9oXA0POe/lpk0xKUI30FvM7kpGJoNoo3v38puEnqSy2NGSERf2JVmUHhwdeU37/E1x4rMDjaV27NZ/jHfVNMZHjto6RLAbdjDjDbizV/5+H8sGOolm81xRJHTMTEu3+68++ozwpKdIBe/RL12zV1fEhILQUrxJAd27K6ec3kUgvwozyzVctel+DVu4aps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5744.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(26005)(6486002)(86362001)(6506007)(235185007)(6512007)(7416002)(316002)(5660300002)(6666004)(66946007)(8676002)(66556008)(38100700002)(478600001)(36756003)(15650500001)(8936002)(4326008)(2616005)(53546011)(2906002)(186003)(21480400003)(33964004)(66476007)(6916009)(966005)(83380400001)(41300700001)(33656002)(45980500001)(72826004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGFCaHdKNlpWQ3dJSWtBL1Zld2x6cEhwZmxMMHNnT1J0OVE5VW0wSTN5a2pN?=
 =?utf-8?B?bm5jTnBFK2NBY3BLQVovTnpmV3JDVS96MEwzWTNpbnFMVWFlZEFpYzNLTUNz?=
 =?utf-8?B?dDVkem1mWXQwY0tBUEFPT05VQ1ZQbHBsbFE1eHh2c1R3SmpwSW5hbTlqcHRQ?=
 =?utf-8?B?d2cyS2RKYjFLN0l5Z1F6YlpDVmZSeU4xRWt1NC94MTJEbUFiOWNtcmw2d083?=
 =?utf-8?B?OWhVaFkwdHdjaVNYazlnRS82RUQ0WVNwdEt4aGxLb2xCZTA1QnB2UjhPaXlP?=
 =?utf-8?B?bDdrcW1YNUsyMzhMY2tXd29CY1hPOVc5Umt6TzFTQkxBWlh5VUowbVk3MHB2?=
 =?utf-8?B?OTc3bE5qV2hhN0NBeGg5a2JldFhwR0trUTl3WVdWUUpscEw0RWM5cDJRYk5K?=
 =?utf-8?B?Tng2WjJhSXQrZUV6bm9nWEpOcWo0TnVwUEZwUE0yejhINU5TNG43a21IYkQ3?=
 =?utf-8?B?N1YrZCtobk5BVThWTG84SEJTdkQzNk5mVVgwN2toQ1NiWnRxM3ZJOGIrK2Fi?=
 =?utf-8?B?OVNQR1RaZ1c5ZU9UZk5oREo1OHpmS1FpVlFwUlZVdm01RUxmTHdFRkJqazYw?=
 =?utf-8?B?RGhBaU1LWnpWdXRwT3BObmUzWWtIRU1wUnZYWGxHWjFPTW9WQkJhUnZWZ3d0?=
 =?utf-8?B?RjE4NHNyaXphN0hacVAxTzRKblR3NmNtQmVnaFRySWlIWlZVT2RkUzdub3gz?=
 =?utf-8?B?NE9wSWtSS25tZVR4MkR0MFZnbUorTlRUTjh2dzZWMVFDVVlaNUdlT0xrM0dQ?=
 =?utf-8?B?K3NleVZwaGtQUTNCY2pPajFYYjFtNnAyS0lSenlCd1U5WGthaUN0ZXJyOGha?=
 =?utf-8?B?SnNIck9qYkRwRVZiR01rVjRtb084azlxWFBPNnVvVW5IcitwZzVQSTNOdVlz?=
 =?utf-8?B?YU9DVFYxR1NJYVZWWU8zdzJ1SFlKZmRXdnlMU0JvQVFnazVGVzcxa1VJN29k?=
 =?utf-8?B?V2FLME1jRDBnVmQ0eXpUcmVTT25UTGUreFN2Qk5yeUg4U0VwVUdUaU45Qnl1?=
 =?utf-8?B?U0srbmI1cmRQMkc5SW15V1VJUjR4eGRBYmt2THRRcndBZEU4QVUraU8xU3dF?=
 =?utf-8?B?NER5c1ZDUXVBNW9kS0RhcTdRTlUyZ2ZzdFFaSEkrQUtuWmNyNlFzZ0ZqR0Uw?=
 =?utf-8?B?T3ZjTkxER21IZUVPeW9VaDFwM3JNZk04VU5tWkFrZE4zcUxJbzRrd3RzQmto?=
 =?utf-8?B?U3BZai84NVY1SHlZbFhHTm1XSTFNR1dkbURaM2xqbm1BNlZ1citpMlZoeHZQ?=
 =?utf-8?B?UWpvWDRIbHUxem9wby9sZ3hZSzBpc0dUK2x4VWZPNzY5S0tsWVppOEZTUnVS?=
 =?utf-8?B?TG5oZ0V5VGtuMFQ4NDcyZUxSbi9WV1BoWE9ZdTRpR3ZiZnY1OVFwbDk5d1NK?=
 =?utf-8?B?YjUrRlJFaTB1V1hTeFNObGFhc1lESks1NnVqOEZGanhuK1hPRnp0YzJWZnZY?=
 =?utf-8?B?dE0vcmgzcTlVS1dqRFo2SmxVNllrZEh6c2UvVklwYVB4VUtTTkh5TjMxcXpD?=
 =?utf-8?B?VW5qclhaekdNdS9nemtXdHFXM1dDUHhtaW5JazhyeFk3RzlUZ1NjVVMvejBa?=
 =?utf-8?B?V0RJQkE5VTBvdkszelBvM1AyUE5tSXhjMVN3VkdJSW9NdmkzaGsxbUFralhL?=
 =?utf-8?B?QkFSVmtaYzFkdExqN094cDdzRlMwYmFQejdMWXR1SlVGRU12VmdNcjIrc2M0?=
 =?utf-8?B?a1JCK0hVTHJLRUVxbzljc2pFcWg3MFVRT1ZJcHh3UUoyVnpoZ3FKNU9uTXpG?=
 =?utf-8?B?L3RQMDdXTzkzbnRnTFhabW5meE9oWHkxS3FTUlUrMld5b3QzTVFLaFNDVlVh?=
 =?utf-8?B?ZnZmTkU0UkpNcnFyVEZIQUlYRG83U1ZwQmJpSHNrRlpBVHJ5UitiaFYvWCtE?=
 =?utf-8?B?dzN5SFVwT2QvOVkvZ0dOWXNEd05hNStkb0R0MlB2RmpocEQrMVYyUnlDNlov?=
 =?utf-8?B?aDA3bWViUUkxTHJITnlUWGwvZUZKUFdKQ0hXNHl6YWp6TG5wWlZadCtZOStY?=
 =?utf-8?B?VSs4SHFyajMvcDRSMGw0MVlwYy9uTCtuRmNrM25nUFlCdU1JNUYzWUQ0eHl6?=
 =?utf-8?B?bjVCSm8zZjNFaXdERml2a1RJdW5yYkRzUGE1N1ovRVlpd3Z4YUpVZEpHa0J3?=
 =?utf-8?B?OEpRc2JuaU1QR1dLNE9HbXNWQ09kZSs0OTRLbHZwUk1iYkFmNXRqejdQaVhq?=
 =?utf-8?B?WVUrRVZVdTVxWmdGR2tzN3B6SU9jS3hSZ0l4b1pmMGU4WXJKTkEyODE4WVJZ?=
 =?utf-8?B?TnN1Tkg5cmRGODNWSVdYTUk5K2VKZW1WSGZZTktNNnliTTF6ZjBrMlVaeUZa?=
 =?utf-8?B?T0phM3ZVaER5OHI2Rno0VnJST0tUeS9GZVFmZVVPVW4yMnNIOHNSdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9059e0-9289-43e7-a363-08da52c72040
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5744.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 14:14:02.0517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWqHqhpXZ5I27jl3QlEAlCVw/fMgp/yfpAQ7/at1Gs/Dypc1T4JFc0T1GzZ5YZKb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1783
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_34E3D0F5-4432-4B1B-9E12-E5D94C5962DF_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 20 Jun 2022, at 8:54, Greg KH wrote:

> On Mon, Jun 20, 2022 at 08:45:13AM -0400, Zi Yan wrote:
>> On 20 Jun 2022, at 8:24, Greg KH wrote:
>>
>>> On Mon, Jun 20, 2022 at 08:18:40PM +0800, Xianting Tian wrote:
>>>>
>>>> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=888:06, Greg KH =E5=86=99=E9=81=93=
:
>>>>> On Mon, Jun 20, 2022 at 07:57:05PM +0800, Xianting Tian wrote:
>>>>>> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=887:42, Greg KH =E5=86=99=E9=81=
=93:
>>>>>>> On Mon, Jun 20, 2022 at 06:54:44PM +0800, Xianting Tian wrote:
>>>>>>>> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=886:17, Greg KH =E5=86=99=E9=
=81=93:
>>>>>>>>> On Fri, Jun 17, 2022 at 12:17:45AM +0800, Xianting Tian wrote:
>>>>>>>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before ch=
eck its migratetype.")
>>>>>>>>>> fixes a bug in 1dd214b8f21c and there is a similar bug in d9dd=
dbf55667 that
>>>>>>>>>> can be fixed in a similar way too.
>>>>>>>>>>
>>>>>>>>>> In unset_migratetype_isolate(), we also need the fix, so move =
page_is_buddy()
>>>>>>>>>> from mm/page_alloc.c to mm/internal.h
>>>>>>>>>>
>>>>>>>>>> In addition, for RISC-V arch the first 2MB RAM could be reserv=
ed for opensbi,
>>>>>>>>>> so it would have pfn_base=3D512 and mem_map began with 512th P=
FN when
>>>>>>>>>> CONFIG_FLATMEM=3Dy.
>>>>>>>>>> But __find_buddy_pfn algorithm thinks the start pfn 0, it coul=
d get 0 pfn or
>>>>>>>>>> less than the pfn_base value. We need page_is_buddy() to verif=
y the buddy to
>>>>>>>>>> prevent accessing an invalid buddy.
>>>>>>>>>>
>>>>>>>>>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between i=
solated and other pageblocks")
>>>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>>>> Reported-by: zjb194813@alibaba-inc.com
>>>>>>>>>> Reported-by: tianhu.hh@alibaba-inc.com
>>>>>>>>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>=

>>>>>>>>>> ---
>>>>>>>>>>     mm/internal.h       | 34 +++++++++++++++++++++++++++++++++=
+
>>>>>>>>>>     mm/page_alloc.c     | 37 +++------------------------------=
----
>>>>>>>>>>     mm/page_isolation.c |  3 ++-
>>>>>>>>>>     3 files changed, 39 insertions(+), 35 deletions(-)
>>>>>>>>> What is the commit id of this in Linus's tree?
>>>>>>>> It is also this one=EF=BC=8C
>>>>>>>>
>>>>>>>> commit 787af64d05cd528aac9ad16752d11bb1c6061bb9
>>>>>>>> Author: Zi Yan <ziy@nvidia.com>
>>>>>>>> Date:=C2=A0=C2=A0 Wed Mar 30 15:45:43 2022 -0700
>>>>>>>>
>>>>>>>>   =C2=A0=C2=A0=C2=A0 mm: page_alloc: validate buddy before check=
 its migratetype.
>>>>>>>>
>>>>>>>>   =C2=A0=C2=A0=C2=A0 Whenever a buddy page is found, page_is_bud=
dy() should be called to
>>>>>>>>   =C2=A0=C2=A0=C2=A0 check its validity.=C2=A0 Add the missing c=
heck during pageblock merge check.
>>>>>>>>
>>>>>>>>   =C2=A0=C2=A0=C2=A0 Fixes: 1dd214b8f21c ("mm: page_alloc: avoid=
 merging non-fallbackable
>>>>>>>> pageblocks with others")
>>>>>>>>   =C2=A0=C2=A0=C2=A0 Link:
>>>>>>>> https://lore.kernel.org/all/20220330154208.71aca532@gandalf.loca=
l.home/
>>>>>>>>   =C2=A0=C2=A0=C2=A0 Reported-and-tested-by: Steven Rostedt <ros=
tedt@goodmis.org>
>>>>>>>>   =C2=A0=C2=A0=C2=A0 Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>>>>   =C2=A0=C2=A0=C2=A0 Signed-off-by: Linus Torvalds <torvalds@lin=
ux-foundation.org>
>>>>>>> This commit looks nothing like what you posted here.
>>>>>>>
>>>>>>> Why the vast difference with no explaination as to why these are =
so
>>>>>>> different from the other backports you provided here?  Also why i=
s the
>>>>>>> subject lines changed?
>>>>>> Yes, the changes of 5.15 are not same with others branches, becaus=
e we need
>>>>>> additional fix for 5.15,
>>>>>>
>>>>>> You can check it in the thread:
>>>>>>
>>>>>> https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A5A2-318C74869=
1FC@nvidia.com/ <https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A5A2=
-318C748691FC@nvidia.com/>
>>>>>>
>>>>>> Right. But pfn_valid_within() was removed since 5.15. So your fix =
is
>>>>>> required for kernels between 5.15 and 5.17 (inclusive).
>>>>> What is "your fix" here?
>>>>>
>>>>> This change differs a lot from what is in Linus's tree now, so this=
 all
>>>>> needs to be resend and fixed up as I mention above if we are going =
to be
>>>>> able to take this.  As-is, it's all not correct so are dropped.
>>>>
>>>> I think, for branches except 5.15,=C2=A0 you can just backport Zi Ya=
n's commit
>>>> 787af64d05cd in Linus tree. I won't send more patches further,
>>>
>>> So just for 5.18?  I am confused.
>>>
>>>> For 5.15, because it need additional fix except commit 787af64d05cd,=
=C2=A0 I will
>>>> send a new patch as your comments.
>>>>
>>>> Is it ok for you?
>>>
>>> No, please send fixed up patches for all branches you want them appli=
ed
>>> to as I do not understand what to do here at all, sorry.
>>
>> Hi Greg,
>>
>> The fixes sent by Xianting do not exist in Linus=E2=80=99s tree, since=
 the bug is
>> fixed by another commit, which was not intended to fix the bug from th=
e commit
>> d9dddbf55667. These fixes only target the stable branches.
>
> Then that all needs to be documented very very very well as to why we
> can't just take the commit that is in Linus's tree.
>
> Why can't we take that commit instead?

The situation is a little complicated.

The bug from commit d9dddbf55667 was not discovered back then. The commit=
 1dd214b8f21c
was trying to get migratetype merging more rigid and made the bug easy to=
 get
hit, but none of us were aware of that the bug also exists in commit d9dd=
dbf55667.
Then the commit 787af64d05cd fixed the bug, but since the original code w=
as
changed by commit 1dd214b8f21c, thus, it does not directly apply to
commit d9dddbf55667. So I do not think it makes sense to use the original=
 commits
1dd214b8f21c and 787af64d05cd, since the former makes a non bug fixing ch=
ange and
the latter fixes the bug revealed by the former.

As a result, Xianting's patches fix the bug directly, looking more reason=
able to me.

--
Best Regards,
Yan, Zi

--=_MailMate_34E3D0F5-4432-4B1B-9E12-E5D94C5962DF_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEE6rR4j8RuQ2XmaZol4n+egRQHKFQFAmKwgKgPHHppeUBudmlk
aWEuY29tAAoJEOJ/noEUByhUgOIQAIHs3P/epHdHgvgIaLy0gl7k90PWYGPoW9nv
JK3hioBZFoflLjI+LRHu8BOBSc3mIEpBwmC3qfHefyAg8d3yDCGImJ5c3jsGkptB
B+gc5R1OgvulfcsI7Au9xSKwsjPY+SU6PHZMiCeKfM/J3lZOKF4RAxLO/w7BCFV6
SEo21p6fD1imUaXq/P6d9D3QUxekW1E4Gt8cG8/dB7soQe2myb6Fj97u4iolcQ1A
OuJ7EpIA3wW0tLvdN64YnQ9Ml1yBZb4oqo47htul9l/ELLbAX3n4y6Dly/KC5oPB
LIehdlBKDP3qyTWyaeq0D5zonfmptrmSeGKCUOubnLB8X7H0OjqAwavQucSDTTiV
9AdvGXZW9bDd5JKh1UXO7Ir7ij05MEfgICBLYbs8iVzjOtd4uF2KibXu+xiBMVzT
09Bmvm+fU2GOTnkwl+DHP8/en6wczCtZs4zpqMsPGOMGfE3p/WBgBeUNqkOCtoOb
ZpSiCYvfwMtrSvcGMY8LEAETrzEAu9DQuYYgF3RHT3Am+MpCooPPfZ+m32ftE3AD
8Z8ahtRTbSIb4kLeNsYi2E0fd55BOy10pZ07IPs1ZwkjLo/Ry+ghKOzIaUMxSlcs
LfYKmd5I/GZW0wTZq+5xvbCltzpYZMTSHn0UeTkNUdponOeUHl8cAGFUbhfHkxmD
XGdpP9Ff
=UyUz
-----END PGP SIGNATURE-----

--=_MailMate_34E3D0F5-4432-4B1B-9E12-E5D94C5962DF_=--
