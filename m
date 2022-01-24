Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F14B499D5B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1583414AbiAXWRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581211AbiAXWLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:11:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924AEC0DF2FE;
        Mon, 24 Jan 2022 12:43:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E164360907;
        Mon, 24 Jan 2022 20:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA5DC340E5;
        Mon, 24 Jan 2022 20:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057013;
        bh=ddcl4cBea324E6KzDBct/pV9ygz8c88MAFzgAN9niJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCS3moWeixOMvs3MW9U7sILYSO73qsoLA1n2geE3c2TvS8MghnhBJ4WzkN7ZJOPzs
         xvsAGvtB+sJvuqbxcV0t+miLP/AKXDd1G2gBRrwmNA+8aFMsRR6kRvWXSPV++oKapN
         keeJsAOkNAeAL6lxcBUqP8Xmtdead9vPmj8SUFkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 673/846] tpm: fix potential NULL pointer access in tpm_del_char_device
Date:   Mon, 24 Jan 2022 19:43:10 +0100
Message-Id: <20220124184124.292354647@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

commit eabad7ba2c752392ae50f24a795093fb115b686d upstream.

Some SPI controller drivers unregister the controller in the shutdown
handler (e.g. BCM2835). If such a controller is used with a TPM 2 slave
chip->ops may be accessed when it is already NULL:

At system shutdown the pre-shutdown handler tpm_class_shutdown() shuts down
TPM 2 and sets chip->ops to NULL. Then at SPI controller unregistration
tpm_tis_spi_remove() is called and eventually calls tpm_del_char_device()
which tries to shut down TPM 2 again. Thereby it accesses chip->ops again:
(tpm_del_char_device calls tpm_chip_start which calls tpm_clk_enable which
calls chip->ops->clk_enable).

Avoid the NULL pointer access by testing if chip->ops is valid and skipping
the TPM 2 shutdown procedure in case it is NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Fixes: 39d0099f9439 ("powerpc/pseries: Add shutdown() to vio_driver and vio_bus")
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-chip.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -474,13 +474,21 @@ static void tpm_del_char_device(struct t
 
 	/* Make the driver uncallable. */
 	down_write(&chip->ops_sem);
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		if (!tpm_chip_start(chip)) {
-			tpm2_shutdown(chip, TPM2_SU_CLEAR);
-			tpm_chip_stop(chip);
+
+	/*
+	 * Check if chip->ops is still valid: In case that the controller
+	 * drivers shutdown handler unregisters the controller in its
+	 * shutdown handler we are called twice and chip->ops to NULL.
+	 */
+	if (chip->ops) {
+		if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+			if (!tpm_chip_start(chip)) {
+				tpm2_shutdown(chip, TPM2_SU_CLEAR);
+				tpm_chip_stop(chip);
+			}
 		}
+		chip->ops = NULL;
 	}
-	chip->ops = NULL;
 	up_write(&chip->ops_sem);
 }
 


