Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4F63AACA
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbfFIQpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729906AbfFIQpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:45:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD302081C;
        Sun,  9 Jun 2019 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098731;
        bh=zscYZ7OpHrYkSXLWm/g6hkpoajMFBmOE1MoQzGHx6WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+/affbIGcdbQRQj4DD71ojex5R9bQ+WFlPMn/dt46nr9hqMz+bmrw58/6FEhPlB6
         N2LRiV7WFhkSEhfF2UIysUix8jwMTFR50Qtu3imPlkz04E3qA/sAuW2cIHBiVN3lSh
         7hn64PLk41QQtR8Xj8K3o26BGtsAnxvVYNKyJMDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 08/70] net: sfp: read eeprom in maximum 16 byte increments
Date:   Sun,  9 Jun 2019 18:41:19 +0200
Message-Id: <20190609164127.948003960@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 28e74a7cfd6403f0d1c0f8b10b45d6fae37b227e ]

Some SFP modules do not like reads longer than 16 bytes, so read the
EEPROM in chunks of 16 bytes at a time.  This behaviour is not specified
in the SFP MSAs, which specifies:

 "The serial interface uses the 2-wire serial CMOS E2PROM protocol
  defined for the ATMEL AT24C01A/02/04 family of components."

and

 "As long as the SFP+ receives an acknowledge, it shall serially clock
  out sequential data words. The sequence is terminated when the host
  responds with a NACK and a STOP instead of an acknowledge."

We must avoid breaking a read across a 16-bit quantity in the diagnostic
page, thankfully all 16-bit quantities in that page are naturally
aligned.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -281,6 +281,7 @@ static int sfp_i2c_read(struct sfp *sfp,
 {
 	struct i2c_msg msgs[2];
 	u8 bus_addr = a2 ? 0x51 : 0x50;
+	size_t this_len;
 	int ret;
 
 	msgs[0].addr = bus_addr;
@@ -292,11 +293,26 @@ static int sfp_i2c_read(struct sfp *sfp,
 	msgs[1].len = len;
 	msgs[1].buf = buf;
 
-	ret = i2c_transfer(sfp->i2c, msgs, ARRAY_SIZE(msgs));
-	if (ret < 0)
-		return ret;
+	while (len) {
+		this_len = len;
+		if (this_len > 16)
+			this_len = 16;
 
-	return ret == ARRAY_SIZE(msgs) ? len : 0;
+		msgs[1].len = this_len;
+
+		ret = i2c_transfer(sfp->i2c, msgs, ARRAY_SIZE(msgs));
+		if (ret < 0)
+			return ret;
+
+		if (ret != ARRAY_SIZE(msgs))
+			break;
+
+		msgs[1].buf += this_len;
+		dev_addr += this_len;
+		len -= this_len;
+	}
+
+	return msgs[1].buf - (u8 *)buf;
 }
 
 static int sfp_i2c_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,


