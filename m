Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B74691095
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 19:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBISqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 13:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBISqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 13:46:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8024216;
        Thu,  9 Feb 2023 10:46:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1A89B822BF;
        Thu,  9 Feb 2023 18:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531B1C433D2;
        Thu,  9 Feb 2023 18:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675968405;
        bh=NA3iBMWRcwiWdDAwavupXMF3yWhQzTQj/BEcxQTPM/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gEBA8p5f1drrwalcpKiwz5P6rKDdKFoNX8y+rW0INdsnt8ucIy+YhSmp5RCVU9ZHV
         452qi9hbX0cxpvblbJ7sg/ihkJkUNKZ3z2vez8Et2PUXeiCB9TPVO6cDBnoZ8nx4By
         rJo3QmhTOXh6HPbtQglP6pTkfKjAPZX9k8xdWdGB7kmUbWmDVQDE12HGT2tzUPgJ8B
         S1ISc1VTJHedYKKI1IBXcfHEjIL9tRa748yllU+ywDbebz737Rd8PNWkPj/nE38DaT
         SBJXGE9F7crNYXg80bBD4yb9ABdb+vI1OJqyCCpPf/Nc5BvZUvA31pE3KZn8s9KO3x
         fwDJJqM/SV4oA==
Date:   Thu, 9 Feb 2023 18:46:43 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Munehisa Kamata <kamatam@amazon.com>, hannes@cmpxchg.org,
        hdanton@sina.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mengcc@amazon.com, stable@vger.kernel.org
Subject: Re: [PATCH] sched/psi: fix use-after-free in ep_remove_wait_queue()
Message-ID: <Y+U/k678tB5w5hJP@gmail.com>
References: <CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com>
 <20230202030023.1847084-1-kamatam@amazon.com>
 <Y9tCl4r/qjqsrVj9@sol.localdomain>
 <CAJuCfpFb0J5ZwO6kncjRG0_4jQLXUy-_dicpH5uGiWP8aKYEJQ@mail.gmail.com>
 <CAJuCfpH4aAAfEJeFzZSGsifhFNCpzZ17MEzXtxhZqoX04jrWbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpH4aAAfEJeFzZSGsifhFNCpzZ17MEzXtxhZqoX04jrWbA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 09, 2023 at 09:09:03AM -0800, Suren Baghdasaryan wrote:
> On Thu, Feb 2, 2023 at 1:11 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Wed, Feb 1, 2023 at 8:56 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Wed, Feb 01, 2023 at 07:00:23PM -0800, Munehisa Kamata wrote:
> > > > diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> > > > index 8ac8b81bfee6..6e66c15f6450 100644
> > > > --- a/kernel/sched/psi.c
> > > > +++ b/kernel/sched/psi.c
> > > > @@ -1343,10 +1343,11 @@ void psi_trigger_destroy(struct psi_trigger *t)
> > > >
> > > >       group = t->group;
> > > >       /*
> > > > -      * Wakeup waiters to stop polling. Can happen if cgroup is deleted
> > > > -      * from under a polling process.
> > > > +      * Wakeup waiters to stop polling and clear the queue to prevent it from
> > > > +      * being accessed later. Can happen if cgroup is deleted from under a
> > > > +      * polling process otherwise.
> > > >        */
> > > > -     wake_up_interruptible(&t->event_wait);
> > > > +     wake_up_pollfree(&t->event_wait);
> > > >
> > > >       mutex_lock(&group->trigger_lock);
> > >
> > > wake_up_pollfree() should only be used in extremely rare cases.  Why can't the
> > > lifetime of the waitqueue be fixed instead?
> >
> > waitqueue lifetime in this case is linked to cgroup_file_release(),
> > which seems appropriate to me here. Unfortunately
> > cgroup_file_release() is not directly linked to the file's lifetime.
> > For more details see:
> > https://lore.kernel.org/all/CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com/#t
> > .
> > So, if we want to fix the lifetime of the waitqueue, we would have to
> > tie cgroup_file_release() to the fput() somehow. IOW, the fix would
> > have to be done at the cgroups or higher (kernfs?) layer.
> 
> Hi Eric,
> Do you still object to using wake_up_pollfree() for this case?
> Changing higher levels to make cgroup_file_release() be tied to fput()
> would be ideal but I think that would be a big change for this one
> case. If you agree I'll Ack this patch.
> Thanks,
> Suren.
> 

I haven't read the code closely in this case.  I'm just letting you know that
wake_up_pollfree() is very much a last-resort option for when the waitqueue
lifetime can't be fixed.  So if you want to use wake_up_pollfree(), you need to
explain why no other fix is possible.  For example maybe the UAPI depends on the
waitqueue having a nonstandard lifetime.

- Eric
