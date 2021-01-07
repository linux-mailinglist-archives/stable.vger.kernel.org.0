Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF9C2ED1F9
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbhAGOUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728878AbhAGOQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:16:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1319F2336D;
        Thu,  7 Jan 2021 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028957;
        bh=+RLk9lYdvNLpt7zKTg3A8hOOqntSWyG7/83Cwg2Nzus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhPhLwhYINNxESmkxExMn+5rhgPKGvoRa8kkIJ8E7DlHulSTgD6lg5h/ZNeYFiy5C
         yWpCDAT8sXcIbOWmnkTTosOL8N12PJClL/s+z1tilzxNQmEA0UIbHuzBJKJbNK6SRd
         q/aIEYtwsosQ84y+imvFCQeklN8uhbnd5bKRAMnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.4 13/19] media: gp8psk: initialize stats at power control logic
Date:   Thu,  7 Jan 2021 15:16:38 +0100
Message-Id: <20210107140828.204165377@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.584658199@linuxfoundation.org>
References: <20210107140827.584658199@linuxfoundation.org>
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
@@ -163,7 +163,7 @@ out_rel_fw:
 
 static int gp8psk_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
-	u8 status, buf;
+	u8 status = 0, buf;
 	int gp_product_id = le16_to_cpu(d->udev->descriptor.idProduct);
 
 	if (onoff) {


