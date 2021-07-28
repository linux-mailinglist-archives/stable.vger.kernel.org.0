Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673793D8E5F
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 14:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhG1M43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 08:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235105AbhG1M40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 08:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24FF360FDA;
        Wed, 28 Jul 2021 12:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627476985;
        bh=0M3/UKJUvgaJKNlYrg8MlqTS8NnwfPDwkRK1D8l/u10=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uBgDKyQrFn9m2h19BGMOwTwsvVS7lAA4FJh+UF8B23jQSrr10bey21WcI6PQV1Ntd
         w97HCoWpo1IgNzjzdj/4Is/e1qsKvTyzcGkILOxWtisY5NHgIsKBpjhFBXRROHOHXB
         slV3qW5Oy4ACbTxZFYyWzc/tjpGXm3PNS3zrQNzYJr7+fqvsBBnvEsnt2OMiLqYKmi
         AIiJjAad1wtikajyhBEXrrViULI+OHupHGnX0WLGW0BY4w2mjD7vF9ynW4Am843ZrZ
         oPpZ7Sl0wT9UbWHuhYvtNNVQsSmMJx6RTte3SkA/40AWqTn/WuV+W4DPp94/7pwoL5
         DG5PL7GRdIeMg==
Received: by mail-pj1-f48.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so9851516pjb.3;
        Wed, 28 Jul 2021 05:56:25 -0700 (PDT)
X-Gm-Message-State: AOAM531EYeVpck+Y0sHLQEjQFkyAqz4lr74XYj2UIMuxB18jexCAKRXb
        YrpomERHVG8nit2Dq2R1ZtE+YggnDd2T4A4IE/k=
X-Google-Smtp-Source: ABdhPJwxkl96MxyvLoHKaTCzrofFdZmMK/UeB7eayktKLW5xwbJvg8Y3LG9HQCq3PSDrySWBwln4E/jb2Pj7gSi9OFw=
X-Received: by 2002:a63:3704:: with SMTP id e4mr28624283pga.310.1627476984815;
 Wed, 28 Jul 2021 05:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210415144414.464797272@linuxfoundation.org> <20210415144415.946778464@linuxfoundation.org>
In-Reply-To: <20210415144415.946778464@linuxfoundation.org>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 28 Jul 2021 14:56:13 +0200
X-Gmail-Original-Message-ID: <CAJKOXPdj3Dij2KDDM27aEK6HbpGfEU6_R6dSbXa4MvHb-NGiYw@mail.gmail.com>
Message-ID: <CAJKOXPdj3Dij2KDDM27aEK6HbpGfEU6_R6dSbXa4MvHb-NGiYw@mail.gmail.com>
Subject: Re: [PATCH 4.14 45/68] usbip: fix vudc usbip_sockfd_store races
 leading to gpf
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Tom Seewald <tseewald@gmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>,
        syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>,
        syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021 at 17:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Shuah Khan <skhan@linuxfoundation.org>
>
> commit 46613c9dfa964c0c60b5385dbdf5aaa18be52a9c upstream.
>
> usbip_sockfd_store() is invoked when user requests attach (import)
> detach (unimport) usb gadget device from usbip host. vhci_hcd sends
> import request and usbip_sockfd_store() exports the device if it is
> free for export.
>

Hi All,

Sorry for reopening an old commit, but I am hoping to learn something
here, see below in the code.

> Export and unexport are governed by local state and shared state
> - Shared state (usbip device status, sockfd) - sockfd and Device
>   status are used to determine if stub should be brought up or shut
>   down. Device status is shared between host and client.
> - Local state (tcp_socket, rx and tx thread task_struct ptrs)
>   A valid tcp_socket controls rx and tx thread operations while the
>   device is in exported state.
> - While the device is exported, device status is marked used and socket,
>   sockfd, and thread pointers are valid.
>
> Export sequence (stub-up) includes validating the socket and creating
> receive (rx) and transmit (tx) threads to talk to the client to provide
> access to the exported device. rx and tx threads depends on local and
> shared state to be correct and in sync.
>
> Unexport (stub-down) sequence shuts the socket down and stops the rx and
> tx threads. Stub-down sequence relies on local and shared states to be
> in sync.
>
> There are races in updating the local and shared status in the current
> stub-up sequence resulting in crashes. These stem from starting rx and
> tx threads before local and global state is updated correctly to be in
> sync.
>
> 1. Doesn't handle kthread_create() error and saves invalid ptr in local
>    state that drives rx and tx threads.
> 2. Updates tcp_socket and sockfd,  starts stub_rx and stub_tx threads
>    before updating usbip_device status to SDEV_ST_USED. This opens up a
>    race condition between the threads and usbip_sockfd_store() stub up
>    and down handling.
>
> Fix the above problems:
> - Stop using kthread_get_run() macro to create/start threads.
> - Create threads and get task struct reference.
> - Add kthread_create() failure handling and bail out.
> - Hold usbip_device lock to update local and shared states after
>   creating rx and tx threads.
> - Update usbip_device status to SDEV_ST_USED.
> - Update usbip_device tcp_socket, sockfd, tcp_rx, and tcp_tx
> - Start threads after usbip_device (tcp_socket, sockfd, tcp_rx, tcp_tx,
>   and status) is complete.
>
> Credit goes to syzbot and Tetsuo Handa for finding and root-causing the
> kthread_get_run() improper error handling problem and others. This is a
> hard problem to find and debug since the races aren't seen in a normal
> case. Fuzzing forces the race window to be small enough for the
> kthread_get_run() error path bug and starting threads before updating the
> local and shared state bug in the stub-up sequence.
>
> Fixes: 9720b4bc76a83807 ("staging/usbip: convert to kthread")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>
> Reported-by: syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>
> Reported-by: syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Link: https://lore.kernel.org/r/b1c08b983ffa185449c9f0f7d1021dc8c8454b60.1615171203.git.skhan@linuxfoundation.org
> Signed-off-by: Tom Seewald <tseewald@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/usbip/vudc_sysfs.c |   42 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 34 insertions(+), 8 deletions(-)
>
> --- a/drivers/usb/usbip/vudc_sysfs.c
> +++ b/drivers/usb/usbip/vudc_sysfs.c
> @@ -103,8 +103,9 @@ unlock:
>  }
>  static BIN_ATTR_RO(dev_desc, sizeof(struct usb_device_descriptor));
>
> -static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
> -                    const char *in, size_t count)
> +static ssize_t store_sockfd(struct device *dev,
> +                                struct device_attribute *attr,
> +                                const char *in, size_t count)
>  {
>         struct vudc *udc = (struct vudc *) dev_get_drvdata(dev);
>         int rv;
> @@ -113,6 +114,8 @@ static ssize_t store_sockfd(struct devic
>         struct socket *socket;
>         unsigned long flags;
>         int ret;
> +       struct task_struct *tcp_rx = NULL;
> +       struct task_struct *tcp_tx = NULL;
>
>         rv = kstrtoint(in, 0, &sockfd);
>         if (rv != 0)
> @@ -158,24 +161,47 @@ static ssize_t store_sockfd(struct devic
>                         goto sock_err;
>                 }
>
> -               udc->ud.tcp_socket = socket;
> -
> +               /* unlock and create threads and get tasks */
>                 spin_unlock_irq(&udc->ud.lock);
>                 spin_unlock_irqrestore(&udc->lock, flags);
>
> -               udc->ud.tcp_rx = kthread_get_run(&v_rx_loop,
> -                                                   &udc->ud, "vudc_rx");
> -               udc->ud.tcp_tx = kthread_get_run(&v_tx_loop,
> -                                                   &udc->ud, "vudc_tx");
> +               tcp_rx = kthread_create(&v_rx_loop, &udc->ud, "vudc_rx");
> +               if (IS_ERR(tcp_rx)) {
> +                       sockfd_put(socket);
> +                       return -EINVAL;
> +               }
> +               tcp_tx = kthread_create(&v_tx_loop, &udc->ud, "vudc_tx");
> +               if (IS_ERR(tcp_tx)) {
> +                       kthread_stop(tcp_rx);
> +                       sockfd_put(socket);
> +                       return -EINVAL;
> +               }
> +
> +               /* get task structs now */
> +               get_task_struct(tcp_rx);
> +               get_task_struct(tcp_tx);
>
> +               /* lock and update udc->ud state */
>                 spin_lock_irqsave(&udc->lock, flags);
>                 spin_lock_irq(&udc->ud.lock);
> +
> +               udc->ud.tcp_socket = socket;
> +               udc->ud.tcp_rx = tcp_rx;
> +               udc->ud.tcp_rx = tcp_tx;
>                 udc->ud.status = SDEV_ST_USED;
> +
>                 spin_unlock_irq(&udc->ud.lock);
>
>                 do_gettimeofday(&udc->start_time);
>                 v_start_timer(udc);
>                 udc->connected = 1;

Here:

Isn't such pattern - spin_unlock_irq() followed by
spin_unlock_irqrestore() a little risky? The spin_unlock_irq() should
unconditionally enable the interrupts. There is therefore a window
with few statements with all interrupts enabled. What happens if an
interrupt comes exactly now?

> +
> +               spin_unlock_irqrestore(&udc->lock, flags);

...and here:

Additionally, the spin_unlock_irqrestore() will now have wrong flags.
Assuming interrupts were enabled during spin_lock_irqsave(), the
interrupt state is stored in flags, spin_unlock_irq() enabled
interrupts and now spin_unlock_irqrestore() gets flags not matching
real state. There should be warn_bogus_irq_restore() visible as well.

The discussed pattern spin_unlock_irq+spin_unlock_irqrestore was here
before, so this is not a comment about this specific patch but the
entire usbip code.

Best regards,
Krzysztof
