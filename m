Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6943E7E79
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhHJRdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhHJRdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F0E60F35;
        Tue, 10 Aug 2021 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616771;
        bh=ZxBTzNRCYWOy37PUIjrXP8rUkmJzh/1RLYGp7oVvQGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISUOYHW7lbhp7HQ8Vxd/meKkOj+cU9yhxJ3Vqt4jRVJSP78nI8a0X7FGlxPnYG/08
         LW6TLPNUjL+qhGhEy5YnNfN/qNl5a18aV6SG3wa2DkOEhQoSxSpg+A25rvLBuDuycb
         8YaCPEReT80vcmyD6A1EJu1vGnDNvUk5WzkDk8XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com,
        Eero Lehtinen <debiangamer2@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Johan Hovold <johan@kernel.org>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 38/54] media: rtl28xxu: fix zero-length control request
Date:   Tue, 10 Aug 2021 19:30:32 +0200
Message-Id: <20210810172945.440686848@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 76f22c93b209c811bd489950f17f8839adb31901 upstream.

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
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -50,7 +50,16 @@ static int rtl28xxu_ctrl_msg(struct dvb_
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


