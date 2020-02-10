Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97BDA157F07
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 16:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgBJPls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 10:41:48 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32848 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgBJPlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 10:41:47 -0500
Received: by mail-lj1-f195.google.com with SMTP id y6so7724934lji.0
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 07:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vxeX3iDS3qAf3x+JMLRj0YdyqYpgOcBfoAPBACaCp4A=;
        b=ydZH6vB5q5uqqUEAchV6QpyAqs+jXxS4xZMDXS3nRhJKyBZCJ1jQQBaohMTDbypzIT
         hpGq+wfdtNo/Z2tjM7MkfkUVH+VHx3XsQld4hVCGwJuLFpMfixr5BPVkrL5yMAzU2Lv8
         IUdehmritbgsGuDrp5CwcEJfSjtNYNwS8AUzeBK9zuHnwgZKXSHlJIcykzzwzZr7YVx+
         r7SSbAHl56IlF9A7gRVz23NecVWpHCgcN+qIXrd9Hw0uY5uDfTArpm1JUH9DMQM/M6nX
         e55KnpdQoJzdzpfy6JnWZS+Zx5Xl3heQBEaocUI5nAr4XAloNPgA4d4bdSunZJkMQkFi
         RMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vxeX3iDS3qAf3x+JMLRj0YdyqYpgOcBfoAPBACaCp4A=;
        b=Do9rfigXfsrX7XNpyQ05OCjuE/QQlWvrvCvl1Bo3gXHHGf3jJBNsO8oCQ5GYldDQWq
         m2J2NXUP4vDTgbUgpaJmfyaFsWnVyQJdYlfg8+DTOZFATg0vTB2FWZxM6EpyGO7Vqqmu
         wXMkZWtQkSD29dIfwN+sQvGh9WWrv5XAR9hIRIGFFubojuXVHmgGNLs9HWlQW6FKX7Y+
         UKRd0TUmvEbcO9RHbGICBi656MRLvWvZAGZIeI0n2NCC9ePWUJmnGorwjzCpzCytJerW
         Xfy+9JJRgEMZW8dxM3Pd5AiZsjnAFFf6TE3xYY4s/qzt+vkrYQM7W9C4332xMf90HHZV
         H6TQ==
X-Gm-Message-State: APjAAAUwYh+N/LYaYLMt620gnVYys1FDkyAyYxyj30vYLpJ6076ePDw7
        te+n5fhMyYUPdi80DIuYQHNYdHFywfG/nRMfYsJXiQ==
X-Google-Smtp-Source: APXvYqwhdAy9fxTUvJ7QqQiFyn3YgBzq7FGMPk9SLTWqRWP0z45RPncxITz7TvkrRWATf6463wrUtLm+ZZRaRXet8QY=
X-Received: by 2002:a2e:9008:: with SMTP id h8mr1259917ljg.217.1581349303995;
 Mon, 10 Feb 2020 07:41:43 -0800 (PST)
MIME-Version: 1.0
References: <20200210122423.695146547@linuxfoundation.org> <20200210122450.176337512@linuxfoundation.org>
In-Reply-To: <20200210122450.176337512@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 10 Feb 2020 21:11:32 +0530
Message-ID: <CA+G9fYu4pDFaG-dA2KbVp61HGNzA1R3F_=Z5isC8_ammG4iZkQ@mail.gmail.com>
Subject: Re: [PATCH 5.5 284/367] compat: scsi: sg: fix v3 compat read/write interface
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Basil Eljuse <Basil.Eljuse@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The arm64 architecture 64k page size enabled build failed on stable rc 5.5
CONFIG_ARM64_64K_PAGES=3Dy
CROSS_COMPILE=3Daarch64-linux-gnu-
Toolchain gcc-9

In file included from ../block/scsi_ioctl.c:23:
 ../include/scsi/sg.h:75:2: error: unknown type name =E2=80=98compat_int_t=
=E2=80=99
  compat_int_t interface_id; /* [i] 'S' for SCSI generic (required) */
  ^~~~~~~~~~~~
 ../include/scsi/sg.h:76:2: error: unknown type name =E2=80=98compat_int_t=
=E2=80=99
  compat_int_t dxfer_direction; /* [i] data transfer direction  */
  ^~~~~~~~~~~~

...
 ../include/scsi/sg.h:97:2: error: unknown type name =E2=80=98compat_uint_t=
=E2=80=99
  compat_uint_t info;  /* [o] auxiliary information */
  ^~~~~~~~~~~~~
 make[2]: *** [../scripts/Makefile.build:266: block/bsg.o] Error

Ref:
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/431659186

On Mon, 10 Feb 2020 at 18:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> commit 78ed001d9e7106171e0ee761cd854137dd731302 upstream.
>
> In the v5.4 merge window, a cleanup patch from Al Viro conflicted
> with my rework of the compat handling for sg.c read(). Linus Torvalds
> did a correct merge but pointed out that the resulting code is still
> unsatisfactory.
>
> I later noticed that the sg_new_read() function still gets the compat
> mode wrong, when the 'count' argument is large enough to pass a
> compat_sg_io_hdr object, but not a nativ sg_io_hdr.
>
> To address both of these, move the definition of compat_sg_io_hdr
> into a scsi/sg.h to make it visible to sg.c and rewrite the logic
> for reading req_pack_id as well as the size check to a simpler
> version that gets the expected results.
>
> Fixes: c35a5cfb4150 ("scsi: sg: sg_read(): simplify reading ->pack_id of =
userland sg_io_hdr_t")
> Fixes: 98aaaec4a150 ("compat_ioctl: reimplement SG_IO handling")
> Reviewed-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  block/scsi_ioctl.c |   29 ------------
>  drivers/scsi/sg.c  |  126 ++++++++++++++++++++++++----------------------=
-------
>  include/scsi/sg.h  |   30 ++++++++++++
>  3 files changed, 90 insertions(+), 95 deletions(-)
>
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -20,6 +20,7 @@
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_ioctl.h>
>  #include <scsi/scsi_cmnd.h>
> +#include <scsi/sg.h>
>
>  struct blk_cmd_filter {
>         unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
> @@ -550,34 +551,6 @@ static inline int blk_send_start_stop(st
>         return __blk_send_generic(q, bd_disk, GPCMD_START_STOP_UNIT, data=
);
>  }
>
> -#ifdef CONFIG_COMPAT
> -struct compat_sg_io_hdr {
> -       compat_int_t interface_id;      /* [i] 'S' for SCSI generic (requ=
ired) */
> -       compat_int_t dxfer_direction;   /* [i] data transfer direction  *=
/
> -       unsigned char cmd_len;          /* [i] SCSI command length ( <=3D=
 16 bytes) */
> -       unsigned char mx_sb_len;        /* [i] max length to write to sbp=
 */
> -       unsigned short iovec_count;     /* [i] 0 implies no scatter gathe=
r */
> -       compat_uint_t dxfer_len;        /* [i] byte count of data transfe=
r */
> -       compat_uint_t dxferp;           /* [i], [*io] points to data tran=
sfer memory
> -                                               or scatter gather list */
> -       compat_uptr_t cmdp;             /* [i], [*i] points to command to=
 perform */
> -       compat_uptr_t sbp;              /* [i], [*o] points to sense_buff=
er memory */
> -       compat_uint_t timeout;          /* [i] MAX_UINT->no timeout (unit=
: millisec) */
> -       compat_uint_t flags;            /* [i] 0 -> default, see SG_FLAG.=
.. */
> -       compat_int_t pack_id;           /* [i->o] unused internally (norm=
ally) */
> -       compat_uptr_t usr_ptr;          /* [i->o] unused internally */
> -       unsigned char status;           /* [o] scsi status */
> -       unsigned char masked_status;    /* [o] shifted, masked scsi statu=
s */
> -       unsigned char msg_status;       /* [o] messaging level data (opti=
onal) */
> -       unsigned char sb_len_wr;        /* [o] byte count actually writte=
n to sbp */
> -       unsigned short host_status;     /* [o] errors from host adapter *=
/
> -       unsigned short driver_status;   /* [o] errors from software drive=
r */
> -       compat_int_t resid;             /* [o] dxfer_len - actual_transfe=
rred */
> -       compat_uint_t duration;         /* [o] time taken by cmd (unit: m=
illisec) */
> -       compat_uint_t info;             /* [o] auxiliary information */
> -};
> -#endif
> -
>  int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp)
>  {
>  #ifdef CONFIG_COMPAT
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -405,6 +405,38 @@ sg_release(struct inode *inode, struct f
>         return 0;
>  }
>
> +static int get_sg_io_pack_id(int *pack_id, void __user *buf, size_t coun=
t)
> +{
> +       struct sg_header __user *old_hdr =3D buf;
> +       int reply_len;
> +
> +       if (count >=3D SZ_SG_HEADER) {
> +               /* negative reply_len means v3 format, otherwise v1/v2 */
> +               if (get_user(reply_len, &old_hdr->reply_len))
> +                       return -EFAULT;
> +
> +               if (reply_len >=3D 0)
> +                       return get_user(*pack_id, &old_hdr->pack_id);
> +
> +               if (in_compat_syscall() &&
> +                   count >=3D sizeof(struct compat_sg_io_hdr)) {
> +                       struct compat_sg_io_hdr __user *hp =3D buf;
> +
> +                       return get_user(*pack_id, &hp->pack_id);
> +               }
> +
> +               if (count >=3D sizeof(struct sg_io_hdr)) {
> +                       struct sg_io_hdr __user *hp =3D buf;
> +
> +                       return get_user(*pack_id, &hp->pack_id);
> +               }
> +       }
> +
> +       /* no valid header was passed, so ignore the pack_id */
> +       *pack_id =3D -1;
> +       return 0;
> +}
> +
>  static ssize_t
>  sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos=
)
>  {
> @@ -413,8 +445,8 @@ sg_read(struct file *filp, char __user *
>         Sg_request *srp;
>         int req_pack_id =3D -1;
>         sg_io_hdr_t *hp;
> -       struct sg_header *old_hdr =3D NULL;
> -       int retval =3D 0;
> +       struct sg_header *old_hdr;
> +       int retval;
>
>         /*
>          * This could cause a response to be stranded. Close the associat=
ed
> @@ -429,79 +461,34 @@ sg_read(struct file *filp, char __user *
>         SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
>                                       "sg_read: count=3D%d\n", (int) coun=
t));
>
> -       if (sfp->force_packid && (count >=3D SZ_SG_HEADER)) {
> -               old_hdr =3D memdup_user(buf, SZ_SG_HEADER);
> -               if (IS_ERR(old_hdr))
> -                       return PTR_ERR(old_hdr);
> -               if (old_hdr->reply_len < 0) {
> -                       if (count >=3D SZ_SG_IO_HDR) {
> -                               /*
> -                                * This is stupid.
> -                                *
> -                                * We're copying the whole sg_io_hdr_t fr=
om user
> -                                * space just to get the 'pack_id' field.=
 But the
> -                                * field is at different offsets for the =
compat
> -                                * case, so we'll use "get_sg_io_hdr()" t=
o copy
> -                                * the whole thing and convert it.
> -                                *
> -                                * We could do something like just calcul=
ating the
> -                                * offset based of 'in_compat_syscall()',=
 but the
> -                                * 'compat_sg_io_hdr' definition is in th=
e wrong
> -                                * place for that.
> -                                */
> -                               sg_io_hdr_t *new_hdr;
> -                               new_hdr =3D kmalloc(SZ_SG_IO_HDR, GFP_KER=
NEL);
> -                               if (!new_hdr) {
> -                                       retval =3D -ENOMEM;
> -                                       goto free_old_hdr;
> -                               }
> -                               retval =3D get_sg_io_hdr(new_hdr, buf);
> -                               req_pack_id =3D new_hdr->pack_id;
> -                               kfree(new_hdr);
> -                               if (retval) {
> -                                       retval =3D -EFAULT;
> -                                       goto free_old_hdr;
> -                               }
> -                       }
> -               } else
> -                       req_pack_id =3D old_hdr->pack_id;
> -       }
> +       if (sfp->force_packid)
> +               retval =3D get_sg_io_pack_id(&req_pack_id, buf, count);
> +       if (retval)
> +               return retval;
> +
>         srp =3D sg_get_rq_mark(sfp, req_pack_id);
>         if (!srp) {             /* now wait on packet to arrive */
> -               if (atomic_read(&sdp->detaching)) {
> -                       retval =3D -ENODEV;
> -                       goto free_old_hdr;
> -               }
> -               if (filp->f_flags & O_NONBLOCK) {
> -                       retval =3D -EAGAIN;
> -                       goto free_old_hdr;
> -               }
> +               if (atomic_read(&sdp->detaching))
> +                       return -ENODEV;
> +               if (filp->f_flags & O_NONBLOCK)
> +                       return -EAGAIN;
>                 retval =3D wait_event_interruptible(sfp->read_wait,
>                         (atomic_read(&sdp->detaching) ||
>                         (srp =3D sg_get_rq_mark(sfp, req_pack_id))));
> -               if (atomic_read(&sdp->detaching)) {
> -                       retval =3D -ENODEV;
> -                       goto free_old_hdr;
> -               }
> -               if (retval) {
> +               if (atomic_read(&sdp->detaching))
> +                       return -ENODEV;
> +               if (retval)
>                         /* -ERESTARTSYS as signal hit process */
> -                       goto free_old_hdr;
> -               }
> -       }
> -       if (srp->header.interface_id !=3D '\0') {
> -               retval =3D sg_new_read(sfp, buf, count, srp);
> -               goto free_old_hdr;
> +                       return retval;
>         }
> +       if (srp->header.interface_id !=3D '\0')
> +               return sg_new_read(sfp, buf, count, srp);
>
>         hp =3D &srp->header;
> -       if (old_hdr =3D=3D NULL) {
> -               old_hdr =3D kmalloc(SZ_SG_HEADER, GFP_KERNEL);
> -               if (! old_hdr) {
> -                       retval =3D -ENOMEM;
> -                       goto free_old_hdr;
> -               }
> -       }
> -       memset(old_hdr, 0, SZ_SG_HEADER);
> +       old_hdr =3D kzalloc(SZ_SG_HEADER, GFP_KERNEL);
> +       if (!old_hdr)
> +               return -ENOMEM;
> +
>         old_hdr->reply_len =3D (int) hp->timeout;
>         old_hdr->pack_len =3D old_hdr->reply_len; /* old, strange behavio=
ur */
>         old_hdr->pack_id =3D hp->pack_id;
> @@ -575,7 +562,12 @@ sg_new_read(Sg_fd * sfp, char __user *bu
>         int err =3D 0, err2;
>         int len;
>
> -       if (count < SZ_SG_IO_HDR) {
> +       if (in_compat_syscall()) {
> +               if (count < sizeof(struct compat_sg_io_hdr)) {
> +                       err =3D -EINVAL;
> +                       goto err_out;
> +               }
> +       } else if (count < SZ_SG_IO_HDR) {
>                 err =3D -EINVAL;
>                 goto err_out;
>         }
> --- a/include/scsi/sg.h
> +++ b/include/scsi/sg.h
> @@ -68,6 +68,36 @@ typedef struct sg_io_hdr
>      unsigned int info;          /* [o] auxiliary information */
>  } sg_io_hdr_t;  /* 64 bytes long (on i386) */
>
> +#if defined(__KERNEL__)
> +#include <linux/compat.h>
> +
> +struct compat_sg_io_hdr {
> +       compat_int_t interface_id;      /* [i] 'S' for SCSI generic (requ=
ired) */
> +       compat_int_t dxfer_direction;   /* [i] data transfer direction  *=
/
> +       unsigned char cmd_len;          /* [i] SCSI command length ( <=3D=
 16 bytes) */
> +       unsigned char mx_sb_len;        /* [i] max length to write to sbp=
 */
> +       unsigned short iovec_count;     /* [i] 0 implies no scatter gathe=
r */
> +       compat_uint_t dxfer_len;        /* [i] byte count of data transfe=
r */
> +       compat_uint_t dxferp;           /* [i], [*io] points to data tran=
sfer memory
> +                                               or scatter gather list */
> +       compat_uptr_t cmdp;             /* [i], [*i] points to command to=
 perform */
> +       compat_uptr_t sbp;              /* [i], [*o] points to sense_buff=
er memory */
> +       compat_uint_t timeout;          /* [i] MAX_UINT->no timeout (unit=
: millisec) */
> +       compat_uint_t flags;            /* [i] 0 -> default, see SG_FLAG.=
.. */
> +       compat_int_t pack_id;           /* [i->o] unused internally (norm=
ally) */
> +       compat_uptr_t usr_ptr;          /* [i->o] unused internally */
> +       unsigned char status;           /* [o] scsi status */
> +       unsigned char masked_status;    /* [o] shifted, masked scsi statu=
s */
> +       unsigned char msg_status;       /* [o] messaging level data (opti=
onal) */
> +       unsigned char sb_len_wr;        /* [o] byte count actually writte=
n to sbp */
> +       unsigned short host_status;     /* [o] errors from host adapter *=
/
> +       unsigned short driver_status;   /* [o] errors from software drive=
r */
> +       compat_int_t resid;             /* [o] dxfer_len - actual_transfe=
rred */
> +       compat_uint_t duration;         /* [o] time taken by cmd (unit: m=
illisec) */
> +       compat_uint_t info;             /* [o] auxiliary information */
> +};
> +#endif
> +
>  #define SG_INTERFACE_ID_ORIG 'S'
>
>  /* Use negative values to flag difference from original sg_header struct=
ure */
>
>

--=20
Linaro LKFT
https://lkft.linaro.org
