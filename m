Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9E117812E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387896AbgCCSBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387879AbgCCSBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:01:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E9DD20870;
        Tue,  3 Mar 2020 18:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258460;
        bh=qd721I88vNXch3ZqPReQwf2cEtykqf23s69glri4oKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoaI3vGsA/MKYlHTE7x3ANS0CaZtiBAO0ojN17NwCFCqlzi6f8otFAL59Ib5NWrx0
         l0Y7eBzl/EcdUkMQFAM/AQt5KMn7vv2zCcRHBBIIZi2UoCAcWrtKji18vY2SR3A3tG
         50bhVTvJDE7MGL5fy+YMV6R5IMf8DEXEy1EQOKsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 4.19 56/87] i2c: jz4780: silence log flood on txabrt
Date:   Tue,  3 Mar 2020 18:43:47 +0100
Message-Id: <20200303174355.386521618@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa@the-dreams.de>

commit 9e661cedcc0a072d91a32cb88e0515ea26e35711 upstream.

The printout for txabrt is way too talkative and is highly annoying with
scanning programs like 'i2cdetect'. Reduce it to the minimum, the rest
can be gained by I2C core debugging and datasheet information. Also,
make it a debug printout, it won't help the regular user.

Fixes: ba92222ed63a ("i2c: jz4780: Add i2c bus controller driver for Ingenic JZ4780")
Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Tested-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-jz4780.c |   36 ++----------------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

--- a/drivers/i2c/busses/i2c-jz4780.c
+++ b/drivers/i2c/busses/i2c-jz4780.c
@@ -82,25 +82,6 @@
 #define JZ4780_I2C_STA_TFNF		BIT(1)
 #define JZ4780_I2C_STA_ACT		BIT(0)
 
-static const char * const jz4780_i2c_abrt_src[] = {
-	"ABRT_7B_ADDR_NOACK",
-	"ABRT_10ADDR1_NOACK",
-	"ABRT_10ADDR2_NOACK",
-	"ABRT_XDATA_NOACK",
-	"ABRT_GCALL_NOACK",
-	"ABRT_GCALL_READ",
-	"ABRT_HS_ACKD",
-	"SBYTE_ACKDET",
-	"ABRT_HS_NORSTRT",
-	"SBYTE_NORSTRT",
-	"ABRT_10B_RD_NORSTRT",
-	"ABRT_MASTER_DIS",
-	"ARB_LOST",
-	"SLVFLUSH_TXFIFO",
-	"SLV_ARBLOST",
-	"SLVRD_INTX",
-};
-
 #define JZ4780_I2C_INTST_IGC		BIT(11)
 #define JZ4780_I2C_INTST_ISTT		BIT(10)
 #define JZ4780_I2C_INTST_ISTP		BIT(9)
@@ -538,21 +519,8 @@ done:
 
 static void jz4780_i2c_txabrt(struct jz4780_i2c *i2c, int src)
 {
-	int i;
-
-	dev_err(&i2c->adap.dev, "txabrt: 0x%08x\n", src);
-	dev_err(&i2c->adap.dev, "device addr=%x\n",
-		jz4780_i2c_readw(i2c, JZ4780_I2C_TAR));
-	dev_err(&i2c->adap.dev, "send cmd count:%d  %d\n",
-		i2c->cmd, i2c->cmd_buf[i2c->cmd]);
-	dev_err(&i2c->adap.dev, "receive data count:%d  %d\n",
-		i2c->cmd, i2c->data_buf[i2c->cmd]);
-
-	for (i = 0; i < 16; i++) {
-		if (src & BIT(i))
-			dev_dbg(&i2c->adap.dev, "I2C TXABRT[%d]=%s\n",
-				i, jz4780_i2c_abrt_src[i]);
-	}
+	dev_dbg(&i2c->adap.dev, "txabrt: 0x%08x, cmd: %d, send: %d, recv: %d\n",
+		src, i2c->cmd, i2c->cmd_buf[i2c->cmd], i2c->data_buf[i2c->cmd]);
 }
 
 static inline int jz4780_i2c_xfer_read(struct jz4780_i2c *i2c,


