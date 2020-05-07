Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F00A1C8D83
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgEGOF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:05:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:59853 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgEGOF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:05:59 -0400
IronPort-SDR: RP/Y2f1PV6Emv49xb6l2YoaXl7/QebIatPptIWObMuuctY/UK0QSHCdI1hudmEjixDfd464bDX
 /sPvo1RSme8g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 07:05:58 -0700
IronPort-SDR: 5tCBvfLrV57N2TTqBGhMqkkL/5QL+bUuW+LU44NCJSYKO4wgf/ixNS2eiWonlITIrNCWcGxFft
 bqNf61n2K5pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,363,1583222400"; 
   d="scan'208";a="339361341"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.157]) ([10.237.72.157])
  by orsmga001.jf.intel.com with ESMTP; 07 May 2020 07:05:55 -0700
Subject: [PATCH] mmc: block: Fix request completion in the CQE timeout path
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        ulf.hansson@linaro.org
Cc:     stummala@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Sarthak Garg <sartgarg@codeaurora.org>, stable@vger.kernel.org,
        Baolin Wang <baolin.wang@linaro.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
References: <1588775643-18037-1-git-send-email-vbadigan@codeaurora.org>
 <1588775643-18037-3-git-send-email-vbadigan@codeaurora.org>
 <b4a01f2c-479a-2a23-58b7-64f16cbc17a2@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <66747f4c-e61f-509f-a3cc-7e3499a844e4@intel.com>
Date:   Thu, 7 May 2020 17:06:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <b4a01f2c-479a-2a23-58b7-64f16cbc17a2@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

First, it should be noted that the CQE timeout (60 seconds) is substantial
so a CQE request that times out is really stuck, and the race between
timeout and completion is extremely unlikely. Nevertheless this patch
fixes an issue with it.

Commit ad73d6feadbd7b ("mmc: complete requests from ->timeout")
preserved the existing functionality, to complete the request.
However that had only been necessary because the block layer
timeout handler had been marking the request to prevent it from being
completed normally. That restriction was removed at the same time, the
result being that a request that has gone will have been completed anyway.
That is, the completion in the timeout handler became unnecessary.

At the time, the unnecessary completion was harmless because the block
layer would ignore it, although that changed in kernel v5.0.

Note for stable, this patch will not apply cleanly without patch "mmc:
core: Fix recursive locking issue in CQE recovery path"

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: ad73d6feadbd7b ("mmc: complete requests from ->timeout")
Cc: stable@vger.kernel.org
---


This is the patch I alluded to when replying to "mmc: core: Fix recursive
locking issue in CQE recovery path"


 drivers/mmc/core/queue.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 72bef39d7011..10ea67892b5f 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -110,8 +110,7 @@ static enum blk_eh_timer_return mmc_cqe_timed_out(struct
request *req)
 				mmc_cqe_recovery_notifier(mrq);
 			return BLK_EH_RESET_TIMER;
 		}
-		/* No timeout (XXX: huh? comment doesn't make much sense) */
-		blk_mq_complete_request(req);
+		/* The request has gone already */
 		return BLK_EH_DONE;
 	default:
 		/* Timeout is handled by mmc core */
-- 
2.17.1

