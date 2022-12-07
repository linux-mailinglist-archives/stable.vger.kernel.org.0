Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A51E64586D
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 12:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiLGLAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 06:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiLGK7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 05:59:54 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF02026110;
        Wed,  7 Dec 2022 02:59:42 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id fc4so12996619ejc.12;
        Wed, 07 Dec 2022 02:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YpIqHrgvxTLKNNK8z3Ar4IvFrm3QLjxZp/LOYj8IOoc=;
        b=KSNFaDV1vgRRim2gV0rHtxasBC0chH1qPAHlD4wuZ+w0VePySVosYbaptSu9DRfg6R
         dhUUOp9ZfgPUi4PJmGDiXPRGymLPc7ZlejWluSDqRNXldnn2IIm7AVO33nPX3CtfH7wF
         r8SFW96g5a1/ChSP488pdCAO5l9jeBgmSSX6z31I8n3iCxFsbTOw0v9ff3DPQfyKbBaj
         kpZ24TELyJ1AROJZvdAenBo6gO4Q1s4G641GrZsyneaQP619A1UvClhDc9Ww+m9acwN6
         FgX6ZXQk78O3Q/13Ow15zN9GAo4YnqwlEgICloYqB9sgr+6wJ83ua85b9bV23BuchxF6
         LXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YpIqHrgvxTLKNNK8z3Ar4IvFrm3QLjxZp/LOYj8IOoc=;
        b=WDGJFxkgV24UKyFL4d3xfzxW/gMM1b+xSFaUWgkN/n1f0f5TekEI+yb5gJybX3Otgf
         v2PJ8HTPJEYM5PfJOVUI8pRUgIETGTJlqlF3QyEnjHHWf99Y4JLgB9kFVHufnaoeSRIs
         a+riRWYMfImflEaRGBXasfT1BiltSk6+6WUdLmwrKkx/xJQPcNCCo+Tm6kydu5yrw/sX
         jr9NlJlj4DxlNybJGkt+eQBr1+YE9rqdNXkfvNN0ONlKsbGwinxMfN+4/zIsiI/CtCY3
         TC+dLj1ofetfMZV81XF+eLPYxXxM1ZF3gpW7l4mJz9fd6wjpiNe0Z7nWYaQ/A9JlDW4o
         ad+g==
X-Gm-Message-State: ANoB5pm3qrEil5smk5OZHmyeE+S+36FwptTchJJukHoBKWmA/eI0w50+
        zgzPgDxTNKd3/N2sleD7m0uYyxRPub41h3aNcK4=
X-Google-Smtp-Source: AA0mqf6aF3yZMYYwmZD4gObv9ldYDfAeF7BalEpxLadXLyDuKJtKCpmtoOhYzl25RSmfHwwRzLX0ctABZfXazPYs+Y4=
X-Received: by 2002:a17:906:3b42:b0:7c0:c220:a341 with SMTP id
 h2-20020a1709063b4200b007c0c220a341mr18026577ejf.569.1670410781367; Wed, 07
 Dec 2022 02:59:41 -0800 (PST)
MIME-Version: 1.0
References: <20221206125915.37404-1-xiubli@redhat.com>
In-Reply-To: <20221206125915.37404-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 7 Dec 2022 11:59:29 +0100
Message-ID: <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, atomlin@atomlin.com, stable@vger.kernel.org
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

On Tue, Dec 6, 2022 at 1:59 PM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When received corrupted snap trace we don't know what exactly has
> happened in MDS side. And we shouldn't continue writing to OSD,
> which may corrupt the snapshot contents.
>
> Just try to blocklist this client and If fails we need to crash the
> client instead of leaving it writeable to OSDs.
>
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/57686
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> Thanks Aaron's feedback.
>
> V3:
> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
>
> V2:
> - Switched to WARN() to taint the Linux kernel.
>
>  fs/ceph/mds_client.c |  3 ++-
>  fs/ceph/mds_client.h |  1 +
>  fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
>  3 files changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index cbbaf334b6b8..59094944af28 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct ceph_connection *con)
>         struct ceph_mds_client *mdsc = s->s_mdsc;
>
>         pr_warn("mds%d closed our session\n", s->s_mds);
> -       send_mds_reconnect(mdsc, s);
> +       if (!mdsc->no_reconnect)
> +               send_mds_reconnect(mdsc, s);
>  }
>
>  static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 728b7d72bf76..8e8f0447c0ad 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -413,6 +413,7 @@ struct ceph_mds_client {
>         atomic_t                num_sessions;
>         int                     max_sessions;  /* len of sessions array */
>         int                     stopping;      /* true if shutting down */
> +       int                     no_reconnect;  /* true if snap trace is corrupted */
>
>         atomic64_t              quotarealms_count; /* # realms with quota */
>         /*
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index c1c452afa84d..023852b7c527 100644
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
> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>         if (first_realm)
>                 ceph_put_snap_realm(mdsc, first_realm);
>         pr_err("%s error %d\n", __func__, err);
> +
> +       /*
> +        * When receiving a corrupted snap trace we don't know what
> +        * exactly has happened in MDS side. And we shouldn't continue
> +        * writing to OSD, which may corrupt the snapshot contents.
> +        *
> +        * Just try to blocklist this kclient and if it fails we need
> +        * to crash the kclient instead of leaving it writeable.

Hi Xiubo,

I'm not sure I understand this "let's blocklist ourselves" concept.
If the kernel client shouldn't continue writing to OSDs in this case,
why not just stop issuing writes -- perhaps initiating some equivalent
of a read-only remount like many local filesystems would do on I/O
errors (e.g. errors=remount-ro mode)?

Or, perhaps, all in-memory snap contexts could somehow be invalidated
in this case, making writes fail naturally -- on the client side,
without actually being sent to OSDs just to be nixed by the blocklist
hammer.

But further, what makes a failure to decode a snap trace special?
AFAIK we don't do anything close to this for any other decoding
failure.  Wouldn't "when received corrupted XYZ we don't know what
exactly has happened in MDS side" argument apply to pretty much all
decoding failures?

> +        *
> +        * Then this kclient must be remounted to continue after the
> +        * corrupted metadata fixed in the MDS side.
> +        */
> +       mdsc->no_reconnect = 1;
> +       ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
> +       if (ret) {
> +               pr_err("%s blocklist of %s failed: %d", __func__,
> +                      ceph_pr_addr(&client->msgr.inst.addr), ret);
> +               BUG();

... and this is a rough equivalent of errors=panic mode.

Is there a corresponding userspace client PR that can be referenced?
This needs additional background and justification IMO.

Thanks,

                Ilya
