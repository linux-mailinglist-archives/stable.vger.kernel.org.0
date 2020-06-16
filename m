Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62171FB9D9
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbgFPPrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732286AbgFPPrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:47:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 907E721508;
        Tue, 16 Jun 2020 15:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322428;
        bh=lMiw6z8M6Tmg7XUhbTCh6hOdFxHhL1CBBaI7l7SKsZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3TxlSq0eXqNt3MyM9DQiIxpZyJ9Z5F0u1NWt27o7CG9X9kDAg0qvLxIRKbj3MnYX
         KwtwGFUE1GOtNMH8eU1rmM3elE0nR+Eke6/1/cmAjiWD4Zd+SJSm74gTFeZ8C7jASP
         QYcUvt5GPvEDMCSpFoJnQr6PgmLyCcQb4MxGfPBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Chen <justinpopo6@gmail.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.7 087/163] spi: bcm-qspi: when tx/rx buffer is NULL set to 0
Date:   Tue, 16 Jun 2020 17:34:21 +0200
Message-Id: <20200616153111.014128001@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

commit 4df3bea7f9d2ddd9ac2c29ba945c7c4db2def29c upstream.

Currently we set the tx/rx buffer to 0xff when NULL. This causes
problems with some spi slaves where 0xff is a valid command. Looking
at other drivers, the tx/rx buffer is usually set to 0x00 when NULL.
Following this convention solves the issue.

Fixes: fa236a7ef240 ("spi: bcm-qspi: Add Broadcom MSPI driver")
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200420190853.45614-6-kdasu.kdev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-bcm-qspi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -670,7 +670,7 @@ static void read_from_hw(struct bcm_qspi
 			if (buf)
 				buf[tp.byte] = read_rxram_slot_u8(qspi, slot);
 			dev_dbg(&qspi->pdev->dev, "RD %02x\n",
-				buf ? buf[tp.byte] : 0xff);
+				buf ? buf[tp.byte] : 0x0);
 		} else {
 			u16 *buf = tp.trans->rx_buf;
 
@@ -678,7 +678,7 @@ static void read_from_hw(struct bcm_qspi
 				buf[tp.byte / 2] = read_rxram_slot_u16(qspi,
 								      slot);
 			dev_dbg(&qspi->pdev->dev, "RD %04x\n",
-				buf ? buf[tp.byte] : 0xffff);
+				buf ? buf[tp.byte / 2] : 0x0);
 		}
 
 		update_qspi_trans_byte_count(qspi, &tp,
@@ -733,13 +733,13 @@ static int write_to_hw(struct bcm_qspi *
 	while (!tstatus && slot < MSPI_NUM_CDRAM) {
 		if (tp.trans->bits_per_word <= 8) {
 			const u8 *buf = tp.trans->tx_buf;
-			u8 val = buf ? buf[tp.byte] : 0xff;
+			u8 val = buf ? buf[tp.byte] : 0x00;
 
 			write_txram_slot_u8(qspi, slot, val);
 			dev_dbg(&qspi->pdev->dev, "WR %02x\n", val);
 		} else {
 			const u16 *buf = tp.trans->tx_buf;
-			u16 val = buf ? buf[tp.byte / 2] : 0xffff;
+			u16 val = buf ? buf[tp.byte / 2] : 0x0000;
 
 			write_txram_slot_u16(qspi, slot, val);
 			dev_dbg(&qspi->pdev->dev, "WR %04x\n", val);


