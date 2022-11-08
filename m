Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B2E62112E
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiKHMoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbiKHMoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:44:23 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B135F2BC7;
        Tue,  8 Nov 2022 04:44:22 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id t25so38241546ejb.8;
        Tue, 08 Nov 2022 04:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tm/K50OJfMDqvas0Rf7rVVrtqGgJ4S3T0B2gTD2W/r0=;
        b=qMwfjmZovUWjo5Gfsw4AvP8yjCrcgNvuJK3kldqDlhxY/FVW3Jf9pW2RMSGp/phL/c
         gcpv67dmA3O8nX56g535nBsLn5xh/v9NBqhQSWJnF4z0zoVT/PP9uma+c8UEj+JblL2L
         Y4hqRsXqU827yM6e5CMH0eYNQYt0NvbOF0LKiBVipARrOHMVFXDO34DYv5+eJaxHOVdA
         0j7G/GcqYlKyA4zYcGXn4hRDcwCr1cHpTBk5i1r7vkv+a9lANbPsJ40zjeCVl6KGLQfR
         TVc0+kpDMoHyIWBJV0X+XQgtx4frtQRAlLdiNI1BQMhkGMaTS2MODOqURzJJGq8cG08T
         iiUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tm/K50OJfMDqvas0Rf7rVVrtqGgJ4S3T0B2gTD2W/r0=;
        b=BZzn22prMyFd1eEMXcQiRR+2eWdpoRb4lRudnN+bO4aPLfYlshWMJ/TKTF1A3H36x/
         9ZINGYjq1wo1qIouQt2FS2/OlL1us/nHslV4Wgl6UNGlIgwrNLGnE+xpQ8HD22KEYyPn
         2fnlfqdR86u+sNfUI87sMPwdWouRC+uy9by9XmZje4xE88dTJN4HxBSlfsS2lU7Vb/TP
         fgSGCGgpcii6EHq56P9u38HiTQDHWPcwYNiLO027oMkLdMLZ6IAVMWZ5th4/A5tlD9RG
         HevlsxxscYlyDh1D/ZU6WTa1ARPtvLi8L+yGVznnRIDfoG1x2ZozYMRLvt9SYOE5NsSQ
         JyrA==
X-Gm-Message-State: ACrzQf2Oz1QgFEXgMmb87i7Td0Sd6vCkH8JQmaKsQUz29Pi/g/4Lpb2M
        dlaChkqgFdSIkq8kGoWvspo7LFkWJc74f29pq98=
X-Google-Smtp-Source: AMsMyM6hdIoMLmPv73ACOFQWHxBY773cI2jgY43vuEbndHlpf8UcNVPZxnSJNjEHNLBrlKGx074iR/yAZ4mup0IerFg=
X-Received: by 2002:a17:906:4fc3:b0:72e:eab4:d9d7 with SMTP id
 i3-20020a1709064fc300b0072eeab4d9d7mr51523692ejw.599.1667911461203; Tue, 08
 Nov 2022 04:44:21 -0800 (PST)
MIME-Version: 1.0
References: <20221108054954.307554-1-xiubli@redhat.com> <CAOi1vP8C20dU+jNqLw92N20mOyAecZWeK4QOX4WD=e-GZBb32Q@mail.gmail.com>
 <8ba8c0bc-28b6-590e-7b77-b805ee7ae8f6@redhat.com>
In-Reply-To: <8ba8c0bc-28b6-590e-7b77-b805ee7ae8f6@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 8 Nov 2022 13:44:09 +0100
Message-ID: <CAOi1vP-WCc2sixM3hAQGGwtuCL6OhO9Etn6sdPp-uar5q2WN=A@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix NULL pointer dereference for req->r_session
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

On Tue, Nov 8, 2022 at 1:38 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 08/11/2022 18:50, Ilya Dryomov wrote:
> > On Tue, Nov 8, 2022 at 6:50 AM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> The request's r_session maybe changed when it was forwarded or
> >> resent.
> >>
> >> Cc: stable@vger.kernel.org
> >> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/caps.c | 88 +++++++++++++++++++-------------------------------
> >>   1 file changed, 33 insertions(+), 55 deletions(-)
> >>
> >> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> >> index 894adfb4a092..172f18f7459d 100644
> >> --- a/fs/ceph/caps.c
> >> +++ b/fs/ceph/caps.c
> >> @@ -2297,8 +2297,9 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
> >>          struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> >>          struct ceph_inode_info *ci = ceph_inode(inode);
> >>          struct ceph_mds_request *req1 = NULL, *req2 = NULL;
> >> +       struct ceph_mds_session *s, **sessions = NULL;
> > Hi Xiubo,
> >
> > Nit: mixing pointers and double pointers coupled with differing
> > initialization is generally frowned upon.  Keep it on two lines as
> > before:
> >
> >      struct ceph_mds_session **sessions = NULL;
> >      struct ceph_mds_session *s;
>
> Sure, will fix it.
>
> >>          unsigned int max_sessions;
> >> -       int ret, err = 0;
> >> +       int i, ret, err = 0;
> >>
> >>          spin_lock(&ci->i_unsafe_lock);
> >>          if (S_ISDIR(inode->i_mode) && !list_empty(&ci->i_unsafe_dirops)) {
> >> @@ -2315,31 +2316,22 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
> >> +       mutex_lock(&mdsc->mutex);
> >> +       max_sessions = mdsc->max_sessions;
> >> +       sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
> >> +       if (!sessions) {
> >> +               mutex_unlock(&mdsc->mutex);
> >> +               err = -ENOMEM;
> >> +               goto out;
> >> +       }
> >> +
> >>          if ((req1 || req2) && likely(max_sessions)) {
> > Just curious, when can max_sessions be zero here?
>
> Checked the code again, just before registering the first session, and
> this is monotone increasing. It should be safe to remove this here.
>
>
> >
> >> -               struct ceph_mds_session **sessions = NULL;
> >> -               struct ceph_mds_session *s;
> >>                  struct ceph_mds_request *req;
> >> -               int i;
> >> -
> >> -               sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
> >> -               if (!sessions) {
> >> -                       err = -ENOMEM;
> >> -                       goto out;
> >> -               }
> >>
> >>                  spin_lock(&ci->i_unsafe_lock);
> >>                  if (req1) {
> >> @@ -2348,16 +2340,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
> >>                                  s = req->r_session;
> >>                                  if (!s)
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
> >> +                               if (unlikely(s->s_mds >= max_sessions))
> >> +                                       continue;
> > Nit: this could be combined with the previous condition:
> >
> >      if (!s || unlikely(s->s_mds >= max_sessions))
> >              continue;
>
> Sure.
>
>
> >>                                  if (!sessions[s->s_mds]) {
> >>                                          s = ceph_get_mds_session(s);
> >>                                          sessions[s->s_mds] = s;
> >> @@ -2370,16 +2354,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
> >>                                  s = req->r_session;
> >>                                  if (!s)
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
> >> +                               if (unlikely(s->s_mds >= max_sessions))
> >> +                                       continue;
> > ditto
> >
> >>                                  if (!sessions[s->s_mds]) {
> >>                                          s = ceph_get_mds_session(s);
> >>                                          sessions[s->s_mds] = s;
> >> @@ -2387,25 +2363,26 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
> >>                          }
> >>                  }
> >>                  spin_unlock(&ci->i_unsafe_lock);
> >> +       }
> >> +       mutex_unlock(&mdsc->mutex);
> >>
> >> -               /* the auth MDS */
> >> -               spin_lock(&ci->i_ceph_lock);
> >> -               if (ci->i_auth_cap) {
> >> -                     s = ci->i_auth_cap->session;
> >> -                     if (!sessions[s->s_mds])
> >> -                             sessions[s->s_mds] = ceph_get_mds_session(s);
> >> -               }
> >> -               spin_unlock(&ci->i_ceph_lock);
> >> +       /* the auth MDS */
> >> +       spin_lock(&ci->i_ceph_lock);
> > Why was this "auth MDS" block moved outside of max_sessions > 0
> > branch?  Logically, it very much belongs there.  Is there a problem
> > with taking ci->i_ceph_lock under mdsc->mutex?
>
> I will remove the 'likely(max_session)' and there is no any problem for
> this.
>
> >
> >> +       if (ci->i_auth_cap) {
> >> +               s = ci->i_auth_cap->session;
> >> +               if (!sessions[s->s_mds] &&
> >> +                   likely(s->s_mds < max_sessions))
> > This is wrong: s->s_mds must be checked against max_sessions before
> > indexing into sessions array.  Also, the entire condition should fit on
> > a single line.
> I am moving it to the if(req1 || req2) {} scope and it will exceed 80
> chars. And will keep it in two lines.

If you are removing max_session > 0 condition, I don't see a need to
move this to "if (req1 || req2)" scope.  I suggested that only because
existing code was explicitly guarding against max_session == 0.

Thanks,

                Ilya
