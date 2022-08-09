Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E684058DFCE
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344773AbiHITH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347539AbiHITG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:06:29 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27C71E3D9;
        Tue,  9 Aug 2022 11:48:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eU1QVCMHahVJqMBB+tJNMK1uNCx8z1AmWghRcYLDW3DvHqyBYtQCSKvrMNGHZzeDnZ5+NSfYL9pvNhJghoq9YkcjaR5xaDHjyNCGnohrPVdjdTGWoRfmVB4uj1ZOAXYeiEJzHEcuqO/+dzHt9ymov5TUYrZx4ZfZHMTj1Xzpb23Wd0hkuGNlg/j7mAmE1mnKIIxsjaGYTo0hZ1YkuXqV/quSOY12+Mk/xk3DLqh/xUl6p2gtGtUQATfCJOjvy8Gzik5fjB4BAe9YZHg/1BNOiJzHdl7DyZdTuAz3ZofdH4UKC5g8f/SXNGzUkL797Lzdq6UvxKv2g/UcVt8P8TIw/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ky3ss1Bx3tUsqGlHF4sO3qeQbwIOm17L8ymQ/c1iDGw=;
 b=mW7XvWk5ma3nvLsE4aNSkt/6ARrHjc4zpItfaxnizIKvqjL1L2lKqrciNBAITzBFaDxQ9n93zlMmHzmhksGS+Jn5/Dz88Hmre97wnZOQdd2tRbBKZONBbNEO6yLV6SfQFOsRDo20ulEd+FyG7ZTpnnrs2BwR9kgBwR4i8l4OYVntAh8WpasoB495WvosYTihfX/8afj2GhGOhol/uMmr8ari+lwns0c5xXzhf6+WhoiDPcCVIGTLNaPpqqngxtY73/bCZZnHZAFGASNoBpBzEavYR6d3A5pSIvxBV0BGfaVpePoWTWMaMmnd2EvWZLOvr+HQtnd6QylZHpYhvQI/6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ky3ss1Bx3tUsqGlHF4sO3qeQbwIOm17L8ymQ/c1iDGw=;
 b=QGhNEvgo+3Vx2Qv1uWhcS03WMB4nv3FuCca1QGleczSKHXNKo99JEcKyWe+nozyimvOjyUgd0MHmGnAjPPN5xJCoKsn+Y2qgn0uTbw5/7KFaLydViD9YX6unk9yV0Z/viLjwQ2KGcwLInZ53Q8WKnytPCYka98RoPG46SE9s6a7j+KOSZi8iVFS9QzXiZKbJE8oQoLh0qtVXYdUvv4a0zC8NZhm5xUWgMhrDS1u1rs+zWOvvvHdQQabSRpRTUd5bp5ems+r7aIYEDVqpu6ez//NEyulsC33v2bTlo0SBZETpkcsNL/24DnXI2Sysljxvc7mK0iVOrj7Ebs8wBGhtug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW2PR12MB2348.namprd12.prod.outlook.com (2603:10b6:907:e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 18:48:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::1a7:7daa:9230:1372]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::1a7:7daa:9230:1372%7]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 18:48:38 +0000
Date:   Tue, 9 Aug 2022 15:48:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
Message-ID: <YvKsBUuwLNlHwhnE@nvidia.com>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wi81ujYGP0gmyy2kDke_ExL742Lo_hLepGjCa8mS81A7w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi81ujYGP0gmyy2kDke_ExL742Lo_hLepGjCa8mS81A7w@mail.gmail.com>
X-ClientProxiedBy: BL1P222CA0027.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68bab285-cc6f-4aa9-4693-08da7a37c56f
X-MS-TrafficTypeDiagnostic: MW2PR12MB2348:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZecH2UmUWVDzkq31KC+Wd0GSVIxF6SFMxZtf5ZygH/9zFc2VYtNcu5dcDTU0TuLjs6TWvWu6vbTJ8uIhWVS0AmouyCr+3lhm0nipUP0FEbynrWxoERBszSwaNxZHPF9Y9pNGDCSYTh/5avvFhAu3iUZl2WXa0bkoW7XJVh1nYSsFO711LblQhZySVkYolR7UirHtE2/KAAvvJNMNDv3AwBsM9ht/MKPyjaGf+tO7uDqd6SlOztlX7P0dd3Lps0UGyMlaTuSNXqUxwhWe8bAx7r8jgDYdGy6zZ4T20HC622cTwe5gDBFuinVx6XzLtb3DNDPE3K5o6X/v9CVf/hpaNwf2cWSRA/NLJ3pupKgVoC892E4jfAY9gye1UMDHkXBpe+f8lNV2I5cjNdLgtOhS4JnzDeJ4LnaYwi5UGKvDCSjIGJu22bYpCOYw2xejtIrL2IajtgBErvJ+z0U5PhD+BR40DqhwK0DWYx9AUlAvtJ7SevodgPi24exArY/bTb58exR/7/CvP5bb3bVNSlwu4QnYQkdQJGZ47/PK9+/VqLDiDOoQ7ZN40sdyh1hApz+66dicfXfTU79R6lULu2OCZm9vMumZWdoFr5E6iBmDxEKlv6TRVDwEiHMpQFjZk5MQ17JgDEzRZn8vE1jkcIjdZSoPd8r9WpFnpcu8V/OURh8BjofLHJIK03MXU/dAAXlRAG4xFLu/+2HSqhs1Vc8eOKm1wAU24QEz/iRoJUoCRorQPTdbpbClSm6E0la0W7pv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(38100700002)(41300700001)(8676002)(4326008)(66476007)(66556008)(66946007)(83380400001)(54906003)(26005)(2906002)(6512007)(107886003)(186003)(2616005)(6506007)(53546011)(316002)(6916009)(6486002)(5660300002)(478600001)(8936002)(86362001)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rVpxaBobjSGIg9WRAv3rLf++Yiv95YyzlBeolFpbAJ0yMTpy+4FAks6c0lna?=
 =?us-ascii?Q?1lldyteJoDTcV7diPnkfTshHgFooPGkQuhpAvXhs47FtrUKxiDXxw8f9Z9Nw?=
 =?us-ascii?Q?96KlSG9ZlyPL/K0xmhu35HVmkiNF4iLkEg/Nk+Gv1u1kkAYlHVhXYr6qOJzp?=
 =?us-ascii?Q?5SLvvhckAuLGXFj7//SkTMSsCJi6UzI5heuATb6OBrZHneGbJzXviIbb+KJN?=
 =?us-ascii?Q?XS/GYPn+6YjKFLlyZA4TYZDuxkWswasT/WqvEILzS2f9LrAcjoUoBNrmXJ78?=
 =?us-ascii?Q?VWfVgQMaL+s8mfssY0dYFeVeR3hariepno0IAhPzkYdGOBHW0JxA6xZ9j42t?=
 =?us-ascii?Q?2vY4NhKjvm3XV9rl3V0gCpC/9kRtZLfdjkjQ7lnDlLA4CMzq72lg3OA6UiM8?=
 =?us-ascii?Q?mPtVwtMQQOPJxD6qy3zDEHi5PiCfFlUHvrubrbN7FWst1fZtqeZejdntkA9L?=
 =?us-ascii?Q?Z7a+K64Pf8llAoYWKnD4G1vE++LcXahAJ1DrnenW9QTrxbTmUIB4ai4TPmIY?=
 =?us-ascii?Q?Y+BN+m8+eyBpCpMuAaRu++wGbYWuhrTtTWNBo/e3Sgm2xlZ4Vriv1ijzUBD+?=
 =?us-ascii?Q?CpSejZA6lZNpLNGkEFRdCcLsEDLNfkgSVH0+7SCQuXYwttmLa3J/3tfjj+4r?=
 =?us-ascii?Q?izjlv99+dQdOPsEHBoEjJwXFgDesbuC43y+iCier7yuQco2raNukzITer/ez?=
 =?us-ascii?Q?sWpoVIVlgTX0HIjQMIADEN8u1q1xy4E2kg92aHpssezbqUufY9pl59CIX2rN?=
 =?us-ascii?Q?PpsVIMK4gi0flZs3KBDeOLIiC+MzdEFBNSGIuIYx/e1eFKRcXtcSY5cqmPxo?=
 =?us-ascii?Q?bYSiv473xPD/PuLnJTRW1DP1YW6PQZzxiqofqkUdb/mD7xLRYuKTbDHsI6Bb?=
 =?us-ascii?Q?jyWO5SX7rfYFCAx1NLrpf7/WNsMeeWIQPkvD6h0GbBPA+1IVSogaDY/MLcHo?=
 =?us-ascii?Q?GHYZ2xM1MRORlBMFJOvHMQGe//5qPCslmPuWPtusz/g7QSWhN/9Hae3iE4hi?=
 =?us-ascii?Q?j8d6zdXfHQrc4esv2tkfcIjO/JBGV3N8g5mIk+5WEbknZN/RGNl7He4/4wnk?=
 =?us-ascii?Q?kABREmeV/p8LFdPtHtqLIIa9b/LcfRYMjIortAMJWvTDwICKa7s6ubcCd/38?=
 =?us-ascii?Q?ZewJib+HKHseWfbKPbsqWy6kjr1a6+sUiFXD+2+tpHQo5WGGuAKSdt4jRr4P?=
 =?us-ascii?Q?PiyKKcEre5IeS65EH6SUkxVPG+JRPoJqzOgMc0hDj/y93ib8Bk6UJd7urX6Q?=
 =?us-ascii?Q?SMxmVia+6m3IygOAdVZwI/svwKnpKLZRMujjH1nmSQjrMHwv9MpmsD7LKWkG?=
 =?us-ascii?Q?SFMHzyU3UUQ3F+nLiCxyHgGNkHZ/baVCUFmtsn8F/fTC60OQkjy+yxDyV5rQ?=
 =?us-ascii?Q?PJPdOAj4Tad5ulubwaMj9A5lvpiChvc6cbNJjcXw607Qm1VRWcVKo2gDkcAg?=
 =?us-ascii?Q?5nw70+MnpAofB0BFek4HjynRzSdCo1OADcl8DBI1LDqwnPH9BxMSiQBC7Unk?=
 =?us-ascii?Q?HzcoUz62Y3Z8qeUk3tpctjIFUe34aE6Q8tjh8xHOBijuJL80I/WBywZRDqf5?=
 =?us-ascii?Q?1DL0YNCgmkOWLL8JPTsLgoajDPVdpfToGMFI1kZ1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68bab285-cc6f-4aa9-4693-08da7a37c56f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 18:48:38.2258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 29q4SHpiokrfK+sM+qbMEyGv6w525tb+54Gw2XiAt+rJMi6T9wh5vXsnMwgcN5kI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2348
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 11:40:50AM -0700, Linus Torvalds wrote:
> On Mon, Aug 8, 2022 at 12:32 AM David Hildenbrand <david@redhat.com> wrote:
> >
> > For example, a write() via /proc/self/mem to a uffd-wp-protected range has
> > to fail instead of silently granting write access and bypassing the
> > userspace fault handler. Note that FOLL_FORCE is not only used for debug
> > access, but also triggered by applications without debug intentions, for
> > example, when pinning pages via RDMA.
> 
> So this made me go "Whaa?"
> 
> I didn't even realize that the media drivers and rdma used FOLL_FORCE.
> 
> That's just completely bogus.
> 
> Why do they do that?
> 
> It seems to be completely bogus, and seems to have no actual valid
> reason for it. Looking through the history, it goes back to the
> original code submission in 2006, and doesn't have a mention of why.

It is because of all this madness with COW.

Lets say an app does:

 buf = mmap(MAP_PRIVATE)
 rdma_pin_for_read(buf)
 buf[0] = 1 

Then the store to buf[0] will COW the page and the pin will become
decoherent.

The purpose of the FORCE is to force COW to happen early so this is
avoided.

Sadly there are real apps that end up working this way, eg because
they are using buffer in .data or something.

I've hoped David's new work on this provided some kind of path to a
proper solution, as the need is very similar to all the other places
where we need to ensure there is no possiblity of future COW.

So, these usage can be interpreted as a FOLL flag we don't have - some
kind of (FOLL_EXCLUSIVE | FOLL_READ) to match the PG_anon_exclusive
sort of idea.

Jason
