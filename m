Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D72A5A343
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfF1SOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:14:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44350 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbfF1SOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:14:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id r16so5343392wrl.11
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 11:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0cnkDQbZpYRwQd96ngx4qAoaZ3lYPa92yT2sfzzvlI8=;
        b=XwDtmRhAErV28ymeatsy9mbPyRbmUhbMtL4IxQFBX2esLP4L8Dg8DWEwrL5BpJDUt4
         FHRVSXQ1ngsz97D33lJZp/5oSvvvJp3Xn3Xp+l3Oi3NFIYedPuJPE5XUsgA4yAFlOBZK
         R61+sxOpWgg2nnLgORSYKvlsaGx/RJDmoN1aCeRDxGVr6Nsz8ZBc0JKYLWMx6DhH/oYm
         8hwcJ2qt1U9LddwPOhjIpppT500w8NuYeTkrluLzzC9EWsDm/yVNdCna15DArgpfthsK
         VrWPoJMdZkoT/ecFhNSgtI8sKXSdlzAt5YEHjAWCSXECby4juochBV6t/gP7+4gZybzO
         VWmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0cnkDQbZpYRwQd96ngx4qAoaZ3lYPa92yT2sfzzvlI8=;
        b=J4r+oq3XvgG2YV3xYnyjkQHizaKbo56xLVoIhfeMd5ONN7AikEH1Iv8iECh3fw3r02
         4NWtZOsFa/6lEHHimjEqk1IOpgdY01IpNV69/CQgwzM1CRxmJ2Wy3jt9Xot+rICxYh/o
         Fr4FUOtZIqNq+YBBeJM8hij5g8HBEK8Yo86RB7lErI2eEGyS3pCIztVabRwQdVtmBkxU
         1+u8NLKRPSTFKSnBKukUkAwF4Jz5RJ11gflmvL4vOZlNrlkThwBB1h2kqhZ30Ty0LVsP
         9Ao5Kkk5O9iAHYAc9JjCQZ1GjzIU7NlghnQ54TMhImObfj1rNwwdkICUUCuerfUq9EaA
         RrHA==
X-Gm-Message-State: APjAAAVeDjZnJGTYdUFQzLM0Euc/0bxvcXmVcK6JIaCoDarR55Y1hS7I
        Va6KBK1eXeK+8AijswZ2TjQ3vfeYsPYCRTa5X0TUFA==
X-Google-Smtp-Source: APXvYqyPkk7Org4QWv5TFR0K0XoNu4JXCnOJoZS2v/LCBIqCN4kbi9bo5JAU+vf3rEyhsGCgeUEQE1wJJRMYIGip/88=
X-Received: by 2002:adf:fe4e:: with SMTP id m14mr9497003wrs.21.1561745682146;
 Fri, 28 Jun 2019 11:14:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190627205240.38366-1-john.stultz@linaro.org> <C672AA6DAAC36042A98BAD0B0B25BDA94CC59E46@BGSMSX104.gar.corp.intel.com>
In-Reply-To: <C672AA6DAAC36042A98BAD0B0B25BDA94CC59E46@BGSMSX104.gar.corp.intel.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Fri, 28 Jun 2019 11:14:31 -0700
Message-ID: <CALAqxLXxbvgv6zeBPgE4n6opTJX_-pqEZ+hLB3pNMHZyBpCr8A@mail.gmail.com>
Subject: Re: [PATCH 4.19.y 0/9] Fix scheduling while atomic in dwc3_gadget_ep_dequeue
To:     "Gopal, Saranya" <saranya.gopal@intel.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Yang, Fei" <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 3:10 AM Gopal, Saranya <saranya.gopal@intel.com> wrote:
>
> > With recent changes in AOSP, adb is using asynchronous io, which
> > causes the following crash usually on a reboot:
> >
> > [  184.278302] BUG: scheduling while atomic: ksoftirqd/0/9/0x00000104
> > [  184.284617] Modules linked in: wl18xx wlcore snd_soc_hdmi_codec
> > wlcore_sdio tcpci_rt1711h tcpci tcpm typec adv7511 cec dwc3 phy_hi3660_usb3
> > snd_soc_simple_card snd_soc_a
> > [  184.316034] Preemption disabled at:
> > [  184.316072] [<ffffff8008081de4>] __do_softirq+0x64/0x398
> > [  184.324953] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G S                4.19.43-
> > 00669-g8e4970572c43-dirty #356
> > [  184.334963] Hardware name: HiKey960 (DT)
> > [  184.338892] Call trace:
> > [  184.341352]  dump_backtrace+0x0/0x158
> > [  184.345025]  show_stack+0x14/0x20
> > [  184.348355]  dump_stack+0x80/0xa4
> > [  184.351685]  __schedule_bug+0x6c/0xc0
> > [  184.355363]  __schedule+0x64c/0x978
> > [  184.358863]  schedule+0x2c/0x90
> > [  184.362053]  dwc3_gadget_ep_dequeue+0x274/0x388 [dwc3]
>
>
> > This happens as usb_ep_dequeue can be called in interrupt
> > context, and dwc3_gadget_ep_dequeue() then calls
> > wait_event_lock_irq() which can sleep.
> >
> > Upstream kernels are not affected due to the change
> > fec9095bdef4 ("dwc3: gadget: remove wait_end_transfer") which
> > removes the wait_even_lock_irq code. Unfortunately that change
> > has a number of dependencies, which I'm submitting here.
> >
> > Also, to match upstream, in this series I've reverted one
> > change that was backported to -stable, to replace it with the
> > cherry-picked upstream commit (as the dependencies are now
> > there)
> >
> > This issue also affects 4.14,4.9 and I believe 4.4 kernels,
> > however I don't know how to best backport this functionality
> > that far back. Help from the maintainers would be very much
> > appreciated!
> >
> > Feedback and comments would be welcome!
> >
> > thanks
> > -john
>
> I confirm that this patch series fixes crash seen on reboot.
> Considering that many Android platforms use 4.19 stable kernel with latest AOSP codebase, it would be really helpful if these patches are merged to 4.19 stable.
>

Thanks so much for the testing! Do let me know if you come across any
ideas on how to cleanly resolve this for 4.14/4.9/4.4!

thanks
-john
