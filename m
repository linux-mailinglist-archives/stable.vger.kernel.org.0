Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5502D5A0596
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiHYB01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiHYB0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:26:25 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DAD7C773;
        Wed, 24 Aug 2022 18:26:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnPTnBqFfmPL2NcXS4NB8XihRMqkAi5d0ad7d73FCDr+2Anh4pOXeMg4Km8jOYS5I45toWJg6v6ICVuru5Z89vWOXSJTS5in1bt7FzfGcKQypDKSDwxhS8gmDgROvIakpxRABe3/3C0mW9dw5isa57xM6rofXEuQXNuAYS9eWKxxtYHxKH/ZPJ9fH1xW6j2ocxtSNlQ0MJ6VOZLCgZ1F24lIhh8EacKoo89lMChDlWfuguULOEf3PcBR70xvwFDIdbLaylUGJnRydPAFjAsmF26qAv4BkBpxUbZm0DtQ+lIi9lPUyqpYnyaW+sx219lmyvf/KxLFLFUTl/ptK4Hwfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/2xB/l4GOdJhsTNw5WHLvslgnTOYMKHQTiJdb4H96U=;
 b=fYZRtM6snEnRXQJfZ7g05DhVYazA7pcIGHO+nYZ8zvK7sml+lexWrTuLMWIUvBGsiIZ7Gaf9DyXx1AFqUJKemAWXb9pJ+BmG2MaIKcoelrWlOrfpIkuTPkLwEFGDGYAlt5sNcF9u9Ozx3MUvVK/maUch63jwjexfWeZUS9ZSOO9xI6kMkoRpigmrdNOgt9G9eYcQsvTFuGJr0rZPbThd7G4nkUK+vK9NnHqz7w6t5U9G3TX1mJEuUKXfY7OaKNguGvCteDNXb+DmVR6+MifFDET0B9M8YLWd70qmOCxWE4Xevg3uTifwMKS3Z2fsaiO9mjQbJjWnV/jKP40eVVgJmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/2xB/l4GOdJhsTNw5WHLvslgnTOYMKHQTiJdb4H96U=;
 b=fjB184xZAeq351b3PV22/zgrJdVU5iE1YW5ZGx8nQWw1KTcu4mg00Rl3j7f3nsFJlFYMz8C6ZbJu4k97JnRIoPZkfCmfo/ztUomEF4wUAUclEzbN9Gt8gDfTg+pvSlm2CaB/k8050PnRakszdSe1K/TFjVP9Uorc32kwQSQwyU7WS8+gGZjDbKKHNeDALEtjDK5l+MykOd+WwlUIA1blxdAZ523voiXMcowEkyAd6PGyyLDjXCgUcAUdjyIasqge4tlyvSgdbHIDdki/zzcEY4P7jEgW4UKXiYCzDQkJSCdQwaOSXgQnrqd9TijZy3xpJ9AmE0ZugO1JQbe8m7Q0EQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by MWHPR12MB1310.namprd12.prod.outlook.com (2603:10b6:300:a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Thu, 25 Aug
 2022 01:26:21 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Thu, 25 Aug 2022
 01:26:21 +0000
References: <YvxWUY9eafFJ27ef@xz-m1.local>
 <87o7wjtn2g.fsf@nvdebian.thelocal>
 <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
 <Yv1BJKb5he3dOHdC@xz-m1.local>
 <87czcyawl6.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Yv5QXkS4Bm9pTBeG@xz-m1.local>
 <874jy9aqts.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <87czcqiecd.fsf@nvdebian.thelocal> <YwaJSBnp2eyMlkjw@xz-m1.local>
 <YwaOpj54/qUb5fXa@xz-m1.local> <87o7w9f7dp.fsf@nvdebian.thelocal>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     "Huang, Ying" <ying.huang@intel.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Date:   Thu, 25 Aug 2022 11:24:03 +1000
In-reply-to: <87o7w9f7dp.fsf@nvdebian.thelocal>
Message-ID: <87k06xf70l.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0211.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::6) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e12795e2-6eba-498e-22d9-08da8638d0d7
X-MS-TrafficTypeDiagnostic: MWHPR12MB1310:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Em6fWfEa6jV+0W6lIu0Lj0AihGN7P9PNIoQcZabq20ksKksocs0lP4KqTd3wD7lXw0UjbgNI9zSU4O6EquClnXd0/o4B2yK7iCvRfXgAmLCBWgJcjD603ZuEXiuVuUvO3/LYrS3ovUdW6KGR7byoyyegBQ/hhw88jG0S/N8zAAgvEgu07xauomnjAea52gXV1mmnseg0LhqoMAZIw3RfhROiTpZHdjffA+GRQfc1BsACC/NhekzJH4nDZXjHPRVWEUxtWjlULWMt7C9h6PPhiZYGELeTO2RgiS+WgPJczLKSgKeD2I9gMY+zg1WecB9Hy5ZVXL4oYgBZj6DVT+VIHDLKNpAOTGu1oM+eLvSTza3mR/pxj6wi8qc+XBLFeCXMp2ACfudJ4Yqi4VAyjIPQH8EaqktVrXkN64Msgy4m/MzPlloUqUwgDpxx8Xm2r2VC4yWcqjzBx+IqTw0UB8Fk6YP2Dty/RK+qwfXovZbox5TsoOqUf/ea4TNv0yeOuNK7gSKitu0qZUkwa0d6sQeWCG07p8GKBEMFm2Cxu+ixYMMaICnp07hRRNQvOVQSjpTOcDshlFfKGBXx7sj1ELF3LT9rk9NI5n3JYKzpsunG/bxJOPhe59FOZBsXnoOeWrgC2N2ejVsDSd42JxnnBeU043rfewX2Jh6i+nqCNC6lbgqF780IeS4w9oMC4JnZZxwZtx+dLdPisfctaQKb/qvlC5TGbZtMV7XyX35RHVCRktJ0DhGusZ0fTMaehR6JIGztdac9uCs1qjy80xQthAQFc582e22Pwfppjyb7IQUSRO17rfY22ifbCMtyPC4c5n0leCemvwl21RpsKyJ9dghsYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(478600001)(186003)(966005)(41300700001)(83380400001)(26005)(6486002)(6666004)(6512007)(6506007)(86362001)(9686003)(2906002)(7416002)(8936002)(316002)(66946007)(4326008)(8676002)(54906003)(66556008)(6916009)(38100700002)(5660300002)(66476007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uL0jr2OXpEjBCvZW+EDzn1+ybBMuv0vBE6en+hzHvVBTTHPMHGv1y5VyFKoZ?=
 =?us-ascii?Q?DmgTSArw0ZwLCNr8bcht7dnG/II9ZQXVes4r2WUo9mh3vL6G+T+gpis0uFFb?=
 =?us-ascii?Q?iFOlNp+l08eeQV4EpPYBF5KMtGPkLHXfB5bPXmfnHO/QadPhJJSVEaEB9zuQ?=
 =?us-ascii?Q?IF4ksSkMKUMg0b8CrP9AwGYqhNdWJG+8YlOW0EQY5m2ng5FLThk7V6WBTf4X?=
 =?us-ascii?Q?pOs2LKLqD+1DKgl2gdsu24OABlJJwhbW7M5Z6l9/TJ803XVsEp64YESseoRO?=
 =?us-ascii?Q?/S/91VosCtH5dUezFomUJUJuj+DsQG8zw7nv6wXSjhbiaDQ7N3aleoCPGyt/?=
 =?us-ascii?Q?Kd7raI4GsAGaQtLQG9SsseYTAdcgZ0iURgcs2gjJYicuTe+YiPN1q6BtW2N9?=
 =?us-ascii?Q?Mvj7WLt+EGy5HO4B81aWMZIvEHz5jNlti3IL0XjxtxYgePePCgGehjihtCK8?=
 =?us-ascii?Q?/B5fN0hcevxz+0sh4IUUcdF+yb1PzWOHASIPtukys2jfU7oJ+X8r+a8O667e?=
 =?us-ascii?Q?w9+3xKPX3fXRVEJUL6e/7UIyF7kPA3t+C/MeeCafhW/DoctqdljTZup9udh+?=
 =?us-ascii?Q?ho8kfwDIPx++4qSwKH4I0t9ltiLwtv+DJMSA0kk2IWoCgHJaiypkNbIvNt9F?=
 =?us-ascii?Q?j/H9/C3LwKGrzw/dS12QHTOlT2nGSrwT7LYGUlDVk/DHdEM2GhwN9Zdi++Cd?=
 =?us-ascii?Q?Q/JEbXqRxapTGKrdr2dOEjcBOy3jxi3X3BbAv5Me0y50voWJeGuYHg0iGiUl?=
 =?us-ascii?Q?9Du6WHwXGjIK3XZ5OuOK68o3EMlyU0dvPcJhnm8qiZIZW3GZgCAR77yLWBK6?=
 =?us-ascii?Q?Op6XNLF6mnkDvkP3H473zy6IYgo4ETe9k+zJ48Ylva3X9R9oIgya4M1Q29vW?=
 =?us-ascii?Q?1cszEQFDXbZmNC5aGcP4AhwNnMsHnyzoiFI4qS523l/P9u3+pkkj8SNkpmm/?=
 =?us-ascii?Q?FtXxhEhqb/LErJMqJ7djuD6TM5TKho1IM+grjtmUWmPf9Up5Jc4N88WPVJ5L?=
 =?us-ascii?Q?1yO7lQTatey4q7v7HCsKKO8bV/GLzvQJZQKxkGQF+xWnn1ENlQ6HmpKm7BAd?=
 =?us-ascii?Q?6ktCvuG6jT6xaD84umn300U0+FPiok85x1og8wUU+edIPxb2WXyX8pZWiyoH?=
 =?us-ascii?Q?TSsL/D6nHGgAGexqT1ybSm5ezXWZD951EGE1tc6y0t8b6eF0Y5+WJqfPFWoT?=
 =?us-ascii?Q?KoY7CXw3eXDiWqxlV1mxUb5UB9sQGYsdNSLdmdW0tuj73q0QRl4Hdb0iAcIg?=
 =?us-ascii?Q?CLqlvqW/FyzH1DXqOrQeFZud6O2AnReWJR8x2uDj0fbsHrFhXPn0qH41ZvOQ?=
 =?us-ascii?Q?9M1ZncPrCyf6EI7ilfrGZnZ4f01QTqxn1fyArCEW/nx7smKFvJQH5ntHqwWx?=
 =?us-ascii?Q?r/n+r0tvkN2O3+gXeeQ4Nk2BVBulmCYotaBGT4IZTbe/99jduzOR5B026WBd?=
 =?us-ascii?Q?S/G9jvcAQtf7gdYHHxEaa6mMAaoasa44n1XZdj9h3gbr6XVlq+ovf0kNjM52?=
 =?us-ascii?Q?pnlBzj2PcynGfxyUfV5KvjTOy5CbkhQBrpYb/HGlS2MvRu6e+uUDXeCpFffC?=
 =?us-ascii?Q?9lFTKMox8GTLfOsO5F25XZGuzZGHiStUbumzIGRp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e12795e2-6eba-498e-22d9-08da8638d0d7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 01:26:20.9365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HixXPSaQtpS8TCyhEhg4jUD01LHDtam6J2xIfM7kDTDRYtFpjF0LLR8OE1Jp3wQqm41Gfjpa5x/UwDIYCGEKjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1310
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Alistair Popple <apopple@nvidia.com> writes:

> Peter Xu <peterx@redhat.com> writes:

>>> But it's kind of against a pure "optimization" in that if trylock failed,
>>> we'll clear the mpfn so the src[i] will be zero at last.  Then will we
>>> directly give up on this page, or will we try to lock_page() again
>>> somewhere?
>
> That comment is out dated. We used to try locking the page again but
> that was removed by ab09243aa95a ("mm/migrate.c: remove
> MIGRATE_PFN_LOCKED"). See
> https://lkml.kernel.org/r/20211025041608.289017-1-apopple@nvidia.com
>
> Will post a clean-up for it.

By the way it's still an optimisation because in most cases we can avoid
calling try_to_migrate() and walking the rmap altogether if we install
the migration entries here. But I agree the comment is misleading.

>>> The future unmap op is also based on this "cpages", not "npages":
>>>
>>> 	if (args->cpages)
>>> 		migrate_vma_unmap(args);
>>>
>>> So I never figured out how this code really works.  It'll be great if you
>>> could shed some light to it.
>>>
>>> Thanks,
>>>
>>> --
>>> Peter Xu
