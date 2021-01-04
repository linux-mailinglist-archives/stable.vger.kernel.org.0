Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5797A2E9A12
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbhADQHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:07:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbhADQCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F1C9224D4;
        Mon,  4 Jan 2021 16:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776125;
        bh=6klDzbX4FQiuaswtnqPILcKm00O72X6oRw8pRkFUjYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mS5IcDqymtvPIu9NeOv9WwLRrb26Dd6cET6maoRSOG8kkkSVDS1GFHH3bOnsJWq83
         2O1lt+oBy5Qj3IEmoPmYl5mDwm4K3gNzW4GdQhBgiSaDxJ/q5bEbLig28LAujvs+1S
         +Sl6b3YGuuqgU23hwELLeUzyPBm+1v9kPj/6MMoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 31/63] media: gp8psk: initialize stats at power control logic
Date:   Mon,  4 Jan 2021 16:57:24 +0100
Message-Id: <20210104155710.330091955@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit d0ac1a26ed5943127cb0156148735f5f52a07075 upstream.

As reported on:
	https://lore.kernel.org/linux-media/20190627222020.45909-1-willemdebruijn.kernel@gmail.com/

if gp8psk_usb_in_op() returns an error, the status var is not
initialized. Yet, this var is used later on, in order to
identify:
	- if the device was already started;
	- if firmware has loaded;
	- if the LNBf was powered on.

Using status = 0 seems to ensure that everything will be
properly powered up.

So, instead of the proposed solution, let's just set
status = 0.

Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb/gp8psk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -182,7 +182,7 @@ out_rel_fw:
 
 static int gp8psk_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
-	u8 status, buf;
+	u8 status = 0, buf;
 	int gp_product_id = le16_to_cpu(d->udev->descriptor.idProduct);
 
 	if (onoff) {


