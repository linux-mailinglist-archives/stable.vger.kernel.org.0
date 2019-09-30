Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93416C1A01
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 03:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbfI3Bqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 21:46:42 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51625 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfI3Bqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 21:46:42 -0400
Received: from fsav107.sakura.ne.jp (fsav107.sakura.ne.jp [27.133.134.234])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x8U1keTx039047;
        Mon, 30 Sep 2019 10:46:40 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav107.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav107.sakura.ne.jp);
 Mon, 30 Sep 2019 10:46:40 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav107.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126227201116.bbtec.net [126.227.201.116])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x8U1kdAt039043
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Mon, 30 Sep 2019 10:46:40 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH 4.19 36/63] locking/lockdep: Add debug_locks check in
 __lock_downgrade()
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+53383ae265fb161ef488@syzkaller.appspotmail.com,
        Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@kernel.org>
References: <20190929135031.382429403@linuxfoundation.org>
 <20190929135038.482721804@linuxfoundation.org>
 <801c81d2-ce72-8eb3-a18b-1b0943270fc4@i-love.sakura.ne.jp>
 <20190930002828.GQ8171@sasha-vm>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <b0203141-297f-1138-5988-607e076cbcf0@i-love.sakura.ne.jp>
Date:   Mon, 30 Sep 2019 10:46:39 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190930002828.GQ8171@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/09/30 9:28, Sasha Levin wrote:
> On Sun, Sep 29, 2019 at 11:43:38PM +0900, Tetsuo Handa wrote:
>> On 2019/09/29 22:54, Greg Kroah-Hartman wrote:
>>> From: Waiman Long <longman@redhat.com>
>>>
>>> [ Upstream commit 513e1073d52e55b8024b4f238a48de7587c64ccf ]
>>>
>>> Tetsuo Handa had reported he saw an incorrect "downgrading a read lock"
>>> warning right after a previous lockdep warning. It is likely that the
>>> previous warning turned off lock debugging causing the lockdep to have
>>> inconsistency states leading to the lock downgrade warning.
>>>
>>> Fix that by add a check for debug_locks at the beginning of
>>> __lock_downgrade().
>>
>> Please drop "[PATCH 4.19 36/63] locking/lockdep: Add debug_locks check in __lock_downgrade()".
>> We had a revert patch shown below in the past.
> 
> We had a revert in the stable trees, but that revert was incorrect.
> 
> Take a look at commit 513e1073d52e55 upstream, it patches
> __lock_set_class() (even though the subject line says
> __lock_downgrade()). So this is not a backporting error as the revert
> said it is, but is rather the intended location to be patched.
> 
> If this is actually wrong, then it should be addressed upstream first.
> 

Hmm, upstream has two commits with same author, same date, same subject, different hash, different content.
I couldn't find from https://lkml.kernel.org/r/1547093005-26085-1-git-send-email-longman@redhat.com that
we want to patch both __lock_set_class() and __lock_downgrade(), but I found that the tip-bot has patched
__lock_downgrade() on "2019-01-21 11:29" and __lock_set_class() on "2019-02-04  8:56".
Seems that we by error patched both functions, though patching both functions should be harmless...

64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4115) static int
00ef9f734 kernel/lockdep.c         (Peter Zijlstra            2008-12-04 09:00:17 +0100 4116) __lock_set_class(struct lockdep_map *lock, const char *name,
00ef9f734 kernel/lockdep.c         (Peter Zijlstra            2008-12-04 09:00:17 +0100 4117)            struct lock_class_key *key, unsigned int subclass,
00ef9f734 kernel/lockdep.c         (Peter Zijlstra            2008-12-04 09:00:17 +0100 4118)            unsigned long ip)
64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4119) {
64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4120)   struct task_struct *curr = current;
8c8889d8e kernel/locking/lockdep.c (Imre Deak                 2019-05-24 23:15:08 +0300 4121)   unsigned int depth, merged = 0;
41c2c5b86 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:15 +0900 4122)   struct held_lock *hlock;
64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4123)   struct lock_class *class;
64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4124)   int i;
64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4125)
513e1073d kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4126)   if (unlikely(!debug_locks))
513e1073d kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4127)           return 0;
513e1073d kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4128)

6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4162) static int __lock_downgrade(struct lockdep_map *lock, unsigned long ip)
6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4163) {
6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4164)   struct task_struct *curr = current;
8c8889d8e kernel/locking/lockdep.c (Imre Deak                 2019-05-24 23:15:08 +0300 4165)   unsigned int depth, merged = 0;
6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4166)   struct held_lock *hlock;
6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4167)   int i;
6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4168)
714925805 kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4169)   if (unlikely(!debug_locks))
714925805 kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4170)           return 0;
714925805 kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4171)

commit 513e1073d52e55b8024b4f238a48de7587c64ccf
Author: Waiman Long <longman@redhat.com>
Date:   Wed Jan 9 23:03:25 2019 -0500

    locking/lockdep: Add debug_locks check in __lock_downgrade()

commit 71492580571467fb7177aade19c18ce7486267f5
Author: Waiman Long <longman@redhat.com>
Date:   Wed Jan 9 23:03:25 2019 -0500

    locking/lockdep: Add debug_locks check in __lock_downgrade()

