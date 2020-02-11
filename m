Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58FB4158D24
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 12:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgBKLEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 06:04:00 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:46006 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbgBKLEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 06:04:00 -0500
Received: by mail-il1-f193.google.com with SMTP id p8so3042747iln.12;
        Tue, 11 Feb 2020 03:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R3y8ZmiEYtDezKD63+l4DczridZuvwHW36ri3A/Fxdk=;
        b=njInSJ1LF/+jt83rq+wKFldX5QtA6salRCBIGztkvhRx7XVRmAWcdivsjlA+w/FjYr
         qtbyGVSaXaY0DtWR5UEbpWVxsdSHJlr6agtKRlkUkXDxWOTU4M1aqAF1NsbpFu2iiC3p
         WGGVPDnqWrKf6ausGnQmp+UoQzcx7RLB4hjkcQIOSDC03QN/kpVgi44CQO9voAG38qP4
         mN4GKzGAu/GYpjk3PxCr1JFB2OPYz4N0rU2+SSEGZee0sQ1pGPbdgY75SRln8W6v7jh8
         UTppcNXm8KA/isIxFwMK+qWwmAjRMXoLw6N9Dn6anTr6RbgV/Yn/gYETUDoN7q6fxr8O
         azhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R3y8ZmiEYtDezKD63+l4DczridZuvwHW36ri3A/Fxdk=;
        b=q7vSiYwgyYfJQhc53mJNLNB6IT4Zua9PzwiUjcHnQaabbFv7BS/M/trGzF0miSqfV3
         Q10APOGP8Hu0Fa1ItlieR3O1jiIl1AiHxNd5a74/Bt+jaxdQbiZCuV5nyLBV3CLQePLS
         E0XFwCC6qW0dyEtH36CGYeDaKJaqc6yWPt2lWgyIN0PxOaTt3rNUsvjpPt36Jc3w7WCH
         prFL1vbZjxc3bUW7aCVhN5LgMdmziSA6CUC9GKxKOpVN+2+YacApEMyAIdh+wKjeT4jI
         CIIXivMWZ2pXU5xqKNuNCrrEujAGtmERG/2E6DB1IiIGsE7DZfwv8tqM+hsrL+Gm4yxp
         tvbA==
X-Gm-Message-State: APjAAAUfMwNnKyAoO6ZS2zBZpYvYzbw50F+y+ngl3vcQR4aqhQGNhnaK
        UvE881hSa7XWHvbw+azxk4tAaV+ocmL5Bk6uAes=
X-Google-Smtp-Source: APXvYqyuvpzR+ZN2wr/ewVANPmPxe3sHkVHc08Bg88hKPLmKJRiu23jWbdQ7zf4uZuzo+VDB8BlGT4qAlklofmJE09I=
X-Received: by 2002:a92:3a8d:: with SMTP id i13mr6123726ilf.112.1581419039079;
 Tue, 11 Feb 2020 03:03:59 -0800 (PST)
MIME-Version: 1.0
References: <20200205192414.GA27345@suse.com> <20200206103842.14936-1-lhenriques@suse.com>
 <CAOi1vP_fTwCnUtN6GfpF0ATBSEygzd+waH8qJ1H3ioWmc-xS6A@mail.gmail.com> <20200211103239.GA21723@suse.com>
In-Reply-To: <20200211103239.GA21723@suse.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 11 Feb 2020 12:04:18 +0100
Message-ID: <CAOi1vP--thAYaV_iXU0UX_crTs4yDB2oSxrVZY8ChcoxFQ-AMA@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix copy_file_range error path in short copies
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 11, 2020 at 11:32 AM Luis Henriques <lhenriques@suse.com> wrote:
>
> On Mon, Feb 10, 2020 at 07:38:10PM +0100, Ilya Dryomov wrote:
> > On Thu, Feb 6, 2020 at 11:38 AM Luis Henriques <lhenriques@suse.com> wrote:
> > >
> > > When there's an error in the copying loop but some bytes have already been
> > > copied into the destination file, it is necessary to dirty the caps and
> > > eventually update the MDS with the file metadata (timestamps, size).  This
> > > patch fixes this error path.
> > >
> > > Another issue this patch fixes is the destination file size being reported
> > > to the MDS.  If we're on the error path but the amount of bytes written
> > > has already changed the destination file size, the offset to use is
> > > dst_off and not endoff.
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > ---
> > >  fs/ceph/file.c | 18 +++++++++++++-----
> > >  1 file changed, 13 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 11929d2bb594..f7f8cb6c243f 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -2104,9 +2104,16 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >                         CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
> > >                 if (err) {
> > >                         dout("ceph_osdc_copy_from returned %d\n", err);
> > > -                       if (!ret)
> > > +                       /*
> > > +                        * If we haven't done any copy yet, just exit with the
> > > +                        * error code; otherwise, return the number of bytes
> > > +                        * already copied, update metadata and dirty caps.
> > > +                        */
> > > +                       if (!ret) {
> > >                                 ret = err;
> > > -                       goto out_caps;
> > > +                               goto out_caps;
> > > +                       }
> > > +                       goto update_dst_inode;
> > >                 }
> > >                 len -= object_size;
> > >                 src_off += object_size;
> > > @@ -2118,16 +2125,17 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >                 /* We still need one final local copy */
> > >                 do_final_copy = true;
> > >
> > > +update_dst_inode:
> > >         file_update_time(dst_file);
> > >         inode_inc_iversion_raw(dst_inode);
> > >
> > > -       if (endoff > size) {
> > > +       if (dst_off > size) {
> > >                 int caps_flags = 0;
> > >
> > >                 /* Let the MDS know about dst file size change */
> > > -               if (ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
> > > +               if (ceph_quota_is_max_bytes_approaching(dst_inode, dst_off))
> > >                         caps_flags |= CHECK_CAPS_NODELAY;
> > > -               if (ceph_inode_set_size(dst_inode, endoff))
> > > +               if (ceph_inode_set_size(dst_inode, dst_off))
> > >                         caps_flags |= CHECK_CAPS_AUTHONLY;
> > >                 if (caps_flags)
> > >                         ceph_check_caps(dst_ci, caps_flags, NULL);
> >
> > Hi Luis,
> >
> > I think this function still has short copy and file size issues:
> >
> > - do_splice_direct() may write fewer bytes than requested, including
> >   nothing at all (i.e. return 0).  While we don't care about the second
> >   call much, handling the first call is crucial because proceeding to
> >   the copy-from loop with src/dst_off not at the object boundary will
> >   corrupt the destination file.
> >
> > - size is set after caps are acquired for the first time and never
> >   updated.  But caps are dropped before do_splice_direct(), so by the
> >   time we get to dst_off > size check, it may be stale.  Again, data
> >   loss if e.g. old-size < dst_off < new-size because the destination
> >   file will get truncated...
> >
> > Also, src/dst_oloc need to be freed with ceph_oloc_destroy() to avoid
> > leaking memory on namespace layouts.
> >
> > It seems clear that this function needs to be split, with the new
> > loop around do_splice_direct() and the copy-from loop each going into
> > a separate functions with clear pre- and post-conditions.
>
> Right, it makes sense to refactor this function and fix all these issues
> you're pointing.  It'll be a pain because a lot of parameters will need to
> be handed over into these new functions (maybe a new 'struct copy_desc'
> can help making it a bit less messy).  Anyway, I'll try to spend some time
> working on that and see what I can come up with.

Yeah, this code really needs more work and extensive verification.

I'm dropping this patch because it's only a partial fix.  Backporting
it alone, with known data corruption issues remaining (and without the
copy-from2 patch that fixes another data corruption issue that is much
easier to hit), doesn't make sense.

Thanks,

                Ilya
