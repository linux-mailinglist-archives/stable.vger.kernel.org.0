Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FD64CE635
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 18:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiCERYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 12:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiCERX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 12:23:59 -0500
X-Greylist: delayed 577 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Mar 2022 09:23:09 PST
Received: from relay.hostedemail.com (relay.hostedemail.com [64.99.140.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924EDC9A1C
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 09:23:09 -0800 (PST)
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay06.hostedemail.com (Postfix) with ESMTP id E11BF23560;
        Sat,  5 Mar 2022 17:13:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id E4F822000D;
        Sat,  5 Mar 2022 17:12:46 +0000 (UTC)
Message-ID: <39660e162b54f241cdb571e0029c26d4596ec8e0.camel@perches.com>
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
Date:   Sat, 05 Mar 2022 09:13:21 -0800
In-Reply-To: <20220305164430.245125-3-dann.frazier@canonical.com>
References: <20220305164430.245125-1-dann.frazier@canonical.com>
         <20220305164430.245125-3-dann.frazier@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Stat-Signature: dxe3wtsd7dwd8huxdtt5cgwugib8qqpm
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: E4F822000D
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+mCSH3LH0zbhwDl9OkUOjVBoOSQXNRy8c=
X-HE-Tag: 1646500366-379292
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2022-03-05 at 09:44 -0700, dann frazier wrote:
> From: Dietmar Eggemann <dietmar.eggemann@arm.com>
> 
> commit 71e5f6644fb2f3304fcb310145ded234a37e7cc1 upstream.
> 
> Commit "sched/topology: Make sched_init_numa() use a set for the
> deduplicating sort" allocates 'i + nr_levels (level)' instead of
> 'i + nr_levels + 1' sched_domain_topology_level.
[]
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
[]
> @@ -1655,7 +1655,7 @@ void sched_init_numa(void)
>  	/* Compute default topology size */
>  	for (i = 0; sched_domain_topology[i].mask; i++);

Thanks.

Couple trivial notes:

A trailing semicolon in a for loop, "for (...);" can be error prone
and is also the only usage of that style in kernel/ path.

A more common usage might be:

	i = 0;
	while (sched_domain_topology[i].mask)
		i++;

> -	tl = kzalloc((i + nr_levels) *
> +	tl = kzalloc((i + nr_levels + 1) *
>  			sizeof(struct sched_domain_topology_level), GFP_KERNEL);

kcalloc would be better, although the array is completely set
by the loop below so the zeroing isn't necessary.
Maybe use kmalloc_array.

Doubtful there's an overall impact though.


