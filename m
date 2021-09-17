Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEC540F2D8
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 09:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhIQHEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 03:04:55 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:37237 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhIQHEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 03:04:54 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MUXlA-1mIMSp3eSG-00QPW4; Fri, 17 Sep 2021 09:03:31 +0200
Received: by mail-wr1-f41.google.com with SMTP id i23so13479612wrb.2;
        Fri, 17 Sep 2021 00:03:31 -0700 (PDT)
X-Gm-Message-State: AOAM533WZq/kA+LPRZU0SE6/iPWXjmp5+BOMPW7w5QZIg8q03v8tQqB5
        lKSmV+X38ZIDcaHFo8f2UGfI1It3Pz3TR0Le9UU=
X-Google-Smtp-Source: ABdhPJz6K37oowvtVnUkowG0nxZzOI+axmO9A4ikJeOfih5HaJAzy/5L2QcnJCd43z3dvvawjMZrQdmy5VxlRg74EhY=
X-Received: by 2002:a05:6000:1561:: with SMTP id 1mr863849wrz.369.1631862211495;
 Fri, 17 Sep 2021 00:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210917005913.157379-1-marex@denx.de>
In-Reply-To: <20210917005913.157379-1-marex@denx.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 17 Sep 2021 09:03:14 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1wE2r11LE1XX26LAag9xpP1yAeOqArScrK6nP9wK_f8w@mail.gmail.com>
Message-ID: <CAK8P3a1wE2r11LE1XX26LAag9xpP1yAeOqArScrK6nP9wK_f8w@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: Avoid potential overflow in timeout_to_jiffies()
To:     Marek Vasut <marex@denx.de>
Cc:     linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:LDX1mwHBQpWYhzPWNvI/DtHRnilu+XGCB5OjDz1Vwjpt/9jjo5G
 8/4vNHIt6yc5aeTETjAN8UyYyNbsve7XLWSxDx7xaqpJDSQNYH0d3EP+wZx93gNnvwaxgt0
 FHhXJvuN99lvFXs2wpH0bTdQjRwXkbpqEhBk+nuxZzUl1fBEqJxqIY2/zbSDGR52KsxGXhV
 CCtrgN3lkv45LMhrNOztQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jxNtv5tCauE=:0iAWKUh0vxAkCDS5WbmSub
 nbHEYd0KDgxjq2kVdsZIrBL6fU/IIdD3j/JUTlH+ko235B17N5Nq2Cj02MNBWUw4R3C8FHWVM
 v96E/QFumFzu1p9ZeZ3jcmVQWSwKkB90F6XiZ4oOsKzz79s78LR+2JwBuDtvi8iGiZrmlY1fB
 koIYH+DtC3qZYjNff0kvNXYvtl7s+9RueAqtEsplAT1BrQYxh5LMgIrsmZkhnGY7HU7rpXTiv
 EMbr0KPLxmod9thMCSjM9XfrK/0jieoqJ6E0U4vtI0XuKxL6xngpJACjHeqrWt8byJCkjHzLr
 OB6PLU2ylipTz1g0p8bBDXORtfxAZ/AHItg1lDO4PZuG6bsq4xG6LBTg+9dRCsW4JHtk+1oZN
 zJbppBy8oPjQdVESBBnTrCSaHe1kuaZsKqkLV+zHh9coVg+/P8XLvpKgqb3z/ulpL6ZX4LR0C
 qm5RrO3MZ9h7uwnhM2g+S/ieaHhi8qXKkPQq/MHB6m9T84WdObBf/S3puN00Uulj0xHlEWaYp
 QOtwUrBdmckjNMMXVY/WBUinCBKhG5LXJ0jQVFCkdX9MDZpcq84pRL6VpAU8wREjDqBikA1x4
 R53EkQ2p0ixQ0sveIXBEBljrV3VIX03BCgHWJ9t+AejhR2gA8uA7zlNbNHWL4eWSkdXkjXPAW
 rA4X6qCv01X+lEdP7l9qQhP3Q3SQFGvBRoSU/q7QKI+ID9Tzc2s14oIf0Y/MtybWfVERnLnA9
 xn1QD5vjkucCMabOi0MiJJTRthqbvwRxDRha7w==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 17, 2021 at 2:59 AM Marek Vasut <marex@denx.de> wrote:
>
> The return type of ktime_divns() is s64. The timeout_to_jiffies() currently
> assigns the result of this ktime_divns() to unsigned long, which on 32 bit
> systems may overflow. Furthermore, the result of this function is sometimes
> also passed to functions which expect signed long, dma_fence_wait_timeout()
> is one such example.
>
> Fix this by adjusting the type of remaining_jiffies to s64, so we do not
> suffer overflow there, and return a value limited to range of 0..INT_MAX,
> which is safe for all usecases of this timeout.
>
> The above overflow can be triggered if userspace passes in too large timeout
> value, larger than INT_MAX / HZ seconds. The kernel detects it and complains
> about "schedule_timeout: wrong timeout value %lx" and generates a warning
> backtrace.
>
> Note that this fixes commit 6cedb8b377bb ("drm/msm: avoid using 'timespec'"),
> because the previously used timespec_to_jiffies() function returned unsigned
> long instead of s64:
> static inline unsigned long timespec_to_jiffies(const struct timespec *value)
>
> Fixes: 6cedb8b377bb ("drm/msm: avoid using 'timespec'")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jordan Crouse <jcrouse@codeaurora.org>
> Cc: Rob Clark <robdclark@chromium.org>
> Cc: stable@vger.kernel.org # 5.6+
> ---

Acked-by: Arnd Bergmann <arnd@arndb.de>
