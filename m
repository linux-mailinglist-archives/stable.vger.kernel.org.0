Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2B740B2D9
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 17:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbhINPTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 11:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbhINPTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 11:19:31 -0400
Received: from gofer.mess.org (gofer.mess.org [IPv6:2a02:8011:d000:212::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6857BC0613C1;
        Tue, 14 Sep 2021 08:18:12 -0700 (PDT)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 90BDEC65BA; Tue, 14 Sep 2021 16:18:09 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1631632689; bh=WksOAXceADQojSv7D9XcocopFCjz8Htoqezgrn7HtWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5H+5QxlrjRGQv24cWyMdIBqxOCO7NaO8FYzva+CkR/axoNrE5Lr4uZWg8I3n8lpY
         oC54a1MlTaKcQOI5uPX5Fu4GnrTV/ZOxSu0UbnticgsaNCWJDSUU12HT5lErQn5JaW
         lkmTgwRV7bhqGFK7qqvd73/dOCSdrhfh50wQD+Xy5HCF2OUt6OVlFio+kl42YSXeFl
         LL+QPnkiEvOysBeaNg9kLdSrOLLJakR4k34ZT2sr1Xu5uhoS+d98nOmNptgJP1+QnO
         BqH0EhwgQ/oSU5PxLDV7gLe2BdqyfrAEYZCBnMjLtQAsxvmX1HgUCm17AZY8B8kGJU
         GA12pd5h85Plw==
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     Georgi Bakalski <georgi.bakalski@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 4/4] media: ir_toy: prevent device from hanging during transmit
Date:   Tue, 14 Sep 2021 16:18:09 +0100
Message-Id: <4ed68b6848f09f191e0709702c3d1d7838a3a717.1631632442.git.sean@mess.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <22eeae667aac9d5eaaae2f21904f238ebef0c05b.1631632442.git.sean@mess.org>
References: <22eeae667aac9d5eaaae2f21904f238ebef0c05b.1631632442.git.sean@mess.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the IR Toy is receiving IR while a transmit is done, it may end up
hanging. We can prevent this from happening by re-entering sample mode
just before issuing the transmit command.

Link: https://github.com/bengtmartensson/HarcHardware/discussions/25
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir_toy.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index d2d9346eb8f5..71aced52248f 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -26,6 +26,7 @@ static const u8 COMMAND_VERSION[] = { 'v' };
 // End transmit and repeat reset command so we exit sump mode
 static const u8 COMMAND_RESET[] = { 0xff, 0xff, 0, 0, 0, 0, 0 };
 static const u8 COMMAND_SMODE_ENTER[] = { 's' };
+static const u8 COMMAND_SMODE_EXIT[] = { 0 };
 static const u8 COMMAND_TXSTART[] = { 0x26, 0x24, 0x25, 0x03 };
 
 #define REPLY_XMITCOUNT 't'
@@ -317,12 +318,30 @@ static int irtoy_tx(struct rc_dev *rc, uint *txbuf, uint count)
 		buf[i] = cpu_to_be16(v);
 	}
 
-	buf[count] = cpu_to_be16(0xffff);
+	buf[count] = 0xffff;
 
 	irtoy->tx_buf = buf;
 	irtoy->tx_len = size;
 	irtoy->emitted = 0;
 
+	// There is an issue where if the unit is receiving IR while the
+	// first TXSTART command is sent, the device might end up hanging
+	// with its led on. It does not respond to any command when this
+	// happens. To work around this, re-enter sample mode.
+	err = irtoy_command(irtoy, COMMAND_SMODE_EXIT,
+			    sizeof(COMMAND_SMODE_EXIT), STATE_COMMAND_NO_RESP);
+	if (err) {
+		dev_err(irtoy->dev, "exit sample mode: %d\n", err);
+		return err;
+	}
+
+	err = irtoy_command(irtoy, COMMAND_SMODE_ENTER,
+			    sizeof(COMMAND_SMODE_ENTER), STATE_COMMAND);
+	if (err) {
+		dev_err(irtoy->dev, "enter sample mode: %d\n", err);
+		return err;
+	}
+
 	err = irtoy_command(irtoy, COMMAND_TXSTART, sizeof(COMMAND_TXSTART),
 			    STATE_TX);
 	kfree(buf);
-- 
2.31.1

