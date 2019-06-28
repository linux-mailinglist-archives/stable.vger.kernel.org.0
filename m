Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5015A36C
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbfF1SYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:24:19 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42986 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfF1SYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:24:18 -0400
Received: by mail-pl1-f194.google.com with SMTP id ay6so3660895plb.9
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 11:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Lui3xxG+jUxHBZj//7cb1eS4egCiB5B/SX3zID9r9OU=;
        b=iYx+PZHPfVmdW5etNZ+RS83FEtBUrZ7pZMN9PI2pP6nCZR+REurZv8JdDysfhHYwXA
         q4m+qa4gvoBEjQ9f9OFDuAmDXO+iOdAr50cRe1Y/8HZSBTf7rws2Wk1wf1BOOJGip1SP
         Jn9z4jqAUaXUeQhJ/k1RSmEetn4Y9stjBOM6LDqWATPf1czqS0Q4vDNZkGfRZ4/s8SaQ
         etMHT5N9J+T/7xN4NFZumbOpp8BcKD1E2YlVU7vZL6bO6r+1+mvPlsWcVCYctZ0ES/jG
         ZVLciF5eArnbAR2ramfq30d3VYF1mnXyUBHDXPkBFMTvdQl9TxFpRlIfQDnv0olBSTc0
         GQxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Lui3xxG+jUxHBZj//7cb1eS4egCiB5B/SX3zID9r9OU=;
        b=OgObJUF305mJThw+Zjd2jF7WDQxKWnJMmDvbioTakLjc2ohAubOF2h78B7iE+ANHhS
         Ostd99coGk4Hx9UydxXFTel3U4ZwWH672BYg+MFTTdq+YHP4lCoQkS6nSCuvxnTa9Ibr
         Sjf3K5ArS5LqufCAxWZjKDpU4FYUkffynqDsEouW9jMgtBmv+JLd0ZRhx+jE1sfWK4lG
         RL8yFhqbqgNCtUryqqAvH/1Re2hLSKRwMUckZfb17FgVdCu+fXQeYR8XUgYM7XzCqoXl
         lp2Rw15Y4QvyWDg8FiORgkR1BkdVJ2a16Af7Slt+NkdVJN3jJsDYPPdBb2P+TOOeSBZV
         5I8Q==
X-Gm-Message-State: APjAAAU5eWY3tdjWR+QBAdGjA8uLgbbcNCRZaLb4wWwWtz7/thEibeXI
        Z41fIQ8LONCcXUPTic/MQ2po6E8L3V8=
X-Google-Smtp-Source: APXvYqxS8O+2ugxIClJkG+iQuKCU0kL/+QCqeqEOCq1YVQiab6kk18FcwGCfKCfCMj3/CDrnfa235A==
X-Received: by 2002:a17:902:2be8:: with SMTP id l95mr12325680plb.231.1561746257338;
        Fri, 28 Jun 2019 11:24:17 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id s15sm2916223pfd.183.2019.06.28.11.24.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:24:16 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     John Stultz <john.stultz@linaro.org>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Jack Pham <jackp@codeaurora.org>, linux-usb@vger.kernel.org
Subject: [PATCH 4.19.y v2 0/9] Fix scheduling while atomic in dwc3_gadget_ep_dequeue
Date:   Fri, 28 Jun 2019 18:24:04 +0000
Message-Id: <20190628182413.33225-1-john.stultz@linaro.org>
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


New in v2:
* Reordered the patchset to put the revert patch first, which
  avoids any bisection build issues. (Thanks to Jack Pham for
  the suggestion!)


Feedback and comments would be welcome!

thanks
-john

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Jack Pham <jackp@codeaurora.org>
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

