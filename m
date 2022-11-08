Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1B0620DBB
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 11:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiKHKu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 05:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiKHKum (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 05:50:42 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E6F43863;
        Tue,  8 Nov 2022 02:50:37 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id kt23so37464380ejc.7;
        Tue, 08 Nov 2022 02:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UrLKP3UiO1uMTLoB7GA8QoDhrr0O6Yze6wD2/gHgWJM=;
        b=mCB3vyrCeq1gZDIEyDN9sfaW2DyFwB0PA8CxQ9Yi9ipvZD45cze/fnccuO40/FJThr
         fU80WDh3ula4rOHqYKKVrtkDpYWJuV4u9rjGnFuKR6aP4zYfl1SUiOJ++7Nkt5CL2Rgc
         LKCojqUIAbVPlgZBgw6LGVF2TEE4NRFDDf7N+ZRoboY9CS/2R2CZdKsS6Wo+JMqiRkdR
         qoqfePe/PSzQ0cfU+hMDLpWck9gjf7W/SFT26vIYFiY+d/bdWL+OFn+kU2u7nuSYDIak
         xB88S5rGe3XCOfEjyWdYVNafLK2ehXKwRTYoDPJJyWraoZ/NRT0thtXZDd5ON1CygBvF
         DDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UrLKP3UiO1uMTLoB7GA8QoDhrr0O6Yze6wD2/gHgWJM=;
        b=CIFbARwpBsQOjm2c42X+ItPET2fc+9tAxFTijUMaa+VKPBGssCZsl3/qFMMhNE9RnB
         jA9DPpNbYfyMEUsYL8/23qiVu/ucmsHk/O4IsXaK/ElYvkEM34yaSZB/8mgeXgLdZ2Wp
         /2u7ptdl+nTtF0fksubPox2xhKk8LLer+HDvpKheE8Ra1Lb6XLxXRbf2skDPW5bJwYvH
         yNS1nfODSv+5jTwXgyPTFkieD/VUknh0M6hDey//4j/SNOSgXMs8268wllqJP7gdNFh+
         VYLWou1Q8NbYvSpGJCgRzHBHKuYAyhyPnUcNX6vHwCtIE1SNdxGkQvsOKdHn4903PDVP
         XIzQ==
X-Gm-Message-State: ACrzQf2horqc2detHReVQ21g2AhNwvaYtACXdI342SRcf0yM7MvVtX+G
        t6NvqcugDuJ9PARWjo4MHtYYZ/fz2T6LRfFffck=
X-Google-Smtp-Source: AMsMyM7GgOMtLKwEwIHZq3zYZFWouJr5ynVovUvXC8rDf6q9UR8HXBowK2vdLrBkFOwxgSN1xmUPZfcsvaR43HLLK/0=
X-Received: by 2002:a17:906:4fc3:b0:72e:eab4:d9d7 with SMTP id
 i3-20020a1709064fc300b0072eeab4d9d7mr51090798ejw.599.1667904636290; Tue, 08
 Nov 2022 02:50:36 -0800 (PST)
MIME-Version: 1.0
References: <20221108054954.307554-1-xiubli@redhat.com>
In-Reply-To: <20221108054954.307554-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 8 Nov 2022 11:50:24 +0100
Message-ID: <CAOi1vP8C20dU+jNqLw92N20mOyAecZWeK4QOX4WD=e-GZBb32Q@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix NULL pointer dereference for req->r_session
To:     xiubli@redhat.com
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

On Tue, Nov 8, 2022 at 6:50 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The request's r_session maybe changed when it was forwarded or
> resent.
>
> Cc: stable@vger.kernel.org
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 88 +++++++++++++++++++-------------------------------
>  1 file changed, 33 insertions(+), 55 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 894adfb4a092..172f18f7459d 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2297,8 +2297,9 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>         struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         struct ceph_mds_request *req1 = NULL, *req2 = NULL;
> +       struct ceph_mds_session *s, **sessions = NULL;

Hi Xiubo,

Nit: mixing pointers and double pointers coupled with differing
initialization is generally frowned upon.  Keep it on two lines as
before:

    struct ceph_mds_session **sessions = NULL;
    struct ceph_mds_session *s;

>         unsigned int max_sessions;
> -       int ret, err = 0;
> +       int i, ret, err = 0;
>
>         spin_lock(&ci->i_unsafe_lock);
>         if (S_ISDIR(inode->i_mode) && !list_empty(&ci->i_unsafe_dirops)) {
> @@ -2315,31 +2316,22 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>         }
>         spin_unlock(&ci->i_unsafe_lock);
>
> -       /*
> -        * The mdsc->max_sessions is unlikely to be changed
> -        * mostly, here we will retry it by reallocating the
> -        * sessions array memory to get rid of the mdsc->mutex
> -        * lock.
> -        */
> -retry:
> -       max_sessions = mdsc->max_sessions;
> -
>         /*
>          * Trigger to flush the journal logs in all the relevant MDSes
>          * manually, or in the worst case we must wait at most 5 seconds
>          * to wait the journal logs to be flushed by the MDSes periodically.
>          */
> +       mutex_lock(&mdsc->mutex);
> +       max_sessions = mdsc->max_sessions;
> +       sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
> +       if (!sessions) {
> +               mutex_unlock(&mdsc->mutex);
> +               err = -ENOMEM;
> +               goto out;
> +       }
> +
>         if ((req1 || req2) && likely(max_sessions)) {

Just curious, when can max_sessions be zero here?

> -               struct ceph_mds_session **sessions = NULL;
> -               struct ceph_mds_session *s;
>                 struct ceph_mds_request *req;
> -               int i;
> -
> -               sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
> -               if (!sessions) {
> -                       err = -ENOMEM;
> -                       goto out;
> -               }
>
>                 spin_lock(&ci->i_unsafe_lock);
>                 if (req1) {
> @@ -2348,16 +2340,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>                                 s = req->r_session;
>                                 if (!s)
>                                         continue;
> -                               if (unlikely(s->s_mds >= max_sessions)) {
> -                                       spin_unlock(&ci->i_unsafe_lock);
> -                                       for (i = 0; i < max_sessions; i++) {
> -                                               s = sessions[i];
> -                                               if (s)
> -                                                       ceph_put_mds_session(s);
> -                                       }
> -                                       kfree(sessions);
> -                                       goto retry;
> -                               }
> +                               if (unlikely(s->s_mds >= max_sessions))
> +                                       continue;

Nit: this could be combined with the previous condition:

    if (!s || unlikely(s->s_mds >= max_sessions))
            continue;

>                                 if (!sessions[s->s_mds]) {
>                                         s = ceph_get_mds_session(s);
>                                         sessions[s->s_mds] = s;
> @@ -2370,16 +2354,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>                                 s = req->r_session;
>                                 if (!s)
>                                         continue;
> -                               if (unlikely(s->s_mds >= max_sessions)) {
> -                                       spin_unlock(&ci->i_unsafe_lock);
> -                                       for (i = 0; i < max_sessions; i++) {
> -                                               s = sessions[i];
> -                                               if (s)
> -                                                       ceph_put_mds_session(s);
> -                                       }
> -                                       kfree(sessions);
> -                                       goto retry;
> -                               }
> +                               if (unlikely(s->s_mds >= max_sessions))
> +                                       continue;

ditto

>                                 if (!sessions[s->s_mds]) {
>                                         s = ceph_get_mds_session(s);
>                                         sessions[s->s_mds] = s;
> @@ -2387,25 +2363,26 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>                         }
>                 }
>                 spin_unlock(&ci->i_unsafe_lock);
> +       }
> +       mutex_unlock(&mdsc->mutex);
>
> -               /* the auth MDS */
> -               spin_lock(&ci->i_ceph_lock);
> -               if (ci->i_auth_cap) {
> -                     s = ci->i_auth_cap->session;
> -                     if (!sessions[s->s_mds])
> -                             sessions[s->s_mds] = ceph_get_mds_session(s);
> -               }
> -               spin_unlock(&ci->i_ceph_lock);
> +       /* the auth MDS */
> +       spin_lock(&ci->i_ceph_lock);

Why was this "auth MDS" block moved outside of max_sessions > 0
branch?  Logically, it very much belongs there.  Is there a problem
with taking ci->i_ceph_lock under mdsc->mutex?

> +       if (ci->i_auth_cap) {
> +               s = ci->i_auth_cap->session;
> +               if (!sessions[s->s_mds] &&
> +                   likely(s->s_mds < max_sessions))

This is wrong: s->s_mds must be checked against max_sessions before
indexing into sessions array.  Also, the entire condition should fit on
a single line.

> +                       sessions[s->s_mds] = ceph_get_mds_session(s);
> +       }
> +       spin_unlock(&ci->i_ceph_lock);
>
> -               /* send flush mdlog request to MDSes */
> -               for (i = 0; i < max_sessions; i++) {
> -                       s = sessions[i];
> -                       if (s) {
> -                               send_flush_mdlog(s);
> -                               ceph_put_mds_session(s);
> -                       }
> +       /* send flush mdlog request to MDSes */
> +       for (i = 0; i < max_sessions; i++) {
> +               s = sessions[i];
> +               if (s) {
> +                       send_flush_mdlog(s);
> +                       ceph_put_mds_session(s);
>                 }
> -               kfree(sessions);
>         }
>
>         dout("%s %p wait on tid %llu %llu\n", __func__,
> @@ -2428,6 +2405,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>                 ceph_mdsc_put_request(req1);
>         if (req2)
>                 ceph_mdsc_put_request(req2);
> +       kfree(sessions);

Nit: since sessions array is allocated after references to req1 and
req2 are grabbed, I would free it before these references are put.

Thanks,

                Ilya
