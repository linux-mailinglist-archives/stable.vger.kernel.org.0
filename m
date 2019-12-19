Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB55126B99
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbfLSSy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:54:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730503AbfLSSy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB1624682;
        Thu, 19 Dec 2019 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781665;
        bh=Rakh7aKAatwab82LT84/GcbyiGBhDIINLMhmkt54iRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AF2I035Q1OHMcePRsXkmd5Mf/tIStdQ0PWeZuOCNMPK2JgGS58dxogovqC1vLEAC5
         6zrJb9j0HlVZHtGu0sgGTDKrvj2/KJoCWDsNYECvtDBa4wB1vvpktTUEZ7yqRg/rLy
         I5HBPleS3aR3gWUFl6EyxmSHdn/dCmzB2plpLJNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chaotian Jing <chaotian.jing@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 03/80] mmc: block: Add CMD13 polling for MMC IOCTLS with R1B response
Date:   Thu, 19 Dec 2019 19:33:55 +0100
Message-Id: <20191219183033.198791681@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaotian Jing <chaotian.jing@mediatek.com>

commit a0d4c7eb71dd08a89ad631177bb0cbbabd598f84 upstream.

MMC IOCTLS with R1B responses may cause the card to enter the busy state,
which means it's not ready to receive a new request. To prevent new
requests from being sent to the card, use a CMD13 polling loop to verify
that the card returns to the transfer state, before completing the request.

Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/block.c |  147 +++++++++++++++++------------------------------
 1 file changed, 55 insertions(+), 92 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -408,38 +408,6 @@ static int mmc_blk_ioctl_copy_to_user(st
 	return 0;
 }
 
-static int ioctl_rpmb_card_status_poll(struct mmc_card *card, u32 *status,
-				       u32 retries_max)
-{
-	int err;
-	u32 retry_count = 0;
-
-	if (!status || !retries_max)
-		return -EINVAL;
-
-	do {
-		err = __mmc_send_status(card, status, 5);
-		if (err)
-			break;
-
-		if (!R1_STATUS(*status) &&
-				(R1_CURRENT_STATE(*status) != R1_STATE_PRG))
-			break; /* RPMB programming operation complete */
-
-		/*
-		 * Rechedule to give the MMC device a chance to continue
-		 * processing the previous command without being polled too
-		 * frequently.
-		 */
-		usleep_range(1000, 5000);
-	} while (++retry_count < retries_max);
-
-	if (retry_count == retries_max)
-		err = -EPERM;
-
-	return err;
-}
-
 static int ioctl_do_sanitize(struct mmc_card *card)
 {
 	int err;
@@ -468,6 +436,58 @@ out:
 	return err;
 }
 
+static inline bool mmc_blk_in_tran_state(u32 status)
+{
+	/*
+	 * Some cards mishandle the status bits, so make sure to check both the
+	 * busy indication and the card state.
+	 */
+	return status & R1_READY_FOR_DATA &&
+	       (R1_CURRENT_STATE(status) == R1_STATE_TRAN);
+}
+
+static int card_busy_detect(struct mmc_card *card, unsigned int timeout_ms,
+			    u32 *resp_errs)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
+	int err = 0;
+	u32 status;
+
+	do {
+		bool done = time_after(jiffies, timeout);
+
+		err = __mmc_send_status(card, &status, 5);
+		if (err) {
+			dev_err(mmc_dev(card->host),
+				"error %d requesting status\n", err);
+			return err;
+		}
+
+		/* Accumulate any response error bits seen */
+		if (resp_errs)
+			*resp_errs |= status;
+
+		/*
+		 * Timeout if the device never becomes ready for data and never
+		 * leaves the program state.
+		 */
+		if (done) {
+			dev_err(mmc_dev(card->host),
+				"Card stuck in wrong state! %s status: %#x\n",
+				 __func__, status);
+			return -ETIMEDOUT;
+		}
+
+		/*
+		 * Some cards mishandle the status bits,
+		 * so make sure to check both the busy
+		 * indication and the card state.
+		 */
+	} while (!mmc_blk_in_tran_state(status));
+
+	return err;
+}
+
 static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
 			       struct mmc_blk_ioc_data *idata)
 {
@@ -477,7 +497,6 @@ static int __mmc_blk_ioctl_cmd(struct mm
 	struct scatterlist sg;
 	int err;
 	unsigned int target_part;
-	u32 status = 0;
 
 	if (!card || !md || !idata)
 		return -EINVAL;
@@ -611,16 +630,12 @@ static int __mmc_blk_ioctl_cmd(struct mm
 
 	memcpy(&(idata->ic.response), cmd.resp, sizeof(cmd.resp));
 
-	if (idata->rpmb) {
+	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B)) {
 		/*
-		 * Ensure RPMB command has completed by polling CMD13
+		 * Ensure RPMB/R1B command has completed by polling CMD13
 		 * "Send Status".
 		 */
-		err = ioctl_rpmb_card_status_poll(card, &status, 5);
-		if (err)
-			dev_err(mmc_dev(card->host),
-					"%s: Card Status=0x%08X, error %d\n",
-					__func__, status, err);
+		err = card_busy_detect(card, MMC_BLK_TIMEOUT_MS, NULL);
 	}
 
 	return err;
@@ -970,58 +985,6 @@ static unsigned int mmc_blk_data_timeout
 	return ms;
 }
 
-static inline bool mmc_blk_in_tran_state(u32 status)
-{
-	/*
-	 * Some cards mishandle the status bits, so make sure to check both the
-	 * busy indication and the card state.
-	 */
-	return status & R1_READY_FOR_DATA &&
-	       (R1_CURRENT_STATE(status) == R1_STATE_TRAN);
-}
-
-static int card_busy_detect(struct mmc_card *card, unsigned int timeout_ms,
-			    u32 *resp_errs)
-{
-	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
-	int err = 0;
-	u32 status;
-
-	do {
-		bool done = time_after(jiffies, timeout);
-
-		err = __mmc_send_status(card, &status, 5);
-		if (err) {
-			dev_err(mmc_dev(card->host),
-				"error %d requesting status\n", err);
-			return err;
-		}
-
-		/* Accumulate any response error bits seen */
-		if (resp_errs)
-			*resp_errs |= status;
-
-		/*
-		 * Timeout if the device never becomes ready for data and never
-		 * leaves the program state.
-		 */
-		if (done) {
-			dev_err(mmc_dev(card->host),
-				"Card stuck in wrong state! %s status: %#x\n",
-				 __func__, status);
-			return -ETIMEDOUT;
-		}
-
-		/*
-		 * Some cards mishandle the status bits,
-		 * so make sure to check both the busy
-		 * indication and the card state.
-		 */
-	} while (!mmc_blk_in_tran_state(status));
-
-	return err;
-}
-
 static int mmc_blk_reset(struct mmc_blk_data *md, struct mmc_host *host,
 			 int type)
 {


