Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCE41770A2
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 09:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgCCIBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 03:01:40 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:43687 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbgCCIBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 03:01:40 -0500
Received: from [5.158.153.52] (helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1j92Ue-0001yk-Jk; Tue, 03 Mar 2020 09:01:32 +0100
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        gregkh@linuxfoundation.org, lirongqing@baidu.com,
        stable@vger.kernel.org, vikram.pandita@ti.com
Subject: Re: FAILED: patch "[PATCH] serial: 8250: Check UPF_IRQ_SHARED in advance" failed to apply to 4.14-stable tree
In-Reply-To: <20200228183643.GB21491@sasha-vm>
References: <158271336456142@kroah.com> <20200226233949.GC22178@sasha-vm> <20200227095908.GC1224808@smile.fi.intel.com> <87r1yf2j57.fsf@kurt> <20200228183643.GB21491@sasha-vm>
Date:   Tue, 03 Mar 2020 09:01:23 +0100
Message-ID: <87wo81c1f0.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Sasha,

On Fri Feb 28 2020, Sasha Levin wrote:
> Hm, yes, looking at it now it doesn't look too tricky, I'm not sure what
> happened a few days ago :)
>
> If you want to send me a backport I'll be happy to queue it up.

Sure. In v4.9 and older kernels the bug exists, but the workarounds
aren't applied. So, Andy's patch becomes shorter.

Here's a backport for v4.9 (compile tested only):

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
From=20e819a733cc31d0a6b598aafafc8230fefa37f34a Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 3 Mar 2020 08:49:55 +0100
Subject: [PATCH] serial: 8250: Check UPF_IRQ_SHARED in advance

The commit 54e53b2e8081
  ("tty: serial: 8250: pass IRQ shared flag to UART ports")
nicely explained the problem:

=2D--8<---8<---

On some systems IRQ lines between multiple UARTs might be shared. If so, the
irqflags have to be configured accordingly. The reason is: The 8250 port st=
artup
code performs IRQ tests *before* the IRQ handler for that particular port is
registered. This is performed in serial8250_do_startup(). This function che=
cks
whether IRQF_SHARED is configured and only then disables the IRQ line while
testing.

This test is performed upon each open() of the UART device. Imagine two UAR=
Ts
share the same IRQ line: On is already opened and the IRQ is active. When t=
he
second UART is opened, the IRQ line has to be disabled while performing IRQ
tests. Otherwise an IRQ might handler might be invoked, but the IRQ itself
cannot be handled, because the corresponding handler isn't registered,
yet. That's because the 8250 code uses a chain-handler and invokes the
corresponding port's IRQ handling routines himself.

Unfortunately this IRQF_SHARED flag isn't configured for UARTs probed via d=
evice
tree even if the IRQs are shared. This way, the actual and shared IRQ line =
isn't
disabled while performing tests and the kernel correctly detects a spurious
IRQ. So, adding this flag to the DT probe solves the issue.

Note: The UPF_SHARE_IRQ flag is configured unconditionally. Therefore, the
IRQF_SHARED flag can be set unconditionally as well.

Example stack trace by performing `echo 1 > /dev/ttyS2` on a non-patched sy=
stem:

|irq 85: nobody cared (try booting with the "irqpoll" option)
| [...]
|handlers:
|[<ffff0000080fc628>] irq_default_primary_handler threaded [<ffff00000855fb=
b8>] serial8250_interrupt
|Disabling IRQ #85

=2D--8<---8<---

But unfortunately didn't fix the root cause. Let's try again here by moving
IRQ flag assignment from serial_link_irq_chain() to serial8250_do_startup().

This should fix the similar issue reported for 8250_pnp case.

Since this change we don't need to have custom solutions in 8250_aspeed_vua=
rt
and 8250_of drivers, thus, drop them.

Fixes: 1c2f04937b3e ("serial: 8250: add IRQ trigger support")
Reported-by: Li RongQing <lirongqing@baidu.com>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
Cc: Vikram Pandita <vikram.pandita@ti.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[Kurt: Backport to v4.9]
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
=2D--
 drivers/tty/serial/8250/8250_core.c | 5 ++---
 drivers/tty/serial/8250/8250_port.c | 4 ++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/=
8250_core.c
index e8819aa20415..c4e9eba36023 100644
=2D-- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -181,7 +181,7 @@ static int serial_link_irq_chain(struct uart_8250_port =
*up)
 	struct hlist_head *h;
 	struct hlist_node *n;
 	struct irq_info *i;
=2D	int ret, irq_flags =3D up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
+	int ret;
=20
 	mutex_lock(&hash_mutex);
=20
@@ -216,9 +216,8 @@ static int serial_link_irq_chain(struct uart_8250_port =
*up)
 		INIT_LIST_HEAD(&up->list);
 		i->head =3D &up->list;
 		spin_unlock_irq(&i->lock);
=2D		irq_flags |=3D up->port.irqflags;
 		ret =3D request_irq(up->port.irq, serial8250_interrupt,
=2D				  irq_flags, "serial", i);
+				  up->port.irqflags, "serial", i);
 		if (ret < 0)
 			serial_do_unlink(i, up);
 	}
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/=
8250_port.c
index 8f1233324586..c7a7574172fa 100644
=2D-- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2199,6 +2199,10 @@ int serial8250_do_startup(struct uart_port *port)
 		}
 	}
=20
+	/* Check if we need to have shared IRQs */
+	if (port->irq && (up->port.flags & UPF_SHARE_IRQ))
+		up->port.irqflags |=3D IRQF_SHARED;
+
 	if (port->irq) {
 		unsigned char iir1;
 		/*
=2D-=20
2.20.1

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

What do you think?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl5eDtMACgkQeSpbgcuY
8KZrdg/+KKlVOAh8kFolQsOaPLDdjhI2xV3cw+hKr52bY3AaZ/FR7al3zLVPvlfV
pAQoTtBCFwoj4rQafv9bRPXodJY3WCmsrWKvsIMwpUcVZfXDJSR6rtKKL51ECFNu
ZJ1ZcnoYXhNVnGJaXaiiAAYv5T3pZEoMXqxE1QVpqV+9pGWAVoLWmDKDOVCXjwbT
4QE/n3eki4fKwR98+6CrJzLp+VQsEnbKz4Bmqb644N/s6WMwJo8ZQTs7TIoSLQA3
ZsVCYS7gmKId+T026xQ8moTNm8kXhyuKxOKOpC4hf0mg6AGA/BAZZoHlmIu6i4kX
Zz/s5zPSyaPGFqAJmclubVjYgL5anXE48nda87/487bPwj2RWHbEfTD8L9jepkDN
qJvevA5Ct8S4t5CbNLdNgSAtRnMiagJb9kx3P15S06RDgOgDy22pD+pGYbvkaFwy
OYwtxuIc+ondjfE1ApUfRL0HNZxr6EYUvXiliXrFqNs1ZB4VdosUvQES7SRx3ajQ
w0pG82UwdP20VgIukwWl/CSjS3+THtYnHD0ujk/CUm1sCZCo4qo32sYWuj9A4f95
WCikC9nFzIbGekG+6fvTdBS+1gaaTcP+Ffpk3AwavY+UoAvJjfng+BPSP+WVuCPW
NbDsS0yJIdw6/481W5EWV8SiDjgKg/e2wcJxXy7vzQDvrNaSinA=
=YJXa
-----END PGP SIGNATURE-----
--=-=-=--
