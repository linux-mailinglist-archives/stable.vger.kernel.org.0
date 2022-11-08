Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4519620CB7
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 10:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiKHJ4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 04:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiKHJ4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 04:56:45 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEA713EBE;
        Tue,  8 Nov 2022 01:56:43 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id f27so37193338eje.1;
        Tue, 08 Nov 2022 01:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMKGW2ULRszh2HQVemdsypiKrjge0/xhaU3RLIpBZ8o=;
        b=V+ySpcF7g2t7mYb0FjSntC4vuBuLLZbVV0mtcefklsZeiB4Asya2e7+Ko5tTNrMm5G
         sMwxELAVYmNBJ92LtmSPISBz6DqkAVt8VsG/PmHeG97m3Ri47yGt3Diz7omaP2DOF75w
         XZmcAw48QC7NZu6uGuHqGLb9wPaRdETZPjdXrBwW+LQdiiA6KZ1sf5w5fi+5/uX26RQT
         JxauCHqyv38sjq+92fbU7h43YMgu79kLFfI4TrOVRnKKxtdCXkU+EuZQHi5Z5quVUOYn
         yu/nik629kxP7FwSpAdiD1bN8PcywVhbeoHLvPm+dBa/0wqG9HKdX5d4pA8COrM29cC2
         FtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yMKGW2ULRszh2HQVemdsypiKrjge0/xhaU3RLIpBZ8o=;
        b=COqw8+Zy4fsWNeV52g+SCTieAw0X8qebV4e/aFalEngEahce5mHDLhIHFZ5rZhqUBZ
         7HlcTPdDyFA8zcQYvy23+rdTz8UegheW7Y1vrbhTiiJCX+Qx8gGwGk4ooc7SC8QyLRzU
         XtOUZxoA1Nhe8EMFL/nnPzXR8T3lYwQ/IGnDVCraE+hGutF+J9tADXFRhbbNUhWTccYd
         MPxJt+Gc5S+rRz1iCw64MPZBVn0X5lLUnmwZj/dXJO3BWeaeecEULHwsUtgd0v8df7o/
         ZgAMwlhThFj1x0iwHgPq5isPUDsJe2cH4xgfemkdwBgLTZeGqaMMGYBNnG6yqGwxfA2w
         6jtw==
X-Gm-Message-State: ACrzQf1X3jImDPCXVenYF640shYTx3+Ghrl8+xlEyQU4Rr3WkruQndny
        WrZ4bjYAITaTUE5fr0FQ9JxUYxilEfkwzR+HkqPI3mxQ1b4=
X-Google-Smtp-Source: AMsMyM7+KWkZunmnyPGAnubrswK7MQT7TneD9EGzMGU2CQ+aaLs9r4fx1NFpxbhgM5J95agXnwEAXNgULt6RguE/XKA=
X-Received: by 2002:a17:906:4fc3:b0:72e:eab4:d9d7 with SMTP id
 i3-20020a1709064fc300b0072eeab4d9d7mr50898843ejw.599.1667901401890; Tue, 08
 Nov 2022 01:56:41 -0800 (PST)
MIME-Version: 1.0
References: <20221108023141.64972-1-xiubli@redhat.com>
In-Reply-To: <20221108023141.64972-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 8 Nov 2022 10:56:30 +0100
Message-ID: <CAOi1vP9MamdH5im1bMZGQTr0ubbMeanHSw5bCZ8Ud+FEG152Zg@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: avoid putting the realm twice when decoding
 snaps fails
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 8, 2022 at 3:32 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When decoding the snaps fails it maybe leaving the 'first_realm'
> and 'realm' pointing to the same snaprealm memory. And then it'll
> put it twice and could cause random use-after-free, BUG_ON, etc
> issues.
>
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/57686
> Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/snap.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 9bceed2ebda3..77b948846d4d 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -854,6 +854,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *md=
sc,
>         else
>                 ceph_put_snap_realm(mdsc, realm);
>
> +       realm =3D NULL;

Hi Xiubo,

Nit: I think it would be better to clear realm in the part of
the function that actually needs it to be cleared -- otherwise
this assignment can be easily lost in refactoring.

        dout("%s deletion=3D%d\n", __func__, deletion);
more:
        realm =3D NULL;
        rebuild_snapcs =3D 0;

And then realm wouldn't need to be initialized.

Thanks,

                Ilya
