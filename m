Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AC7216C23
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 13:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgGGLrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 07:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbgGGLrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 07:47:46 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE4DC08C5E0
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 04:47:46 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y18so24514742lfh.11
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 04:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H31qO9mIhZa8mYSQsZNVqE+31tdLenCwSf5kmSoOfwM=;
        b=sQs8aM6fKHIQiqDAeBYhbK8/IcCikVwpSJBAz8Vm7OIXiet8/MSv6Wig5gdT7jXE7Z
         A3cQubcZ8i8CnqiA6c+JlRxHdO9bIc7UTSwvW9YAGOPdW8xSDteGUMk1iE55ryLq1zhw
         /Q5xc06TFPTkJIdNNz5jC5AvdkUcnM2+SzoS1YH7efa/5XMMAwLNC5In+xwUuDKQ1Ui6
         iG8vYYzHC5y/duMI7TEKx67+xsDQiCIMNeYdjEdtFE8sGxgvQjXkjk8B0or94UzwPHhT
         oFSUjIBLiQVtCZzci0PpKrd6w7c4huuUd06SJZf9b8rH8azxPsbCjGIhH74lbC8MLlAj
         s53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H31qO9mIhZa8mYSQsZNVqE+31tdLenCwSf5kmSoOfwM=;
        b=hN3l609edgHICtTzwvLgPQGILHo4GyjPdQV5paqpsaMWAck3qTLXLye0/uBIVmWsV9
         1zAozQGLArdMSOnu38BzaHxpRVfR3hl4eTcgWU5mTZ2O8uStkNzRl/iLK/ay7/f50CiT
         WjMkwb0BV2AZPfC6C+YneNXNHW//L42sMzl6NIpIJjqVNOeldt3QvM/yHqNToRtWT4d1
         70x4Nqy5MTSAN6L2WXptqqVBfII/Nso1Qwp9pnxkuciNrlR5BAMRGUxAYtb9cP9NI9oN
         SKyRJfEfPXbE6KxOqu74DNmD/9nzBt/v/hNlL/LobWpn0SgFr7cBewLg+AQGa+bRADX9
         JIkQ==
X-Gm-Message-State: AOAM530k/1tX6QMKunqJqls5zk+MIcf/GDb2UwjQIG1eqbeVXfqmuZMF
        GekBmg7YXIo4P1+IjS42KvBuPlUs6UigHk37bSyL+g==
X-Google-Smtp-Source: ABdhPJxvak0DTuQbCCiRuOe2HWkQ0l0ImblSKrDKYrp0nX4jzJvM6lIpOEX1oqU3vLADw7kPGiebDvdnOG4Pw/ijD6g=
X-Received: by 2002:a19:745:: with SMTP id 66mr32853284lfh.77.1594122464864;
 Tue, 07 Jul 2020 04:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <TZHZBQ.SOVDZ4DJB30O1@ixit.cz> <87tuz8b4gv.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87tuz8b4gv.fsf@nanos.tec.linutronix.de>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 7 Jul 2020 13:47:34 +0200
Message-ID: <CACRpkdYVQzdBJkAwB=uB6AFm2dC_tzpMRhefYWbVfGcAVxJ2pw@mail.gmail.com>
Subject: Re: [PATCH] irq: Request and release resources for chained IRQs
To:     Thomas Gleixner <tglx@linutronix.de>,
        Brian Masney <masneyb@onstation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     20181129133119.29387-1-linus.walleij@linaro.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 8:42 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> David Heidelberg <david@ixit.cz> writes:
> > is there chance to get this patch included or could be this issue
> > solved with different approach?
>
> Included into what? This patch is incorrect as I pointed out in review
> here:
>
>   https://lore.kernel.org/lkml/alpine.DEB.2.21.1812071143480.14498@nanos.tec.linutronix.de/
>
> So why are you even asking?
>
> I recommended to switch this away from chained handler and then the
> whole story ended with this mail:
>
>   https://lore.kernel.org/lkml/alpine.DEB.2.21.1812071404140.14498@nanos.tec.linutronix.de/
>
> I have no idea how the GPIO people solved that problem, but certainly
> not by applying this.

We didn't solve that problem.

The reason is that changing the platform from chained to regular handler
involves of course changing all the other drivers in the irqchip hierarchy
since chained is an all-or-nothing approach, and that needs to happen
over the whole set of Qualcomm drivers.

Sooner or later I guess I will get to it unless Bjorn or Brian or someone
else beats me to it.

Yours,
Linus Walleij
