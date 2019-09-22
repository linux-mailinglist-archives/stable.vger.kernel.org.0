Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8422BBA79E
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438842AbfIVS7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406582AbfIVS7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:59:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 780072184D;
        Sun, 22 Sep 2019 18:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178761;
        bh=5PRxwvJOPGRmn8UkRJJoesonvbFonXLvvtfiGZcZyPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4Af2OTjETui8e+lb92hmxdV3Xp7cA64Um7vXxyD4redXnDqTMKnRkvu11BUEPZvO
         jRUtkmFQsVGcyXZDtTUtXqMVmfEwq6+KriImqSqDO6/jGR3fTWgJAWEvIiqkSGbkr+
         vJRz9tJyQGl4JjiHkd06CjxOc+z73jTT5tVKLsRI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        syzbot+eaaaf38a95427be88f4b@syzkaller.appspotmail.com,
        Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 82/89] media: technisat-usb2: break out of loop at end of buffer
Date:   Sun, 22 Sep 2019 14:57:10 -0400
Message-Id: <20190922185717.3412-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

[ Upstream commit 0c4df39e504bf925ab666132ac3c98d6cbbe380b ]

Ensure we do not access the buffer beyond the end if no 0xff byte
is encountered.

Reported-by: syzbot+eaaaf38a95427be88f4b@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/technisat-usb2.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index 18d0f8f5283fa..8d8e9f56a8be5 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -607,10 +607,9 @@ static int technisat_usb2_frontend_attach(struct dvb_usb_adapter *a)
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
@@ -646,26 +645,25 @@ static int technisat_usb2_get_ir(struct dvb_usb_device *d)
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
-- 
2.20.1

