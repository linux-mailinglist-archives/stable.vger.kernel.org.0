Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5471456AD
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbgAVN2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:28:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730876AbgAVN2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:28:31 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76AAA24125;
        Wed, 22 Jan 2020 13:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699710;
        bh=bRPI4NEzsYbWl9R1aXwUkxxw/RBMVoVzvkO0RHLavmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IX6AWrybZdey/g6O+uGUAZg3F1rCJEhmuQzl2h+EOnYJNh9OSw999toSA9mkHx96l
         4EK9B4fprgMF02QMt9qucBvTB05e0pKNnsFAr05wyU2LVm3ytXjH2mjaivFbR3CUuk
         KtkkTKai/4dvlIzE/R3GEk1BT9p4sM3jKKBbBPpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Angelo Dureghello <angelo.dureghello@timesys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 193/222] mtd: devices: fix mchp23k256 read and write
Date:   Wed, 22 Jan 2020 10:29:39 +0100
Message-Id: <20200122092847.495536388@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angelo Dureghello <angelo.dureghello@timesys.com>

commit 14f89e088155314d311e4d4dd9f2b4ccaeef92b2 upstream.

Due to the use of sizeof(), command size set for the spi transfer
was wrong. Driver was sending and receiving always 1 byte less
and especially on write, it was hanging.

echo -n -e "\\x1\\x2\\x3\\x4" > /dev/mtd1

And read part too now works as expected.

hexdump -C -n16 /dev/mtd1
00000000  01 02 03 04 ab f3 ad c2  ab e3 f4 36 dd 38 04 15
00000010

Fixes: 4379075a870b ("mtd: mchp23k256: Add support for mchp23lcv1024")
Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/devices/mchp23k256.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/mtd/devices/mchp23k256.c
+++ b/drivers/mtd/devices/mchp23k256.c
@@ -64,15 +64,17 @@ static int mchp23k256_write(struct mtd_i
 	struct spi_transfer transfer[2] = {};
 	struct spi_message message;
 	unsigned char command[MAX_CMD_SIZE];
-	int ret;
+	int ret, cmd_len;
 
 	spi_message_init(&message);
 
+	cmd_len = mchp23k256_cmdsz(flash);
+
 	command[0] = MCHP23K256_CMD_WRITE;
 	mchp23k256_addr2cmd(flash, to, command);
 
 	transfer[0].tx_buf = command;
-	transfer[0].len = mchp23k256_cmdsz(flash);
+	transfer[0].len = cmd_len;
 	spi_message_add_tail(&transfer[0], &message);
 
 	transfer[1].tx_buf = buf;
@@ -88,8 +90,8 @@ static int mchp23k256_write(struct mtd_i
 	if (ret)
 		return ret;
 
-	if (retlen && message.actual_length > sizeof(command))
-		*retlen += message.actual_length - sizeof(command);
+	if (retlen && message.actual_length > cmd_len)
+		*retlen += message.actual_length - cmd_len;
 
 	return 0;
 }
@@ -101,16 +103,18 @@ static int mchp23k256_read(struct mtd_in
 	struct spi_transfer transfer[2] = {};
 	struct spi_message message;
 	unsigned char command[MAX_CMD_SIZE];
-	int ret;
+	int ret, cmd_len;
 
 	spi_message_init(&message);
 
+	cmd_len = mchp23k256_cmdsz(flash);
+
 	memset(&transfer, 0, sizeof(transfer));
 	command[0] = MCHP23K256_CMD_READ;
 	mchp23k256_addr2cmd(flash, from, command);
 
 	transfer[0].tx_buf = command;
-	transfer[0].len = mchp23k256_cmdsz(flash);
+	transfer[0].len = cmd_len;
 	spi_message_add_tail(&transfer[0], &message);
 
 	transfer[1].rx_buf = buf;
@@ -126,8 +130,8 @@ static int mchp23k256_read(struct mtd_in
 	if (ret)
 		return ret;
 
-	if (retlen && message.actual_length > sizeof(command))
-		*retlen += message.actual_length - sizeof(command);
+	if (retlen && message.actual_length > cmd_len)
+		*retlen += message.actual_length - cmd_len;
 
 	return 0;
 }


