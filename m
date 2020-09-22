Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62792748FE
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 21:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIVTWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 15:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgIVTWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 15:22:41 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DF1C061755
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 12:22:41 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so18300761wrl.12
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 12:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fooishbar-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I3TzcxT+agQSzXap31GmXBqpQ5l+VuHWFFx46ZHwwbk=;
        b=0/AizksPP03va9xtTssFRnX0Nfgr7YhRF6a60XPsQPz+YAg6xKJPbUiqNqcJQCrpCJ
         L21Q17H64vLFWtNoNGlS9OFFKfMtvaekSfmjKWajS+pnMmS7Z5Ker0COQk+f5gFfrGkv
         HKz8d+SL7byDfnGFj4FZDz85iyVQXJ5NAq9Jt8H/FBDtjBleZ5w048dhAwivsMwOSTwm
         TX/XL/dF3vDxLvEG2owC6aa4rgMMR/++gZ4uBaaMoBXQT4F1n8YYhTNMqmJwjM3dTjj8
         OhyayKxwX2aV/YpnW7znBPqnlbktcmx4FweomQq+ZOXQGpweKmQEScJ7O9sbcM5aHKqP
         65zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I3TzcxT+agQSzXap31GmXBqpQ5l+VuHWFFx46ZHwwbk=;
        b=p1wGF+YCV+/HA5H9/TLmu0WvOerCwK9ayshXCYbPHsWkFvmAw2MMPJnlmGYptwtRuh
         oyl9A7K+pWOkLeRcni9vQ1tn82rMSA1cdJjNNkqSwcq7m3pj4DrZXny6/ka3ByW2Gx6N
         vh3FQMzfBWTrGFE2d0S25H3/kgdsF3Y26vWNiC1sY5zRvjMgctmqrXVTcsbTI8JXoZHt
         3/ACpb0PNGYpbMjJS7qmB6ewMKmQg6BffGWS8MU/xydCwJLC7Td7DbZCXpXFjQK7deuj
         0McRx4PH8HIdMIPik/X3qMTm4KUXmozJkzKxBBF4/VDiDqJP1itfY2/n8byvy8IaNrlH
         Dvqw==
X-Gm-Message-State: AOAM530pGNC+FsMOf+OmyTIXgQN5FnCEmzf6khy6DGreXHmDQANvEE8+
        A95YoFEj9X2MxlS9h8TK1sMklf0jHukYDDN1rA5siQ==
X-Google-Smtp-Source: ABdhPJyOWSJqfljRuC2AmZxTrv6cdELKH1mZZGRhKl+KB3PwLlQsNSaHT7K6ID4ys3oDH2QukhpyqqmVrOQGGDMuPBY=
X-Received: by 2002:a5d:608f:: with SMTP id w15mr7005612wrt.244.1600802559703;
 Tue, 22 Sep 2020 12:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200922181834.2913552-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20200922181834.2913552-1-daniel.vetter@ffwll.ch>
From:   Daniel Stone <daniel@fooishbar.org>
Date:   Tue, 22 Sep 2020 20:22:28 +0100
Message-ID: <CAPj87rP1uBqhhBfJ0phSaOfoAptauTmeOkk_uD-N2kCCnH=_tw@mail.gmail.com>
Subject: Re: [PATCH] drm: document and enforce rules around "spurious" EBUSY
 from atomic_commit
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        Simon Ser <contact@emersion.fr>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, 22 Sep 2020 at 19:18, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> +       for_each_new_crtc_in_state(state, crtc, old_crtc_state, i)
> +               affected_crtc |= drm_crtc_mask(crtc);
> +
> +       /*
> +        * For commits that allow modesets drivers can add other CRTCs to the
> +        * atomic commit, e.g. when they need to reallocate global resources.
> +        * This can cause spurious EBUSY, which robs compositors of a very
> +        * effective sanity check for their drawing loop. Therefor only allow
> +        * this for modeset commits.
> +        *
> +        * FIXME: Should add affected_crtc mask to the ATOMIC IOCTL as an output
> +        * so compositors know what's going on.
> +        */
> +       if (affected_crtc != requested_crtc) {
> +               /* adding other CRTC is only allowed for modeset commits */
> +               WARN_ON(!state->allow_modeset);
> +       }
> +

Can we please add a DRM_DEBUG() here, regardless of the WARN_ON(), to
let people know what's happening?

With that, R-b me.

Cheers,
Daniel
