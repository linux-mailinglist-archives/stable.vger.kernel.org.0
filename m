Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C64FC90A
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 15:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKNOhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 09:37:48 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45940 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfKNOhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 09:37:47 -0500
Received: by mail-yw1-f65.google.com with SMTP id j137so1897889ywa.12;
        Thu, 14 Nov 2019 06:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=adlNbWJT++8x84LHedpmwcETz3O3BWzq6McgCf8yRb0=;
        b=Vx7gNwBI7WuKupMBhpYwqln09RBXdzMPiAFHsF6GxBaQpcu64ynUiidGBXYwCIF8Bu
         i+4x6jRaUAzC2CzLr5BHxqy1sKNP+vX8moutVUeHFzzDZL/n5/UETtW4ml4wz2PqNBhn
         u7upv8UWpRsKwdHqPamKYCSZHekVim2XAe1mLwmkB1EBEcteDis8+J0TFyOlLEnIxulX
         M5z145L3qCAXbnaNdHN5n1HU5AyQ4nZA9R285KVWxx7c2IY0gCEVPOBAWYD33UBRfOO0
         c7b4nFkdEQDG3AF/81eejYFfoPCKV8n4ULnb6Oz1kK6e+CbUurG2Gm0KbRFeI4EvdldU
         v9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=adlNbWJT++8x84LHedpmwcETz3O3BWzq6McgCf8yRb0=;
        b=KtxDFwpsjCB4rLRzLHCr5s+c6Y1lRBKQp/OGPDHV2Ybem2H2CHZgb30ypQEqvfazAT
         aNqGPjrcrHn9Y0SW9/inzLosRhl+Z2ksbioT0qQGpQDccOF8gVpW5yX51/xE0o1df1gF
         yaMkIeqRznY0tSewGvOadZ9u25kVz+MGdX5Q2DcJOvj7Jiujdu2uesbe3Qj0xdlYD8ho
         5DGiJTEYoCEg5TqsYVVN25m4XaX5NHiV6k3/VY1yUY0gBOvu7n7GfBKWF8ZzgkFke92X
         7E9UWaACkKAEChkuDCrFjBzLtDbkJ3V1c0tkopfO/G8qpR9jJh5un8lTvgbM3sj58mIr
         PqrA==
X-Gm-Message-State: APjAAAUepPbAePdHub+wbvau4p6oJqkwyTEJhktliJd4rYzfTc/qJ1tC
        ofzcay7yW5anhMUwRY64+bWok0rEL4KV9Ujt1EemMnrE
X-Google-Smtp-Source: APXvYqypGwJizPbAtIFNtfF9F16+gEKUX1tqhtofapxN8DOGmK+1PIfkktOsNhpPshlC7JgJWq7zZoio52tUJWYfh+4=
X-Received: by 2002:a0d:f305:: with SMTP id c5mr5905050ywf.31.1573742266309;
 Thu, 14 Nov 2019 06:37:46 -0800 (PST)
MIME-Version: 1.0
References: <20191107104957.306383-1-colin.king@canonical.com>
 <CAJfpegtr_xg_VG2npTfaxC+vD7B8bKa_0n9pu5vyfU-XQ9oV9Q@mail.gmail.com>
 <CAOQ4uxhnpeyK6xW-c5NOQZ_h1uhAOUn_BbVVVYhUgZ74KSKDKQ@mail.gmail.com> <CAJfpegu7egxf=BVyVQKKW_icjMbjdLcLdd1FEw5hXLvDaiLNVQ@mail.gmail.com>
In-Reply-To: <CAJfpegu7egxf=BVyVQKKW_icjMbjdLcLdd1FEw5hXLvDaiLNVQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 14 Nov 2019 16:37:35 +0200
Message-ID: <CAOQ4uxh8n-QW+zTe3Y56suyaQf8Tcascj337AbMmKF7jf9=sjw@mail.gmail.com>
Subject: Re: [PATCH][V2] ovl: fix lookup failure on multi lower squashfs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Colin King <colin.king@canonical.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 14, 2019 at 4:12 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Nov 13, 2019 at 5:34 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Nov 13, 2019 at 6:02 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Thu, Nov 7, 2019 at 11:50 AM Colin King <colin.king@canonical.com> wrote:
> > > >
> > > > From: Colin Ian King <colin.king@canonical.com>
> > > >
> > > > In the past, overlayfs required that lower fs have non null uuid in
> > > > order to support nfs export and decode copy up origin file handles.
> > > >
> > > > Commit 9df085f3c9a2 ("ovl: relax requirement for non null uuid of
> > > > lower fs") relaxed this requirement for nfs export support, as long
> > > > as uuid (even if null) is unique among all lower fs.
> > > >
> > > > However, said commit unintentionally also relaxed the non null uuid
> > > > requirement for decoding copy up origin file handles, regardless of
> > > > the unique uuid requirement.
> > > >
> > > > Amend this mistake by disabling decoding of copy up origin file handle
> > > > from lower fs with a conflicting uuid.
> > > >
> > > > We still encode copy up origin file handles from those fs, because
> > > > file handles like those already exist in the wild and because they
> > > > might provide useful information in the future.
> > > >
> > > > Reported-by: Colin Ian King <colin.king@canonical.com>
> > > > Link: https://lore.kernel.org/lkml/20191106234301.283006-1-colin.king@canonical.com/
> > > > Fixes: 9df085f3c9a2 ("ovl: relax requirement for non null uuid ...")
> > > > Cc: stable@vger.kernel.org # v4.20+
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > > ---
> > > >  fs/overlayfs/namei.c     |  8 ++++++++
> > > >  fs/overlayfs/ovl_entry.h |  2 ++
> > > >  fs/overlayfs/super.c     | 16 ++++++++++------
> > > >  3 files changed, 20 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > > > index e9717c2f7d45..f47c591402d7 100644
> > > > --- a/fs/overlayfs/namei.c
> > > > +++ b/fs/overlayfs/namei.c
> > > > @@ -325,6 +325,14 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
> > > >         int i;
> > > >
> > > >         for (i = 0; i < ofs->numlower; i++) {
> > > > +               /*
> > > > +                * If lower fs uuid is not unique among lower fs we cannot match
> > > > +                * fh->uuid to layer.
> > > > +                */
> > > > +               if (ofs->lower_layers[i].fsid &&
> > > > +                   ofs->lower_layers[i].fs->bad_uuid)
> > > > +                       continue;
> > > > +
> > > >                 origin = ovl_decode_real_fh(fh, ofs->lower_layers[i].mnt,
> > > >                                             connected);
> > > >                 if (origin)
> > > > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > > > index a8279280e88d..28348c44ea5b 100644
> > > > --- a/fs/overlayfs/ovl_entry.h
> > > > +++ b/fs/overlayfs/ovl_entry.h
> > > > @@ -22,6 +22,8 @@ struct ovl_config {
> > > >  struct ovl_sb {
> > > >         struct super_block *sb;
> > > >         dev_t pseudo_dev;
> > > > +       /* Unusable (conflicting) uuid */
> > > > +       bool bad_uuid;
> > > >  };
> > > >
> > > >  struct ovl_layer {
> > > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > > > index afbcb116a7f1..5d4faab57ba0 100644
> > > > --- a/fs/overlayfs/super.c
> > > > +++ b/fs/overlayfs/super.c
> > > > @@ -1255,17 +1255,18 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
> > > >  {
> > > >         unsigned int i;
> > > >
> > > > -       if (!ofs->config.nfs_export && !(ofs->config.index && ofs->upper_mnt))
> > > > -               return true;
> > > > -
> >
> > Colin, I mislead you, this should be (I think):
> >
> >        if (!ofs->config.nfs_export && !ofs->upper_mnt)
> >                return true;
> >
> > > >         for (i = 0; i < ofs->numlowerfs; i++) {
> > > >                 /*
> > > >                  * We use uuid to associate an overlay lower file handle with a
> > > >                  * lower layer, so we can accept lower fs with null uuid as long
> > > >                  * as all lower layers with null uuid are on the same fs.
> > > > +                * if we detect multiple lower fs with the same uuid, we
> > > > +                * disable lower file handle decoding on all of them.
> > > >                  */
> > > > -               if (uuid_equal(&ofs->lower_fs[i].sb->s_uuid, uuid))
> > > > +               if (uuid_equal(&ofs->lower_fs[i].sb->s_uuid, uuid)) {
> > > > +                       ofs->lower_fs[i].bad_uuid = true;
> > > >                         return false;
> > > > +               }
> > > >         }
> > > >         return true;
> > > >  }
> > > > @@ -1277,6 +1278,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
> > > >         unsigned int i;
> > > >         dev_t dev;
> > > >         int err;
> > > > +       bool bad_uuid = false;
> > > >
> > > >         /* fsid 0 is reserved for upper fs even with non upper overlay */
> > > >         if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
> > > > @@ -1287,10 +1289,11 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
> > > >                         return i + 1;
> > > >         }
> > > >
> > > > -       if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
> > > > +       if (ofs->upper_mnt && !ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
> > >
> > > This seems bogus: why only check conflicting lower layers if there's
> > > an upper layer?
> >
> > It is bogus - it was my (wrong) suggestion.
> > The thinking was that we only decode origin fh if we have an upper layer
> > and index only valid with upper layer.
> > I forgot the case of nfs_export and lower-only setup.
> > Suggested fix above.
> >
> > >
> > > > +               bad_uuid = true;
> > > >                 ofs->config.index = false;
> > > >                 ofs->config.nfs_export = false;
> > > > -               pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
> > > > +               pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', enforcing index=off,nfs_export=off.\n",
> > >
> > > And this while this makes sense, it doesn't really fit into this patch
> > > (no change of behavior regarding how index and nfs_export are
> > > handled).
> > >
> >
> > Again, this was my (not wrong?) suggestion.
> > What this patch changes is that ovl_lower_uuid_ok() can now return false
> > and we get to this print although user did not ask for index nor nfs_export.
> > So the "falling back" language no longer makes sense.
>
> But does "enforcing" makes sense in this light?  That's not what the
> detected bad_uuid condition is about, it's about failing to utilize
> origin markings to make inode numbers persistent for filesystems that
> have null uuid.   Is that correct?

That is not exactly how I would describe bad_uuid.
ovl_lower_uuid_ok() had already existed for a while
it was requires for decoding lower file handles, which is
a requirement of both index and nfs_export.

What Colin has now reported brings to light the fact that
decoding lower file handles was also required for making inode
numbers persistent.

So the bad_uuid condition is required for all of the above, not
just for decoding origin.

> Can we do a message that makes
> that somewhat more clearer?
>

What about the logs:

                pr_warn("overlayfs: upper fs does not support xattr,
falling back to index=off and metacopy=off.\n");
                pr_warn("overlayfs: upper fs does not support file
handles, falling back to index=off.\n");
                pr_warn("overlayfs: fs on '%s' does not support file
handles, falling back to index=off,nfs_export=off.\n",

Should we also change them to reflect the fact the decoding origin
is not supported???

Seems like a lot of hassle that will end up writing too much information
that most people won't understand.

IIRC, we also do not guaranty persistent inode numbers for hardlinks
when index=off.

As for the change in question (falling back => enforcing), if that bothers you,
we can get rid of this change by testing emitting the print only if
(ofs->config.nfs_export || ofs->config.index).

Thanks,
Amir.
