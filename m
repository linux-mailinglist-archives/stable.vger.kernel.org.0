Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EA3667A6B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 17:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjALQNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 11:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjALQM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 11:12:56 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC9E630C;
        Thu, 12 Jan 2023 08:07:27 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id q2so19840848ljp.6;
        Thu, 12 Jan 2023 08:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LvAQXYdamVqQXCgPq+dD+jjmfMCKJhXUElRrS0wbfd0=;
        b=EZlrdeo7n2ouUAVL8e3iu3obigIq4dXB0zEm/9c2UYWjmSNi9sEfS9bCIG1ikJvr2t
         3eaiHqZAzBQQ7n5sgiTWGs7BpgMZdttSv0+717z29dfgzM4p1Epk3QaPTvBVNf1NlKdr
         zgtPpzZzapGLEpTGn0p4YFtO3IugBtVoodOhvzrJbMvc5x1oeKp3N4ug3mJUKqFyCdZx
         NYVHMeLPW7LMbxKBeNvsHNUSaPeiEnUxir8QUrUexA8SvKcw8whbVlPijxMSi1+XxrOP
         CKAGdklvFt4pDLCeHmBMXt4at3Vtw/Oj6Fymr8Bv2jzoLXDbEbty/MkP7IL/W90WaD6i
         tGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LvAQXYdamVqQXCgPq+dD+jjmfMCKJhXUElRrS0wbfd0=;
        b=LmgI5e7LBvOYhp+/qd5IRqJFxD6IkajieGvM10L/mz13ie4RuaoarRhexIEO9DA1tK
         BKZcANQM0Jvh4Y3LSwaah4oX3anWNwb8BCG3OYZ/xVRkZtgu6niMqf9CTLYgup8v33/1
         liU8v/pk18mTYZ8CIRSJxsbvJz13yH4fCS96Pm0KYnvMiRZ0j2nHaENk7rGoFj64apN3
         oQe9zy7/TI/+monqLJAfHrQDvZwpBa36VrMdHhB0gVj25TpWxK63vUgjDyk9DYn42OGV
         gHPp4uDpd+fWZ+4KN5+gYnqEm7BI6tkIXgfC1VJW7hm80Xb7POkJBTUYZqA4xnlApOCx
         HAlw==
X-Gm-Message-State: AFqh2kq1PKwxnlaW5ZAXE34WraSLTWrH/DveYiatH5802fTJeiFFGuH2
        7fv7CrM2i+bGWVqeA+Kif+6WRF82MTrHPa/s5E8=
X-Google-Smtp-Source: AMrXdXtmrARdnJxWT3NINJTvlh900Rwfjw7PAoIBovqroCZRwKxp7dW0Ry8v37kbZrZ3Yj60fIFaStMIJGm0qDlWle4=
X-Received: by 2002:a05:651c:1681:b0:286:4fb:2531 with SMTP id
 bd1-20020a05651c168100b0028604fb2531mr1287888ljb.161.1673539645680; Thu, 12
 Jan 2023 08:07:25 -0800 (PST)
MIME-Version: 1.0
References: <20221229102829.403917-1-krzysztof.kozlowski@linaro.org> <397c61e8-d928-4e07-9616-afb315d356dd@linaro.org>
In-Reply-To: <397c61e8-d928-4e07-9616-afb315d356dd@linaro.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 12 Jan 2023 08:07:14 -0800
Message-ID: <CABBYNZJYTfVfBMBvfxx6D9a4T5gbqZZcb7BP5LBa28fOEKuoFw@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: hci_qca: Fix driver shutdown on closed serdev
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Zijun Hu <zijuhu@codeaurora.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Krzysztof,

On Thu, Jan 12, 2023 at 7:20 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 29/12/2022 11:28, Krzysztof Kozlowski wrote:
> > The driver shutdown callback (which sends EDL_SOC_RESET to the device
> > over serdev) should not be invoked when HCI device is not open (e.g. if
> > hci_dev_open_sync() failed), because the serdev and its TTY are not open
> > either.  Also skip this step if device is powered off
> > (qca_power_shutdown()).
> >
> > The shutdown callback causes use-after-free during system reboot with
> > Qualcomm Atheros Bluetooth:
> >
> >   Unable to handle kernel paging request at virtual address 0072662f67726fd7
> >   ...
> >   CPU: 6 PID: 1 Comm: systemd-shutdow Tainted: G        W          6.1.0-rt5-00325-g8a5f56bcfcca #8
> >   Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
> >   Call trace:
> >    tty_driver_flush_buffer+0x4/0x30
> >    serdev_device_write_flush+0x24/0x34
> >    qca_serdev_shutdown+0x80/0x130 [hci_uart]
> >    device_shutdown+0x15c/0x260
> >    kernel_restart+0x48/0xac
> >
> > KASAN report:
> >
> >   BUG: KASAN: use-after-free in tty_driver_flush_buffer+0x1c/0x50
> >   Read of size 8 at addr ffff16270c2e0018 by task systemd-shutdow/1
> >
> >   CPU: 7 PID: 1 Comm: systemd-shutdow Not tainted 6.1.0-next-20221220-00014-gb85aaf97fb01-dirty #28
> >   Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
> >   Call trace:
> >    dump_backtrace.part.0+0xdc/0xf0
> >    show_stack+0x18/0x30
> >    dump_stack_lvl+0x68/0x84
> >    print_report+0x188/0x488
> >    kasan_report+0xa4/0xf0
> >    __asan_load8+0x80/0xac
> >    tty_driver_flush_buffer+0x1c/0x50
> >    ttyport_write_flush+0x34/0x44
> >    serdev_device_write_flush+0x48/0x60
> >    qca_serdev_shutdown+0x124/0x274
> >    device_shutdown+0x1e8/0x350
> >    kernel_restart+0x48/0xb0
> >    __do_sys_reboot+0x244/0x2d0
> >    __arm64_sys_reboot+0x54/0x70
> >    invoke_syscall+0x60/0x190
> >    el0_svc_common.constprop.0+0x7c/0x160
> >    do_el0_svc+0x44/0xf0
> >    el0_svc+0x2c/0x6c
> >    el0t_64_sync_handler+0xbc/0x140
> >    el0t_64_sync+0x190/0x194
> >
> > Fixes: 7e7bbddd029b ("Bluetooth: hci_qca: Fix qca6390 enable failure after warm reboot")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> >
> > ---
>
> Any comments on this? Patchwork tools complain on longer line, but
> without it checkpatch would complain as well, so I assume you do not
> expect to fix it?

I did apply it already:

https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=a18fca670e14f0c09c2ed332cf2c6d77a4ae05f9

Not sure why the bot hasn't responded to you.

> Best regards,
> Krzysztof
>


-- 
Luiz Augusto von Dentz
