Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57F46137E8D
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgAKKLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:11:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgAKKLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:11:11 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6774206DA;
        Sat, 11 Jan 2020 10:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737470;
        bh=S58NJcF7W084CSOKXy/vHHYh/uY+5RLG0+7WgTqAwHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5g1/YG35nPrskuA/vy7sg4lEqS/bCrSoxpC/cLls64draZ3aDCqf2aomsQb4K8kV
         UoOIkd+8Ota8OXtQOcGtaUFN+vf7NxcADEP+itmYdTVEnO+HGVVIy6sDosZFOCRcoB
         5XxahgH0yvomQgW2vxXGm+ycILBs82p/K2G/FyE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Subject: [PATCH 4.14 44/62] mmc: block: Delete mmc_access_rpmb()
Date:   Sat, 11 Jan 2020 10:50:26 +0100
Message-Id: <20200111094850.226463946@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 14f4ca7e4d2825f9f71e22905ae177b899959f1d upstream.

This function is used by the block layer queue to bail out of
requests if the current request is towards an RPMB
"block device".

This was done to avoid boot time scanning of this "block
device" which was never really a block device, thus duct-taping
over the fact that it was badly engineered.

This problem is now gone as we removed the offending RPMB block
device in another patch and replaced it with a character
device.

Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/block.c |   12 ------------
 drivers/mmc/core/queue.c |    2 +-
 drivers/mmc/core/queue.h |    2 --
 3 files changed, 1 insertion(+), 15 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1239,18 +1239,6 @@ static inline void mmc_blk_reset_success
 	md->reset_done &= ~type;
 }
 
-int mmc_access_rpmb(struct mmc_queue *mq)
-{
-	struct mmc_blk_data *md = mq->blkdata;
-	/*
-	 * If this is a RPMB partition access, return ture
-	 */
-	if (md && md->part_type == EXT_CSD_PART_CONFIG_ACC_RPMB)
-		return true;
-
-	return false;
-}
-
 /*
  * The non-block commands come back from the block layer after it queued it and
  * processed it with all other requests and then they get issued in this
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -30,7 +30,7 @@ static int mmc_prep_request(struct reque
 {
 	struct mmc_queue *mq = q->queuedata;
 
-	if (mq && (mmc_card_removed(mq->card) || mmc_access_rpmb(mq)))
+	if (mq && mmc_card_removed(mq->card))
 		return BLKPREP_KILL;
 
 	req->rq_flags |= RQF_DONTPREP;
--- a/drivers/mmc/core/queue.h
+++ b/drivers/mmc/core/queue.h
@@ -84,6 +84,4 @@ extern void mmc_queue_resume(struct mmc_
 extern unsigned int mmc_queue_map_sg(struct mmc_queue *,
 				     struct mmc_queue_req *);
 
-extern int mmc_access_rpmb(struct mmc_queue *);
-
 #endif


