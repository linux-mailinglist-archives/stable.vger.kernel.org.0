Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEF2C15D6
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfI2Ono (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:43:44 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58947 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfI2Ono (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 10:43:44 -0400
Received: from fsav402.sakura.ne.jp (fsav402.sakura.ne.jp [133.242.250.101])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x8TEhfp4094706;
        Sun, 29 Sep 2019 23:43:41 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav402.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav402.sakura.ne.jp);
 Sun, 29 Sep 2019 23:43:41 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav402.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126227201116.bbtec.net [126.227.201.116])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x8TEhd7U094685
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Sun, 29 Sep 2019 23:43:40 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH 4.19 36/63] locking/lockdep: Add debug_locks check in
 __lock_downgrade()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+53383ae265fb161ef488@syzkaller.appspotmail.com,
        Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20190929135031.382429403@linuxfoundation.org>
 <20190929135038.482721804@linuxfoundation.org>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <801c81d2-ce72-8eb3-a18b-1b0943270fc4@i-love.sakura.ne.jp>
Date:   Sun, 29 Sep 2019 23:43:38 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190929135038.482721804@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/09/29 22:54, Greg Kroah-Hartman wrote:
> From: Waiman Long <longman@redhat.com>
> 
> [ Upstream commit 513e1073d52e55b8024b4f238a48de7587c64ccf ]
> 
> Tetsuo Handa had reported he saw an incorrect "downgrading a read lock"
> warning right after a previous lockdep warning. It is likely that the
> previous warning turned off lock debugging causing the lockdep to have
> inconsistency states leading to the lock downgrade warning.
> 
> Fix that by add a check for debug_locks at the beginning of
> __lock_downgrade().

Please drop "[PATCH 4.19 36/63] locking/lockdep: Add debug_locks check in __lock_downgrade()".
We had a revert patch shown below in the past.

"[PATCH 4.19 37/63] locking/lockdep: Add debug_locks check in __lock_downgrade() - again" seems the correct patch.


On 2019/04/25 17:08, gregkh@linuxfoundation.org wrote:> 
> This is a note to let you know that I've just added the patch titled
> 
>     Revert "locking/lockdep: Add debug_locks check in __lock_downgrade()"
> 
> to the 4.19-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      revert-locking-lockdep-add-debug_locks-check-in-__lock_downgrade.patch
> and it can be found in the queue-4.19 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
>>From 7f437eec35a20f40d9ff82ae1c072b211c29e8e0 Mon Sep 17 00:00:00 2001
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date: Thu, 25 Apr 2019 10:00:43 +0200
> Subject: Revert "locking/lockdep: Add debug_locks check in __lock_downgrade()"
> 
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This reverts commit 0e0f7b30721233ce610bde2395a8e58ff7771475 which was
> commit 71492580571467fb7177aade19c18ce7486267f5 upstream.
> 
> Tetsuo rightly points out that the backport here is incorrect, as it
> touches the __lock_set_class function instead of the intended
> __lock_downgrade function.
> 
> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  kernel/locking/lockdep.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -3567,9 +3567,6 @@ __lock_set_class(struct lockdep_map *loc
>  	unsigned int depth;
>  	int i;
>  
> -	if (unlikely(!debug_locks))
> -		return 0;
> -
>  	depth = curr->lockdep_depth;
>  	/*
>  	 * This function is about (re)setting the class of a held lock,
> 
> 
