Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079C53B10FA
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 02:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhFWAQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 20:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhFWAQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 20:16:02 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301A4C061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 17:13:45 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j1so567945wrn.9
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 17:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6+n9RAFHS60CsUcw0y9ACYP1rnXZ5QdTw0WZoevoIqI=;
        b=UBqf5xFC8yfDL9QmANKerzK/IBaE5nTeFf0p8L3GsG5gGhkHzZx4aslWqE0JVdJd9K
         IGVgOT7ZV9RBI7PNzL1SbETx3UFpSs5xPS8fhUue8fKIaUOWDIvgVH9CJ6W6ABk85ftk
         TWRU/qWTgBeb7c8pbuBuLXvQlYE4jEFXW4DtBQufNHsQJhHZujaqR95L0rsK4TD8iEOs
         ounjBpyZuK+flHA9d9U8QkJnP4aLmLBFEEsc/SwYVyJOb/KUj+U792Nv9pk0mA+FAJyh
         /91XQ3UBGd/sCzN7qlyDYLPtMgcCRGCfQYrSQ1n6JfJ2bAZvwbTIUMHglYKpYchiBMAw
         hmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6+n9RAFHS60CsUcw0y9ACYP1rnXZ5QdTw0WZoevoIqI=;
        b=FL+395DTzgZF0gDKB3CqZOa1kQDnGKzrfEMKwvmtnNwOHQyraix3UTcwyY21GnXCKv
         ku/dC7Kr1x4gkOWSmLDLLPEl5Okj5nfzMUM3nf+aef2Lr6SMxjiIY8DgpD3d/Ul1rbug
         KbPU8wHe/Vyckd8FUbJZBlrgL9hdzLD0XBDUWtMolWvGNhY3w0+zf6yJM7oZOeKxzfxR
         6ULlkKxmzORNI/xznkjFN57eBfmFyRYnpMKJB/60rLrPrBNtAkmZLBG6qMtO2FgC2AAa
         RdrJSGQDH5shsbK4UGwbxC0QlVwjna1crAPnUC5SanIyR0hX/MPHC5I7Wq82RXnHrgNG
         7WLA==
X-Gm-Message-State: AOAM532Jr9kb7aMJJtt2Ufz1afC5KMtmlmUTjjG1HBi4Ia5CVqxKbsC6
        7e27hZ0LzM4w/l3xUdkr0lk5cWS7okhwAlpmf1z3Kg==
X-Google-Smtp-Source: ABdhPJxzgxgl9GRbX8DFAWNw4Zsx32HqUwDZeN3N7AS4oP7r/vUk3zML+c6MUFmD+Jnwwmdi03I/UrIE86kFczZlHJU=
X-Received: by 2002:a5d:6b82:: with SMTP id n2mr6277278wrx.206.1624407223595;
 Tue, 22 Jun 2021 17:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <70042d9f.111abd.17a19f94b84.Coremail.linma@zju.edu.cn>
 <CAATStaMu-Nx1XS=4fbK6T2cRanS8OvSzP_83dmSnEKB7pgpm8A@mail.gmail.com> <25433968.3904.17a2d03131c.Coremail.linma@zju.edu.cn>
In-Reply-To: <25433968.3904.17a2d03131c.Coremail.linma@zju.edu.cn>
From:   "Anand K. Mistry" <amistry@google.com>
Date:   Wed, 23 Jun 2021 10:13:31 +1000
Message-ID: <CAATStaPD0iF9d5B=tJOTgDH8drR22RGNBoorszGpZas6jPoo3Q@mail.gmail.com>
Subject: Re: Re: Re: [PATCH 5.4 39/78] Bluetooth: use correct lock to prevent
 UAF of hdev object
To:     LinMa <linma@zju.edu.cn>
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Jun 2021 at 15:20, LinMa <linma@zju.edu.cn> wrote:
[SNIP]
>
> However, it seems that this patch breaks the rule and we have to figure o=
ut a better one. T^T
> (I just hope this patch won't introduce any security impacts but just thi=
s warning BUG, at least it will help with the previous UAF one)

Out of curiosity (since I'm seeing this warning a lot), I turned on
some of the various lock debugging options, and get the following:
[  171.250942] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  171.250945] WARNING: possible circular locking dependency detected
[  171.250949] 5.10.45-lockdep #72 Tainted: G        W
[  171.250952] ------------------------------------------------------
[  171.250955] kworker/u4:30/3998 is trying to acquire lock:
[  171.250958] ffff892194614130
(sk_lock-AF_BLUETOOTH-BTPROTO_HCI){+.+.}-{0:0}, at:
hci_sock_dev_event+0x160/0x1f6 [bluetooth]
[  171.250974]
               but task is already holding lock:
[  171.250977] ffffffffc08a4808 (hci_sk_list.lock){++++}-{2:2}, at:
hci_sock_dev_event+0x134/0x1f6 [bluetooth]
[  171.250993]
               which lock already depends on the new lock.

[  171.250996]
               the existing dependency chain (in reverse order) is:
[  171.250999]
               -> #1 (hci_sk_list.lock){++++}-{2:2}:
[  171.251008]        _raw_read_lock+0x3e/0x7c
[  171.251020]        hci_send_to_channel+0x27/0x4b [bluetooth]
[  171.251032]        hci_sock_sendmsg+0x8fe/0x92a [bluetooth]
[  171.251037]        sock_sendmsg+0x72/0x76
[  171.251041]        ____sys_sendmsg+0x16c/0x1e5
[  171.251045]        ___sys_sendmsg+0x95/0xd1
[  171.251048]        __sys_sendmsg+0x86/0xc0
[  171.251052]        do_syscall_64+0x43/0x55
[  171.251056]        entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  171.251059]
               -> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_HCI){+.+.}-{0:0}:
[  171.251068]        __lock_acquire+0x1519/0x2a2f
[  171.251072]        lock_acquire+0x191/0x265
[  171.251076]        lock_sock_nested+0x7b/0x8a
[  171.251087]        hci_sock_dev_event+0x160/0x1f6 [bluetooth]
[  171.251099]        hci_unregister_dev+0x16a/0x313 [bluetooth]
[  171.251103]        btusb_disconnect+0x77/0x127 [btusb]
[  171.251107]        usb_unbind_interface+0xa9/0x231
[  171.251111]        device_release_driver_internal+0x100/0x1a2
[  171.251115]        unbind_marked_interfaces+0x4e/0x69
[  171.251118]        usb_resume+0x59/0x66
[  171.251122]        dpm_run_callback+0x48/0x95
[  171.251125]        device_resume+0x1f3/0x25d
[  171.251128]        async_resume+0x1d/0x42
[  171.251132]        async_run_entry_fn+0x3d/0xd1
[  171.251137]        process_one_work+0x2a1/0x51c
[  171.251141]        worker_thread+0x215/0x376
[  171.251145]        kthread+0x159/0x168
[  171.251149]        ret_from_fork+0x22/0x30
[  171.251152]
               other info that might help us debug this:

[  171.251155]  Possible unsafe locking scenario:

[  171.251158]        CPU0                    CPU1
[  171.251161]        ----                    ----
[  171.251163]   lock(hci_sk_list.lock);
[  171.251168]
lock(sk_lock-AF_BLUETOOTH-BTPROTO_HCI);
[  171.251172]                                lock(hci_sk_list.lock);
[  171.251176]   lock(sk_lock-AF_BLUETOOTH-BTPROTO_HCI);
[  171.251181]
                *** DEADLOCK ***

It looks like there's a potential deadlock between hci_sock_sendmsg()
and hci_sock_dev_event(). In particular:
hci_sock_sendmsg(channel =3D=3D HCI_CHANNEL_LOGGING) acquires lock_sock(sk)=
;
-> hci_logging_frame()
-> hci_send_to_channel() acquires read_lock(&hci_sk_list.lock);

and:
hci_sock_dev_event() acquires read_lock(&hci_sk_list.lock); then lock_sock(=
sk);

Granted, this is likely very rare. But I think it is still a concern.

>
> My direct idea is to replace the hci_sk_list.lock to another sleep-able l=
ock too. Or we have to craft the logic to allow the HCI_DEV_UNREG event to =
signal other functions to abandon the lock. I'm going to working on this, a=
nd hope to get some suggestions just like before.
>
> And Greg, really sorry to submit this not properly tested patch. Please p=
ardon me for this unintended mistake. :(
>
> Regards
> Lin Ma



--=20
Anand K. Mistry
Software Engineer
Google Australia
