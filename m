Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84901103069
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 00:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfKSXpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 18:45:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34484 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfKSXpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 18:45:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574207152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3bFj7LSbHt/7ruFNmSC+gYmj5OfI/vxqc7ZinRrkQ1A=;
        b=TzbuEuvIg9aI5VJuEbmsOy42VGUjp++eWjzYc8bwRP7qHDF2J4ovuUaiwumMimucAE6xH6
        0wHdRq6oFQCirg5Oqrwh09RcBYYC9b0YyLyx2LsBpvQYQ4NbO5Bg1mN4C0Qbvn+6i6kciw
        6azNt5Hx3//vlgGLC/t/bi7Vim41wWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-OLmRwB14PtS3nQai2skpxQ-1; Tue, 19 Nov 2019 18:45:50 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 735D0100551A;
        Tue, 19 Nov 2019 23:45:48 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-46.bss.redhat.com [10.20.1.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8415810375FC;
        Tue, 19 Nov 2019 23:45:41 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     linux-input@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        =?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@gmail.com>,
        Nick Black <dankamongmen@gmail.com>,
        Yussuf Khalil <dev@pp3345.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexander Mikhaylenko <exalm7659@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "Input: synaptics - enable RMI mode for X1 Extreme 2nd Generation"
Date:   Tue, 19 Nov 2019 18:45:33 -0500
Message-Id: <20191119234534.10725-1-lyude@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: OLmRwB14PtS3nQai2skpxQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 68b9c5066e39af41d3448abfc887c77ce22dd64d.

Ugh, I really dropped the ball on this one :\. So as it turns out RMI4
works perfectly fine on the X1 Extreme Gen 2 except for one thing I
didn't notice because I usually use the trackpoint: clicking with the
touchpad. Somehow this is broken, in fact we don't even seem to indicate
BTN_LEFT as a valid event type for the RMI4 touchpad. And, I don't even
see any RMI4 events coming from the touchpad when I press down on it.
This only seems to work for PS/2 mode.

Since that means we have a regression, and PS/2 mode seems to work fine
for the time being - revert this for now. We'll have to do a more
thorough investigation on this.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/input/mouse/synaptics.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptic=
s.c
index 704558d449a2..56fae3472114 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -177,7 +177,6 @@ static const char * const smbus_pnp_ids[] =3D {
 =09"LEN0096", /* X280 */
 =09"LEN0097", /* X280 -> ALPS trackpoint */
 =09"LEN009b", /* T580 */
-=09"LEN0402", /* X1 Extreme 2nd Generation */
 =09"LEN200f", /* T450s */
 =09"LEN2054", /* E480 */
 =09"LEN2055", /* E580 */
--=20
2.21.0

