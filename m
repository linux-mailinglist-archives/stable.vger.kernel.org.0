Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06914B84E6
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404419AbfISWPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403915AbfISWP3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:15:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636A821907;
        Thu, 19 Sep 2019 22:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931328;
        bh=ont1s2hWDsj0rjL5UpbAstBll8ppiMiCPDPkdEjRjYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wdLUiEyiWXUoodjI9s+g3oRIDAHD0XhTP7zI+Ah4diTYKKI0fjC85+4kVlojZEot
         E51M5iG6o6poVlMlQ8tpCrEU++p6hqBJO/DCDlJc9DWMV3OAN6y0WwDMr+uwWPoQRW
         qt+m70sbzGSscyTCWfduMHSS2DDL4E08RZr486As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+eaaaf38a95427be88f4b@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>, Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.19 79/79] media: technisat-usb2: break out of loop at end of buffer
Date:   Fri, 20 Sep 2019 00:04:04 +0200
Message-Id: <20190919214814.696898666@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
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
 drivers/media/usb/dvb-usb/technisat-usb2.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -607,10 +607,9 @@ static int technisat_usb2_frontend_attac
 static int technisat_usb2_get_ir(struct dvb_usb_device *d)
 {
 	struct technisat_usb2_state *state = d->priv;
-	u8 *buf = state->buf;
-	u8 *b;
-	int ret;
 	struct ir_raw_event ev;
+	u8 *buf = state->buf;
+	int i, ret;
 
 	buf[0] = GET_IR_DATA_VENDOR_REQUEST;
 	buf[1] = 0x08;
@@ -646,26 +645,25 @@ unlock:
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
+	for (i = 1; i < ARRAY_SIZE(state->buf); i++) {
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


