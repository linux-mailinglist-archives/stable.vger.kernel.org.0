Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B43645C9E
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiLGO3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiLGO24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:28:56 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C0C58BC7;
        Wed,  7 Dec 2022 06:28:47 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c17so16562389edj.13;
        Wed, 07 Dec 2022 06:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qdZ1QvV9ORUx4PGEtAOvuKpcfA02TBUmSwRhYNY8U0I=;
        b=oJG+pyheLcq476YX/KA6L/nuNbrHOvu3yLgzfVnZ0nE11UNwD0zXCIJXvXNx7wiLaO
         EIIg3BW61UNnvRF37NvL5n6v0S+4KkOqlg0uiYn6m3zvbycp4AQxcJbRWRzJVMpuCCas
         1+FiOfKQjVJ5VF63dxjNiTfEHAJel/ZI5bwDvitbiZKO7uz58V82uUrjn2+/nM+WAJ0X
         zSyc9bPPBPSUqcgtLcoYmM52pwoSOuzgP+IqM/WjSV7nS80Wv1JM4Xx61dbhdGnq8CEY
         VzNWkl2zO3zQLlcRiroRIWyJNDZw4GB94RiUHkWJ43ldkga+O1n454KsGT+7c88i26NU
         T1ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qdZ1QvV9ORUx4PGEtAOvuKpcfA02TBUmSwRhYNY8U0I=;
        b=K6dE87PMvA6TUzu6VEbMrMcoYAIREzk2RFq7PdRy6ggnBExs2Q8MG2eE3A+VDRKGvN
         2P/AWo+ohcwmAKXwLh8UKUpVfcdH421kW8N1IC9mgg3cmoDbJ40QyKkwWbDh8mnpqBdY
         4H/nKQavaHQGtPCRO4nb0ITfi7BKAHrom+4NlsOv545RbuVNS7iHDmfSNbL/LEWMCUyu
         9QqAYvLQZs3xGMZeLPyioJPpLDp6OfwjrficOBnnnZ+Oj/b2YuDylzPMe52ZoLRN433v
         iGYPoCcmcWOI31vj0KgFrQoLG0Hq/pLCHreHVg2YFniZ3M4t7xFmOroFfiB5cO2wvZK8
         ZoWw==
X-Gm-Message-State: ANoB5plWNz3rGgjy9v3aHMlJf49hzMHPYLPaWHXbac7QUjfLHSCAM8Ib
        GhTpDIeL63Km7gCQE9H52cUObnRwPTylyL9xF5cRAp9s5kw=
X-Google-Smtp-Source: AA0mqf6+YHDoq1URy54JV2g7Hl28F57I3ROGCqDwGa2+UMF8sYApdBQs21ib4LoJyTsRR79Yg8vg1JOr2qoe75cxoT4=
X-Received: by 2002:a05:6402:5517:b0:461:c563:defa with SMTP id
 fi23-20020a056402551700b00461c563defamr80594493edb.72.1670423323834; Wed, 07
 Dec 2022 06:28:43 -0800 (PST)
MIME-Version: 1.0
References: <20221206125915.37404-1-xiubli@redhat.com> <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
 <897fc89b-775f-88ce-1550-90c47220dc18@redhat.com>
In-Reply-To: <897fc89b-775f-88ce-1550-90c47220dc18@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 7 Dec 2022 15:28:31 +0100
Message-ID: <CAOi1vP8f_qHpPT05yx2X+dbVb28qq+hkpWP988bVcpabU=b+1Q@mail.gmail.com>
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

On Wed, Dec 7, 2022 at 1:35 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 07/12/2022 18:59, Ilya Dryomov wrote:
> > On Tue, Dec 6, 2022 at 1:59 PM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> When received corrupted snap trace we don't know what exactly has
> >> happened in MDS side. And we shouldn't continue writing to OSD,
> >> which may corrupt the snapshot contents.
> >>
> >> Just try to blocklist this client and If fails we need to crash the
> >> client instead of leaving it writeable to OSDs.
> >>
> >> Cc: stable@vger.kernel.org
> >> URL: https://tracker.ceph.com/issues/57686
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>
> >> Thanks Aaron's feedback.
> >>
> >> V3:
> >> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
> >>
> >> V2:
> >> - Switched to WARN() to taint the Linux kernel.
> >>
> >>   fs/ceph/mds_client.c |  3 ++-
> >>   fs/ceph/mds_client.h |  1 +
> >>   fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
> >>   3 files changed, 28 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >> index cbbaf334b6b8..59094944af28 100644
> >> --- a/fs/ceph/mds_client.c
> >> +++ b/fs/ceph/mds_client.c
> >> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct ceph_connection *con)
> >>          struct ceph_mds_client *mdsc = s->s_mdsc;
> >>
> >>          pr_warn("mds%d closed our session\n", s->s_mds);
> >> -       send_mds_reconnect(mdsc, s);
> >> +       if (!mdsc->no_reconnect)
> >> +               send_mds_reconnect(mdsc, s);
> >>   }
> >>
> >>   static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
> >> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> >> index 728b7d72bf76..8e8f0447c0ad 100644
> >> --- a/fs/ceph/mds_client.h
> >> +++ b/fs/ceph/mds_client.h
> >> @@ -413,6 +413,7 @@ struct ceph_mds_client {
> >>          atomic_t                num_sessions;
> >>          int                     max_sessions;  /* len of sessions array */
> >>          int                     stopping;      /* true if shutting down */
> >> +       int                     no_reconnect;  /* true if snap trace is corrupted */
> >>
> >>          atomic64_t              quotarealms_count; /* # realms with quota */
> >>          /*
> >> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> >> index c1c452afa84d..023852b7c527 100644
> >> --- a/fs/ceph/snap.c
> >> +++ b/fs/ceph/snap.c
> >> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> >>          struct ceph_snap_realm *realm;
> >>          struct ceph_snap_realm *first_realm = NULL;
> >>          struct ceph_snap_realm *realm_to_rebuild = NULL;
> >> +       struct ceph_client *client = mdsc->fsc->client;
> >>          int rebuild_snapcs;
> >>          int err = -ENOMEM;
> >> +       int ret;
> >>          LIST_HEAD(dirty_realms);
> >>
> >>          lockdep_assert_held_write(&mdsc->snap_rwsem);
> >> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> >>          if (first_realm)
> >>                  ceph_put_snap_realm(mdsc, first_realm);
> >>          pr_err("%s error %d\n", __func__, err);
> >> +
> >> +       /*
> >> +        * When receiving a corrupted snap trace we don't know what
> >> +        * exactly has happened in MDS side. And we shouldn't continue
> >> +        * writing to OSD, which may corrupt the snapshot contents.
> >> +        *
> >> +        * Just try to blocklist this kclient and if it fails we need
> >> +        * to crash the kclient instead of leaving it writeable.
> > Hi Xiubo,
> >
> > I'm not sure I understand this "let's blocklist ourselves" concept.
> > If the kernel client shouldn't continue writing to OSDs in this case,
> > why not just stop issuing writes -- perhaps initiating some equivalent
> > of a read-only remount like many local filesystems would do on I/O
> > errors (e.g. errors=remount-ro mode)?
>
> I still haven't found how could I handle it this way from ceph layer. I
> saw they are just marking the inodes as EIO when this happens.
>
> >
> > Or, perhaps, all in-memory snap contexts could somehow be invalidated
> > in this case, making writes fail naturally -- on the client side,
> > without actually being sent to OSDs just to be nixed by the blocklist
> > hammer.
> >
> > But further, what makes a failure to decode a snap trace special?
>
>  From the known tracker the snapid was corrupted in one inode in MDS and
> then when trying to build the snap trace with the corrupted snapid it
> will corrupt.
>
> And also there maybe other cases.
>
> > AFAIK we don't do anything close to this for any other decoding
> > failure.  Wouldn't "when received corrupted XYZ we don't know what
> > exactly has happened in MDS side" argument apply to pretty much all
> > decoding failures?
>
> The snap trace is different from other cases. The corrupted snap trace
> will affect the whole snap realm hierarchy, which will affect the whole
> inodes in the mount in worst case.
>
> This is why I was trying to evict the mount to prevent further IOs.

I suspected as much and my other suggestion was to look at somehow
invalidating snap contexts/realms.  Perhaps decode out-of-place and on
any error set a flag indicating that the snap context can't be trusted
anymore?  The OSD client could then check whether this flag is set
before admitting the snap context blob into the request message and
return an error, effectively rejecting the write.

Thanks,

                Ilya
