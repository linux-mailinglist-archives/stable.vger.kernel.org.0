Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2094C6241C1
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 12:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiKJLtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 06:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKJLtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 06:49:20 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7545570542;
        Thu, 10 Nov 2022 03:49:19 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id 13so4359640ejn.3;
        Thu, 10 Nov 2022 03:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Oxk2AV8+FhBOGroCEWRLPEZUBblVi7YSrra9hiMhDuc=;
        b=BzUM/uBULqYF4lAvJofEpsuCEO1dVz0vJT12o2or5Un9WWwg6xf4NdR6jNHjXi/rqv
         75RNhh6mkwhIG2anyIJcl/JpsVPoFypOZAK6OM/F7f53Aj+3SOwkAl0y4T8yQyR7DoE8
         LY3nLO4VT0XZ0R562LvfeH9gjdKpkWTyva3wL1hJAUK7qqQYOZlmzqoU8+3GKbX6MOzN
         urptqRL9xrwjfMBz6VJUbBiqm7kEwacjpVHSO3gaFWQE6ScSuars3eU4a/7LrhLH99ph
         EQkMOibsO5qUb1l8Kw/Ju0hFP90+iIliEDPWO7NLXHfo47BDlbzR9W3tWt+LxSJdX+sD
         ZdCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oxk2AV8+FhBOGroCEWRLPEZUBblVi7YSrra9hiMhDuc=;
        b=Ig+41MxQPmIk3D4n2bsyUt9WOAqC15/8UMhPGdr1EFhROJ0NDQeiY6HpirZTBmphNA
         9WmSq1dmX6bWUoiE9P1dGrjn8pZuKHTBwI9opC+VlQY+DeixKA8MPe3wGA8s20qi4Dis
         jBHREGwmfxHO8WFOh3pwFuqAu2+elbAbc559lyBIyzZj0NVC20mp47DCeq+g+kSzM2bR
         P08s1TmhXn1hE2AHUpmIzPeFuZgh/c/cmRjOVxSWOoJImcDwGJIVQG8cfjhkTClamK+W
         Xl3wqSFLsGMArP5nfa5ZvKyn6q7pXP3wjg3p8dm+ewEaU0Pwl22gTjG56f6Z5X+queC+
         CNRg==
X-Gm-Message-State: ACrzQf1Q50VAw31RdVyYGYUI4GjQtlhSliOB3ETrTdXy1E8y9lIcNYw4
        qGgF9+kUoqTnockeqY1hi8NMSvMy5ta9/RnT0ks=
X-Google-Smtp-Source: AMsMyM5nMfMTxYoYbUC3Tq2BPBFebscncPbDQfPBdv4GGxfIwkVYTbyiY3ITGSzImVUszRjomL+YDTTO7L+TCkWFDQU=
X-Received: by 2002:a17:906:ee8e:b0:730:4a24:f311 with SMTP id
 wt14-20020a170906ee8e00b007304a24f311mr60330140ejb.420.1668080957978; Thu, 10
 Nov 2022 03:49:17 -0800 (PST)
MIME-Version: 1.0
References: <20221110020828.1899393-1-xiubli@redhat.com>
In-Reply-To: <20221110020828.1899393-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 10 Nov 2022 12:49:05 +0100
Message-ID: <CAOi1vP9CtZdJ7tx4-WHhiHxB4WPqx-i6EjXwMHCOeBcxMxAndA@mail.gmail.com>
Subject: Re: [PATCH v4] ceph: fix NULL pointer dereference for req->r_session
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

On Thu, Nov 10, 2022 at 3:08 AM <xiubli@redhat.com> wrote:
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
>
> Changed in V4:
> - move mdsc->mutex acquisition and max_sessions assignment into "if (req1 || req2)" branch
>
>  fs/ceph/caps.c | 54 +++++++++++++++-----------------------------------
>  1 file changed, 16 insertions(+), 38 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 894adfb4a092..1c84be839087 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2297,7 +2297,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>         struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         struct ceph_mds_request *req1 = NULL, *req2 = NULL;
> -       unsigned int max_sessions;
>         int ret, err = 0;
>
>         spin_lock(&ci->i_unsafe_lock);
> @@ -2315,28 +2314,24 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
> +       if (req1 || req2) {
>                 struct ceph_mds_request *req;
> +               struct ceph_mds_session **sessions;
> +               struct ceph_mds_session *s;
> +               unsigned int max_sessions;
>                 int i;
>
> +               mutex_lock(&mdsc->mutex);
> +               max_sessions = mdsc->max_sessions;
> +
>                 sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
>                 if (!sessions) {
> +                       mutex_unlock(&mdsc->mutex);
>                         err = -ENOMEM;
>                         goto out;
>                 }
> @@ -2346,18 +2341,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>                         list_for_each_entry(req, &ci->i_unsafe_dirops,
>                                             r_unsafe_dir_item) {
>                                 s = req->r_session;
> -                               if (!s)
> +                               if (!s || unlikely(s->s_mds >= max_sessions))

Hi Xiubo,

I would be fine with this patch as is but I'm wondering if it can be
simplified further.  Now that mdsc->mutex is held while sessions array
is populated, is checking s->s_mds against max_sessions actually
needed?  Is it possible for some req->r_session on one of the unsafe
lists to have an "out of bounds" s_mds under mdsc->mutex?

Thanks,

                Ilya
