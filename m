Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799E04626FE
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbhK2W77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbhK2W7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:59:48 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79F1C127106
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 10:05:14 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id 207so36038463ljf.10
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 10:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IDi3zvjd6u7ZBVvXAka/LTSyAvUkqeh+L5SnX6c8Zdk=;
        b=ELtQ57DjVTWJPnvASv4jZtvg9xzVjpRXdLK6WadVUiqQO2Tejx2Y4rP/jZvsvwdaGM
         wVK5qYNcJTRTVvihhUy6a3XfzO7ShXe3HSKg9CJ9S9TdxAt3X4+ddQNsKXsRbhOEV3Nn
         NeS7l4DPoqAaH0j+Gm2rrnRobzgyBp+zZRI4nhmfoSItyMTQPe6HJsrb3a8uXIO7pAUp
         d0pHSCno/fnC3Fp0q+W51eSWigYy/I5qIJhRZa/O1KEhI708OF8jeLET61Dg8b9kw0VH
         st1/mw7gEQ1NVGLv+ANo/xqXiZgR94N5ykkWzVgrrh3SWq2UdJQ1DTZyuwBI86rq3HIq
         HE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IDi3zvjd6u7ZBVvXAka/LTSyAvUkqeh+L5SnX6c8Zdk=;
        b=EyF6d/R3pTzJv4uT7Kk8+Hd6Uct5jhGo7dRTJ84o9U/yl2DJpDFUWN9PFlt+vdX3S0
         UTg20/2ISqlo6SNDjr4XrqP7/wS/nMtSCwYAvw0uitM0qLUiNP4YQi1KlwOrO433ZkL4
         mrvccsyV3QpKTzUrmkyOyC5B7IZOaDMMOZxy1XcSILql0aVxljCuEFViHMQxNMC3pVxQ
         jG3+l9marKDkhywP8pEhw+k0VVjJBJN/4dgv/Ib3i4pglPTiIdxmnubOPOLcg5d+T6Xo
         FxXYGX7C1GO+0WcfctXWQfRPkR3v1k8CTjpfX+oJvsAe4dUXVPvBSxAZlakKWVUJlWp5
         7uWA==
X-Gm-Message-State: AOAM53212Hcl6NBX/BkAM5evJ/slpJZ3/W2vGeh9hjzBXnjRQHzBu0xy
        aPF1EIje3qJseSt2kfC5NDKiykXkAyXYljaFF1YuGw==
X-Google-Smtp-Source: ABdhPJz00rJJqhFv+eY/G4mQJbhWwtM/vfpfxJXb8qlKInsjRYgNcLli9eLdqgC5XVztKYKpkdzK0NNalzo7Gw9l8CQ=
X-Received: by 2002:a2e:95d3:: with SMTP id y19mr50881703ljh.175.1638209112922;
 Mon, 29 Nov 2021 10:05:12 -0800 (PST)
MIME-Version: 1.0
References: <YaB/JHP/pMbgRJ1O@kroah.com> <20211126074904.88388-1-guangming.cao@mediatek.com>
In-Reply-To: <20211126074904.88388-1-guangming.cao@mediatek.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Mon, 29 Nov 2021 10:05:00 -0800
Message-ID: <CALAqxLVF1BPznzwjem2BcsDDoo5gMoBqjKEceZDLJan4zCtk3w@mail.gmail.com>
Subject: Re: [PATCH v4] dma-buf: system_heap: Use 'for_each_sgtable_sg' in
 pages free flow
To:     guangming.cao@mediatek.com
Cc:     greg@kroah.com, Brian.Starkey@arm.com,
        benjamin.gaignard@linaro.org, christian.koenig@amd.com,
        dri-devel@lists.freedesktop.org, labbott@redhat.com,
        linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org,
        lmark@codeaurora.org, matthias.bgg@gmail.com, robin.murphy@arm.com,
        stable@vger.kernel.org, sumit.semwal@linaro.org,
        wsd_upstream@mediatek.com, kuan-ying.lee@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 11:48 PM <guangming.cao@mediatek.com> wrote:
>
> From: Guangming <Guangming.Cao@mediatek.com>
>
> For previous version, it uses 'sg_table.nent's to traverse sg_table in pages
> free flow.
> However, 'sg_table.nents' is reassigned in 'dma_map_sg', it means the number of
> created entries in the DMA adderess space.
> So, use 'sg_table.nents' in pages free flow will case some pages can't be freed.
>
> Here we should use sg_table.orig_nents to free pages memory, but use the
> sgtable helper 'for each_sgtable_sg'(, instead of the previous rather common
> helper 'for_each_sg' which maybe cause memory leak) is much better.
>
> Fixes: d963ab0f15fb0 ("dma-buf: system_heap: Allocate higher order pages if available")
> Signed-off-by: Guangming <Guangming.Cao@mediatek.com>
> Reviewed-by: Robin Murphy <robin.murphy@arm.com>
> Cc: <stable@vger.kernel.org> # 5.11.*

Thanks so much for catching this and sending in all the revisions!

Reviewed-by: John Stultz <john.stultz@linaro.org>
