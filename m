Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E7D3F6724
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240428AbhHXRbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240535AbhHXR3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 13:29:05 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A615AC06114A
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 10:00:52 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id p38so47036922lfa.0
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 10:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dL9ba3yUu6lSJ0YhxN/X5vzaVX0fX38NNuDKyk4dZZI=;
        b=YZ4Ro47ELEDWuai57Dne3vrEso9qPxNoHIDO/4mRCB5MMRJWwZ2M3peJcvzynsOo5y
         Pqo3xyqBOUtVLE7GPn/c0Zmdrl71Re2BysX+3tnTueSeITJtmfqTf4nJVt6uys7Mab7m
         X4wADbNkN2ugEPhpsNnPSAA7HVwg+MA8y2eVM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dL9ba3yUu6lSJ0YhxN/X5vzaVX0fX38NNuDKyk4dZZI=;
        b=UHwWj9pAbILBfgROlhDrOea88DHX+tnlZdDPGn48cFm77/ow7xXWf/G2wFKx3z+tSd
         5L9XF+xbGh/aNCpnTYOgaoG595hyWhDTCIU06RAm//uQ5d0nXM3vGmBpZemUmit1zUZT
         rBRLYGneNy7BUKA0yDnVgsXffobrV012CiTzcTfIlfUyiQDhpho27qGEuAmLnqZnPR57
         63Xp0iCcmUWnauvAvyRH5dNDEgyB5+8PRsHmt5sgz+32XPyIsdjWAQxPsitfgsBXf4EN
         GVQOdlu0VyRq45SMtIxBXqJSnX7/y0y84FcSAMULRxLat2pdcaBtf6tzbOhjHxFl4hwn
         Gn0Q==
X-Gm-Message-State: AOAM533z2tFTShEsIcR/5uk/JZ7T3Mc+ZW4akexJxT8+KdUnYmTtgPBD
        gCwyLldA1A2mKAzKLa4FHRYslQqDRy1vk/uH
X-Google-Smtp-Source: ABdhPJzzpQ55ZaIfgwj4KXCSLOkUHKu5GWyJzzqb0x2KfcP3HFsapQkOfC2fZRXTNEEJogV3qo/eew==
X-Received: by 2002:a05:6512:3991:: with SMTP id j17mr22355723lfu.374.1629824450587;
        Tue, 24 Aug 2021 10:00:50 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id 4sm204373ljq.99.2021.08.24.10.00.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 10:00:50 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id i28so38809425ljm.7
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 10:00:49 -0700 (PDT)
X-Received: by 2002:a2e:3004:: with SMTP id w4mr30290770ljw.465.1629824449585;
 Tue, 24 Aug 2021 10:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210824165607.709387-1-sashal@kernel.org> <20210824165607.709387-74-sashal@kernel.org>
In-Reply-To: <20210824165607.709387-74-sashal@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 24 Aug 2021 10:00:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiQhb689WEk__vLy-ET4rL69cjq39pGTmrKam=c_0LYGg@mail.gmail.com>
Message-ID: <CAHk-=wiQhb689WEk__vLy-ET4rL69cjq39pGTmrKam=c_0LYGg@mail.gmail.com>
Subject: Re: [PATCH 5.13 073/127] pipe: avoid unnecessary EPOLLET wakeups
 under normal loads
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        Sandeep Patil <sspatil@android.com>,
        Mel Gorman <mgorman@techsingularity.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 9:57 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
>
> [ Upstream commit 3b844826b6c6affa80755254da322b017358a2f4 ]

This one has an odd performance regression report associated with it.

Honestly, I don't understand the performance regression, but that's
likely on me, not on the kernel test robot.

So I'd hold off on applying it for now. It *might* be some odd test
robot hiccup, but ..

          Linus
