Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC642F214
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfE3DPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730347AbfE3DPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:33 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 353EC2458A;
        Thu, 30 May 2019 03:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186132;
        bh=oVmDshnLleo9pqCbEgHuG/rktvjZkZDdq6MhgGZqmZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHebKj1KtyyUFIyCAPjFuSNJtqpxKDXI0aSvBhij+FYKXI1+Frr79R3MCsgOHI/No
         6A0zYuQoHSc/8hc0tFk6F/oPpG6E+iF7ENihbvNYW4PzLvIc3M/9WKMJaLxWD9QEJ5
         vEbqy0G4SOXMj8kMtNN1IXlAk5/hE6nuI0symCw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 295/346] tinydrm/mipi-dbi: Use dma-safe buffers for all SPI transfers
Date:   Wed, 29 May 2019 20:06:08 -0700
Message-Id: <20190530030555.803849406@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a89bfc5d9a0732d84b4de311e27133daa0586316 ]

Buffers passed to spi_sync() must be dma-safe even for tiny buffers since
some SPI controllers use DMA for all transfers.

Example splat with CONFIG_DMA_API_DEBUG enabled:

[   23.750467] DMA-API: dw_dmac_pci 0000:00:15.0: device driver maps memory from stack [probable addr=000000001e49185d]
[   23.750529] WARNING: CPU: 1 PID: 1296 at kernel/dma/debug.c:1161 check_for_stack+0xb7/0x190
[   23.750533] Modules linked in: mmc_block(+) spi_pxa2xx_platform(+) pwm_lpss_pci pwm_lpss spi_pxa2xx_pci sdhci_pci cqhci intel_mrfld_pwrbtn extcon_intel_mrfld sdhci intel_mrfld_adc led_class mmc_core ili9341 mipi_dbi tinydrm backlight ti_ads7950 industrialio_triggered_buffer kfifo_buf intel_soc_pmic_mrfld hci_uart btbcm
[   23.750599] CPU: 1 PID: 1296 Comm: modprobe Not tainted 5.0.0-rc7+ #236
[   23.750605] Hardware name: Intel Corporation Merrifield/BODEGA BAY, BIOS 542 2015.01.21:18.19.48
[   23.750620] RIP: 0010:check_for_stack+0xb7/0x190
[   23.750630] Code: 8b 6d 50 4d 85 ed 75 04 4c 8b 6d 10 48 89 ef e8 2f 8b 44 00 48 89 c6 4a 8d 0c 23 4c 89 ea 48 c7 c7 88 d0 82 b4 e8 40 7c f9 ff <0f> 0b 8b 05 79 00 4b 01 85 c0 74 07 5b 5d 41 5c 41 5d c3 8b 05 54
[   23.750637] RSP: 0000:ffff97bbc0292fa0 EFLAGS: 00010286
[   23.750646] RAX: 0000000000000000 RBX: ffff97bbc0290000 RCX: 0000000000000006
[   23.750652] RDX: 0000000000000007 RSI: 0000000000000002 RDI: ffff94b33e115450
[   23.750658] RBP: ffff94b33c8578b0 R08: 0000000000000002 R09: 00000000000201c0
[   23.750664] R10: 00000006ecb0ccc6 R11: 0000000000034f38 R12: 000000000000316c
[   23.750670] R13: ffff94b33c84b250 R14: ffff94b33dedd5a0 R15: 0000000000000001
[   23.750679] FS:  0000000000000000(0000) GS:ffff94b33e100000(0063) knlGS:00000000f7faf690
[   23.750686] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[   23.750691] CR2: 00000000f7f54faf CR3: 000000000722c000 CR4: 00000000001006e0
[   23.750696] Call Trace:
[   23.750713]  debug_dma_map_sg+0x100/0x340
[   23.750727]  ? dma_direct_map_sg+0x3b/0xb0
[   23.750739]  spi_map_buf+0x25a/0x300
[   23.750751]  __spi_pump_messages+0x2a4/0x680
[   23.750762]  __spi_sync+0x1dd/0x1f0
[   23.750773]  spi_sync+0x26/0x40
[   23.750790]  mipi_dbi_typec3_command_read+0x14d/0x240 [mipi_dbi]
[   23.750802]  ? spi_finalize_current_transfer+0x10/0x10
[   23.750821]  mipi_dbi_typec3_command+0x1bc/0x1d0 [mipi_dbi]

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190222124329.23046-1-noralf@tronnes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tinydrm/ili9225.c  |  6 ++--
 drivers/gpu/drm/tinydrm/mipi-dbi.c | 58 +++++++++++++++++++++---------
 include/drm/tinydrm/mipi-dbi.h     |  5 +--
 3 files changed, 48 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/tinydrm/ili9225.c b/drivers/gpu/drm/tinydrm/ili9225.c
index 78f7c2d1b4494..5d85894607c73 100644
--- a/drivers/gpu/drm/tinydrm/ili9225.c
+++ b/drivers/gpu/drm/tinydrm/ili9225.c
@@ -279,7 +279,7 @@ static void ili9225_pipe_disable(struct drm_simple_display_pipe *pipe)
 	mipi->enabled = false;
 }
 
-static int ili9225_dbi_command(struct mipi_dbi *mipi, u8 cmd, u8 *par,
+static int ili9225_dbi_command(struct mipi_dbi *mipi, u8 *cmd, u8 *par,
 			       size_t num)
 {
 	struct spi_device *spi = mipi->spi;
@@ -289,11 +289,11 @@ static int ili9225_dbi_command(struct mipi_dbi *mipi, u8 cmd, u8 *par,
 
 	gpiod_set_value_cansleep(mipi->dc, 0);
 	speed_hz = mipi_dbi_spi_cmd_max_speed(spi, 1);
-	ret = tinydrm_spi_transfer(spi, speed_hz, NULL, 8, &cmd, 1);
+	ret = tinydrm_spi_transfer(spi, speed_hz, NULL, 8, cmd, 1);
 	if (ret || !num)
 		return ret;
 
-	if (cmd == ILI9225_WRITE_DATA_TO_GRAM && !mipi->swap_bytes)
+	if (*cmd == ILI9225_WRITE_DATA_TO_GRAM && !mipi->swap_bytes)
 		bpw = 16;
 
 	gpiod_set_value_cansleep(mipi->dc, 1);
diff --git a/drivers/gpu/drm/tinydrm/mipi-dbi.c b/drivers/gpu/drm/tinydrm/mipi-dbi.c
index 3a05e56f9b0d8..dd091c7eecf94 100644
--- a/drivers/gpu/drm/tinydrm/mipi-dbi.c
+++ b/drivers/gpu/drm/tinydrm/mipi-dbi.c
@@ -148,16 +148,42 @@ EXPORT_SYMBOL(mipi_dbi_command_read);
  */
 int mipi_dbi_command_buf(struct mipi_dbi *mipi, u8 cmd, u8 *data, size_t len)
 {
+	u8 *cmdbuf;
 	int ret;
 
+	/* SPI requires dma-safe buffers */
+	cmdbuf = kmemdup(&cmd, 1, GFP_KERNEL);
+	if (!cmdbuf)
+		return -ENOMEM;
+
 	mutex_lock(&mipi->cmdlock);
-	ret = mipi->command(mipi, cmd, data, len);
+	ret = mipi->command(mipi, cmdbuf, data, len);
 	mutex_unlock(&mipi->cmdlock);
 
+	kfree(cmdbuf);
+
 	return ret;
 }
 EXPORT_SYMBOL(mipi_dbi_command_buf);
 
+/* This should only be used by mipi_dbi_command() */
+int mipi_dbi_command_stackbuf(struct mipi_dbi *mipi, u8 cmd, u8 *data, size_t len)
+{
+	u8 *buf;
+	int ret;
+
+	buf = kmemdup(data, len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = mipi_dbi_command_buf(mipi, cmd, buf, len);
+
+	kfree(buf);
+
+	return ret;
+}
+EXPORT_SYMBOL(mipi_dbi_command_stackbuf);
+
 /**
  * mipi_dbi_buf_copy - Copy a framebuffer, transforming it if necessary
  * @dst: The destination buffer
@@ -745,18 +771,18 @@ static int mipi_dbi_spi1_transfer(struct mipi_dbi *mipi, int dc,
 	return 0;
 }
 
-static int mipi_dbi_typec1_command(struct mipi_dbi *mipi, u8 cmd,
+static int mipi_dbi_typec1_command(struct mipi_dbi *mipi, u8 *cmd,
 				   u8 *parameters, size_t num)
 {
-	unsigned int bpw = (cmd == MIPI_DCS_WRITE_MEMORY_START) ? 16 : 8;
+	unsigned int bpw = (*cmd == MIPI_DCS_WRITE_MEMORY_START) ? 16 : 8;
 	int ret;
 
-	if (mipi_dbi_command_is_read(mipi, cmd))
+	if (mipi_dbi_command_is_read(mipi, *cmd))
 		return -ENOTSUPP;
 
-	MIPI_DBI_DEBUG_COMMAND(cmd, parameters, num);
+	MIPI_DBI_DEBUG_COMMAND(*cmd, parameters, num);
 
-	ret = mipi_dbi_spi1_transfer(mipi, 0, &cmd, 1, 8);
+	ret = mipi_dbi_spi1_transfer(mipi, 0, cmd, 1, 8);
 	if (ret || !num)
 		return ret;
 
@@ -765,7 +791,7 @@ static int mipi_dbi_typec1_command(struct mipi_dbi *mipi, u8 cmd,
 
 /* MIPI DBI Type C Option 3 */
 
-static int mipi_dbi_typec3_command_read(struct mipi_dbi *mipi, u8 cmd,
+static int mipi_dbi_typec3_command_read(struct mipi_dbi *mipi, u8 *cmd,
 					u8 *data, size_t len)
 {
 	struct spi_device *spi = mipi->spi;
@@ -774,7 +800,7 @@ static int mipi_dbi_typec3_command_read(struct mipi_dbi *mipi, u8 cmd,
 	struct spi_transfer tr[2] = {
 		{
 			.speed_hz = speed_hz,
-			.tx_buf = &cmd,
+			.tx_buf = cmd,
 			.len = 1,
 		}, {
 			.speed_hz = speed_hz,
@@ -792,8 +818,8 @@ static int mipi_dbi_typec3_command_read(struct mipi_dbi *mipi, u8 cmd,
 	 * Support non-standard 24-bit and 32-bit Nokia read commands which
 	 * start with a dummy clock, so we need to read an extra byte.
 	 */
-	if (cmd == MIPI_DCS_GET_DISPLAY_ID ||
-	    cmd == MIPI_DCS_GET_DISPLAY_STATUS) {
+	if (*cmd == MIPI_DCS_GET_DISPLAY_ID ||
+	    *cmd == MIPI_DCS_GET_DISPLAY_STATUS) {
 		if (!(len == 3 || len == 4))
 			return -EINVAL;
 
@@ -823,7 +849,7 @@ static int mipi_dbi_typec3_command_read(struct mipi_dbi *mipi, u8 cmd,
 			data[i] = (buf[i] << 1) | !!(buf[i + 1] & BIT(7));
 	}
 
-	MIPI_DBI_DEBUG_COMMAND(cmd, data, len);
+	MIPI_DBI_DEBUG_COMMAND(*cmd, data, len);
 
 err_free:
 	kfree(buf);
@@ -831,7 +857,7 @@ static int mipi_dbi_typec3_command_read(struct mipi_dbi *mipi, u8 cmd,
 	return ret;
 }
 
-static int mipi_dbi_typec3_command(struct mipi_dbi *mipi, u8 cmd,
+static int mipi_dbi_typec3_command(struct mipi_dbi *mipi, u8 *cmd,
 				   u8 *par, size_t num)
 {
 	struct spi_device *spi = mipi->spi;
@@ -839,18 +865,18 @@ static int mipi_dbi_typec3_command(struct mipi_dbi *mipi, u8 cmd,
 	u32 speed_hz;
 	int ret;
 
-	if (mipi_dbi_command_is_read(mipi, cmd))
+	if (mipi_dbi_command_is_read(mipi, *cmd))
 		return mipi_dbi_typec3_command_read(mipi, cmd, par, num);
 
-	MIPI_DBI_DEBUG_COMMAND(cmd, par, num);
+	MIPI_DBI_DEBUG_COMMAND(*cmd, par, num);
 
 	gpiod_set_value_cansleep(mipi->dc, 0);
 	speed_hz = mipi_dbi_spi_cmd_max_speed(spi, 1);
-	ret = tinydrm_spi_transfer(spi, speed_hz, NULL, 8, &cmd, 1);
+	ret = tinydrm_spi_transfer(spi, speed_hz, NULL, 8, cmd, 1);
 	if (ret || !num)
 		return ret;
 
-	if (cmd == MIPI_DCS_WRITE_MEMORY_START && !mipi->swap_bytes)
+	if (*cmd == MIPI_DCS_WRITE_MEMORY_START && !mipi->swap_bytes)
 		bpw = 16;
 
 	gpiod_set_value_cansleep(mipi->dc, 1);
diff --git a/include/drm/tinydrm/mipi-dbi.h b/include/drm/tinydrm/mipi-dbi.h
index b8ba588619867..bcc98bd447f7a 100644
--- a/include/drm/tinydrm/mipi-dbi.h
+++ b/include/drm/tinydrm/mipi-dbi.h
@@ -42,7 +42,7 @@ struct mipi_dbi {
 	struct spi_device *spi;
 	bool enabled;
 	struct mutex cmdlock;
-	int (*command)(struct mipi_dbi *mipi, u8 cmd, u8 *param, size_t num);
+	int (*command)(struct mipi_dbi *mipi, u8 *cmd, u8 *param, size_t num);
 	const u8 *read_commands;
 	struct gpio_desc *dc;
 	u16 *tx_buf;
@@ -79,6 +79,7 @@ u32 mipi_dbi_spi_cmd_max_speed(struct spi_device *spi, size_t len);
 
 int mipi_dbi_command_read(struct mipi_dbi *mipi, u8 cmd, u8 *val);
 int mipi_dbi_command_buf(struct mipi_dbi *mipi, u8 cmd, u8 *data, size_t len);
+int mipi_dbi_command_stackbuf(struct mipi_dbi *mipi, u8 cmd, u8 *data, size_t len);
 int mipi_dbi_buf_copy(void *dst, struct drm_framebuffer *fb,
 		      struct drm_clip_rect *clip, bool swap);
 /**
@@ -96,7 +97,7 @@ int mipi_dbi_buf_copy(void *dst, struct drm_framebuffer *fb,
 #define mipi_dbi_command(mipi, cmd, seq...) \
 ({ \
 	u8 d[] = { seq }; \
-	mipi_dbi_command_buf(mipi, cmd, d, ARRAY_SIZE(d)); \
+	mipi_dbi_command_stackbuf(mipi, cmd, d, ARRAY_SIZE(d)); \
 })
 
 #ifdef CONFIG_DEBUG_FS
-- 
2.20.1



