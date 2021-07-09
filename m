Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D923C214A
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 11:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhGIJPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 05:15:39 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35068 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhGIJPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 05:15:39 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 13BB22217F;
        Fri,  9 Jul 2021 09:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625821975; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wuq8AXnGSyHPWHlBAgr2stU1z9+pJd/xXc0LihvQkIg=;
        b=pLKGEPz4RX9m9xhtNK/iehnkcQPfsO/AwJ5/p4NWMXdfaIK0vEyogXXGG7pqB7oaqjt3IQ
        lfPrkyT0SJWHh4hgIYA9i77fRlp5EnqR+cEJgpGzHXsYcpz5ofWwFL4d0Oobg24cvqcfaO
        8foEucjWZLfQFVmWv/aamHQhOU9hWic=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BBDDAA3BC7;
        Fri,  9 Jul 2021 09:12:54 +0000 (UTC)
Date:   Fri, 9 Jul 2021 11:12:54 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] printk/console: Check consistent sequence number when
 handling race in console_unlock()
Message-ID: <YOgTFsuYYNE3fnkw@alley>
References: <20210702150657.26760-1-pmladek@suse.com>
 <87y2an7w1x.fsf@jogness.linutronix.de>
 <YOWdWs8foEWKbgXy@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOWdWs8foEWKbgXy@alley>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 2021-07-07 14:26:03, Petr Mladek wrote:
> On Sat 2021-07-03 08:32:02, John Ogness wrote:
> > On 2021-07-02, Petr Mladek <pmladek@suse.com> wrote:
> > > The standard printk() tries to flush the message to the console
> > > immediately. It tries to take the console lock. If the lock is
> > > already taken then the current owner is responsible for flushing
> > > even the new message.
> > >
> > > There is a small race window between checking whether a new message is
> > > available and releasing the console lock. It is solved by re-checking
> > > the state after releasing the console lock. If the check is positive
> > > then console_unlock() tries to take the lock again and process the new
> > > message as well.
> > >
> > > The commit 996e966640ddea7b535c ("printk: remove logbuf_lock") causes that
> > > console_seq is not longer read atomically. As a result, the re-check might
> > > be done with an inconsistent 64-bit index.
> > >
> > > Solve it by using the last sequence number that has been checked under
> > > the console lock. In the worst case, it will take the lock again only
> > > to realized that the new message has already been proceed. But it
> > > was possible even before.
> > >
> > > The variable next_seq is marked as __maybe_unused to call down compiler
> > > warning when CONFIG_PRINTK is not defined.
> > 
> > As Sergey already pointed out, this patch is not fixing a real
> > problem. An inconsistent value (or an increased consistent value) would
> > mean that another printer is actively printing, and thus a retry is not
> > necessary anyway.
> 
> Ah, I misunderstood that part. You are right. CPU_X might see wrong
> console_seq only when CPU_Y incremented console_seq. If CPU_X does not do
> retry because of racy console_seq. Then CPU_Y would do retry when
> yet another CPU added yet another new message in the meantime.
> 
> > But this patch will avoid a KASAN message about an unmarked
> > (although safe) data race.
> 
> Yup.
> 
> OK, I am going to queue the patch for-5.15. There is no need to
> rush it for-4.14.

The patch has been committed into printk/linux.git, branch
rework/fixup-for-5.15.

Note that I am going to use topic branches rework/* for the printk
rework from now on. It will allow to be more flexible with pushing
big changes and fixes into linux-next and mainline.

The "rework/" prefix will still allow to differ printk rework-related
changes from "unrelated" printk features and fixes.

As a result, "printk-rework" branch will not longer be merged into
"for-next" or "for-linus" branches. But I am still going to merge
"rework/*" branches there so that "printk-rework" branch shows
the printk rework history. I think about renaming this branch
to "rework/history" or "rework/HEAD".

Best Regards,
Petr
