Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD89158CB4
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 11:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgBKKcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 05:32:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:40796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbgBKKcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Feb 2020 05:32:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 901C4AE06;
        Tue, 11 Feb 2020 10:32:31 +0000 (UTC)
Date:   Tue, 11 Feb 2020 10:32:39 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] ceph: fix copy_file_range error path in short copies
Message-ID: <20200211103239.GA21723@suse.com>
References: <20200205192414.GA27345@suse.com>
 <20200206103842.14936-1-lhenriques@suse.com>
 <CAOi1vP_fTwCnUtN6GfpF0ATBSEygzd+waH8qJ1H3ioWmc-xS6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP_fTwCnUtN6GfpF0ATBSEygzd+waH8qJ1H3ioWmc-xS6A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 07:38:10PM +0100, Ilya Dryomov wrote:
> On Thu, Feb 6, 2020 at 11:38 AM Luis Henriques <lhenriques@suse.com> wrote:
> >
> > When there's an error in the copying loop but some bytes have already been
> > copied into the destination file, it is necessary to dirty the caps and
> > eventually update the MDS with the file metadata (timestamps, size).  This
> > patch fixes this error path.
> >
> > Another issue this patch fixes is the destination file size being reported
> > to the MDS.  If we're on the error path but the amount of bytes written
> > has already changed the destination file size, the offset to use is
> > dst_off and not endoff.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> >  fs/ceph/file.c | 18 +++++++++++++-----
> >  1 file changed, 13 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 11929d2bb594..f7f8cb6c243f 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -2104,9 +2104,16 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >                         CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
> >                 if (err) {
> >                         dout("ceph_osdc_copy_from returned %d\n", err);
> > -                       if (!ret)
> > +                       /*
> > +                        * If we haven't done any copy yet, just exit with the
> > +                        * error code; otherwise, return the number of bytes
> > +                        * already copied, update metadata and dirty caps.
> > +                        */
> > +                       if (!ret) {
> >                                 ret = err;
> > -                       goto out_caps;
> > +                               goto out_caps;
> > +                       }
> > +                       goto update_dst_inode;
> >                 }
> >                 len -= object_size;
> >                 src_off += object_size;
> > @@ -2118,16 +2125,17 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >                 /* We still need one final local copy */
> >                 do_final_copy = true;
> >
> > +update_dst_inode:
> >         file_update_time(dst_file);
> >         inode_inc_iversion_raw(dst_inode);
> >
> > -       if (endoff > size) {
> > +       if (dst_off > size) {
> >                 int caps_flags = 0;
> >
> >                 /* Let the MDS know about dst file size change */
> > -               if (ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
> > +               if (ceph_quota_is_max_bytes_approaching(dst_inode, dst_off))
> >                         caps_flags |= CHECK_CAPS_NODELAY;
> > -               if (ceph_inode_set_size(dst_inode, endoff))
> > +               if (ceph_inode_set_size(dst_inode, dst_off))
> >                         caps_flags |= CHECK_CAPS_AUTHONLY;
> >                 if (caps_flags)
> >                         ceph_check_caps(dst_ci, caps_flags, NULL);
> 
> Hi Luis,
> 
> I think this function still has short copy and file size issues:
> 
> - do_splice_direct() may write fewer bytes than requested, including
>   nothing at all (i.e. return 0).  While we don't care about the second
>   call much, handling the first call is crucial because proceeding to
>   the copy-from loop with src/dst_off not at the object boundary will
>   corrupt the destination file.
> 
> - size is set after caps are acquired for the first time and never
>   updated.  But caps are dropped before do_splice_direct(), so by the
>   time we get to dst_off > size check, it may be stale.  Again, data
>   loss if e.g. old-size < dst_off < new-size because the destination
>   file will get truncated...
> 
> Also, src/dst_oloc need to be freed with ceph_oloc_destroy() to avoid
> leaking memory on namespace layouts.
> 
> It seems clear that this function needs to be split, with the new
> loop around do_splice_direct() and the copy-from loop each going into
> a separate functions with clear pre- and post-conditions.

Right, it makes sense to refactor this function and fix all these issues
you're pointing.  It'll be a pain because a lot of parameters will need to
be handed over into these new functions (maybe a new 'struct copy_desc'
can help making it a bit less messy).  Anyway, I'll try to spend some time
working on that and see what I can come up with.

Cheers,
--
Luís
