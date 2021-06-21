Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96D33AE1EF
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 05:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhFUDsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 23:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhFUDsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Jun 2021 23:48:16 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611A0C061756
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 20:46:02 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id b1so8445110vsh.7
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 20:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bgDx2y7jnHVgqpuH7DSftkNRKg871OtZSQDSrAU/dKc=;
        b=RBgI4HZOPSLWFitfDhCXIi1mcWgVvf3+50V5tuKS/O8N8Nja87eY9XsQ8PGbHRDp9k
         ltUFHJ6eDpV4UUlkmvP+A9XJF+swllOumaSrn1A2bi46Ei36fhBwCYcWsZ+/AvAwEbz7
         S0KYpU/qfIYt6V79RiP/1Ys3Qp2E2q79UeYI2trez2eKuLm74gbksVymh+y+rr/ZoZbz
         SS8fUnjBmIVwXjQk7sTIGSL5G0fM1mn0HzC8U4JP/nFQKza5qo+dG/eVtHxgzWg5tWU3
         lFmOa1AqiIqNsFk81RdFuDYEZ8B8sENcTLkDcXXAlXlfDAoG33qm0J7n7NlnHj7NBUyV
         PLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bgDx2y7jnHVgqpuH7DSftkNRKg871OtZSQDSrAU/dKc=;
        b=SaLpcmGy0KA1DH3mKTBPA9uS/2DHuYWCSGc1hEkokxH4ya4aBNKX7H2Elaz8Wqq7vI
         b27PxeF5Wllf51IjCyuQ1dRHAeOYPHPQdsVwgMWn4ulit/7vyPfLis3a1gFXUMiEMt4S
         vgvznCWPr2xBUAM+el6bFQiEj4MKRJOlyLXdli3b892S6L9QpgwwNZ0Vu5IShRxO+LG1
         qUmQ8P5/VbH+xFyoGHbjhMRNiJQGcDxmaTEnptxW/fCfLv9vH2sGCeXf9I3N2UBYdofI
         k6SoLHYISJqXFZPmXN8goWOTgsK5MHn2C+CY5K3mYuZomqKkvNavu0Yif4WTqtCdTeHh
         BqLQ==
X-Gm-Message-State: AOAM533Et6z4ccFuB4qqVl7Pe4ko9Qi2ND6IiIRiTwB1GgmBIeAsbs2G
        WQrp2L7EjXhz9SE6LZ1HVTMXg5zOTMeV3kXDZ4FxEA==
X-Google-Smtp-Source: ABdhPJy7ECzuz5hNyc7Izeqf3qovhAfGANrRMoXis/pR0LSbVi4JKaNiqOgKBjh4RwGD/ZfwWnpS/ebVXWAkHA/w0n0=
X-Received: by 2002:a05:6102:3026:: with SMTP id v6mr5152176vsa.1.1624247161113;
 Sun, 20 Jun 2021 20:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <70042d9f.111abd.17a19f94b84.Coremail.linma@zju.edu.cn>
In-Reply-To: <70042d9f.111abd.17a19f94b84.Coremail.linma@zju.edu.cn>
From:   "Anand K. Mistry" <amistry@google.com>
Date:   Mon, 21 Jun 2021 13:45:48 +1000
Message-ID: <CAATStaMu-Nx1XS=4fbK6T2cRanS8OvSzP_83dmSnEKB7pgpm8A@mail.gmail.com>
Subject: Re: Re: [PATCH 5.4 39/78] Bluetooth: use correct lock to prevent UAF
 of hdev object
To:     LinMa <linma@zju.edu.cn>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Jun 2021 at 22:37, LinMa <linma@zju.edu.cn> wrote:
>
>
> Oops, sorry for the delay here. I just forgot to check the mails.
>
> This comment is right, when I submit this patch I mentioned that the repl=
acement of this lock can hang the detaching routine because it needs to wai=
t the release of the lock_sock().
>
> But this does no harm in my testing. In fact, the relevant code can only =
be executed when removing the controller. I think it can wait for the lock.=
 Moreover, this patch can fix the potential UAF indeed.
>
> > may need further discussion. (wrote in previous mail list
>
> Welcome the additional advise on this. Does this really broken the lock p=
rinciple?

One more data point. I'm seeing this 100% of the time when trying the
suspend my system (on 5.10):

[  466.608970] BUG: sleeping function called from invalid context at
net/core/sock.c:3074
[  466.608975] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid:
5614, name: kworker/u4:4
[  466.608980] CPU: 1 PID: 5614 Comm: kworker/u4:4 Tainted: G        W
        5.10.43 #64
[  466.608983] Hardware name: HP Grunt/Grunt, BIOS
Google_Grunt.11031.104.0 09/05/2019
[  466.608991] Workqueue: events_unbound async_run_entry_fn
[  466.608995] Call Trace:
[  466.609003]  dump_stack+0x9c/0xe7
[  466.609009]  ___might_sleep+0x148/0x15e
[  466.609013]  lock_sock_nested+0x22/0x5d
[  466.609033]  hci_sock_dev_event+0x15a/0x1f0 [bluetooth]
[  466.609043]  hci_unregister_dev+0x15c/0x303 [bluetooth]
[  466.609049]  btusb_disconnect+0x77/0x127 [btusb]
[  466.609054]  usb_unbind_interface+0xa6/0x22e
[  466.609059]  ? usb_dev_suspend+0x14/0x14
[  466.609063]  device_release_driver_internal+0x100/0x1a1
[  466.609067]  unbind_marked_interfaces+0x4b/0x66
[  466.609071]  usb_resume+0x59/0x66
[  466.609075]  dpm_run_callback+0x8c/0x126
[  466.609078]  device_resume+0x1f1/0x25b
[  466.609082]  async_resume+0x1d/0x42
[  466.609085]  async_run_entry_fn+0x3d/0xd1
[  466.609089]  process_one_work+0x1b9/0x363
[  466.609093]  worker_thread+0x213/0x372
[  466.609097]  kthread+0x150/0x15f
[  466.609100]  ? pr_cont_work+0x58/0x58
[  466.609103]  ? kthread_blkcg+0x31/0x31
[  466.609106]  ret_from_fork+0x22/0x30


>
> Regards Lin Ma
>
> =E5=9C=A8 2021-06-16 23:01:08=EF=BC=8C"Greg Kroah-Hartman" <gregkh@linuxf=
oundation.org> =E5=86=99=E9=81=93=EF=BC=9A
>
> >On Mon, Jun 14, 2021 at 04:15:02PM +0200, Eric Dumazet wrote:
> >>
> >>
> >> On 6/8/21 8:27 PM, Greg Kroah-Hartman wrote:
> >> > From: Lin Ma <linma@zju.edu.cn>
> >> >
> >> > commit e305509e678b3a4af2b3cfd410f409f7cdaabb52 upstream.
> >> >
> >> > The hci_sock_dev_event() function will cleanup the hdev object for
> >> > sockets even if this object may still be in used within the
> >> > hci_sock_bound_ioctl() function, result in UAF vulnerability.
> >> >
> >> > This patch replace the BH context lock to serialize these affairs
> >> > and prevent the race condition.
> >> >
> >> > Signed-off-by: Lin Ma <linma@zju.edu.cn>
> >> > Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> >> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> > ---
> >> >  net/bluetooth/hci_sock.c |    4 ++--
> >> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >> >
> >> > --- a/net/bluetooth/hci_sock.c
> >> > +++ b/net/bluetooth/hci_sock.c
> >> > @@ -755,7 +755,7 @@ void hci_sock_dev_event(struct hci_dev *
> >> >            /* Detach sockets from device */
> >> >            read_lock(&hci_sk_list.lock);
> >> >            sk_for_each(sk, &hci_sk_list.head) {
> >> > -                  bh_lock_sock_nested(sk);
> >> > +                  lock_sock(sk);
> >> >                    if (hci_pi(sk)->hdev =3D=3D hdev) {
> >> >                            hci_pi(sk)->hdev =3D NULL;
> >> >                            sk->sk_err =3D EPIPE;
> >> > @@ -764,7 +764,7 @@ void hci_sock_dev_event(struct hci_dev *
> >> >
> >> >                            hci_dev_put(hdev);
> >> >                    }
> >> > -                  bh_unlock_sock(sk);
> >> > +                  release_sock(sk);
> >> >            }
> >> >            read_unlock(&hci_sk_list.lock);
> >> >    }
> >> >
> >> >
> >>
> >>
> >> This patch is buggy.
> >>
> >> lock_sock() can sleep.
> >>
> >> But the read_lock(&hci_sk_list.lock) two lines before is not going to =
allow the sleep.
> >>
> >> Hmmm ?
> >>
> >>
> >
> >Odd, Lin, did you see any problems with your testing of this?
> >



--=20
Anand K. Mistry
Software Engineer
Google Australia
