Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940DBC22B3
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 16:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731602AbfI3OIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 10:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731375AbfI3OIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Sep 2019 10:08:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBF56216F4;
        Mon, 30 Sep 2019 14:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569852493;
        bh=kt7fla+BzzgYe489Sg6nEjWAJ0zp3OgREXHfjYBlS3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=azRfqxqYJMigCAgiF+TDmSvzc2YzSJRfHI98n+QETYLLkFOxzxf8l/lG78ONWtMNy
         zW92z9jldZ1ik4kR1bjORLjYuK5lSN5Yz9nM9uXnb39P6GoWXy4aGeV1P64cw5CRXk
         DsrjMwBJ/x9M/yQA357bBhMh8yoJ/VATM0SanepA=
Date:   Sun, 29 Sep 2019 16:49:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+53383ae265fb161ef488@syzkaller.appspotmail.com,
        Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 36/63] locking/lockdep: Add debug_locks check in
 __lock_downgrade()
Message-ID: <20190929144912.GA2011833@kroah.com>
References: <20190929135031.382429403@linuxfoundation.org>
 <20190929135038.482721804@linuxfoundation.org>
 <801c81d2-ce72-8eb3-a18b-1b0943270fc4@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <801c81d2-ce72-8eb3-a18b-1b0943270fc4@i-love.sakura.ne.jp>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 11:43:38PM +0900, Tetsuo Handa wrote:
> On 2019/09/29 22:54, Greg Kroah-Hartman wrote:
> > From: Waiman Long <longman@redhat.com>
> > 
> > [ Upstream commit 513e1073d52e55b8024b4f238a48de7587c64ccf ]
> > 
> > Tetsuo Handa had reported he saw an incorrect "downgrading a read lock"
> > warning right after a previous lockdep warning. It is likely that the
> > previous warning turned off lock debugging causing the lockdep to have
> > inconsistency states leading to the lock downgrade warning.
> > 
> > Fix that by add a check for debug_locks at the beginning of
> > __lock_downgrade().
> 
> Please drop "[PATCH 4.19 36/63] locking/lockdep: Add debug_locks check in __lock_downgrade()".
> We had a revert patch shown below in the past.

Ugh, I missed that, thanks.

> "[PATCH 4.19 37/63] locking/lockdep: Add debug_locks check in __lock_downgrade() - again" seems the correct patch.

Ok, will keep that one.  And will drop the "again" part of that subject
line, had to add that to make quilt happy :(

thanks for the review.

greg k-h
