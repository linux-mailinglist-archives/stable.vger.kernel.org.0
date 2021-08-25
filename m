Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8EA3F776A
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 16:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbhHYOcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 10:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbhHYOcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 10:32:32 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4247C061757;
        Wed, 25 Aug 2021 07:31:46 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id z2so24215215iln.0;
        Wed, 25 Aug 2021 07:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=laCdEszt0aD7ybsJ/HjhQubPo1lPPLOx+GmITV5RusQ=;
        b=kPIXq8nIXCnB5kzQ05HqcduGyIoMy8BiwkNmkMR2yPwc4i745ydUWAOReG/g3ZMwO1
         0XKlwIC4DUHkTvyVT2ygM/bjpGmq2s2w0nKVMfFewMTbxIkdXudReTQyX/+7qVPOc81a
         mmK8OpcLNeLrFGkp/G152MR4BfsWKhx6wcdfeWDwv9sj9mwZ7udswTAQ4lAu33s6TTvD
         bk0NZQvPF6wICTj5ANCh6pFJrrnALqh5t5UaTtvGNHAITqxherztFzWjRZ4qwEWm14ww
         plsXQ4ZbRnW8nSFc2X/MtdcIOppdogtFeQpAWn4ErV00xKPs5eeMlDpqSCo6OIeVpCp4
         l8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=laCdEszt0aD7ybsJ/HjhQubPo1lPPLOx+GmITV5RusQ=;
        b=cvTEMxdnvLD1MSTc/QgOlIs6BwYAw5QdCihWRRSTsmvlfvea7fcf/lmqjKYRc8OPt5
         RkE0grTk7QeSb82bIUaxrLPR9EqMW3UHZFnwvKeUYVE+LLWZyfqbC3qh4qSGE9YWWiZo
         6cDMmFmJlARAlkVnxzuIPY5qMYseREYRjdZbMDolBOIad9ExOX3a6wFdYryr1+96G16b
         FEId65bG/5RATa2hOj64U7IyB9adQaCIHqZve0sl35PcydgFaHeenOoAs9hKnYHSURrd
         R2LPQXxLB2nTvSdwbB9zld7BfrhVn+Yvx9WG+Tf1UgsA391ZywJL2EW+AoxwAyehbHi4
         IYeA==
X-Gm-Message-State: AOAM531cY5AQE9OKa8dJHn3wP+rRwN4KT700yFzhTT0NnbWovsvJxeV7
        KOR+2vuAdv5+4VXhn9y9nM3hVZmzQ3IPz1j5ziaPcGuJcyqlFQ==
X-Google-Smtp-Source: ABdhPJzCW9DPCnWdxy3r6FXra2wkvDNyLzU+sf1+4SW/kJIfvlelhPIXXPYMcQcF6Kyq3O3SI+epde1x6HKwA/VvCAA=
X-Received: by 2002:a05:6e02:1a6f:: with SMTP id w15mr30874580ilv.281.1629901906136;
 Wed, 25 Aug 2021 07:31:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210825052212.19625-1-xiubli@redhat.com> <da7fe11c497e61573434591fe1dc07424eca0399.camel@kernel.org>
In-Reply-To: <da7fe11c497e61573434591fe1dc07424eca0399.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 25 Aug 2021 16:31:29 +0200
Message-ID: <CAOi1vP9ED1ZaPuueDPjeWx_b-Nsu_B8FqnRq49NyzMLgD99c9g@mail.gmail.com>
Subject: Re: [PATCH] ceph: init the i_list/g_list for cap flush
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, "Yan, Zheng" <ukernel@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 25, 2021 at 12:50 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2021-08-25 at 13:22 +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > Always init the i_list/g_list in the begining to make sure it won't
> > crash the kernel if someone want to delete the cap_flush from the
> > lists.
> >
> > Cc: stable@vger.kernel.org
> > URL: https://tracker.ceph.com/issues/52401
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/caps.c | 2 +-
> >  fs/ceph/snap.c | 2 ++
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 4f0dbc640b0b..60f60260cf42 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -3666,7 +3666,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
> >       while (!list_empty(&to_remove)) {
> >               cf = list_first_entry(&to_remove,
> >                                     struct ceph_cap_flush, i_list);
> > -             list_del(&cf->i_list);
> > +             list_del_init(&cf->i_list);
> >               if (!cf->is_capsnap)
> >                       ceph_free_cap_flush(cf);
> >       }
> > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > index 62fab59bbf96..b41e6724c591 100644
> > --- a/fs/ceph/snap.c
> > +++ b/fs/ceph/snap.c
> > @@ -488,6 +488,8 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
> >               return;
> >       }
> >       capsnap->cap_flush.is_capsnap = true;
> > +     INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
> > +     INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
> >
> >       spin_lock(&ci->i_ceph_lock);
> >       used = __ceph_caps_used(ci);
>
> I'm not certain the second hunk is strictly needed. These either end up
> on the list or they just get freed. That said, they shouldn't hurt
> anything and it is more consistent. Merged into testing.
>
> Ilya, since this is marked for stable, this probably ought to go to
> Linus in the last v5.14 pile.

I'm inclined to fold this into "ceph: correctly handle releasing an
embedded cap flush" which is already queued for 5.14.

Thanks,

                Ilya
