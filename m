Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1363664120
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 14:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbjAJNDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 08:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238648AbjAJNDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 08:03:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0648E517FD;
        Tue, 10 Jan 2023 05:03:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 964E4616DE;
        Tue, 10 Jan 2023 13:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF22C433EF;
        Tue, 10 Jan 2023 13:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673355812;
        bh=tMAJplNMu5w1rrrs8QfI2RyE5frRVobjXl2ItdE9iRE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FB3evCvKqzN4h1XROqvItFBBPt9ZEZinl3EhlU3lwXvLVvz4lhBLOIGiSLWSIFzPQ
         jwanItiorJhY84gT+v8DFLFJJEwi9JcP1VhVPEqIEpzHpfl/zuXsVBjSvfOBkqPS2k
         Z31ReAMDPMpBK6t4k2HwA9W3WffW3gEGzRNxtTxNbjBaexfW+sMVGhW08R613aLOHs
         nRaSTYlVVrqEqcnl3hriHSy6myQkYv+t2xpOV0kV+FO2UJSQ490sOJdjvTe5beJpBQ
         DUr+b1Yt0j8yq1o3xDg47uwMZbgOD8CshEOfxdrZH6+o47ZgWF04MIzcai5+2ILRB2
         jlHDN85X6H1LA==
Date:   Tue, 10 Jan 2023 13:03:25 +0000
From:   Will Deacon <will@kernel.org>
To:     Waiman Long <longman@redhat.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Phil Auld <pauld@redhat.com>,
        Wenjie Li <wenjieli@qti.qualcomm.com>,
        David Wang =?utf-8?B?546L5qCH?= <wangbiao3@xiaomi.com>,
        Quentin Perret <qperret@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v6 1/2] sched: Fix use-after-free bug in
 dup_user_cpus_ptr()
Message-ID: <20230110130324.GA9180@willie-the-truck>
References: <20221231041120.440785-1-longman@redhat.com>
 <20221231041120.440785-2-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221231041120.440785-2-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 30, 2022 at 11:11:19PM -0500, Waiman Long wrote:
> Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
> restricted on asymmetric systems"), the setting and clearing of
> user_cpus_ptr are done under pi_lock for arm64 architecture. However,
> dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
> protection. Since sched_setaffinity() can be invoked from another
> process, the process being modified may be undergoing fork() at
> the same time.  When racing with the clearing of user_cpus_ptr in
> __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
> possibly double-free in arm64 kernel.
> 
> Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
> cpumask") fixes this problem as user_cpus_ptr, once set, will never
> be cleared in a task's lifetime. However, this bug was re-introduced
> in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
> do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
> do_set_cpus_allowed(). This time, it will affect all arches.
> 
> Fix this bug by always clearing the user_cpus_ptr of the newly
> cloned/forked task before the copying process starts and check the
> user_cpus_ptr state of the source task under pi_lock.
> 
> Note to stable, this patch won't be applicable to stable releases.
> Just copy the new dup_user_cpus_ptr() function over.
> 
> Fixes: 07ec77a1d4e8 ("sched: Allow task CPU affinity to be restricted on asymmetric systems")
> Fixes: 851a723e45d1 ("sched: Always clear user_cpus_ptr in do_set_cpus_allowed()")
> CC: stable@vger.kernel.org
> Reported-by: David Wang 王标 <wangbiao3@xiaomi.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/sched/core.c | 34 +++++++++++++++++++++++++++++-----
>  1 file changed, 29 insertions(+), 5 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
