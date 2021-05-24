Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0519A38E4F9
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 13:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbhEXLLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 07:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232734AbhEXLLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 07:11:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8775361153;
        Mon, 24 May 2021 11:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621854582;
        bh=GVsPUYUbH6Fhhs9/c1HYG789KkLiGQmAFPvGxAEzfZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcwVbcNJ0Akpo4wTKnWBaTfvzngnBY9pvoRnrM6kiZoEiZBS+zyPHwbmI6J7k3Vfu
         +kmyyh5jCP5lGK4RelfJJgRC0u09ocQLXuL271GdSQQe5HOQ3UB+oyPyiL7tYWdrzF
         Efe217s5NENfYhE7A7VEFcDvj9lT/WNUulhVDllPe81oFARpMfKxSsxqHqCxCLDQSW
         TAHoOFJMTP0KrPiYaxuelbp3HiYJkeVXI65AHxn0dEbwWzzYhDAqkfpm1hWlc0bEyi
         EDgPW+nqgGTzB+tkXrfDEX+q/zR+EiUdz8JC6ZL05m/CDLo/kS9jE2eAfMtUwRR2J5
         cwod2wQaCBeNA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ll8Sp-0006Pt-Hr; Mon, 24 May 2021 13:09:39 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] media: rtl28xxu: fix zero-length control request
Date:   Mon, 24 May 2021 13:09:20 +0200
Message-Id: <20210524110920.24599-4-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210524110920.24599-1-johan@kernel.org>
References: <20210524110920.24599-1-johan@kernel.org>
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

Fix the zero-length i2c-read request used for type detection by
attempting to read a single byte instead.

Reported-by: syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com
Fixes: d0f232e823af ("[media] rtl28xxu: add heuristic to detect chip type")
Cc: stable@vger.kernel.org      # 4.0
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
 
-- 
2.26.3

