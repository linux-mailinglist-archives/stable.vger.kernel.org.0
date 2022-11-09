Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E50D622BF7
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiKIM4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiKIM4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:56:31 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2823175A9;
        Wed,  9 Nov 2022 04:56:28 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ft34so10055188ejc.12;
        Wed, 09 Nov 2022 04:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GoUB8OXMKKZeCPs9z7zz/Zo0jwCwKnOKqemNAor4VBU=;
        b=LyMmN+QdCYs1cNvEgWZ2eR5Z0CKHUFZ8YKUhiwDsS3X0j81cGYPDLDBBYdPjYNz/Eb
         Psg/J5z/goLbOpr1IYhX+lXm3TFCy/UIwamQcBrChIeHWd23PLkz0ZAJ46v6nMWIVwGN
         uFLQ+fKUNQJpZTAul86Zm5brxEPHMixaVJ8oeC8hhfsSM78hegXns4Hk7AL2QxnXcWzl
         lb7CPTxkvILlup+oNa+Kp6IB/7+Y1DA+luvwVVbea+KIhnSp/O1thjn4MJpvXzmt4QiB
         0u4Cqf9Sj+KGKR05Tdi4g2DDiXr0OV98NZ3QESrtreV4g6Kn4vWIhZaFW/mgKyXiCnQs
         TeoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GoUB8OXMKKZeCPs9z7zz/Zo0jwCwKnOKqemNAor4VBU=;
        b=rinMXSTHFJ9sO/3hXeqgEikAJ6fPWOfZMgYugqHmQoJJc616/6vFbCX+iwU4ayJN43
         jPetMfuFsuWYTyaPtMiNyC16nkNqIrTIYX2d/QphSqcYfBP1D/J8DeyEGJrQmuoh/QOz
         zTv2uOgOuTS8joSSJPytqasLAYuF69j4//vxn4tsySN4Nu+n7VEyvBb3JUEc8PQQJ8Dv
         bHMsgQvfk/wpfr7OfBKFJTl5HhH170tC44WdZL+dBj3V5gsE8WSJfk1OrCW/8m7BVlac
         fzgEcAkTqxqOWALMl8vBbZDiTiWcHSIhVPLIfxdulxnDO1iAbwtslVIr8L3LW8h9gzsA
         IvWA==
X-Gm-Message-State: ACrzQf0b1CQDi38IrxUtj5QJP2Qm8uU9Dh0hsWlGdefYsrNA1oSSd1bw
        TRRz4cmq34JWCgcn6tqug/XBzYhOzlhtnu3r/KA=
X-Google-Smtp-Source: AMsMyM68ba+KgL8sWboB6Gos+JbFZLczvZH8LJpOgLwI/mEUx1N1Rf2rWbE1mZEKU5daoSe/3fzFOQLyWkncMH6HQek=
X-Received: by 2002:a17:906:4fc3:b0:72e:eab4:d9d7 with SMTP id
 i3-20020a1709064fc300b0072eeab4d9d7mr55504159ejw.599.1667998587272; Wed, 09
 Nov 2022 04:56:27 -0800 (PST)
MIME-Version: 1.0
References: <20221108135554.558278-1-xiubli@redhat.com>
In-Reply-To: <20221108135554.558278-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 9 Nov 2022 13:56:15 +0100
Message-ID: <CAOi1vP8Fkzq542St9od7G_JnQyS93=BgLLRUE86-E-Zw4MEt3g@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: fix NULL pointer dereference for req->r_session
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

On Tue, Nov 8, 2022 at 2:56 PM <xiubli@redhat.com> wrote:
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
>  fs/ceph/caps.c | 60 ++++++++++++++++----------------------------------
>  1 file changed, 19 insertions(+), 41 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 894adfb4a092..83f9e18e3169 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2297,8 +2297,10 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>         struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         struct ceph_mds_request *req1 = NULL, *req2 = NULL;
> +       struct ceph_mds_session **sessions = NULL;
> +       struct ceph_mds_session *s;
>         unsigned int max_sessions;
> -       int ret, err = 0;
> +       int i, ret, err = 0;
>
>         spin_lock(&ci->i_unsafe_lock);
>         if (S_ISDIR(inode->i_mode) && !list_empty(&ci->i_unsafe_dirops)) {
> @@ -2315,28 +2317,19 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
> -       if ((req1 || req2) && likely(max_sessions)) {
> -               struct ceph_mds_session **sessions = NULL;
> -               struct ceph_mds_session *s;
> +       mutex_lock(&mdsc->mutex);
> +       max_sessions = mdsc->max_sessions;
> +       if (req1 || req2) {
>                 struct ceph_mds_request *req;
> -               int i;
>
>                 sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
>                 if (!sessions) {
> +                       mutex_unlock(&mdsc->mutex);
>                         err = -ENOMEM;
>                         goto out;
>                 }
> @@ -2346,18 +2339,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>                         list_for_each_entry(req, &ci->i_unsafe_dirops,
>                                             r_unsafe_dir_item) {
>                                 s = req->r_session;
> -                               if (!s)
> +                               if (!s || unlikely(s->s_mds >= max_sessions))
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
>                                 if (!sessions[s->s_mds]) {
>                                         s = ceph_get_mds_session(s);
>                                         sessions[s->s_mds] = s;
> @@ -2368,18 +2351,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>                         list_for_each_entry(req, &ci->i_unsafe_iops,
>                                             r_unsafe_target_item) {
>                                 s = req->r_session;
> -                               if (!s)
> +                               if (!s || unlikely(s->s_mds >= max_sessions))
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
>                                 if (!sessions[s->s_mds]) {
>                                         s = ceph_get_mds_session(s);
>                                         sessions[s->s_mds] = s;
> @@ -2391,13 +2364,18 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>                 /* the auth MDS */
>                 spin_lock(&ci->i_ceph_lock);
>                 if (ci->i_auth_cap) {
> -                     s = ci->i_auth_cap->session;
> -                     if (!sessions[s->s_mds])
> -                             sessions[s->s_mds] = ceph_get_mds_session(s);
> +                       s = ci->i_auth_cap->session;
> +                       if (likely(s->s_mds < max_sessions)
> +                           && !sessions[s->s_mds]) {

Hi Xiubo,

Nit: keep && on the previous line for style consistency.

> +                               sessions[s->s_mds] = ceph_get_mds_session(s);
> +                       }
>                 }
>                 spin_unlock(&ci->i_ceph_lock);
> +       }
> +       mutex_unlock(&mdsc->mutex);
>
> -               /* send flush mdlog request to MDSes */
> +       /* send flush mdlog request to MDSes */
> +       if (sessions) {

Since mdlog is flushed only in "if (req1 || req2)" case, why not keep
max_sessions loop there and avoid sessions != NULL check?

Then, you could also move mdsc->mutex acquisition and max_sessions
assignment into "if (req1 || req2)" branch and keep sessions, s and
i declarations where there are today.

Thanks,

                Ilya
