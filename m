Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF5A432F53
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 09:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhJSH1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 03:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhJSH1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 03:27:08 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B34C06161C;
        Tue, 19 Oct 2021 00:24:56 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id j190so11808573pgd.0;
        Tue, 19 Oct 2021 00:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jr3Muznsu1+ia39ypZjhEZwn1Lvzal6ZyLPhl8pjkfI=;
        b=ixmnDgU0Zl4avp6D8yzTpc3wdRJy2oAd3ZvW/hBVZne2jByQwbMnxXkbYl5jRs0Cz7
         0v2EAr7ipycdLKJoGl0CJuyWMplsUByA8wundZHKppEgzc1B/oP2gqFO6zcFpyFzxyqT
         vBrESaefLeDxi9k49mDpnzlkee6X9Ea7bijkgmapnEZT0KH8fbNJk4sfBzzlRdLW4qM8
         nbMVip+NIULDFWJQWTqqRA9zJpQQhaHC7tnV6iNBkTGBgz493OKN+HRSNssQhmwZXl5M
         VFhSqEj41KW4gbhyVkTvvxoQTFyUHfqLR1oQTzdVdlxaYjJXRqqSnLZMOKuw9ryNFmnU
         evfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jr3Muznsu1+ia39ypZjhEZwn1Lvzal6ZyLPhl8pjkfI=;
        b=TmUlT7pSSRTqbn5WTpT5b3bwzv6PAielLMGIM3Wj+U0swVxvQl2A/Dj1BzkLWsOSjb
         mlPSmpomQQkF/goDyNZU9N+Ng/eFqQQPSh19s7eif2UhwZ7IMYJ2YwmVX3a4Pc1qPRCK
         Wh8Ly2OPI8k/7Q9OSRRUVY14v7qNzt1UFhR4IqHORi/hkTrkXUGg2HqJzIQFfipE0ILU
         GwjLuN4eIi22ImM7EaENmwL+xMTK93M07AQDQ+K7Ic6EHCCl7WB4uIRrTZ6YuhsAxbqv
         pJB4TddHuaZu/I/b5nJ+mfZj7vytAikUjtn0v1Hh1tzvhMXhZhsPxd7pLART9LRo1Nro
         WH/Q==
X-Gm-Message-State: AOAM530Mf1sIk+gaEF1HaWXDSmwrV+BBrdfs2Pfr1TTI7S3uTlDH1/jf
        tD2dcwxOe7+Mc6YztcEppaceRerUy8HOzYureOY=
X-Google-Smtp-Source: ABdhPJwL/7Uw8QLij+OYWZyPH3LUPnUQ/++Tuck4Vc4cz54ntUZdo3PLcLYq+Q9hNdZjeirJR1olcltcVXWdg15qAbE=
X-Received: by 2002:aa7:9f92:0:b0:44d:bd1:98b2 with SMTP id
 z18-20020aa79f92000000b0044d0bd198b2mr34175808pfr.82.1634628296156; Tue, 19
 Oct 2021 00:24:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211008081137.1948848-1-michal.vokac@ysoft.com>
 <20211018112820.qkebjt2gk2w53lp5@pengutronix.de> <37bc3702-bc98-dc54-e9c7-bf9bc92432f0@linaro.org>
In-Reply-To: <37bc3702-bc98-dc54-e9c7-bf9bc92432f0@linaro.org>
From:   Petr Benes <petrben@gmail.com>
Date:   Tue, 19 Oct 2021 09:24:44 +0200
Message-ID: <CAPwXO5YguJtSFSqnA_aGPch2NswmrP1EzOs0QH5O_iOdtn5W1A@mail.gmail.com>
Subject: Re: [PATCH] thermal: imx: Fix temperature measurements on i.MX6 after alarm
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Petr_Bene=C5=A1?= <petr.benes@ysoft.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Oct 2021 at 13:38, Daniel Lezcano <daniel.lezcano@linaro.org> wr=
ote:
>
> On 18/10/2021 13:28, Oleksij Rempel wrote:
> > Hi Michal,
> >
> > I hope you have seen this patch:
> > https://lore.kernel.org/all/20210924115032.29684-1-o.rempel@pengutronix=
.de/
> >
> > Are there any reason why this was ignored?
>
> No reasons, I was waiting for some tags before merging it. But I forget
> about it when reviewing the current patch.

Tested Oleksij's patch. It works OK. A question arose. Does it require
CONFIG_PM=3Dy?
If this condition is mandatory and the requirement is valid, Kconfig
should be changed accordingly.
I'm not able to verify it works without PM, seems it doesn't.
>
>
>
> --
> <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software for AR=
M SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
