Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A818C2001
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 13:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbfI3LgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 07:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbfI3Lf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Sep 2019 07:35:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4C17206BB;
        Mon, 30 Sep 2019 11:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569843359;
        bh=9WEhA8JA+UBptPyxfyomZDl3eE0Son1at5a6dFCkZpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bHxPk2ypvO+UY24J4mkRO/KKATPjdvWvN/rfnLCOSf35scy1gjE532dFE2JC0LvqA
         BW//GlJwH8DzlwwfXAKUZ8P2Qk6BniW6WeiQHqYIC3UVTnNJlmrBrcLKp88EReX7Z8
         a+nOWkYgM8MMhS4ZSeRlo4EHQzx/ACsmMpbdINeQ=
Date:   Mon, 30 Sep 2019 07:35:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
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
Subject: Re: [PATCH 4.19 36/63] locking/lockdep: Add debug_locks check in
 __lock_downgrade()
Message-ID: <20190930113557.GR8171@sasha-vm>
References: <20190929135031.382429403@linuxfoundation.org>
 <20190929135038.482721804@linuxfoundation.org>
 <801c81d2-ce72-8eb3-a18b-1b0943270fc4@i-love.sakura.ne.jp>
 <20190930002828.GQ8171@sasha-vm>
 <b0203141-297f-1138-5988-607e076cbcf0@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b0203141-297f-1138-5988-607e076cbcf0@i-love.sakura.ne.jp>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 30, 2019 at 10:46:39AM +0900, Tetsuo Handa wrote:
>On 2019/09/30 9:28, Sasha Levin wrote:
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
>>>
>>> Please drop "[PATCH 4.19 36/63] locking/lockdep: Add debug_locks check in __lock_downgrade()".
>>> We had a revert patch shown below in the past.
>>
>> We had a revert in the stable trees, but that revert was incorrect.
>>
>> Take a look at commit 513e1073d52e55 upstream, it patches
>> __lock_set_class() (even though the subject line says
>> __lock_downgrade()). So this is not a backporting error as the revert
>> said it is, but is rather the intended location to be patched.
>>
>> If this is actually wrong, then it should be addressed upstream first.
>>
>
>Hmm, upstream has two commits with same author, same date, same subject, different hash, different content.
>I couldn't find from https://lkml.kernel.org/r/1547093005-26085-1-git-send-email-longman@redhat.com that
>we want to patch both __lock_set_class() and __lock_downgrade(), but I found that the tip-bot has patched
>__lock_downgrade() on "2019-01-21 11:29" and __lock_set_class() on "2019-02-04  8:56".
>Seems that we by error patched both functions, though patching both functions should be harmless...

Right, there's a lot of confusion between the duplicate subject lines
and what this patch actually does. My point was that this is an upstream
issue rather than a stable issue, we're just aligning with upstream
here.

--
Thanks,
Sasha
