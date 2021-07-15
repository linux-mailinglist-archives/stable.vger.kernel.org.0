Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A25A3CA997
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbhGOTHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241950AbhGOTGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:06:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A676613FB;
        Thu, 15 Jul 2021 19:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375769;
        bh=PTmuQ+jgb47AOA2Ebl+Ynrr6Y303UUE+WJIg1P24iZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKsvPRVZphFHaR7SADfDI0O0/3sxD721ajlnU8xggd/jQFu2sSZolRIrMgxHZ49P3
         OQgNokDt7Mr0jVR7ID1Q9PN8Ut9oab0Fnj8GqELTl8zzAFQ9FeTu19FHy3Fxq9SUgq
         2NnI4Y8RDsiARuiOg2PO2trVnBOQKuK3abXXccxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com,
        Antti Palosaari <crope@iki.fi>,
        Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.12 228/242] media: rtl28xxu: fix zero-length control request
Date:   Thu, 15 Jul 2021 20:39:50 +0200
Message-Id: <20210715182633.025050739@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 25d5ce3a606a1eb23a9265d615a92a876ff9cb5f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -612,8 +612,9 @@ static int rtl28xxu_read_config(struct d
 static int rtl28xxu_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	struct rtl28xxu_dev *dev = d_to_priv(d);
+	u8 buf[1];
 	int ret;
-	struct rtl28xxu_req req_demod_i2c = {0x0020, CMD_I2C_DA_RD, 0, NULL};
+	struct rtl28xxu_req req_demod_i2c = {0x0020, CMD_I2C_DA_RD, 1, buf};
 
 	dev_dbg(&d->intf->dev, "\n");
 


