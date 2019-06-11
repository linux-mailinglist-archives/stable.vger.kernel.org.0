Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A81DA41929
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 01:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405317AbfFKXwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 19:52:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36607 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404808AbfFKXwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 19:52:34 -0400
Received: by mail-lj1-f193.google.com with SMTP id i21so13392687ljj.3;
        Tue, 11 Jun 2019 16:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VENOP9kl7lg5KwAxIPCouDt1b8Ws7sAjlClYwMccvkk=;
        b=fivEwC5hnXqUGk5603e1MnAG/mADaygUOmV3PIsZ3IMYL75ryOgDvU7uHsFxpYB0go
         ieMR00vOGpQREHjn2+aej3foTWeEL3oQOrFc69YRAikto9jTKa5n7QaX6nkzZaH04dMG
         /Kkwk34cl9BDmFIfJg9XRni4Qo8z3YM10s16+wF7IBqeaAGYbAfvR4uF1mgTQUt+VCUk
         JNfkMxauM0kWVmOd/nhtZ65BRuvrKL8yXxafKLbdN/cPj8WSDbLXgj7DaCFKNUP+4vag
         OZfTARhoXxcb1AvwVTUjlYcYtIke/qT5kk6MFaI+9kKSkap21v2vtI8iyN/Ndb/GeaUI
         elrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VENOP9kl7lg5KwAxIPCouDt1b8Ws7sAjlClYwMccvkk=;
        b=tnn2U1BPIHnGsX35BNNfY8F8MTT9Py6tZCkWykF8oaNEHYhWk7KTtyQZPVdQiaIHmh
         kSGbx5GoXUw1cijh6sT/BfRpUJPw3g3H9G0SA86/a1xwYAmsVcB187dzsF+iro2zAI+a
         GTT/LAUa6kpvE0JdC8Pw9G4t5vPygTBGaV4FfuPGjV5HYYRpsj9GYEeRw9UYAeVfvhc+
         auaQ9AzXmWn9YkWX3hSpqXG8DvaBS5FNQW/KIjxk9F1CVm0c20PeHOmyfLEiFxvtYOKp
         +zz0rMw6Puuaf3x0drYM7ITCDzeFUdsy9kiKsVHS9ouws7tf0ehbFXVp+KxMKY+/MGYQ
         TkNA==
X-Gm-Message-State: APjAAAUvEY8927VCBvekud4Z9Wvf8jtZhAozs3kWcYssgBlQ5MCTrlRA
        BKQ8EZd0GEGxPr2LQ452WWA8cnpxaqruwj5ECw==
X-Google-Smtp-Source: APXvYqwXKEnifxG0ZulJwDSBVavjHGiiNqpCp4KHpEscPy7916h+xxeL2bSqWfzEtRZLpQ8+dBbewxnKzU3w1FUEGok=
X-Received: by 2002:a2e:9e8e:: with SMTP id f14mr17661324ljk.120.1560297152242;
 Tue, 11 Jun 2019 16:52:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190605001534.28278-1-lsahlber@redhat.com>
In-Reply-To: <20190605001534.28278-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 11 Jun 2019 16:52:21 -0700
Message-ID: <CAKywueSpgeVf4cR+yeHxRHuzt5RV9p_1Vsea_jH_qH98-+EYhA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix panic in smb2_reconnect
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=D0=B2=D1=82, 4 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 17:16, Ronnie Sahlb=
erg <lsahlber@redhat.com>:
>
> RH Bugzilla: 1702264
>
> We need to protect so that the call to smb2_reconnect() in
> smb2_reconnect_server() does not end up freeing the session
> because it can lead to a use after free and crash.
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2pdu.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 565b60b62f4d..ab8dc73d2282 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3113,9 +3113,14 @@ void smb2_reconnect_server(struct work_struct *wor=
k)
>                                 tcon_exist =3D true;
>                         }
>                 }
> +               /*
> +                * IPC has the same lifetime as its session and uses its
> +                * refcount.
> +                */
>                 if (ses->tcon_ipc && ses->tcon_ipc->need_reconnect) {
>                         list_add_tail(&ses->tcon_ipc->rlist, &tmp_list);
>                         tcon_exist =3D true;
> +                       ses->ses_count++;
>                 }
>         }
>         /*
> @@ -3134,7 +3139,10 @@ void smb2_reconnect_server(struct work_struct *wor=
k)
>                 else
>                         resched =3D true;
>                 list_del_init(&tcon->rlist);
> -               cifs_put_tcon(tcon);
> +               if (tcon->ipc)
> +                       cifs_put_smb_ses(tcon->ses);
> +               else
> +                       cifs_put_tcon(tcon);
>         }
>
>         cifs_dbg(FYI, "Reconnecting tcons finished\n");
> --
> 2.13.6
>

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
