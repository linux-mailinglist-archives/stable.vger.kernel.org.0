Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 775DA15BADA
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 09:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgBMIhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 03:37:22 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52709 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgBMIhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 03:37:22 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so5194103wmc.2
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 00:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=SpOSiHd+ceklnjc83gflDmwLy0jKlR+qhKztdISCJPg=;
        b=QqLT0mWVbsMw+N9f4Im+jQL5BOZo+5jZXDOTzVWBKwPthjs9CXFw5kX2TVdcK/JYQS
         SgPW18YO1LCHbpThp+P6ZRoeZtLq69sCJ21cpm867TRwd/S54iTZrTK0XS7g3KDuffEC
         LzdwixSMCUskX2SPWImajF+SsDK+hX6EsXF5IIOUcxqE53Rf5pa1lImq3xbL90KcAEDN
         0gn2FqERO9F2jtW/KbFh/C07s4I+p1oJPmqz1Abj+EMbv/F3wF29lguemS0h4t2O6rrE
         jgHVzKVE4uD/30BlXw+InYiUcUz+GWXFTDCh81VHWnGbSUV8Yv1lyu7SoskuvZ3jakRD
         oijA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=SpOSiHd+ceklnjc83gflDmwLy0jKlR+qhKztdISCJPg=;
        b=CvAjef2A/+/wkiT0R1piPJA08JZvhJHmrrI3LYLzK/nLwIiSisgarbZqiG7pEHFg5S
         uN6O/5lBBmc/XF1sAAWpaBy5VyWICqxBuOCmkAuXlGMBM1T1HRO/H6Q28GMfujfbhVy5
         J4OabldTo9fks0HjkFvSaLLV02l+9mtmW0ytF64u5hcURuMyxDDXw0sWLNy69U6MciCE
         UuM1YQllrKZh9nNzS/cYpQqbVyPUzcM8XoIrHsCDKIkDTo/74rNS1QAK+9d/A8gwf1f2
         bnfJd8JLuWLvKwTyAbNmRXqmOzzuSh1BgI77PQClbL19CIaZZ7lcrgWj/FNx+xW5Y1GU
         vZ4w==
X-Gm-Message-State: APjAAAWvCRZWhaqTlmj5B8Ae8RK9xBH2ZZCn9TBHdCyoj41PX+T0L6fT
        fXybG7DDc4V/qwETpPZRhC+ocQ==
X-Google-Smtp-Source: APXvYqzCff8WTsFShTc3iju7U1CZeupb+EhRjNpiAZFEfcxo2uvaUfoSzx1vdoEkL6bd57iktFA6Nw==
X-Received: by 2002:a1c:4e01:: with SMTP id g1mr4269368wmh.12.1581583039666;
        Thu, 13 Feb 2020 00:37:19 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id o77sm2154746wme.34.2020.02.13.00.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 00:37:19 -0800 (PST)
References: <20200213061147.29386-1-samuel@sholland.org> <20200213061147.29386-2-samuel@sholland.org>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Samuel Holland <samuel@sholland.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Jonathan Corbet <corbet@lwn.net>
Cc:     alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] ASoC: codec2codec: avoid invalid/double-free of pcm runtime
In-reply-to: <20200213061147.29386-2-samuel@sholland.org>
Date:   Thu, 13 Feb 2020 09:37:18 +0100
Message-ID: <1jr1yyannl.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Thu 13 Feb 2020 at 07:11, Samuel Holland <samuel@sholland.org> wrote:

> The PCM runtime was freed during PMU in the case that the event hook
> encountered an error. However, it is also unconditionally freed during
> PMD. Avoid a double-free by dropping the call to kfree in the PMU
> hook.

Oh ... Thanks for finding this.

I thought that a widget which has failed PMU would not go through PMD,
but It seems the return value dapm_seq_check_event is not checked.

This brings another question/problem:
A link which has failed in PMU, could try in PMD to hw_free/shutdown a
dai which has not gone through startup/hw_params, right ?

>
> Fixes: a72706ed8208 ("ASoC: codec2codec: remove ephemeral variables")
> Cc: stable@vger.kernel.org
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
>  sound/soc/soc-dapm.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
> index b6378f025836..935b5375ecc5 100644
> --- a/sound/soc/soc-dapm.c
> +++ b/sound/soc/soc-dapm.c
> @@ -3888,9 +3888,6 @@ snd_soc_dai_link_event_pre_pmu(struct snd_soc_dapm_widget *w,
>  	runtime->rate = params_rate(params);
>  
>  out:
> -	if (ret < 0)
> -		kfree(runtime);
> -
>  	kfree(params);
>  	return ret;
>  }

