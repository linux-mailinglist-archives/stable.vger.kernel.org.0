Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A592E3D9C19
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 05:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbhG2DPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 23:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbhG2DPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 23:15:52 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67DBC061765
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 20:15:49 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id c3so4325600ilh.3
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 20:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GEHpVphhyLJFXCEe7iQRjsD/9tyMnPNRqVbPlXIwLE4=;
        b=H90NoVLKUmuE48C1hAsE0ENepOFZRurynbwu4Ws/QA1jGVRagWYAhHGiC8+m2XW69W
         JA9fHV1GqZL6fM7sH2FKKneMMmwqYPo8v4iPz8hoSF6djxgc3bXBfUay/zJ28wLYWvpT
         vkll/a6MvrPvAukm8GFHf+MXXIuhOKhN/2AKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GEHpVphhyLJFXCEe7iQRjsD/9tyMnPNRqVbPlXIwLE4=;
        b=ESyYZm8P0B+ld4BsHo95upzxqLMeC0t3w8LPhbzjbc/UcdnwoU9PX7hl1Zbm5JbzOx
         tBtth4bGQiiQNTYrsMUVM46asTJHSCJ+YpJ+PofIx/b4jBI0ZYtEvS0MgyJs/ZHt8ad1
         ySqFh7H4k2L5WPlo5GM6wiblrGv4Er1SqR5+QAi7Af+cqZNfm7G3iX7oNe7/U1bQBeGY
         uiuG/JCvA/jxIj3Bxk/PXcRYSuYI/oG+ZCsLhy8rhDsJD2xG5aNrIVtfpgYntjaT8s68
         CIrC+dqUj4ZGck+OU0FuWRKse4ehR+hQHkl/ZrF9cXuXuzSfI/ksavrHocNDDQ8cgJ/E
         0eTA==
X-Gm-Message-State: AOAM532rFSG+Sd8N4KebETLFNIWfnrB4UefO9rsmmncAgH1C+J0y1Hs3
        IfAFoI8NOMLz1yaovGE/5kWVjjKTpoheLSpWJK8CN5XXj/3whQ==
X-Google-Smtp-Source: ABdhPJyPsS75VPrbgercdilELkiuOWzRBn0SaHkomjCxnwrLSJus0YUdJJOv5CRdtmWxFFYOzx1hw2W2wQKSbbm/++c=
X-Received: by 2002:a05:6e02:d8f:: with SMTP id i15mr2072719ilj.102.1627528549224;
 Wed, 28 Jul 2021 20:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210727174025.10552-1-linux@fw-web.de>
In-Reply-To: <20210727174025.10552-1-linux@fw-web.de>
From:   Hsin-Yi Wang <hsinyi@chromium.org>
Date:   Thu, 29 Jul 2021 11:15:23 +0800
Message-ID: <CAJMQK-g8g5QJbBkU-A6th1VSWafxVv2fGtym+enQa_hDVaVoBw@mail.gmail.com>
Subject: Re: [PATCH] soc: mmsys: mediatek: add mask to mmsys routes
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 1:41 AM Frank Wunderlich <linux@fw-web.de> wrote:
>
> From: CK Hu <ck.hu@mediatek.com>
>
> SOUT has many bits and need to be cleared before set new value.
> Write only could do the clear, but for MOUT, it clears bits that
> should not be cleared. So use a mask to reset only the needed bits.
>
> this fixes HDMI issues on MT7623/BPI-R2 since 5.13
>
> Cc: stable@vger.kernel.org
> Fixes: 440147639ac7 ("soc: mediatek: mmsys: Use an array for setting the routing registers")
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: CK Hu <ck.hu@mediatek.com>
> ---
> code is taken from here (upstreamed without mask part)
> https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/2345186/5
> basicly CK Hu's code so i set him as author
> ---
>  drivers/soc/mediatek/mtk-mmsys.c |   7 +-
>  drivers/soc/mediatek/mtk-mmsys.h | 133 +++++++++++++++++++++----------
>  2 files changed, 98 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/soc/mediatek/mtk-mmsys.c b/drivers/soc/mediatek/mtk-mmsys.c
> index 080660ef11bf..0f949896fd06 100644
> --- a/drivers/soc/mediatek/mtk-mmsys.c
> +++ b/drivers/soc/mediatek/mtk-mmsys.c
> @@ -68,7 +68,9 @@ void mtk_mmsys_ddp_connect(struct device *dev,
>
>         for (i = 0; i < mmsys->data->num_routes; i++)
>                 if (cur == routes[i].from_comp && next == routes[i].to_comp) {
> -                       reg = readl_relaxed(mmsys->regs + routes[i].addr) | routes[i].val;
> +                       reg = readl_relaxed(mmsys->regs + routes[i].addr);
> +                       reg &= ~routes[i].mask;
> +                       reg |= routes[i].val;
>                         writel_relaxed(reg, mmsys->regs + routes[i].addr);
>                 }
>  }
> @@ -85,7 +87,8 @@ void mtk_mmsys_ddp_disconnect(struct device *dev,
>
>         for (i = 0; i < mmsys->data->num_routes; i++)
>                 if (cur == routes[i].from_comp && next == routes[i].to_comp) {
> -                       reg = readl_relaxed(mmsys->regs + routes[i].addr) & ~routes[i].val;
> +                       reg = readl_relaxed(mmsys->regs + routes[i].addr);
> +                       reg &= ~routes[i].mask;

This patch is breaking the mt8183 internal display. I think it's
because  ~routes[i].val; is removed?
Also what should the routes[i].mask be if it's not set in
mmsys_mt8183_routing_table?

>                         writel_relaxed(reg, mmsys->regs + routes[i].addr);
>                 }
>  }
<snip>
