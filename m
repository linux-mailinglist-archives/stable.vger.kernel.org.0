Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F0B5A75D
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 01:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfF1XDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 19:03:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53446 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfF1XDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 19:03:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so10532544wmj.3
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 16:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=evLd5fuBi/6693RrazYIrEMj1Q5RZjaPJkFls4ewXBM=;
        b=qeakDdgKB5w9Hmsi+xzjcS5m0U0+VO2ERiaiLxNeUpDZBuCOCywA7CeFkOTkdYZMEl
         g3is6OrREW+twxkAj8x5tOu3ZPABxzx5BBYLvPsm+JB7wI196Urm+3SiYxIYd5dFvpLD
         a3CODGnMcPhDEU5mTufi+dsKBzm4F/UqzQe//blNUuiGLtvowAg377iHWEnSpZhD/o66
         VIyEX6D1SH0HNyIUcFcM36ZY8xt+6FQ/MtGc4bHD57wIKi4f4L9D08VK+BMzHa6/uUTu
         7xCVNfSRd93ScSiLPHIFRp4wARaLSTxjEgZ/wD9k4ByMh/jW539s2GiMfrRRjXqksxhv
         W55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=evLd5fuBi/6693RrazYIrEMj1Q5RZjaPJkFls4ewXBM=;
        b=b7ZKvt3l81rM7dPQvisxKTxXnA+a6TprBYmvTudDUHjkjwQvwesdCjZMpCHmqyldau
         /TSDLWzPISDq1nG6yuEECMX/vxQ/tXBFWMKPcqPXX15z/mqCWoMW4yme6YrG42cdw58I
         3qMFyCQrq466UOnM9ZvP5/Zz6FeRfBXBnR96PJq7RkvOHMTUvaXtz8bkOCeRn2ECWRsN
         qHqGQTMp2QtbLk5vfbwFHno20yBYYvwGJdv+g+cYHDwlBKR0HE44b5pyEI/0A7AxxjG/
         ORne3ZX5iltdin8eqT8LNcOqJhhCMB5O5HOuPB6SYvczTHuuWQ99vDl94xpc1zFyZcjP
         kYrg==
X-Gm-Message-State: APjAAAWnzmeyLX5clLxQs8Rqi2rN+MipR3Tf+g1DK4msgWZTUKsgnqZr
        +qOocterG3S56uTypQ3EZlduRZTlxecxNtGmsQ3KvA==
X-Google-Smtp-Source: APXvYqxRgj7KT3n/jQByQgPUCRsBOP9jo3SfFB2exGaApvMsicoPI28k+RklEuSAsE+jORUTMAS8wMhvKUyN8wXmzHU=
X-Received: by 2002:a05:600c:2201:: with SMTP id z1mr8099094wml.59.1561763026019;
 Fri, 28 Jun 2019 16:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190628182413.33225-1-john.stultz@linaro.org> <20190628225803.GK11506@sasha-vm>
In-Reply-To: <20190628225803.GK11506@sasha-vm>
From:   John Stultz <john.stultz@linaro.org>
Date:   Fri, 28 Jun 2019 16:03:33 -0700
Message-ID: <CALAqxLX002_9jqCVpZ9esd9xj=ikC4soYDbCKH4etmUDYUXvrQ@mail.gmail.com>
Subject: Re: [PATCH 4.19.y v2 0/9] Fix scheduling while atomic in dwc3_gadget_ep_dequeue
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>, Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Jack Pham <jackp@codeaurora.org>,
        Linux USB List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 3:58 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Fri, Jun 28, 2019 at 06:24:04PM +0000, John Stultz wrote:
> >With recent changes in AOSP, adb is using asynchronous io, which
> >causes the following crash usually on a reboot:
> >
> >[  184.278302] BUG: scheduling while atomic: ksoftirqd/0/9/0x00000104
> >[  184.284617] Modules linked in: wl18xx wlcore snd_soc_hdmi_codec wlcore_sdio tcpci_rt1711h tcpci tcpm typec adv7511 cec dwc3 phy_hi3660_usb3 snd_soc_simple_card snd_soc_a
> >[  184.316034] Preemption disabled at:
> >[  184.316072] [<ffffff8008081de4>] __do_softirq+0x64/0x398
> >[  184.324953] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G S                4.19.43-00669-g8e4970572c43-dirty #356
> >[  184.334963] Hardware name: HiKey960 (DT)
> >[  184.338892] Call trace:
> >[  184.341352]  dump_backtrace+0x0/0x158
> >[  184.345025]  show_stack+0x14/0x20
> >[  184.348355]  dump_stack+0x80/0xa4
> >[  184.351685]  __schedule_bug+0x6c/0xc0
> >[  184.355363]  __schedule+0x64c/0x978
> >[  184.358863]  schedule+0x2c/0x90
> >[  184.362053]  dwc3_gadget_ep_dequeue+0x274/0x388 [dwc3]
> >[  184.367210]  usb_ep_dequeue+0x24/0xf8
> >[  184.370884]  ffs_aio_cancel+0x3c/0x80
> >[  184.374561]  free_ioctx_users+0x40/0x148
> >[  184.378500]  percpu_ref_switch_to_atomic_rcu+0x180/0x1c0
> >[  184.383830]  rcu_process_callbacks+0x24c/0x5d8
> >[  184.388283]  __do_softirq+0x13c/0x398
> >[  184.391959]  run_ksoftirqd+0x3c/0x48
> >[  184.395549]  smpboot_thread_fn+0x220/0x288
> >[  184.399660]  kthread+0x12c/0x130
> >[  184.402901]  ret_from_fork+0x10/0x1c
> >
> >
> >This happens as usb_ep_dequeue can be called in interrupt
> >context, and dwc3_gadget_ep_dequeue() then calls
> >wait_event_lock_irq() which can sleep.
> >
> >Upstream kernels are not affected due to the change
> >fec9095bdef4 ("dwc3: gadget: remove wait_end_transfer") which
> >removes the wait_even_lock_irq code. Unfortunately that change
> >has a number of dependencies, which I'm submitting here.
> >
> >Also, to match upstream, in this series I've reverted one
> >change that was backported to -stable, to replace it with the
> >cherry-picked upstream commit (as the dependencies are now
> >there)
> >
> >This issue also affects 4.14,4.9 and I believe 4.4 kernels,
> >however I don't know how to best backport this functionality
> >that far back. Help from the maintainers would be very much
> >appreciated!
> >
> >
> >New in v2:
> >* Reordered the patchset to put the revert patch first, which
> >  avoids any bisection build issues. (Thanks to Jack Pham for
> >  the suggestion!)
> >
> >
> >Feedback and comments would be welcome!
>
> I've queued it up for 4.19.
>
> Is it the case that for older kernels the dependency list is too long?

Yea. It gets ugly and I'm not enough of an expert on the driver to
feel comfortable knowing if I'm doing the right thing reworking this
stack onto an even older tree.

But I do see crashes on reboot w/ 4.14 and 4.9 (I and suspect 4.4 as
well), so I'll need to figure out something eventually.

thanks
-john
