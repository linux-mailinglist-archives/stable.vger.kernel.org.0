Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB40B85E2
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405103AbfISWZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407057AbfISWXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:23:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5356521920;
        Thu, 19 Sep 2019 22:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931833;
        bh=YPQUVoNFly186FGiihx6pRJ6rB1JjNJQOT4c6Wej2H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJN+L7tQn2bh3hjTlpk/Tco3E78Ch8x3Mf4rD745NjDvBrrkW+YCXr0HGfFhAEQys
         uA7N0Q2qUrS/DUYBD4S1ij95hmdQT3hIhe2BQU9zbtzUWNBoUCzzeuRo4jH6dSm78X
         /C6t4bZdafa5Wf/4LtrMUZZMhcK0iD1rDAe98JDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+eaaaf38a95427be88f4b@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>, Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.4 55/56] media: technisat-usb2: break out of loop at end of buffer
Date:   Fri, 20 Sep 2019 00:04:36 +0200
Message-Id: <20190919214805.053463953@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 0c4df39e504bf925ab666132ac3c98d6cbbe380b upstream.

Ensure we do not access the buffer beyond the end if no 0xff byte
is encountered.

Reported-by: syzbot+eaaaf38a95427be88f4b@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb/technisat-usb2.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -594,9 +594,9 @@ static int technisat_usb2_frontend_attac
 
 static int technisat_usb2_get_ir(struct dvb_usb_device *d)
 {
-	u8 buf[62], *b;
-	int ret;
+	u8 buf[62];
 	struct ir_raw_event ev;
+	int i, ret;
 
 	buf[0] = GET_IR_DATA_VENDOR_REQUEST;
 	buf[1] = 0x08;
@@ -632,26 +632,25 @@ unlock:
 		return 0; /* no key pressed */
 
 	/* decoding */
-	b = buf+1;
 
 #if 0
 	deb_rc("RC: %d ", ret);
-	debug_dump(b, ret, deb_rc);
+	debug_dump(buf + 1, ret, deb_rc);
 #endif
 
 	ev.pulse = 0;
-	while (1) {
-		ev.pulse = !ev.pulse;
-		ev.duration = (*b * FIRMWARE_CLOCK_DIVISOR * FIRMWARE_CLOCK_TICK) / 1000;
-		ir_raw_event_store(d->rc_dev, &ev);
-
-		b++;
-		if (*b == 0xff) {
+	for (i = 1; i < ARRAY_SIZE(buf); i++) {
+		if (buf[i] == 0xff) {
 			ev.pulse = 0;
 			ev.duration = 888888*2;
 			ir_raw_event_store(d->rc_dev, &ev);
 			break;
 		}
+
+		ev.pulse = !ev.pulse;
+		ev.duration = (buf[i] * FIRMWARE_CLOCK_DIVISOR *
+			       FIRMWARE_CLOCK_TICK) / 1000;
+		ir_raw_event_store(d->rc_dev, &ev);
 	}
 
 	ir_raw_event_handle(d->rc_dev);


