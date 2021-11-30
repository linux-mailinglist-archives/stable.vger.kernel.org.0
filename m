Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159E3463829
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243718AbhK3O60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:58:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58744 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242888AbhK3O40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:56:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9FC6FCE1A74;
        Tue, 30 Nov 2021 14:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0372C53FC7;
        Tue, 30 Nov 2021 14:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283983;
        bh=3S7YOgzGCmBTdU22hi4/KaF8ovSGbDGe7wXFSwKaTPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0NTtfFjCS+9WAvbUjAl0mv34DeD8QIsqx+9DsLNiUs2s2LjoNFT+baBymK/8fGhJ
         Rva+/7za04HTbjmShR8mCddIOR4mGIdAxVy/mPqHmvJeSKSoM++XLoKabDr4gXEemk
         zMdu4wHfceptaVlG2R2EYXWTAg66aOGlRmoPnMO/6yzw77Mrh5XREbKoYa46j9snJV
         lP3KZv4RhyILbQb3Gqi9WFiOvTRB/+/z7+Prsk1a7yLHdpqiVbSz+7T8s1f366QTX0
         WhBSN5O3BAiXOj94PgdFF+7gU6uG2Lo/rKRsHjfCOsKEn8rsnz8NjFbeCpiqYaAmAe
         x0iOswMLOHH/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        ck+kernelbugzilla@bl4ckb0x.de, stephane.poignant@protonmail.com,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/17] i2c: i801: Fix interrupt storm from SMB_ALERT signal
Date:   Tue, 30 Nov 2021 09:52:34 -0500
Message-Id: <20211130145243.946407-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145243.946407-1-sashal@kernel.org>
References: <20211130145243.946407-1-sashal@kernel.org>
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
index efafd028c5d16..3606a1d6a0560 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -199,6 +199,7 @@
 #define SMBSLVSTS_HST_NTFY_STS	BIT(0)
 
 /* Host Notify Command register bits */
+#define SMBSLVCMD_SMBALERT_DISABLE	BIT(2)
 #define SMBSLVCMD_HST_NTFY_INTREN	BIT(0)
 
 #define STATUS_ERROR_FLAGS	(SMBHSTSTS_FAILED | SMBHSTSTS_BUS_ERR | \
@@ -644,12 +645,20 @@ static irqreturn_t i801_isr(int irq, void *dev_id)
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
@@ -969,9 +978,13 @@ static void i801_enable_host_notify(struct i2c_adapter *adapter)
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

