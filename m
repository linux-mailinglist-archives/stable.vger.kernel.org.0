Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92016450EFA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241587AbhKOSX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:23:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241350AbhKOSTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:19:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAF9163231;
        Mon, 15 Nov 2021 17:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998712;
        bh=6izIzVSJyOGGWPiOpGlTCHsaJn2bqXeweXG3Dy/CjYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UagI+kIn3r5YLUB8ernA730Qmj7CmkyGJUh853Blj7ywxjc5eeOnyAS2PICDrBC7g
         pDbo1Tqp20qeCj9A/dHxUrU8IW0lmPLFKLphy3Dety4emhad3FsokgjRMDGnhs+Ryy
         4n6XjLFSgjHL1pwGPzW0hL/L1OJRm4RqgMdVW1vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.14 006/849] libata: fix read log timeout value
Date:   Mon, 15 Nov 2021 17:51:29 +0100
Message-Id: <20211115165420.192965863@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 68dbbe7d5b4fde736d104cbbc9a2fce875562012 upstream.

Some ATA drives are very slow to respond to READ_LOG_EXT and
READ_LOG_DMA_EXT commands issued from ata_dev_configure() when the
device is revalidated right after resuming a system or inserting the
ATA adapter driver (e.g. ahci). The default 5s timeout
(ATA_EH_CMD_DFL_TIMEOUT) used for these commands is too short, causing
errors during the device configuration. Ex:

...
ata9: SATA max UDMA/133 abar m524288@0x9d200000 port 0x9d200400 irq 209
ata9: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata9.00: ATA-9: XXX  XXXXXXXXXXXXXXX, XXXXXXXX, max UDMA/133
ata9.00: qc timeout (cmd 0x2f)
ata9.00: Read log page 0x00 failed, Emask 0x4
ata9.00: Read log page 0x00 failed, Emask 0x40
ata9.00: NCQ Send/Recv Log not supported
ata9.00: Read log page 0x08 failed, Emask 0x40
ata9.00: 27344764928 sectors, multi 16: LBA48 NCQ (depth 32), AA
ata9.00: Read log page 0x00 failed, Emask 0x40
ata9.00: ATA Identify Device Log not supported
ata9.00: failed to set xfermode (err_mask=0x40)
ata9: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata9.00: configured for UDMA/133
...

The timeout error causes a soft reset of the drive link, followed in
most cases by a successful revalidation as that give enough time to the
drive to become fully ready to quickly process the read log commands.
However, in some cases, this also fails resulting in the device being
dropped.

Fix this by using adding the ata_eh_revalidate_timeouts entries for the
READ_LOG_EXT and READ_LOG_DMA_EXT commands. This defines a timeout
increased to 15s, retriable one time.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-eh.c |    8 ++++++++
 include/linux/libata.h  |    2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -93,6 +93,12 @@ static const unsigned long ata_eh_identi
 	ULONG_MAX,
 };
 
+static const unsigned long ata_eh_revalidate_timeouts[] = {
+	15000,	/* Some drives are slow to read log pages when waking-up */
+	15000,  /* combined time till here is enough even for media access */
+	ULONG_MAX,
+};
+
 static const unsigned long ata_eh_flush_timeouts[] = {
 	15000,	/* be generous with flush */
 	15000,  /* ditto */
@@ -129,6 +135,8 @@ static const struct ata_eh_cmd_timeout_e
 ata_eh_cmd_timeout_table[ATA_EH_CMD_TIMEOUT_TABLE_SIZE] = {
 	{ .commands = CMDS(ATA_CMD_ID_ATA, ATA_CMD_ID_ATAPI),
 	  .timeouts = ata_eh_identify_timeouts, },
+	{ .commands = CMDS(ATA_CMD_READ_LOG_EXT, ATA_CMD_READ_LOG_DMA_EXT),
+	  .timeouts = ata_eh_revalidate_timeouts, },
 	{ .commands = CMDS(ATA_CMD_READ_NATIVE_MAX, ATA_CMD_READ_NATIVE_MAX_EXT),
 	  .timeouts = ata_eh_other_timeouts, },
 	{ .commands = CMDS(ATA_CMD_SET_MAX, ATA_CMD_SET_MAX_EXT),
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -390,7 +390,7 @@ enum {
 	/* This should match the actual table size of
 	 * ata_eh_cmd_timeout_table in libata-eh.c.
 	 */
-	ATA_EH_CMD_TIMEOUT_TABLE_SIZE = 6,
+	ATA_EH_CMD_TIMEOUT_TABLE_SIZE = 7,
 
 	/* Horkage types. May be set by libata or controller on drives
 	   (some horkage may be drive/controller pair dependent */


