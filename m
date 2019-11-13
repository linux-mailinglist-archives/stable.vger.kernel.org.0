Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9C0FB52A
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 17:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfKMQeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 11:34:16 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:37417 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfKMQeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 11:34:16 -0500
Received: by mail-yw1-f67.google.com with SMTP id v84so901417ywc.4;
        Wed, 13 Nov 2019 08:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiPOE4dEWZID+eZLhWltcit72QEYQwsciv53e7H+Pbo=;
        b=fTqf0eVNZ+usGaW/XhW14kltRi0FuL4zP+EjwcgMfbVaU5lXtjSUx0Hfo7mOWgL+6/
         dRtsyyGS4L3SjrWCY2kdAAwZiZNyaS3cCbgQlKcSL8i3Dc56BUBaxHc/taGlND/z2a3T
         Lu6P6Gi3MAfQgb704PuijtOSHfQei89c+Dqg6jNVlzulyG0yY2/BjKrjitdSDFzLO8yK
         Vsqq7yosYBJrNtTPzqF0mlRJ821kiTTqWw3ZGz2cPKR4eeaoxFAsUJrZsMoS5dEd5kQP
         b0kn1VVnNiyMV9rPYM5rLqz3dLGrph1lvPZbT6BDAL8LKYCrxq8BFPCo9AbJVYJXf27u
         QhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiPOE4dEWZID+eZLhWltcit72QEYQwsciv53e7H+Pbo=;
        b=f8SYGRAd/jEnwf/eKrWw9rvRxp6E5Cv7ebzIaFfkjtMrOOcov12UW0VcI7N5hfnhz2
         nQHzyroekKpo5kbLvQ+h3rwSVN61J4dMt/ASJgmD+yZAw+P02cYY+ifyYcwH2uSU+iVf
         GhpC6XbZeBWt9mXO5n/J34cm5d4wpSgi+JINd7JoonsXt17QRVkz10nVJ4qs7FzvBOYz
         NAamdxRmm0UdjDtqXFVfiTydDAU4XmAvSkts9kj2np+z8LXuVNaBjmlLdpVS3qq8cw2X
         PiZ1Q7mKrffFy06KHD9C9mt7hpLdfEu9T1WoEEaYMn1fnv2ItaR5d3zLPUx94tBxthmp
         QpoA==
X-Gm-Message-State: APjAAAXFHxezjG749H9hOQHfnYZNUgnI4QnqFlyNjyOQWKSUw/ihL0dt
        oW6Q72t2uQH4zKtW+rFWsY5tfBBwhwaD5+ZN8Gww3BE5
X-Google-Smtp-Source: APXvYqxwF0vg12/1JNMqn6YrYdCNFD9+fRDa0Scj9i0AYecSLEJC2Jt6RRGFd6Gf6IagqrXy+Mq7y4KRz9Q/JMqtt5E=
X-Received: by 2002:a81:58c6:: with SMTP id m189mr2523609ywb.25.1573662854934;
 Wed, 13 Nov 2019 08:34:14 -0800 (PST)
MIME-Version: 1.0
References: <20191107104957.306383-1-colin.king@canonical.com> <CAJfpegtr_xg_VG2npTfaxC+vD7B8bKa_0n9pu5vyfU-XQ9oV9Q@mail.gmail.com>
In-Reply-To: <CAJfpegtr_xg_VG2npTfaxC+vD7B8bKa_0n9pu5vyfU-XQ9oV9Q@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 13 Nov 2019 18:34:03 +0200
Message-ID: <CAOQ4uxhnpeyK6xW-c5NOQZ_h1uhAOUn_BbVVVYhUgZ74KSKDKQ@mail.gmail.com>
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

On Wed, Nov 13, 2019 at 6:02 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, Nov 7, 2019 at 11:50 AM Colin King <colin.king@canonical.com> wrote:
> >
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > In the past, overlayfs required that lower fs have non null uuid in
> > order to support nfs export and decode copy up origin file handles.
> >
> > Commit 9df085f3c9a2 ("ovl: relax requirement for non null uuid of
> > lower fs") relaxed this requirement for nfs export support, as long
> > as uuid (even if null) is unique among all lower fs.
> >
> > However, said commit unintentionally also relaxed the non null uuid
> > requirement for decoding copy up origin file handles, regardless of
> > the unique uuid requirement.
> >
> > Amend this mistake by disabling decoding of copy up origin file handle
> > from lower fs with a conflicting uuid.
> >
> > We still encode copy up origin file handles from those fs, because
> > file handles like those already exist in the wild and because they
> > might provide useful information in the future.
> >
> > Reported-by: Colin Ian King <colin.king@canonical.com>
> > Link: https://lore.kernel.org/lkml/20191106234301.283006-1-colin.king@canonical.com/
> > Fixes: 9df085f3c9a2 ("ovl: relax requirement for non null uuid ...")
> > Cc: stable@vger.kernel.org # v4.20+
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  fs/overlayfs/namei.c     |  8 ++++++++
> >  fs/overlayfs/ovl_entry.h |  2 ++
> >  fs/overlayfs/super.c     | 16 ++++++++++------
> >  3 files changed, 20 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index e9717c2f7d45..f47c591402d7 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -325,6 +325,14 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
> >         int i;
> >
> >         for (i = 0; i < ofs->numlower; i++) {
> > +               /*
> > +                * If lower fs uuid is not unique among lower fs we cannot match
> > +                * fh->uuid to layer.
> > +                */
> > +               if (ofs->lower_layers[i].fsid &&
> > +                   ofs->lower_layers[i].fs->bad_uuid)
> > +                       continue;
> > +
> >                 origin = ovl_decode_real_fh(fh, ofs->lower_layers[i].mnt,
> >                                             connected);
> >                 if (origin)
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index a8279280e88d..28348c44ea5b 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -22,6 +22,8 @@ struct ovl_config {
> >  struct ovl_sb {
> >         struct super_block *sb;
> >         dev_t pseudo_dev;
> > +       /* Unusable (conflicting) uuid */
> > +       bool bad_uuid;
> >  };
> >
> >  struct ovl_layer {
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index afbcb116a7f1..5d4faab57ba0 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1255,17 +1255,18 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
> >  {
> >         unsigned int i;
> >
> > -       if (!ofs->config.nfs_export && !(ofs->config.index && ofs->upper_mnt))
> > -               return true;
> > -

Colin, I mislead you, this should be (I think):

       if (!ofs->config.nfs_export && !ofs->upper_mnt)
               return true;

> >         for (i = 0; i < ofs->numlowerfs; i++) {
> >                 /*
> >                  * We use uuid to associate an overlay lower file handle with a
> >                  * lower layer, so we can accept lower fs with null uuid as long
> >                  * as all lower layers with null uuid are on the same fs.
> > +                * if we detect multiple lower fs with the same uuid, we
> > +                * disable lower file handle decoding on all of them.
> >                  */
> > -               if (uuid_equal(&ofs->lower_fs[i].sb->s_uuid, uuid))
> > +               if (uuid_equal(&ofs->lower_fs[i].sb->s_uuid, uuid)) {
> > +                       ofs->lower_fs[i].bad_uuid = true;
> >                         return false;
> > +               }
> >         }
> >         return true;
> >  }
> > @@ -1277,6 +1278,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
> >         unsigned int i;
> >         dev_t dev;
> >         int err;
> > +       bool bad_uuid = false;
> >
> >         /* fsid 0 is reserved for upper fs even with non upper overlay */
> >         if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
> > @@ -1287,10 +1289,11 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
> >                         return i + 1;
> >         }
> >
> > -       if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
> > +       if (ofs->upper_mnt && !ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
>
> This seems bogus: why only check conflicting lower layers if there's
> an upper layer?

It is bogus - it was my (wrong) suggestion.
The thinking was that we only decode origin fh if we have an upper layer
and index only valid with upper layer.
I forgot the case of nfs_export and lower-only setup.
Suggested fix above.

>
> > +               bad_uuid = true;
> >                 ofs->config.index = false;
> >                 ofs->config.nfs_export = false;
> > -               pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
> > +               pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', enforcing index=off,nfs_export=off.\n",
>
> And this while this makes sense, it doesn't really fit into this patch
> (no change of behavior regarding how index and nfs_export are
> handled).
>

Again, this was my (not wrong?) suggestion.
What this patch changes is that ovl_lower_uuid_ok() can now return false
and we get to this print although user did not ask for index nor nfs_export.
So the "falling back" language no longer makes sense.

Thanks,
Amir.
