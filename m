Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4904CE69B
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 20:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiCETvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 14:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiCETvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 14:51:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A72064D4;
        Sat,  5 Mar 2022 11:50:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1261B80CA1;
        Sat,  5 Mar 2022 19:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEBAC004E1;
        Sat,  5 Mar 2022 19:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646509853;
        bh=zE8mY7gSZ94ep1kSuWQL2BU4MPCGeaZjsBead339r+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LtIJ6kb3cOTmfja5IypACO5cXZ6Tq+dnIt3f6IG+FZ5Hn4skKQGJWRuvJ2v/PoytQ
         tU88U4Y8AKnl/lbabx6BMNmhpg+8WJoAI4KdjGWLXH5rEKUyiAeFXzC2J/ysMlJJXy
         rpCCpdtkjM8J0GJWd8g/N5hWezEyY+4giLB7TJRY=
Date:   Sat, 5 Mar 2022 20:50:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     stable@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
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
Subject: Re: [PATCH 5.10+5.4 0/3] sched/topology: Fix missing scheduling
 domain levels
Message-ID: <YiO/EsBd0QlDA9o4@kroah.com>
References: <20220305164430.245125-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220305164430.245125-1-dann.frazier@canonical.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 05, 2022 at 09:44:27AM -0700, dann frazier wrote:
> The LTP cpuset_sched_domains test, authored by Miao Xie, fails on a Kunpeng920
> server that has 4 NUMA nodes:
>   https://launchpad.net/bugs/1951289
> 
> This does appear to be a real bug. /proc/schedstat displays 4 domain levels for
> CPUs on 2 of the nodes, but only 3 levels for the others 2 (see below).
> I assume this means the scheduler is making suboptimal decisions about
> where to place/move processes. I'm not sure how to demonstrate that - but
> open to suggestions if that evidence is important justification for stable.
> 
> This is not a problem in current upstream kernels, so I bisected and found
> that the first patch here fixes it. I can't tell from the commit message
> if fixing this case was Valentin's intent, or just a happy side-effect of the
> set conversion. The other two patches fix regressions introduced by the first.
> All cherry-pick cleanly back to 5.10.y and 5.4.y. This platform easily
> reproduces the problem Dietmar's fix addresses. I don't have hardware to test
> the ia64 fix.
> 
> Note: This also impacts earlier stable trees, but require some minor porting,
> so I'll submit fixes for those separately.
> 
> Here's a comparison of /proc/schedstat before & after applying these
> fixes:

Thanks, now queued up.

greg k-h
