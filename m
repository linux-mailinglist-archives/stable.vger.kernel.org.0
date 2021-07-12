Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CA23C55EA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350422AbhGLIMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354045AbhGLID0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9939D611F1;
        Mon, 12 Jul 2021 07:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076785;
        bh=vbIdOpqykdVZ+lcvBjxFFpJ7AefLJLkRFPmxWAZWWuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=El8Y5PAbvcITRxuYR6b0hFrD+X3mimebAIFXpczrUy5EiB4OnH7Oazy7TIbOp8oJU
         IxqLw+sg5pf/fKOHKQLCfivMqhiRoLYiG3A9qEVRnqQb3VNf9YUBYj5QxwBSj/X00x
         TIkrxwW5NliaCGOQWrqw4nFstOyKqPxoX37x7oek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.13 791/800] tpm: Replace WARN_ONCE() with dev_err_once() in tpm_tis_status()
Date:   Mon, 12 Jul 2021 08:13:34 +0200
Message-Id: <20210712061050.887227851@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 0178f9d0f60ba07e09bab57381a3ef18e2c1fd7f upstream.

Do not tear down the system when getting invalid status from a TPM chip.
This can happen when panic-on-warn is used.

Instead, introduce TPM_TIS_INVALID_STATUS bitflag and use it to trigger
once the error reporting per chip. In addition, print out the value of
TPM_STS for improved forensics.

Link: https://lore.kernel.org/keyrings/YKzlTR1AzUigShtZ@kroah.com/
Fixes: 55707d531af6 ("tpm_tis: Add a check for invalid status")
Cc: stable@vger.kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_tis_core.c |   25 ++++++++++++++++++-------
 drivers/char/tpm/tpm_tis_core.h |    3 ++-
 2 files changed, 20 insertions(+), 8 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -196,13 +196,24 @@ static u8 tpm_tis_status(struct tpm_chip
 		return 0;
 
 	if (unlikely((status & TPM_STS_READ_ZERO) != 0)) {
-		/*
-		 * If this trips, the chances are the read is
-		 * returning 0xff because the locality hasn't been
-		 * acquired.  Usually because tpm_try_get_ops() hasn't
-		 * been called before doing a TPM operation.
-		 */
-		WARN_ONCE(1, "TPM returned invalid status\n");
+		if  (!test_and_set_bit(TPM_TIS_INVALID_STATUS, &priv->flags)) {
+			/*
+			 * If this trips, the chances are the read is
+			 * returning 0xff because the locality hasn't been
+			 * acquired.  Usually because tpm_try_get_ops() hasn't
+			 * been called before doing a TPM operation.
+			 */
+			dev_err(&chip->dev, "invalid TPM_STS.x 0x%02x, dumping stack for forensics\n",
+				status);
+
+			/*
+			 * Dump stack for forensics, as invalid TPM_STS.x could be
+			 * potentially triggered by impaired tpm_try_get_ops() or
+			 * tpm_find_get_ops().
+			 */
+			dump_stack();
+		}
+
 		return 0;
 	}
 
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -83,6 +83,7 @@ enum tis_defaults {
 
 enum tpm_tis_flags {
 	TPM_TIS_ITPM_WORKAROUND		= BIT(0),
+	TPM_TIS_INVALID_STATUS		= BIT(1),
 };
 
 struct tpm_tis_data {
@@ -90,7 +91,7 @@ struct tpm_tis_data {
 	int locality;
 	int irq;
 	bool irq_tested;
-	unsigned int flags;
+	unsigned long flags;
 	void __iomem *ilb_base_addr;
 	u16 clkrun_enabled;
 	wait_queue_head_t int_queue;


