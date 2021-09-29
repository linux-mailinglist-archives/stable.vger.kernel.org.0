Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C1641BCBA
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 04:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243783AbhI2CaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 22:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243062AbhI2CaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 22:30:08 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA899C061745
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 19:28:27 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id m3so4397952lfu.2
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 19:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vzNXCj84D1g4PbD9Z2/a7WAfkTzxrDKROcDc/hzpBWc=;
        b=UFBbRLUsdxkCVsyDBTZelri1sE1uBJFhlXVFzOQ00BYD/vd027QrYNGqzaxNahSk5t
         p6RkaJek68Zp/n/NESHX4OhAOqTF0Ns7OTCXh7/7WouElvWnEJzoUqEO5tfPylzKLTcJ
         4mmlTm0nReyACi0Ttcsrq2osd9UWg42lgdAnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vzNXCj84D1g4PbD9Z2/a7WAfkTzxrDKROcDc/hzpBWc=;
        b=H2Dl4b96eA1k0SHFUWAilMVDacH5uNwEfp7+eESKcki+4hxNSK/+BriQkiRehH0edF
         1To4eQMTpDKl7s4HOLTE/EcWq+8xkv49rBi9A7QwU/+u7CGFARtT75LxCW9XcK00uteL
         93OOpb1AbILCaNS+SFf/1rDmYHSTbjeTI/UHhBU2qcGZJSajki20CbLJgSsXZ/mmODfu
         1Emxyve9zoBx8gsbtk4vSw73POmcaf7Gmq2Li6Y3/S4+uVrWnN03KiQFU0S4Xg+iABuy
         vkmcx3w/nOh1hzcRzKoKGs2Z5WQPgQFUyLh/c9kKz1AtUpdpSn55S0YAp5U8hNndk8Hz
         YMBA==
X-Gm-Message-State: AOAM530nn7YFqk+G/d7Xaax6aI6FL5+CKwgFx5vk8I+IM6k8oLeC15dD
        D3tDjTP0TLYd7ibs9xL5yON8lfh9CaCBVjsoMjX0pw==
X-Google-Smtp-Source: ABdhPJyNUZV2MQMbi62ec77cW4ABFydIvPmDIM3cOMvSI1YRYR4lewd8Ni0ge/QhfE1OeZiNo6sOeIu/PGqaRs29+uo=
X-Received: by 2002:a2e:b80f:: with SMTP id u15mr3549500ljo.414.1632882506299;
 Tue, 28 Sep 2021 19:28:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210928213552.1001939-1-briannorris@chromium.org> <20210928143413.v3.2.I4e9d93aadb00b1ffc7d506e3186a25492bf0b732@changeid>
In-Reply-To: <20210928143413.v3.2.I4e9d93aadb00b1ffc7d506e3186a25492bf0b732@changeid>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Wed, 29 Sep 2021 10:28:15 +0800
Message-ID: <CAGXv+5GiQrxrcwCt0A6Dxxodd8JTqUvEJtZdzB=SUKJuWD_RVw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] drm/rockchip: dsi: Reconfigure hardware on resume()
To:     Brian Norris <briannorris@chromium.org>
Cc:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Sandy Huang <hjc@rock-chips.com>,
        Thomas Hebb <tommyhebb@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 29, 2021 at 5:36 AM Brian Norris <briannorris@chromium.org> wrote:
>
> Since commit 43c2de1002d2, we perform most HW configuration in the
> bind() function. This configuration may be lost on suspend/resume, so we
> need to call it again. That may lead to errors like this after system
> suspend/resume:
>
>   dw-mipi-dsi-rockchip ff968000.mipi: failed to write command FIFO
>   panel-kingdisplay-kd097d04 ff960000.mipi.0: failed write init cmds: -110
>
> Tested on Acer Chromebook Tab 10 (RK3399 Gru-Scarlet).
>
> Note that early mailing list versions of this driver borrowed Rockchip's
> downstream/BSP solution, to do HW configuration in mode_set() (which
> *is* called at the appropriate pre-enable() times), but that was
> discarded along the way. I've avoided that still, because mode_set()
> documentation doesn't suggest this kind of purpose as far as I can tell.
>
> Fixes: 43c2de1002d2 ("drm/rockchip: dsi: move all lane config except LCDC mux to bind()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
