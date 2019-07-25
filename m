Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE0775305
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 17:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388598AbfGYPmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 11:42:05 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34384 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389136AbfGYPmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 11:42:05 -0400
Received: by mail-ed1-f66.google.com with SMTP id s49so15810960edb.1
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 08:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MNkXECJCwZrlY0TNH7A1b2lGWt3otavBoyZrTznJtcA=;
        b=jI+NycjUP6dxobiyu7dooewJyiMPSKnZuEAR9QAAdHorsKKv9zQty8Zi/e3mTuuwTw
         f+5REnTryYYRy7SGL9GubSQdxHJJASl9Ylgtuj/XQKjHnxc3LR3PA0ZTh3KESVVHAP0l
         b+ZmbxdwQ8OgMxYul7lgpNzEHZXSO/mmnFCbw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MNkXECJCwZrlY0TNH7A1b2lGWt3otavBoyZrTznJtcA=;
        b=Cic/joPT80gqWjiw1u4RObm/vB/DWIr0UAIk9oAbgNrXhnth+JQROBHxOGOYs6B56Z
         OZZ0AqyI8jl7Nq9/AGLhMXcYULSe+6s+iDl16KHyAn0BB0ye/G5Qu9qx4wvwB83wEYO8
         lTd6sB7WdFIQGbpBvNnScsjn3Fw8ac0I4QEvGZgiBCmmKiIYrC7LgHuDIxt5njqOs1b0
         rR3/t07SD5oOqpH8RGd+BcDMvoBmlRL5Mf8WOWs6h7TDw/KtPACr9kFazSQkBNILw/MW
         VpKMKDWET0cRa2Yum/qPExIslPWQvon1zE3+KtrSAc42vooqkbg2P7eFJQ4EIhNaxpQo
         62/Q==
X-Gm-Message-State: APjAAAUlv2AuKFqZLntHOqjiS6pNty0/SnxkJ/mzFBzh9oZN42sr0thP
        7JnCWDypVAQ7mBahGrg22H7QUz8hpo+MtA==
X-Google-Smtp-Source: APXvYqzILmlGWVTVRLMPmX59d+tuOurxf+wpv0gI9hqdj1ZQ1mUs1Lyw6/pADO2/D7J4AP28WChnOg==
X-Received: by 2002:a50:b122:: with SMTP id k31mr78575089edd.204.1564069323424;
        Thu, 25 Jul 2019 08:42:03 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id b15sm2908420ejj.5.2019.07.25.08.42.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 08:42:02 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id v15so45455829wml.0
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 08:42:02 -0700 (PDT)
X-Received: by 2002:a1c:343:: with SMTP id 64mr77603832wmd.116.1564069321964;
 Thu, 25 Jul 2019 08:42:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190725141756.2518-1-ezequiel@collabora.com> <20190725141756.2518-2-ezequiel@collabora.com>
 <1564069001.3006.1.camel@pengutronix.de>
In-Reply-To: <1564069001.3006.1.camel@pengutronix.de>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 26 Jul 2019 00:41:48 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BxQJBNqMnS1bCVXz-9+dCkw0g4xmiPLYgtVCJx_pbRPg@mail.gmail.com>
Message-ID: <CAAFQd5BxQJBNqMnS1bCVXz-9+dCkw0g4xmiPLYgtVCJx_pbRPg@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] media: hantro: Set DMA max segment size
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        fbuergisser@chromium.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 12:36 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
> On Thu, 2019-07-25 at 11:17 -0300, Ezequiel Garcia wrote:
> > From: Francois Buergisser <fbuergisser@chromium.org>
> >
> > The Hantro codec is typically used in platforms with an IOMMU,
> > so we need to set a proper DMA segment size.
>
> ... to make sure the DMA-mapping subsystem produces contiguous mappings?
>
> > Devices without an
> > IOMMU will still fallback to default 64KiB segments.
>
> I don't understand this comment. The default max_seg_size may be 64 KiB,
> but if we are always setting it to DMA_BUT_MASK(32), there is no falling
> back.
>

DMA mask and segment size are two completely orthogonal parameters.
Please check https://elixir.bootlin.com/linux/v5.3-rc1/source/drivers/iommu/dma-iommu.c#L740
for an example of how the latter is used.

Best regards,
Tomasz
