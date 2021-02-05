Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E697A311121
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhBERnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhBERlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 12:41:01 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E807C061756;
        Fri,  5 Feb 2021 11:22:44 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id m22so9101539ljj.4;
        Fri, 05 Feb 2021 11:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F2vsApDg2B3glC5E0j7mMjIzbTbx0EI6gxSiyVDvcXs=;
        b=W22aY6M+qGPtyiVVqnBVYKVgtdw8bg69xFcMto8ut4LKn3xDVhzCR714TEkDUZXB65
         bG2twq0QG0IKmid7s7ZNeokWEJVYdt/YSzTtG9itWlktL5XtlTGb4Suvhu4ogXa01jWL
         UYAQsbkp2sR65Nicgitdi4gll5bLLvuIekoTjiabCbqg4ouVvYkGbkw5bVl+DIvepOCF
         1XdA7rHWSM6kiBa9Vuc9UOZQkXC649rqNtu3vXhSGrsq95gRA7EiukfMtstvjOEECL5F
         bQ0O36VQn9GZphlbZ9gd+UFwwGIJvfZ4IR5PTe+b585bTwJ1M8U9qyJzPYcpNR3BBfb9
         K1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F2vsApDg2B3glC5E0j7mMjIzbTbx0EI6gxSiyVDvcXs=;
        b=DO4V1gT+pI00VdWQM1UaYrkLmI8nQFwc7C0evbeA0uxo59/5oYSILkpTn0g1p14N7I
         SCK/fxuRoMHaUi6LKvQv/I47OOkYnrtU8D8DGmaVyNl8u5Gxti2XlBUBO82rwoQbYLnu
         eXrN+zO+JWOZ/ScsJyW+ecuZgvmi8yWsqq7k4MrtkqleijpaseCLQrYDgTqMrYR+qsJx
         VPOyLFtMuEdm2A2RhLS63K08yjYAhl79P8UTHtoMJCz0eRdmfXHzP7ylENCaKLtL2UQ9
         IcNRma6Ahlagz2Toml1I9pk9KsJujc9QwoxcuM/SOHBpiGL50fHRqZJ7uC3P0iIIOu4W
         /jAA==
X-Gm-Message-State: AOAM5313merIjgcFJhp6qytIopLndhInYoOJYXbzSlbWEbiUK+0vn0Fq
        3Ngvad++wobR/fv56NRM4toYSsBOkCmGIw4kMz0=
X-Google-Smtp-Source: ABdhPJwKZiAP0rDyEetgcQRONiYE9BR58NzkRwu0TdURLwmIuytVyytmgBSQc+49PP5p/SjusMD/upEJyzLW111sk8Q=
X-Received: by 2002:a05:651c:548:: with SMTP id q8mr3501352ljp.256.1612552962974;
 Fri, 05 Feb 2021 11:22:42 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=o4b9RfQ5omd911pLH3WFbiC1-ghF43kRZ5-4SV+PeS=g@mail.gmail.com>
 <20210205144248.13508-1-aaptel@suse.com> <CANT5p=p7Ah_yFsmpj7VCzuoszpf6WiU+G8jws24njXgM_gv_mQ@mail.gmail.com>
In-Reply-To: <CANT5p=p7Ah_yFsmpj7VCzuoszpf6WiU+G8jws24njXgM_gv_mQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 5 Feb 2021 13:22:31 -0600
Message-ID: <CAH2r5mvzQa4B2c-=F5f5x=XMxXTius4J=oyHXBGbMAnsxCr2mQ@mail.gmail.com>
Subject: Re: [PATCH v4] cifs: report error instead of invalid when
 revalidating a dentry fails
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 5, 2021 at 8:52 AM Shyam Prasad N <nspmangalore@gmail.com> wrot=
e:
>
> Looks good to me.

We do need to find out how a single client test could generate ESTALE
though (perhaps we forgot to drop a dentry on delete or rmdir).
The test is doing fsstress, so should be easy enough to shorten it
and repro and find out exactly why the ESTALE is coming.


> Maybe change the FYI in the cifs_dbg line above to VFS?

Probably safer to put a dynamic trace point there in case EACCES or other r=
c
becomes too common in some scenario.

> On Fri, Feb 5, 2021 at 6:42 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
> >
> > From: Aurelien Aptel <aaptel@suse.com>
> >
> > Assuming
> > - //HOST/a is mounted on /mnt
> > - //HOST/b is mounted on /mnt/b
> >
> > On a slow connection, running 'df' and killing it while it's
> > processing /mnt/b can make cifs_get_inode_info() returns -ERESTARTSYS.
> >
> > This triggers the following chain of events:
> > =3D> the dentry revalidation fail
> > =3D> dentry is put and released
> > =3D> superblock associated with the dentry is put
> > =3D> /mnt/b is unmounted
> >
> > This patch makes cifs_d_revalidate() return the error instead of 0
> > (invalid) when cifs_revalidate_dentry() fails, except for ENOENT (file
> > deleted) and ESTALE (file recreated).
> >
> > Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> > Suggested-by: Shyam Prasad N <nspmangalore@gmail.com>
> > CC: stable@vger.kernel.org
> >
> > ---
> >  fs/cifs/dir.c | 22 ++++++++++++++++++++--
> >  1 file changed, 20 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > index 68900f1629bff..97ac363b5df16 100644
> > --- a/fs/cifs/dir.c
> > +++ b/fs/cifs/dir.c
> > @@ -737,6 +737,7 @@ static int
> >  cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
> >  {
> >         struct inode *inode;
> > +       int rc;
> >
> >         if (flags & LOOKUP_RCU)
> >                 return -ECHILD;
> > @@ -746,8 +747,25 @@ cifs_d_revalidate(struct dentry *direntry, unsigne=
d int flags)
> >                 if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(i=
node)))
> >                         CIFS_I(inode)->time =3D 0; /* force reval */
> >
> > -               if (cifs_revalidate_dentry(direntry))
> > -                       return 0;
> > +               rc =3D cifs_revalidate_dentry(direntry);
> > +               if (rc) {
> > +                       cifs_dbg(FYI, "cifs_revalidate_dentry failed wi=
th rc=3D%d", rc);
> > +                       switch (rc) {
> > +                       case -ENOENT:
> > +                       case -ESTALE:
> > +                               /*
> > +                                * Those errors mean the dentry is inva=
lid
> > +                                * (file was deleted or recreated)
> > +                                */
> > +                               return 0;
> > +                       default:
> > +                               /*
> > +                                * Otherwise some unexpected error happ=
ened
> > +                                * report it as-is to VFS layer
> > +                                */
> > +                               return rc;
> > +                       }
> > +               }
> >                 else {
> >                         /*
> >                          * If the inode wasn't known to be a dfs entry =
when
> > --
> > 2.29.2
> >
>
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
