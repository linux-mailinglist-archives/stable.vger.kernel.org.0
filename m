Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD2040FFF1
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 21:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343938AbhIQTsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 15:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbhIQTsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 15:48:39 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C478C061574
        for <stable@vger.kernel.org>; Fri, 17 Sep 2021 12:47:17 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id a22so13598769iok.12
        for <stable@vger.kernel.org>; Fri, 17 Sep 2021 12:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g8Bx21q9AegTNE96Id2UsXZWLEcvlx6srL/tdQ2snFc=;
        b=kGgzhyObvn1lW/gJ+RXhzVfHISy3GATxp8JdmNf63BrlJVlMbyqBEQDh7RDkv4cAXH
         X9OXee033T64nAchCmg1+6jzJCr1SRcQP2F9MGZqP7Eqin1x63jvVJosLTCIkz5RcvHi
         Y6mPRaoArbvLDYeOY6E9zNYQRr+n1lH+4eHa50Qyy5C6a7Br4HaiTU0H+V+4+vfZynZ+
         OqZQE0fVK8IAUSsy1+E/Zk+iF0xNI8dgSxhWgoAv6KnlEy25FBu/Xg4k7UlKfyhZqMUE
         1gPlHda5QsO3nqdwPyy4/oW7q/l8jcUA/zD1DCvCwnebnaFqXjWL/ETyYrZdp2jKYPz9
         bG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g8Bx21q9AegTNE96Id2UsXZWLEcvlx6srL/tdQ2snFc=;
        b=6HzLcZewLMOt2dtYf/W0jiKKExu2y488MnBD+0a0e0x5cqusHiPqJ/MxZvVNMSsNol
         AqW7OHWX6K1ltFk7Xo7v0+h9ss6avUbrfyBDQuGhjn/4sLZvRBEkOFNoeF3+AhNMQgVb
         f/kNWMsNAwnnsTgrYLwwwq327tFEo/ycb9UUK7wVpNQ93ne23L0FcMFcHJx5T7dTcpQN
         ahPyl4r0ZPGGT2ABzRwGa4m9BfzSAHnToNuIG7vYJzzbZ+ja1OzRTmutqPYwtZvRyOHT
         byi+3QG0W2B61u4KUgFucnaziE9UQCvyUxptrXCjDH41186yOBcwLwnmGAuXvTI8y3qb
         Blww==
X-Gm-Message-State: AOAM530PRvnnHkXTxaDItsSOnDwEriR3yYvPQEUGsLMpG9cOfmwVU++r
        8ZOA+yQRzI2se0py6LvuDHMsXmnK+EACnZmfRPBKuQ==
X-Google-Smtp-Source: ABdhPJwlqiUPgqafzcRoI/Vt7FtGYlqc/TTt/M861o6pVpZ3f/jQrvfR3OcST2CA2oIONVj+WipQ1zlF9ce7+eUeaBg=
X-Received: by 2002:a6b:5913:: with SMTP id n19mr548941iob.91.1631908036562;
 Fri, 17 Sep 2021 12:47:16 -0700 (PDT)
MIME-Version: 1.0
References: <20201217140933.1133969-1-robert.foss@linaro.org>
In-Reply-To: <20201217140933.1133969-1-robert.foss@linaro.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Fri, 17 Sep 2021 12:47:05 -0700
Message-ID: <CAMn1gO4y6yC0fcLYdGfYR4KqPq9Ff0n4DhEczWQh9J6ceobs5A@mail.gmail.com>
Subject: Re: [PATCH v2] drm/bridge: lt9611: Fix handling of 4k panels
To:     Robert Foss <robert.foss@linaro.org>
Cc:     a.hajda@samsung.com, Neil Armstrong <narmstrong@baylibre.com>,
        Laurent.pinchart@ideasonboard.com, jonas@kwiboo.se,
        jernej.skrabec@siol.net, airlied@linux.ie,
        Daniel Vetter <daniel@ffwll.ch>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Anibal Limon <anibal.limon@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 17, 2020 at 6:09 AM Robert Foss <robert.foss@linaro.org> wrote:
>
> 4k requires two dsi pipes, so don't report MODE_OK when only a
> single pipe is configured. But rather report MODE_PANEL to
> signal that requirements of the panel are not being met.
>
> Reported-by: Peter Collingbourne <pcc@google.com>
> Suggested-by: Peter Collingbourne <pcc@google.com>
> Signed-off-by: Robert Foss <robert.foss@linaro.org>
> Tested-by: John Stultz <john.stultz@linaro.org>
> Tested-by: Anibal Limon <anibal.limon@linaro.org>
> Acked-By: Vinod Koul <vkoul@kernel.org>
> Tested-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

This landed in commit d1a97648ae028a44536927c87837c45ada7141c9. Since
this is a bug fix I'd like to request it to be applied to the 5.10
stable kernel.

Peter
