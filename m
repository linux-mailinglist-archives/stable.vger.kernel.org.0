Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF60550DBC
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 02:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiFTAKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 20:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiFTAK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 20:10:29 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035CBDB1;
        Sun, 19 Jun 2022 17:10:28 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id i81-20020a1c3b54000000b0039c76434147so6985777wma.1;
        Sun, 19 Jun 2022 17:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MOgkmt4hoY1NuTD36wu+KkCXhIYC/5pF/wBvdmvGfkI=;
        b=fEftjZz9xOfRte/5Vn/z6uNJF5TeH7mcqAdtIpGU7vMdvK8RppSemCqOMg65gCdPwn
         +hna0kFogrLD6wE3HkG9QoytTHgoPWIjN0fLyJbo8ce1hz4HUefLzX8MCk6pmvCMmkc0
         vKmMeoC6aLNEbhzTSdfKTuQvN8pmKIgR94J/RCnlQ6Ij+dww31cfRdlGDKwdkvoT6QR2
         /nUiuvDGR/s1SJTERb0d3l76NdpEtcoUrVNqe23nrFLCjvPdiXSksnFpVUFSiZhkRBca
         fV/mCqNbbGkf9n94lk0sSHYeKKdXEF5GYdiU0i9FHlvd5ZXFxWLwetlg34DOxZ5pHWZc
         P9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MOgkmt4hoY1NuTD36wu+KkCXhIYC/5pF/wBvdmvGfkI=;
        b=XL79tC2QloRQ3u/lnnLjSzlPYaUvlkWhaPhtDQmSAq8rfsJLWSQkb3jRFVfEEIjVNl
         USoyehg0Ama20C3F4mf/iIEWInTN8FjdyRYMr6hZN/wkcXhCyWRv77czYuA/gZ1yJcZf
         OMY5g7DkE2z7x5cTz1Scpe0cR8U/LNWUv+lgB2AvnC9vyImBNI4fkeudKUOOIuTS8mad
         gsS7AE2KW9PKoB8vG6JQQvp+UToeTGw1AWh2bHnb1vUs11gMGq9UTOqhSR8+QlgE4Hyf
         meM+oYpzNQ9xgzJexe96NvJhGtj6wWWC2UURhhFiBKACmjqJYiiYwefupt2Gk9YpmO1C
         gknw==
X-Gm-Message-State: AJIora9pORUJdZnwAoqzBebUbaNxe/A99PSfxcQSyqTHSpUu8Nyw+vpt
        mvHIjIVyg9N6AUba+xydGGBJxRZ7D9ydRa6dBiU=
X-Google-Smtp-Source: AGRyM1uSHE60zzO0/gPy8Fr1bzhj/uEOzf7E9aPvCjleJw0Gl57hEYYoqZ0byCMvu+NarDwU1ZXwEBF8Ekbupp4cwV4=
X-Received: by 2002:a7b:c392:0:b0:39c:4d27:e698 with SMTP id
 s18-20020a7bc392000000b0039c4d27e698mr21804143wmj.57.1655683827478; Sun, 19
 Jun 2022 17:10:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220619141120.12760-1-linkinjeon@kernel.org> <20220619141120.12760-2-linkinjeon@kernel.org>
In-Reply-To: <20220619141120.12760-2-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 20 Jun 2022 09:10:16 +0900
Message-ID: <CANFS6bZz353HN_7-dSdZEtPxEYTeyAX7YHYe5N_=wLS2Z1ua8g@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: check invalid FileOffset and BeyondFinalZero
 in FSCTL_ZERO_DATA
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        stable@vger.kernel.org
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

2022=EB=85=84 6=EC=9B=94 19=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 11:11, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> FileOffset should not be greater than BeyondFinalZero in FSCTL_ZERO_DATA.
> And don't call ksmbd_vfs_zero_data() if length is zero.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

>  fs/ksmbd/smb2pdu.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index e35930867893..94ab1dcd80e7 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7700,7 +7700,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>         {
>                 struct file_zero_data_information *zero_data;
>                 struct ksmbd_file *fp;
> -               loff_t off, len;
> +               loff_t off, len, bfz;
>
>                 if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG=
_WRITABLE)) {
>                         ksmbd_debug(SMB,
> @@ -7717,19 +7717,26 @@ int smb2_ioctl(struct ksmbd_work *work)
>                 zero_data =3D
>                         (struct file_zero_data_information *)&req->Buffer=
[0];
>
> -               fp =3D ksmbd_lookup_fd_fast(work, id);
> -               if (!fp) {
> -                       ret =3D -ENOENT;
> +               off =3D le64_to_cpu(zero_data->FileOffset);
> +               bfz =3D le64_to_cpu(zero_data->BeyondFinalZero);
> +               if (off > bfz) {
> +                       ret =3D -EINVAL;
>                         goto out;
>                 }
>
> -               off =3D le64_to_cpu(zero_data->FileOffset);
> -               len =3D le64_to_cpu(zero_data->BeyondFinalZero) - off;
> +               len =3D bfz - off;
> +               if (len) {
> +                       fp =3D ksmbd_lookup_fd_fast(work, id);
> +                       if (!fp) {
> +                               ret =3D -ENOENT;
> +                               goto out;
> +                       }
>
> -               ret =3D ksmbd_vfs_zero_data(work, fp, off, len);
> -               ksmbd_fd_put(work, fp);
> -               if (ret < 0)
> -                       goto out;
> +                       ret =3D ksmbd_vfs_zero_data(work, fp, off, len);
> +                       ksmbd_fd_put(work, fp);
> +                       if (ret < 0)
> +                               goto out;
> +               }
>                 break;
>         }
>         case FSCTL_QUERY_ALLOCATED_RANGES:
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
