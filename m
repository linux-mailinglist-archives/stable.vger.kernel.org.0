Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823636D10A3
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 23:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjC3VQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 17:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjC3VPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 17:15:54 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1DAEC76
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 14:15:51 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p203so25213699ybb.13
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 14:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1680210951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qF+oDwPkmVm7Qzdori7BA3QXVGteSFkr5JVJlHDMV5M=;
        b=Uyr/tXATNpJkiRXDw5jPhZvgg3yTmAqevZZQdIgzznbFGsdDGcvLYswsrKbDTlEbMp
         0LSn4lVMaDd0wz6FRdC83zkC9WXvs5MZLt8Ezz/yEAUr5XD9sPPFK9RjoAgsIn3U0h4I
         gYuL5Ayy9wn8jZjai/fRYcKSYspooI5ovRLEaMHzzo8NCkszVDJxZmVNhxkVp7ZPUAYe
         6X+7REVFzscjLqZp5XXx+ntsKfb1TTkOJgq8WTSlHnLpbq6nMEoKVm3W8LmnAyFmswVt
         km2jGPsYbdVJAS1gD6b2EUDdbT8pq8TG2onjt1eCr+gUVqqUdyce819NSJz/07NP0ZIj
         4YDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680210951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qF+oDwPkmVm7Qzdori7BA3QXVGteSFkr5JVJlHDMV5M=;
        b=6cQ6e9vm+zbjJuzSPJs5rbnQhPDwwBNNl6i7KE07z9dNqrImL/ciKX3T/g6/G5rk8L
         4qsRW25onpPJHfIeJpOaUnhhWLvUTCRwn3GV6v5UJBYiLChNunlbDnAhAX9R8UgqE1qr
         fp+TYBkxZsPQJD9qZmfdD10Ri4P3BXHOvj4+khmqyS/utlzlxdsLbExFcwr6yG08l4SI
         YlMxqdA6hJJJUghm8VgbAMC+Z6/hdv9I1pz7MFuvpKfQqCY0QceEsvvHZzirTeST7Vtp
         JyRj0LCi+v3D6HnINSK+39KzRYPx1kOS7Jxq6sRUrjoC6wmq419sykc9SMjSK8aW9PoH
         IRWw==
X-Gm-Message-State: AAQBX9dCjyT4s1GRZFzhvXvDygbOpPGXFV3ctIHVGRfc1MGKChGA1swj
        2dIz2LNf4AnoYfuCHdRJIyB6n7IvcufzHaW6hM8B
X-Google-Smtp-Source: AKy350bjJ+D3+gXwrEw2lcCPM+Y4L8ToBkt7wQW0VhUQUCBX571TFxcGzOeeLA6px4laNdFZKwMWsEs+KGpCrB5zv1s=
X-Received: by 2002:a05:6902:70a:b0:b6e:361a:c86 with SMTP id
 k10-20020a056902070a00b00b6e361a0c86mr13662579ybt.3.1680210950900; Thu, 30
 Mar 2023 14:15:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230329130415.2312521-1-roberto.sassu@huaweicloud.com> <20230329130415.2312521-2-roberto.sassu@huaweicloud.com>
In-Reply-To: <20230329130415.2312521-2-roberto.sassu@huaweicloud.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 Mar 2023 17:15:40 -0400
Message-ID: <CAHC9VhRg7twUWXLH0xTaWc2MeSFExkGr9tJztYopzD0JEM-npw@mail.gmail.com>
Subject: Re: [PATCH v9 1/4] reiserfs: Add security prefix to xattr name in reiserfs_security_write()
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, casey@schaufler-ca.com,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        bpf@vger.kernel.org, kpsingh@kernel.org, keescook@chromium.org,
        nicolas.bouchinet@clip-os.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 9:05=E2=80=AFAM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> Reiserfs sets a security xattr at inode creation time in two stages: firs=
t,
> it calls reiserfs_security_init() to obtain the xattr from active LSMs;
> then, it calls reiserfs_security_write() to actually write that xattr.
>
> Unfortunately, it seems there is a wrong expectation that LSMs provide th=
e
> full xattr name in the form 'security.<suffix>'. However, LSMs always
> provided just the suffix, causing reiserfs to not write the xattr at all
> (if the suffix is shorter than the prefix), or to write an xattr with the
> wrong name.
>
> Add a temporary buffer in reiserfs_security_write(), and write to it the
> full xattr name, before passing it to reiserfs_xattr_set_handle().
>
> Since the 'security.' prefix is always prepended, remove the name length
> check.
>
> Cc: stable@vger.kernel.org # v2.6.x
> Fixes: 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes=
 during inode creation")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  fs/reiserfs/xattr_security.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
> index 6bffdf9a4fd..b0c354ab113 100644
> --- a/fs/reiserfs/xattr_security.c
> +++ b/fs/reiserfs/xattr_security.c
> @@ -95,11 +95,13 @@ int reiserfs_security_write(struct reiserfs_transacti=
on_handle *th,
>                             struct inode *inode,
>                             struct reiserfs_security_handle *sec)
>  {
> +       char xattr_name[XATTR_NAME_MAX + 1];
>         int error;
> -       if (strlen(sec->name) < sizeof(XATTR_SECURITY_PREFIX))
> -               return -EINVAL;

If one really wanted to be paranoid they could verify that
'XATTR_SECURITY_PREFIX_LEN + strlen(sec->name) <=3D XATTR_NAME_MAX' and
return EINVAL, but that really shouldn't be an issue and if the
concatenation does result in a xattr name that is too big, the
snprintf() will safely truncate/managle it.

Regardless, this patch is fine with me, but it would be nice if at
least of the reiserfs/VFS folks could provide an ACK/Reviewed-by tag,
although I think we can still move forward on this without one of
those.

> -       error =3D reiserfs_xattr_set_handle(th, inode, sec->name, sec->va=
lue,
> +       snprintf(xattr_name, sizeof(xattr_name), "%s%s", XATTR_SECURITY_P=
REFIX,
> +                sec->name);
> +
> +       error =3D reiserfs_xattr_set_handle(th, inode, xattr_name, sec->v=
alue,
>                                           sec->length, XATTR_CREATE);
>         if (error =3D=3D -ENODATA || error =3D=3D -EOPNOTSUPP)
>                 error =3D 0;
> --
> 2.25.1

--=20
paul-moore.com
