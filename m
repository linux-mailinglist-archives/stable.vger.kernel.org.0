Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A812F2DFD
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 12:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbhALLfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 06:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbhALLfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 06:35:07 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CCDC06179F
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 03:34:27 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id c7so1553084qke.1
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 03:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BAPb6vexy0PxRtXiUa5L0zEXfbkLceHCVsv7ebs5b1k=;
        b=zi6iaFuVYuUiKP2K8cPgOTQZ7OFwrTgmdC5T6KZgeikQEjRkOhtCbM4wKpyailZafU
         riOSqnVptS+vJJKV1UrBRFX66IHFMZCkFU+hZri2g/EljddrUUIY410Eh4RgOPCB026f
         GUsbErOQkL5zBFFSss88s0ovOkkP8UJaNmzBgSFOJavm0et8cuKqH1t0yru2F6ZestrN
         rf9umHxtU7XCCh0sSm2Yy5fFARZXc0GgZrcCScLWV8LxNmXSFFv/keQgz5HYIcDN1E5O
         8Mgy2FHcY1e6THAiPpzNw+NPLg953O+yN4SAXNUiXw6J9qaxC1lRk3bjEpiBaX25G/oH
         uUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BAPb6vexy0PxRtXiUa5L0zEXfbkLceHCVsv7ebs5b1k=;
        b=c1YkFDjPXAE1semjwQfu1+bf1l4BC/4wHSyzr48SCPI2YKQT7RNYwhuJ4ePJfaAfGo
         FG3W2W309BMrHo0xvZjc6uGjHVShiq086wQbu/vNYnvuUa6uWymmjebNQSFMZOjwbEWg
         +vNvoIk93CVUaxE0zWCb6eop40ULasqjIIehnpRCCV0usen/qqiXhGYOHtHE0Md0bpGD
         KT2c8XSpN12qJU5Y1kEIVWkz9zioUtGg+3EBa8/n87v5YdYeIjrZ53EUVAmDmVL3uv29
         yHiMiBUW8KWW1IFz5nnud4ESdfli6rvBi+8bg2FWRvTcJK9ZU7LnYqW/q76FzpaCgCAb
         uncw==
X-Gm-Message-State: AOAM530tkb6hFVIGUdINiYhd+t+W30wF9eoXE9a1dFYpAsl+MO+9Knp6
        ItuCL2Oy1aUH3aMbIedJrGQRHK4kkrteya7FGUpshA==
X-Google-Smtp-Source: ABdhPJyUSpCuEwwARgenIRd/aDCwRCB3v4+OhxHyhOyFHJY4qH28gQ1A/X5bMFhsiXYHkxCQfo4LCWZm/BDzP5iw6/M=
X-Received: by 2002:a37:418d:: with SMTP id o135mr4180829qka.426.1610451266538;
 Tue, 12 Jan 2021 03:34:26 -0800 (PST)
MIME-Version: 1.0
References: <20201210121438.7718-1-lma@semihalf.com> <20201217130439.141943-1-lma@semihalf.com>
In-Reply-To: <20201217130439.141943-1-lma@semihalf.com>
From:   =?UTF-8?Q?=C5=81ukasz_Majczak?= <lma@semihalf.com>
Date:   Tue, 12 Jan 2021 12:34:15 +0100
Message-ID: <CAFJ_xbprw7UKREWgRAq3dDAA9oC_3cWoozn5pCY8w9By4dASag@mail.gmail.com>
Subject: Re: [PATCH v2] ASoC: Intel: Skylake: Check the kcontrol against NULL
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alex Levin <levinale@google.com>,
        Guenter Roeck <groeck@google.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This is just a kind reminder. Is there anything more required to
upstream this patch?

Best regards,
Lukasz


czw., 17 gru 2020 o 14:06 Lukasz Majczak <lma@semihalf.com> napisa=C5=82(a)=
:
>
> There is no check for the kcontrol against NULL and in some cases
> it causes kernel to crash.
>
> Fixes: 2d744ecf2b984 ("ASoC: Intel: Skylake: Automatic DMIC format config=
uration according to information from NHLT")
> Cc: <stable@vger.kernel.org> # 5.4+
> Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> Reviewed-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>
> ---
>  sound/soc/intel/skylake/skl-topology.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>  v1 -> v2: fixed coding style
>
> diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/sky=
lake/skl-topology.c
> index ae466cd592922..8f0bfda7096a9 100644
> --- a/sound/soc/intel/skylake/skl-topology.c
> +++ b/sound/soc/intel/skylake/skl-topology.c
> @@ -3618,12 +3618,18 @@ static void skl_tplg_complete(struct snd_soc_comp=
onent *component)
>         int i;
>
>         list_for_each_entry(dobj, &component->dobj_list, list) {
> -               struct snd_kcontrol *kcontrol =3D dobj->control.kcontrol;
> -               struct soc_enum *se =3D
> -                       (struct soc_enum *)kcontrol->private_value;
> -               char **texts =3D dobj->control.dtexts;
> +               struct snd_kcontrol *kcontrol;
> +               struct soc_enum *se;
> +               char **texts;
>                 char chan_text[4];
>
> +               kcontrol =3D dobj->control.kcontrol;
> +               if (!kcontrol)
> +                       continue;
> +
> +               se =3D (struct soc_enum *)kcontrol->private_value;
> +               texts =3D dobj->control.dtexts;
> +
>                 if (dobj->type !=3D SND_SOC_DOBJ_ENUM ||
>                     dobj->control.kcontrol->put !=3D
>                     skl_tplg_multi_config_set_dmic)
> --
> 2.25.1
>
