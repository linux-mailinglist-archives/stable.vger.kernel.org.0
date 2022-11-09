Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447C0622D49
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 15:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiKIOQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 09:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiKIOQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 09:16:56 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87490E41;
        Wed,  9 Nov 2022 06:16:54 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id 13so47074449ejn.3;
        Wed, 09 Nov 2022 06:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5uqSshIS4DG9q63dG7cW224Y5uvALsigR0o5/MU/kNc=;
        b=WgSgBH9EGPfjOMlO/UHS1jZS3/0w3RGz32gZT38blC/tfhwgfnLO4JqwIVmLfYqN6M
         6MC5eMeg7XCiq+VcmfHQW52H0LaCHw0MAmQr/FY3kOUydBT9lI0VYBSYZY32CoWbSLxG
         XAb0pM91QS9IaXpEmuoRgHVUlSSdDYGHw8XcwPeNNykydig6FoKqwkwozabosvo12xxJ
         21zIvwNZAJI98/x/1P7GcXAYAZLnpcfh6ml2W9fYPKmqjkauCTXC6OGmpEYLE/v1YRpa
         xiIWj4SJ+MxeCtn8cbBj3AtedJ9XUY4yrFw+pvRmo+PHEROuBvFHQzu2CKrL1131Y1Hs
         2n4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5uqSshIS4DG9q63dG7cW224Y5uvALsigR0o5/MU/kNc=;
        b=hGeVIQLlhWddJX23QJiapSuQigIm6rq6L+27pDA6J7/q5BuBaJlGdmL0OfNXKXbCW3
         9kw+7XlJKa3T8G0kYC3pXT87KrvOEa1i1bsfuu44PMogdsaL6fom6uLNUO8mwWAhu3DD
         awmegZsEXAYNSPG0kVjB73FZODenYCf6Iq5ESoFlYhXduTaGJwY//UeWCW/BYSYRyooo
         jCdUFdAi50fNgU4AukE+Uc/mHXgibh8KFgK2QcUW9E0gGTnyPpqPqPRNgwtbP40kgb+c
         9Q6KE+nEqdT4tpnuKgr2UiNGpIL40/0LjJ98d20zBDD2+frf9+aUU7xSS0nZ1yzqCc13
         28kg==
X-Gm-Message-State: ACrzQf0MFppqJonaUv29TLZy0oFvRU9y7H0QeDCj6Gf5h3vej9YrEsvt
        bTqHuJHKEDYY66+sNOKvi4YeFqQnD/RH8uOUhZM=
X-Google-Smtp-Source: AMsMyM78lUFK1PIcjMCDDIydufoHgInBGM4HOYViAaUF27WQsIpWQ1lkqnGrwesPWeA1MrG3YgGOHCNZVDMBpK4fUHw=
X-Received: by 2002:a17:906:e83:b0:7ae:c0c:210b with SMTP id
 p3-20020a1709060e8300b007ae0c0c210bmr34418749ejf.523.1668003412976; Wed, 09
 Nov 2022 06:16:52 -0800 (PST)
MIME-Version: 1.0
References: <20221108135554.558278-1-xiubli@redhat.com> <CAOi1vP8Fkzq542St9od7G_JnQyS93=BgLLRUE86-E-Zw4MEt3g@mail.gmail.com>
 <c905be56-ba74-9a86-1aff-3fb17a157932@redhat.com>
In-Reply-To: <c905be56-ba74-9a86-1aff-3fb17a157932@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 9 Nov 2022 15:16:41 +0100
Message-ID: <CAOi1vP91fd=TpnPio0rtMcpepqz4u3r1HsXmp8+WC7dfy2rZ2w@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: fix NULL pointer dereference for req->r_session
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
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

On Wed, Nov 9, 2022 at 3:12 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 09/11/2022 20:56, Ilya Dryomov wrote:
> > On Tue, Nov 8, 2022 at 2:56 PM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> The request's r_session maybe changed when it was forwarded or
> >> resent.
> >>
> >> Cc: stable@vger.kernel.org
> >> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/caps.c | 60 ++++++++++++++++----------------------------------
> >>   1 file changed, 19 insertions(+), 41 deletions(-)
> >>
> >> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> >> index 894adfb4a092..83f9e18e3169 100644
> >> --- a/fs/ceph/caps.c
> >> +++ b/fs/ceph/caps.c
> >> @@ -2297,8 +2297,10 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
> >>          struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> >>          struct ceph_inode_info *ci = ceph_inode(inode);
> >>          struct ceph_mds_request *req1 = NULL, *req2 = NULL;
> >> +       struct ceph_mds_session **sessions = NULL;
> >> +       struct ceph_mds_session *s;
> >>          unsigned int max_sessions;
> >> -       int ret, err = 0;
> >> +       int i, ret, err = 0;
> >>
> >>          spin_lock(&ci->i_unsafe_lock);
> >>          if (S_ISDIR(inode->i_mode) && !list_empty(&ci->i_unsafe_dirops)) {
> >> @@ -2315,28 +2317,19 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
> >>          }
> >>          spin_unlock(&ci->i_unsafe_lock);
> >>
> >> -       /*
> >> -        * The mdsc->max_sessions is unlikely to be changed
> >> -        * mostly, here we will retry it by reallocating the
> >> -        * sessions array memory to get rid of the mdsc->mutex
> >> -        * lock.
> >> -        */
> >> -retry:
> >> -       max_sessions = mdsc->max_sessions;
> >> -
> >>          /*
> >>           * Trigger to flush the journal logs in all the relevant MDSes
> >>           * manually, or in the worst case we must wait at most 5 seconds
> >>           * to wait the journal logs to be flushed by the MDSes periodically.
> >>           */
> >> -       if ((req1 || req2) && likely(max_sessions)) {
> >> -               struct ceph_mds_session **sessions = NULL;
> >> -               struct ceph_mds_session *s;
> >> +       mutex_lock(&mdsc->mutex);
> >> +       max_sessions = mdsc->max_sessions;
> >> +       if (req1 || req2) {
> >>                  struct ceph_mds_request *req;
> >> -               int i;
> >>
> >>                  sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
> >>                  if (!sessions) {
> >> +                       mutex_unlock(&mdsc->mutex);
> >>                          err = -ENOMEM;
> >>                          goto out;
> >>                  }
> >> @@ -2346,18 +2339,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
> >>                          list_for_each_entry(req, &ci->i_unsafe_dirops,
> >>                                              r_unsafe_dir_item) {
> >>                                  s = req->r_session;
> >> -                               if (!s)
> >> +                               if (!s || unlikely(s->s_mds >= max_sessions))
> >>                                          continue;
> >> -                               if (unlikely(s->s_mds >= max_sessions)) {
> >> -                                       spin_unlock(&ci->i_unsafe_lock);
> >> -                                       for (i = 0; i < max_sessions; i++) {
> >> -                                               s = sessions[i];
> >> -                                               if (s)
> >> -                                                       ceph_put_mds_session(s);
> >> -                                       }
> >> -                                       kfree(sessions);
> >> -                                       goto retry;
> >> -                               }
> >>                                  if (!sessions[s->s_mds]) {
> >>                                          s = ceph_get_mds_session(s);
> >>                                          sessions[s->s_mds] = s;
> >> @@ -2368,18 +2351,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
> >>                          list_for_each_entry(req, &ci->i_unsafe_iops,
> >>                                              r_unsafe_target_item) {
> >>                                  s = req->r_session;
> >> -                               if (!s)
> >> +                               if (!s || unlikely(s->s_mds >= max_sessions))
> >>                                          continue;
> >> -                               if (unlikely(s->s_mds >= max_sessions)) {
> >> -                                       spin_unlock(&ci->i_unsafe_lock);
> >> -                                       for (i = 0; i < max_sessions; i++) {
> >> -                                               s = sessions[i];
> >> -                                               if (s)
> >> -                                                       ceph_put_mds_session(s);
> >> -                                       }
> >> -                                       kfree(sessions);
> >> -                                       goto retry;
> >> -                               }
> >>                                  if (!sessions[s->s_mds]) {
> >>                                          s = ceph_get_mds_session(s);
> >>                                          sessions[s->s_mds] = s;
> >> @@ -2391,13 +2364,18 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
> >>                  /* the auth MDS */
> >>                  spin_lock(&ci->i_ceph_lock);
> >>                  if (ci->i_auth_cap) {
> >> -                     s = ci->i_auth_cap->session;
> >> -                     if (!sessions[s->s_mds])
> >> -                             sessions[s->s_mds] = ceph_get_mds_session(s);
> >> +                       s = ci->i_auth_cap->session;
> >> +                       if (likely(s->s_mds < max_sessions)
> >> +                           && !sessions[s->s_mds]) {
> > Hi Xiubo,
> >
> > Nit: keep && on the previous line for style consistency.
>
> Sure. Will fix it.
>
>
> >
> >> +                               sessions[s->s_mds] = ceph_get_mds_session(s);
> >> +                       }
> >>                  }
> >>                  spin_unlock(&ci->i_ceph_lock);
> >> +       }
> >> +       mutex_unlock(&mdsc->mutex);
> >>
> >> -               /* send flush mdlog request to MDSes */
> >> +       /* send flush mdlog request to MDSes */
> >> +       if (sessions) {
> > Since mdlog is flushed only in "if (req1 || req2)" case, why not keep
> > max_sessions loop there and avoid sessions != NULL check?
>
> This is because I must drop the mdsc->mutex before calling
> "send_flush_mdlog()" in the max_sessions loop.

If you move mdsc->mutex acquisition and max_sessions assignment
into "if (req1 || req2)" branch, it can be trivially dropped before
the loop.

Thanks,

                Ilya
