Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE0C47FFDF
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbhL0Pl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239659AbhL0PkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511C4C08E844;
        Mon, 27 Dec 2021 07:38:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE075610A6;
        Mon, 27 Dec 2021 15:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9157BC36AEA;
        Mon, 27 Dec 2021 15:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619520;
        bh=sQTTMRchETzKPT0AIJEtLkclSn1NWGJW/KZGsFuLLl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXm9RjQce71oJqH6PYD9zynNZfxCSulNbahT//1uSmuTXp7HJMBGu9XYPd1Mpt9Db
         7WkcqWLWeEO9ocMy/4cbJKm2QbffVokg1ERhJGLprc799+MEc6nscYY5eMmOy80FZE
         GDWE0dGrDtiMeI2jp3oLGnuWQAbrWhlBy8CaT3Xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 53/76] mmc: meson-mx-sdhc: Set MANUAL_STOP for multi-block SDIO commands
Date:   Mon, 27 Dec 2021 16:31:08 +0100
Message-Id: <20211227151326.539105353@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit f89b548ca66be7500dcd92ee8e61590f7d08ac91 upstream.

The vendor driver implements special handling for multi-block
SD_IO_RW_EXTENDED (and SD_IO_RW_DIRECT) commands which have data
attached to them. It sets the MANUAL_STOP bit in the MESON_SDHC_MISC
register for these commands. In all other cases this bit is cleared.
Here we omit SD_IO_RW_DIRECT since that command never has any data
attached to it.

This fixes SDIO wifi using the brcmfmac driver which reported the
following error without this change on a Netxeon S82 board using a
Meson8 (S802) SoC:
  brcmf_fw_alloc_request: using brcm/brcmfmac43362-sdio for chip
                          BCM43362/1
  brcmf_sdiod_ramrw: membytes transfer failed
  brcmf_sdio_download_code_file: error -110 on writing 219557 membytes
                                 at 0x00000000
  brcmf_sdio_download_firmware: dongle image file download failed

And with this change:
  brcmf_fw_alloc_request: using brcm/brcmfmac43362-sdio for chip
                          BCM43362/1
  brcmf_c_process_clm_blob: no clm_blob available (err=-2), device may
                            have limited channels available
  brcmf_c_preinit_dcmds: Firmware: BCM43362/1 wl0: Apr 22 2013 14:50:00
                         version 5.90.195.89.6 FWID 01-b30a427d

Fixes: e4bf1b0970ef96 ("mmc: host: meson-mx-sdhc: new driver for the Amlogic Meson SDHC host")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211219153442.463863-2-martin.blumenstingl@googlemail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-mx-sdhc-mmc.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/mmc/host/meson-mx-sdhc-mmc.c
+++ b/drivers/mmc/host/meson-mx-sdhc-mmc.c
@@ -135,6 +135,7 @@ static void meson_mx_sdhc_start_cmd(stru
 				    struct mmc_command *cmd)
 {
 	struct meson_mx_sdhc_host *host = mmc_priv(mmc);
+	bool manual_stop = false;
 	u32 ictl, send;
 	int pack_len;
 
@@ -172,12 +173,27 @@ static void meson_mx_sdhc_start_cmd(stru
 		else
 			/* software flush: */
 			ictl |= MESON_SDHC_ICTL_DATA_XFER_OK;
+
+		/*
+		 * Mimic the logic from the vendor driver where (only)
+		 * SD_IO_RW_EXTENDED commands with more than one block set the
+		 * MESON_SDHC_MISC_MANUAL_STOP bit. This fixes the firmware
+		 * download in the brcmfmac driver for a BCM43362/1 card.
+		 * Without this sdio_memcpy_toio() (with a size of 219557
+		 * bytes) times out if MESON_SDHC_MISC_MANUAL_STOP is not set.
+		 */
+		manual_stop = cmd->data->blocks > 1 &&
+			      cmd->opcode == SD_IO_RW_EXTENDED;
 	} else {
 		pack_len = 0;
 
 		ictl |= MESON_SDHC_ICTL_RESP_OK;
 	}
 
+	regmap_update_bits(host->regmap, MESON_SDHC_MISC,
+			   MESON_SDHC_MISC_MANUAL_STOP,
+			   manual_stop ? MESON_SDHC_MISC_MANUAL_STOP : 0);
+
 	if (cmd->opcode == MMC_STOP_TRANSMISSION)
 		send |= MESON_SDHC_SEND_DATA_STOP;
 


