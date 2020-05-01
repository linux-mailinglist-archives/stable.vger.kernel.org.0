Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463201C1D73
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 20:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgEAS6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 14:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729767AbgEAS6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 14:58:20 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E54C061A0C
        for <stable@vger.kernel.org>; Fri,  1 May 2020 11:58:20 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id s10so7960701edy.9
        for <stable@vger.kernel.org>; Fri, 01 May 2020 11:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anholt-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vt0QD0qGDDBVo/FGY17/QPfRi70EGhMjrVST5CXganc=;
        b=n+VOSW7MD4XNSmZihQfjum+mxK5FnIdMcEiBsOxO2YKarPrGhNRlvcg2KHGBfRAO6e
         4gbTcv566mvkBg2iFpc/NReOVomtY9GLeW4yURrBxLL94iCOMH2NFhidOSWDfOVLE8h5
         QYrYIGtF90V/JseWG8q987eBRh2ABNYDpFCvHQr5VZK4WNOxMrhCyO9RONejoHOPH296
         sHzmULyHaChfwP/e/fMlyiabp3YCA16BBXIfKWM2tDqpwkLKNwN9ZYhLwBrIsHtUfS1Y
         fXdtX4nNCU0HVUP/jeU7v5WrRblEk6xrYarJ+/+Kfdv8tLcKTkqacAqVy9gqdGwqr0YQ
         VRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vt0QD0qGDDBVo/FGY17/QPfRi70EGhMjrVST5CXganc=;
        b=JD4QNMhHdN2zhKo3Nv/2fNenv3KfSHek3UqyDcmDtOfB69drdrpwjneL9Ul+5PUFbo
         K+k/HCVBKapVaqA84eBNdNqM1yYoKdhW5eaezzLCVntoe1yceMAENSw0kibjFL100NwG
         /XaT9edqA619YS3920wxmR9T31/6Xf3N22t/1b/NOS6quG8k7uZcX/Qnu5pDF/kvH86J
         AZ4wg3drK/9dryQLCpZn9FTw1eTXuvmxvLdDTOG9P+ffYd1uaUT0OMcR+EM6tFz4l0dI
         Or2PULVmbnZMkNFC3gScs9GmPz/HzaZ+i+YbFLIVGJXt9A6dnVAWDpahXtHwAk0zGYA+
         N3pA==
X-Gm-Message-State: AGi0PuYYsRpPBTYWRk2JyLiW4Rh2bgjN/dcZtaAVH7o1+DJm2D/SQJsM
        Ys99s8HmYk0yN6X6VbLxbE47PhLJIC4B/Nbi2/Cqyg==
X-Google-Smtp-Source: APiQypLXpYI05phFZgf41A4e2ccy/aLjYv3h3qo7mTf3PdPfV7hhelvJX+6ErvFxVnYeV8WkozZ6Kn83pMp9XjQxpfs=
X-Received: by 2002:a50:aa8d:: with SMTP id q13mr4726587edc.88.1588359499000;
 Fri, 01 May 2020 11:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200501182533.19753-1-jcrouse@codeaurora.org>
In-Reply-To: <20200501182533.19753-1-jcrouse@codeaurora.org>
From:   Eric Anholt <eric@anholt.net>
Date:   Fri, 1 May 2020 11:58:08 -0700
Message-ID: <CADaigPXLOp8+cJ6XGzUm=bmyyhMO2qCGHhgAA44Auq9NvhfFhw@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: Check for powered down HW in the devfreq callbacks
To:     Jordan Crouse <jcrouse@codeaurora.org>
Cc:     linux-arm-msm@vger.kernel.org, stable@vger.kernel.org,
        Akhil P Oommen <akhilpo@codeaurora.org>,
        AngeloGioacchino Del Regno <kholk11@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        Sharat Masetty <smasetty@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 1, 2020 at 11:26 AM Jordan Crouse <jcrouse@codeaurora.org> wrote:
>
> Writing to the devfreq sysfs nodes while the GPU is powered down can
> result in a system crash (on a5xx) or a nasty GMU error (on a6xx):
>
>  $ /sys/class/devfreq/5000000.gpu# echo 500000000 > min_freq
>   [  104.841625] platform 506a000.gmu: [drm:a6xx_gmu_set_oob]
>         *ERROR* Timeout waiting for GMU OOB set GPU_DCVS: 0x0
>
> Despite the fact that we carefully try to suspend the devfreq device when
> the hardware is powered down there are lots of holes in the governors that
> don't check for the suspend state and blindly call into the devfreq
> callbacks that end up triggering hardware reads in the GPU driver.
>
> Check the power state in the gpu_busy() and gpu_set_freq() callbacks for
> a5xx and a6xx to make sure that the hardware is active before trying to
> access it.

Chatted on IRC -- while this avoids the instaboot on db820c when
setting /sys/class/devfreq/devfreq1/min_freq, I think we should be
using pm_runtime_get_if_in_use() to avoid the races while still
avoiding bringing up the GPU.
