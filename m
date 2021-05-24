Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0251038EE54
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhEXPsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234318AbhEXPq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:46:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D84F061464;
        Mon, 24 May 2021 15:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870608;
        bh=PhYoiT3RYsgbOCAnboZLWyl+uNOG8VMJEGIzWL6htM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAvfKStHtHe07O/5LFM1BIBOufhkNxK2bQSWkBz+GkCMfjoSypcyY1f7YqiEEbnDz
         VTr4bPe5uTiJhH41CJy4lkwxr2iXEOALE0Wq8w22AO+xZbwd5ouOngUcGCbdYA9/RJ
         MkTqs2KNm3PjvMeD8vXAoNyRBK2BYnRtUIlsqFSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/71] scsi: ufs: core: Increase the usable queue depth
Date:   Mon, 24 May 2021 17:25:12 +0200
Message-Id: <20210524152326.664893909@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit d0b2b70eb12e9ffaf95e11b16b230a4e015a536c ]

With the current implementation of the UFS driver active_queues is 1
instead of 0 if all UFS request queues are idle. That causes
hctx_may_queue() to divide the queue depth by 2 when queueing a request and
hence reduces the usable queue depth.

The shared tag set code in the block layer keeps track of the number of
active request queues. blk_mq_tag_busy() is called before a request is
queued onto a hwq and blk_mq_tag_idle() is called some time after the hwq
became idle. blk_mq_tag_idle() is called from inside blk_mq_timeout_work().
Hence, blk_mq_tag_idle() is only called if a timer is associated with each
request that is submitted to a request queue that shares a tag set with
another request queue.

Adds a blk_mq_start_request() call in ufshcd_exec_dev_cmd(). This doubles
the queue depth on my test setup from 16 to 32.

In addition to increasing the usable queue depth, also fix the
documentation of the 'timeout' parameter in the header above
ufshcd_exec_dev_cmd().

Link: https://lore.kernel.org/r/20210513164912.5683-1-bvanassche@acm.org
Fixes: 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating tag conflicts")
Cc: Can Guo <cang@codeaurora.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 25112c2fe2db..0429ba5d7d23 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2615,7 +2615,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
  * ufshcd_exec_dev_cmd - API for sending device management requests
  * @hba: UFS hba
  * @cmd_type: specifies the type (NOP, Query...)
- * @timeout: time in seconds
+ * @timeout: timeout in milliseconds
  *
  * NOTE: Since there is only one available tag for device management commands,
  * it is expected you hold the hba->dev_cmd.lock mutex.
@@ -2645,6 +2645,9 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	}
 	tag = req->tag;
 	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
+	/* Set the timeout such that the SCSI error handler is not activated. */
+	req->timeout = msecs_to_jiffies(2 * timeout);
+	blk_mq_start_request(req);
 
 	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
-- 
2.30.2



