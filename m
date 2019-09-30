Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964C4C228F
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 16:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbfI3OAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 10:00:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfI3OAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Sep 2019 10:00:38 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8122C3086262;
        Mon, 30 Sep 2019 14:00:37 +0000 (UTC)
Received: from llong.remote.csb (ovpn-122-104.rdu2.redhat.com [10.10.122.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3D9860C63;
        Mon, 30 Sep 2019 14:00:35 +0000 (UTC)
Subject: Re: [PATCH 4.19 36/63] locking/lockdep: Add debug_locks check in
 __lock_downgrade()
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+53383ae265fb161ef488@syzkaller.appspotmail.com,
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
 <b0203141-297f-1138-5988-607e076cbcf0@i-love.sakura.ne.jp>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <b4e4de80-cabc-3de5-9fa7-8366a8582ba9@redhat.com>
Date:   Mon, 30 Sep 2019 10:00:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <b0203141-297f-1138-5988-607e076cbcf0@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 30 Sep 2019 14:00:37 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/29/19 9:46 PM, Tetsuo Handa wrote:
> On 2019/09/30 9:28, Sasha Levin wrote:
>> On Sun, Sep 29, 2019 at 11:43:38PM +0900, Tetsuo Handa wrote:
>>> On 2019/09/29 22:54, Greg Kroah-Hartman wrote:
>>>> From: Waiman Long <longman@redhat.com>
>>>>
>>>> [ Upstream commit 513e1073d52e55b8024b4f238a48de7587c64ccf ]
>>>>
>>>> Tetsuo Handa had reported he saw an incorrect "downgrading a read lock"
>>>> warning right after a previous lockdep warning. It is likely that the
>>>> previous warning turned off lock debugging causing the lockdep to have
>>>> inconsistency states leading to the lock downgrade warning.
>>>>
>>>> Fix that by add a check for debug_locks at the beginning of
>>>> __lock_downgrade().
>>> Please drop "[PATCH 4.19 36/63] locking/lockdep: Add debug_locks check in __lock_downgrade()".
>>> We had a revert patch shown below in the past.
>> We had a revert in the stable trees, but that revert was incorrect.
>>
>> Take a look at commit 513e1073d52e55 upstream, it patches
>> __lock_set_class() (even though the subject line says
>> __lock_downgrade()). So this is not a backporting error as the revert
>> said it is, but is rather the intended location to be patched.
>>
>> If this is actually wrong, then it should be addressed upstream first.
>>
> Hmm, upstream has two commits with same author, same date, same subject, different hash, different content.
> I couldn't find from https://lkml.kernel.org/r/1547093005-26085-1-git-send-email-longman@redhat.com that
> we want to patch both __lock_set_class() and __lock_downgrade(), but I found that the tip-bot has patched
> __lock_downgrade() on "2019-01-21 11:29" and __lock_set_class() on "2019-02-04  8:56".
> Seems that we by error patched both functions, though patching both functions should be harmless...
>
> 64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4115) static int
> 00ef9f734 kernel/lockdep.c         (Peter Zijlstra            2008-12-04 09:00:17 +0100 4116) __lock_set_class(struct lockdep_map *lock, const char *name,
> 00ef9f734 kernel/lockdep.c         (Peter Zijlstra            2008-12-04 09:00:17 +0100 4117)            struct lock_class_key *key, unsigned int subclass,
> 00ef9f734 kernel/lockdep.c         (Peter Zijlstra            2008-12-04 09:00:17 +0100 4118)            unsigned long ip)
> 64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4119) {
> 64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4120)   struct task_struct *curr = current;
> 8c8889d8e kernel/locking/lockdep.c (Imre Deak                 2019-05-24 23:15:08 +0300 4121)   unsigned int depth, merged = 0;
> 41c2c5b86 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:15 +0900 4122)   struct held_lock *hlock;
> 64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4123)   struct lock_class *class;
> 64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4124)   int i;
> 64aa348ed kernel/lockdep.c         (Peter Zijlstra            2008-08-11 09:30:21 +0200 4125)
> 513e1073d kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4126)   if (unlikely(!debug_locks))
> 513e1073d kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4127)           return 0;
> 513e1073d kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4128)
>
> 6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4162) static int __lock_downgrade(struct lockdep_map *lock, unsigned long ip)
> 6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4163) {
> 6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4164)   struct task_struct *curr = current;
> 8c8889d8e kernel/locking/lockdep.c (Imre Deak                 2019-05-24 23:15:08 +0300 4165)   unsigned int depth, merged = 0;
> 6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4166)   struct held_lock *hlock;
> 6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4167)   int i;
> 6419c4af7 kernel/locking/lockdep.c (J. R. Okajima             2017-02-03 01:38:17 +0900 4168)
> 714925805 kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4169)   if (unlikely(!debug_locks))
> 714925805 kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4170)           return 0;
> 714925805 kernel/locking/lockdep.c (Waiman Long               2019-01-09 23:03:25 -0500 4171)
>
> commit 513e1073d52e55b8024b4f238a48de7587c64ccf
> Author: Waiman Long <longman@redhat.com>
> Date:   Wed Jan 9 23:03:25 2019 -0500
>
>     locking/lockdep: Add debug_locks check in __lock_downgrade()
>
> commit 71492580571467fb7177aade19c18ce7486267f5
> Author: Waiman Long <longman@redhat.com>
> Date:   Wed Jan 9 23:03:25 2019 -0500
>
>     locking/lockdep: Add debug_locks check in __lock_downgrade()
>
As I had said before, it looks like the git-apply mixed up the location
due to the fact that the hunks are exactly the same for both locations.
So if the patch to be applied does not have the right line number, it
will get applied to the wrong location first.

Cheers,
Longman

