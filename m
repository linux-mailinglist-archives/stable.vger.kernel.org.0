Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF673C5548
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355504AbhGLIJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353409AbhGLICI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17D4461C86;
        Mon, 12 Jul 2021 07:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076503;
        bh=vn/VPJBysEMnVybQe14G/wmQ9C23wb6BVbVn/IuU1J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLp4OLrbEUnQ/z8ZDpqoySFGSGWNFckQMihdpVAFs9x4Ss+9PZ5viPKSIAbHtlFm5
         WUxv/g0Ohau946MSeb+mPrXRwTz65TvAJX1d9NSjeOMqpyVrTlse3BDsH+IDDkiWqt
         zGSUhCIeKx4WL40qCE/QjdUgtMKEE2ojzxJb2Ms4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 672/800] fsi: scom: Reset the FSI2PIB engine for any error
Date:   Mon, 12 Jul 2021 08:11:35 +0200
Message-Id: <20210712061038.444589198@linuxfoundation.org>
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

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit a5c317dac5567206ca7b6bc9d008dd6890c8bced ]

The error bits in the FSI2PIB status are only cleared by a reset. So
the driver needs to perform a reset after seeing any of the FSI2PIB
errors, otherwise subsequent operations will also look like failures.

Fixes: 6b293258cded ("fsi: scom: Major overhaul")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20210329151344.14246-1-eajames@linux.ibm.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-scom.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/fsi/fsi-scom.c b/drivers/fsi/fsi-scom.c
index b45bfab7b7f5..75d1389e2626 100644
--- a/drivers/fsi/fsi-scom.c
+++ b/drivers/fsi/fsi-scom.c
@@ -38,9 +38,10 @@
 #define SCOM_STATUS_PIB_RESP_MASK	0x00007000
 #define SCOM_STATUS_PIB_RESP_SHIFT	12
 
-#define SCOM_STATUS_ANY_ERR		(SCOM_STATUS_PROTECTION | \
-					 SCOM_STATUS_PARITY |	  \
-					 SCOM_STATUS_PIB_ABORT | \
+#define SCOM_STATUS_FSI2PIB_ERROR	(SCOM_STATUS_PROTECTION |	\
+					 SCOM_STATUS_PARITY |		\
+					 SCOM_STATUS_PIB_ABORT)
+#define SCOM_STATUS_ANY_ERR		(SCOM_STATUS_FSI2PIB_ERROR |	\
 					 SCOM_STATUS_PIB_RESP_MASK)
 /* SCOM address encodings */
 #define XSCOM_ADDR_IND_FLAG		BIT_ULL(63)
@@ -240,13 +241,14 @@ static int handle_fsi2pib_status(struct scom_device *scom, uint32_t status)
 {
 	uint32_t dummy = -1;
 
-	if (status & SCOM_STATUS_PROTECTION)
-		return -EPERM;
-	if (status & SCOM_STATUS_PARITY) {
+	if (status & SCOM_STATUS_FSI2PIB_ERROR)
 		fsi_device_write(scom->fsi_dev, SCOM_FSI2PIB_RESET_REG, &dummy,
 				 sizeof(uint32_t));
+
+	if (status & SCOM_STATUS_PROTECTION)
+		return -EPERM;
+	if (status & SCOM_STATUS_PARITY)
 		return -EIO;
-	}
 	/* Return -EBUSY on PIB abort to force a retry */
 	if (status & SCOM_STATUS_PIB_ABORT)
 		return -EBUSY;
-- 
2.30.2



