Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D160320500A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732227AbgFWLJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:09:46 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:34597 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732217AbgFWLJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:09:46 -0400
Date:   Tue, 23 Jun 2020 11:09:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1592910583; bh=twAyp3okr7kOUwXw1V0zgiy/sW5FRSDtzU2LxgNpArI=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=BCcgXjxKR/i/Wk7Lg+AP/wQU9CYm7lwjnWCZvfKrNyGFRkNyXf93czgX+hmRzsLbq
         GKLVJJgP0ETycDY/+PpsjDg84X+djkHgI7ZqxEv3fwKpSlwyRAgovuQ0zwHMnW31W1
         WT9uSLmGXUtJCYYp0//YbueWdegUThGDooujg96aTk1GRjaYVLKsvMnOFq0zZ/4Nat
         0C97ouZp6RbIcISEunxecl0L8VwDQJMfgvk/xG0KlO83U9jg7XknS7QXWm+QnY1m0i
         +EmKtdr1zQFOYtuz2pXkP4QJgmFlhbl9fRo+YRzxbcj/an7280MIQdzGnMFcGb6UHx
         LFkxWG+aenBXw==
To:     Amit Shah <amit@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?Q?Sjur_Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alexander Lobakin <alobakin@pm.me>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH resend] virtio: virtio_console: add missing MODULE_DEVICE_TABLE() for rproc serial
Message-ID: <x7C_CbeJtoGMy258nwAXASYz3xgFMFpyzmUvOyZzRnQrgWCREBjaqBOpAUS7ol4NnZYvSVwmTsCG0Ohyfvta-ygw6HMHcoeKK0C3QFiAO_Q=@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

rproc_serial_id_table lacks an exposure to module devicetable, so
when remoteproc firmware requests VIRTIO_ID_RPROC_SERIAL, no uevent
is generated and no module autoloading occurs.
Add missing MODULE_DEVICE_TABLE() annotation and move the existing
one for VIRTIO_ID_CONSOLE right to the table itself.

Fixes: 1b6370463e88 ("virtio_console: Add support for remoteproc serial")
Cc: <stable@vger.kernel.org> # v3.8+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Amit Shah <amit@kernel.org>
---
 drivers/char/virtio_console.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 00c5e3acee46..ca691bce9791 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2116,6 +2116,7 @@ static struct virtio_device_id id_table[] =3D {
 =09{ VIRTIO_ID_CONSOLE, VIRTIO_DEV_ANY_ID },
 =09{ 0 },
 };
+MODULE_DEVICE_TABLE(virtio, id_table);
=20
 static unsigned int features[] =3D {
 =09VIRTIO_CONSOLE_F_SIZE,
@@ -2128,6 +2129,7 @@ static struct virtio_device_id rproc_serial_id_table[=
] =3D {
 #endif
 =09{ 0 },
 };
+MODULE_DEVICE_TABLE(virtio, rproc_serial_id_table);
=20
 static unsigned int rproc_serial_features[] =3D {
 };
@@ -2280,6 +2282,5 @@ static void __exit fini(void)
 module_init(init);
 module_exit(fini);
=20
-MODULE_DEVICE_TABLE(virtio, id_table);
 MODULE_DESCRIPTION("Virtio console driver");
 MODULE_LICENSE("GPL");
--=20
2.27.0


