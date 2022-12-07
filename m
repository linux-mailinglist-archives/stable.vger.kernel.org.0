Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EB8645C5A
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiLGOU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiLGOUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:20:34 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22F25FBBB;
        Wed,  7 Dec 2022 06:20:21 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id e13so25062141edj.7;
        Wed, 07 Dec 2022 06:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L/zOay+3Fb/ANlUQ0vmlLf8XMa57liQStI/Efuezn08=;
        b=DINDuKzzcjHJyZB/HqfYmUUBUUNF1+2hI38WG2hmGqJfSVDyaOKtOHFWhH6KW9AFkQ
         gjWJSuBKC5I83nnoKOvk0hdFbk14tP6vM0/pbmI5PVjK/3vaEBD07rt4SIqsWz65wn4n
         8RXOoUpAqJBgf/lIMTyVBIsVcUSb0ziWmBCuRDn95E4XDH1j26tkYUn57dIbFL9u/J//
         BnkCOLjiARQStSwMDtxZnTL2t+evhuokfe6Pri1tQ8fGurvcG8qfvkc2FMFhiV8Mhg2W
         4b9ul8pvjj7QA6+u0U2PolNNvbxgE60TXjvohKyaeIgr7VSmcEA4m04outu5aoJyEB6D
         Sfgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L/zOay+3Fb/ANlUQ0vmlLf8XMa57liQStI/Efuezn08=;
        b=2ofdgm2G9agS8TFzdDnFjAxX0hxLQq8JmYaGImNgkXZZ4GK4AF9vdCvNgTbe45ut/6
         sbd9oTtCtaenVxS6NhXWlzpTragOR7/A+0smHQQuM1ABXwXNQzRrIkR/iRJtCMFa5KA3
         kpTTv24Gg4XnakR3C0fvraUhjUV7bu5BmyyitzA+UTtzmawmlAAfr3E30LruUHNbQy/H
         T8ZVNIoZUFRrvJDBeRZA8RuOQJY3q9lYTAoquoKX+925Uco06YQRpAmjgIYQyVHaEgP7
         hGSyX3ctfRk5Vo+cLLs2oG/dJWFxP6HAviPXHjdArjzfwxfu/DkvX4nyGu4xjk0MDuUi
         MSjw==
X-Gm-Message-State: ANoB5pm+gnMGWr+yxUTWSFQ4KAYkJ44aa2jnHomfFOVWbSiyWxLL7+C/
        tfi0pAU5HbBg9Wiogz7JvXpNJoOOWnwbEmHcZFg=
X-Google-Smtp-Source: AA0mqf50bkvOBEQCmLYcKRJ9JUU/sjDeaMRg2yd/ioYNuQe8H7WHGe03PNDXaKNGZoNznsgDhAGgqjHDeJ4z1UsCyvA=
X-Received: by 2002:aa7:d44d:0:b0:46d:7d3c:30cc with SMTP id
 q13-20020aa7d44d000000b0046d7d3c30ccmr1043443edr.322.1670422820200; Wed, 07
 Dec 2022 06:20:20 -0800 (PST)
MIME-Version: 1.0
References: <20221206125915.37404-1-xiubli@redhat.com> <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
 <baa681e9-4472-bcfb-601f-132dc6658888@redhat.com> <ac1e95e6-f8fa-e243-97bd-a280b8e0fa66@redhat.com>
In-Reply-To: <ac1e95e6-f8fa-e243-97bd-a280b8e0fa66@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 7 Dec 2022 15:20:08 +0100
Message-ID: <CAOi1vP_=2wOSYmrzfdm3k__dVONjXspjV15gbZ+Yq247xmpnXQ@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, atomlin@atomlin.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 7, 2022 at 2:31 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 07/12/2022 21:19, Xiubo Li wrote:
> >
> > On 07/12/2022 18:59, Ilya Dryomov wrote:
> >> On Tue, Dec 6, 2022 at 1:59 PM <xiubli@redhat.com> wrote:
> >>> From: Xiubo Li <xiubli@redhat.com>
> >>>
> >>> When received corrupted snap trace we don't know what exactly has
> >>> happened in MDS side. And we shouldn't continue writing to OSD,
> >>> which may corrupt the snapshot contents.
> >>>
> >>> Just try to blocklist this client and If fails we need to crash the
> >>> client instead of leaving it writeable to OSDs.
> >>>
> >>> Cc: stable@vger.kernel.org
> >>> URL: https://tracker.ceph.com/issues/57686
> >>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>> ---
> >>>
> >>> Thanks Aaron's feedback.
> >>>
> >>> V3:
> >>> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
> >>>
> >>> V2:
> >>> - Switched to WARN() to taint the Linux kernel.
> >>>
> >>>   fs/ceph/mds_client.c |  3 ++-
> >>>   fs/ceph/mds_client.h |  1 +
> >>>   fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
> >>>   3 files changed, 28 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >>> index cbbaf334b6b8..59094944af28 100644
> >>> --- a/fs/ceph/mds_client.c
> >>> +++ b/fs/ceph/mds_client.c
> >>> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct
> >>> ceph_connection *con)
> >>>          struct ceph_mds_client *mdsc = s->s_mdsc;
> >>>
> >>>          pr_warn("mds%d closed our session\n", s->s_mds);
> >>> -       send_mds_reconnect(mdsc, s);
> >>> +       if (!mdsc->no_reconnect)
> >>> +               send_mds_reconnect(mdsc, s);
> >>>   }
> >>>
> >>>   static void mds_dispatch(struct ceph_connection *con, struct
> >>> ceph_msg *msg)
> >>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> >>> index 728b7d72bf76..8e8f0447c0ad 100644
> >>> --- a/fs/ceph/mds_client.h
> >>> +++ b/fs/ceph/mds_client.h
> >>> @@ -413,6 +413,7 @@ struct ceph_mds_client {
> >>>          atomic_t                num_sessions;
> >>>          int                     max_sessions;  /* len of sessions
> >>> array */
> >>>          int                     stopping;      /* true if shutting
> >>> down */
> >>> +       int                     no_reconnect;  /* true if snap trace
> >>> is corrupted */
> >>>
> >>>          atomic64_t              quotarealms_count; /* # realms with
> >>> quota */
> >>>          /*
> >>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> >>> index c1c452afa84d..023852b7c527 100644
> >>> --- a/fs/ceph/snap.c
> >>> +++ b/fs/ceph/snap.c
> >>> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct
> >>> ceph_mds_client *mdsc,
> >>>          struct ceph_snap_realm *realm;
> >>>          struct ceph_snap_realm *first_realm = NULL;
> >>>          struct ceph_snap_realm *realm_to_rebuild = NULL;
> >>> +       struct ceph_client *client = mdsc->fsc->client;
> >>>          int rebuild_snapcs;
> >>>          int err = -ENOMEM;
> >>> +       int ret;
> >>>          LIST_HEAD(dirty_realms);
> >>>
> >>>          lockdep_assert_held_write(&mdsc->snap_rwsem);
> >>> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct
> >>> ceph_mds_client *mdsc,
> >>>          if (first_realm)
> >>>                  ceph_put_snap_realm(mdsc, first_realm);
> >>>          pr_err("%s error %d\n", __func__, err);
> >>> +
> >>> +       /*
> >>> +        * When receiving a corrupted snap trace we don't know what
> >>> +        * exactly has happened in MDS side. And we shouldn't continue
> >>> +        * writing to OSD, which may corrupt the snapshot contents.
> >>> +        *
> >>> +        * Just try to blocklist this kclient and if it fails we need
> >>> +        * to crash the kclient instead of leaving it writeable.
> >> Hi Xiubo,
> >>
> >> I'm not sure I understand this "let's blocklist ourselves" concept.
> >> If the kernel client shouldn't continue writing to OSDs in this case,
> >> why not just stop issuing writes -- perhaps initiating some equivalent
> >> of a read-only remount like many local filesystems would do on I/O
> >> errors (e.g. errors=remount-ro mode)?
> >
> > The following patch seems working. Let me do more test to make sure
> > there is not further crash.
> >
> > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > index c1c452afa84d..cd487f8a4cb5 100644
> > --- a/fs/ceph/snap.c
> > +++ b/fs/ceph/snap.c
> > @@ -767,6 +767,7 @@ int ceph_update_snap_trace(struct ceph_mds_client
> > *mdsc,
> >         struct ceph_snap_realm *realm;
> >         struct ceph_snap_realm *first_realm = NULL;
> >         struct ceph_snap_realm *realm_to_rebuild = NULL;
> > +       struct super_block *sb = mdsc->fsc->sb;
> >         int rebuild_snapcs;
> >         int err = -ENOMEM;
> >         LIST_HEAD(dirty_realms);
> > @@ -885,6 +886,9 @@ int ceph_update_snap_trace(struct ceph_mds_client
> > *mdsc,
> >         if (first_realm)
> >                 ceph_put_snap_realm(mdsc, first_realm);
> >         pr_err("%s error %d\n", __func__, err);
> > +       pr_err("Remounting filesystem read-only\n");
> > +       sb->s_flags |= SB_RDONLY;
> > +
> >         return err;
> >  }
> >
> >
> For readonly approach is also my first thought it should be, but I was
> just not very sure whether it would be the best approach.
>
> Because by evicting the kclient we could prevent the buffer to be wrote
> to OSDs. But the readonly one seems won't ?

The read-only setting is more for the VFS and the user.  Technically,
the kernel client could just stop issuing writes (i.e. OSD requests
containing a write op) and not set SB_RDONLY.  That should cover any
buffered data as well.

By employing self-blocklisting, you are shifting the responsibility
of rejecting OSD requests to the OSDs.  I'm saying that not issuing
OSD requests from a potentially busted client in the first place is
probably a better idea.  At the very least you wouldn't need to BUG
on ceph_monc_blocklist_add() errors.

Thanks,

                Ilya
