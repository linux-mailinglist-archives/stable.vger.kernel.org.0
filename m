Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F17854CA70
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 15:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349036AbiFONz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 09:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352836AbiFONz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 09:55:56 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3854F3633C;
        Wed, 15 Jun 2022 06:55:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VN2rOeA+KSyqf/nm+ha1LBvLVhJ0/KTREpzX1hnE9fRJmSOel8+jPMkO7vLWuFSj6vvOwj6S9WAfsmgvm6YN1Ja6S+MgVeewTsf7XoZGkXEiJZc5V9BRyZRgSjpThAqulS5yqYTW6d+NXCldFCY3KgIJGelDBlwpPNKisN6nLRbGYS/N6oK9h5NIEivAuYK4wP26AtN93QSAbJ001WXSanC6APr4ZBAQc4SOcWy+gY59D23t/3RO1BfQPtyTF+jRArQWk+XBwTrAegyJCdcrNtXk+X7cWXHL9mxVGUbBXGtlYKjsLlzGORkEKvEKSIV4GSBjp7/PYER/aDbFQ90M8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i52+G9I5AqVU3Lp21fP2XTJcTd7ClcGt7AjsSKCKvqU=;
 b=jd6VLRZc9WsRvDezOdKpU62Hke4/ZG0cV0Z0XHZ6i0RuO7qhSEAiIJuZAzj5I5PDMGuiYewrqHwD0IE89u2qOQrEyg7loVK2qlvM0KW5CO5I1C84hWJKx+pOFMfKE/9Esnsf/Xr38e88XU03+8Xf/naZgxkY/+QC/ShoS8aW7qt/ZgcR4hlV4T9TvN2eO7xF+rtDPKWr3t3gP1Z6aC6/ep2+c0Si1QnM+eCA9W4dFKs0GE2QvAfN/Q1NDjNJ9hIJB55nZOPMWx5YO8pCv7Rrcz4PfgQZRJprHTYX6TcEZ2ILJKY/pufaRsI0+qPMLbVYwcl4Nd23b4P0wB0PDDVjLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i52+G9I5AqVU3Lp21fP2XTJcTd7ClcGt7AjsSKCKvqU=;
 b=Y72tD9WbkfjJkFLvn0fGZBctBLnbf8bo28m96Gw0IXzp6XUM/zL1m0VVBUDmCuOOqkDhnmAf+uXUQ9bz9On1a/KMSb+rs9Yx4uFTWFbdcQTfp3Pa+7R/WD/okzlZV5/HQs2iXXiR6PI4HR/dt94bbKECrcOEh8e4B/d7p1Vg54qoSDuPTkIcL3nYljQBcSE5o/2jJB6pFQfqnxh2ozRkwEia2fq3YPE5Nr1R8Yg9zXOfoXzvok84RqEBbqtKpRpVy+jthnSJGTTxdwJUUhR29cB8UhbtsZl4qPA+uHY5BG+jZMKVPaBv6/DHNTdvVQzsYM0R5/vi8CDqdJylIXm0sQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) by
 BN9PR12MB5276.namprd12.prod.outlook.com (2603:10b6:408:101::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 15 Jun
 2022 13:55:53 +0000
Received: from DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::2030:d898:6e2f:3471]) by DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::2030:d898:6e2f:3471%9]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 13:55:53 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     Guo Ren <guoren@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, huanyi.xj@alibaba-inc.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        Hanjun Guo <guohanjun@huawei.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <labbott@redhat.com>
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the
 migratetype
Date:   Wed, 15 Jun 2022 09:55:50 -0400
X-Mailer: MailMate (1.14r5898)
Message-ID: <18330D9A-F433-4136-A226-F24173293BF3@nvidia.com>
In-Reply-To: <b65b9edd-ff3e-aa44-029a-49fa5ba66b47@linux.alibaba.com>
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
 <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com>
 <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
 <D667F530-E286-4E75-B7CE-63E120E440C8@nvidia.com>
 <CAJF2gTSsaaseds=T_y-Ddt5Np2rYhk3ENumzSZDZUSXFwT3u-g@mail.gmail.com>
 <435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com>
 <b65b9edd-ff3e-aa44-029a-49fa5ba66b47@linux.alibaba.com>
Content-Type: multipart/signed;
 boundary="=_MailMate_A3F55948-B04D-4696-808A-C184576EEF2D_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: BL1PR13CA0375.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::20) To DS7PR12MB5744.namprd12.prod.outlook.com
 (2603:10b6:8:73::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32a891e1-4780-42aa-9f58-08da4ed6c303
X-MS-TrafficTypeDiagnostic: BN9PR12MB5276:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5276FF3199CD9939253C3A35C2AD9@BN9PR12MB5276.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AQVqCJdl583yrTzsEPHdh0O8/2SVfvBG6WFdI7PSROAc34ABuZvpBETfpMo6uisHdoG2//1wivmMpfaHimntKNHAkmPr+EX1pCr8xwrh3Xa3k8a3bEAofc304kJZ8Z6XQ+wwOyPMIA/USCey2mGsLXdIVYD4NmuphUahvwj+LAojnBtS8760LFhQWbkPGHSUDRgS+R6m+VgG35i/yzD1f47E3LiUABuzWRvkqByuCLPXo+Pwuj3P+nUSvbvBaz+xesgTNmzN2igVWgc6eyoSY7ldQEOU7RJtusc1VJ9UtH8AWeAGFD3lBg6PVReQ8AHZOCtmcnrcSHF81cOEd4p3qZsI/8BuiQ9Ki4mmwqQ9R9PsP3SD3ZxLNxnyI0iARfDI90N+ht1dvpPof0HECc40nAYByDueDmrrNOTfFJO4ZnLvG8s1hT0xg8roRCSr8NmRhTvzpggMPbFwkZdsJRZGc+QF/8wrbby3hjZ8ie4pum7SNYNyrrs1+DQuGSbCuGJzJyfG+/modvEUc0u54spGhbHJL7O2uSaVLb316ag4g6/k/JNt4z1c3UZweGSKhaXM1FXesZVX63kNw8y5sIceGe+X6GdiTqa6+27Yg3bHC3xkpSh9rBilkgCoPWqqsgbJ1KePihcRXzYIn3DT3/aHBlQyqZ45IzCdf0JN/TefFNainA9ZyPmJPLo1m/4NygJn1vTdehnEMjnVxUKMaR+AEJ7MYaPXklDdarK3sNnN+YloZrxjQxQrCL0fyqiQd3wCdWvQmd35PDg0pkIKA5nocRFDlutLP6dYUWTyX0PvEDhFJ0E50iB+nKbKcaoHaqFr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5744.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(54906003)(186003)(66476007)(66946007)(8676002)(6916009)(36756003)(21480400003)(66556008)(4326008)(316002)(53546011)(33964004)(508600001)(8936002)(6506007)(6486002)(966005)(2906002)(26005)(6512007)(5660300002)(83380400001)(2616005)(33656002)(86362001)(7416002)(235185007)(15650500001)(38100700002)(72826004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0VLbSthWXJsS215WlIweE1PTUdKRWg0YjdqYlJHRmJOSkJnbGxISEdVdWtx?=
 =?utf-8?B?dDJSbGNzR0tsdER3Q2Y4T3FrVXFuTndERW1qN3lncTc1MytkbENDWjgxbkE4?=
 =?utf-8?B?bU1DejZYb04yVlpCZWJIVFgwMDdmSnR2UllDbU5lUFF0V0Y2NXo1UjE2VjZK?=
 =?utf-8?B?Q0tldjhiRGh5aldyQ2liMlk4eTBYeTVDZmtQdnNXalBLT29GMkgreUR2Y1hW?=
 =?utf-8?B?eHcvTUF0RlM5UWFVakhmRW1MN3RiK1NabXFubkRtcDlPblFHS1VWUnZSVlQx?=
 =?utf-8?B?ZThCR1g5MnpnWG5EYjZEMmU0UnBQNTg2eENxYmVKWDNRZlRwV3Y3TXgwRTJR?=
 =?utf-8?B?YjNhZ0JoU2tVRUViOTNDZ0tDVEJnT0I2dVdLSkw1Zm0wL0h4Y1RIVmlIUzZS?=
 =?utf-8?B?c3Z4ckt3dk0wM3QzY3pLS2dJOTcwSTkydENjOVpKZEgxM3FMRW5yV2o2bHVz?=
 =?utf-8?B?ZWdRSjFHRUlRdVltUzVFdDZUcTFMTW90YVMraTFJRTBweklYNUdNZFpGSWRk?=
 =?utf-8?B?OU5sN1dlb3M0cEZQVXpBbkdHRVp2QitURDJ5VGtMV1YrZlUvakM3WWtzbUQy?=
 =?utf-8?B?SEtwVWpCbEVPd3ZDc09nWExHeG9qaWFkcmhXY3Y4dDhKWEtIQ2ozM3RHd1Vv?=
 =?utf-8?B?OWx4NnBhRnRlelJqbk8xOHBVSHRxQzhqQStqaVY5RlBsWlFUY3dOSnRtUnpB?=
 =?utf-8?B?NHpmMndVVnlVcWpxRmxWcEl0MTR3WUdtZVU4Ni9oNS9iN3hHajdGQldNQlZu?=
 =?utf-8?B?dHppMnpPOUNPaVNobVdTWXh3VWJVemVVdU1rZ21ocFJsekZGWDU2Z0Z3dWVR?=
 =?utf-8?B?RGxuR2xnTWxreEZmU3ZPU25SSUlSSnpITUN4YW5wOElvSTk2TFJoUWRFa2ht?=
 =?utf-8?B?MFdqOWh1SWh0empERHRYWHZmYzVWaDhmR1RDZHVaNEgvV0hLUytQbkRSVFVy?=
 =?utf-8?B?dG9WWGJWblphSy9mRDVESVBYVDlSaE50b0VmRURrU0YyREhMK21ncUQ1aGJw?=
 =?utf-8?B?UXFlZDNkVnJoeEY2ejBKcU95cWFGOG92R2xjSDFqUjMzYnVJQlA2ZTcyRE84?=
 =?utf-8?B?MmFxcGlSMnVidFhDczVlTHhVWFBVWkdYcmgrT3pWZDloZmI2NDE5QW54K0lI?=
 =?utf-8?B?Qm43cmMyV1VNdmlxNHd2N0h4V3VTcit4d1dvZ3V5V3pVcmtXd29OMHVwRS80?=
 =?utf-8?B?T1ZlWTJBcjBYQWVmRDhBdEttNkZGam5IeTB1dDhiS21aelNCZG5hTHpqUDdI?=
 =?utf-8?B?M3EzVU5LQzd5aWVoNkJzZE9rcldCclc3YWFxQlB1cG45SFgzYjU0VnlBNHJ5?=
 =?utf-8?B?ZmM1QUJwNEtRZjR6TGYrZUpOR0lNNTY5WHhtMnVqVHEwT1d5aWZQMzVYdkJX?=
 =?utf-8?B?d1VsVU1ZSEFQd0xXNjBHR3VvYSt4djFzWDBWek1OcDhBNHZJYnNhdU9XakdS?=
 =?utf-8?B?SlpLNm8xNDljd3Z1UUtQUGk3TVl5bHJnUy9sTTNiVG9LaHFPaUtDY3hpdHEx?=
 =?utf-8?B?N0RDWFgvamF1MTNCU1dYRWh5dmszZXcyNi9nY0wweGNGdnV6WEFDTkptSzJL?=
 =?utf-8?B?MEV1bnlydGVmS1Z1V3I5aThjQVVlazE0NEtYOG9hYjBiTm5jRzVOY1JwNTRx?=
 =?utf-8?B?QVoyNmJpZE5jZTZSamwxYXJHSEdiL25Iakt0Z2tHZ1hVcDFxSkFiKzdzb3Jr?=
 =?utf-8?B?OXpTVTRzSU1hdXBlb3ArNXhYWDNKM092QTVVN1NTaGJEd3V6VWxsdHlDUWlt?=
 =?utf-8?B?YzlRK3lGVzhGMXVFd3hLUzBwVTlxN2NyU2VCRDNGVmx2UWVzd1ptTVVFM2ha?=
 =?utf-8?B?V1NEQzROQUJsWTdZZmZXNlRoN0VVcFhzcXJMNXRheFJDUUNpZzl6Q0hRMHZU?=
 =?utf-8?B?bk1ZMkRucHZoWmg0WkVBK0ZvSnFSU0xiZlJTMHozYjNQeG9BTGhmL295NURR?=
 =?utf-8?B?RlVlNEQ2TzcrTHdqQmdhWUFIek9SR2F2bVkrN2I1QnNteVROU0tGbWg1K1oz?=
 =?utf-8?B?ZDZmaGJZZGdmdDFQcWhYb0dwYUJISGdCdTduR3pOa3BxV0YrY1RlcUU0enFK?=
 =?utf-8?B?eUhSMzVjM0dPdmcyQ1VWbGF2VlI0QTR5em1nTDN4VWFtb0lmd2JtNVhqbEtx?=
 =?utf-8?B?SmVsTzB4TmZFV2ZpYnBDNHBQWXNVd0VhdWlXSWZnYWRVVVNiV3hQT3MxZUZH?=
 =?utf-8?B?ZlZVT3JLbmljaFl2Q285bVU3a1krd3B0VmpsOWFHQlpuVjZYNDNTWjM1UnlF?=
 =?utf-8?B?MWJvWkN2dExnUGxEcFR1Vm5EcUYxNW5reGFBbTlIK2R5YnhxaGJhdHVaenUw?=
 =?utf-8?B?clBNUnBHZjRVOW1qaTdhVlRDMlZPTHBqUmdYUSs1azVEdWlabDYzUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a891e1-4780-42aa-9f58-08da4ed6c303
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5744.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 13:55:52.9671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vURuXoqORQ+yux6AnzkITNSSRSCHiqheOHHtSAtRI77mAV5gc4NXMUMqNFopLfxd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5276
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_A3F55948-B04D-4696-808A-C184576EEF2D_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 15 Jun 2022, at 2:47, Xianting Tian wrote:

> =E5=9C=A8 2022/6/14 =E4=B8=8A=E5=8D=888:14, Zi Yan =E5=86=99=E9=81=93:
>> On 13 Jun 2022, at 19:47, Guo Ren wrote:
>>
>>> On Tue, Jun 14, 2022 at 3:49 AM Zi Yan <ziy@nvidia.com> wrote:
>>>> On 13 Jun 2022, at 12:32, Guo Ren wrote:
>>>>
>>>>> On Mon, Jun 13, 2022 at 11:23 PM Zi Yan <ziy@nvidia.com> wrote:
>>>>>> Hi Xianting,
>>>>>>
>>>>>> Thanks for your patch.
>>>>>>
>>>>>> On 13 Jun 2022, at 9:10, Xianting Tian wrote:
>>>>>>
>>>>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check=
 its migratetype.")
>>>>>>> added buddy check code. But unfortunately, this fix isn't backpor=
ted to
>>>>>>> linux-5.17.y and the former stable branches. The reason is it add=
ed wrong
>>>>>>> fixes message:
>>>>>>>       Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fal=
lbackable
>>>>>>>                           pageblocks with others")
>>>>>> No, the Fixes tag is right. The commit above does need to validate=
 buddy.
>>>>> I think Xianting is right. The =E2=80=9CFixes:" tag is not accurate=
 and the
>>>>> page_is_buddy() is necessary here.
>>>>>
>>>>> This patch could be applied to the early version of the stable tree=

>>>>> (eg: Linux-5.10.y, not the master tree)
>>>> This is quite misleading. Commit 787af64d05cd applies does not mean =
it is
>>>> intended to fix the preexisting bug. Also it does not apply cleanly
>>>> to commit d9dddbf55667, there is a clear indentation mismatch. At be=
st,
>>>> you can say the way of 787af64d05cd fixing 1dd214b8f21c also fixes d=
9dddbf55667.
>>>> There is no way you can apply 787af64d05cd to earlier trees and call=
 it a day.
>>>>
>>>> You can mention 787af64d05cd that it fixes a bug in 1dd214b8f21c and=
 there is
>>>> a similar bug in d9dddbf55667 that can be fixed in a similar way too=
=2E Saying
>>>> the fixes message is wrong just misleads people, making them think t=
here is
>>>> no bug in 1dd214b8f21c. We need to be clear about this.
>>> First, d9dddbf55667 is earlier than 1dd214b8f21c in Linus tree. The
>>> origin fixes could cover the Linux-5.0.y tree if they give the
>>> accurate commit number and that is the cause we want to point out.
>> Yes, I got that d9dddbf55667 is earlier and commit 787af64d05cd fixes
>> the issue introduced by d9dddbf55667. But my point is that 787af64d05c=
d
>> is not intended to fix d9dddbf55667 and saying it has a wrong fixes
>> message is misleading. This is the point I want to make.
>>
>>> Second, if the patch is for d9dddbf55667 then it could cover any tree=

>>> in the stable repo. Actually, we only know Linux-5.10.y has the
>>> problem.
>> But it is not and does not apply to d9dddbf55667 cleanly.
>>
>>> Maybe, Gregkh could help to direct us on how to deal with the issue:
>>> (Fixup a bug which only belongs to the former stable branch.)
>>>
>> I think you just need to send this patch without saying =E2=80=9Ccommi=
t
>> 787af64d05cd fixes message is wrong=E2=80=9D would be a good start. Yo=
u also
>> need extra fix to mm/page_isolation.c for kernels between 5.15 and 5.1=
7
>> (inclusive). So there will need to be two patches:
>>
>> 1) your patch to stable tree prior to 5.15 and
>>
>> 2) your patch with an additional mm/page_isolation.c fix to stable tre=
e
>> between 5.15 and 5.17.
>>
>>>> Also, you will need to fix the mm/page_isolation.c code too to make =
this patch
>>>> complete, unless you can show that PFN=3D0x1000 is never going to be=
 encountered
>>>> in the mm/page_isolation.c code I mentioned below.
>>> No, we needn't fix mm/page_isolation.c in linux-5.10.y, because it ha=
d
>>> pfn_valid_within(buddy_pfn) check after __find_buddy_pfn() to prevent=

>>> buddy_pfn=3D0.
>>> The root cause comes from __find_buddy_pfn():
>>> return page_pfn ^ (1 << order);
>> Right. But pfn_valid_within() was removed since 5.15. So your fix is
>> required for kernels between 5.15 and 5.17 (inclusive).
>>
>>> When page_pfn is the same as the order size, it will return the
>>> previous buddy not the next. That is the only exception for this
>>> algorithm, right?
>>>
>>>
>>>
>>>
>>> In fact, the bug is a very long time to reproduce and is not easy to
>>> debug, so we want to contribute it to the community to prevent other
>>> guys from wasting time. Although there is no new patch at all.
>> Thanks for your reporting and sending out the patch. I really
>> appreciate it. We definitely need your inputs. Throughout the email
>> thread, I am trying to help you clarify the bug and how to fix it
>> properly:
>>
>> 1. The commit 787af64d05cd does not apply cleanly to commits
>> d9dddbf55667, meaning you cannot just cherry-pick that commit to
>> fix the issue. That is why we need your patch to fix the issue.
>> And saying it has a wrong fixes message in this patch=E2=80=99s git lo=
g is
>> misleading.
>>
>> 2. For kernels between 5.15 and 5.17 (inclusive), an additional fix
>> to mm/page_isolation.c is also needed, since pfn_valid_within() was
>> removed since 5.15 and the issue can appear during page isolation.
>>
>> 3. For kernels before 5.15, this patch will apply.
>
> Zi Yan, Guo Ren,
>
> I think we still need some imporvemnt for MASTER branch, as we discusse=
d above, we will get an illegal buddy page if buddy_pfn is 0,
>
> within page_is_buddy(), it still use the illegal buddy page to do the c=
heck. I think in most of cases, page_is_buddy() can return false,=C2=A0 b=
ut it still may return true with very low probablity.

Can you elaborate more on this? What kind of page can lead to page_is_bud=
dy()
returning true? You said it is buddy_pfn is 0, but if the page is reserve=
d,
if (!page_is_guard(buddy) && !PageBuddy(buddy)) should return false.
Maybe show us the dump_page() that offending page.

Thanks.

>
> I think we need to add some code to verify buddy_pfn in the first place=
=2E
>
> Could you give some suggestions for this idea?
>
>>
>>>>>>> Actually, this issue is involved by commit:
>>>>>>>       commit d9dddbf55667 ("mm/page_alloc: prevent merging betwee=
n isolated and other pageblocks")
>>>>>>>
>>>>>>> For RISC-V arch, the first 2M is reserved for sbi, so the start P=
FN is 512,
>>>>>>> but it got buddy PFN 0 for PFN 0x2000:
>>>>>>>       0 =3D 0x2000 ^ (1 << 12)
>>>>>>> With the illegal buddy PFN 0, it got an illegal buddy page, which=
 caused
>>>>>>> crash in __get_pfnblock_flags_mask().
>>>>>> It seems that the RISC-V arch reveals a similar bug from d9dddbf55=
667.
>>>>>> Basically, this bug will only happen when PFN=3D0x2000 is merging =
up and
>>>>>> there are some isolated pageblocks.
>>>>> Not PFN=3D0x2000, it's PFN=3D0x1000, I guess.
>>>>>
>>>>> RISC-V's first 2MB RAM could reserve for opensbi, so it would have
>>>>> riscv_pfn_base=3D512 and mem_map began with 512th PFN when
>>>>> CONFIG_FLATMEM=3Dy.
>>>>> (Also, csky has the same issue: a non-zero pfn_base in some scenari=
os.)
>>>>>
>>>>> But __find_buddy_pfn algorithm thinks the start address is 0, it co=
uld
>>>>> get 0 pfn or less than the pfn_base value. We need another check to=

>>>>> prevent that.
>>>>>
>>>>>> BTW, what does first reserved 2MB imply? All 4KB pages from first =
2MB are
>>>>>> set to PageReserved?
>>>>>>
>>>>>>> With the patch, it can avoid the calling of get_pageblock_migrate=
type() if
>>>>>>> it isn't buddy page.
>>>>>> You might miss the __find_buddy_pfn() caller in unset_migratetype_=
isolate()
>>>>>> from mm/page_isolation.c, if you are talking about linux-5.17.y an=
d former
>>>>>> version. There, page_is_buddy() is also not called and is_migrate_=
isolate_page()
>>>>>> is called, which calls get_pageblock_migratetype() too.
>>>>>>
>>>>>>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isol=
ated and other pageblocks")
>>>>>>> Cc: stable@vger.kernel.org
>>>>>>> Reported-by: zjb194813@alibaba-inc.com
>>>>>>> Reported-by: tianhu.hh@alibaba-inc.com
>>>>>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>>>>>>> ---
>>>>>>>   mm/page_alloc.c | 3 +++
>>>>>>>   1 file changed, 3 insertions(+)
>>>>>>>
>>>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>>>> index b1caa1c6c887..5b423caa68fd 100644
>>>>>>> --- a/mm/page_alloc.c
>>>>>>> +++ b/mm/page_alloc.c
>>>>>>> @@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct p=
age *page,
>>>>>>>
>>>>>>>                        buddy_pfn =3D __find_buddy_pfn(pfn, order)=
;
>>>>>>>                        buddy =3D page + (buddy_pfn - pfn);
>>>>>>> +
>>>>>>> +                     if (!page_is_buddy(page, buddy, order))
>>>>>>> +                             goto done_merging;
>>>>>>>                        buddy_mt =3D get_pageblock_migratetype(bud=
dy);
>>>>>>>
>>>>>>>                        if (migratetype !=3D buddy_mt
>>>>>>> --
>>>>>>> 2.17.1
>>>>>> --
>>>>>> Best Regards,
>>>>>> Yan, Zi
>>>>>
>>>>>
>>>>> --
>>>>> Best Regards
>>>>>   Guo Ren
>>>>>
>>>>> ML: https://lore.kernel.org/linux-csky/
>>>> --
>>>> Best Regards,
>>>> Yan, Zi
>>>
>>>
>>> -- =

>>> Best Regards
>>>   Guo Ren
>>>
>>> ML: https://lore.kernel.org/linux-csky/
>> --
>> Best Regards,
>> Yan, Zi

--
Best Regards,
Yan, Zi

--=_MailMate_A3F55948-B04D-4696-808A-C184576EEF2D_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEE6rR4j8RuQ2XmaZol4n+egRQHKFQFAmKp5OYPHHppeUBudmlk
aWEuY29tAAoJEOJ/noEUByhUR24P/1J16nHlzEK3aPJ1euycS8fVqMpeMEhn3EJI
VsnbU+CkkiC2o0aQYricaGxZRByEXKd9uXmw1ZS61dDdel4zzKsHxd1klf30aAYz
wme1UfTxN2IrcJpPySzwjTQPHHZj3Z8OyOLI96fdeNZHrhl2M5I4M54XLDZTxvh3
pMhvdztJXORPFOZvhaDJp6QMh43/264imsBqlWALN5wVk10Pzb8eI9n2fD++rCmR
Wj/e6Vcv+kVOxpJDJEHWwIhATRNKkuCXq3tfxAL//8A/18GMUCBpmQMqbHNSp68x
NbJFPB+xBjyijLE/nzhg7LVP6AvWagx4aIiFA6r7Pt8FfIFsWPZmsqwOH3ne3G4g
YJYWcHZYMZy2dZFLiKYFVshg2tbpnZwxPD2QaqMfxsdJ+INaXj4G33j8j4J8Jqhm
+W3vq3m3ADQOOnzOLcMUnrN64Ym4fd4kaMN1arEcX/k5cBavS8fVr8F9/PyVF1np
gLww+7YXA5ry4TqHhPMg8+wztlO0eZFj0sVUOQYzkYUvIcrBYqnh/Oq7ceGhCnqm
n7SQCHXWHyIzzP91Ir1AVJXH8MNEjbmT3/nHNzBjoqNgd50xLOmmxP9SJch4wDry
xzkCpeUvUvkYjg3dNREsae2CRbsDPEuCGMu7VBPFa5Pz2dlUT/YOTYViUpwamQHw
m5KCOfuO
=+t06
-----END PGP SIGNATURE-----

--=_MailMate_A3F55948-B04D-4696-808A-C184576EEF2D_=--
