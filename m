Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4189669469C
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 14:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBMNKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 08:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjBMNKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 08:10:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6818B16AFF;
        Mon, 13 Feb 2023 05:09:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C1F9B80E09;
        Mon, 13 Feb 2023 13:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC87C433EF;
        Mon, 13 Feb 2023 13:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676293796;
        bh=+lSwRxBRk5BaxrEvWIQ1/kdCEJwwG5mTcu2QWMangHk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vD4dsOxQRr2yVrUrx1F9OjLzpV3HBfkkSAAvGLio956cCpvJGh86OAdf0mIj5FGkM
         Gu9A0SN5lHDEWKrN+TG6yV5ikU6XsBz4C3sFztMpSSfQaa9AmqzUSFUHw1kadutCc1
         BoWt+Z7F/GGi7JFRP0+rzw2ZzPVRMPgwkY7aAxed0AfTUvNHOEMH9H8/7NwqgPynRl
         2cd+8iKCAG2BjA/diBNwY4IlHlwWA31iUBn8HdDYnXoO+J/Hl14MTZpHhDFW+O4OGu
         4H8ZfpAXpPw6OuhW1+FLoJ9sOIiJmAseR4tnBreFlG0Y6X7A9eakNonc8zyaMju3zh
         aQmcAnKTAkzKA==
Message-ID: <3225027aae8a868ae8b57441c28047710c5356e4.camel@kernel.org>
Subject: Re: [PATCH] ceph: update the time stamps and try to drop the
 suid/sgid
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com,
        Ceph Development <ceph-devel@vger.kernel.org>
Cc:     vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Date:   Mon, 13 Feb 2023 08:09:54 -0500
In-Reply-To: <0700f314-63fa-9324-94d2-5815daca2734@redhat.com>
References: <20230213111038.15021-1-xiubli@redhat.com>
         <732e55f69d06c4e0de3c5c7eee10f254253391f6.camel@kernel.org>
         <0700f314-63fa-9324-94d2-5815daca2734@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2023-02-13 at 20:59 +0800, Xiubo Li wrote:
> On 13/02/2023 20:37, Jeff Layton wrote:
> > On Mon, 2023-02-13 at 19:10 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > >=20
> > > The fallocate will try to clear the suid/sgid if a unprevileged user
> > > changed the file.
> > >=20
> > > There is no Posix item requires that we should clear the suid/sgid
> > > in fallocate code path but this is the default behaviour for most of
> > > the filesystems and the VFS layer. And also the same for the write
> > > code path, which have already support it.
> > >=20
> > Huh, you're right. It really doesn't say anything about the timestamps
> > or setuid bits:
> >=20
> >      https://pubs.opengroup.org/onlinepubs/9699919799/functions/posix_f=
allocate.html
> >=20
> >=20
> > That's arguably a bug in the spec. It really does need to do those
> > things.
>=20
> Yeah.
>=20

Actually, posix_fallocate doesn't do hole punching. It just ensures that
blocks are reserved to back future writes. Given that that's not
something "observable" and won't change the contents of the file, then
there really is no need to change the times and clear set{u,g}id bits
there.

Linux' fallocate is different. It's a GNU API not covered by POSIX, and
can result in an observable change to the contents of the file. There,
we _must_ clear the setuid/setgid bits and update timestamps, at least
in the cases where the content can change.


> Also the kernel fuse code and libfuse also need to be improved to make=
=20
> ceph-fuse work.
>=20
> Thanks Jeff.
>=20
> - Xiubo
>=20
> > > And also we need to update the time stamps since the fallocate will
> > > change the file contents.
> > >=20
> > > Cc: stable@vger.kernel.org
> > > URL: https://tracker.ceph.com/issues/58054
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/file.c | 8 ++++++++
> > >   1 file changed, 8 insertions(+)
> > >=20
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 903de296f0d3..dee3b445f415 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -2502,6 +2502,9 @@ static long ceph_fallocate(struct file *file, i=
nt mode,
> > >   	loff_t endoff =3D 0;
> > >   	loff_t size;
> > >  =20
> > > +	dout("%s %p %llx.%llx mode %x, offset %llu length %llu\n", __func__=
,
> > > +	     inode, ceph_vinop(inode), mode, offset, length);
> > > +
> > >   	if (mode !=3D (FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> > >   		return -EOPNOTSUPP;
> > >  =20
> > > @@ -2539,6 +2542,10 @@ static long ceph_fallocate(struct file *file, =
int mode,
> > >   	if (ret < 0)
> > >   		goto unlock;
> > >  =20
> > > +	ret =3D file_modified(file);
> > > +	if (ret)
> > > +		goto put_caps;
> > > +
> > >   	filemap_invalidate_lock(inode->i_mapping);
> > >   	ceph_fscache_invalidate(inode, false);
> > >   	ceph_zero_pagecache_range(inode, offset, length);
> > > @@ -2554,6 +2561,7 @@ static long ceph_fallocate(struct file *file, i=
nt mode,
> > >   	}
> > >   	filemap_invalidate_unlock(inode->i_mapping);
> > >  =20
> > > +put_caps:
> > >   	ceph_put_cap_refs(ci, got);
> > >   unlock:
> > >   	inode_unlock(inode);
> > Reviewed-by: Jeff Layton <jlayton@kernel.org>
> >=20

--=20
Jeff Layton <jlayton@kernel.org>
