Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65A354A318
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 02:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiFNAOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 20:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiFNAOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 20:14:44 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE9531916;
        Mon, 13 Jun 2022 17:14:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GE4+pJz0iV0OgftYuR8oB+YGvHhz4OiCAUUGGm6f3hT8N7CysaVwekOK1rq4QhQWmVrZbyuMWg4y01SDe6nZfvsVE1Bnfn2HUbcq5t85e1GqRRoSOMEMFDb+HKcmNkRTmtLUVojChW0ymkGBeohL20AS9V9avOxbpyXH3Ggf8XVkJC7tTf20gia9Pwx0EMg3UZk+awFjaGtbPkICqT2K71fE1fVeEFgVnoRe+N+xnNMulPK/WW0AR/1blxIcGsuFQ6kU+Twy2KwcoHy9ZZo3hgUwz3M7rPgriObQMlKWrRZNtLGh1kXLduYWRHadABk2lD2canidP9sIulqStUtFaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSeDNKRGGMHl7uHaPIzHvAHYCAcwJm2KVE6grmKU8VE=;
 b=WJ03VBHDKKnnAOzYT4pCfQjovEapj+okXo4ubx9/6FMrCic90RtYwpLl+1N2gCtgEN6EoauUROM2UTgOcB5PnPLG/4S657iFI90I3EctsVaOWGC4h5B/q8wn8aVeI7A6Tgf47j4NSg4yvED5FNBFSqkaqQv2a74aLctSmhkWRvQVKwe4zGODmnFVDTHuDFFiTn1W2qM9XRvFP3aWakHLR3Tq8ghW1vIRJTtiwn9pJMmRoiZmMXIw80VGFeu7FIeVeD4zjAd7o+mB2udUOoHWtyccQQoopYAghs3n2k8gZVQprkerRAUrAhWj2j0xV1rU5GMSsPsYK9RcxLMpQmcpFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSeDNKRGGMHl7uHaPIzHvAHYCAcwJm2KVE6grmKU8VE=;
 b=ULU729JO8arsAlyMiN/f9xSrLFZlpf81jMzXHGOhT9dT6pkU/qOCqQdy2tBUjPBSRwNgSdnVDhjzE+ikBxYESfy6mJlwaXq4yTD8RX2qWzCZ8tDS1XW29KMgExJOkV0CabrDRFfSmiEHVm6cKfYrOYwxWP0GOUmoPd7Rz59H17xOy5broxkxuf+lXRwUDOVgjeqtRWRFK+o2KJzfAIRe963lY9FfLS1g30rLfi0w65OiEnGa9vUPlFJEn9NAS8TzLK8675fK43lIiFaAoqHOG7WZRiC0KVmIH7puQ8yGmyRMFQa4j+L4FxLI7jx/GtiROtWRbakPnIJ8ISvrUaubPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) by
 SJ1PR12MB6338.namprd12.prod.outlook.com (2603:10b6:a03:455::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 00:14:40 +0000
Received: from DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::2030:d898:6e2f:3471]) by DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::2030:d898:6e2f:3471%7]) with mapi id 15.20.5332.017; Tue, 14 Jun 2022
 00:14:39 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Guo Ren <guoren@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
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
Date:   Mon, 13 Jun 2022 20:14:36 -0400
X-Mailer: MailMate (1.14r5883)
Message-ID: <435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com>
In-Reply-To: <CAJF2gTSsaaseds=T_y-Ddt5Np2rYhk3ENumzSZDZUSXFwT3u-g@mail.gmail.com>
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
 <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com>
 <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
 <D667F530-E286-4E75-B7CE-63E120E440C8@nvidia.com>
 <CAJF2gTSsaaseds=T_y-Ddt5Np2rYhk3ENumzSZDZUSXFwT3u-g@mail.gmail.com>
Content-Type: multipart/signed;
 boundary="=_MailMate_E133FCE1-A8E8-45AB-BB0D-17B9488A3C6D_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: BL1PR13CA0145.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::30) To DS7PR12MB5744.namprd12.prod.outlook.com
 (2603:10b6:8:73::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a34709a-ba82-4663-7b28-08da4d9adf70
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6338:EE_
X-Microsoft-Antispam-PRVS: <SJ1PR12MB63387D4177D3BC3EB1B0A1A3C2AA9@SJ1PR12MB6338.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X5dPkwetwLNei7n044Mk5iIamBoGC0UlsA46FFqGPpaLpax7ucOwZPrdk8bNecxWZm45pPLD0Y5ZJXJBF35mCZSuyplOCv0o7km2FGCKrQiJBwJpRzunyjrEBHCAqyqV/awlLHk/h3d4EWVnv7rPF51zC3MWwcDWm7u6Nz6UX93se1jwapwvj5iQpVMsEpeBWY++Pdw2GDE5sSNGr4dp/ZuUtz/a3mh5k4YSEIKF/lQ0TdvEM3nZbSLANzcgVCG3yOTZD6qLchcsniHkPRlNoNIpzBRdgRpSfo5y/r2tfqYRnBpX0CWL+OuE6vdFzk9VXI7gvAiMBg9Txp0Zo6fFP4/Nrmcia1HJV+OwXJeNkWxhpvSq4boH4l9EmCZ6l3vKTN9ZXNwDdWplOAO8ckUbwexmeEa8tb+oyTkKZy/0HNiWck+E3ghuWFzj3ELkc2cimT7Hqf04K3prZxrt05TJpQQfLNgPKB81dkN8aKKfdnmd1+yySaubvexuSSSEz4m9GE6KWhr6gYCcsXsnTcwWzWi7NdTW/CioKe0IrGsoDW6BK7OPJpGAcGjTS061vI25sxFg0e5oPj20zFLvz996959hsoCjoVAMwjIA5Bk5Z1y68dcGh2umUo57dcHM6YXSkz+LFEKv4rQlW+Kx8L23E0vsgk6vZh0r6qOy41TMOM1Oi1JIiNsmmoPZxqMsR0pzjjgt2JE5uCV9cyjxPF83xUHzqWAXJ4YG2awNuKjsKR4I0MZzwqPKIYp4bxgvcPtalERkzNAw+PW9RljyRppgKcUi/ElMSS2Oyj/sC57JRRYUsqZ800qWB8oAZve433MX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5744.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(316002)(54906003)(6916009)(21480400003)(36756003)(53546011)(66946007)(66476007)(4326008)(15650500001)(33656002)(38100700002)(2906002)(66556008)(86362001)(6666004)(8676002)(8936002)(966005)(6486002)(6512007)(2616005)(83380400001)(26005)(508600001)(33964004)(235185007)(7416002)(5660300002)(6506007)(186003)(72826004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUg0VjQwVkRPL0tkS05YR3BGUkNpMFZqMzV1UkJ6am1HUHpMOTdSWmUvZkln?=
 =?utf-8?B?SE9XZzJMZnA4cmNkU0gwRVpYVjVTbUYxWUJMRzhhZWlVUkZqdThMSzFpbEVx?=
 =?utf-8?B?VEd1ZC90cVgwNy8za1daWko0em5NeWsyQStNSDlnRHFaK016TzlMblVVM0pR?=
 =?utf-8?B?TWo1S0IxYmV1RTZCTmR5ZFk3Wk9FZkhuTFpoWk1NeEZmdmNPbXR6NnVYN3Rp?=
 =?utf-8?B?WkNZcHRyeFVsazBhOExZdHA4WmVDbjU3bytEMmIxYkRZc3I0cU0zMDFwT0Jj?=
 =?utf-8?B?Z24wZVFzcm40RkNKNWJPaXZPMG9KZ2dWTVN2QmVHMW9Ga2VHSndRamhIY1pz?=
 =?utf-8?B?bVNTLzlNWEt6S2Z3UE5rbzRwbjJ2UVZBVCtXQmVhZ21DNVNxdE9nYkFDVHVy?=
 =?utf-8?B?RkdGWHNHLzVjZnVJSlhpcUptR0pKais5QzI4bGN6akNSa2NvK3B3TmNySDRF?=
 =?utf-8?B?QzkrNkVqUVRxakZRMnprOUh6eUczZ05DTEFaUTMwZXFuVHlzemVMUWRPSUgr?=
 =?utf-8?B?NGN6NlRSeGlBZy9JQ0Z1dFNDT2Mwakd0VEZwWjd3ajFTVkZJT0JSa1dXS002?=
 =?utf-8?B?ZHJZaVJLMmVUOWRXUG1uK3lOZkZiOWtqZ2g4aG4ySXBtSU9JVG5lTHpaWXlx?=
 =?utf-8?B?akN0ekNNaFBGaU44dXBjaXVMd043cjR6cjJUWm1nWmhUVURNS2x0a2pIN3h5?=
 =?utf-8?B?V01tUE84TUxqZHRpVUtkWTd4L0NZWHBrQ3ZuMUZWTnJCdzYxdnJFL3hFdkpw?=
 =?utf-8?B?ZVN2aHRTRnd2RnIvbXdvWmdmU3d2RFhOd1RnWWhienF0ZTNLbWxqTTkzd0R6?=
 =?utf-8?B?TW0rZmtJOFZZS0ZyS0hSN3FjNVp1Tnh6L2RoWm0wV0dCMFFaeVVTVm5KK2Uz?=
 =?utf-8?B?MitKZTZ6aEFLc2ZCQzR5T01lVHlGTFNFZ0ZlV0VadWdmNVVNMVY2ZTU5a0J6?=
 =?utf-8?B?RW5wMm44bTZxbDlLKzFmL0hiWXNtNEVCYVExTW1ERkZkYlkyeVpFYTNYSDFY?=
 =?utf-8?B?amVORXcrUllHa0NNeEZIM3JvamJyUFhmTGV4RDB2TXpzd2pSeVlqcDFhTUFa?=
 =?utf-8?B?SFp5QzNBbHFNVmVqc3NWUUZzc0ZLSnJ6YjJqUGNSNkVqV0RoSVd5aGhwank4?=
 =?utf-8?B?eW1UQWdoQlJHZzBad2IwZmVFbzFNbDhHeFFjVXM0Y1RJcUVoTllyRTBUMGJt?=
 =?utf-8?B?dVdRbWZjWndiZFd2c3hKSEw0SUxDejRRdjRtNzZLNkZiWGVQMk5pcVFlbTQ0?=
 =?utf-8?B?ZkltR2dXc3VXSlBtREZ4b283Ukc5N1U2L2dxVkNuL3RMYmI3aGxMWFBadTdl?=
 =?utf-8?B?SmtsQWEvclF4T3pXaFo5L0llNkxhVTNpTkh3VWhlSXduQW1CVHBKbDVWZWZJ?=
 =?utf-8?B?T1VsN2tmNVcrRDhRb3FWelVXYmV6Z3NsOWNwVHhtSVdFSDZUaHFXdktJK25Y?=
 =?utf-8?B?MkxON3p5cTU3NE1mVU8wWTZMb2l0ZmRKMVVKN0djQkt6c09IWExUbkJZMW50?=
 =?utf-8?B?TjhQdVJXbUhSZTQ4NkVwUS9sV29wY2NSQXRUaWlUNXpvUFYvN2FHN2Uya1Nk?=
 =?utf-8?B?OTRZOUZnS0tpem1vaGZsY1F2b0dza25uZXMxK3g5YTJrVEx0bmc2YnhObEU4?=
 =?utf-8?B?UzdZemVGd2VQMHBqaDh5YjhHN1FxTjBNaXRJdE1xY25WUFFFSEpPbHQxeUpO?=
 =?utf-8?B?VGMzaU15MGdmdXFJcGp5ZjJtYndjVlVNdG4xaWlSU1NMcXdjYjlxdnFQYW5j?=
 =?utf-8?B?SGIvQ2JrL1Z0Vmk1b1VTMTdVd2dBRlQ2VnU2STdOR2F4NitrNkRaWDVGYTFO?=
 =?utf-8?B?RkJjVCtodE1FdE0zeS9Rc3NGcjZqa1JXK05qT3JBZUtLMVVVbENRK1RtVDQv?=
 =?utf-8?B?bmRORUI1T3VCVW9zcElHWXM4OFFyN0NzTHRvN0ZXaGxVaksrODd6aDBNN0Jy?=
 =?utf-8?B?SjdmRmVnWE5TNWcxeDFKUUdJMjdrR1pxZENGQW5zOWk2Sk91Q2d0M25wRU41?=
 =?utf-8?B?UmJtY1hHc01lMlVwR1FqY1NFS2JuOXlvWmtwKzZSYlB4dzVZblAybFNnWUsr?=
 =?utf-8?B?NnRwK3RlN0lkeXQ5a0t6LzV6azAzOFowSGczck5BU0phZ0hKZVNBVXNTSkNv?=
 =?utf-8?B?bk1HQzg3RUFLS09obFdEcjh1dzFmVnoxckZ1cVNKQlNmOXRpenBxRVo1Z2tT?=
 =?utf-8?B?SlN3N1FMempIbktPaGlwdHRqS0sxMkNzbVJIQ0lFUDk1djBiVzRwWTZYYkFC?=
 =?utf-8?B?L2sxKy9HbmJGSGVVWVFCVWlaQ1hqbUNZanB5cXJNekErdVdHL2JseENkYUJQ?=
 =?utf-8?B?L1FSUy93NFJJU3NvMkk1a2l1a3lEc1hqb1h1MHFpSUdyTWlQWEpZdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a34709a-ba82-4663-7b28-08da4d9adf70
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5744.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 00:14:39.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlj3pKRGNd3G1pmucLi5/5413BBdmUXz+cW1QmCww4EgULfQmN4ch5qMnQAfkVyk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6338
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_E133FCE1-A8E8-45AB-BB0D-17B9488A3C6D_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 13 Jun 2022, at 19:47, Guo Ren wrote:

> On Tue, Jun 14, 2022 at 3:49 AM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 13 Jun 2022, at 12:32, Guo Ren wrote:
>>
>>> On Mon, Jun 13, 2022 at 11:23 PM Zi Yan <ziy@nvidia.com> wrote:
>>>>
>>>> Hi Xianting,
>>>>
>>>> Thanks for your patch.
>>>>
>>>> On 13 Jun 2022, at 9:10, Xianting Tian wrote:
>>>>
>>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check i=
ts migratetype.")
>>>>> added buddy check code. But unfortunately, this fix isn't backporte=
d to
>>>>> linux-5.17.y and the former stable branches. The reason is it added=
 wrong
>>>>> fixes message:
>>>>>      Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallba=
ckable
>>>>>                          pageblocks with others")
>>>>
>>>> No, the Fixes tag is right. The commit above does need to validate b=
uddy.
>>> I think Xianting is right. The =E2=80=9CFixes:" tag is not accurate a=
nd the
>>> page_is_buddy() is necessary here.
>>>
>>> This patch could be applied to the early version of the stable tree
>>> (eg: Linux-5.10.y, not the master tree)
>>
>> This is quite misleading. Commit 787af64d05cd applies does not mean it=
 is
>> intended to fix the preexisting bug. Also it does not apply cleanly
>> to commit d9dddbf55667, there is a clear indentation mismatch. At best=
,
>> you can say the way of 787af64d05cd fixing 1dd214b8f21c also fixes d9d=
ddbf55667.
>> There is no way you can apply 787af64d05cd to earlier trees and call i=
t a day.
>>
>> You can mention 787af64d05cd that it fixes a bug in 1dd214b8f21c and t=
here is
>> a similar bug in d9dddbf55667 that can be fixed in a similar way too. =
Saying
>> the fixes message is wrong just misleads people, making them think the=
re is
>> no bug in 1dd214b8f21c. We need to be clear about this.
> First, d9dddbf55667 is earlier than 1dd214b8f21c in Linus tree. The
> origin fixes could cover the Linux-5.0.y tree if they give the
> accurate commit number and that is the cause we want to point out.

Yes, I got that d9dddbf55667 is earlier and commit 787af64d05cd fixes
the issue introduced by d9dddbf55667. But my point is that 787af64d05cd
is not intended to fix d9dddbf55667 and saying it has a wrong fixes
message is misleading. This is the point I want to make.

>
> Second, if the patch is for d9dddbf55667 then it could cover any tree
> in the stable repo. Actually, we only know Linux-5.10.y has the
> problem.

But it is not and does not apply to d9dddbf55667 cleanly.

>
> Maybe, Gregkh could help to direct us on how to deal with the issue:
> (Fixup a bug which only belongs to the former stable branch.)
>

I think you just need to send this patch without saying =E2=80=9Ccommit
787af64d05cd fixes message is wrong=E2=80=9D would be a good start. You a=
lso
need extra fix to mm/page_isolation.c for kernels between 5.15 and 5.17
(inclusive). So there will need to be two patches:

1) your patch to stable tree prior to 5.15 and

2) your patch with an additional mm/page_isolation.c fix to stable tree
between 5.15 and 5.17.

>>
>> Also, you will need to fix the mm/page_isolation.c code too to make th=
is patch
>> complete, unless you can show that PFN=3D0x1000 is never going to be e=
ncountered
>> in the mm/page_isolation.c code I mentioned below.
> No, we needn't fix mm/page_isolation.c in linux-5.10.y, because it had
> pfn_valid_within(buddy_pfn) check after __find_buddy_pfn() to prevent
> buddy_pfn=3D0.
> The root cause comes from __find_buddy_pfn():
> return page_pfn ^ (1 << order);

Right. But pfn_valid_within() was removed since 5.15. So your fix is
required for kernels between 5.15 and 5.17 (inclusive).

>
> When page_pfn is the same as the order size, it will return the
> previous buddy not the next. That is the only exception for this
> algorithm, right?
>
>
>
>
> In fact, the bug is a very long time to reproduce and is not easy to
> debug, so we want to contribute it to the community to prevent other
> guys from wasting time. Although there is no new patch at all.

Thanks for your reporting and sending out the patch. I really
appreciate it. We definitely need your inputs. Throughout the email
thread, I am trying to help you clarify the bug and how to fix it
properly:

1. The commit 787af64d05cd does not apply cleanly to commits
d9dddbf55667, meaning you cannot just cherry-pick that commit to
fix the issue. That is why we need your patch to fix the issue.
And saying it has a wrong fixes message in this patch=E2=80=99s git log i=
s
misleading.

2. For kernels between 5.15 and 5.17 (inclusive), an additional fix
to mm/page_isolation.c is also needed, since pfn_valid_within() was
removed since 5.15 and the issue can appear during page isolation.

3. For kernels before 5.15, this patch will apply.

>
>>
>>>
>>>>
>>>>> Actually, this issue is involved by commit:
>>>>>      commit d9dddbf55667 ("mm/page_alloc: prevent merging between i=
solated and other pageblocks")
>>>>>
>>>>> For RISC-V arch, the first 2M is reserved for sbi, so the start PFN=
 is 512,
>>>>> but it got buddy PFN 0 for PFN 0x2000:
>>>>>      0 =3D 0x2000 ^ (1 << 12)
>>>>> With the illegal buddy PFN 0, it got an illegal buddy page, which c=
aused
>>>>> crash in __get_pfnblock_flags_mask().
>>>>
>>>> It seems that the RISC-V arch reveals a similar bug from d9dddbf5566=
7.
>>>> Basically, this bug will only happen when PFN=3D0x2000 is merging up=
 and
>>>> there are some isolated pageblocks.
>>> Not PFN=3D0x2000, it's PFN=3D0x1000, I guess.
>>>
>>> RISC-V's first 2MB RAM could reserve for opensbi, so it would have
>>> riscv_pfn_base=3D512 and mem_map began with 512th PFN when
>>> CONFIG_FLATMEM=3Dy.
>>> (Also, csky has the same issue: a non-zero pfn_base in some scenarios=
=2E)
>>>
>>> But __find_buddy_pfn algorithm thinks the start address is 0, it coul=
d
>>> get 0 pfn or less than the pfn_base value. We need another check to
>>> prevent that.
>>>
>>>>
>>>> BTW, what does first reserved 2MB imply? All 4KB pages from first 2M=
B are
>>>> set to PageReserved?
>>>>
>>>>>
>>>>> With the patch, it can avoid the calling of get_pageblock_migratety=
pe() if
>>>>> it isn't buddy page.
>>>>
>>>> You might miss the __find_buddy_pfn() caller in unset_migratetype_is=
olate()
>>>> from mm/page_isolation.c, if you are talking about linux-5.17.y and =
former
>>>> version. There, page_is_buddy() is also not called and is_migrate_is=
olate_page()
>>>> is called, which calls get_pageblock_migratetype() too.
>>>>
>>>>>
>>>>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolat=
ed and other pageblocks")
>>>>> Cc: stable@vger.kernel.org
>>>>> Reported-by: zjb194813@alibaba-inc.com
>>>>> Reported-by: tianhu.hh@alibaba-inc.com
>>>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>>>>> ---
>>>>>  mm/page_alloc.c | 3 +++
>>>>>  1 file changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>> index b1caa1c6c887..5b423caa68fd 100644
>>>>> --- a/mm/page_alloc.c
>>>>> +++ b/mm/page_alloc.c
>>>>> @@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct pag=
e *page,
>>>>>
>>>>>                       buddy_pfn =3D __find_buddy_pfn(pfn, order);
>>>>>                       buddy =3D page + (buddy_pfn - pfn);
>>>>> +
>>>>> +                     if (!page_is_buddy(page, buddy, order))
>>>>> +                             goto done_merging;
>>>>>                       buddy_mt =3D get_pageblock_migratetype(buddy)=
;
>>>>>
>>>>>                       if (migratetype !=3D buddy_mt
>>>>> --
>>>>> 2.17.1
>>>>
>>>> --
>>>> Best Regards,
>>>> Yan, Zi
>>>
>>>
>>>
>>> --
>>> Best Regards
>>>  Guo Ren
>>>
>>> ML: https://lore.kernel.org/linux-csky/
>>
>> --
>> Best Regards,
>> Yan, Zi
>
>
>
> -- =

> Best Regards
>  Guo Ren
>
> ML: https://lore.kernel.org/linux-csky/

--
Best Regards,
Yan, Zi

--=_MailMate_E133FCE1-A8E8-45AB-BB0D-17B9488A3C6D_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAmKn0u0PHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqK8CcQAKE59rmqKVsp44VmXx/OxJPqqqmeIMs9ZRiQ
Io8qwpb57sh+vwWeHcI3RikWsNvfcECCVQ0dgHwM32NZAdl3XT7f+e1ufaoRRUMZ
H8roNF06NqWE34+k7TPRvNByRQhRZdu7iuJcCr+xF3a8XNc85A2IxHLlZJGOzDxE
y7cWrBrrIJs58xP294cRGN9Nc2ZS9UjOTiMpN6PeqfJLfh6ruoAIv8JKDRhf9ckV
fOaRR+nZQdBa+XBx7mz7uSLU1J3fjdOxCrRsFMKQv5p4PjRAD11JZ9pQ1dRFmqLd
WPqNWdz37jmQpEATBBBBGlYRazLHAqQ2rUJpOaLy0w3qzsrqeTC846fE6VUkncBY
pHM8UjPuT6auBGHjp9hI7x92gNA5d9ModqnG4ahS+DBYzI7PqNN24aMHrR8eRJKm
Uh8vlb+McK0hq9VfKZ6SLQfJQisDPwPdaewezcZSHJb7vWUTZ+f8lPY7x67Nezcv
FbPlO+Qx04fCYjKlf62Z/JUpq+sy1LbiyZBijF3Y4cERcYR21/05cGnXD+INeBts
+dNLGacYiETYoaft5iVAnXkyYtng4ZBqXzSz/0G2q707kziL8xY6YIn7/a/+UMo1
smu/yxep/DcLrCulXDyGr0uxDrnZyIo7LkrTywBDDHrHFC94Ul+FLEWZGMwvWLIP
o29BWob3
=NSir
-----END PGP SIGNATURE-----

--=_MailMate_E133FCE1-A8E8-45AB-BB0D-17B9488A3C6D_=--
