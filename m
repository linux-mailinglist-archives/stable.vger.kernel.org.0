Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A88D3E8BB7
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 10:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhHKIZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 04:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhHKIZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 04:25:09 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611E8C061798
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 01:24:46 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id c24so3944332lfi.11
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 01:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GVm6z+/Bdr1n5Fxa4kSmJVT5Ljn0y9dUOJYnV8Z4PAA=;
        b=npDtkwz0NnMywdciIG5W0LkfTTOnjggjeCnH3sgoLPN5Hccs4URBbWq0lmrVIjgkvq
         xbw1AbzO+nfE/1+yQfqze5oHl+jtYm8kIc0fIISaS/9tYulHcumxsocgP8gWH6N384vJ
         /wcpWMM9natlQocS/RkP4b+cv2u+VIoEG6se5sHXdymoQP6TbjNPWzqaYk1u1mIzV1m5
         k/VXeVLYNelL05P2GONZFDXEVKbEMZuK5Wdc/nVDbRe4k2XMzG2/KcI8HKBwvc/QK+7R
         Xaih6iEM4iWlhD2N2TbtPpV0Txi6EiQpWa5BMj7p3CWEQ5XAdC2r9qfcwTXEOKqm33+t
         m2yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GVm6z+/Bdr1n5Fxa4kSmJVT5Ljn0y9dUOJYnV8Z4PAA=;
        b=S7dus53WWGsR7eRv2meAhgK0UWwtpdji/OXxmM4kJX9gsQEZMSBG+y1Xd3ZrbbFZxz
         WMVWSm5qFWbBnUD/kKZRv9d+/lCeIVG3l9Cr7OYzRLWk9z4vQglGGmGvoJ/XRNEK3BRR
         dFDetWuwPfVZ6EmVLwvcx4r+fynFrtFrzyN8N9dboQQbKvvCEsr1X8vBmZv0SIumRN3Q
         VOFxZLJXIK1LGm+ji1tmcjayEbRdaFtdCbQm1dScDId614/jo3u/lw7v04Pv7VMmJa+o
         DVe1rSGj/J7/ySmlqD6LpfHkWXf4XabFWlaX7uODrxI71HiqN3vqAbQXPJ7MsIJkpGLY
         fA3A==
X-Gm-Message-State: AOAM5319UK3uFwrE39NDCb03m6dGRN1HA7w15sf9XWOKEdm58kGoflwZ
        eAZuQOiY5fKPtJKd4UAS79u7lhUAveOl28KQJ7KgOQ==
X-Google-Smtp-Source: ABdhPJw4NdVqOP8gfyXv+14MvH9T3lyPveKwazy7JVk+5XTR/vz5E6tNfn4zvYKymCGWRbOp10vWB0/n7S2SBJmBe0Y=
X-Received: by 2002:a05:6512:132a:: with SMTP id x42mr24116051lfu.291.1628670284748;
 Wed, 11 Aug 2021 01:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210717174836.14776-1-paul@crapouillou.net>
In-Reply-To: <20210717174836.14776-1-paul@crapouillou.net>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 11 Aug 2021 10:24:33 +0200
Message-ID: <CACRpkdakKpyb375DY+D5BgS6NK4c_LoLRmQ_hh-F8KQpR_wtvg@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: ingenic: Fix incorrect pull up/down info
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     =?UTF-8?B?5ZGo55Cw5p2w?= <zhouyanjie@wanyeetech.com>,
        linux-mips@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 17, 2021 at 7:48 PM Paul Cercueil <paul@crapouillou.net> wrote:

> Fix the pull up/down info for both the JZ4760 and JZ4770 SoCs, as the
> previous values sometimes contradicted what's written in the programming
> manual.
>
> Fixes: b5c23aa46537 ("pinctrl: add a pinctrl driver for the Ingenic jz47xx SoCs")
> Cc: <stable@vger.kernel.org> # v4.12
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Patch applied!

Yours,
Linus Walleij
