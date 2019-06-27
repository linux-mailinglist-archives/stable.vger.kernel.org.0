Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22DB458C02
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 22:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfF0Uwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 16:52:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43808 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfF0Uwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 16:52:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so1540054pgv.10
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 13:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=j4UAHd5jEgwrnNSvgUERX+teOkMFsnYeMyJ1l9cr6K4=;
        b=gJXPTYzxr6WkAkTh8nZt1EhLYOAnRpHvmztof9MZmVHsF84zasnk1xsnlG5lQfMZzs
         g5LOVY0jdOW3uaEFhPQPCuKGakweV1GI1YOOLBCkKfPLyqlvTYRZw+bxQvv3fN2ZFORO
         yk0ee+Mf9caRv2gwdTnryKbbrp/vf3ENEMs8N6v1xxaR5NjGEQmlslU0FqWId3pF2Zbz
         aDO6QiYRXVHk1e+iLa/JYJx3UclxZOkMRx7HjL+b4cGp77ChKXJchFYyMkDZpz8vXte/
         ckpEdPOoXWO5p7qgeKTvBz+UryniX2yzKF3lUMt1Uu1OYlDbH5tooTKeioK9QvGANQxD
         poCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j4UAHd5jEgwrnNSvgUERX+teOkMFsnYeMyJ1l9cr6K4=;
        b=OAL0qnqQQQM0qaRnVB3XUx1NuilyRUTAEU1gci0tB53/t2S0G05bEBt17h+S5b0iCQ
         WRQiTxILc4/HVuO4k7qaTofEnliwXMdfFke75HfM20cNq2z5QGhmavJ8wH2PTpvj8Y/V
         rarExCbplCLgrPzv/hJ4DsoEYbGgJ5N/gLcx6vM0r690TOsKVWYOsVRRtBoRpN4sayDq
         Q7BzbjhnEZ62UupmVj9jmarx0z/ZB05eD7ZPbOEJAkWh6i9a1YqSBiC9SdYJ6lvTwiW7
         i2FJ/no/0dZGVdPcbwDFVNb/E+pamkRPawFq3fDksOh1UJ1GOuieNnK4KGYkX2kOeuGu
         HaNA==
X-Gm-Message-State: APjAAAXLpvU4oviTJTZ5VhfV8fTVD+hcmPoFt4SCtfY2G/ONzmzd6xvL
        pO4+WD9ijjmwE/tvv0I3vS+GN6HWjnk=
X-Google-Smtp-Source: APXvYqyhbTsZQMFsW3ELLkqN5sax4BzTvpxSrOSr3VfUZe47uoNQpiu/YuLbkVwsNZ24MrcsbqyUEQ==
X-Received: by 2002:a17:90a:c504:: with SMTP id k4mr8373953pjt.104.1561668764743;
        Thu, 27 Jun 2019 13:52:44 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id 2sm3674083pff.174.2019.06.27.13.52.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 13:52:43 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     John Stultz <john.stultz@linaro.org>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH 4.19.y 0/9] Fix scheduling while atomic in dwc3_gadget_ep_dequeue
Date:   Thu, 27 Jun 2019 20:52:31 +0000
Message-Id: <20190627205240.38366-1-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With recent changes in AOSP, adb is using asynchronous io, which
causes the following crash usually on a reboot:

[  184.278302] BUG: scheduling while atomic: ksoftirqd/0/9/0x00000104
[  184.284617] Modules linked in: wl18xx wlcore snd_soc_hdmi_codec wlcore_sdio tcpci_rt1711h tcpci tcpm typec adv7511 cec dwc3 phy_hi3660_usb3 snd_soc_simple_card snd_soc_a
[  184.316034] Preemption disabled at:
[  184.316072] [<ffffff8008081de4>] __do_softirq+0x64/0x398
[  184.324953] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G S                4.19.43-00669-g8e4970572c43-dirty #356
[  184.334963] Hardware name: HiKey960 (DT)
[  184.338892] Call trace:
[  184.341352]  dump_backtrace+0x0/0x158
[  184.345025]  show_stack+0x14/0x20
[  184.348355]  dump_stack+0x80/0xa4
[  184.351685]  __schedule_bug+0x6c/0xc0
[  184.355363]  __schedule+0x64c/0x978
[  184.358863]  schedule+0x2c/0x90
[  184.362053]  dwc3_gadget_ep_dequeue+0x274/0x388 [dwc3]
[  184.367210]  usb_ep_dequeue+0x24/0xf8
[  184.370884]  ffs_aio_cancel+0x3c/0x80
[  184.374561]  free_ioctx_users+0x40/0x148
[  184.378500]  percpu_ref_switch_to_atomic_rcu+0x180/0x1c0
[  184.383830]  rcu_process_callbacks+0x24c/0x5d8
[  184.388283]  __do_softirq+0x13c/0x398
[  184.391959]  run_ksoftirqd+0x3c/0x48
[  184.395549]  smpboot_thread_fn+0x220/0x288
[  184.399660]  kthread+0x12c/0x130
[  184.402901]  ret_from_fork+0x10/0x1c


This happens as usb_ep_dequeue can be called in interrupt
context, and dwc3_gadget_ep_dequeue() then calls
wait_event_lock_irq() which can sleep.

Upstream kernels are not affected due to the change
fec9095bdef4 ("dwc3: gadget: remove wait_end_transfer") which
removes the wait_even_lock_irq code. Unfortunately that change
has a number of dependencies, which I'm submitting here.

Also, to match upstream, in this series I've reverted one
change that was backported to -stable, to replace it with the
cherry-picked upstream commit (as the dependencies are now
there)

This issue also affects 4.14,4.9 and I believe 4.4 kernels,
however I don't know how to best backport this functionality
that far back. Help from the maintainers would be very much
appreciated!

Feedback and comments would be welcome!

thanks
-john

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y

Felipe Balbi (7):
  usb: dwc3: gadget: combine unaligned and zero flags
  usb: dwc3: gadget: track number of TRBs per request
  usb: dwc3: gadget: use num_trbs when skipping TRBs on ->dequeue()
  usb: dwc3: gadget: extract dwc3_gadget_ep_skip_trbs()
  usb: dwc3: gadget: introduce cancelled_list
  usb: dwc3: gadget: move requests to cancelled_list
  usb: dwc3: gadget: remove wait_end_transfer

Jack Pham (1):
  usb: dwc3: gadget: Clear req->needs_extra_trb flag on cleanup

John Stultz (1):
  Revert "usb: dwc3: gadget: Clear req->needs_extra_trb flag on cleanup"

 drivers/usb/dwc3/core.h   |  15 ++--
 drivers/usb/dwc3/gadget.c | 158 +++++++++++++-------------------------
 drivers/usb/dwc3/gadget.h |  15 ++++
 3 files changed, 75 insertions(+), 113 deletions(-)

-- 
2.17.1

