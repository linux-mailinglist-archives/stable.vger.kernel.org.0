Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD643A9DE
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733205AbfFIQ5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733198AbfFIQ5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:57:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9630204EC;
        Sun,  9 Jun 2019 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099453;
        bh=UiuYeVOdzbq/S50Dj8jcg/2b3A6n1zaxu9b9gA2SFEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlKShTU42WQyyfT/4zfp34OhHLjhzIRu1UjGDJa/5I77pv/KDcq/59pQfdHQf+tE1
         GXLWe3UdtypIx5MthMWF4iCnAr/76ZtpDZWWW3sHr062J8f5vh5mpp5AFXnNAtWh+t
         OLJMUt87Z3SIXuFiB10qAGp+T53LTxb5Um7hcan8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Curtis Malainey <cujomalainey@chromium.org>,
        Ben Zhang <benzh@chromium.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 011/241] ASoC: RT5677-SPI: Disable 16Bit SPI Transfers
Date:   Sun,  9 Jun 2019 18:39:13 +0200
Message-Id: <20190609164148.112395434@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Curtis Malainey <cujomalainey@chromium.org>

commit a46eb523220e242affb9a6bc9bb8efc05f4f7459 upstream.

The current algorithm allows 3 types of transfers, 16bit, 32bit and
burst. According to Realtek, 16bit transfers have a special restriction
in that it is restricted to the memory region of
0x18020000 ~ 0x18021000. This region is the memory location of the I2C
registers. The current algorithm does not uphold this restriction and
therefore fails to complete writes.

Since this has been broken for some time it likely no one is using it.
Better to simply disable the 16 bit writes. This will allow users to
properly load firmware over SPI without data corruption.

Signed-off-by: Curtis Malainey <cujomalainey@chromium.org>
Reviewed-by: Ben Zhang <benzh@chromium.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/rt5677-spi.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/sound/soc/codecs/rt5677-spi.c
+++ b/sound/soc/codecs/rt5677-spi.c
@@ -60,13 +60,15 @@ static DEFINE_MUTEX(spi_mutex);
  * RT5677_SPI_READ/WRITE_32:	Transfer 4 bytes
  * RT5677_SPI_READ/WRITE_BURST:	Transfer any multiples of 8 bytes
  *
- * For example, reading 260 bytes at 0x60030002 uses the following commands:
- * 0x60030002 RT5677_SPI_READ_16	2 bytes
+ * Note:
+ * 16 Bit writes and reads are restricted to the address range
+ * 0x18020000 ~ 0x18021000
+ *
+ * For example, reading 256 bytes at 0x60030004 uses the following commands:
  * 0x60030004 RT5677_SPI_READ_32	4 bytes
  * 0x60030008 RT5677_SPI_READ_BURST	240 bytes
  * 0x600300F8 RT5677_SPI_READ_BURST	8 bytes
  * 0x60030100 RT5677_SPI_READ_32	4 bytes
- * 0x60030104 RT5677_SPI_READ_16	2 bytes
  *
  * Input:
  * @read: true for read commands; false for write commands
@@ -81,15 +83,13 @@ static u8 rt5677_spi_select_cmd(bool rea
 {
 	u8 cmd;
 
-	if (align == 2 || align == 6 || remain == 2) {
-		cmd = RT5677_SPI_READ_16;
-		*len = 2;
-	} else if (align == 4 || remain <= 6) {
+	if (align == 4 || remain <= 4) {
 		cmd = RT5677_SPI_READ_32;
 		*len = 4;
 	} else {
 		cmd = RT5677_SPI_READ_BURST;
-		*len = min_t(u32, remain & ~7, RT5677_SPI_BURST_LEN);
+		*len = (((remain - 1) >> 3) + 1) << 3;
+		*len = min_t(u32, *len, RT5677_SPI_BURST_LEN);
 	}
 	return read ? cmd : cmd + 1;
 }
@@ -110,7 +110,7 @@ static void rt5677_spi_reverse(u8 *dst,
 	}
 }
 
-/* Read DSP address space using SPI. addr and len have to be 2-byte aligned. */
+/* Read DSP address space using SPI. addr and len have to be 4-byte aligned. */
 int rt5677_spi_read(u32 addr, void *rxbuf, size_t len)
 {
 	u32 offset;
@@ -126,7 +126,7 @@ int rt5677_spi_read(u32 addr, void *rxbu
 	if (!g_spi)
 		return -ENODEV;
 
-	if ((addr & 1) || (len & 1)) {
+	if ((addr & 3) || (len & 3)) {
 		dev_err(&g_spi->dev, "Bad read align 0x%x(%zu)\n", addr, len);
 		return -EACCES;
 	}
@@ -161,13 +161,13 @@ int rt5677_spi_read(u32 addr, void *rxbu
 }
 EXPORT_SYMBOL_GPL(rt5677_spi_read);
 
-/* Write DSP address space using SPI. addr has to be 2-byte aligned.
- * If len is not 2-byte aligned, an extra byte of zero is written at the end
+/* Write DSP address space using SPI. addr has to be 4-byte aligned.
+ * If len is not 4-byte aligned, then extra zeros are written at the end
  * as padding.
  */
 int rt5677_spi_write(u32 addr, const void *txbuf, size_t len)
 {
-	u32 offset, len_with_pad = len;
+	u32 offset;
 	int status = 0;
 	struct spi_transfer t;
 	struct spi_message m;
@@ -180,22 +180,19 @@ int rt5677_spi_write(u32 addr, const voi
 	if (!g_spi)
 		return -ENODEV;
 
-	if (addr & 1) {
+	if (addr & 3) {
 		dev_err(&g_spi->dev, "Bad write align 0x%x(%zu)\n", addr, len);
 		return -EACCES;
 	}
 
-	if (len & 1)
-		len_with_pad = len + 1;
-
 	memset(&t, 0, sizeof(t));
 	t.tx_buf = buf;
 	t.speed_hz = RT5677_SPI_FREQ;
 	spi_message_init_with_transfers(&m, &t, 1);
 
-	for (offset = 0; offset < len_with_pad;) {
+	for (offset = 0; offset < len;) {
 		spi_cmd = rt5677_spi_select_cmd(false, (addr + offset) & 7,
-				len_with_pad - offset, &t.len);
+				len - offset, &t.len);
 
 		/* Construct SPI message header */
 		buf[0] = spi_cmd;


