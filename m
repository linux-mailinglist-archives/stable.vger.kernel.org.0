Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BEE23DE56
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgHFRYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729880AbgHFRDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 13:03:36 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44517C034628
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 06:43:13 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id 88so44020221wrh.3
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 06:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mmxr6ODtW3F7I7f0JcLe8XihaHT+mhwOKI2TY5ezmF0=;
        b=EZtQDYnhnqdiPVVm7psBtCS+W7AG95jrxdC4x1x5RLLg3Vu1l/BqvE2qxkDjpMhICE
         WRx0siJqzd4OwvmT6V/B/CQkKvWNFpK/GBxK2oVnJJMtyADKHMZthR973/Ey75Tx3Hwn
         NH6rfgsciGnQsqYqudbAXrq7pZyt0CcW9xRvRdRVZk2cU1t7hkvkR/njYqTESIQkzCa1
         AG+DaWTtO4yJgyyN6HBnKA3zj2yhdQ4f6ZzHNCf5ILQvUnQOYhC4Th65qzeGPdYwz7F1
         dJjYCckKLF68h9yFFbOc5RockzDMlzTF7nDEVOk8sor5yH9R13t2cPy3sMsFyFbBY1Q+
         XgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mmxr6ODtW3F7I7f0JcLe8XihaHT+mhwOKI2TY5ezmF0=;
        b=CpMuG7k1OlvRfgSLuMuNCuBJW4wKkecC2SM/0EjIm14WB6CrbFHzZMtZYA/d9Goga0
         xqdM56UHpLawH+Efy18OxDaPwVulaF/YrOP1+kWJCcqVu+SBrHaiBPxARY3KkhDlTXAD
         kva/RI635qgRQgKosi1oGeTTrR3x70tYOqw1mXut3UWJya26OUL4sr1ukUsXKKM1fkfx
         2e2S8fKgRt8JoYEim0jctr8yNcMsCRPNmSx/tkde14wh2Lt6wwRm1RFev8UiAF1Zo5AF
         qW9278Rh6k6RUtwRO5vZd6bxEEEroiVagOC396fXwaflghiX3VvnjUnW33NWKCBY6YJB
         jBsA==
X-Gm-Message-State: AOAM5329ZFlOT5IcMjRL/5FX6Zr8eA9Le+vFLDqCmta1DxGISbQTT2Kh
        QOXf3ActVwXZLP5gLPZ3CDAJ3PQU688b/6AjbrI=
X-Google-Smtp-Source: ABdhPJwvwTP0QUORbCyKyPgOqHMwSNKx90drUplBvqE9YxC2Fsqr6u8rqBsK9csrVOEoXYR7zDBfxo0oAgOaOWvLVbU=
X-Received: by 2002:adf:fd41:: with SMTP id h1mr8042434wrs.124.1596721382136;
 Thu, 06 Aug 2020 06:43:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200805215700.451808-1-alexander.deucher@amd.com> <20200806070103.GC2582961@kroah.com>
In-Reply-To: <20200806070103.GC2582961@kroah.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 6 Aug 2020 09:42:51 -0400
Message-ID: <CADnq5_N0P8S5X4bqsavjNJ5KgZUKN=3cDrigiH=W8-3PiEv49w@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: fix ordering of psp suspend
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "for 3.8" <stable@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 6, 2020 at 7:10 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Aug 05, 2020 at 05:57:00PM -0400, Alex Deucher wrote:
> > The ordering of psp_tmr_terminate() and psp_asd_unload()
> > got reversed when the patches were applied to stable.
> >
> > Fixes: 22ff658396b446 ("drm/amdgpu: asd function needs to be unloaded in suspend phase")
> > Fixes: 2c41c968c6f648 ("drm/amdgpu: add TMR destory function for psp")
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Cc: stable@vger.kernel.org # 5.7.x
> > Cc: Huang Rui <ray.huang@amd.com>
> > ---
> >  drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
>
> What is the git commit id of this patch in Linus's tree?

It doesn't exist in Linus' tree.  The order is correct in 5.8 and
newer.  The order got reversed when the patches were applied to
stable.

Alex

>
> thanks,
>
> greg k-h
