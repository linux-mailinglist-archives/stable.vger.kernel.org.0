Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454DB518360
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 13:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbiECLlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 07:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234537AbiECLlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 07:41:49 -0400
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E9734BBD;
        Tue,  3 May 2022 04:38:16 -0700 (PDT)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4KsydL0Bgmz9sSS;
        Tue,  3 May 2022 13:38:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zMKZwDGPS9yF; Tue,  3 May 2022 13:38:13 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4KsydK6QMWz9sSN;
        Tue,  3 May 2022 13:38:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id C779F8B77B;
        Tue,  3 May 2022 13:38:13 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Cpf1zNW_yYlA; Tue,  3 May 2022 13:38:13 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.20])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 836788B763;
        Tue,  3 May 2022 13:38:13 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 243Bc0Cp233681
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 3 May 2022 13:38:00 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 243Bbxdw233654;
        Tue, 3 May 2022 13:37:59 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, stable <stable@kernel.org>
Subject: [PATCH] [Rebased for 5.15] eeprom: at25: Use DMA safe buffers
Date:   Tue,  3 May 2022 13:37:47 +0200
Message-Id: <17730b921128e87ffd05957f39664cd257ff5416.1651577811.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1651577866; l=5865; s=20211009; h=from:subject:message-id; bh=pW8owyfWKdYaDYoFV2R3ky1kZlLDiDTXUaDgUsQJ9d4=; b=Rwkd65lKIzgnII9V1R6jUiCfJiijJp55BHCKZB9Ayd6tfJslQ8R7vr4TmX5bnh5IZrwguQzhvuZI 5Ah9mOaTD/f7LqpB/cW9K058wrKh5xuS/lmgf5eUVgUzRv91PdaT
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 5b47b751b760ee1c74a51660fd096aa148a362cd

Reading EEPROM fails with following warning:

[   16.357496] ------------[ cut here ]------------
[   16.357529] fsl_spi b01004c0.spi: rejecting DMA map of vmalloc memory
[   16.357698] WARNING: CPU: 0 PID: 371 at include/linux/dma-mapping.h:326 fsl_spi_cpm_bufs+0x2a0/0x2d8
[   16.357775] CPU: 0 PID: 371 Comm: od Not tainted 5.16.11-s3k-dev-01743-g19beecbfe9d6-dirty #109
[   16.357806] NIP:  c03fbc9c LR: c03fbc9c CTR: 00000000
[   16.357825] REGS: e68d9b20 TRAP: 0700   Not tainted  (5.16.11-s3k-dev-01743-g19beecbfe9d6-dirty)
[   16.357849] MSR:  00029032 <EE,ME,IR,DR,RI>  CR: 24002282  XER: 00000000
[   16.357931]
[   16.357931] GPR00: c03fbc9c e68d9be0 c26d06a0 00000039 00000001 c0d36364 c0e96428 00000027
[   16.357931] GPR08: 00000001 00000000 00000023 3fffc000 24002282 100d3dd6 100a2ffc 00000000
[   16.357931] GPR16: 100cd280 100b0000 00000000 aff54f7e 100d0000 100d0000 00000001 100cf328
[   16.357931] GPR24: 100cf328 00000000 00000003 e68d9e30 c156b410 e67ab4c0 e68d9d38 c24ab278
[   16.358253] NIP [c03fbc9c] fsl_spi_cpm_bufs+0x2a0/0x2d8
[   16.358292] LR [c03fbc9c] fsl_spi_cpm_bufs+0x2a0/0x2d8
[   16.358325] Call Trace:
[   16.358336] [e68d9be0] [c03fbc9c] fsl_spi_cpm_bufs+0x2a0/0x2d8 (unreliable)
[   16.358388] [e68d9c00] [c03fcb44] fsl_spi_bufs.isra.0+0x94/0x1a0
[   16.358436] [e68d9c20] [c03fd970] fsl_spi_do_one_msg+0x254/0x3dc
[   16.358483] [e68d9cb0] [c03f7e50] __spi_pump_messages+0x274/0x8a4
[   16.358529] [e68d9ce0] [c03f9d30] __spi_sync+0x344/0x378
[   16.358573] [e68d9d20] [c03fb52c] spi_sync+0x34/0x60
[   16.358616] [e68d9d30] [c03b4dec] at25_ee_read+0x138/0x1a8
[   16.358667] [e68d9e50] [c04a8fb8] bin_attr_nvmem_read+0x98/0x110
[   16.358725] [e68d9e60] [c0204b14] kernfs_fop_read_iter+0xc0/0x1fc
[   16.358774] [e68d9e80] [c0168660] vfs_read+0x284/0x410
[   16.358821] [e68d9f00] [c016925c] ksys_read+0x6c/0x11c
[   16.358863] [e68d9f30] [c00160e0] ret_from_syscall+0x0/0x28
...
[   16.359608] ---[ end trace a4ce3e34afef0cb5 ]---
[   16.359638] fsl_spi b01004c0.spi: unable to map tx dma

This is due to the AT25 driver using buffers on stack, which is not
possible with CONFIG_VMAP_STACK.

As mentionned in kernel Documentation (Documentation/spi/spi-summary.rst):

  - Follow standard kernel rules, and provide DMA-safe buffers in
    your messages.  That way controller drivers using DMA aren't forced
    to make extra copies unless the hardware requires it (e.g. working
    around hardware errata that force the use of bounce buffering).

Modify the driver to use a buffer located in the at25 device structure
which is allocated via kmalloc during probe.

Protect writes in this new buffer with the driver's mutex.

Fixes: b587b13a4f67 ("[PATCH] SPI eeprom driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/230a9486fc68ea0182df46255e42a51099403642.1648032613.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/at25.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 9193b812bc07..403243859dce 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -30,6 +30,8 @@
  */
 
 #define	FM25_SN_LEN	8		/* serial number length */
+#define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
+
 struct at25_data {
 	struct spi_device	*spi;
 	struct mutex		lock;
@@ -38,6 +40,7 @@ struct at25_data {
 	struct nvmem_config	nvmem_config;
 	struct nvmem_device	*nvmem;
 	u8 sernum[FM25_SN_LEN];
+	u8 command[EE_MAXADDRLEN + 1];
 };
 
 #define	AT25_WREN	0x06		/* latch the write enable */
@@ -60,8 +63,6 @@ struct at25_data {
 
 #define	FM25_ID_LEN	9		/* ID length */
 
-#define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
-
 /* Specs often allow 5 msec for a page write, sometimes 20 msec;
  * it's important to recover from write timeouts.
  */
@@ -76,7 +77,6 @@ static int at25_ee_read(void *priv, unsigned int offset,
 {
 	struct at25_data *at25 = priv;
 	char *buf = val;
-	u8			command[EE_MAXADDRLEN + 1];
 	u8			*cp;
 	ssize_t			status;
 	struct spi_transfer	t[2];
@@ -90,12 +90,15 @@ static int at25_ee_read(void *priv, unsigned int offset,
 	if (unlikely(!count))
 		return -EINVAL;
 
-	cp = command;
+	cp = at25->command;
 
 	instr = AT25_READ;
 	if (at25->chip.flags & EE_INSTR_BIT3_IS_ADDR)
 		if (offset >= (1U << (at25->addrlen * 8)))
 			instr |= AT25_INSTR_BIT3;
+
+	mutex_lock(&at25->lock);
+
 	*cp++ = instr;
 
 	/* 8/16/24-bit address is written MSB first */
@@ -114,7 +117,7 @@ static int at25_ee_read(void *priv, unsigned int offset,
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
-	t[0].tx_buf = command;
+	t[0].tx_buf = at25->command;
 	t[0].len = at25->addrlen + 1;
 	spi_message_add_tail(&t[0], &m);
 
@@ -122,8 +125,6 @@ static int at25_ee_read(void *priv, unsigned int offset,
 	t[1].len = count;
 	spi_message_add_tail(&t[1], &m);
 
-	mutex_lock(&at25->lock);
-
 	/* Read it all at once.
 	 *
 	 * REVISIT that's potentially a problem with large chips, if
@@ -151,7 +152,7 @@ static int fm25_aux_read(struct at25_data *at25, u8 *buf, uint8_t command,
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
-	t[0].tx_buf = &command;
+	t[0].tx_buf = at25->command;
 	t[0].len = 1;
 	spi_message_add_tail(&t[0], &m);
 
@@ -161,6 +162,8 @@ static int fm25_aux_read(struct at25_data *at25, u8 *buf, uint8_t command,
 
 	mutex_lock(&at25->lock);
 
+	at25->command[0] = command;
+
 	status = spi_sync(at25->spi, &m);
 	dev_dbg(&at25->spi->dev, "read %d aux bytes --> %d\n", len, status);
 
-- 
2.35.1

