Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FE942AD95
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 22:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhJLUIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 16:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbhJLUIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 16:08:31 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5EAC061570;
        Tue, 12 Oct 2021 13:06:28 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id h4so944204uaw.1;
        Tue, 12 Oct 2021 13:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wdKcDVXA6vAqIyBI6HG7iRr8yhpfW6/IUUuBnFjc/Ko=;
        b=jzH7BZ2sostp0IMUQJRXq1kZDcpC8rH3Bths0FwXAKs7DbReDBG/RMaj+kIZRqMnPA
         h3bp7jrBJVrWAhi0rWhcgUzWv8mOLXvFyUvyICxh5Ddi7TdygPEg9bwcW3Hnq+VeQufq
         ub7GgMq3EnAZS64GSjz47HR2/z5CrioDuPIaevTfpuNUwx5b1s8kNMEa0KFu/AzgA46R
         Rf4xAYbW14tEqM/A+VzxMLY8V9fOfY9yiE3qXPncsutKQIaB14rGLZAj+L/79UbI+p/X
         Jl1PXiCdTxYolwgruDXWlD9erzJXbyOK9VBO9Di8Cb73yKDs8/HxkCFqWAqzLetmd1xi
         ZTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wdKcDVXA6vAqIyBI6HG7iRr8yhpfW6/IUUuBnFjc/Ko=;
        b=Gw6JB+6/VstyTmFUI8LdBP2Qs8YNsL4aos2upGUK1Mhez+vqtN5ZGx+EANPg5c0kSb
         DJuBf2hqNV4minBeEcETcgTQc6OjNl5Ji5iZ+Wb+xuWLW9mb336gEG13DyAe7hytsOX+
         yFbxX4B8e5RBfAV2GgZ9QMqRrgeXmUeOxDuaFQbNlsClUXJq2cpVvxeEQTRuYTtzTVMH
         yQX5iKUO+26vPxJLJbuixw02USNQ7nFftnCnw34H8292oDal3I+Uw796xrHY0kod4/eW
         tzcUMXi4U9TR0kcFXLJ84w5eZnwHya/1h7HGiOpxrdHaD0iMKLSqRw9GYURNT2s6Rydp
         h9Rw==
X-Gm-Message-State: AOAM533fK4qCZAHIVBCu7SpHoPEQDTArSAbgVR2N246ia6+V9tmyUUdC
        K7Lhd4vNU0axDryRm8t3v8j1+2FNKyr/EpGgvdw=
X-Google-Smtp-Source: ABdhPJzYyE2fBqIQcPey9Eru5GAEwZ6pSnvXn/ieRwMnowq6Brkpbtm+ScCXWMhCmyqMYjIZ1Vz2HucYVuv+9iUEAo4=
X-Received: by 2002:ab0:3d06:: with SMTP id f6mr26026482uax.65.1634069187402;
 Tue, 12 Oct 2021 13:06:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211012134915.38994-1-jlayton@kernel.org> <CAOi1vP8L74DQAKHrF9FFz00pvqcktOXLdemhFGmXsROZCtNB=w@mail.gmail.com>
 <e69f6a977f01eb8493284395b04981a7def580b2.camel@kernel.org>
In-Reply-To: <e69f6a977f01eb8493284395b04981a7def580b2.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 12 Oct 2021 22:05:54 +0200
Message-ID: <CAOi1vP-jyg1E1eBB7NrtcmQB=2wYFXht669kgFqTsmgVeX-h4w@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: skip existing superblocks that are blocklisted
 or shut down when mounting
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Niels de Vos <ndevos@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>, stable@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 12, 2021 at 9:42 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2021-10-12 at 21:05 +0200, Ilya Dryomov wrote:
> > On Tue, Oct 12, 2021 at 3:49 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > Currently when mounting, we may end up finding an existing superblock
> > > that corresponds to a blocklisted MDS client. This means that the new
> > > mount ends up being unusable.
> > >
> > > If we've found an existing superblock with a client that is already
> > > blocklisted, and the client is not configured to recover on its own,
> > > fail the match. Ditto if the superblock has been forcibly unmounted.
> > >
> > > While we're in here, also rename "other" to the more conventional "fsc".
> > >
> > > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > > Cc: Niels de Vos <ndevos@redhat.com>
> > > Cc: "Yan, Zheng" <ukernel@gmail.com>
> > > Cc: stable@vger.kernel.org
> > > URL: https://bugzilla.redhat.com/show_bug.cgi?id=1901499
> > > Reviewed-by: Xiubo Li <xiubli@redhat.com>
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > >
> > > ceph: when comparing superblocks, skip ones that have been forcibly unmounted
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> >
> > Hi Jeff,
> >
> > This looks like a squashing left-over.
> >
>
> Yep, that can be removed.
>
> > > ---
> > >  fs/ceph/super.c | 17 ++++++++++++++---
> > >  1 file changed, 14 insertions(+), 3 deletions(-)
> > >
> > > v3: also handle the case where we have a forcibly unmounted superblock
> > >     that is detached but still extant
> > >
> > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > index f517ad9eeb26..b9ba50c9dc95 100644
> > > --- a/fs/ceph/super.c
> > > +++ b/fs/ceph/super.c
> > > @@ -1123,16 +1123,16 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
> > >         struct ceph_fs_client *new = fc->s_fs_info;
> > >         struct ceph_mount_options *fsopt = new->mount_options;
> > >         struct ceph_options *opt = new->client->options;
> > > -       struct ceph_fs_client *other = ceph_sb_to_client(sb);
> > > +       struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> > >
> > >         dout("ceph_compare_super %p\n", sb);
> > >
> > > -       if (compare_mount_options(fsopt, opt, other)) {
> > > +       if (compare_mount_options(fsopt, opt, fsc)) {
> > >                 dout("monitor(s)/mount options don't match\n");
> > >                 return 0;
> > >         }
> > >         if ((opt->flags & CEPH_OPT_FSID) &&
> > > -           ceph_fsid_compare(&opt->fsid, &other->client->fsid)) {
> > > +           ceph_fsid_compare(&opt->fsid, &fsc->client->fsid)) {
> > >                 dout("fsid doesn't match\n");
> > >                 return 0;
> > >         }
> > > @@ -1140,6 +1140,17 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
> > >                 dout("flags differ\n");
> > >                 return 0;
> > >         }
> > > +       /* Exclude any blocklisted superblocks */
> >
> > Nit: given the dout message that follows, this comment seems useless.
> >
> > Thanks,
> >
> >                 Ilya
>
> I'm fine with removing that comment. Would you rather I resend, or do
> you just want to fix up the nits in-tree?

The squashing left-over is already fixed.  I'll remove the comment
later.

Thanks,

                Ilya
