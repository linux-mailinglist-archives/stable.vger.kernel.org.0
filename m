Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D8F6EDB72
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 08:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjDYGBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 02:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbjDYGBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 02:01:34 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFC5768A;
        Mon, 24 Apr 2023 23:01:32 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id a1e0cc1a2514c-77115450b8fso3059734241.0;
        Mon, 24 Apr 2023 23:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682402491; x=1684994491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/QtXOE0evN6u5nDYY+j79dys0ARBBBVTD6zTkUWl1o=;
        b=VyBLHzI3lbUTEeTSQWQ2Qwyub1Gd3J9MoMG+UanYep4hgcvGQwxw8wNQRr0yhUlOjL
         YuEIkJenm/JM4AG+C0yrKmB6G/4tFrH+z+k2uGWvj7R8TG5ITsuONfqP1hggYq1x+A+c
         0b2e85PT4+NkS0lwmN7FGLlfV34fMirKkGiiepRV1EEgw7WlO2CoGpb4BFL8qz0Lk5mU
         uxguja9QRhqsKlHOTHqudMfuuCy0vwPvPuWy01PkEZ8mEL9Z7fQa3vLuSNz75Tv/0CJn
         mvSvEWoj8tDmPEqFt1RMOE256Zsu5HoBD+wA5OOVG0N+9u5t89ULYSiKRqdmSSVPRozl
         S+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682402491; x=1684994491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u/QtXOE0evN6u5nDYY+j79dys0ARBBBVTD6zTkUWl1o=;
        b=leIpchaWlHVPkT3eVbo/vb4eIbFwE5xNDq/5wFxo/1eoIkEFsPY+MK10QP00N+Kmu6
         nLOzWE14Qrgc9rdD7nBOUsuCjN6fdjV6Dd3psfLjoD0PGv27pN4XQZWvfSS5dShlfO/z
         C2uu62Q9GNBK+1bovnfeqty+YAN+v4GZGvDFaZ1V7+VHUeEa6AulEb0/zWGUCvbLGu2c
         KLMr36+JsYRXCBiMI7yJgznoyxTvvqf2otHGyqQ1+JdNxpmaNG6Wf0tKW4g6nlIX4UGL
         sqfnt++pEBoVi+mfE0ttNv4RdKqLHCwQMs1qTTyzxWKqh29/s+wXLAzxW7lUjkuliADz
         /caQ==
X-Gm-Message-State: AAQBX9dUM1DyQ1sngIjpv4WW4ezzX59hh0m1DDfghgqdSFoPmcwayZtD
        lwWNerG4UqOHct11c/QR4R1TiRBUTHEuy2vimF8=
X-Google-Smtp-Source: AKy350aVfd3f4Es5Xsk1ghtpikyrFPuFZfLEQ2g1D2pgZ/Ep9mpheYWenLWKLdpRoKqtDD4IFfE2q955uxwRd5KmJOY=
X-Received: by 2002:a05:6102:14a:b0:42c:543a:ab2a with SMTP id
 a10-20020a056102014a00b0042c543aab2amr6296411vsr.35.1682402491632; Mon, 24
 Apr 2023 23:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230424163219.9250-1-jack@suse.cz>
In-Reply-To: <20230424163219.9250-1-jack@suse.cz>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 25 Apr 2023 09:01:20 +0300
Message-ID: <CAOQ4uxjamwMxOXb3j7D8j_KkHLosayn3dnRbGfso9SFfzkSdDg@mail.gmail.com>
Subject: Re: [PATCH] inotify: Avoid reporting event with invalid wd
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+4a06d4373fd52f0b2f9c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 24, 2023 at 7:32=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> When inotify_freeing_mark() races with inotify_handle_inode_event() it
> can happen that inotify_handle_inode_event() sees that i_mark->wd got
> already reset to -1 and reports this value to userspace which can
> confuse the inotify listener. Avoid the problem by validating that wd is
> sensible (and pretend the mark got removed before the event got
> generated otherwise).
>
> CC: stable@vger.kernel.org
> Fixes: 7e790dd5fc93 ("inotify: fix error paths in inotify_update_watch")
> Reported-by: syzbot+4a06d4373fd52f0b2f9c@syzkaller.appspotmail.com
> Signed-off-by: Jan Kara <jack@suse.cz>

Makes sense.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/notify/inotify/inotify_fsnotify.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> I plan to merge this fix through my tree.
>
> diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/ino=
tify_fsnotify.c
> index 49cfe2ae6d23..f86d12790cb1 100644
> --- a/fs/notify/inotify/inotify_fsnotify.c
> +++ b/fs/notify/inotify/inotify_fsnotify.c
> @@ -65,7 +65,7 @@ int inotify_handle_inode_event(struct fsnotify_mark *in=
ode_mark, u32 mask,
>         struct fsnotify_event *fsn_event;
>         struct fsnotify_group *group =3D inode_mark->group;
>         int ret;
> -       int len =3D 0;
> +       int len =3D 0, wd;
>         int alloc_len =3D sizeof(struct inotify_event_info);
>         struct mem_cgroup *old_memcg;
>
> @@ -80,6 +80,13 @@ int inotify_handle_inode_event(struct fsnotify_mark *i=
node_mark, u32 mask,
>         i_mark =3D container_of(inode_mark, struct inotify_inode_mark,
>                               fsn_mark);
>
> +       /*
> +        * We can be racing with mark being detached. Don't report event =
with
> +        * invalid wd.
> +        */
> +       wd =3D READ_ONCE(i_mark->wd);
> +       if (wd =3D=3D -1)
> +               return 0;
>         /*
>          * Whoever is interested in the event, pays for the allocation. D=
o not
>          * trigger OOM killer in the target monitoring memcg as it may ha=
ve
> @@ -110,7 +117,7 @@ int inotify_handle_inode_event(struct fsnotify_mark *=
inode_mark, u32 mask,
>         fsn_event =3D &event->fse;
>         fsnotify_init_event(fsn_event);
>         event->mask =3D mask;
> -       event->wd =3D i_mark->wd;
> +       event->wd =3D wd;
>         event->sync_cookie =3D cookie;
>         event->name_len =3D len;
>         if (len)
> --
> 2.35.3
>
