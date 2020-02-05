Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F42E1529B1
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 12:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgBELPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 06:15:50 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42852 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgBELPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 06:15:50 -0500
Received: by mail-lf1-f65.google.com with SMTP id y19so1187119lfl.9;
        Wed, 05 Feb 2020 03:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x8ckLRvDL8dg/iPhi1vO5fg6t5hQSAQsmjIQBiNcoB4=;
        b=EMit4qaHp+ClCDjyyJMWphi8crzhLGi3Smu8kLgmk5GeEWZLArq8dWq6YdlNJzI2Gk
         tzdNIgVZZ8PnQSPgFY+dN9u8RZk5JhdzutPScZWOr6S7IKi466ZmSnxnjRIskLubxiYv
         0EazMj9lgI8fWAOpzK/fZslU6nRAOw4Gwz0BezfxkS2HQWJjEEKiUxmqFLvsldQ6Mg5T
         svzwQH3256oa3SVEHucPnZoIK7k0Alpj8B0lQQ6GEw//CfL0MPfGIec72ClV1tjCrGS1
         OgYH7ZgBKyxrdHmHUoZeLo1dswYbKQr/NRyhxocM3avK7u+zYoRrc/xMI4/un4qwBD7+
         SaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x8ckLRvDL8dg/iPhi1vO5fg6t5hQSAQsmjIQBiNcoB4=;
        b=r02dXWSVGXd5s9bbPBs8z1Eihk5b4YrgxN8zcaAkQtqqgyLHcotH9hllJVMc0h3jA6
         FC41Pu/LCSKYf1M6mrJNVgGG37EiRUwouQiyhRPUzTYavaczf3Sc0wtf994m1YNCP/I6
         xASDX5zouV4h0YNTr9y+HYGgatqV9VySpGPcMf4xcyWvD5B4Q1AbKuMtGfHX0W1JSq9i
         IJaSrXVHfV1uS7sXoLAo4AsO0Qtbugva9aDhx7JqwALysnlgvoMrhOJpIrqc83IM+On+
         aUueIYAE6UQOsowEazh1w8kQlXGFvW5f/EdIAJoLo4xgT3r6z+Q+LqTbby5Vj+ciBhpV
         BHEQ==
X-Gm-Message-State: APjAAAWMqvdUfzXswEiFM+xuJWSak+hgVI6Ae8amLdVizyioW1x7siZt
        vrs/buHe7frouih9jjAUTdqwXIY9VFxL2oCkdx8=
X-Google-Smtp-Source: APXvYqx8oG0xURPnylXNJ0s8CMXSDW6QXuLPsyuAcMSJ8G+8s5BFjDWo3Ir56Hq28vLgMhIY4WDVZaO+tSSN5P0TS7Y=
X-Received: by 2002:a05:6512:64:: with SMTP id i4mr17458571lfo.55.1580901348247;
 Wed, 05 Feb 2020 03:15:48 -0800 (PST)
MIME-Version: 1.0
References: <20200205102852.12236-1-lhenriques@suse.com>
In-Reply-To: <20200205102852.12236-1-lhenriques@suse.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 5 Feb 2020 12:16:02 +0100
Message-ID: <CAOi1vP8w_ssGZJTimgDMULgd4jyb_CYuxNyjvHhbBR9FgAqB9A@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix copy_file_range error path in short copies
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

On Wed, Feb 5, 2020 at 11:28 AM Luis Henriques <lhenriques@suse.com> wrote:
>
> When there's an error in the copying loop but some bytes have already been
> copied into the destination file, it is necessary to dirty the caps and
> eventually update the MDS with the file metadata (timestamps, size).  This
> patch fixes this error path.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/file.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 11929d2bb594..7be47d24edb1 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -2104,9 +2104,16 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>                         CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
>                 if (err) {
>                         dout("ceph_osdc_copy_from returned %d\n", err);
> -                       if (!ret)
> +                       /*
> +                        * If we haven't done any copy yet, just exit with the
> +                        * error code; otherwise, return the number of bytes
> +                        * already copied, update metadata and dirty caps.
> +                        */
> +                       if (!ret) {
>                                 ret = err;
> -                       goto out_caps;
> +                               goto out_caps;
> +                       }
> +                       goto out_early;
>                 }
>                 len -= object_size;
>                 src_off += object_size;
> @@ -2118,6 +2125,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>                 /* We still need one final local copy */
>                 do_final_copy = true;
>
> +out_early:

out_early is misleading, especially given that there already
is out_caps, which just puts caps.  I suggest something like
update_dst_inode.

>         file_update_time(dst_file);
>         inode_inc_iversion_raw(dst_inode);
>

I think this is still buggy.  What follows is this:

        if (endoff > size) {
                int caps_flags = 0;

                /* Let the MDS know about dst file size change */
                if (ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
                        caps_flags |= CHECK_CAPS_NODELAY;
                if (ceph_inode_set_size(dst_inode, endoff))
                        caps_flags |= CHECK_CAPS_AUTHONLY;
                if (caps_flags)
                        ceph_check_caps(dst_ci, caps_flags, NULL);
        }

with endoff being:

        size = i_size_read(dst_inode);
        endoff = dst_off + len;

So a short copy effectively zero-fills the destination file...

Thanks,

                Ilya
