Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B569C5A1C19
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 00:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243557AbiHYWSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 18:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiHYWSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 18:18:54 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADE3956A6;
        Thu, 25 Aug 2022 15:18:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xc/PwzyMDFgp8+o0VbTSdQOhTbG6l9wxevnX+sDWN9GMngnV/pl1OZNtr0PnMVAzRM2Sog/XagZyI2CNtzHye4bj40xQF0ec6X+Wsb4j4inlY5eM2maLf7KxNqq7KeheoLir7eC2BrB/+uE3fwn1AIh2O3+eJvcxfGNbALo3sE49eZxYwKDqC4prgf6boTOKfl58kk2IYs2Uu5yl9Jt9r4tHp95e0uquwdfLGonegwo9HpYqzIjS9Cxawk3oYvOpXUdvUpsc34zQE6u0qGhVqYwN6nFl1SC0MufnKtZwXcN6t+N+sU0lR0j8VA0nOjTJCWaQW2j5ID+tx4dXq5UV2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTLjAYJ2VHe85atSfY1n09uCICnlvOz5N5spgDcZHCE=;
 b=P1Ma8A6ECTn1SrltX26BT1gkQGmgroAqq8VoIUgc4xZKq/i+vKWxFQJYNaIrGe2IRfhEN5ukyuLeyzhfI7ITkpx239X6vIaQz08IDt6nXaEJu1OHzGg4tUQqKUhhWdlg8dQKSPnQ3WWBFgjaM5HdbOo/7mRbQcmriH4ABusTEnD9n2LJn0kXwGx4+Ph4C7Ve3/BFgYbNsUuIqAhjJFPLmkda0XVMx+u+aNGpH9f585azhrURTLbErRS4+0BbZWrpveUvNv36lR+Esnqp+sc0RpQbjWqrtdBvpVJc+HlH9T3cQP3nauUOdgkVK/d5FEfvZ4b5z3P9BL4dC5+Ckl5IqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTLjAYJ2VHe85atSfY1n09uCICnlvOz5N5spgDcZHCE=;
 b=GoKVwjgRLJ6qGnOownEXrvJ5csSflVdY1g/Lo4lP+/8CTxH4byEbClbM76I8SbTU05Le4qfnrL7N6qV7EwBjCARXv/0cQS8G2FzX2nbq5MF68dzvAKnW0osVL7Aze9raJNd70Qxuv90PhvN3Xi/9XDi6uSGRyNnzpoWa3g6fzFpq3MtMWMXV++tri98P961f4jfd6/w3fwXcjBy+Gr4fqCSAm4gMFS1KLqlvw5DHm8A7K11mfGGVRtYBRHMvEQB8ZbuoixdBMdejfKS7BoswSEHkZT/fpjKNvw0UlwCQzYGjaaDWBga9kHp66Wu4t/HUTJxRz0l0lCWHMLPS2kXLKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by BL3PR12MB6547.namprd12.prod.outlook.com (2603:10b6:208:38e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 22:18:50 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Thu, 25 Aug 2022
 22:18:49 +0000
References: <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
 <Yv1BJKb5he3dOHdC@xz-m1.local>
 <87czcyawl6.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Yv5QXkS4Bm9pTBeG@xz-m1.local>
 <874jy9aqts.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <87czcqiecd.fsf@nvdebian.thelocal> <YwaJSBnp2eyMlkjw@xz-m1.local>
 <YwaOpj54/qUb5fXa@xz-m1.local> <87o7w9f7dp.fsf@nvdebian.thelocal>
 <87k06xf70l.fsf@nvdebian.thelocal> <YwePm5lMSU2tsW6f@xz-m1.local>
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
Date:   Fri, 26 Aug 2022 08:09:28 +1000
In-reply-to: <YwePm5lMSU2tsW6f@xz-m1.local>
Message-ID: <877d2wezll.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0064.namprd17.prod.outlook.com
 (2603:10b6:a03:167::41) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e68454b-54fb-461a-886a-08da86e7c8e4
X-MS-TrafficTypeDiagnostic: BL3PR12MB6547:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OPijzWMSrwdL0h3IhIsMOkn0rFeG8AyBJI22/eOg29snSS3urYPMdXI72sBC1/IqQarRkxpnkGHpzQ/SCh+YqWc8sceyJXBwaTpljyMNRpcIsYKZpfg66QLNPg7cLko7TqLEWjeu0Nm9Se+v2BkhZK+tkAowat7LJmLQ+gVd0o5x9+2WA0a13e7A33226/obPcsSBP6XwddzOv3rpsbj2f6XKKKQfEPfyHe46mm0R5FC2m6WQiKNLMFmFVJCs5NzbLH/PYHcMWFrUuOoKXjqGcNBkL16cnLPPn0taYaMAsBh8GK6ZYEuswgUveF3tU3Ah/8Pxgrli0/gwFpsM2mVZBOtCxwVYD1U/2yMwvnPGg7F931PblOQlmwiI42yjKL5NBbNjf9yo8MCRo02I7FNi1g9iKBDrJXbMlxKKwbeWKapRHncTGAdZYE84X/M3kgwSkUxhNKc5Ac0A48J2uEc/MfARNbIWDxawgow9AVLImGURnb0Wbrc84TJCndvChb9Qo8zK/sNs+KPRm148W75SFeRJhLFTIZ2mrqiNhyEFz1jjyaKGDLu5w4OfwMrizcTelBwuOA1E//RmcwFo00mv1eiO3JsFhe+fPreQJEreusmyiUWUrkW+XBEXkGn/BJikiiEjl9RQ7Y8dIILIK7uAntPbwTujqHNf77fim/UwLG+Vgh07WAEU+9ke3jAPuFk4wc66Q17keIG/w6OuJdf9KuymgjGNZQBThAlttxtU5VP2ggKlzB4jMsoppmxNYgZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(2906002)(7416002)(5660300002)(8936002)(316002)(9686003)(6486002)(6916009)(6666004)(478600001)(6506007)(54906003)(41300700001)(6512007)(26005)(186003)(86362001)(8676002)(83380400001)(66476007)(66556008)(38100700002)(66946007)(4326008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Oo7K8cttmrBFloqTD5+BbX1LHRnvHPbhRQVNm9JSsVBHK/ZqJd9DVWxeu4C?=
 =?us-ascii?Q?g3KcXEnwH/NvHhMCOmlxLbn7Z+m9J1vLK9BXX76+Da4pcQLTVsRvjPJ4Yce9?=
 =?us-ascii?Q?C29iV2kEqVPRHqgwOqM4KwukUuDxOLx0xFIuHOo7qAFFQNERQH4+s61DCNL6?=
 =?us-ascii?Q?rPXe6Q1gxw11W1i9MDof51TmN7zFWlnbNRvC9/+vlTmTrdQbcG66k65/6Z0Y?=
 =?us-ascii?Q?h3/Rex2w7mk+AnjO3HmOlQ9in+cziBolHFemctP8e2ghP/ugFx3I8dljCQG7?=
 =?us-ascii?Q?X5UqMscJjZ4+IBriKqMVVevIkph+XslsxaAjQtawtk7UZwwjfZ/IcbOWkaBL?=
 =?us-ascii?Q?W09qMAptJPNuMNqxALpbR05xmpkCoIg269e2z0AlraDNau+h7uoRDEhHf/P8?=
 =?us-ascii?Q?ietB+nKED3zn9UOjbP9CDksjq9LfC4QxHZXUv6rtpFsHIT0nWr9w3HcB9r2s?=
 =?us-ascii?Q?3x0BSWbLN+VqQSS23pTtnTKuHyxEFozBepesXZ6l69FIfqpnTU0uQb3qEAkH?=
 =?us-ascii?Q?+4NcTp8AZY53o1crT6stzSlpOzqCzbrzB74KicIDcW8MAZDjZPyQmqGBkaUQ?=
 =?us-ascii?Q?Sq+XF/bgFYhihLF3PkC2V4hpc1Jm38XbsV49sA5gLz0nmC27SKCzgOnetAd7?=
 =?us-ascii?Q?sgOGGjZ5BlbTfI6vWIHY+V29zeJbQx2seW/fJPW2zm1jBpW7wU95BHHw7AGG?=
 =?us-ascii?Q?MgtoFN3HHll+03PA2KtDXyPJfmiEx3xlW9PVHbT17ETv/m6316FGzNVvgaDt?=
 =?us-ascii?Q?l+Q5/bCFY6dFlXmv6EAcbW+w/6bgMXCm6oS3GWBcN10FwYQUryvIC0vVdjT4?=
 =?us-ascii?Q?iST5shS5nIS7dH4rBXaL7EdM8a4SXaDb5g7jJV50ZbaEKyJbm6AeoxUJFZQ6?=
 =?us-ascii?Q?DimMl23lUvOXohmTv+ZJVgJ2A0nSKTbG9igGuc246Uo/EPY/F4ubpiQHsHvq?=
 =?us-ascii?Q?Bzrbnkx1c+Sv6XtWbq1iA9GdwyYlCCTAkyUMpqqpNi0E45Vf7GgzpTHaLLjd?=
 =?us-ascii?Q?qTnxEagJnJnGjJQIrcx0RLgtHneYUUQoi2Qp+3YlyxzddiZzS/XO3qGgBETr?=
 =?us-ascii?Q?0uPht4SFxfLQl5+h05Kd5fykI4VGQSo7W9oRix7Cnoz9jdS86LW8Ygsk78iC?=
 =?us-ascii?Q?s8TAJt7huIhGkZnnK/3WcONq381nkQ+l/knL3/jtAEo2BVuwyY5jMRyU3dxR?=
 =?us-ascii?Q?XPM49GYIt9O1R656EUkza9LbNJFmALtz71SypJu4CjwExBhJiBNKUkSS9GSK?=
 =?us-ascii?Q?vmMgf6iJDAuuAAxpWu5NAtJTa86SyF7UPa+4ak85k3H2E7eQLlGDc5pR+yi7?=
 =?us-ascii?Q?jR8+UDFG6rj+v1Q6uoRcAj6GBd5+sT+kAT3oSUZzQCzh76SXphJ6v/fJ8Kgw?=
 =?us-ascii?Q?Z4LFxFpTCVmHxyci6wGiC9NU7n/RWbrXCkMjUZDrmKUxecBx5xtHlvI77mvU?=
 =?us-ascii?Q?x7tpb1Rk8vMFA9XMkQbdVC11aeRXplwkjRzgJAOY9RAZymoFE3JtZB+uD/GQ?=
 =?us-ascii?Q?46zhU7HUm3NEBpo0KigzYseJhTUcxKUc6ZAahPqfQH4aED+gHMyDx5gdv4Oz?=
 =?us-ascii?Q?JLipZgyEKCXiNhHB6SWepgXKVw6CATxtxNSEnz0v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e68454b-54fb-461a-886a-08da86e7c8e4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 22:18:49.6240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cGSs6fZeTPCP1f8sIVq9O1px3mtZUafSei4fd0MObMmSv57NLGZGsAfplnsk3jUbMxxmg3IDJy0k0VNNOKA3pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6547
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


Peter Xu <peterx@redhat.com> writes:

> On Thu, Aug 25, 2022 at 11:24:03AM +1000, Alistair Popple wrote:
>> By the way it's still an optimisation because in most cases we can avoid
>> calling try_to_migrate() and walking the rmap altogether if we install
>> the migration entries here. But I agree the comment is misleading.
>
> There's one follow up question I forgot to ask on the trylock thing.  I
> figured maybe I should ask out loud since we're at it.
>
> Since migrate_vma_setup() always only use trylock (even if before dropping
> the prepare() code), does it mean that it can randomly fail?

Yes, migration is always best effort and can randomly fail. For example
it can also fail because there are unexpected page references or pins.

> I looked at some of the callers, it seems not all of them are ready to
> handle that (__kvmppc_svm_page_out() or svm_migrate_vma_to_vram()).  Is it
> safe?  Do the callers need to always properly handle that (unless the
> migration is only a best-effort, but it seems not always the case).

Migration is always best effort. Callers need to be prepared to handle
failure of a particular page to migrate, but I could believe not all of
them are.

> Besides, since I read the old code of prepare(), I saw this comment:
>
> -		if (!(migrate->src[i] & MIGRATE_PFN_LOCKED)) {
> -			/*
> -			 * Because we are migrating several pages there can be
> -			 * a deadlock between 2 concurrent migration where each
> -			 * are waiting on each other page lock.
> -			 *
> -			 * Make migrate_vma() a best effort thing and backoff
> -			 * for any page we can not lock right away.
> -			 */
> -			if (!trylock_page(page)) {
> -				migrate->src[i] = 0;
> -				migrate->cpages--;
> -				put_page(page);
> -				continue;
> -			}
> -			remap = false;
> -			migrate->src[i] |= MIGRATE_PFN_LOCKED;
> -		}
>
> I'm a bit curious whether that deadlock mentioned in the comment is
> observed in reality?
>
> If the page was scanned in the same address space, logically the lock order
> should be guaranteed (if both page A&B, both threads should lock in order).
> I think the order can be changed if explicitly did so (e.g. fork() plus
> mremap() for anonymous here) but I just want to make sure I get the whole
> point of it.

You seem to have the point of it. The trylock_page() is to avoid
deadlock, and failure is always an option for migration. Drivers can
always retry if they really need the page to migrate, although success
is never guaranteed. For example the page might be pinned (or have
swap-cache allocated to it, but I'm hoping to at least get that fixed).

> Thanks,
