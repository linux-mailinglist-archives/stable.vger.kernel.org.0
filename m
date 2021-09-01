Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED2E3FD1AE
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 05:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241782AbhIADON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 23:14:13 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:41668 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbhIADOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 23:14:10 -0400
Received: by mail-lf1-f48.google.com with SMTP id y34so3326540lfa.8;
        Tue, 31 Aug 2021 20:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=d55o8VRMccw0pmcvesAE8Rz9x+AqcwcttzF+pmxCfek=;
        b=E3BLgVvx+QOcTFO4S7s0rxlsuZ7TLLseKvuc3NCkzFENw07eXkgbCM+madxtJYH9PI
         WFGBEDRuaIU6T4La6kQMg2zzL1j5vkk1R+SglmjrVSJkn/970a5+XpNMV2sqfhi6FH+Y
         Vru2C8tG+VsJLwdExrR0ajywplEdUWr9aVSx27FXOhDfML3WnNpDj31oI17DU5Is3ObT
         1xa6/Hwzn69LQidlp1vi7Cys/aSQ8Ty34jgMbhyimPPPWea27BlS40s/GL5nmK/I6Dmo
         8F0o05NQv1d6gVPQZTRV6cLmI2ixiGGeXYAoXGvNabzc4vbHip7Ce/cuzijpNIM38rZ4
         c6gg==
X-Gm-Message-State: AOAM5301srTPIipdVR+SOWf0wjhVhD0VUWfT1BO4tMj+rRBFo4j2JECl
        vNKzsUuDeXLm/92pTMqNEnkOwaNCKMel/g==
X-Google-Smtp-Source: ABdhPJwHLvqZyHza8PQP2FOiCndnruv1kADugN2L1a/jgRvlj4L9sgH/hDIblvQ+/wuVM753QFO1jA==
X-Received: by 2002:a05:6512:4da:: with SMTP id w26mr10844837lfq.576.1630465993065;
        Tue, 31 Aug 2021 20:13:13 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id y35sm2403920lje.127.2021.08.31.20.13.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 20:13:12 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id p38so3508818lfa.0;
        Tue, 31 Aug 2021 20:13:12 -0700 (PDT)
X-Received: by 2002:a05:6512:3b27:: with SMTP id f39mr23258174lfv.303.1630465992483;
 Tue, 31 Aug 2021 20:13:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210831184819.93670-1-jernej.skrabec@gmail.com>
In-Reply-To: <20210831184819.93670-1-jernej.skrabec@gmail.com>
Reply-To: wens@csie.org
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Wed, 1 Sep 2021 11:13:01 +0800
X-Gmail-Original-Message-ID: <CAGb2v67TNrkeP438t3nLcquFvGTfS+F0MvBmGAS=qmZ5JZFmag@mail.gmail.com>
Message-ID: <CAGb2v67TNrkeP438t3nLcquFvGTfS+F0MvBmGAS=qmZ5JZFmag@mail.gmail.com>
Subject: Re: [PATCH] drm/sun4i: Fix macros in sun8i_csc.h
To:     Jernej Skrabec <jernej.skrabec@gmail.com>
Cc:     Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Roman Stratiienko <r.stratiienko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 1, 2021 at 2:48 AM Jernej Skrabec <jernej.skrabec@gmail.com> wrote:
>
> Macros SUN8I_CSC_CTRL() and SUN8I_CSC_COEFF() don't follow usual
> recommendation of having arguments enclosed in parenthesis. While that
> didn't change anything for quiet sometime, it actually become important

                             ^ Typo

> after CSC code rework with commit ea067aee45a8 ("drm/sun4i: de2/de3:
> Remove redundant CSC matrices").
>
> Without this fix, colours are completely off for supported YVU formats
> on SoCs with DE2 (A64, H3, R40, etc.).
>
> Fix the issue by enclosing macro arguments in parenthesis.
>
> Cc: stable@vger.kernel.org # 5.12+
> Fixes: 883029390550 ("drm/sun4i: Add DE2 CSC library")
> Reported-by: Roman Stratiienko <r.stratiienko@gmail.com>
> Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Otherwise,

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
