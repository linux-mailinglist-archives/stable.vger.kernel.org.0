Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192D2FA318
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbfKMCAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:00:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729618AbfKMCAU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4E1D22469;
        Wed, 13 Nov 2019 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610420;
        bh=XzZBn4TQb5p09UhPbtTd7mbOVh4J/ulq/n1RLpPhf3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFuQ2E2W6Iu2o9Y76i4125wc8evNSjmdqmSdyUCNA16tkn3s9rpfBDzvE3jD8/zBp
         09zAmDpVCMO5exU2JGV0xxGMOaCEnbGjehGwnS/XJFc2wZBotXSST06ytJvFm9MycZ
         rDbZNk1nohVFT9ujIKS7y4Bk0ZKvQncIpNED1z98=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 30/68] USB: serial: cypress_m8: fix interrupt-out transfer length
Date:   Tue, 12 Nov 2019 20:58:54 -0500
Message-Id: <20191113015932.12655-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 56445eef55cb5904096fed7a73cf87b755dfffc7 ]

Fix interrupt-out transfer length which was being set to the
transfer-buffer length rather than the size of the outgoing packet.

Note that no slab data was leaked as the whole transfer buffer is always
cleared before each transfer.

Fixes: 9aa8dae7b1fa ("cypress_m8: use usb_fill_int_urb where appropriate")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/cypress_m8.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index bbeeb2bd55a83..2c915be1db4ce 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -773,7 +773,7 @@ static void cypress_send(struct usb_serial_port *port)
 
 	usb_fill_int_urb(port->interrupt_out_urb, port->serial->dev,
 		usb_sndintpipe(port->serial->dev, port->interrupt_out_endpointAddress),
-		port->interrupt_out_buffer, port->interrupt_out_size,
+		port->interrupt_out_buffer, actual_size,
 		cypress_write_int_callback, port, priv->write_urb_interval);
 	result = usb_submit_urb(port->interrupt_out_urb, GFP_ATOMIC);
 	if (result) {
-- 
2.20.1

