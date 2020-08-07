Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9609B23F27B
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 20:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGSHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 14:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHGSHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 14:07:34 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106E2C061756;
        Fri,  7 Aug 2020 11:07:34 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id v13so2666880oiv.13;
        Fri, 07 Aug 2020 11:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7F5o5gH/tEwEajzpI7fTjneSGKfDGJAlpNidTq6oDnU=;
        b=h+X+IDG5dLANG+FOYNwmT/mCzl4Eb5Ny4ytokQkbBAz6vm7JzGxrWxCh6OV0G41Ykp
         S2ejLI8XMS4YUc+lMRsIWn0uc7CVSjSzAeAGa27laMge9LsOK2CPGIijmkWa+E7ks4K0
         jJ5r4IpBgYA1ztYzjHeBvXUzdb1kVTFDMdG0Wwao/aFVgz3IeaDxX45YwG1kBfoVjr22
         IQaqs8IXPcgqnbByfxJJ/zRFIJmL6RBbpsQsFv2tYI2QJYdeia+uouapjk95vdMma8/l
         mz3+NKks7GOgRHY2CkxNuKWAPs34MlpC7/xXPigdPv7wQe+sT98EW4iDrialwFEl6PR0
         M5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7F5o5gH/tEwEajzpI7fTjneSGKfDGJAlpNidTq6oDnU=;
        b=SmmL9mvd/4mdRUDlpR+iskhLsGdfsC255WxNb3r/HdWcWOFvybZiryZC8jACkfsxH4
         n2qYXfJvt2M0tMRmJ2Pn0OQYNaVwQLMsiltq9eaKPYhwPhKA+drV4fojUmVp74X4MFbw
         T7aoUT7X+2RlbtNDNR/F21o3XT+w70bVTf7f0c+wRvBHL7yEvKuuQ/ayVzFCJKv/rOo/
         9BGVgNSQxuY/rzuNS6oSqOQBRVgUDIP5OUHQtZv+3Rfzpt/d0E07W9B2yv9FXZVtxRQz
         Oy02sleNi3SAWZoesUipl2d+UK7yIllNzIN9h/o05rBzL/+cnyX4OHSWN9HGLFPUF+VO
         k+TQ==
X-Gm-Message-State: AOAM532gw8Mc7TkqSNQFzJr+o5tEUeOvTMrZVKSLdlpXUMwfSdE290S7
        5VpLiknNUUijIS9Ls8QkYJzTYLrJ5aW+EoYv3vpfzOd8sZo=
X-Google-Smtp-Source: ABdhPJwAwFyKTWZBNEByGdfE4mVSiUP2K7OvxM69x0Fq4mUmGEi6WMVAeDWuVNdDDca6vu4Gvg3YPhC4XatMWkG74EA=
X-Received: by 2002:aca:2306:: with SMTP id e6mr12413148oie.108.1596823653421;
 Fri, 07 Aug 2020 11:07:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200730205112.2099429-1-ndesaulniers@google.com> <20200730205112.2099429-2-ndesaulniers@google.com>
In-Reply-To: <20200730205112.2099429-2-ndesaulniers@google.com>
From:   Nathan Huckleberry <nhuck15@gmail.com>
Date:   Fri, 7 Aug 2020 13:07:21 -0500
Message-ID: <CAN=-RxtoXCG5h2qirsrLG2P37pjjMEHgfAv-7+NSVUy9_LPaYQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: backtrace-clang: check for NULL lr
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        clang-built-linux@googlegroups.com,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Lvqiang Huang <lvqiang.huang@unisoc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Miles Chen <miles.chen@mediatek.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 3:51 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> If the link register was zeroed out, do not attempt to use it for
> address calculations for which there are currently no fixup handlers,
> which can lead to a panic during unwind. Since panicking triggers
> another unwind, this can lead to an infinite loop.  If this occurs
> during start_kernel(), this can prevent a kernel from booting.
>
> commit 59b6359dd92d ("ARM: 8702/1: head-common.S: Clear lr before jumping to start_kernel()")
> intentionally zeros out the link register in __mmap_switched which tail
> calls into start kernel. Test for this condition so that we can stop
> unwinding when initiated within start_kernel() correctly.
>
> Cc: stable@vger.kernel.org
> Fixes: commit 6dc5fd93b2f1 ("ARM: 8900/1: UNWINDER_FRAME_POINTER implementation for Clang")
> Reported-by: Miles Chen <miles.chen@mediatek.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  arch/arm/lib/backtrace-clang.S | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/lib/backtrace-clang.S b/arch/arm/lib/backtrace-clang.S
> index 6174c45f53a5..5388ac664c12 100644
> --- a/arch/arm/lib/backtrace-clang.S
> +++ b/arch/arm/lib/backtrace-clang.S
> @@ -144,6 +144,8 @@ for_each_frame:     tst     frame, mask             @ Check for address exceptions
>   */
>  1003:          ldr     sv_lr, [sv_fp, #4]      @ get saved lr from next frame
>
> +               tst     sv_lr, #0               @ If there's no previous lr,
> +               beq     finished_setup          @ we're done.
>                 ldr     r0, [sv_lr, #-4]        @ get call instruction
>                 ldr     r3, .Lopcode+4
>                 and     r2, r3, r0              @ is this a bl call
> --
> 2.28.0.163.g6104cc2f0b6-goog
>

Reviewed-by: Nathan Huckleberry <nhuck15@gmail.com>
