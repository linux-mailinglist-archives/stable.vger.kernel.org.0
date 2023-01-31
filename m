Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34A0683608
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 20:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjAaTGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 14:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbjAaTGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 14:06:12 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406455999A;
        Tue, 31 Jan 2023 11:05:47 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id p26so33363722ejx.13;
        Tue, 31 Jan 2023 11:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cyZBXak+cF6JbtvZcE/sVa5hEbgfgeBs3PFeP9KUACU=;
        b=lWXjiE9fl1G3FcDJPeyoA19LUjfVvUW/ZHl2FXa15CcIIkkP56eOR3bHU+5TE9Ljwl
         frms6P/Ubl0fRA+wURwLqupGmjGaqwIdBhEbxR41mIMzOS4uxH6yImLCQJLX9RE44rkj
         cRvYpeTIV9Yevgde5uN8GdGwb2ofhIhEGbrPcgp1gsUyegDqFBrrNF0I5m5r+MPW7dvl
         DFin2VKV/axnHYEXoPzU7/zHzKSAGXsJmtSxJjYAumNR698idnmGwvPCaoFBQd40PHLa
         8haflFgYxab0shEFtWuPBVnMlf2VX+nCW8mh4YLXWv5p/3E4NUmHO8kmNk2wBp/ViYFS
         EAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cyZBXak+cF6JbtvZcE/sVa5hEbgfgeBs3PFeP9KUACU=;
        b=SJ7ycU652JG1xrqXkgY4TsRs8XDnY/bcLrGYqiQf6K6BNG3Q6dl56uz8q5FjIppylX
         lhWfbBVDConL3Xwr7TNkGeKQYJ+1LO6ow3qH+uz6LqHWi3NpcWfgncgiGBIWAhNG1m3+
         FWYzeQGWQYtnkDYsyYUb5P92cGiME1vwh32VGkPMcUGP/i/FlE7GE0VjXQxCMytHQlId
         szUW0qJ+gWQtKT/ZM3lGL8Z9LZcnkcANrYI6v5k3zIwvwH0veXDX7LlX1NtZ+hw1tj7b
         iHIDeFntvlNlLcc5DzUQoOOl1gkISAiW05yFozEHaPhE/eoKQdK82v368TjMS8CNhwcr
         u98A==
X-Gm-Message-State: AFqh2krmpRgUw0LydOaTwZIu12GEiqLCMnT8qGckSQG+a1ps7bz+enOX
        TT1y4JJHz+q0VMAg4RXC2LD3Y8qDw4GxdRj9g2cyjki2oI4=
X-Google-Smtp-Source: AMrXdXu+oZFXhOLU4thHkU9LkYx8VRropz8cRkc8W2hGkI40TQRJTsgIkKGH0WR/LoQj8Hz+R3zypLGG3M2vUOysb2c=
X-Received: by 2002:a17:906:7754:b0:86f:2cc2:7028 with SMTP id
 o20-20020a170906775400b0086f2cc27028mr8898059ejn.133.1675191945523; Tue, 31
 Jan 2023 11:05:45 -0800 (PST)
MIME-Version: 1.0
References: <20230112085602.14583-1-xiubli@redhat.com>
In-Reply-To: <20230112085602.14583-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 31 Jan 2023 20:05:33 +0100
Message-ID: <CAOi1vP_DC0GaNSi-Za__OQ2pfXOJqrigNVCC2-dGx7TO+kHV9g@mail.gmail.com>
Subject: Re: [PATCH v6] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, vshankar@redhat.com, stable@vger.kernel.org
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

On Thu, Jan 12, 2023 at 9:56 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When received corrupted snap trace we don't know what exactly has
> happened in MDS side. And we shouldn't continue IOs and metadatas
> access to MDS, which may corrupt or get incorrect contents.
>
> This patch will just block all the further IO/MDS requests
> immediately and then evict the kclient itself.
>
> The reason why we still need to evict the kclient just after
> blocking all the further IOs is that the MDS could revoke the caps
> faster.
>
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/57686
> Reviewed-by: Venky Shankar <vshankar@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V6:
> - switch to ceph_inode_is_shutdown() to check the mount state
> - fix two debug logs
> - use the WRITE_ONCE to set the FENCE_IO state
>
> V5:
> - s/CEPH_MOUNT_CORRUPTED/CEPH_MOUNT_FENCE_IO/g
>
> V4:
> - block all the IO/metadata requests before evicting the client.
>
> V3:
> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
>
> V2:
> - Switched to WARN() to taint the Linux kernel.
>
>
>
>  fs/ceph/addr.c       | 17 +++++++++++++++--
>  fs/ceph/caps.c       | 17 ++++++++++++++---
>  fs/ceph/file.c       |  9 +++++++++
>  fs/ceph/mds_client.c | 28 +++++++++++++++++++++++++---
>  fs/ceph/snap.c       | 38 ++++++++++++++++++++++++++++++++++++--
>  fs/ceph/super.h      |  1 +
>  6 files changed, 100 insertions(+), 10 deletions(-)

Hi Xiubo,

This patch appears to be based on testing.  If the intent is to get it
into 6.2-rc it needs to be rebased on mainline because there is a number
of contextual conflicts with SPARSEREAD, etc.

>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 6fb329a70ac1..13d1c24d2f53 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -305,13 +305,18 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>         struct inode *inode = rreq->inode;
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> -       struct ceph_osd_request *req;
> +       struct ceph_osd_request *req = NULL;
>         struct ceph_vino vino = ceph_vino(inode);
>         struct iov_iter iter;
>         int err = 0;
>         u64 len = subreq->len;
>         bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
>
> +       if (ceph_inode_is_shutdown(inode)) {
> +               err = -EIO;
> +               goto out;
> +       }
> +
>         if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
>                 return;
>
> @@ -557,6 +562,9 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>
>         dout("writepage %p idx %lu\n", page, page->index);
>
> +       if (ceph_inode_is_shutdown(inode))
> +               return -EIO;
> +
>         /* verify this is a writeable snap context */
>         snapc = page_snap_context(page);
>         if (!snapc) {
> @@ -1637,7 +1645,7 @@ int ceph_uninline_data(struct file *file)
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>         struct ceph_osd_request *req = NULL;
> -       struct ceph_cap_flush *prealloc_cf;
> +       struct ceph_cap_flush *prealloc_cf = NULL;
>         struct folio *folio = NULL;
>         u64 inline_version = CEPH_INLINE_NONE;
>         struct page *pages[1];
> @@ -1651,6 +1659,11 @@ int ceph_uninline_data(struct file *file)
>         dout("uninline_data %p %llx.%llx inline_version %llu\n",
>              inode, ceph_vinop(inode), inline_version);
>
> +       if (ceph_inode_is_shutdown(inode)) {
> +               err = -EIO;
> +               goto out;
> +       }
> +
>         if (inline_version == CEPH_INLINE_NONE)
>                 return 0;
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 948136f81fc8..5230ab64fff0 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4134,6 +4134,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>         void *p, *end;
>         struct cap_extra_info extra_info = {};
>         bool queue_trunc;
> +       bool close_sessions = false;
>
>         dout("handle_caps from mds%d\n", session->s_mds);
>
> @@ -4275,9 +4276,13 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>                 realm = NULL;
>                 if (snaptrace_len) {
>                         down_write(&mdsc->snap_rwsem);
> -                       ceph_update_snap_trace(mdsc, snaptrace,
> -                                              snaptrace + snaptrace_len,
> -                                              false, &realm);
> +                       if (ceph_update_snap_trace(mdsc, snaptrace,
> +                                                  snaptrace + snaptrace_len,
> +                                                  false, &realm)) {
> +                               up_write(&mdsc->snap_rwsem);
> +                               close_sessions = true;
> +                               goto done;
> +                       }
>                         downgrade_write(&mdsc->snap_rwsem);
>                 } else {
>                         down_read(&mdsc->snap_rwsem);
> @@ -4341,6 +4346,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>         iput(inode);
>  out:
>         ceph_put_string(extra_info.pool_ns);
> +
> +       /* Defer closing the sessions after s_mutex lock being released */
> +       if (close_sessions)
> +               ceph_mdsc_close_sessions(mdsc);
> +
>         return;
>
>  flush_cap_releases:
> @@ -4350,6 +4360,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>          * cap).
>          */
>         ceph_flush_cap_releases(mdsc, session);
> +

Stray whitespace?

>         goto done;
>
>  bad:
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 59c89c436185..1ba3c07e242b 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -976,6 +976,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>         dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
>              (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>
> +       if (ceph_inode_is_shutdown(inode))
> +               return -EIO;
> +
>         if (!len)
>                 return 0;
>         /*
> @@ -1342,6 +1345,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>         bool should_dirty = !write && user_backed_iter(iter);
>         bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
>
> +       if (ceph_inode_is_shutdown(inode))
> +               return -EIO;
> +
>         if (write && ceph_snap(file_inode(file)) != CEPH_NOSNAP)
>                 return -EROFS;
>
> @@ -2078,6 +2084,9 @@ static int ceph_zero_partial_object(struct inode *inode,
>         loff_t zero = 0;
>         int op;
>
> +       if (ceph_inode_is_shutdown(inode))
> +               return -EIO;
> +
>         if (!length) {
>                 op = offset ? CEPH_OSD_OP_DELETE : CEPH_OSD_OP_TRUNCATE;
>                 length = &zero;
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index cbbaf334b6b8..b60812707fce 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -957,6 +957,9 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>  {
>         struct ceph_mds_session *s;
>
> +       if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
> +               return ERR_PTR(-EIO);
> +
>         if (mds >= mdsc->mdsmap->possible_max_rank)
>                 return ERR_PTR(-EINVAL);
>
> @@ -1632,6 +1635,9 @@ static int __open_session(struct ceph_mds_client *mdsc,
>         int mstate;
>         int mds = session->s_mds;
>
> +       if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
> +               return -EIO;
> +
>         /* wait for mds to go active? */
>         mstate = ceph_mdsmap_get_state(mdsc->mdsmap, mds);
>         dout("open_session to mds%d (%s)\n", mds,
> @@ -3205,6 +3211,11 @@ static void __do_request(struct ceph_mds_client *mdsc,
>                 err = -ETIMEDOUT;
>                 goto finish;
>         }
> +       if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
> +               dout("do_request metadata corrupted\n");
> +               err = -EIO;
> +               goto finish;
> +       }

In all other cases, a fencing-related condition is checked first and
the associated EIO error therefore trumps all other errors (and not
just errors, in some cases the error takes precedence over a potential
successful return, for example when there is no inline data).  However
in this case ETIMEDOUT could be returned even if fsc->mount_state ==
CEPH_MOUNT_FENCE_IO.  Should these checks be reordered?

>         if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
>                 dout("do_request forced umount\n");
>                 err = -EIO;
> @@ -3584,6 +3595,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>         u64 tid;
>         int err, result;
>         int mds = session->s_mds;
> +       bool close_sessions = false;
>
>         if (msg->front.iov_len < sizeof(*head)) {
>                 pr_err("mdsc_handle_reply got corrupt (short) reply\n");
> @@ -3698,10 +3710,15 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>         realm = NULL;
>         if (rinfo->snapblob_len) {
>                 down_write(&mdsc->snap_rwsem);
> -               ceph_update_snap_trace(mdsc, rinfo->snapblob,
> +               err = ceph_update_snap_trace(mdsc, rinfo->snapblob,
>                                 rinfo->snapblob + rinfo->snapblob_len,
>                                 le32_to_cpu(head->op) == CEPH_MDS_OP_RMSNAP,
>                                 &realm);
> +               if (err) {
> +                       up_write(&mdsc->snap_rwsem);
> +                       close_sessions = true;
> +                       goto out_err;
> +               }
>                 downgrade_write(&mdsc->snap_rwsem);
>         } else {
>                 down_read(&mdsc->snap_rwsem);
> @@ -3759,6 +3776,10 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>                                      req->r_end_latency, err);
>  out:
>         ceph_mdsc_put_request(req);
> +
> +       /* Defer closing the sessions after s_mutex lock being released */
> +       if (close_sessions)
> +               ceph_mdsc_close_sessions(mdsc);
>         return;
>  }
>
> @@ -5358,7 +5379,7 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
>  }
>
>  /*
> - * called after sb is ro.
> + * called after sb is ro or when metadata corrupted.
>   */
>  void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
>  {
> @@ -5648,7 +5669,8 @@ static void mds_peer_reset(struct ceph_connection *con)
>         struct ceph_mds_client *mdsc = s->s_mdsc;
>
>         pr_warn("mds%d closed our session\n", s->s_mds);
> -       send_mds_reconnect(mdsc, s);
> +       if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO)
> +               send_mds_reconnect(mdsc, s);
>  }
>
>  static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index c1c452afa84d..3d417ec8da0c 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/ceph/ceph_debug.h>
>
> +#include <linux/fs.h>
>  #include <linux/sort.h>
>  #include <linux/slab.h>
>  #include <linux/iversion.h>
> @@ -767,8 +768,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>         struct ceph_snap_realm *realm;
>         struct ceph_snap_realm *first_realm = NULL;
>         struct ceph_snap_realm *realm_to_rebuild = NULL;
> +       struct ceph_client *client = mdsc->fsc->client;
>         int rebuild_snapcs;
>         int err = -ENOMEM;
> +       int ret;
>         LIST_HEAD(dirty_realms);
>
>         lockdep_assert_held_write(&mdsc->snap_rwsem);
> @@ -885,6 +888,27 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>         if (first_realm)
>                 ceph_put_snap_realm(mdsc, first_realm);
>         pr_err("%s error %d\n", __func__, err);
> +
> +       /*
> +        * When receiving a corrupted snap trace we don't know what
> +        * exactly has happened in MDS side. And we shouldn't continue
> +        * writing to OSD, which may corrupt the snapshot contents.
> +        *
> +        * Just try to blocklist this kclient and then this kclient
> +        * must be remounted to continue after the corrupted metadata
> +        * fixed in the MDS side.
> +        */
> +       WRITE_ONCE(mdsc->fsc->mount_state, CEPH_MOUNT_FENCE_IO);
> +       ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
> +       if (ret)
> +               pr_err("%s blocklist of %s failed: %d", __func__,
> +                      ceph_pr_addr(&client->msgr.inst.addr), ret);
> +
> +       WARN(1, "%s: %s%s do remount to continue%s",
> +            __func__, ret ? "" : ceph_pr_addr(&client->msgr.inst.addr),

FWIW this %s%s construct is still not right: in case blocklisting
fails, the message would look like "ceph_update_snap_trace:  do remount
..." with two spaces instead of one.

Thanks,

                Ilya
