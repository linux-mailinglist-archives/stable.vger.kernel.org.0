Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9BB714EB7
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfEFPEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:04:02 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:53928 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbfEFPEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 11:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=nCTiJI+kMTH4I78pMnMBinNZSAPdzKRaNQJc8hcng/k=; b=ZT3FMuX7ALkj
        TMNiBwg7jzUehWOSdwYAm7UvkQHkgov9rtyrymQixnkxhkdAU4H4LKzJIZexYIgURcFsMe28kEGdQ
        9vpRODa6A+YQ/YOMNzmIN3vIXsJc1ml0IhY5C7zQmABzs5alUgDw3kbj2mFi9coVPQG/Pg79uSWjU
        hw+mw=;
Received: from [2001:268:c0e6:658d:8f3d:d90b:c4e4:2fdf] (helo=finisterre.ee.mobilebroadband)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hNf9i-0001ub-Pw; Mon, 06 May 2019 15:03:51 +0000
Received: by finisterre.ee.mobilebroadband (Postfix, from userid 1000)
        id 0DC20440039; Mon,  6 May 2019 16:03:46 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Curtis Malainey <cujomalainey@chromium.org>
Cc:     alsa-devel@alsa-project.org, Bard Liao <bardliao@realtek.com>,
        Ben Zhang <benzh@chromium.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Oder Chiou <oder_chiou@realtek.com>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.com>
Subject: Applied "ASoC: RT5677-SPI: Disable 16Bit SPI Transfers" to the asoc tree
In-Reply-To: <20190503193213.227189-1-cujomalainey@chromium.org>
X-Patchwork-Hint: ignore
Message-Id: <20190506150346.0DC20440039@finisterre.ee.mobilebroadband>
Date:   Mon,  6 May 2019 16:03:45 +0100 (BST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: RT5677-SPI: Disable 16Bit SPI Transfers

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-5.2

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From a46eb523220e242affb9a6bc9bb8efc05f4f7459 Mon Sep 17 00:00:00 2001
From: Curtis Malainey <cujomalainey@chromium.org>
Date: Fri, 3 May 2019 12:32:14 -0700
Subject: [PATCH] ASoC: RT5677-SPI: Disable 16Bit SPI Transfers

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
---
 sound/soc/codecs/rt5677-spi.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/sound/soc/codecs/rt5677-spi.c b/sound/soc/codecs/rt5677-spi.c
index 167a02773a0b..84b6bd8b50e1 100644
--- a/sound/soc/codecs/rt5677-spi.c
+++ b/sound/soc/codecs/rt5677-spi.c
@@ -58,13 +58,15 @@ static DEFINE_MUTEX(spi_mutex);
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
@@ -79,15 +81,13 @@ static u8 rt5677_spi_select_cmd(bool read, u32 align, u32 remain, u32 *len)
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
@@ -108,7 +108,7 @@ static void rt5677_spi_reverse(u8 *dst, u32 dstlen, const u8 *src, u32 srclen)
 	}
 }
 
-/* Read DSP address space using SPI. addr and len have to be 2-byte aligned. */
+/* Read DSP address space using SPI. addr and len have to be 4-byte aligned. */
 int rt5677_spi_read(u32 addr, void *rxbuf, size_t len)
 {
 	u32 offset;
@@ -124,7 +124,7 @@ int rt5677_spi_read(u32 addr, void *rxbuf, size_t len)
 	if (!g_spi)
 		return -ENODEV;
 
-	if ((addr & 1) || (len & 1)) {
+	if ((addr & 3) || (len & 3)) {
 		dev_err(&g_spi->dev, "Bad read align 0x%x(%zu)\n", addr, len);
 		return -EACCES;
 	}
@@ -159,13 +159,13 @@ int rt5677_spi_read(u32 addr, void *rxbuf, size_t len)
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
@@ -178,22 +178,19 @@ int rt5677_spi_write(u32 addr, const void *txbuf, size_t len)
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
-- 
2.20.1

