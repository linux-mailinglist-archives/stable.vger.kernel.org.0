Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4D8687E51
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 14:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjBBNLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 08:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjBBNLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 08:11:43 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85288C421;
        Thu,  2 Feb 2023 05:11:40 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id dr8so5713857ejc.12;
        Thu, 02 Feb 2023 05:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uE/PZl8bXbMy/8cB7HRnlexu8+tv2uDQFVWizPQeq30=;
        b=LI0mXs93a+UvKw3A/4JZvbBMsrM2xP5tAmEIWxdwp9C1i3w4XMfditg1WM8dGrOCeE
         rQJp8xqYmIv5AgORmfD/C0DHqZXBNRIbo2WyuWKJhVtjgpu+lPXNrpfS2laioAFXJgiV
         gc58mDcLsVqjLKrg1oqaanWwC6aMAtdVBKbz2xElFsdO8tM0/Th0EYE9zQ3nMcJA+s7d
         YoyuYyCr5IIrCysvfv/FYPjT/ondcYnrWsQ0MjrpGMIPn1SYExWTPzHb2Br053qgakv+
         HLDw6MAxDbd5yt3zNlLW61jQidkVjxOxb8SzghBVTRJhvt0r+VyF3MdGOKiVXsl+flvn
         6PUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uE/PZl8bXbMy/8cB7HRnlexu8+tv2uDQFVWizPQeq30=;
        b=DklvtYIfcPqIzAGIFd+mzH/MxYatshlRdyVUvWimldpKOA1psyYuoYYi/U7PnN+WW6
         GzMprVGqqWQFoFP19edOtttLH0r7fY4HS6qTV9+rQxYnVkxhhGKBgFAfPbgePnw5Qr8s
         lCoDOmnItqdi6IhLa+CBdolohWO8QILpz/iPiSYeZ9MKmslR8opTri4R7dv9xH3UTiV4
         ImD1ztxePmmSm0BbvqExtvYqspirhOwowiMP2mPCH45Ljqacbi/mlcjlNumy1/kAd1YL
         h7osx2lfR1IvAzXcgWxb51UO65JkmIRurNl8+Go4zfKxIuzqp0y0ea1Jv7UR/9gvVwnq
         aAqg==
X-Gm-Message-State: AO0yUKXL540s790AZ0ajkGDDIcsmH7yl2es1Xxp+Soqn4kJEooaPkQdC
        Em4BB3RYZzfbz+GAuDxuzdkt3Gth6cIBS9L7Yp0=
X-Google-Smtp-Source: AK7set+3pFkS8++1tJdAgd6jTuCf4/T6yT/gANQklvAFot1PToZOynl3DSLxLaT2QQta7VAPFE85YvkDsYcKJH2T7Zk=
X-Received: by 2002:a17:906:b154:b0:88d:7c47:39f5 with SMTP id
 bt20-20020a170906b15400b0088d7c4739f5mr1884027ejb.159.1675343498984; Thu, 02
 Feb 2023 05:11:38 -0800 (PST)
MIME-Version: 1.0
References: <20230201013645.404251-1-xiubli@redhat.com> <20230201013645.404251-3-xiubli@redhat.com>
 <CAOi1vP-4VF1XukTdhESgHHZbWK6A-p1yZ3_x3viSUfm_vu58rA@mail.gmail.com> <b3abcaaf-f48a-5666-733d-073f2cf876bd@redhat.com>
In-Reply-To: <b3abcaaf-f48a-5666-733d-073f2cf876bd@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 2 Feb 2023 14:11:26 +0100
Message-ID: <CAOi1vP_cKdoiThzu-GM2isauzVN2rvCjo+ViRr4qmMSs+1Op=A@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] ceph: blocklist the kclient when receiving
 corrupted snap trace
To:     Xiubo Li <xiubli@redhat.com>
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

On Thu, Feb 2, 2023 at 3:30 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 01/02/2023 21:12, Ilya Dryomov wrote:
> > On Wed, Feb 1, 2023 at 2:37 AM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> When received corrupted snap trace we don't know what exactly has
> >> happened in MDS side. And we shouldn't continue IOs and metadatas
> >> access to MDS, which may corrupt or get incorrect contents.
> >>
> >> This patch will just block all the further IO/MDS requests
> >> immediately and then evict the kclient itself.
> >>
> >> The reason why we still need to evict the kclient just after
> >> blocking all the further IOs is that the MDS could revoke the caps
> >> faster.
> >>
> >> Cc: stable@vger.kernel.org
> >> URL: https://tracker.ceph.com/issues/57686
> >> Reviewed-by: Venky Shankar <vshankar@redhat.com>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/addr.c       | 17 +++++++++++++++--
> >>   fs/ceph/caps.c       | 16 +++++++++++++---
> >>   fs/ceph/file.c       |  9 +++++++++
> >>   fs/ceph/mds_client.c | 28 +++++++++++++++++++++++++---
> >>   fs/ceph/snap.c       | 38 ++++++++++++++++++++++++++++++++++++--
> >>   fs/ceph/super.h      |  1 +
> >>   6 files changed, 99 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> >> index 8c74871e37c9..cac4083e387a 100644
> >> --- a/fs/ceph/addr.c
> >> +++ b/fs/ceph/addr.c
> >> @@ -305,7 +305,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
> >>          struct inode *inode = rreq->inode;
> >>          struct ceph_inode_info *ci = ceph_inode(inode);
> >>          struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> >> -       struct ceph_osd_request *req;
> >> +       struct ceph_osd_request *req = NULL;
> >>          struct ceph_vino vino = ceph_vino(inode);
> >>          struct iov_iter iter;
> >>          struct page **pages;
> >> @@ -313,6 +313,11 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
> >>          int err = 0;
> >>          u64 len = subreq->len;
> >>
> >> +       if (ceph_inode_is_shutdown(inode)) {
> >> +               err = -EIO;
> >> +               goto out;
> >> +       }
> >> +
> >>          if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
> >>                  return;
> >>
> >> @@ -563,6 +568,9 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
> >>
> >>          dout("writepage %p idx %lu\n", page, page->index);
> >>
> >> +       if (ceph_inode_is_shutdown(inode))
> >> +               return -EIO;
> >> +
> >>          /* verify this is a writeable snap context */
> >>          snapc = page_snap_context(page);
> >>          if (!snapc) {
> >> @@ -1643,7 +1651,7 @@ int ceph_uninline_data(struct file *file)
> >>          struct ceph_inode_info *ci = ceph_inode(inode);
> >>          struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> >>          struct ceph_osd_request *req = NULL;
> >> -       struct ceph_cap_flush *prealloc_cf;
> >> +       struct ceph_cap_flush *prealloc_cf = NULL;
> >>          struct folio *folio = NULL;
> >>          u64 inline_version = CEPH_INLINE_NONE;
> >>          struct page *pages[1];
> >> @@ -1657,6 +1665,11 @@ int ceph_uninline_data(struct file *file)
> >>          dout("uninline_data %p %llx.%llx inline_version %llu\n",
> >>               inode, ceph_vinop(inode), inline_version);
> >>
> >> +       if (ceph_inode_is_shutdown(inode)) {
> >> +               err = -EIO;
> >> +               goto out;
> >> +       }
> >> +
> >>          if (inline_version == CEPH_INLINE_NONE)
> >>                  return 0;
> >>
> >> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> >> index f75ad432f375..210e40037881 100644
> >> --- a/fs/ceph/caps.c
> >> +++ b/fs/ceph/caps.c
> >> @@ -4078,6 +4078,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
> >>          void *p, *end;
> >>          struct cap_extra_info extra_info = {};
> >>          bool queue_trunc;
> >> +       bool close_sessions = false;
> >>
> >>          dout("handle_caps from mds%d\n", session->s_mds);
> >>
> >> @@ -4215,9 +4216,13 @@ void ceph_handle_caps(struct ceph_mds_session *session,
> >>                  realm = NULL;
> >>                  if (snaptrace_len) {
> >>                          down_write(&mdsc->snap_rwsem);
> >> -                       ceph_update_snap_trace(mdsc, snaptrace,
> >> -                                              snaptrace + snaptrace_len,
> >> -                                              false, &realm);
> >> +                       if (ceph_update_snap_trace(mdsc, snaptrace,
> >> +                                                  snaptrace + snaptrace_len,
> >> +                                                  false, &realm)) {
> >> +                               up_write(&mdsc->snap_rwsem);
> >> +                               close_sessions = true;
> >> +                               goto done;
> >> +                       }
> >>                          downgrade_write(&mdsc->snap_rwsem);
> >>                  } else {
> >>                          down_read(&mdsc->snap_rwsem);
> >> @@ -4277,6 +4282,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
> >>          iput(inode);
> >>   out:
> >>          ceph_put_string(extra_info.pool_ns);
> >> +
> >> +       /* Defer closing the sessions after s_mutex lock being released */
> >> +       if (close_sessions)
> >> +               ceph_mdsc_close_sessions(mdsc);
> >> +
> >>          return;
> >>
> >>   flush_cap_releases:
> >> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> >> index 764598e1efd9..3fbf4993d15d 100644
> >> --- a/fs/ceph/file.c
> >> +++ b/fs/ceph/file.c
> >> @@ -943,6 +943,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
> >>          dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
> >>               (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
> >>
> >> +       if (ceph_inode_is_shutdown(inode))
> >> +               return -EIO;
> > Hi Xiubo,
> >
> > ceph_sync_read() is called only from ceph_read_iter() which already
> > checks for ceph_inode_is_shutdown() (although the generated error is
> > ESTALE instead of EIO).  Is the new one in ceph_sync_read() actually
> > needed?
> >
> > If the answer is yes, why hasn't a corresponding check been added to
> > ceph_sync_write()?
>
> Before I generated this patch based on the fscrypt patches,  this will
> be renamed to __ceph_sync_read() and also will be called by
> fill_fscrypt_truncate(). I just forgot this and after rebasing I didn't
> adjust it.
>
> I have updated the 'wip-snap-trace-blocklist' branch by removing it from
> here and ceph_direct_read_write(). And I will fix this later in the
> fscrypt patches.

Hi Xiubo,

The latest revision looks fine.  I folded the "ceph: dump the msg when
receiving a corrupt snap trace" follow-up into this patch and pulled the
result into master.

I also rebased testing appropriately, feel free to perform the necessary
fscrypt-related fixups there!

Thanks,

                Ilya
