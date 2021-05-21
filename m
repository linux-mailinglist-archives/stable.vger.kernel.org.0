Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9103F38C588
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 13:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhEULTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 07:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbhEULTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 07:19:21 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AE8C061763
        for <stable@vger.kernel.org>; Fri, 21 May 2021 04:17:58 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id s1-20020a4ac1010000b02901cfd9170ce2so4490895oop.12
        for <stable@vger.kernel.org>; Fri, 21 May 2021 04:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EcIp8WA1WHrJEqMIlaVs2ij19F6h1FeNiLm8T3GjEDY=;
        b=gFmVEQZvD+AQHMdUJsoBv5RTf3kX2ozOsQ823fwsAf3l6XUyw97ke6ACIhTPJKpBgh
         wW9mdj6xBW9Aezn1Mzr+2ehoSfa27rNt5CGgwMz29mEoI4kptCCYhxnwOhTAdw5MlKZJ
         hl/Vvobs56pvLesJ9xjlrYHVK4njrrcGWDkBP0o7mryY2zfOzCab22xSH2X6p5SCDH1d
         2uUQ0lUt0PltMWGXkqOQwRUDnHdY7aX2wWwJOuaO6XWNCU3PFTAiZfDRAoYV8FjRhHU5
         hpWGlwDegjoE4JaCzJY5K7RBY3lu7LGkASVYncb5IR2I1J+V9qAxv1CpRW2SrrKd7Aqo
         g+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EcIp8WA1WHrJEqMIlaVs2ij19F6h1FeNiLm8T3GjEDY=;
        b=LtHO7Lw2/ckmtrcLZgpijM4xWF/gele6JUucxm8fPwq7OU9Sq7H49XSYHpIL3o+LAt
         qkrML2yQomg94mH9aeNXyDkO8NUGiaLHaHFNLX4zp8CHfgr0GUO4NLC6H0JKyDAJMlcz
         K+sxqLYSmN2mtuvl2B25At5U2gU4WW8T5uvHbth/KCD0YsFAwfLT+UoO9bUX2XUR1AFP
         +T4yud+X1ztqejMjP86Po8oYlKpimahe53h9dS7uiYELU6tVvacWYQ79uSEYmNG1ehfM
         jJZh/fnRQI4hMucQIXZVUCf0dD2es/oO2I4fkuJt/GjDvIluSSMv+6vgEfKxP0rqGRQV
         ci1Q==
X-Gm-Message-State: AOAM5311WyfJfX/bap/L8rGvZ1nJeOF2b011VIYMyD+xQQuu+BToheFa
        2D9qp3WVyiUXbe8HmzuF4LjhHLfwDIW5Qi6eHm3whQ==
X-Google-Smtp-Source: ABdhPJw8SJYXkQFKjdyvexxkcKn4vgnDN+xTtCy93UoM3eGHgFr6VjCvHqXfF8ZFZBoC62/obPHq3PSJt/HRt1kic/Q=
X-Received: by 2002:a4a:cf15:: with SMTP id l21mr6404487oos.36.1621595876593;
 Fri, 21 May 2021 04:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210521083209.3740269-1-elver@google.com> <20210521093715.1813-1-hdanton@sina.com>
In-Reply-To: <20210521093715.1813-1-hdanton@sina.com>
From:   Marco Elver <elver@google.com>
Date:   Fri, 21 May 2021 13:17:44 +0200
Message-ID: <CANpmjNMD58SJPeVnKrx1=mXoudPZFs+HoCsVujYomCtZ5K+DKQ@mail.gmail.com>
Subject: Re: [PATCH] kfence: use TASK_IDLE when awaiting allocation
To:     Hillf Danton <hdanton@sina.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Mel Gorman <mgorman@suse.de>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 21 May 2021 at 11:37, Hillf Danton <hdanton@sina.com> wrote:
> On Fri, 21 May 2021 10:32:09 +0200 Marco Elver wrote:
> >Since wait_event() uses TASK_UNINTERRUPTIBLE by default, waiting for an
> >allocation counts towards load. However, for KFENCE, this does not make
> >any sense, since there is no busy work we're awaiting.
>
> Because of a blocking wq callback, kfence_timer should be queued on a
> unbound workqueue in the first place. Feel free to add a followup to
> replace system_power_efficient_wq with system_unbound_wq if it makes
> sense to you that kfence behaves as correctly as expected independent of
> CONFIG_WQ_POWER_EFFICIENT_DEFAULT given "system_power_efficient_wq is
> identical to system_wq if 'wq_power_efficient' is disabled."

Thanks for pointing it out -- I think this makes sense, let's just use
the unbound wq unconditionally. Since it's independent of this patch,
I've sent it separately:
https://lkml.kernel.org/r/20210521111630.472579-1-elver@google.com
