Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B14E550DBB
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 02:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiFTAKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 20:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiFTAJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 20:09:59 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DD4DB1;
        Sun, 19 Jun 2022 17:09:57 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id z9so4940090wmf.3;
        Sun, 19 Jun 2022 17:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sTcyRUHx7dY4o3iVYmrVKSVrMV1L0KNbCdnwZCN6ypo=;
        b=StCMuCfo2YuGbrPTmgo35h4o0Au+DhJhbv7vBpAsTpS31wBZPunoLy0Eob7HxmlKav
         0kJNMDpgYsD3BSz0bc7kqth7x+9n0IrtWH1neUjZyG8XYldr4jfPrbg/Bnz3GbbTsauH
         5DZC9Au+cSUrGz5Tu8ioPDlCdsRu7keR4g0PPRSEBBTjxy81y/GnHy4+jRkaAYYPPWsA
         t+1say2dALhGQwqf6T78sOBPLJTFuNJ2v8BQQ/7mxnsrbn22A73eX8tK3dupKycVF3s4
         iV7CzdewkB5pj224wAAsEqQO5WiHFjH/TIgAUaYgRI7EzsZUK0WiyC05P3lTlCqoMa3d
         bPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sTcyRUHx7dY4o3iVYmrVKSVrMV1L0KNbCdnwZCN6ypo=;
        b=WAfGVZ7K/pYjmmFkxjmHtpuYIAxrqQmLHtBhVehV7SoOgOnZP49A7PSLOWkS4GSkBc
         +/qLOchuOLHe/TsQ0k5iV+uOo2E0dXBTKp3dd2Lg8IlnngtbW5422RCrpcPcIWrPgfiA
         8bdYJ+9CWtY9pj8oCBZ2wUStdxvLus/ARxGqh/6bggzKWlB3XxRay/c87seuXvgs7eTI
         tENhUZPt3O9CwxkIZhnYZd063kI1uSg6VvxqT+nSbhW+NOc6EVO1w5eU9qklJdBDUv1T
         u4yND5ZyVe03IS3ZD/WkR5hlmg2uc5SILtkB4tgKTRn8FPbBIAU75KwxrdS6F0pt0Adh
         h8wg==
X-Gm-Message-State: AJIora/A4DYmzbm82DpDUZNNr9w1HnjKO6Q7slvG6icobnUADKPtXfld
        OAmA1YGNzufyofpTjVnkFPwMV/ybT27Fqvdc7TM=
X-Google-Smtp-Source: AGRyM1sJuELf0erLfiL2ntMWYp0ecnpdPKVMxEZGTmA6P9RD0kkkyc6jUvPDWRe7M2jmryIs6ZGaOTLTM6kUPP0FFPw=
X-Received: by 2002:a05:600c:4ed4:b0:39c:325e:5d81 with SMTP id
 g20-20020a05600c4ed400b0039c325e5d81mr22133830wmq.76.1655683795681; Sun, 19
 Jun 2022 17:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220619141120.12760-1-linkinjeon@kernel.org>
In-Reply-To: <20220619141120.12760-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 20 Jun 2022 09:09:44 +0900
Message-ID: <CANFS6baGo-t5csmj_UvT2A6aRMD_fUN7NxmDf-GbMfx73qKLfA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: set the range of bytes to zero without
 extending file size in FSCTL_ZERO_DATA
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
> generic/091, 263 test failed since commit f66f8b94e7f2 ("cifs: when
> extending a file with falloc we should make files not-sparse").
> FSCTL_ZERO_DATA sets the range of bytes to zero without extending file
> size. The VFS_FALLOCATE_FL_KEEP_SIZE flag should be used even on
> non-sparse files.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

>  fs/ksmbd/vfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
> index dcdd07c6efff..f194bf764f9f 100644
> --- a/fs/ksmbd/vfs.c
> +++ b/fs/ksmbd/vfs.c
> @@ -1015,7 +1015,9 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work, st=
ruct ksmbd_file *fp,
>                                      FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEE=
P_SIZE,
>                                      off, len);
>
> -       return vfs_fallocate(fp->filp, FALLOC_FL_ZERO_RANGE, off, len);
> +       return vfs_fallocate(fp->filp,
> +                            FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
> +                            off, len);
>  }
>
>  int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t len=
gth,
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
