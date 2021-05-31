Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0F39585A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 11:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhEaJrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 05:47:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231172AbhEaJra (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 05:47:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11BFE6103E;
        Mon, 31 May 2021 09:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622454351;
        bh=jF62RzkWE7fS2aErLRL97R4fHohCVIw0Or/yoZ4tfN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/0IKrQFbRJkV+NAU7aBGlJgPdUhoLQrHQmidvU9HQFHvpZNCma1Lpj7doG6kpxf6
         CtIs4xXX9BM6osGWtIMaR5+qiRucS+ZPyH0EjvQm1LkSWCXk9nC3k9rSmh3qKCG6tj
         sXVyUIH9UZWVNRGru9Hd3ljVdwvjl9Jq/o0JtqDhzxsnjzYDwFroB8qF7qS/zWGEFM
         o4cKPcxJQiTyzfJWwIVixIOjvsRRQpNTmNaYVufpx+RacjfttK5Nj2WU6EDD/A2M5n
         o/KpQagRejQjH3AWp3GDvS01Pkm2lG9tAEGep/GnFbEZGNFt9Gnkys6mPqteIGVTZM
         r/RQXDEYvPTeA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lneUU-0003JP-Dy; Mon, 31 May 2021 11:45:46 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eero Lehtinen <debiangamer2@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2 3/3] media: rtl28xxu: fix zero-length control request
Date:   Mon, 31 May 2021 11:44:34 +0200
Message-Id: <20210531094434.12651-4-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531094434.12651-1-johan@kernel.org>
References: <20210531094434.12651-1-johan@kernel.org>
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
index 97ed17a141bb..a6124472cb06 100644
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

