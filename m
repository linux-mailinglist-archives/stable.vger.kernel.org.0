Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB77251F9B
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 21:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgHYTM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 15:12:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:44178 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgHYTM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 15:12:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 89B9DB70C;
        Tue, 25 Aug 2020 19:12:57 +0000 (UTC)
Date:   Tue, 25 Aug 2020 21:12:25 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        mingo@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com,
        christian@kellner.me, areber@redhat.com,
        Shakeel Butt <shakeelb@google.com>, cyphar@cyphar.com,
        Oleg Nesterov <oleg@redhat.com>, adobriyan@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        gladkov.alexey@gmail.com, Michel Lespinasse <walken@google.com>,
        daniel.m.jordan@oracle.com, avagin@gmail.com,
        bernd.edlinger@hotmail.de,
        John Johansen <john.johansen@canonical.com>,
        laoar.shao@gmail.com, Tim Murray <timmurray@google.com>,
        Minchan Kim <minchan@kernel.org>,
        kernel-team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, stable <stable@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/1] mm, oom_adj: don't loop through tasks in
 __set_oom_adj when not necessary
Message-ID: <20200825191225.GK22869@dhcp22.suse.cz>
References: <20200824153036.3201505-1-surenb@google.com>
 <87imd6n0qk.fsf@x220.int.ebiederm.org>
 <CAJuCfpG4emt9vT8qdakc8Myoc65XyxSgg30Am0Z67z+hc-Psbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpG4emt9vT8qdakc8Myoc65XyxSgg30Am0Z67z+hc-Psbg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 25-08-20 10:36:45, Suren Baghdasaryan wrote:
> On Tue, Aug 25, 2020 at 9:38 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
[...]
> > > diff --git a/include/linux/oom.h b/include/linux/oom.h
> > > index f022f581ac29..861f22bd4706 100644
> > > --- a/include/linux/oom.h
> > > +++ b/include/linux/oom.h
> > > @@ -55,6 +55,7 @@ struct oom_control {
> > >  };
> > >
> > >  extern struct mutex oom_lock;
> > > +extern struct mutex oom_adj_lock;
> >                        ^^^^^^^^^^^^^^
> >
> > I understand moving this lock by why renaming it?
> 
> To be consistent with the mutex name right above it. I'm ok keeping it
> as before if this is too much additional churn. I guess Michal deals
> with this code more than anyone else, so I'll wait for him to comment
> on this one.

I cannot say I would care deeply about naming. Consistency looks nice
but if there is a preference to keep the lock then I will not object.

-- 
Michal Hocko
SUSE Labs
