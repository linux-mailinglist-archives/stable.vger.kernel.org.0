Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAFE392E01
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 14:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhE0MdT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 27 May 2021 08:33:19 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:58444 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235143AbhE0MdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 08:33:15 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-nkm0D6TAM16qtowWrDKxhA-1; Thu, 27 May 2021 08:31:38 -0400
X-MC-Unique: nkm0D6TAM16qtowWrDKxhA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4F22DF8B3;
        Thu, 27 May 2021 12:31:37 +0000 (UTC)
Received: from bahia.lan (ovpn-112-46.ams2.redhat.com [10.36.112.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 344446061F;
        Thu, 27 May 2021 12:31:35 +0000 (UTC)
Date:   Thu, 27 May 2021 14:31:34 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Max Reitz <mreitz@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, virtio-fs@redhat.com,
        linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/4] fuse: Fix infinite loop in sget_fc()
Message-ID: <20210527143134.2792d2fd@bahia.lan>
In-Reply-To: <58c70352-2df5-0cb9-9ca6-bb4bf2edd1c2@redhat.com>
References: <20210525150230.157586-1-groug@kaod.org>
        <20210525150230.157586-3-groug@kaod.org>
        <58c70352-2df5-0cb9-9ca6-bb4bf2edd1c2@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=groug@kaod.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 May 2021 12:08:36 +0200
Max Reitz <mreitz@redhat.com> wrote:

> On 25.05.21 17:02, Greg Kurz wrote:
> > We don't set the SB_BORN flag on submounts. This is wrong as these
> > superblocks are then considered as partially constructed or dying
> > in the rest of the code and can break some assumptions.
> > 
> > One such case is when you have a virtiofs filesystem with submounts
> > and you try to mount it again : virtio_fs_get_tree() tries to obtain
> > a superblock with sget_fc(). The logic in sget_fc() is to loop until
> > it has either found an existing matching superblock with SB_BORN set
> > or to create a brand new one. It is assumed that a superblock without
> > SB_BORN is transient and should go away. Forgetting to set SB_BORN on
> > submounts hence causes sget_fc() to retry forever.
> > 
> > Setting SB_BORN requires special care, i.e. a write barrier for
> > super_cache_count() which can check SB_BORN without taking any lock.
> > We should call vfs_get_tree() to deal with that but this requires
> > to have a proper ->get_tree() implementation for submounts, which
> > is a bigger piece of work. Go for a simple bug fix in the meatime.
> > 
> > Fixes: bf109c64040f ("fuse: implement crossmounts")
> > Cc: mreitz@redhat.com
> > Cc: stable@vger.kernel.org # v5.10+
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> > ---
> >   fs/fuse/dir.c | 10 ++++++++++
> >   1 file changed, 10 insertions(+)
> > 
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index 01559061cbfb..3b0482738741 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -346,6 +346,16 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
> >   		goto out_put_sb;
> >   	}
> >   
> > +	/*
> > +	 * FIXME: setting SB_BORN requires a write barrier for
> > +	 *        super_cache_count(). We should actually come
> > +	 *        up with a proper ->get_tree() implementation
> > +	 *        for submounts and call vfs_get_tree() to take
> > +	 *        care of the write barrier.
> > +	 */
> > +	smp_wmb();
> > +	sb->s_flags |= SB_BORN;
> > +
> 
> I’m not sure whether we should have the order be exactly the same as in 
> vfs_get_tree(), i.e. whether this should be put after fsc->root has been 
> set.  Or maybe even after fm has been added to fc->mounts, because that 
> too was part of the fuse_get_tree_submount() function of your “fuse: 
> Call vfs_get_tree() for submounts” patch.
> 

Good catch !

>  From a quick look at SB_BORN users, it doesn’t seem to make a 
> difference to me, though, so:
> 

Same here but I'm fine with posting a new version that
preserves the order.

> Reviewed-by: Max Reitz <mreitz@redhat.com>
> 

Thanks !

--
Greg

> >   	sb->s_flags |= SB_ACTIVE;
> >   	fsc->root = dget(sb->s_root);
> >   	/* We are done configuring the superblock, so unlock it */
> > 
> 

