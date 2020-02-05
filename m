Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF981153908
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 20:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgBETYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 14:24:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:33894 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbgBETYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 14:24:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3B5AAB08C;
        Wed,  5 Feb 2020 19:24:08 +0000 (UTC)
Date:   Wed, 5 Feb 2020 19:24:14 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] ceph: fix copy_file_range error path in short copies
Message-ID: <20200205192414.GA27345@suse.com>
References: <20200205102852.12236-1-lhenriques@suse.com>
 <CAOi1vP8w_ssGZJTimgDMULgd4jyb_CYuxNyjvHhbBR9FgAqB9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP8w_ssGZJTimgDMULgd4jyb_CYuxNyjvHhbBR9FgAqB9A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 12:16:02PM +0100, Ilya Dryomov wrote:
> On Wed, Feb 5, 2020 at 11:28 AM Luis Henriques <lhenriques@suse.com> wrote:
> >
> > When there's an error in the copying loop but some bytes have already been
> > copied into the destination file, it is necessary to dirty the caps and
> > eventually update the MDS with the file metadata (timestamps, size).  This
> > patch fixes this error path.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> >  fs/ceph/file.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 11929d2bb594..7be47d24edb1 100644
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
> > +                       goto out_early;
> >                 }
> >                 len -= object_size;
> >                 src_off += object_size;
> > @@ -2118,6 +2125,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >                 /* We still need one final local copy */
> >                 do_final_copy = true;
> >
> > +out_early:
> 
> out_early is misleading, especially given that there already
> is out_caps, which just puts caps.  I suggest something like
> update_dst_inode.
> 
> >         file_update_time(dst_file);
> >         inode_inc_iversion_raw(dst_inode);
> >
> 
> I think this is still buggy.  What follows is this:
> 
>         if (endoff > size) {
>                 int caps_flags = 0;
> 
>                 /* Let the MDS know about dst file size change */
>                 if (ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
>                         caps_flags |= CHECK_CAPS_NODELAY;
>                 if (ceph_inode_set_size(dst_inode, endoff))
>                         caps_flags |= CHECK_CAPS_AUTHONLY;
>                 if (caps_flags)
>                         ceph_check_caps(dst_ci, caps_flags, NULL);
>         }
> 
> with endoff being:
> 
>         size = i_size_read(dst_inode);
>         endoff = dst_off + len;
> 
> So a short copy effectively zero-fills the destination file...

Ah!  What a surprise!  Yet another bug in copy_file_range.  /me hides

I guess that replacing 'endoff' by 'dst_off' in the 'if' statement above
(including the condition itself) should fix it.  But I start to think that
I'm biased and unable to see the most obvious issues with this code :-/

Cheers,
--
Luís
