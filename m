Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757D864DC27
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 14:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiLONUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 08:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiLONUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 08:20:43 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D9F25F;
        Thu, 15 Dec 2022 05:20:42 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id t17so52212484eju.1;
        Thu, 15 Dec 2022 05:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UHG2DQ/q3tdCjR3+JAIlJLfOPaVrBzMAXmKA5muIVjo=;
        b=O2u/MK0hQn54Ffs39OhuZsWMjYRlhWISZrALEx40MtN2rVh3iFJ64EJczYyr2rewRl
         aPN/F5LQ+mCwSH74U7YN6jO9KYtnH+6J452jQI7qWzMNj98SaGFmrOW6jYs2/kRWiylF
         kGLgX1Z8sUu7Pku4wluW64TXDnNHB611nMpRMvXXOUZDgvdkfTVt+fpYFQ4mhSSj1nh4
         VFnoTEw5CQIzQ/OejJFqeUMxEQFeZBe0jaiA5VZRzNTJQqXWV4PgF0CKy57SMLUq2wih
         YBMkFFn77J5pU806AHEBBfy2NS+AD9VHki9nNXtLhgrlunQr66wQg9k+Hc9NMhSB/1A8
         Vssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UHG2DQ/q3tdCjR3+JAIlJLfOPaVrBzMAXmKA5muIVjo=;
        b=TGuSwnOdlP+FR+yfZMBW56A590XXkb9RX3fN9A8DduDuakq1VYjG5zDFX1YvVwjWJQ
         wvy2Z4GWSmQIwAAW9N7QGa0r4gCoXApCWCRlwdQoPbcMWBsiks473Wkz5fV7bvC0c3Pk
         QnGxZR0JIRg7wuOHveSXKbPY3+uw8Bpw6tRjpUg6Ql5aqLfrZOk4GFqBtMVe9aZmKA6b
         FW8Zaju/MmldIHvE1YbMm5gF9jpLjg70vuWf0cXsGY89fFVIsJOxC8QzeRe2yM/ain4c
         LAX2cl6aanV+3No71dXAVrCseVgq+jCLUnv+AuFtI9XOeHAOlsBZRUjQX/n4fLZOMpMB
         Apvg==
X-Gm-Message-State: ANoB5pnpgoWWvCzcCy2ypHZgUVGX6vRgkM718aRlfPcqf8E79QIbQRuZ
        Zc1t9M3HAuU37Txo6W/nwYtmayE3Pa7iSUt5ylw=
X-Google-Smtp-Source: AA0mqf7CwzjnS9VrR+9xfqWcAfIDbwxwTeK7REnuDbDXTRA+q+Wc9kzW/kiM0XtlZN2oqPpJxLNrZ2iq+4TIQdmIySg=
X-Received: by 2002:a17:907:a074:b0:7c1:bb5:5705 with SMTP id
 ia20-20020a170907a07400b007c10bb55705mr11708113ejc.544.1671110440722; Thu, 15
 Dec 2022 05:20:40 -0800 (PST)
MIME-Version: 1.0
References: <20221214033512.659913-1-xiubli@redhat.com> <20221214033512.659913-2-xiubli@redhat.com>
In-Reply-To: <20221214033512.659913-2-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 15 Dec 2022 14:20:29 +0100
Message-ID: <CAOi1vP9Je-DnqUdYcBi_zSDUgj30aYrTeGq1MSwS66E7ptaTSg@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] ceph: switch to vfs_inode_has_locks() to fix file
 lock bug
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, ceph-devel@vger.kernel.org,
        mchangir@redhat.com, lhenriques@suse.de, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 14, 2022 at 4:35 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> For the POSIX locks they are using the same owner, which is the
> thread id. And multiple POSIX locks could be merged into single one,
> so when checking whether the 'file' has locks may fail.
>
> For a file where some openers use locking and others don't is a
> really odd usage pattern though. Locks are like stoplights -- they
> only work if everyone pays attention to them.
>
> Just switch ceph_get_caps() to check whether any locks are set on
> the inode. If there are POSIX/OFD/FLOCK locks on the file at the
> time, we should set CHECK_FILELOCK, regardless of what fd was used
> to set the lock.
>
> Cc: stable@vger.kernel.org
> Cc: Jeff Layton <jlayton@kernel.org>
> Fixes: ff5d913dfc71 ("ceph: return -EIO if read/write against filp that lost file locks")
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c  | 2 +-
>  fs/ceph/locks.c | 4 ----
>  fs/ceph/super.h | 1 -
>  3 files changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 065e9311b607..948136f81fc8 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2964,7 +2964,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
>
>         while (true) {
>                 flags &= CEPH_FILE_MODE_MASK;
> -               if (atomic_read(&fi->num_locks))
> +               if (vfs_inode_has_locks(inode))
>                         flags |= CHECK_FILELOCK;
>                 _got = 0;
>                 ret = try_get_cap_refs(inode, need, want, endoff,
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index 3e2843e86e27..b191426bf880 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -32,18 +32,14 @@ void __init ceph_flock_init(void)
>
>  static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
>  {
> -       struct ceph_file_info *fi = dst->fl_file->private_data;
>         struct inode *inode = file_inode(dst->fl_file);
>         atomic_inc(&ceph_inode(inode)->i_filelock_ref);
> -       atomic_inc(&fi->num_locks);
>  }
>
>  static void ceph_fl_release_lock(struct file_lock *fl)
>  {
> -       struct ceph_file_info *fi = fl->fl_file->private_data;
>         struct inode *inode = file_inode(fl->fl_file);
>         struct ceph_inode_info *ci = ceph_inode(inode);
> -       atomic_dec(&fi->num_locks);
>         if (atomic_dec_and_test(&ci->i_filelock_ref)) {
>                 /* clear error when all locks are released */
>                 spin_lock(&ci->i_ceph_lock);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 14454f464029..e7662ff6f149 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -804,7 +804,6 @@ struct ceph_file_info {
>         struct list_head rw_contexts;
>
>         u32 filp_gen;
> -       atomic_t num_locks;
>  };
>
>  struct ceph_dir_file_info {
> --
> 2.31.1
>

Hi Xiubo,

You marked this for stable but there is an obvious dependency on
vfs_inode_has_locks() that just got merged for 6.2-rc1.  Are you
intending to take it into stable kernels as well?

Thanks,

                Ilya
