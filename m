Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C723B1624
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 10:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFWIse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 04:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhFWIse (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 04:48:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 301B561164;
        Wed, 23 Jun 2021 08:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624437977;
        bh=mG6ErbLJ7lSo5V7i1rljNDUgVDQwNGUi4e3zpOu3v4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3Pyyo8QTH5g3DOMYBfcOVv1YW6m3r+/ul6h17e76XRM3i/yuG5G1/sqBHAKCNfZ2
         Co4+AzYA/oD209zeeJhoHo0qJCzssCLeevSb2GV5sXYcoQbhcS6URt0TpKlvi+IGjA
         sHU1cmKP96oXndPZMdvXYQ6acfocMwgVOp8x5DGt8/l4w5oTwAGcakxsvy7zpGsdj8
         GCsJ1ZdMcKOWUazjGlUbNn6YHok3MpgFHSbX2eBTML9b/ul7TtpEXqp3o/C6qFy1t6
         Pxmd3v7Zh7W8MvuiuU7tb3Z91uvRoXkP8T/W2MFfFNI7eocPxSypMNhZGRwdOoQpNy
         hzEXYs7Kuiavw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lvyWV-0001s2-UM; Wed, 23 Jun 2021 10:46:15 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Antti Palosaari <crope@iki.fi>,
        Eero Lehtinen <debiangamer2@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH 2/2] media: rtl28xxu: fix zero-length control request
Date:   Wed, 23 Jun 2021 10:45:21 +0200
Message-Id: <20210623084521.7105-3-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210623084521.7105-1-johan@kernel.org>
References: <20210623084521.7105-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Control transfers without a data stage are treated as OUT requests by
the USB stack and should be using usb_sndctrlpipe(). Failing to do so
will now trigger a warning.

The driver uses a zero-length i2c-read request for type detection so
update the control-request code to use usb_sndctrlpipe() in this case.

Note that actually trying to read the i2c register in question does not
work as the register might not exist (e.g. depending on the demodulator)
as reported by Eero Lehtinen <debiangamer2@gmail.com>.

Reported-by: syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com
Reported-by: Eero Lehtinen <debiangamer2@gmail.com>
Tested-by: Eero Lehtinen <debiangamer2@gmail.com>
Fixes: d0f232e823af ("[media] rtl28xxu: add heuristic to detect chip type")
Cc: stable@vger.kernel.org      # 4.0
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 0cbdb95f8d35..795a012d4020 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -37,7 +37,16 @@ static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
 	} else {
 		/* read */
 		requesttype = (USB_TYPE_VENDOR | USB_DIR_IN);
-		pipe = usb_rcvctrlpipe(d->udev, 0);
+
+		/*
+		 * Zero-length transfers must use usb_sndctrlpipe() and
+		 * rtl28xxu_identify_state() uses a zero-length i2c read
+		 * command to determine the chip type.
+		 */
+		if (req->size)
+			pipe = usb_rcvctrlpipe(d->udev, 0);
+		else
+			pipe = usb_sndctrlpipe(d->udev, 0);
 	}
 
 	ret = usb_control_msg(d->udev, pipe, 0, requesttype, req->value,
-- 
2.31.1

