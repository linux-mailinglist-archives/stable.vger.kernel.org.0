Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEE01582B8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 19:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgBJShz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 13:37:55 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:45066 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgBJShx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 13:37:53 -0500
Received: by mail-il1-f195.google.com with SMTP id p8so1090039iln.12;
        Mon, 10 Feb 2020 10:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=end8yQlEP+B+YiWzV6pVioijLvJsH98AVHTgTqHE2kc=;
        b=XZHa3/Kefvs1a7y+DrOpFR01u/nc7ENmeFyOZwYa+dxAyTyaNmZhE4+48stmc7Lp2g
         sZ2ZQ8lH0RLjLmIwXF+vzuO417RWk7xZEUkzZ2D36fpoRMGOLXOGQaa12Z+N4NqRm0//
         jlul/DGf1EGDsWOLwj17OQ2WkWBBc7YMHvcHm97qONiA4+6QHq242AWf3ttBdVa+E9El
         88fxseLxZXwfQssIe7/89uzd2zWdo3lGc6Ii8MtnKRG0k0ET1N4x7bnt5B7DyTZ2Yq3/
         t6BgEK+QnmPW3j2/QeFSnEzb3zLaeG8qErzsvLf6YuCe69EjeJBAcYFJOaUuLUilYkFn
         2YOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=end8yQlEP+B+YiWzV6pVioijLvJsH98AVHTgTqHE2kc=;
        b=PicTzWWAQF/FTfRf2ndUubSaiAbJ6ofTIpd9ZguMVXXyTO7WIkkuRdnUZsZzVWLrvO
         2eba5Nw3ApK9Be54q37fFf83IfHBxHle2vyB2V9r1T3RPJSMao4uPFuyVsywSYC1VIW6
         49QvtbxufsAGOz1Ref2jBQLEjBPZwDGPpsHmA9pNVVr8LsjUgKbLzv0cOREDUOMlMwMA
         xMWxjQ34BjaOCLn3VbDDY1UFrwznE31qSxKCMzTJAKfYmJENaeSbsH7bSrrShjjcMKey
         lOoo/JtMRhOEwR2mTAb2be2AOLTUUNRKWfeIqP8SR0KpWVa+3+NZTDjxo9mYvR+TAcxe
         ZvAQ==
X-Gm-Message-State: APjAAAWlzqV/OUhe8FmQFLvxNf5OINaEEyG/EnjgYw0hFtbLcZ+Ogopb
        Rm+Uw0MZKZwza8qowXOJcL/Zaye5eh3FPDXjNhk=
X-Google-Smtp-Source: APXvYqyyIm5NVOjTGMlBfZ6A5Wqhqs+7RIihpBDifKBjldx7jBtkBHh+TkD1stcz4b47z6uzE3prk+r+g1uDrLXkwho=
X-Received: by 2002:a92:3991:: with SMTP id h17mr2826498ilf.131.1581359872312;
 Mon, 10 Feb 2020 10:37:52 -0800 (PST)
MIME-Version: 1.0
References: <20200205192414.GA27345@suse.com> <20200206103842.14936-1-lhenriques@suse.com>
In-Reply-To: <20200206103842.14936-1-lhenriques@suse.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 10 Feb 2020 19:38:10 +0100
Message-ID: <CAOi1vP_fTwCnUtN6GfpF0ATBSEygzd+waH8qJ1H3ioWmc-xS6A@mail.gmail.com>
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

On Thu, Feb 6, 2020 at 11:38 AM Luis Henriques <lhenriques@suse.com> wrote:
>
> When there's an error in the copying loop but some bytes have already been
> copied into the destination file, it is necessary to dirty the caps and
> eventually update the MDS with the file metadata (timestamps, size).  This
> patch fixes this error path.
>
> Another issue this patch fixes is the destination file size being reported
> to the MDS.  If we're on the error path but the amount of bytes written
> has already changed the destination file size, the offset to use is
> dst_off and not endoff.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/file.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 11929d2bb594..f7f8cb6c243f 100644
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
> +                       goto update_dst_inode;
>                 }
>                 len -= object_size;
>                 src_off += object_size;
> @@ -2118,16 +2125,17 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>                 /* We still need one final local copy */
>                 do_final_copy = true;
>
> +update_dst_inode:
>         file_update_time(dst_file);
>         inode_inc_iversion_raw(dst_inode);
>
> -       if (endoff > size) {
> +       if (dst_off > size) {
>                 int caps_flags = 0;
>
>                 /* Let the MDS know about dst file size change */
> -               if (ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
> +               if (ceph_quota_is_max_bytes_approaching(dst_inode, dst_off))
>                         caps_flags |= CHECK_CAPS_NODELAY;
> -               if (ceph_inode_set_size(dst_inode, endoff))
> +               if (ceph_inode_set_size(dst_inode, dst_off))
>                         caps_flags |= CHECK_CAPS_AUTHONLY;
>                 if (caps_flags)
>                         ceph_check_caps(dst_ci, caps_flags, NULL);

Hi Luis,

I think this function still has short copy and file size issues:

- do_splice_direct() may write fewer bytes than requested, including
  nothing at all (i.e. return 0).  While we don't care about the second
  call much, handling the first call is crucial because proceeding to
  the copy-from loop with src/dst_off not at the object boundary will
  corrupt the destination file.

- size is set after caps are acquired for the first time and never
  updated.  But caps are dropped before do_splice_direct(), so by the
  time we get to dst_off > size check, it may be stale.  Again, data
  loss if e.g. old-size < dst_off < new-size because the destination
  file will get truncated...

Also, src/dst_oloc need to be freed with ceph_oloc_destroy() to avoid
leaking memory on namespace layouts.

It seems clear that this function needs to be split, with the new
loop around do_splice_direct() and the copy-from loop each going into
a separate functions with clear pre- and post-conditions.

Thanks,

                Ilya
