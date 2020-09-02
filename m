Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C8D25AB8C
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 14:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIBM6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 08:58:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33630 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgIBM6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 08:58:32 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 95F651C0B7F; Wed,  2 Sep 2020 14:58:28 +0200 (CEST)
Date:   Wed, 2 Sep 2020 14:58:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        syzbot+c2c3302f9c601a4b1be2@syzkaller.appspotmail.com
Subject: Re: [PATCH 4.19 108/125] USB: yurex: Fix bad gfp argument
Message-ID: <20200902125827.GA8817@duo.ucw.cz>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150939.905188730@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <20200901150939.905188730@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The syzbot fuzzer identified a bug in the yurex driver: It passes
> GFP_KERNEL as a memory-allocation flag to usb_submit_urb() at a time
> when its state is TASK_INTERRUPTIBLE, not TASK_RUNNING:

Yeah, and instead of fixing the bug, patch papers over it, reducing
reliability of the driver in the process.

> This patch changes the call to use GFP_ATOMIC instead of GFP_KERNEL.

Fixing it properly should be as simple as moving prepare_to_wait down,
no?

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 785080f79073..5fbbb57e6e95 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -489,10 +489,10 @@ static ssize_t yurex_write(struct file *file, const c=
har __user *user_buffer,
 	}
=20
 	/* send the data as the control msg */
-	prepare_to_wait(&dev->waitq, &wait, TASK_INTERRUPTIBLE);
 	dev_dbg(&dev->interface->dev, "%s - submit %c\n", __func__,
 		dev->cntl_buffer[0]);
-	retval =3D usb_submit_urb(dev->cntl_urb, GFP_ATOMIC);
+	retval =3D usb_submit_urb(dev->cntl_urb, GFP_KERNEL);
+	prepare_to_wait(&dev->waitq, &wait, TASK_INTERRUPTIBLE);
 	if (retval >=3D 0)
 		timeout =3D schedule_timeout(YUREX_WRITE_TIMEOUT);
 	finish_wait(&dev->waitq, &wait);


Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX0+W8wAKCRAw5/Bqldv6
8qhCAKCALokkNqTK/gKXORopIw1iBG/XuwCguq4niA/xdb8rAIcmbmunTeGsIu0=
=PAfh
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
