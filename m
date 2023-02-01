Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938D1686670
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 14:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbjBANMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 08:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjBANMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 08:12:40 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77EA6385D;
        Wed,  1 Feb 2023 05:12:34 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id k4so45804514eje.1;
        Wed, 01 Feb 2023 05:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6NxabXm39DsstyXXKSgmQju2hEiPCbZXPShbRUxDGTI=;
        b=i+ko4lgn6wat1wPy4lgG7U3r67Q7UoBbjJxOGzZuVyTDMalRvLG3JAPq9s+jT+rlMq
         HFVO1Rhs0ssaTJ9SF/sj47NANsPs+qDkHy/cxwIek6sAX4xr3V7rvuz6WnfjEq/h6u4v
         vEkbRHRbExbB/a3Tmn3jPK504/gjVcFTqO0Gas54Ww4osSXWTyMj7OGPPaK/TEv6ZT5W
         Oxd1TXYpHJHSei7Qrs2eowBaw7GDG+/jAEXd9SEO2hGF7t4x8Ubegjx3dQWWyzlGRLfo
         MjgsCiVSQuPS+B6udl6FybQE17sLIvyb5xTVZexq8jTFjx0HZyPQBzTNRNSxEFtnJPGn
         ujmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6NxabXm39DsstyXXKSgmQju2hEiPCbZXPShbRUxDGTI=;
        b=H6slsQ78GXnA0JESSfz+Dv4z+SMewqweTd3Yyq34AEaFSobhv1V+AFz7ExT8M6FFV/
         NOkLs1g/osGVdDWH88egMGYNGJRRAdqY6V+vtKp+6NnEtk2VKSk4IBgtGQqg7JzHaM6z
         uDmOabnv3W8MU/QpKL8ReAAJoKvUmATvV3fb+T64w72ixpiAbpQ33mwg8p6HL1SAJd4J
         z3TLbajxh2AQS/Jnaw7vQtTily6DblKOKNWJm4jAVQe8+ttbNp4d6uaf0IskNvpfGPE1
         Gclo+ncTAtvcmlZQSWofWQgqg3iB47EzTVcxaYZ9fGFJFct0xES6/pg6f9FOD+SEAONL
         zefA==
X-Gm-Message-State: AO0yUKWt8tDo7yAHIOzXLUfFHg8kQyV/5flLpS1XW3uoH7pc2iDEmtCK
        r4ecH4k4E7wfFpbo8JJg05fAMSU/dwf/4gHJOT4=
X-Google-Smtp-Source: AK7set931TGqkKWzzadM1Dy8MozYLxwi0EcoaiZ8W1Yki9OlS/8eg6EyAMmzgVa3xeu07Kvyg89aCq6/l/W/GXEJkp8=
X-Received: by 2002:a17:906:5055:b0:880:ffaa:16f3 with SMTP id
 e21-20020a170906505500b00880ffaa16f3mr681856ejk.207.1675257153275; Wed, 01
 Feb 2023 05:12:33 -0800 (PST)
MIME-Version: 1.0
References: <20230201013645.404251-1-xiubli@redhat.com> <20230201013645.404251-3-xiubli@redhat.com>
In-Reply-To: <20230201013645.404251-3-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 1 Feb 2023 14:12:20 +0100
Message-ID: <CAOi1vP-4VF1XukTdhESgHHZbWK6A-p1yZ3_x3viSUfm_vu58rA@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] ceph: blocklist the kclient when receiving
 corrupted snap trace
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, vshankar@redhat.com, lhenriques@suse.de,
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

On Wed, Feb 1, 2023 at 2:37 AM <xiubli@redhat.com> wrote:
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
>  fs/ceph/addr.c       | 17 +++++++++++++++--
>  fs/ceph/caps.c       | 16 +++++++++++++---
>  fs/ceph/file.c       |  9 +++++++++
>  fs/ceph/mds_client.c | 28 +++++++++++++++++++++++++---
>  fs/ceph/snap.c       | 38 ++++++++++++++++++++++++++++++++++++--
>  fs/ceph/super.h      |  1 +
>  6 files changed, 99 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 8c74871e37c9..cac4083e387a 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -305,7 +305,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>         struct inode *inode = rreq->inode;
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> -       struct ceph_osd_request *req;
> +       struct ceph_osd_request *req = NULL;
>         struct ceph_vino vino = ceph_vino(inode);
>         struct iov_iter iter;
>         struct page **pages;
> @@ -313,6 +313,11 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>         int err = 0;
>         u64 len = subreq->len;
>
> +       if (ceph_inode_is_shutdown(inode)) {
> +               err = -EIO;
> +               goto out;
> +       }
> +
>         if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
>                 return;
>
> @@ -563,6 +568,9 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>
>         dout("writepage %p idx %lu\n", page, page->index);
>
> +       if (ceph_inode_is_shutdown(inode))
> +               return -EIO;
> +
>         /* verify this is a writeable snap context */
>         snapc = page_snap_context(page);
>         if (!snapc) {
> @@ -1643,7 +1651,7 @@ int ceph_uninline_data(struct file *file)
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>         struct ceph_osd_request *req = NULL;
> -       struct ceph_cap_flush *prealloc_cf;
> +       struct ceph_cap_flush *prealloc_cf = NULL;
>         struct folio *folio = NULL;
>         u64 inline_version = CEPH_INLINE_NONE;
>         struct page *pages[1];
> @@ -1657,6 +1665,11 @@ int ceph_uninline_data(struct file *file)
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
> index f75ad432f375..210e40037881 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4078,6 +4078,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>         void *p, *end;
>         struct cap_extra_info extra_info = {};
>         bool queue_trunc;
> +       bool close_sessions = false;
>
>         dout("handle_caps from mds%d\n", session->s_mds);
>
> @@ -4215,9 +4216,13 @@ void ceph_handle_caps(struct ceph_mds_session *session,
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
> @@ -4277,6 +4282,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
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
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 764598e1efd9..3fbf4993d15d 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -943,6 +943,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>         dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
>              (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>
> +       if (ceph_inode_is_shutdown(inode))
> +               return -EIO;

Hi Xiubo,

ceph_sync_read() is called only from ceph_read_iter() which already
checks for ceph_inode_is_shutdown() (although the generated error is
ESTALE instead of EIO).  Is the new one in ceph_sync_read() actually
needed?

If the answer is yes, why hasn't a corresponding check been added to
ceph_sync_write()?

> +
>         if (!len)
>                 return 0;
>         /*
> @@ -1287,6 +1290,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>         bool write = iov_iter_rw(iter) == WRITE;
>         bool should_dirty = !write && user_backed_iter(iter);
>
> +       if (ceph_inode_is_shutdown(inode))
> +               return -EIO;

Similarly, ceph_direct_read_write() is called from ceph_read_iter() and
ceph_write_iter(), both of which check for ceph_inode_is_shutdown() at
the top already.

> +
>         if (write && ceph_snap(file_inode(file)) != CEPH_NOSNAP)
>                 return -EROFS;
>
> @@ -2011,6 +2017,9 @@ static int ceph_zero_partial_object(struct inode *inode,
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
> index 26a0a8b9975e..df78d30c1cce 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -806,6 +806,9 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>  {
>         struct ceph_mds_session *s;
>
> +       if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
> +               return ERR_PTR(-EIO);
> +
>         if (mds >= mdsc->mdsmap->possible_max_rank)
>                 return ERR_PTR(-EINVAL);
>
> @@ -1478,6 +1481,9 @@ static int __open_session(struct ceph_mds_client *mdsc,
>         int mstate;
>         int mds = session->s_mds;
>
> +       if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
> +               return -EIO;
> +
>         /* wait for mds to go active? */
>         mstate = ceph_mdsmap_get_state(mdsc->mdsmap, mds);
>         dout("open_session to mds%d (%s)\n", mds,
> @@ -2860,6 +2866,11 @@ static void __do_request(struct ceph_mds_client *mdsc,
>                 return;
>         }
>
> +       if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
> +               dout("do_request metadata corrupted\n");
> +               err = -EIO;
> +               goto finish;
> +       }
>         if (req->r_timeout &&
>             time_after_eq(jiffies, req->r_started + req->r_timeout)) {
>                 dout("do_request timed out\n");
> @@ -3245,6 +3256,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>         u64 tid;
>         int err, result;
>         int mds = session->s_mds;
> +       bool close_sessions = false;
>
>         if (msg->front.iov_len < sizeof(*head)) {
>                 pr_err("mdsc_handle_reply got corrupt (short) reply\n");
> @@ -3351,10 +3363,15 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
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
> @@ -3412,6 +3429,10 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
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
> @@ -5011,7 +5032,7 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
>  }
>
>  /*
> - * called after sb is ro.
> + * called after sb is ro or when metadata corrupted.
>   */
>  void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
>  {
> @@ -5301,7 +5322,8 @@ static void mds_peer_reset(struct ceph_connection *con)
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
> index e4151852184e..e985e4e3ed85 100644
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
> @@ -766,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
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
> @@ -884,6 +887,27 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
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

A newline is missing at the end here, I have added it.

> +                      ceph_pr_addr(&client->msgr.inst.addr), ret);
> +
> +       WARN(1, "%s: %s%sdo remount to continue%s",
> +            __func__, ret ? "" : ceph_pr_addr(&client->msgr.inst.addr),
> +            ret ? "" : " was blocklisted, ",
> +            err == -EIO ? " after corrupted snaptrace is fixed" : "");
> +
>         return err;
>  }
>
> @@ -984,6 +1008,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>         __le64 *split_inos = NULL, *split_realms = NULL;
>         int i;
>         int locked_rwsem = 0;
> +       bool close_sessions = false;
>
>         /* decode */
>         if (msg->front.iov_len < sizeof(*h))
> @@ -1092,8 +1117,12 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>          * update using the provided snap trace. if we are deleting a
>          * snap, we can avoid queueing cap_snaps.
>          */
> -       ceph_update_snap_trace(mdsc, p, e,
> -                              op == CEPH_SNAP_OP_DESTROY, NULL);
> +       if (ceph_update_snap_trace(mdsc, p, e,
> +                                  op == CEPH_SNAP_OP_DESTROY,
> +                                  NULL)) {
> +               close_sessions = true;
> +               goto bad;
> +       }
>
>         if (op == CEPH_SNAP_OP_SPLIT)
>                 /* we took a reference when we created the realm, above */
> @@ -1112,6 +1141,11 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>  out:
>         if (locked_rwsem)
>                 up_write(&mdsc->snap_rwsem);
> +
> +       /* Defer closing the sessions after s_mutex lock being released */

s_mutex doesn't seem to be held here.  Did you mean snap_rwsem or does
the locking not matter at all in this case?

I assume it's the latter so I have removed this comment.  Let me know
if it needs to be added back and mention snap_rwsem (or something else
entirely) instead.

I have pushed the result to wip-snap-trace-blocklist branch for now,
until the question of either redundant or missing checks in file.c is
clarified.

Thanks,

                Ilya
