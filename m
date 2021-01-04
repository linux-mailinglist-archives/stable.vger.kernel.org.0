Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A996E2E9AAB
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbhADP7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:59:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbhADP7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:59:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E809522581;
        Mon,  4 Jan 2021 15:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775959;
        bh=DFWKiau7hlhlTqppCxv5Uc3+xLeRAQL1o3WuyyBMoVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AW9wsq9cGI5YhzISkK8DvKSUWgYU0b1gOizkVNMuE3msUrM0UywxLOnIevc5aTwwA
         GtMtem920QZsXY5U2UAt78CL3yGsu0Blpfskr+nEfqlFxbl0jdyHr8EXakNm/9jM59
         n9GW8AHmG9rcWp3scYsAnURm3ZqZuwko3WypPSJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 24/35] media: gp8psk: initialize stats at power control logic
Date:   Mon,  4 Jan 2021 16:57:27 +0100
Message-Id: <20210104155704.576999164@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
References: <20210104155703.375788488@linuxfoundation.org>
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
@@ -185,7 +185,7 @@ out_rel_fw:
 
 static int gp8psk_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
-	u8 status, buf;
+	u8 status = 0, buf;
 	int gp_product_id = le16_to_cpu(d->udev->descriptor.idProduct);
 
 	if (onoff) {


