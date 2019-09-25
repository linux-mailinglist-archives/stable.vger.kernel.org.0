Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012CEBDFA1
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 16:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbfIYOFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 10:05:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730549AbfIYOFj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Sep 2019 10:05:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C77AC01D36C;
        Wed, 25 Sep 2019 14:05:38 +0000 (UTC)
Received: from llong.remote.csb (dhcp-17-160.bos.redhat.com [10.18.17.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C86FF5D9CC;
        Wed, 25 Sep 2019 14:05:37 +0000 (UTC)
Subject: Re: [BACKPORT 4.14.y v3 1/3] locking/lockdep: Add debug_locks check
 in __lock_downgrade()
To:     Baolin Wang <baolin.wang@linaro.org>, stable@vger.kernel.org,
        peterz@infradead.org, mingo@redhat.com
Cc:     arnd@arndb.de, orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
References: <cover.1569405445.git.baolin.wang@linaro.org>
 <4ac2e84637ceaf5ec67cfc11ad58c489778693a8.1569405445.git.baolin.wang@linaro.org>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <87e81724-9f1a-8716-5b4f-f2aac6f25c5a@redhat.com>
Date:   Wed, 25 Sep 2019 10:05:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4ac2e84637ceaf5ec67cfc11ad58c489778693a8.1569405445.git.baolin.wang@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 25 Sep 2019 14:05:38 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/25/19 6:01 AM, Baolin Wang wrote:
> From: Waiman Long <longman@redhat.com>
>
> [Upstream commit 513e1073d52e55b8024b4f238a48de7587c64ccf]
>
> Tetsuo Handa had reported he saw an incorrect "downgrading a read lock"
> warning right after a previous lockdep warning. It is likely that the
> previous warning turned off lock debugging causing the lockdep to have
> inconsistency states leading to the lock downgrade warning.
>
> Fix that by add a check for debug_locks at the beginning of
> __lock_downgrade().
>
> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Reported-by: syzbot+53383ae265fb161ef488@syzkaller.appspotmail.com
> Signed-off-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Will Deacon <will.deacon@arm.com>
> Link: https://lkml.kernel.org/r/1547093005-26085-1-git-send-email-longman@redhat.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
> ---
>  kernel/locking/lockdep.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index 565005a..5c370c6 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -3650,6 +3650,9 @@ static int reacquire_held_locks(struct task_struct *curr, unsigned int depth,
>  	unsigned int depth;
>  	int i;
>  
> +	if (unlikely(!debug_locks))
> +		return 0;
> +
>  	depth = curr->lockdep_depth;
>  	/*
>  	 * This function is about (re)setting the class of a held lock,

Apparently, there are 2 such patches in the upstream kernel - commit
513e1073d52e55b8024b4f238a48de7587c64ccf and
71492580571467fb7177aade19c18ce7486267f5. These are probably caused by
the fact that there are 2 places in the code that can match the hunks.
Anyway, this looks like it is applying to the wrong function. It should
be applied to __lock_downgrade. Though it shouldn't harm if it is
applied to the wrong function.

Cheers,
Longman

