Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818D8398951
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 14:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFBMWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 08:22:09 -0400
Received: from www.linuxtv.org ([130.149.80.248]:46042 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhFBMWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 08:22:09 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1loPrC-00GEsr-60; Wed, 02 Jun 2021 12:20:22 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Wed, 02 Jun 2021 12:15:42 +0000
Subject: [git:media_stage/master] media: rtl28xxu: fix zero-length control request
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Antti Palosaari <crope@iki.fi>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1loPrC-00GEsr-60@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: rtl28xxu: fix zero-length control request
Author:  Johan Hovold <johan@kernel.org>
Date:    Mon May 24 13:09:20 2021 +0200

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Control transfers without a data stage are treated as OUT requests by
the USB stack and should be using usb_sndctrlpipe(). Failing to do so
will now trigger a warning.

Fix the zero-length i2c-read request used for type detection by
attempting to read a single byte instead.

Reported-by: syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com
Fixes: d0f232e823af ("[media] rtl28xxu: add heuristic to detect chip type")
Cc: stable@vger.kernel.org      # 4.0
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 97ed17a141bb..2c04ed8af0e4 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -612,8 +612,9 @@ static int rtl28xxu_read_config(struct dvb_usb_device *d)
 static int rtl28xxu_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	struct rtl28xxu_dev *dev = d_to_priv(d);
+	u8 buf[1];
 	int ret;
-	struct rtl28xxu_req req_demod_i2c = {0x0020, CMD_I2C_DA_RD, 0, NULL};
+	struct rtl28xxu_req req_demod_i2c = {0x0020, CMD_I2C_DA_RD, 1, buf};
 
 	dev_dbg(&d->intf->dev, "\n");
 
