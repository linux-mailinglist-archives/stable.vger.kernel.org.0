Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18374CE636
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 18:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiCER0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 12:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbiCER0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 12:26:04 -0500
Received: from relay3.hostedemail.com (relay3.hostedemail.com [64.99.140.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563841B84E2
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 09:25:14 -0800 (PST)
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay01.hostedemail.com (Postfix) with ESMTP id 660E0612E8;
        Sat,  5 Mar 2022 17:25:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf15.hostedemail.com (Postfix) with ESMTPA id 6F3351C;
        Sat,  5 Mar 2022 17:24:37 +0000 (UTC)
Message-ID: <45c5acb0e72112d2c3cf6330b0037389073fa5f3.camel@perches.com>
Subject: Re: [PATCH 5.10+5.4 2/3] sched/topology: Fix
 sched_domain_topology_level alloc in sched_init_numa()
From:   Joe Perches <joe@perches.com>
To:     dann frazier <dann.frazier@canonical.com>, stable@vger.kernel.org
Cc:     Miao Xie <miaox@cn.fujitsu.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Anatoly Pugachev <matorola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date:   Sat, 05 Mar 2022 09:25:03 -0800
In-Reply-To: <39660e162b54f241cdb571e0029c26d4596ec8e0.camel@perches.com>
References: <20220305164430.245125-1-dann.frazier@canonical.com>
         <20220305164430.245125-3-dann.frazier@canonical.com>
         <39660e162b54f241cdb571e0029c26d4596ec8e0.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 6F3351C
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Stat-Signature: ayh3wfrt3brb8zgqthecyw37gcii3a1b
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+gUly3Gk3jG59foXfiC7q41cuVLoX2m5k=
X-HE-Tag: 1646501077-480000
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2022-03-05 at 09:13 -0800, Joe Perches wrote:
> On Sat, 2022-03-05 at 09:44 -0700, dann frazier wrote:
> > From: Dietmar Eggemann <dietmar.eggemann@arm.com>
> > 
> > commit 71e5f6644fb2f3304fcb310145ded234a37e7cc1 upstream.
> > 
> > Commit "sched/topology: Make sched_init_numa() use a set for the
> > deduplicating sort" allocates 'i + nr_levels (level)' instead of
> > 'i + nr_levels + 1' sched_domain_topology_level.
> []
> > diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> []
> > @@ -1655,7 +1655,7 @@ void sched_init_numa(void)
> >  	/* Compute default topology size */
> >  	for (i = 0; sched_domain_topology[i].mask; i++);
> 
> Thanks.

Oops.  Didn't notice this was for a stable backport.


