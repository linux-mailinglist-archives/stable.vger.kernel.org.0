Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB1E59091C
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 01:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbiHKXW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 19:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbiHKXW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 19:22:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F31A1A49;
        Thu, 11 Aug 2022 16:22:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1h1XrgwOt/y6x3JRSaO7VcTp4/3cdnHC5zyEmz6jfG/aypexz3lwXwUDephjnxCKZLo25VNRPF9lIqLdQCtP/WurdF5EonISVbrLDkRzDnPbwGcK1dtwubu9giu7SPUdQw6tAcZ6zJD3qMaJwYwv698mRvbo9vqquU+NdA1RRwAex/Q4HfL60EP/f8Fyjyo+DjJKiRTmcGzfUHrFuWPLb4r07tatUcCy8iGIkbRFCwLtbzxS4M46lXfG5/YC3ATGR0sh8p5C4pfAicz873pTcIl8qlwppNNIwDoRlJcpQMDXQ57MY97ZBwDL7TQl7LbUGNFtDAY2d60aaaEZx3cAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QybElcSP2bDmvmjdIgaCzA5rzSPnDfQ/K6FOeY45wpY=;
 b=n5ClyvWrX1+iyeWgkmrIaoy/mpDjUUMfRZxZKAc4nr1BvZwgJKQZuUJDhTMps6JeE86Kg9jZjWbJV5AK9XmK8pfG8SOuAtKfoLc77s8fIvMRK/55TbhrDlriFfPAgvHQoIy5AjCOJKmZjFAJjuuOe9SYDWQ/X0TEE85TUGU0Xb13F1dMlsRZP9Dn3Nk52R2zJoTCUSUaVloCykyuD42zBaukYfXpyFk0NXL9AA2fxMpYoa0vx7m3L2XZ98+G0wZvJZ9ImlFZ2HbkVykowT+ak3RdBLF+M+y+VSPaHt59z1NNe5Wenp9AD2eBR4yGHZM04wBfoCO78OINAQkYzovtgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QybElcSP2bDmvmjdIgaCzA5rzSPnDfQ/K6FOeY45wpY=;
 b=rSkM5XfV69X69c1Ju7z5ewWGTudhRqp8QjK1upoOGfrIh3JuHoiRYuLvjmpjnzJCcu3B5LZE77WUVZIXQBIrjMcGPL4bhjTepO39xzs7CKUhvaTToueHIZOFdejOia8hX7mgTuUMRH6qRp8Ld88r/6DALmSdtMKT8Wr2t0p1AzMibmBvFycAc7hADmd2ypPzQe9OMbzeM8W1DX60ezX/51xuuG1gOEvqGhw1/EIMsKbMw8O3lWAJL3sxTf6qFg2P4QhasBlZFQvOpYCtdH9olRcU8kNFdwSoCJdVCTlTAFiCANJ9q6ApRlJyGUUapPBrBlbHekdu8Z0gMtCaYz94iw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6063.namprd12.prod.outlook.com (2603:10b6:8:b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 11 Aug
 2022 23:22:56 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.011; Thu, 11 Aug 2022
 23:22:55 +0000
Date:   Thu, 11 Aug 2022 20:22:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] sched/all: Change BUG_ON() instances to WARN_ON()
Message-ID: <YvWPThSv65hwuSMl@nvidia.com>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvSsKcAXISmshtHo@gmail.com>
 <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
 <YvV0e7UY5yRbHNJQ@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvV0e7UY5yRbHNJQ@casper.infradead.org>
X-ClientProxiedBy: BLAPR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:208:32a::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e64acf7-4cb4-4378-7e69-08da7bf06baa
X-MS-TrafficTypeDiagnostic: DM4PR12MB6063:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XL5bFRRckjknW01F7lbupqr+pfc5TCm5Xnkk1raf+FgfBVaFI2I6knygnEU3KapO8Xjn8QsD35TVVwY1iozRWdNIme9IE6im9dD9MqROJJ6fF7qTUhN0aoflRdwjHUCBPHDA9qL0yA8rcewK2IJTLX09e3PlyZndbnEoQBzhxnJy3pl+k7hM1wfZu5QhbruS+JV56mtnI/bzMUn9DXfa+wIQOiyyxtwppnMfyOPjWN7/JmComf7yBLvHbkWsxfBXxADOPbKyvmdqmhkZNULKnv9ld6G6zeDj47SA6yBav5q8R49IfpmkhSfsNtXa8B7w6/ANCaK30ji+eSJWf9G53QGHsdAmfrItCzhjXa4FBWbPgJtaogBY9PJMCSXNzugxcQmr8Aa2EQwVUJgsGesmHTsp1TtgvsN4KkhhXp4Gk5BKB+M7Ssqba7GA2Af1SB32+jya20s0VdI7Bn6ghv5RFnFpAZRowCa7ol2tVCOq1AZIrKHD/zXOL62rtQYfsHiwQ4kXZHIzRIAQtbVcQKS5FCL4LcUOmr0ksNmr5H2BclsHi3bThE1jIr6TKuRUz0aB4w8IBznkkyt3xoDSnv8DFE8cjqJ+2iiQc3gYWpVk10lymSzkpb3PUBJ801VM8hQ65I7CpAuAK7cy/BSy9E7N3OhSdiauBaJeQZBJ+Oq57letm3qKq29M8MeaFjH+kKyqy2pv4Qob+GmxIUCBLLsHn5z21kFtHZ66/TZ3a9mhxjJrN5ZNHuV+/X+N2w6aeJO+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(2906002)(8936002)(7416002)(5660300002)(26005)(86362001)(66476007)(2616005)(186003)(41300700001)(6506007)(6512007)(83380400001)(478600001)(316002)(6916009)(66556008)(8676002)(4326008)(38100700002)(54906003)(66946007)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4onB5umgFGelVRoRbCtqCEuWDhVRtHPeis8FRYEVcm/48JAEBhiSB0qKGWGB?=
 =?us-ascii?Q?YYREM9CgjtCZ7uamKDhCWE5XgerN12PQpQSd964TAZ8UWAzM5AstenkqioKB?=
 =?us-ascii?Q?tvjV/slHy9YBSLlPZfZyjVxZ9QDAosq/QYJ0cRgujSLbHof99q5Oqo62zutN?=
 =?us-ascii?Q?FlBlzID+BOe7b4sriEbfZCDyGNq5cajHO+SGGfhbNyV/qNozTeNHOnCtfsNH?=
 =?us-ascii?Q?junAsjGskDUc6mNHHLAf1zxndUyM3cKITLC+3ErXO8u31EQpwPE7zVbzMctB?=
 =?us-ascii?Q?/a2OQhSmQg54ZTno760cPZPTghQH9mLgv670s9T7SWMSjACtw9xbRiwLqf4s?=
 =?us-ascii?Q?DQMgrlGZhO7P+zStQ9sQ+LBilmyAEm3oJYKsMI4uUJOSvdvocmD9lonvbX0i?=
 =?us-ascii?Q?Ut/PvDT/2EJI1tuLHl6mEXI5gORx4tEhOc0Bz06c20lAgyxtx9cnxQ/bSvox?=
 =?us-ascii?Q?mJHOa+cQLQDj4JCggGuX3aATSturlcQO4R3JaSaBLkSckYF+IvlCfKqpiHMW?=
 =?us-ascii?Q?hL6SU2QTV2cYQk83q035Wn9GGlObb3i0pqPhiHxf+RbaHBMCizLyKXJDHfFC?=
 =?us-ascii?Q?oYH134qzCOrSm8Qp7TISHe9DdCFIsMcsy0lt2JJMw7gc5FFy1cN/C5w8mxZR?=
 =?us-ascii?Q?hlxOolicKVQcCE8nsBxnmskuXvSVW4JKPP4UDCZWC4BJV2huDMsyZizILbrP?=
 =?us-ascii?Q?3xaBk4vj/vpB77ebvrH5XmOznusP6jtSOZalmA4yeseSF5xbUSPpvpv+8uHR?=
 =?us-ascii?Q?GY8+kPYzamMkocUpRKM/YpEZqzpA7zMCWKBVrhoveVzeVIgtGMQ0jbMOTBqr?=
 =?us-ascii?Q?FRSACgvYTZsfovFhOHMLcgzvRymOrr15iVsdqTKMEpRZv9mNtj7pHn96mraQ?=
 =?us-ascii?Q?FKzRWGIDoUhDrGVYJDP9KRvWg9th7FaX1qmgEDpMm7yNlJJCWOoTtvjEwI0C?=
 =?us-ascii?Q?FnKIDD7cg/KMQd+oKusuhV265HnkhI/NzuS27N8H+mwJjfIdtu0Vl6BEKqRT?=
 =?us-ascii?Q?2wKCxnMlQhDrdjPyEu2iRxWNqO536yrkNkySIr/qavO1ICdaSczowV2ZZCOw?=
 =?us-ascii?Q?o4cD2RgdBkMq+mNFH160sMpoP+gn+aQXZYO82JkobASpSICAFZ/5h0Rq82Wv?=
 =?us-ascii?Q?dGZtNedoylwtztVuc6EOC1aJl4/Mj0t/IiUUO9F2/JLtT22cusxLX6gep5MY?=
 =?us-ascii?Q?ClrhQGw0iKnvyySEbUUmlPV6ySh7crhPwRHClSWEHgVr/EIS8faR0PV9VUVS?=
 =?us-ascii?Q?TZ0SYaghURnyQJRMYVcZacHBl13cZKpWu6F2t2YREOT85MOIRyR1OD8gBdcG?=
 =?us-ascii?Q?a//ZMZQdv2wE9GYYSaB3c6GQG2sPAcesk+9r8biXHX4OHDHKocm0RYshGDDS?=
 =?us-ascii?Q?cRZ70l7VgR9Km9r/KR0vVQ19EddTa2qJRw0PgcS1uVjvMwzxzb9iswf2a+57?=
 =?us-ascii?Q?8RQpmmBRRI7lxnBgXsIWQg8j+VJIfdR2P0M2YF/+0hE2j/XmvGnFhszkjHxV?=
 =?us-ascii?Q?nmTB3WmbC2GLEsQXgFdm2C0M6n+UMrXHERUlCQHi9+m3QII53mrOXkjSE6Ja?=
 =?us-ascii?Q?cEdAli9N2bhZq2GQKLuaOFYdELlGCHP/pZ+cOZD0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e64acf7-4cb4-4378-7e69-08da7bf06baa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 23:22:55.8031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlLVtU+jDaHPCirRT18ESAaexBCZB2loipi1ailyZdpLY5uF4QWsvYaoIjQgFeW4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6063
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 10:28:27PM +0100, Matthew Wilcox wrote:
> On Thu, Aug 11, 2022 at 01:43:09PM -0700, Linus Torvalds wrote:
> > May I suggest going one step further, and making these WARN_ON_ONCE() instead.
> > 
> > >From personal experience, once some scheduler bug (or task struct
> > corruption) happens, ti often *keeps* happening, and the logs just
> > fill up with more and more data, to the point where you lose sight of
> > the original report (and the machine can even get unusable just from
> > the logging).
> 
> I've been thinking about magically turning all the WARN_ON_ONCE() into
> (effectively) WARN_ON_RATELIMIT().  I had some patches in that direction
> a while ago but never got round to tidying them up for submission.

I often wonder if we have a justification for WARN_ON to even exist, I
see a lot of pressure to make things into WARN_ON_ONCE based on the
logic that spamming makes it useless..

Maybe a global limit of 10 warn ons per minute or something would be
interesting?

Jason
