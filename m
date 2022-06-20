Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBE35518D0
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbiFTMZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242374AbiFTMZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:25:38 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2082.outbound.protection.outlook.com [40.107.102.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A8317A9C;
        Mon, 20 Jun 2022 05:25:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHx/Wl+1QFewjpAEXPcqD4QLosZE+vGiqHeQH6Eg4d3OVs1zzMBwuQn76nVLhOKGdnXawHTIU4f01dTE9i7Oj5Gc/WGIAbUDi6RCVxQfqy0rwvDHXTpeoIayEuqs7O4u8ICzPCWK4AVTY0e5rpnRUI3uva9J8QzYeQoDASiemXEIWimIaKlQRkjjpD5BrHBjrG0uEZXp49j4CzoFD28+kNGbdLa+QYkDE8j0UHjvj01/DkW0ADjlq4uJ1Pprd2LVybiPDtYv3WI/GOSVcmUJKlwiPMCH/06GEi6yq0pIUlUZCOvK/z8zyQ0iu2AC9aiO6pWWuMlR5fXsJmZd1+9hUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bSMQ/D8mqyfZaQhxZi7I4kC/S5DFkAEo6bZ+7tlyITM=;
 b=nZvBmw4RQw2YfgSlKKqgPo6dy2eXJtQp9F+bizEdnweG7y+Ou4V2tmzyYOTnzRlUs3CpnMHsnk4PfH4gwj5lZEqNaRYcyeEBCfRS/+5/AZP01vwl+QZwdAN5EBINcRitBcJPrn87lAhFfluVCm0qktB3g4B/V0gZZ9zVuV6yCY8g2ySV/pkOCDX7K29/NHNlHh3nLUeqFWQPQfNt546Ufe1C7vZlgIsiFCLQwbszyA8JX5ETZNdgr1XjL5iRM4q8eC+pSZGTUgiCRk0HCi3N8A0U2K54014xHUbAQMFkaDwXldp2cMa6RgShw2/I/xVl06fJKwWLLx5PFh4tzIxR3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSMQ/D8mqyfZaQhxZi7I4kC/S5DFkAEo6bZ+7tlyITM=;
 b=LTF+WmpC84IR3CT3iUvbwGpH5XxHbvggqiwmzqiyS3geQQYmWXsAgFIh/bVozhRGUneHZUmzKtMKfeLQPGNdIx5dyCDpv7vErXSIYbJwK3jNg46XcyzSc2dEUzdbxqYQ34Gh5QDCxlCf4fxXdZSsz5KGuwehtbKL2Z/Iy41VTSZyt9TsFR0ZNLJ0LB9Qvk0p6fsEXy/uYVc3PAYlpt9DySzqAtAupL1909DyNcDNukBp9vRjXIybCaS9tXMWTvDxbpTDENXGpoKhKx/Nw630PEl5PKBy4/CUFs5FzsUu1xddH1Hgan0IHnraJFo0WdSlkD0J/QEZsboK2MIYWUQlwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) by
 BN8PR12MB3635.namprd12.prod.outlook.com (2603:10b6:408:46::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Mon, 20 Jun 2022 12:25:35 +0000
Received: from DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::c44c:ea8d:1b00:5fdd]) by DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::c44c:ea8d:1b00:5fdd%6]) with mapi id 15.20.5353.017; Mon, 20 Jun 2022
 12:25:35 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, akpm@linux-foundation.org,
        stable@vger.kernel.org, guoren@kernel.org,
        huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15] mm: validate buddy page before using
Date:   Mon, 20 Jun 2022 08:25:33 -0400
X-Mailer: MailMate (1.14r5883)
Message-ID: <2E1BD795-A6EA-4272-859B-A29DFAF6DC07@nvidia.com>
In-Reply-To: <d52e17da-a382-0028-2b16-105ab7053028@linux.alibaba.com>
References: <20220616161746.3565225-1-xianting.tian@linux.alibaba.com>
 <20220616161746.3565225-6-xianting.tian@linux.alibaba.com>
 <YrBJVAZWOzmDyUN3@kroah.com>
 <35bd7396-f5aa-e154-9495-0a36fc6f6a33@linux.alibaba.com>
 <YrBdKwFHfy9Lr14c@kroah.com>
 <8b16a502-5ad5-1efb-0d84-ed0a8ae63c0e@linux.alibaba.com>
 <YrBi1evI1/BF/WLV@kroah.com>
 <d52e17da-a382-0028-2b16-105ab7053028@linux.alibaba.com>
Content-Type: multipart/signed;
 boundary="=_MailMate_D10FC8E5-1B79-4253-B553-9465B70C7233_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: BL0PR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:207:3d::32) To DS7PR12MB5744.namprd12.prod.outlook.com
 (2603:10b6:8:73::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b64f424-fb24-4544-0152-08da52b7fa0d
X-MS-TrafficTypeDiagnostic: BN8PR12MB3635:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3635C78D34BACB249DFE8A60C2B09@BN8PR12MB3635.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +guwJDBOr2XVSQZP3QCc0qihqcPDHjtzmqzsCrXFZyAnae592aqwm2THmbYWN6N4KaKkzXqd+mlFspLyxLvPQi2QQsRhBvoz1h6bmTk6Y6I9bjcqK1P0xVNXpgXOXVLCWr4bZ5arDTdhavEq8OhsmxhXtOEmG3DELiCBIXv2Uc9je18+x/ejIAdgcWr50+yVJ6FxCzvzs8ZctekKdqH5GdwewDQnAJldJ9ZBW+P+FVIdeI11Z/vJkuuer2DRnhcNh4CxDLdiyq5oY08pmLcpA4MIvYdIXdL61ypjizPjqvVV0MvGSL3FsxGOPnzRwbNT60HrTekxYzo/VBC5n0GGn4+1EEC0y7oJUM7uz4n7n8wEombfXsb/fefbhMX5k1X3KYN1qtQusNY7/836hUHZqVJvIz9HsBzuZjZEp2MGVQdGSPO429wRSoFmvtZnGA0VvUIhQxU1rCWEuWM4IyfDWjgUnzZwzNLj29WuDFD8fCDs2OOv+T8VI6PElVebdYEM08hzD/baXD9doOlChxQ7wfena2rZl8fZG7XsZWEhIZbwNHtHtHADOn9UAvAFX0dPYAXz9qGl2qCKi2dmZFo6r+r0xDCxs21e5j0hDsCjuX6qCWEAzYam/alxPIyeTCxACV1VzLuDf7D9e6fPKuIdalK1KMYpOL6E26lgunzQnHH1Y77jCVKHlYqGd6IZVql4AwEc+cGq5iJyuLDS6540wzRTAa2+kPpVAtOgpoXrmJT8+cw8IW1Vsy6VCsy7yw/VBlv1PoMjNohSajfkVA3H5Sc7O4cJ/kZaVGrEZS+X5SAFwdmMgJuGvAXhohn5l3nrFeHNPsPMcQpuvn8cyXTBsIFpZsfqWPT+VUFsmKJYWAY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5744.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(21480400003)(53546011)(6512007)(2616005)(33964004)(6506007)(26005)(83380400001)(36756003)(186003)(15650500001)(2906002)(5660300002)(7416002)(33656002)(235185007)(8936002)(66946007)(966005)(86362001)(66476007)(6486002)(8676002)(4326008)(478600001)(41300700001)(38100700002)(316002)(6916009)(66556008)(45980500001)(72826004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekdJZEN5Yk5WblB4TlZVb0ZnZ28zT0xyZUFHSUkyM0h2blFUeGtuRVJoeVJo?=
 =?utf-8?B?U3BaSS9NVkI1ckNXM1Y0OU1ZbUFGQ1FKc0E4RE5ZZy9QbVZzR2dlZTNlb0dT?=
 =?utf-8?B?bFVBVnBZY2k5d3E4NlVkUVpiSzN4RHZqUFpMcTAzajliY1B1cEt0c2pzSnNw?=
 =?utf-8?B?WVhPL3Z3SFJqdnZnTVFXSENoRnJGbi9hUEFKZnVVSjNCaGd2cTZMSmQ2a0hC?=
 =?utf-8?B?SWl1QU0zZ1VGcHRhbHhGYWorbnJvdmM2Q0pjV1IzRXpvZ3YzNmw5QVh0amIv?=
 =?utf-8?B?VkF3QXVsdTlNRUxLdGlzRkFPamxubzd1K3ZoSm9GNGVtVzVjdUNPaG1DRjdZ?=
 =?utf-8?B?dnZaQS80UXVtSVJkMDNGSEN3UUgvQkxET3ZKWkVoYUpNVG13ajVDQno3OVZM?=
 =?utf-8?B?aENrSHc5OTNKVFpGZTk3R3VCNmdoakxtQmYwTFJSdHphUVVtL3NVdGlyeldk?=
 =?utf-8?B?RzNkcGxRWERGRmR2OW03SGxuQnc3amJtREN6OWxMalpJb3FDbkphSTl4TGxy?=
 =?utf-8?B?S3VkaE5zNnhTZFdtRzVZNHovK0U4YzNheTNkYXR3cWxDV2R5VSsxOWFsNzNs?=
 =?utf-8?B?N25Wdk01MmNKSml5d04xeUROdENwcDJJYU5oWTA5ZGRJSy81UFpBcEswQnE1?=
 =?utf-8?B?dHRicStnV0ZYbnZ6NXhYMzdjTS84aGgvUzVDRWM2R3lVWVdpL2hiR2p2V2Z1?=
 =?utf-8?B?TWpLVFlsenZQcjh1NFU3QkdOaE81d2p3V2FyeXBVb3VkS3EvWEI0eTlqTTRV?=
 =?utf-8?B?OEpHZXplbm5ueUFkWGx3TCtndlJXOTR2cUZ0cGJNUWkzb2tyM2xjQUdCNUJx?=
 =?utf-8?B?aGFBTGJVR0hIQmhrZ2pYZzYzblNQSUlueUg5eTNWYkIrYXJOS1RROGNIak1O?=
 =?utf-8?B?aG1FTU5neG03THlHbWVqU25GYk5LY0ZMU3kzVlVEL1BHNFQ1YVBlazd2eGdk?=
 =?utf-8?B?aWlkMjdxNC9yR1VYUHdCNEhQV0hIQys1Y2hyV09CZjhTeXBYQS9BRnd0WGRa?=
 =?utf-8?B?b25DdFpDSFpkeFdhelAyUUFRVC9Pd2tiTjY1U21aYzdKM0YwbWczaFAyN3Fu?=
 =?utf-8?B?T0ZvbDVUQm1sdHJTQjJJdUNoSVhhMHpqUnBLZFhUZzVoQkVCcmVCSlpWNWsx?=
 =?utf-8?B?MURNOUNsK0xTYUV5dzhORFgxcC8xVDVXckQ0Q1E0WDhnVHRuK0RUWGU1NUFm?=
 =?utf-8?B?Ujl3U0gwbmZSa21kV2ZpUjlYWkNBTUR0N1V5MkRNNW10djFuQldnU2lwYmRw?=
 =?utf-8?B?WDhscDF3Z1I2RVk4bG5ZYXJzVlc5VXFLazRDYkUxUUpyR3BwN3RiMUY4L0xW?=
 =?utf-8?B?TTA1cndVakNKTyt5ai9adjJSMGpmSHVwb1pmNXpqTzFETkl1OUFkRkNzbzc1?=
 =?utf-8?B?LzRzUlRNc1llRmkrYTNST3NtY21DREw5RjBNVExkODNtNlZ5MEVzUGs0b005?=
 =?utf-8?B?TWMwZm1jTlNXY0tidy9ZV2s5UThOSVFVbCtpZEdyYVArM3ViMEtaVzA2SmI4?=
 =?utf-8?B?a3I2YWQ2RWZFUFBPQTVRK0NGK2NYL1gyR3VIMVhaUVZqOEZ5QTI0cXBHN28x?=
 =?utf-8?B?QnlNZXZNSEt2d2Zpc1ZJWmo3OVVaSkdsWGFhVGIvUlVjUFJERHhuQktQMHN0?=
 =?utf-8?B?b0VDYWF5VytVa09GOGVSRzJjSjVBSGJ6YTlnREFncHNlTC9UcWpGYmpoSG1P?=
 =?utf-8?B?RXNkUU0yUmYwcTZQWjBuUGZyMWlHcEplRVpGVHA2ZWd3UWI1eW5qdTdFQlgr?=
 =?utf-8?B?Z2dKWE5oa1NJQ0tmQ0IxRmpBWFNtcWJlSklXZGFDK1hIeVQ0eGZ5NnRCeFd2?=
 =?utf-8?B?Q2lwa0g1a0hhQzhqUk5GTnppQ1lqcWRvall5UkVzV0NBTWFGR3J0Mktmc2JS?=
 =?utf-8?B?ckZCZjlOblF2U21lMXBvVkIvT1JFdGszQUhqbFFvTitEakcyR1kzUjROVFg0?=
 =?utf-8?B?UTNuVXk1dnBXWHRCYm95MVVuRXF1REtRdGxTb3dPMExGY01UVkgvRHhyY2FJ?=
 =?utf-8?B?eHJPd0pqUFlrbkkxcWt0b1hkNEhLWFlhWklsSDJQd2RLZkFyQnpvME1xL08w?=
 =?utf-8?B?blpCZnlXc2NTbFZvamg2cElpNGZEcFoybGhLdGV3d3pmTk5NY1lhUm1KaWtO?=
 =?utf-8?B?alpKNjhLRkJxY212ZWRjcno4a3owREJYWXU3bnc3dXJVNGgwQXN1NEdNY1pj?=
 =?utf-8?B?RlZISHBlWGwveHYvNDMrVGNTSElzUkJONlhyaktPWDBUYXhGcGZsUmRZeTl4?=
 =?utf-8?B?WHlTVEI4VjJLckFhQ0lYeXlqcFRqT2MzcmRKWkRHWlBpMGlScldLeUp6VUF0?=
 =?utf-8?B?VU1NVUhwY2dTSjh2MVkvdjVkNTNxNzhublFFeWk4aXI1cGpYYXJHdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b64f424-fb24-4544-0152-08da52b7fa0d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5744.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 12:25:35.5401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: khNJwPgxgeiG/+pJW5JWr9QjQ85lb+uWcDrbe3KHh8SD5YlV3tqf55HfXhesvzBe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3635
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_D10FC8E5-1B79-4253-B553-9465B70C7233_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 20 Jun 2022, at 8:18, Xianting Tian wrote:

> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=888:06, Greg KH =E5=86=99=E9=81=93:=

>> On Mon, Jun 20, 2022 at 07:57:05PM +0800, Xianting Tian wrote:
>>> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=887:42, Greg KH =E5=86=99=E9=81=93=
:
>>>> On Mon, Jun 20, 2022 at 06:54:44PM +0800, Xianting Tian wrote:
>>>>> =E5=9C=A8 2022/6/20 =E4=B8=8B=E5=8D=886:17, Greg KH =E5=86=99=E9=81=
=93:
>>>>>> On Fri, Jun 17, 2022 at 12:17:45AM +0800, Xianting Tian wrote:
>>>>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check=
 its migratetype.")
>>>>>>> fixes a bug in 1dd214b8f21c and there is a similar bug in d9dddbf=
55667 that
>>>>>>> can be fixed in a similar way too.
>>>>>>>
>>>>>>> In unset_migratetype_isolate(), we also need the fix, so move pag=
e_is_buddy()
>>>>>>> from mm/page_alloc.c to mm/internal.h
>>>>>>>
>>>>>>> In addition, for RISC-V arch the first 2MB RAM could be reserved =
for opensbi,
>>>>>>> so it would have pfn_base=3D512 and mem_map began with 512th PFN =
when
>>>>>>> CONFIG_FLATMEM=3Dy.
>>>>>>> But __find_buddy_pfn algorithm thinks the start pfn 0, it could g=
et 0 pfn or
>>>>>>> less than the pfn_base value. We need page_is_buddy() to verify t=
he buddy to
>>>>>>> prevent accessing an invalid buddy.
>>>>>>>
>>>>>>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isol=
ated and other pageblocks")
>>>>>>> Cc: stable@vger.kernel.org
>>>>>>> Reported-by: zjb194813@alibaba-inc.com
>>>>>>> Reported-by: tianhu.hh@alibaba-inc.com
>>>>>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>>>>>>> ---
>>>>>>>     mm/internal.h       | 34 ++++++++++++++++++++++++++++++++++
>>>>>>>     mm/page_alloc.c     | 37 +++---------------------------------=
-
>>>>>>>     mm/page_isolation.c |  3 ++-
>>>>>>>     3 files changed, 39 insertions(+), 35 deletions(-)
>>>>>> What is the commit id of this in Linus's tree?
>>>>> It is also this one=EF=BC=8C
>>>>>
>>>>> commit 787af64d05cd528aac9ad16752d11bb1c6061bb9
>>>>> Author: Zi Yan <ziy@nvidia.com>
>>>>> Date:=C2=A0=C2=A0 Wed Mar 30 15:45:43 2022 -0700
>>>>>
>>>>>   =C2=A0=C2=A0=C2=A0 mm: page_alloc: validate buddy before check it=
s migratetype.
>>>>>
>>>>>   =C2=A0=C2=A0=C2=A0 Whenever a buddy page is found, page_is_buddy(=
) should be called to
>>>>>   =C2=A0=C2=A0=C2=A0 check its validity.=C2=A0 Add the missing chec=
k during pageblock merge check.
>>>>>
>>>>>   =C2=A0=C2=A0=C2=A0 Fixes: 1dd214b8f21c ("mm: page_alloc: avoid me=
rging non-fallbackable
>>>>> pageblocks with others")
>>>>>   =C2=A0=C2=A0=C2=A0 Link:
>>>>> https://lore.kernel.org/all/20220330154208.71aca532@gandalf.local.h=
ome/
>>>>>   =C2=A0=C2=A0=C2=A0 Reported-and-tested-by: Steven Rostedt <rosted=
t@goodmis.org>
>>>>>   =C2=A0=C2=A0=C2=A0 Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>   =C2=A0=C2=A0=C2=A0 Signed-off-by: Linus Torvalds <torvalds@linux-=
foundation.org>
>>>> This commit looks nothing like what you posted here.
>>>>
>>>> Why the vast difference with no explaination as to why these are so
>>>> different from the other backports you provided here?  Also why is t=
he
>>>> subject lines changed?
>>> Yes, the changes of 5.15 are not same with others branches, because w=
e need
>>> additional fix for 5.15,
>>>
>>> You can check it in the thread:
>>>
>>> https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A5A2-318C748691FC=
@nvidia.com/ <https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A5A2-31=
8C748691FC@nvidia.com/>
>>>
>>> Right. But pfn_valid_within() was removed since 5.15. So your fix is
>>> required for kernels between 5.15 and 5.17 (inclusive).
>> What is "your fix" here?
>>
>> This change differs a lot from what is in Linus's tree now, so this al=
l
>> needs to be resend and fixed up as I mention above if we are going to =
be
>> able to take this.  As-is, it's all not correct so are dropped.
>
> I think, for branches except 5.15,=C2=A0 you can just backport Zi Yan's=
 commit 787af64d05cd in Linus tree. I won't send more patches further,

Please do not back port my commit 787af64d05cd directly, because although=

it fixes the issue, the code indentation is not right. At least, I tried
to cherry-pick the commit and failed. The commit just happens to fix
the issue in commit d9dddbf55667.

>
> For 5.15, because it need additional fix except commit 787af64d05cd,=C2=
=A0 I will send a new patch as your comments.
>
> Is it ok for you?
>
>>
>> thanks,
>>
>> greg k-h

--
Best Regards,
Yan, Zi

--=_MailMate_D10FC8E5-1B79-4253-B553-9465B70C7233_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAmKwZz0PHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqK3soP/1u1K40+aWovlQzW3UCoDvwTrJ4CSjDOj+CG
YrxsBsI1eBuxqj1R5o6d0RXeIBTRGqMuejO/pGsQ+YNl/0woTB5Q1iKelThqbM0e
/gIz2ZA5IpLxp+qmqJkN26SesbRk1EZhNgiOVHQyxNtDVPxA61Eo3APME8TC8bOF
3otT9fQ6WiM6yq4s2hHmZC1B8TRnkWTV4WG+0eLJTRbRhXSpDbDycJtrnTuhsb0V
CYxnapUymcjmRk7Cmd3FnvZzN8aWxz8gHqgbptK4uCjCjHVUGydyMg+JxU29aK5h
lH/giwqgCYRD4EWit+DVq+Az0md+FRARqFlxKCq9C+khgii+tT8IzvqdabiTj4jG
ntNxCxvmZPKSBqN+Jkn/IzWRkxc7bG9FNMppuvf7v8hjFCgKV3IcLG1tfrVn4dH3
3IW1qmWMUzyy/tV3lZ3vU9rJq9onyYKfaFaW6Yn7riSiJBj9+wa3RzREt9gxcn9v
6L9ZpaVZUf4KwO1gSKf0vbpA0qpvfkjG+dxXisp7BJfJLpz49wDQMC2D3u9y44sI
KUnu0DlNowN2UPKFlYhgUGU0bsiqByv63IABz147f5kmqJN0dLBh8M2w5IHwRfHl
lG+SDoXK/POsljEaaEaCXAVDdgYxNu6Gv2z8TF1c5PYMbexOpWkkSjq12YaZBliF
BUpmLNgK
=7cyc
-----END PGP SIGNATURE-----

--=_MailMate_D10FC8E5-1B79-4253-B553-9465B70C7233_=--
