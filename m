Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF4C516546
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 18:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349062AbiEAQe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 12:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348893AbiEAQe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 12:34:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EEE62F2
        for <stable@vger.kernel.org>; Sun,  1 May 2022 09:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E3A060F32
        for <stable@vger.kernel.org>; Sun,  1 May 2022 16:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D02C385AA;
        Sun,  1 May 2022 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651422661;
        bh=Ub9pkuUnby423LPF8RMozBTuaZJaTJ8c0VMPBqPk0mI=;
        h=Subject:To:Cc:From:Date:From;
        b=u/y9V9WxMDx9IgP08IxMTwW1kX4I4Pm/z5m+MPFDsCw2Z6YJblXXPB6MIs17y2I7t
         sJ/s8fFW66n2rRInowQxv54gq86FsPsAxG8dJ0o3j0Spr1mRufZDv0O/TsE1Wu/qlX
         TlO/kyTHoEGl6fFjtqmeZghPfbiL+TurapWwxOr8=
Subject: FAILED: patch "[PATCH] eeprom: at25: Use DMA safe buffers" failed to apply to 5.10-stable tree
To:     christophe.leroy@csgroup.eu, gregkh@linuxfoundation.org,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 01 May 2022 18:30:44 +0200
Message-ID: <165142264418625@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5b47b751b760ee1c74a51660fd096aa148a362cd Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Wed, 23 Mar 2022 11:51:55 +0100
Subject: [PATCH] eeprom: at25: Use DMA safe buffers

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

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 91f96abbb3f9..8d169a35cf13 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -31,6 +31,8 @@
  */
 
 #define	FM25_SN_LEN	8		/* serial number length */
+#define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
+
 struct at25_data {
 	struct spi_eeprom	chip;
 	struct spi_device	*spi;
@@ -39,6 +41,7 @@ struct at25_data {
 	struct nvmem_config	nvmem_config;
 	struct nvmem_device	*nvmem;
 	u8 sernum[FM25_SN_LEN];
+	u8 command[EE_MAXADDRLEN + 1];
 };
 
 #define	AT25_WREN	0x06		/* latch the write enable */
@@ -61,8 +64,6 @@ struct at25_data {
 
 #define	FM25_ID_LEN	9		/* ID length */
 
-#define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
-
 /*
  * Specs often allow 5ms for a page write, sometimes 20ms;
  * it's important to recover from write timeouts.
@@ -78,7 +79,6 @@ static int at25_ee_read(void *priv, unsigned int offset,
 {
 	struct at25_data *at25 = priv;
 	char *buf = val;
-	u8			command[EE_MAXADDRLEN + 1];
 	u8			*cp;
 	ssize_t			status;
 	struct spi_transfer	t[2];
@@ -92,12 +92,15 @@ static int at25_ee_read(void *priv, unsigned int offset,
 	if (unlikely(!count))
 		return -EINVAL;
 
-	cp = command;
+	cp = at25->command;
 
 	instr = AT25_READ;
 	if (at25->chip.flags & EE_INSTR_BIT3_IS_ADDR)
 		if (offset >= BIT(at25->addrlen * 8))
 			instr |= AT25_INSTR_BIT3;
+
+	mutex_lock(&at25->lock);
+
 	*cp++ = instr;
 
 	/* 8/16/24-bit address is written MSB first */
@@ -116,7 +119,7 @@ static int at25_ee_read(void *priv, unsigned int offset,
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
-	t[0].tx_buf = command;
+	t[0].tx_buf = at25->command;
 	t[0].len = at25->addrlen + 1;
 	spi_message_add_tail(&t[0], &m);
 
@@ -124,8 +127,6 @@ static int at25_ee_read(void *priv, unsigned int offset,
 	t[1].len = count;
 	spi_message_add_tail(&t[1], &m);
 
-	mutex_lock(&at25->lock);
-
 	/*
 	 * Read it all at once.
 	 *
@@ -152,7 +153,7 @@ static int fm25_aux_read(struct at25_data *at25, u8 *buf, uint8_t command,
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
-	t[0].tx_buf = &command;
+	t[0].tx_buf = at25->command;
 	t[0].len = 1;
 	spi_message_add_tail(&t[0], &m);
 
@@ -162,6 +163,8 @@ static int fm25_aux_read(struct at25_data *at25, u8 *buf, uint8_t command,
 
 	mutex_lock(&at25->lock);
 
+	at25->command[0] = command;
+
 	status = spi_sync(at25->spi, &m);
 	dev_dbg(&at25->spi->dev, "read %d aux bytes --> %d\n", len, status);
 

