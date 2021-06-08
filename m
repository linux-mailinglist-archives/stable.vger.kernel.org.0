Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9A23A0313
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbhFHTM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:12:29 -0400
Received: from mail-il1-f182.google.com ([209.85.166.182]:44575 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237662AbhFHTKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 15:10:13 -0400
Received: by mail-il1-f182.google.com with SMTP id i17so20715888ilj.11;
        Tue, 08 Jun 2021 12:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r1xlspWinCBxxSlZ757oy9UT6WlwH21EloJvL59lff4=;
        b=RmHSuuXM5RuW5lsjCFArOIVNU2gBGb3ZDdSS8/HSdXbeUZG7/ZvzdjSfofVOpDl7O2
         OfSgKhLJR97cKJECKY+uhZvC4zd5pfEN9cf1Mv8HsTrJLzaUldmCNH7jrsz3jZKxTOe+
         qARod1NzBSyB/CAF4rNrN5vjoc1+UHqklfl9r/NTmxw7CBVX9kLo1knAKfLdg0rYHb43
         DacTu3Z5aezL3HmNIJkQKI4DsmgGD0R2jvD/ZKtMrKmdr+tQYuXsz1QG6xtMXf7qhph/
         /XIWKBFfRANmxXSLK7eWcKQLxXfkyPkvwOTIa+A5mnHhc0GdmUcshsLGvVgR5XXsiXag
         BLuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r1xlspWinCBxxSlZ757oy9UT6WlwH21EloJvL59lff4=;
        b=OwHzFHrR3d/owReeroRGKlBbUT1Vx6OXFvNo/FoHZszT4l62F3eY0UwhBeL9yx2Ih4
         VDnQGIKYT91c+U4dLGptqWKmqnr2Ohfi9y7I3QVfJl4NO0nCBa5ThQswAyoASCa5SCln
         rZPHJNiLlJmrXIEV7hLbhl1xg9i1cv3kczwdJI+4gMnhwSO4JBR/FLDjoIgpgx6yMSU0
         SasnDuie73ZiyGTErXewwEE94kJT7wRv0QtFHyz+IFAarduxs20eclQt3z5crL/XTCp9
         35+z4xBxRZ8pyXhifNnRMn5WqG6sHQAO5MSCBY7IP6lqtMcL1x2FZe64y3HI5jHtZNWL
         cbAg==
X-Gm-Message-State: AOAM532ftzlDSs8nOo5l/pKHi6Yk9SgdzjTESOwxNbbaegFllSayV1zH
        UBkggbqkY5IHS8/9WcAuv2NlZR+lmNcCQGBwhxoro6Zdpdpk7A==
X-Google-Smtp-Source: ABdhPJzgd/pnBYOgBAeO5gpFCqQgwKGSVlnKsCBCdZPcxiUhbw8ZCkc9GUhkTnrDn04Yf8yAnnM8N6ACKZlpcbA34ks=
X-Received: by 2002:a92:7b01:: with SMTP id w1mr21291347ilc.100.1623179240094;
 Tue, 08 Jun 2021 12:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210608175945.476074951@linuxfoundation.org> <20210608175948.243493420@linuxfoundation.org>
In-Reply-To: <20210608175948.243493420@linuxfoundation.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 8 Jun 2021 21:07:18 +0200
Message-ID: <CAOi1vP-B4A4bmd=ZbnwqEa14BizN-X8V4ktUMWGuEtXu8n2y-g@mail.gmail.com>
Subject: Re: [PATCH 5.12 083/161] libceph: dont set global_id until we get an
 auth ticket
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Sage Weil <sage@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 8, 2021 at 8:48 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Ilya Dryomov <idryomov@gmail.com>
>
> [ Upstream commit 61ca49a9105faefa003b37542cebad8722f8ae22 ]
>
> With the introduction of enforcing mode, setting global_id as soon
> as we get it in the first MAuth reply will result in EACCES if the
> connection is reset before we get the second MAuth reply containing
> an auth ticket -- because on retry we would attempt to reclaim that
> global_id with no auth ticket at hand.
>
> Neither ceph_auth_client nor ceph_mon_client depend on global_id
> being set ealy, so just delay the setting until we get and process
> the second MAuth reply.  While at it, complain if the monitor sends
> a zero global_id or changes our global_id as the session is likely
> to fail after that.
>
> Cc: stable@vger.kernel.org # needs backporting for < 5.11
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> Reviewed-by: Sage Weil <sage@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/ceph/auth.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/net/ceph/auth.c b/net/ceph/auth.c
> index eb261aa5fe18..de407e8feb97 100644
> --- a/net/ceph/auth.c
> +++ b/net/ceph/auth.c
> @@ -36,6 +36,20 @@ static int init_protocol(struct ceph_auth_client *ac, int proto)
>         }
>  }
>
> +static void set_global_id(struct ceph_auth_client *ac, u64 global_id)
> +{
> +       dout("%s global_id %llu\n", __func__, global_id);
> +
> +       if (!global_id)
> +               pr_err("got zero global_id\n");
> +
> +       if (ac->global_id && global_id != ac->global_id)
> +               pr_err("global_id changed from %llu to %llu\n", ac->global_id,
> +                      global_id);
> +
> +       ac->global_id = global_id;
> +}
> +
>  /*
>   * setup, teardown.
>   */
> @@ -222,11 +236,6 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
>
>         payload_end = payload + payload_len;
>
> -       if (global_id && ac->global_id != global_id) {
> -               dout(" set global_id %lld -> %lld\n", ac->global_id, global_id);
> -               ac->global_id = global_id;
> -       }
> -
>         if (ac->negotiating) {
>                 /* server does not support our protocols? */
>                 if (!protocol && result < 0) {
> @@ -253,11 +262,16 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
>
>         ret = ac->ops->handle_reply(ac, result, payload, payload_end,
>                                     NULL, NULL, NULL, NULL);
> -       if (ret == -EAGAIN)
> +       if (ret == -EAGAIN) {
>                 ret = build_request(ac, true, reply_buf, reply_len);
> -       else if (ret)
> +               goto out;
> +       } else if (ret) {
>                 pr_err("auth protocol '%s' mauth authentication failed: %d\n",
>                        ceph_auth_proto_name(ac->protocol), result);
> +               goto out;
> +       }
> +
> +       set_global_id(ac, global_id);
>
>  out:
>         mutex_unlock(&ac->mutex);
> @@ -484,15 +498,11 @@ int ceph_auth_handle_reply_done(struct ceph_auth_client *ac,
>         int ret;
>
>         mutex_lock(&ac->mutex);
> -       if (global_id && ac->global_id != global_id) {
> -               dout("%s global_id %llu -> %llu\n", __func__, ac->global_id,
> -                    global_id);
> -               ac->global_id = global_id;
> -       }
> -
>         ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
>                                     session_key, session_key_len,
>                                     con_secret, con_secret_len);
> +       if (!ret)
> +               set_global_id(ac, global_id);
>         mutex_unlock(&ac->mutex);
>         return ret;
>  }

Hi Greg,

I asked Sasha to drop this patch earlier today.

Thanks,

                Ilya
