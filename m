Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC31664C78
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 20:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjAJTab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 14:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjAJTaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 14:30:12 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EA1BC9E;
        Tue, 10 Jan 2023 11:30:11 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id v10so17902583edi.8;
        Tue, 10 Jan 2023 11:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UuGmxfdzm1A1d6Dwr6ciAxKjzfvLse6cfekUFUgweC0=;
        b=fs+2PPNz2Cf7IXSqRehP3+iobIGU6HVot/7AmGyHN1qfG6+FLFAsUNK3gzxiN9JezI
         ceFKEhgGD7sxYC4b7tWIoXgeQE29qiGugftAtGtaYwqE2XzbjCboN14fEpp4H5b5/YiE
         Js3Q+61s2sVfBdId1icUPslfA+niKaePOJxzo2VryX3RH9fCaCCCkDPObz7Y7wFQOhT+
         y6W+afRTUWlakBYq9C5YJrTn8BdXGAOBVW+AqdFsUVlwF+BrEI1LLToAOJy7a+UFVnNI
         Kqz3xsxH9EwjOql13ACE9M+m19kasPprVpO5JDDsCl8oCz3P/oPbxnwl0NlvGCdRts2q
         eX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UuGmxfdzm1A1d6Dwr6ciAxKjzfvLse6cfekUFUgweC0=;
        b=MqvFGdNJUR5t3xF3QuhCU7mQTRz02zps6Pa1iiZvkjDzoVztaFaBHiZqhKS8Ci2e7U
         9g5Yqnmf8FJze02eTnP8Q4YFYi8vJ56xnrkELNyho1cDd+86W292Gp7ZD/dcMPMQpypH
         h0FXcy0ybeRpiA7ytNai05jvmo9Ll6xWC7yoijZkvFhc6YnJODu4Aa+eihIVdBdUYUkJ
         zjJG4OpvH2xSDAfYeQTMpTJcXr1N+PAfJh8cTxUnVpkcGLglTMXEPLnYyhwUXaYQz9Gn
         xSFzL3IOmyS5ecW4RuA7tq4JEf/DSL/nY5j/Kv97tJmzdevrY9HWS3TjtG8o2JmW63BC
         yerw==
X-Gm-Message-State: AFqh2kpbDRZe8gaFicsMHocs1YsNQci7pYKiO5IeJzF3sW0c+ajiQiWv
        OHTaA9bjscWHvy4u9QBTeu+6iV/4GBS3mAXYQ8o=
X-Google-Smtp-Source: AMrXdXspk8g0yXmUPip/35eaX4bemquh0vpQ8V2qVlkceMGCjMpygf8a3snWCy7GITpr6qWVd0g/mTI0oHfoIAsadIc=
X-Received: by 2002:aa7:df8d:0:b0:47f:a863:956c with SMTP id
 b13-20020aa7df8d000000b0047fa863956cmr7549433edy.100.1673379009783; Tue, 10
 Jan 2023 11:30:09 -0800 (PST)
MIME-Version: 1.0
References: <20221221060206.1859329-1-xiubli@redhat.com> <20221221060206.1859329-3-xiubli@redhat.com>
In-Reply-To: <20221221060206.1859329-3-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Jan 2023 20:29:58 +0100
Message-ID: <CAOi1vP8BPzG8KNDg+r=93eCGaQNVrzAL66K9v3paZ1zy9JEfPQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] ceph: blocklist the kclient when receiving
 corrupted snap trace
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

On Wed, Dec 21, 2022 at 7:02 AM <xiubli@redhat.com> wrote:
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
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c       | 22 ++++++++++++++++++++--
>  fs/ceph/caps.c       | 17 ++++++++++++++---
>  fs/ceph/file.c       |  9 +++++++++
>  fs/ceph/mds_client.c | 28 +++++++++++++++++++++++++---
>  fs/ceph/snap.c       | 37 +++++++++++++++++++++++++++++++++++--
>  fs/ceph/super.h      |  1 +
>  6 files changed, 104 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index da2fb2c97531..092f8d40abdc 100644
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
> +       if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
> +               err = -EIO;
> +               goto out;
> +       }
> +
>         if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
>                 return;

Hi Xiubo,

Not related, but I noticed this while looking at this patch.  There
seems to be a double free on req in case ceph_alloc_sparse_ext_map()
fails.

>
> @@ -559,6 +564,9 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>
>         dout("writepage %p idx %lu\n", page, page->index);
>
> +       if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
> +               return -EIO;
> +
>         /* verify this is a writeable snap context */
>         snapc = page_snap_context(page);
>         if (!snapc) {
> @@ -797,6 +805,11 @@ static int ceph_writepages_start(struct address_space *mapping,
>         bool done = false;
>         bool caching = ceph_is_cache_enabled(inode);
>
> +       if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
> +               mapping_set_error(mapping, -EIO);
> +               return -EIO;

There is a check below which is triggered and handled almost the same
way: ceph_inode_is_shutdown(inode).  The new check is likely redundant
here and also raises a bigger question: what is the semantic difference
between the new CEPH_MOUNT_FENCE_IO and the existing CEPH_MOUNT_SHUTDOWN
state when it comes to OSD requests?  Given that CEPH_MOUNT_SHUTDOWN
already kills writes in ceph_writepages_start() and some other places,
why is another bunch of mount_state checks in addr.c and file.c needed?

> +       }
> +
>         if (wbc->sync_mode == WB_SYNC_NONE &&
>             fsc->write_congested)
>                 return 0;
> @@ -1639,7 +1652,7 @@ int ceph_uninline_data(struct file *file)
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>         struct ceph_osd_request *req = NULL;
> -       struct ceph_cap_flush *prealloc_cf;
> +       struct ceph_cap_flush *prealloc_cf = NULL;
>         struct folio *folio = NULL;
>         u64 inline_version = CEPH_INLINE_NONE;
>         struct page *pages[1];
> @@ -1653,6 +1666,11 @@ int ceph_uninline_data(struct file *file)
>         dout("uninline_data %p %llx.%llx inline_version %llu\n",
>              inode, ceph_vinop(inode), inline_version);
>
> +       if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
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
>         goto done;
>
>  bad:
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 85afcbbb5648..76a5633b3f35 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -976,6 +976,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>         dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
>              (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>
> +       if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
> +               return -EIO;
> +
>         if (!len)
>                 return 0;
>         /*
> @@ -1342,6 +1345,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>         bool should_dirty = !write && user_backed_iter(iter);
>         bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
>
> +       if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
> +               return -EIO;
> +
>         if (write && ceph_snap(file_inode(file)) != CEPH_NOSNAP)
>                 return -EROFS;
>
> @@ -2078,6 +2084,9 @@ static int ceph_zero_partial_object(struct inode *inode,
>         loff_t zero = 0;
>         int op;
>
> +       if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
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
> index c1c452afa84d..a73943e51a77 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
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
> @@ -885,6 +887,27 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
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
> +       mdsc->fsc->mount_state = CEPH_MOUNT_FENCE_IO;

Should this be done through WRITE_ONCE?

> +       ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
> +       if (ret)
> +               pr_err("%s blocklist of %s failed: %d", __func__,
> +                      ceph_pr_addr(&client->msgr.inst.addr), ret);
> +
> +       WARN(1, "%s:%s%s do remount to continue%s",

A space is missing here: "%s: %s%s".

> +            __func__, ret ? "" : ceph_pr_addr(&client->msgr.inst.addr),
> +            ret ? "" : " was blocklisted,",
> +            err == -EIO ? " after corrupted snaptrace fixed" : "");

"after corrupted snaptrace is fixed"

Thanks,

                Ilya

> +
>         return err;
>  }
>
> @@ -985,6 +1008,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>         __le64 *split_inos = NULL, *split_realms = NULL;
>         int i;
>         int locked_rwsem = 0;
> +       bool close_sessions = false;
>
>         /* decode */
>         if (msg->front.iov_len < sizeof(*h))
> @@ -1093,8 +1117,12 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
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
> @@ -1113,6 +1141,11 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>  out:
>         if (locked_rwsem)
>                 up_write(&mdsc->snap_rwsem);
> +
> +       /* Defer closing the sessions after s_mutex lock being released */
> +       if (close_sessions)
> +               ceph_mdsc_close_sessions(mdsc);
> +
>         return;
>  }
>
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 0d5cb0983831..f59fd4b4755b 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -111,6 +111,7 @@ enum {
>         CEPH_MOUNT_UNMOUNTED,
>         CEPH_MOUNT_SHUTDOWN,
>         CEPH_MOUNT_RECOVER,
> +       CEPH_MOUNT_FENCE_IO,
>  };
>
>  #define CEPH_ASYNC_CREATE_CONFLICT_BITS 8
> --
> 2.31.1
>
