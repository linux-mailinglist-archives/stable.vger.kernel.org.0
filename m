Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8C140C3AD
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 12:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhIOKgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 06:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbhIOKgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 06:36:47 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE39C061574;
        Wed, 15 Sep 2021 03:35:28 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so2894951otq.7;
        Wed, 15 Sep 2021 03:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6xLSppBOsV2YPjsByPhMJVGLtMZoH734rrG1YlyXsLM=;
        b=hw09PvReJAO18JdKGV2h/0YN0Gj53kgc+lArAoVDkir+8QRebGtc1g8WQVcBdYivoZ
         lqH9Y/HrHjDlBWGMvthoFvdivW/oPq3a3cKuGLKGgXf8ccb5T1RyH3vYvm2B4ynNlo57
         Owy+hfDHvJ7P3EmFZmiOD+wT31ToL/yK8j6khLE0LPq23luwTHXSnGhVNSA4JBjy+q92
         jSiEod+GZeqCZOyK+zU1D+Xan09SagXgpbVThKD83pj/TfhkxYA+TxTDp+askPp2rV8S
         Iar+bMd3AkMMhywQQksY9HZspaRShuR+B5aBIzqXPxQsgMN5bsvil8V+CywYlCv9NRTO
         RnHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6xLSppBOsV2YPjsByPhMJVGLtMZoH734rrG1YlyXsLM=;
        b=nOI1aQLakzF50qG/MAxe4Qeot98Z9yXQkDokhijzmVsEExM8qnElE3ggijDGxb1fvi
         GoeePM6lx0Dgax4cpcYxq8pR4jhZPaMk4DMWNhWyGj1afn2BwsYBfbUSaJSZyd5m7gMV
         yoU8q8TLaC+pA6dT4bG5X/6e8VElVNPlMZPodFabIx5xg38fy3sQuVmZ0q2iGbFb6Reh
         045shtxmCMozruDU+TGxvMnRzPAyKsCMM6XHUs31cEAFk5nuTI6STByRdZ62+xqbSGR3
         yRd3vpM7lFRfLtU5gpixCh+0WPqXHTn/YGCnWUZos0hCQBX4/iEjn9w854d1dIm+ZnwW
         uOIA==
X-Gm-Message-State: AOAM533vNgN+z9K4xVERe7U5S1BnaPE1Zhm768SI42hiMaDrtkG5zTPt
        6zpgW4CneSayC2joKQ3LpPvnMrF2+fX2ejjpOek=
X-Google-Smtp-Source: ABdhPJy/m9CzMPOmk678cmG5JGElmmCBP3/xxB3seGE78Xsr9MTLQAgQCuXJECCyNlIRvkU/y6jl637q8ZOswsov/lg=
X-Received: by 2002:a05:6830:4018:: with SMTP id h24mr19136186ots.161.1631702127872;
 Wed, 15 Sep 2021 03:35:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAHj4cs-noupgFn3QjB96Z20hv-BhFLHOyFZFEtrhGpESkeoRSA@mail.gmail.com>
 <CAFj5m9J4sxRwQb7+nHzYOurX9QRpEgsEMCqdx4SHA4THnsJXBA@mail.gmail.com>
 <YTnc5Ja/DKR30Euy@kroah.com> <YTq4QFWexPF9aQvG@T590> <YTsAOtychCR8m3WA@kroah.com>
In-Reply-To: <YTsAOtychCR8m3WA@kroah.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Wed, 15 Sep 2021 12:35:16 +0200
Message-ID: <CA+res+T4XVV9LDc+ADiBJTRB_Qynthzky2Ldj4q76hzeP=-d1w@mail.gmail.com>
Subject: Re: [bug report] NULL pointer at blk_mq_put_rq_ref+0x20/0xb4 observed
 with blktests on 5.13.15
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ming Lei <ming.lei@redhat.com>, Yi Zhang <yi.zhang@redhat.com>,
        linux-block <linux-block@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2021=E5=B9=B49=E6=9C=8810=E6=
=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8A=E5=8D=888:51=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Sep 10, 2021 at 09:43:28AM +0800, Ming Lei wrote:
> > On Thu, Sep 09, 2021 at 12:07:32PM +0200, Greg KH wrote:
> > > On Thu, Sep 09, 2021 at 05:14:18PM +0800, Ming Lei wrote:
> > > > On Thu, Sep 9, 2021 at 4:47 PM Yi Zhang <yi.zhang@redhat.com> wrote=
:
> > > > >
> > > > > Hello
> > > > >
> > > > > I found this issue with blktests on[1], did we miss some patch on=
 stable?
> > > > > [1]
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
> > > > > queue/5.13
> > > > >
> > > > > [   68.989907] run blktests block/006 at 2021-09-09 04:34:35
> > > > > [   69.085724] null_blk: module loaded
> > > > > [   74.271624] Unable to handle kernel NULL pointer dereference a=
t
> > > > > virtual address 00000000000002b8
> > > > > [   74.280414] Mem abort info:
> > > > > [   74.283195]   ESR =3D 0x96000004
> > > > > [   74.286245]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> > > > > [   74.291545]   SET =3D 0, FnV =3D 0
> > > > > [   74.294587]   EA =3D 0, S1PTW =3D 0
> > > > > [   74.297720] Data abort info:
> > > > > [   74.300588]   ISV =3D 0, ISS =3D 0x00000004
> > > > > [   74.304411]   CM =3D 0, WnR =3D 0
> > > > > [   74.307368] user pgtable: 4k pages, 48-bit VAs, pgdp=3D0000080=
04366e000
> > > > > [   74.313796] [00000000000002b8] pgd=3D0000000000000000, p4d=3D0=
000000000000000
> > > > > [   74.320577] Internal error: Oops: 96000004 [#1] SMP
> > > > > [   74.325443] Modules linked in: null_blk mlx5_ib ib_uverbs ib_c=
ore
> > > > > rfkill sunrpc vfat fat joydev acpi_ipmi ipmi_ssif cdc_ether usbne=
t mii
> > > > > mlx5_core psample ipmi_devintf mlxfw tls ipmi_msghandler arm_cmn
> > > > > cppc_cpufreq arm_dsu_pmu acpi_tad fuse zram ip_tables xfs ast
> > > > > i2c_algo_bit drm_vram_helper drm_kms_helper crct10dif_ce syscopya=
rea
> > > > > ghash_ce sysfillrect uas sysimgblt sbsa_gwdt fb_sys_fops cec
> > > > > drm_ttm_helper ttm nvme usb_storage nvme_core drm xgene_hwmon
> > > > > aes_neon_bs
> > > > > [   74.366458] CPU: 31 PID: 2511 Comm: fio Not tainted 5.13.15+ #=
1
> > > >
> > > > Looks the fixes haven't land on linux-5.13.y:
> > > >
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3Da9ed27a764156929efe714033edb3e9023c5f321
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3Dc2da19ed50554ce52ecbad3655c98371fe58599f
> > >
> > > Now queued up.  Someone could have told us they were needed :)
> >
> > Thanks for queuing it up, sorry for not Cc stable.
> >
> > BTW, the following two patches are missed too in linux-5.13-y:
> >
> > 364b61818f65 blk-mq: clearing flush request reference in tags->rqs[]
>
> This one applies, but,
>
> > bd63141d585b blk-mq: clear stale request in tags->rq[] before freeing o=
ne request pool
>
> This one does not.
this is already included since 5.10.50
747b654e4069 ("blk-mq: clear stale request in tags->rq[] before
freeing one request pool")
>
> Please provide working backports for both of these if you want to see
> them merged into the stable trees.  And what about 5.10 for them as
> well?
>
> thanks,
>
> greg k-h
