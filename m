Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A894E25A810
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 10:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIBIwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 04:52:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46742 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgIBIwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 04:52:46 -0400
Received: from ip5f5af70b.dynamic.kabel-deutschland.de ([95.90.247.11] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1kDOVB-0007sW-3b; Wed, 02 Sep 2020 08:52:21 +0000
Date:   Wed, 2 Sep 2020 10:52:19 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Suren Baghdasaryan <surenb@google.com>, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, esyr@redhat.com,
        christian@kellner.me, areber@redhat.com, shakeelb@google.com,
        cyphar@cyphar.com, oleg@redhat.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, ebiederm@xmission.com,
        gladkov.alexey@gmail.com, walken@google.com,
        daniel.m.jordan@oracle.com, avagin@gmail.com,
        bernd.edlinger@hotmail.de, john.johansen@canonical.com,
        laoar.shao@gmail.com, timmurray@google.com, minchan@kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 1/1] mm, oom_adj: don't loop through tasks in
 __set_oom_adj when not necessary
Message-ID: <20200902085219.7nvp2wml4wh2dojv@wittgenstein>
References: <20200902012558.2335613-1-surenb@google.com>
 <20200902055302.GA6363@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200902055302.GA6363@dhcp22.suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 07:53:02AM +0200, Michal Hocko wrote:
> On Tue 01-09-20 18:25:58, Suren Baghdasaryan wrote:
> > Currently __set_oom_adj loops through all processes in the system to
> > keep oom_score_adj and oom_score_adj_min in sync between processes
> > sharing their mm. This is done for any task with more that one mm_users,
> > which includes processes with multiple threads (sharing mm and signals).
> > However for such processes the loop is unnecessary because their signal
> > structure is shared as well.
> > Android updates oom_score_adj whenever a tasks changes its role
> > (background/foreground/...) or binds to/unbinds from a service, making
> > it more/less important. Such operation can happen frequently.
> > We noticed that updates to oom_score_adj became more expensive and after
> > further investigation found out that the patch mentioned in "Fixes"
> > introduced a regression. Using Pixel 4 with a typical Android workload,
> > write time to oom_score_adj increased from ~3.57us to ~362us. Moreover
> > this regression linearly depends on the number of multi-threaded
> > processes running on the system.
> > Mark the mm with a new MMF_MULTIPROCESS flag bit when task is created with
> > (CLONE_VM && !CLONE_THREAD && !CLONE_VFORK). Change __set_oom_adj to use
> > MMF_MULTIPROCESS instead of mm_users to decide whether oom_score_adj
> > update should be synchronized between multiple processes. To prevent
> > races between clone() and __set_oom_adj(), when oom_score_adj of the
> > process being cloned might be modified from userspace, we use
> > oom_adj_mutex. Its scope is changed to global. The combination of
> > (CLONE_VM && !CLONE_THREAD) is rarely used except for the case of vfork().
> > To prevent performance regressions of vfork(), we skip taking oom_adj_mutex
> > and setting MMF_MULTIPROCESS when CLONE_VFORK is specified. Clearing the
> > MMF_MULTIPROCESS flag (when the last process sharing the mm exits) is left
> > out of this patch to keep it simple and because it is believed that this
> > threading model is rare. Should there ever be a need for optimizing that
> > case as well, it can be done by hooking into the exit path, likely
> > following the mm_update_next_owner pattern.
> > With the combination of (CLONE_VM && !CLONE_THREAD && !CLONE_VFORK) being
> > quite rare, the regression is gone after the change is applied.
> > 
> > Fixes: 44a70adec910 ("mm, oom_adj: make sure processes sharing mm have same view of oom_score_adj")
> > Reported-by: Tim Murray <timmurray@google.com>
> > Debugged-by: Minchan Kim <minchan@kernel.org>
> > Suggested-by: Michal Hocko <mhocko@kernel.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
