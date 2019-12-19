Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C99A126AE4
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbfLSSv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:51:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730186AbfLSSvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:51:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B00C92064B;
        Thu, 19 Dec 2019 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781513;
        bh=wzrWLkjW0uPzgoAymaZOMN7L1Rznj01UlrJbLeIfw4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kad6cY9KiLgFQExjhald6/JNGCLIE9I6U5a30oWUJ1OfLM/kAeGDoKExmuuHVKh11
         VyPwMCVVaCTdGSSZXbQA19NoqrJ3kNfBv8nZ3XVV4ZP/iPBw/hwFtjipGdA+1qaTFi
         s/ToQ0HCoJAgpGjKJyH92LQUFjujW9YMcFTYLe20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chaotian Jing <chaotian.jing@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 16/47] mmc: block: Make card_busy_detect() a bit more generic
Date:   Thu, 19 Dec 2019 19:34:30 +0100
Message-Id: <20191219182917.317219858@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
References: <20191219182857.659088743@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaotian Jing <chaotian.jing@mediatek.com>

commit 3869468e0c4800af52bfe1e0b72b338dcdae2cfc upstream.

To prepare for more users of card_busy_detect(), let's drop the struct
request * as an in-parameter and convert to log the error message via
dev_err() instead of pr_err().

Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/block.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -982,7 +982,7 @@ static inline bool mmc_blk_in_tran_state
 }
 
 static int card_busy_detect(struct mmc_card *card, unsigned int timeout_ms,
-			    struct request *req, u32 *resp_errs)
+			    u32 *resp_errs)
 {
 	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
 	int err = 0;
@@ -993,8 +993,8 @@ static int card_busy_detect(struct mmc_c
 
 		err = __mmc_send_status(card, &status, 5);
 		if (err) {
-			pr_err("%s: error %d requesting status\n",
-			       req->rq_disk->disk_name, err);
+			dev_err(mmc_dev(card->host),
+				"error %d requesting status\n", err);
 			return err;
 		}
 
@@ -1007,9 +1007,9 @@ static int card_busy_detect(struct mmc_c
 		 * leaves the program state.
 		 */
 		if (done) {
-			pr_err("%s: Card stuck in wrong state! %s %s status: %#x\n",
-				mmc_hostname(card->host),
-				req->rq_disk->disk_name, __func__, status);
+			dev_err(mmc_dev(card->host),
+				"Card stuck in wrong state! %s status: %#x\n",
+				 __func__, status);
 			return -ETIMEDOUT;
 		}
 
@@ -1678,7 +1678,7 @@ static int mmc_blk_fix_state(struct mmc_
 
 	mmc_blk_send_stop(card, timeout);
 
-	err = card_busy_detect(card, timeout, req, NULL);
+	err = card_busy_detect(card, timeout, NULL);
 
 	mmc_retune_release(card->host);
 
@@ -1902,7 +1902,7 @@ static int mmc_blk_card_busy(struct mmc_
 	if (mmc_host_is_spi(card->host) || rq_data_dir(req) == READ)
 		return 0;
 
-	err = card_busy_detect(card, MMC_BLK_TIMEOUT_MS, req, &status);
+	err = card_busy_detect(card, MMC_BLK_TIMEOUT_MS, &status);
 
 	/*
 	 * Do not assume data transferred correctly if there are any error bits


