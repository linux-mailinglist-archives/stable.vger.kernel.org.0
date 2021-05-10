Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9391937836F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhEJKpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232170AbhEJKmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66E6861925;
        Mon, 10 May 2021 10:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642746;
        bh=ETJoj2j80oumrwPwA11tzNIIEASKJKrk3A+O9Q4qKDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COGU1urzS7zV/R2nZq8V8aKkh99uGunwAtXSDXVROl7pPX4S26NyxUcyWaEvDpmaG
         Xkt6WPy6nXiTUsmdY7e12rk2DTj8UWTdnESzw398n8dIK1JRAkRak+qDlp9L/GZYIh
         dHMVrV5DrIoptxUG3Ys5qIOyAovXgcxfEj7P446Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brendan Peter <bpeter@lytx.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 034/299] mmc: block: Issue a cache flush only when its enabled
Date:   Mon, 10 May 2021 12:17:11 +0200
Message-Id: <20210510102005.975415818@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avri Altman <avri.altman@wdc.com>

commit 97fce126e279690105ee15be652b465fd96f9997 upstream.

In command queueing mode, the cache isn't flushed via the mmc_flush_cache()
function, but instead by issuing a CMDQ_TASK_MGMT (CMD48) with a
FLUSH_CACHE opcode. In this path, we need to check if cache has been
enabled, before deciding to flush the cache, along the lines of what's
being done in mmc_flush_cache().

To fix this problem, let's add a new bus ops callback ->cache_enabled() and
implement it for the mmc bus type. In this way, the mmc block device driver
can call it to know whether cache flushing should be done.

Fixes: 1e8e55b67030 (mmc: block: Add CQE support)
Cc: stable@vger.kernel.org
Reported-by: Brendan Peter <bpeter@lytx.com>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Tested-by: Brendan Peter <bpeter@lytx.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20210425060207.2591-2-avri.altman@wdc.com
Link: https://lore.kernel.org/r/20210425060207.2591-3-avri.altman@wdc.com
[Ulf: Squashed the two patches and made some minor updates]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c   |    4 ++++
 drivers/mmc/core/core.h    |    9 +++++++++
 drivers/mmc/core/mmc.c     |    7 +++++++
 drivers/mmc/core/mmc_ops.c |    4 +---
 4 files changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2233,6 +2233,10 @@ enum mmc_issued mmc_blk_mq_issue_rq(stru
 	case MMC_ISSUE_ASYNC:
 		switch (req_op(req)) {
 		case REQ_OP_FLUSH:
+			if (!mmc_cache_enabled(host)) {
+				blk_mq_end_request(req, BLK_STS_OK);
+				return MMC_REQ_FINISHED;
+			}
 			ret = mmc_blk_cqe_issue_flush(mq, req);
 			break;
 		case REQ_OP_READ:
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -29,6 +29,7 @@ struct mmc_bus_ops {
 	int (*shutdown)(struct mmc_host *);
 	int (*hw_reset)(struct mmc_host *);
 	int (*sw_reset)(struct mmc_host *);
+	bool (*cache_enabled)(struct mmc_host *);
 };
 
 void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops);
@@ -171,4 +172,12 @@ static inline void mmc_post_req(struct m
 		host->ops->post_req(host, mrq, err);
 }
 
+static inline bool mmc_cache_enabled(struct mmc_host *host)
+{
+	if (host->bus_ops->cache_enabled)
+		return host->bus_ops->cache_enabled(host);
+
+	return false;
+}
+
 #endif
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -2033,6 +2033,12 @@ static void mmc_detect(struct mmc_host *
 	}
 }
 
+static bool _mmc_cache_enabled(struct mmc_host *host)
+{
+	return host->card->ext_csd.cache_size > 0 &&
+	       host->card->ext_csd.cache_ctrl & 1;
+}
+
 static int _mmc_suspend(struct mmc_host *host, bool is_suspend)
 {
 	int err = 0;
@@ -2212,6 +2218,7 @@ static const struct mmc_bus_ops mmc_ops
 	.alive = mmc_alive,
 	.shutdown = mmc_shutdown,
 	.hw_reset = _mmc_hw_reset,
+	.cache_enabled = _mmc_cache_enabled,
 };
 
 /*
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -988,9 +988,7 @@ int mmc_flush_cache(struct mmc_card *car
 {
 	int err = 0;
 
-	if (mmc_card_mmc(card) &&
-			(card->ext_csd.cache_size > 0) &&
-			(card->ext_csd.cache_ctrl & 1)) {
+	if (mmc_cache_enabled(card->host)) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 				 EXT_CSD_FLUSH_CACHE, 1,
 				 MMC_CACHE_FLUSH_TIMEOUT_MS);


