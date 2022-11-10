Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EA7624392
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 14:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiKJNtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 08:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiKJNtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 08:49:00 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD036178A4;
        Thu, 10 Nov 2022 05:48:37 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id 13so5147391ejn.3;
        Thu, 10 Nov 2022 05:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zWD7xQ1ZBNW7LqeVLIITdMwN5Fl/BN1ePxWzb72P0kw=;
        b=M6JZKta52LWnQB8uUwDLsG2qe1akDDjZheSCrPtIfaH6erXYtWNPGzrkZyFrUSdbNO
         hqv+I5z+GsMDLmQJuD/naNZH4z7OIKWUo+q6HadPYzEaR1iKEGEf4fMoJK1gdokXgeNi
         LwOmzgZl567PL19GNMLYGEAuqxtVgK2OdXlFtSqPM6PIHacXvsxcQpQ2s7mq3Wjbsb1G
         FH1T6YyZ3HS4ripKFe5WMBYteqIBXtQUjxxCzxjx1NgzekVXNhlXxuA6ezPHh1ADI4i2
         MTsdZKxoLsNdV29l2Q1cPrkg9rRh4qxJfPWAMWoyD3Q7+V5/2rmYTqVaXXLY5ugsOlu4
         mA/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zWD7xQ1ZBNW7LqeVLIITdMwN5Fl/BN1ePxWzb72P0kw=;
        b=MORdA6ewum0GWaM9/c/EC1afJh3BJJLHINFT6CpjbakxCBYwrnvJF0KaH+CHHidQlR
         MtAZUPFmMojSU5+nvs5247TH6y+PGJGRI6UGeIaB6MpalATumZUOpV1D2avJf2rrtDjW
         CPQrJxJeNHX8UoRIeNk4vgszAjQ1i5dMmvf497v4f9BJvD7ffd0BNB/EleDnXcKUVlmc
         9QVgKMOjKtH8zUT0uhQsa1KU5wySoyhs4aHcSH1CSRj/0osDIMZDKV31SmV6uKbsEMwi
         /CF2lj0LHCTbU3q1i49XjDR2GO90CfZa1kN/COWzrDRInBVyjFBzcuqmu4BkESIFxJJQ
         XAiw==
X-Gm-Message-State: ACrzQf3x54mWmb/03Cn2aH3f5Ae97q51wbZKKl0DO8ZkZnzSNJj4DCdU
        /Z6g5x38o9qJd3ZS2boAvm7f7B0dwmxJ9JD92rbKE8BF4Hg=
X-Google-Smtp-Source: AMsMyM75YF0qLvEnFg0pKREUN463PjuQ+w8BgJdhZHh94GNnzp4aeTaHdWSx0UhDcM74vEYNm7tdLGM0nb4V1UkTggk=
X-Received: by 2002:a17:906:e83:b0:7ae:c0c:210b with SMTP id
 p3-20020a1709060e8300b007ae0c0c210bmr36799729ejf.523.1668088116237; Thu, 10
 Nov 2022 05:48:36 -0800 (PST)
MIME-Version: 1.0
References: <20221110130159.33319-1-xiubli@redhat.com>
In-Reply-To: <20221110130159.33319-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 10 Nov 2022 14:48:23 +0100
Message-ID: <CAOi1vP-Evz+q7XU2EKNRaqCWOVHm8pm0WVp6No21=q55tDdGag@mail.gmail.com>
Subject: Re: [PATCH v5] ceph: fix NULL pointer dereference for req->r_session
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

On Thu, Nov 10, 2022 at 2:02 PM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The request's r_session maybe changed when it was forwarded or
> resent. Both the forwarding and resending cases the requests will
> be protected by the mdsc->mutex.
>
> Cc: stable@vger.kernel.org
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> Changed in V5:
> - simplify the code by removing the "unlikely(s->s_mds >= max_sessions)" check.
>
> Changed in V4:
> - move mdsc->mutex acquisition and max_sessions assignment into "if (req1 || req2)" branch
>
>
>
>  fs/ceph/caps.c | 48 ++++++++++++------------------------------------
>  1 file changed, 12 insertions(+), 36 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 894adfb4a092..065e9311b607 100644
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
> @@ -2348,16 +2343,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
>                                 if (!sessions[s->s_mds]) {
>                                         s = ceph_get_mds_session(s);
>                                         sessions[s->s_mds] = s;
> @@ -2370,16 +2355,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
>                                 if (!sessions[s->s_mds]) {
>                                         s = ceph_get_mds_session(s);
>                                         sessions[s->s_mds] = s;
> @@ -2391,11 +2366,12 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>                 /* the auth MDS */
>                 spin_lock(&ci->i_ceph_lock);
>                 if (ci->i_auth_cap) {
> -                     s = ci->i_auth_cap->session;
> -                     if (!sessions[s->s_mds])
> -                             sessions[s->s_mds] = ceph_get_mds_session(s);
> +                       s = ci->i_auth_cap->session;
> +                       if (!sessions[s->s_mds])
> +                               sessions[s->s_mds] = ceph_get_mds_session(s);
>                 }
>                 spin_unlock(&ci->i_ceph_lock);
> +               mutex_unlock(&mdsc->mutex);
>
>                 /* send flush mdlog request to MDSes */
>                 for (i = 0; i < max_sessions; i++) {
> --
> 2.31.1
>

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
