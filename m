Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF5545B3B6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 06:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhKXFHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 00:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhKXFH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 00:07:29 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83B8C061574;
        Tue, 23 Nov 2021 21:04:20 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id n6so2590537uak.1;
        Tue, 23 Nov 2021 21:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DLu60VdNpOFl5EO9/7C3ti11HMjzdJ7VrkBrvpessEs=;
        b=ZmpBtOKZ968zAOt4BZ3YTiTNXpcuA4vuSgMYfs3hRqd2RroaG/un059x910LRziuNj
         Yjdsxh5uh1uWdO7Az80NOO7vTn0nf6gDRSGfln6Mjys8RMvJuuwhkfKwD/KsQlvlaoub
         3s/KuLvkErcTLl9meacZmroxC5ccsd0+8MEiKS3+TVoCCAJnrmAydYTxMfTsR9tIswfs
         DZYh2XMuCmlkhIIkG0UHOCRNt6dqVSGlzIs4D/QOMq1MTnOxPLTX2T/AC21hj7vahbZG
         gua+qo0wJDJZZU7Dc2yDXrqmTvHcSXKeNr59vu/MAu2fbGZf5aYswBF0mbZOl12h2DEd
         Ceqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DLu60VdNpOFl5EO9/7C3ti11HMjzdJ7VrkBrvpessEs=;
        b=xmJnM4i6CzOGhpwaktGUBB9pkaUhM7AEToFVOAFM7pWlGBa3XyqfGbcicle3sJevwr
         yiIcvxi2iCymF2g1/VuXqzC2OeRLIshSinhXaeRT14n9ivV2hdqqgV+EbsNoULR9tLOs
         u8D4+O1ZIOw9YDVq4zFPvSR7FFCSwm9p+ykN764COSohMk5Y9YcFafwKppzeDTgJ65DD
         4iaQHnVHs3SmmCwUn5le4s2TXwhPjnFLQxXBUw9eNW4ZaAsSaZQsjGHPWyQ98n4aa1o3
         Wwq175LX+DwnZUK/P+VQ9HJKRxf4OdHStTs0dsa2WnayvmeD3yfaK7qAqz8jaJoDJ1VV
         UlFg==
X-Gm-Message-State: AOAM533NDrgJ/PcGXwx/iABUDFLvEcKJXLcnMP++KVYHynyr2TL2QcP2
        SEmHlNmzoPkoWMpCoas7rEOp71OMsJQPRKewv00jUd8Dw88=
X-Google-Smtp-Source: ABdhPJwOnnT724UYAqiDlX6LuZAkXcfixTfv9zwkx8MH9wn1QQ8mMrl0B8HNAKS5eWTEQzwmhH1CNJHCvxoBaKesjmg=
X-Received: by 2002:ab0:4465:: with SMTP id m92mr5493316uam.47.1637730259696;
 Tue, 23 Nov 2021 21:04:19 -0800 (PST)
MIME-Version: 1.0
References: <20211124014511.12510-1-linkinjeon@kernel.org>
In-Reply-To: <20211124014511.12510-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 24 Nov 2021 14:04:08 +0900
Message-ID: <CANFS6baukT-PLGj2gdJajmTM=mP=2tRi2Ef=KP56zhYxEcPtTQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix memleak in get_file_stream_info()
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>, stable@vger.kernel.org,
        Coverity Scan <scan-admin@coverity.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2021=EB=85=84 11=EC=9B=94 24=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 1:46, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Fix memleak in get_file_stream_info()
>
> Fixes: 34061d6b76a4 ("ksmbd: validate OutputBufferLength of QUERY_DIR, QU=
ERY_INFO, IOCTL requests")
> Cc: stable@vger.kernel.org # v5.15
> Reported-by: Coverity Scan <scan-admin@coverity.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

>  fs/ksmbd/smb2pdu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 2067d5bab1b0..c70972b49da8 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -4496,8 +4496,10 @@ static void get_file_stream_info(struct ksmbd_work=
 *work,
>                                      ":%s", &stream_name[XATTR_NAME_STREA=
M_LEN]);
>
>                 next =3D sizeof(struct smb2_file_stream_info) + streamlen=
 * 2;
> -               if (next > buf_free_len)
> +               if (next > buf_free_len) {
> +                       kfree(stream_buf);
>                         break;
> +               }
>
>                 file_info =3D (struct smb2_file_stream_info *)&rsp->Buffe=
r[nbytes];
>                 streamlen  =3D smbConvertToUTF16((__le16 *)file_info->Str=
eamName,
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
