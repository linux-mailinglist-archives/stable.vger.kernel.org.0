Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3723FD61C0
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 13:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbfJNLxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 07:53:09 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40912 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730335AbfJNLxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 07:53:09 -0400
Received: by mail-lj1-f193.google.com with SMTP id 7so16323277ljw.7
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 04:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BUUSXCx6hkqJbTEWpOdC3FCy26W6ddQaFzU+/nbRFVg=;
        b=YhJw+dADb1GVJrtNlGRG/Y2ls1HP18kIPeidp6Po7LqQHPgDXNvFowqAC5pRd2b+ra
         eDYteQDZ/kNlq2ma7V1mrjosG0xqe5HzfX8QxkdKb2Sw+e+tskaf4MRnSSB0A9y9ymGR
         TX/H46WAUITyWlFBjvXWC1Dgx1OV1xoCrScv8XA84hYySIjqUKrqazRvbVGaHFi2Aubc
         QbvN/rhu6irogrlFCACX8KaCCD0U6qqukDk60xBeil5vO9VAMP9vzKD6ABoqL+7Te5x5
         r3QmpYDcWnhUrXtQ6LY81UX7UpDq+HJ+2JzPawwphbOr9UZuVGQ8XRUD/UoH9qKlTgtT
         8XNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BUUSXCx6hkqJbTEWpOdC3FCy26W6ddQaFzU+/nbRFVg=;
        b=Hi524yPQ3yaoqsfxrv6rqjeOc7OfBEVKIakjWg4wq6441jKLVd44bb+WS/lEYyx6wg
         C/xTHJ0Q3HFoRhJjTTl2p5XVrrjxCb0TmXWr5wmS6guxYjzOYOecQaFT2qqbmqKp/4g3
         Qfdc/5N84wQN/ryKHHabTmWLq9DNpP3j63DPMtK9iOpI0d2a3puiwVGkam236Gsf5TLG
         w34/0Fys5iGoCehFiZraq5mhJX6xuH7hd4cACyZ5k4Q2IH2m8y/va6mE1WCTvVJt1xRx
         xpaaAoSo+SE23T8JQqV4ny5KhlSOI/+fjPCGsmwyId0oNwyZTzX6LjvEySndk/4gY/W6
         /Osg==
X-Gm-Message-State: APjAAAWs6BJjW2kWu5fhm5kQsn29cgjF91RU49sbQpSLpEsWfE1PrSc+
        Y7QZ1i6EssocSMY/Zi6CbcNlemnAjuCD0xZnJDnsnQ==
X-Google-Smtp-Source: APXvYqz8u5CvuNfqAA4R48grRt6sZXO4XODyM/njd2C+ebU9VV7lVNOLV1asO7f0AmCDGt9XNJlYDIVpjW788PlsTlE=
X-Received: by 2002:a2e:978e:: with SMTP id y14mr5840922lji.206.1571053985940;
 Mon, 14 Oct 2019 04:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191014114710.22142-1-valentin.schneider@arm.com>
In-Reply-To: <20191014114710.22142-1-valentin.schneider@arm.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Mon, 14 Oct 2019 13:52:54 +0200
Message-ID: <CAKfTPtCtT8+qTHSvwBXfV1A6e4V_m=A7JmS_g9QWY4AGAvWtpQ@mail.gmail.com>
Subject: Re: [PATCH] sched/topology: Disable sched_asym_cpucapacity on domain destruction
To:     Valentin Schneider <valentin.schneider@arm.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Quentin Perret <qperret@qperret.net>,
        "# v4 . 16+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Oct 2019 at 13:47, Valentin Schneider
<valentin.schneider@arm.com> wrote:
>
> While the static key is correctly initialized as being disabled, it will
> remain forever enabled once turned on. This means that if we start with an
> asymmetric system and hotplug out enough CPUs to end up with an SMP system,
> the static key will remain set - which is obviously wrong. We should detect
> this and turn off things like misfit migration and EAS wakeups.
>
> Having that key enabled should also mandate
>
>   per_cpu(sd_asym_cpucapacity, cpu) != NULL
>
> for all CPUs, but this is obviously not true with the above.
>
> On top of that, sched domain rebuilds first lead to attaching the NULL
> domain to the affected CPUs, which means there will be a window where the
> static key is set but the sd_asym_cpucapacity shortcut points to NULL even
> if asymmetry hasn't been hotplugged out.
>
> Disable the static key when destroying domains, and let
> build_sched_domains() (re) enable it as needed.
>
> Cc: <stable@vger.kernel.org>
> Fixes: df054e8445a4 ("sched/topology: Add static_key for asymmetric CPU capacity optimizations")
> Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>

Acked-by: Vincent Guittot <vincent .guittot@linaro.org>

> ---
>  kernel/sched/topology.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index b5667a273bf6..c49ae57a0611 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2123,7 +2123,8 @@ static void detach_destroy_domains(const struct cpumask *cpu_map)
>  {
>         int i;
>
> +       static_branch_disable_cpuslocked(&sched_asym_cpucapacity);
> +
>         rcu_read_lock();
>         for_each_cpu(i, cpu_map)
>                 cpu_attach_domain(NULL, &def_root_domain, i);
> --
> 2.22.0
>
