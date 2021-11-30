Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E0C463839
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243297AbhK3O6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:58:53 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:60272 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhK3O4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:56:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C4817CE1A75;
        Tue, 30 Nov 2021 14:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11F2C53FC1;
        Tue, 30 Nov 2021 14:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284009;
        bh=WHjCRXogm5Kl8KpuQkkByV+cS/mu/8FDifLQmqlyog4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHlqBTCQcrU1eyTM9zNzCygDekPGIiLmdMZI7b58ajuQxu7LsKhpM8qpF9fHRSud9
         Jo6xTduDqdyKGzFddEjSg7RPk77b03R+AAQ/CjxaD9ly+4oo5GTMyoxSp8Wms4YY4u
         1LWoxPf/8OYbleHz+OxDdkxRorHLBKhdrFw2EZrG0E2mk2rYDCzbfIasGrSJiHhZEr
         Z8ugCbDCkExRC0p06NmApxnDw3rLcpqLNCt1nPw6MJum3GTf6gyi0sile/dOMn6jjO
         6wDTwMf6k3don8tBOG8IaepdLzjicxVUghiiu0XNcflXw5EFEq2Yy0MPCBpfbDt93K
         DOvfGKkjoDwYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        ck+kernelbugzilla@bl4ckb0x.de, stephane.poignant@protonmail.com,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/14] i2c: i801: Fix interrupt storm from SMB_ALERT signal
Date:   Tue, 30 Nov 2021 09:53:08 -0500
Message-Id: <20211130145317.946676-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145317.946676-1-sashal@kernel.org>
References: <20211130145317.946676-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 03a976c9afb5e3c4f8260c6c08a27d723b279c92 ]

Currently interrupt storm will occur from i2c-i801 after first
transaction if SMB_ALERT signal is enabled and ever asserted. It is
enough if the signal is asserted once even before the driver is loaded
and does not recover because that interrupt is not acknowledged.

This fix aims to fix it by two ways:
- Add acknowledging for the SMB_ALERT interrupt status
- Disable the SMB_ALERT interrupt on platforms where possible since the
  driver currently does not make use for it

Acknowledging resets the SMB_ALERT interrupt status on all platforms and
also should help to avoid interrupt storm on older platforms where the
SMB_ALERT interrupt disabling is not available.

For simplicity this fix reuses the host notify feature for disabling and
restoring original register value.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=177311
Reported-by: ck+kernelbugzilla@bl4ckb0x.de
Reported-by: stephane.poignant@protonmail.com
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Tested-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 7b1654b0fb6db..2964c3a3f89f2 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -196,6 +196,7 @@
 #define SMBSLVSTS_HST_NTFY_STS	BIT(0)
 
 /* Host Notify Command register bits */
+#define SMBSLVCMD_SMBALERT_DISABLE	BIT(2)
 #define SMBSLVCMD_HST_NTFY_INTREN	BIT(0)
 
 #define STATUS_ERROR_FLAGS	(SMBHSTSTS_FAILED | SMBHSTSTS_BUS_ERR | \
@@ -639,12 +640,20 @@ static irqreturn_t i801_isr(int irq, void *dev_id)
 		i801_isr_byte_done(priv);
 
 	/*
-	 * Clear irq sources and report transaction result.
+	 * Clear remaining IRQ sources: Completion of last command, errors
+	 * and the SMB_ALERT signal. SMB_ALERT status is set after signal
+	 * assertion independently of the interrupt generation being blocked
+	 * or not so clear it always when the status is set.
+	 */
+	status &= SMBHSTSTS_INTR | STATUS_ERROR_FLAGS | SMBHSTSTS_SMBALERT_STS;
+	if (status)
+		outb_p(status, SMBHSTSTS(priv));
+	status &= ~SMBHSTSTS_SMBALERT_STS; /* SMB_ALERT not reported */
+	/*
+	 * Report transaction result.
 	 * ->status must be cleared before the next transaction is started.
 	 */
-	status &= SMBHSTSTS_INTR | STATUS_ERROR_FLAGS;
 	if (status) {
-		outb_p(status, SMBHSTSTS(priv));
 		priv->status = status;
 		wake_up(&priv->waitq);
 	}
@@ -964,9 +973,13 @@ static void i801_enable_host_notify(struct i2c_adapter *adapter)
 	if (!(priv->features & FEATURE_HOST_NOTIFY))
 		return;
 
-	if (!(SMBSLVCMD_HST_NTFY_INTREN & priv->original_slvcmd))
-		outb_p(SMBSLVCMD_HST_NTFY_INTREN | priv->original_slvcmd,
-		       SMBSLVCMD(priv));
+	/*
+	 * Enable host notify interrupt and block the generation of interrupt
+	 * from the SMB_ALERT signal because the driver does not support
+	 * SMBus Alert.
+	 */
+	outb_p(SMBSLVCMD_HST_NTFY_INTREN | SMBSLVCMD_SMBALERT_DISABLE |
+	       priv->original_slvcmd, SMBSLVCMD(priv));
 
 	/* clear Host Notify bit to allow a new notification */
 	outb_p(SMBSLVSTS_HST_NTFY_STS, SMBSLVSTS(priv));
-- 
2.33.0

