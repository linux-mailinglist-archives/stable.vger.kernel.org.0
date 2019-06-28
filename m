Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1820A5A73D
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 00:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfF1W6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 18:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfF1W6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 18:58:05 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 184872086D;
        Fri, 28 Jun 2019 22:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561762684;
        bh=DZUscUNbxaI+uslyptrcYGtHY9gmsQXG8HQh9v7cFKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vncCx9NC68t+4xDDVkcuTGQQVnz3+ljuFihJbYIRxpxeFCpia6ghnyBh2w+LUpLQ5
         U3NOrVGLTmzpqI1hH1qDq77i0FKzbMvorp/kIH4sCt0A3LDS7Dw9QIYA+imBOv22TJ
         QPQOKSO1iuzl1n/qkESkwEjv9nKjWLBkJJvYLcAQ=
Date:   Fri, 28 Jun 2019 18:58:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     stable@vger.kernel.org, Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Jack Pham <jackp@codeaurora.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 4.19.y v2 0/9] Fix scheduling while atomic in
 dwc3_gadget_ep_dequeue
Message-ID: <20190628225803.GK11506@sasha-vm>
References: <20190628182413.33225-1-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190628182413.33225-1-john.stultz@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 06:24:04PM +0000, John Stultz wrote:
>With recent changes in AOSP, adb is using asynchronous io, which
>causes the following crash usually on a reboot:
>
>[  184.278302] BUG: scheduling while atomic: ksoftirqd/0/9/0x00000104
>[  184.284617] Modules linked in: wl18xx wlcore snd_soc_hdmi_codec wlcore_sdio tcpci_rt1711h tcpci tcpm typec adv7511 cec dwc3 phy_hi3660_usb3 snd_soc_simple_card snd_soc_a
>[  184.316034] Preemption disabled at:
>[  184.316072] [<ffffff8008081de4>] __do_softirq+0x64/0x398
>[  184.324953] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G S                4.19.43-00669-g8e4970572c43-dirty #356
>[  184.334963] Hardware name: HiKey960 (DT)
>[  184.338892] Call trace:
>[  184.341352]  dump_backtrace+0x0/0x158
>[  184.345025]  show_stack+0x14/0x20
>[  184.348355]  dump_stack+0x80/0xa4
>[  184.351685]  __schedule_bug+0x6c/0xc0
>[  184.355363]  __schedule+0x64c/0x978
>[  184.358863]  schedule+0x2c/0x90
>[  184.362053]  dwc3_gadget_ep_dequeue+0x274/0x388 [dwc3]
>[  184.367210]  usb_ep_dequeue+0x24/0xf8
>[  184.370884]  ffs_aio_cancel+0x3c/0x80
>[  184.374561]  free_ioctx_users+0x40/0x148
>[  184.378500]  percpu_ref_switch_to_atomic_rcu+0x180/0x1c0
>[  184.383830]  rcu_process_callbacks+0x24c/0x5d8
>[  184.388283]  __do_softirq+0x13c/0x398
>[  184.391959]  run_ksoftirqd+0x3c/0x48
>[  184.395549]  smpboot_thread_fn+0x220/0x288
>[  184.399660]  kthread+0x12c/0x130
>[  184.402901]  ret_from_fork+0x10/0x1c
>
>
>This happens as usb_ep_dequeue can be called in interrupt
>context, and dwc3_gadget_ep_dequeue() then calls
>wait_event_lock_irq() which can sleep.
>
>Upstream kernels are not affected due to the change
>fec9095bdef4 ("dwc3: gadget: remove wait_end_transfer") which
>removes the wait_even_lock_irq code. Unfortunately that change
>has a number of dependencies, which I'm submitting here.
>
>Also, to match upstream, in this series I've reverted one
>change that was backported to -stable, to replace it with the
>cherry-picked upstream commit (as the dependencies are now
>there)
>
>This issue also affects 4.14,4.9 and I believe 4.4 kernels,
>however I don't know how to best backport this functionality
>that far back. Help from the maintainers would be very much
>appreciated!
>
>
>New in v2:
>* Reordered the patchset to put the revert patch first, which
>  avoids any bisection build issues. (Thanks to Jack Pham for
>  the suggestion!)
>
>
>Feedback and comments would be welcome!

I've queued it up for 4.19.

Is it the case that for older kernels the dependency list is too long?

--
Thanks,
Sasha
