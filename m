Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842B16A8E54
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 01:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjCCAvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 19:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCCAvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 19:51:15 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB9BA1;
        Thu,  2 Mar 2023 16:51:14 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s17so560714pgv.4;
        Thu, 02 Mar 2023 16:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677804674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJYk4hCKjOxFQ49axmFLTnRK8yHcLGp0RaCvx6w4UZo=;
        b=PTSN8VZY7bxIAnoE+oKlL98axPXERPDJ3I2XICKNOBUQsUqSYfN/k7TdWdpOfDO/uR
         5RuxpBfv15zz5/XLJwLOmUePrOxW7T/HPfRZ1qnsOw7RSXLaQ1eJ2Fc1aicfCvD+rGC6
         c3TX542Nx/WHx5i+1TrS+ITXmrU5/EEa59tdeYqoqBw5iKZGyz61IqupvT7pNcP879vP
         gcRM7qCFoXY9Gr5EvJaNvHUisokzO2tzSK8bp6sa2D8NOAbz1Of6miZnYupjM4/10nJ7
         s6+lnn2JB3QNeqE5/WI/23X/PmldskoYM2LUudD2tyXIG2pRmcp7oZq4xgtNWQt+1Rfj
         Uo1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677804674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qJYk4hCKjOxFQ49axmFLTnRK8yHcLGp0RaCvx6w4UZo=;
        b=FM/ncnBOrLmAssEi/9NmnFzu8bUTQ1B66nL/9M7+MD5N3DiG/Ixx5GSrgwTRJCWKO3
         bB/hOLZQiJJ9S0LxCdCVJuywa3WJra0wv1JYczWTKCBlOwMnYLfHQ/ZQrY1wOTZ5VjiN
         tnqCyx9Cz0GoVZodSZjwX0/62OiiP+Fze+Twij0fXNuTB+Ri8HPXBRpadueB9USu48LQ
         3wrvKb0AFDTbVFWJ0BSAI9mftDQyn2d4dpupT+nCAZ/zEaMDc5v8LtRd1Q3Bo+I7jOZD
         JWTuesBUQMGJSEhZKxxoMYmsJ67pAJv8t4XSmyXbHYgHyG/6hYqPp7Hf4XNwgG/VJ0LF
         uhhw==
X-Gm-Message-State: AO0yUKVa/vN53Lbwfc/IkfbVzExYEDPeg3Ue79EJLY4IYcMOuwG/mjz8
        HmI3F3RUw+Mlv3H0zX4/dIpzY2lzhjfu5+GypbY=
X-Google-Smtp-Source: AK7set+8913cW40rRk6iFWRxSLXX85Xkgyh4u1C4LzKcHqHle7Cfal1MiqBUSeP5RoeTmEVAjM9/SyCXFuNz4UCYoqU=
X-Received: by 2002:a63:2b04:0:b0:503:83e8:9b54 with SMTP id
 r4-20020a632b04000000b0050383e89b54mr1454436pgr.1.1677804674271; Thu, 02 Mar
 2023 16:51:14 -0800 (PST)
MIME-Version: 1.0
References: <20230302163648.3349669-1-alvin@pqrs.dk>
In-Reply-To: <20230302163648.3349669-1-alvin@pqrs.dk>
From:   Ruslan Bilovol <ruslan.bilovol@gmail.com>
Date:   Thu, 2 Mar 2023 19:51:02 -0500
Message-ID: <CAB=otbTiCd0RTbJQxVrp1BB=MVtH-U70eM0fTMHdFH33bC00HA@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: u_audio: don't let userspace block driver unbind
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yadi Brar <yadi.brar01@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Felipe Balbi <balbi@ti.com>, alsa-devel@alsa-project.org,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, Mar 2, 2023 at 11:39=E2=80=AFAM Alvin =C5=A0ipraga <alvin@pqrs.dk> =
wrote:
>
> From: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
>
> In the unbind callback for f_uac1 and f_uac2, a call to snd_card_free()
> via g_audio_cleanup() will disconnect the card and then wait for all
> resources to be released, which happens when the refcount falls to zero.
> Since userspace can keep the refcount incremented by not closing the
> relevant file descriptor, the call to unbind may block indefinitely.
> This can cause a deadlock during reboot, as evidenced by the following
> blocked task observed on my machine:
>
>   task:reboot  state:D stack:0   pid:2827  ppid:569    flags:0x0000000c
>   Call trace:
>    __switch_to+0xc8/0x140
>    __schedule+0x2f0/0x7c0
>    schedule+0x60/0xd0
>    schedule_timeout+0x180/0x1d4
>    wait_for_completion+0x78/0x180
>    snd_card_free+0x90/0xa0
>    g_audio_cleanup+0x2c/0x64
>    afunc_unbind+0x28/0x60
>    ...
>    kernel_restart+0x4c/0xac
>    __do_sys_reboot+0xcc/0x1ec
>    __arm64_sys_reboot+0x28/0x30
>    invoke_syscall+0x4c/0x110
>    ...
>
> The issue can also be observed by opening the card with arecord and
> then stopping the process through the shell before unbinding:
>
>   # arecord -D hw:UAC2Gadget -f S32_LE -c 2 -r 48000 /dev/null
>   Recording WAVE '/dev/null' : Signed 32 bit Little Endian, Rate 48000 Hz=
, Stereo
>   ^Z[1]+  Stopped                    arecord -D hw:UAC2Gadget -f S32_LE -=
c 2 -r 48000 /dev/null
>   # echo gadget.0 > /sys/bus/gadget/drivers/configfs-gadget/unbind
>   (observe that the unbind command never finishes)
>
> Fix the problem by using snd_card_free_when_closed() instead, which will
> still disconnect the card as desired, but defer the task of freeing the
> resources to the core once userspace closes its file descriptor.

It seems nobody has tested that use-case before. Thank you for fixing it

Reviewed-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>

>
> Fixes: 132fcb460839 ("usb: gadget: Add Audio Class 2.0 Driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
> ---
>  drivers/usb/gadget/function/u_audio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/f=
unction/u_audio.c
> index c1f62e91b012..4a42574b4a7f 100644
> --- a/drivers/usb/gadget/function/u_audio.c
> +++ b/drivers/usb/gadget/function/u_audio.c
> @@ -1422,7 +1422,7 @@ void g_audio_cleanup(struct g_audio *g_audio)
>         uac =3D g_audio->uac;
>         card =3D uac->card;
>         if (card)
> -               snd_card_free(card);
> +               snd_card_free_when_closed(card);
>
>         kfree(uac->p_prm.reqs);
>         kfree(uac->c_prm.reqs);
> --
> 2.39.1
>
