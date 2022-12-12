Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD0364A667
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 19:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiLLSCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 13:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiLLSCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 13:02:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E5A3BC;
        Mon, 12 Dec 2022 10:02:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFDD4611A1;
        Mon, 12 Dec 2022 18:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEFAC433D2;
        Mon, 12 Dec 2022 18:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670868158;
        bh=3GKIRZb4uU1EeNPMEs5V6EixOSqw1dZwgmBOv4XdRgw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i6rk80ZEyDNj+joL4OYR2+K9v7vTmuT2b63ZLfuv2XwVdKCwdiJosYWDTR7+NYS8h
         b7xBIKNU+Beg8JNxVNNBTWgxDqueLSBcZ7TI/U86wc8KSfqQJdmM9e4vjYsNIWff54
         gDaeD1YBSvAKKVx6aMvKD73xRqYPFg/XBD4EKICCiUDyqJ97HMSWT1nlyUbXYPdFA4
         6yBiFhnn99rF35C7nn4E3GvjqUaZMI2sseB72DXg//n+bQ7jaKLSATkOHV7xzwm++W
         RdVDDFAecxgyNQlZP0+QEQSsPKyzhB2wxDLOaGKfsk4fqRrIl0LQVfmBzk7+xMsmpT
         HtXjrKwg2qWzA==
Message-ID: <c5e95e043a1c79244fb6b3c4bc59f15fe1e9d5f4.camel@kernel.org>
Subject: Re: [PATCH 2/2 v3] ceph: add ceph_lock_info support for file_lock
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de,
        mchangir@redhat.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Mon, 12 Dec 2022 13:02:36 -0500
In-Reply-To: <CAOi1vP-dhH-Z9_dgGLLkqwoZ5di1Bp4o+5zeJRgRHddU=X1AwQ@mail.gmail.com>
References: <20221118020642.472484-1-xiubli@redhat.com>
         <20221118020642.472484-3-xiubli@redhat.com>
         <CAOi1vP-dhH-Z9_dgGLLkqwoZ5di1Bp4o+5zeJRgRHddU=X1AwQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-12-12 at 18:56 +0100, Ilya Dryomov wrote:
> On Fri, Nov 18, 2022 at 3:07 AM <xiubli@redhat.com> wrote:
> >=20
> > From: Xiubo Li <xiubli@redhat.com>
> >=20
> > When ceph releasing the file_lock it will try to get the inode pointer
> > from the fl->fl_file, which the memory could already be released by
> > another thread in filp_close(). Because in VFS layer the fl->fl_file
> > doesn't increase the file's reference counter.
> >=20
> > Will switch to use ceph dedicate lock info to track the inode.
> >=20
> > And in ceph_fl_release_lock() we should skip all the operations if
> > the fl->fl_u.ceph_fl.fl_inode is not set, which should come from
> > the request file_lock. And we will set fl->fl_u.ceph_fl.fl_inode when
> > inserting it to the inode lock list, which is when copying the lock.
> >=20
> > Cc: stable@vger.kernel.org
> > Cc: Jeff Layton <jlayton@kernel.org>
> > URL: https://tracker.ceph.com/issues/57986
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/locks.c                 | 20 ++++++++++++++++++--
> >  include/linux/ceph/ceph_fs_fl.h | 17 +++++++++++++++++
> >  include/linux/fs.h              |  2 ++
> >  3 files changed, 37 insertions(+), 2 deletions(-)
> >  create mode 100644 include/linux/ceph/ceph_fs_fl.h
> >=20
> > diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> > index b191426bf880..621f38f10a88 100644
> > --- a/fs/ceph/locks.c
> > +++ b/fs/ceph/locks.c
> > @@ -34,18 +34,34 @@ static void ceph_fl_copy_lock(struct file_lock *dst=
, struct file_lock *src)
> >  {
> >         struct inode *inode =3D file_inode(dst->fl_file);
> >         atomic_inc(&ceph_inode(inode)->i_filelock_ref);
> > +       dst->fl_u.ceph_fl.fl_inode =3D igrab(inode);
> >  }
> >=20
> > +/*
> > + * Do not use the 'fl->fl_file' in release function, which
> > + * is possibly already released by another thread.
> > + */
> >  static void ceph_fl_release_lock(struct file_lock *fl)
> >  {
> > -       struct inode *inode =3D file_inode(fl->fl_file);
> > -       struct ceph_inode_info *ci =3D ceph_inode(inode);
> > +       struct inode *inode =3D fl->fl_u.ceph_fl.fl_inode;
> > +       struct ceph_inode_info *ci;
> > +
> > +       /*
> > +        * If inode is NULL it should be a request file_lock,
> > +        * nothing we can do.
> > +        */
> > +       if (!inode)
> > +               return;
> > +
> > +       ci =3D ceph_inode(inode);
> >         if (atomic_dec_and_test(&ci->i_filelock_ref)) {
> >                 /* clear error when all locks are released */
> >                 spin_lock(&ci->i_ceph_lock);
> >                 ci->i_ceph_flags &=3D ~CEPH_I_ERROR_FILELOCK;
> >                 spin_unlock(&ci->i_ceph_lock);
> >         }
> > +       fl->fl_u.ceph_fl.fl_inode =3D NULL;
> > +       iput(inode);
> >  }
> >=20
> >  static const struct file_lock_operations ceph_fl_lock_ops =3D {
> > diff --git a/include/linux/ceph/ceph_fs_fl.h b/include/linux/ceph/ceph_=
fs_fl.h
> > new file mode 100644
> > index 000000000000..ad1cf96329f9
> > --- /dev/null
> > +++ b/include/linux/ceph/ceph_fs_fl.h
> > @@ -0,0 +1,17 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * ceph_fs_fl.h - Ceph lock info
> > + *
> > + * LGPL2
> > + */
> > +
> > +#ifndef CEPH_FS_FL_H
> > +#define CEPH_FS_FL_H
> > +
> > +#include <linux/fs.h>
> > +
> > +struct ceph_lock_info {
> > +       struct inode *fl_inode;
> > +};
> > +
> > +#endif
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index d6cb42b7e91c..2b03d5e375d7 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1066,6 +1066,7 @@ bool opens_in_grace(struct net *);
> >=20
> >  /* that will die - we need it for nfs_lock_info */
> >  #include <linux/nfs_fs_i.h>
> > +#include <linux/ceph/ceph_fs_fl.h>
> >=20
> >  /*
> >   * struct file_lock represents a generic "file lock". It's used to rep=
resent
> > @@ -1119,6 +1120,7 @@ struct file_lock {
> >                         int state;              /* state of grant or er=
ror if -ve */
> >                         unsigned int    debug_id;
> >                 } afs;
> > +               struct ceph_lock_info   ceph_fl;
>=20
> Hi Xiubo and Jeff,
>=20
> Xiubo, instead of defining struct ceph_lock_info and including
> a CephFS-specific header file in linux/fs.h, I think we should repeat
> what was done for AFS -- particularly given that ceph_lock_info ends up
> being a dummy type that isn't mentioned anywhere else.
>=20
> Jeff, could you please ack this with your file locking hat on?
>=20

ACK. I think that would be cleaner.

Thanks
--=20
Jeff Layton <jlayton@kernel.org>
