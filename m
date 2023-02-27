Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22B56A38B9
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjB0CgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjB0Cf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:35:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244171B571;
        Sun, 26 Feb 2023 18:35:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F027B60CA3;
        Mon, 27 Feb 2023 02:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D994BC433D2;
        Mon, 27 Feb 2023 02:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463678;
        bh=QKIMaQF7XXFjtcqy6YI45gQA80BPDI6UUkz1miUBmhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAL/rslDWR76buDCf0MNOAIuY+C9iiGm8W3VOjx76/dUMrC3wg237Cdpn4+yUTJfG
         Huek0ohwsh1cTgjmifbSzB7+hpEZw+Rx3e1RSvpLS/CbjhgpFtuM+Q2Umx1WBwS10B
         EQuG0Ov9P+jbOcAQXTYmv3ua6MGAxaDsL+iM79v9lh9l3aneUmRMWcY/+hXlu1rMxY
         HFhuuhF405sa+gpvyxy0A7taRF3fMAisZ2sbrG32awnCxju+achI3tVOXTkDBvtN+k
         SPbG3OTlwgOTcL0zj1daet7buDAGX++pVOzmFagv4VBljziIIzFnivEF7MFj141Xwc
         DXRVylWC6kjFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mason Zhang <Mason.Zhang@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        matthias.bgg@gmail.com, beanhuo@micron.com, avri.altman@wdc.com,
        stanley.chu@mediatek.com, quic_asutoshd@quicinc.com,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 47/58] scsi: ufs: core: Fix device management cmd timeout flow
Date:   Sun, 26 Feb 2023 21:04:45 -0500
Message-Id: <20230227020457.1048737-47-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mason Zhang <Mason.Zhang@mediatek.com>

[ Upstream commit 36822124f9de200cedc2f42516301b50d386a6cd ]

In the UFS error handling flow, the host will send a device management cmd
(NOP OUT) to the device for link recovery. If this cmd times out and
clearing the doorbell fails, ufshcd_wait_for_dev_cmd() will do nothing and
return. hba->dev_cmd.complete struct is not set to NULL.

When this happens, if cmd has been completed by device, then we will call
complete() in __ufshcd_transfer_req_compl(). Because the complete struct is
allocated on the stack, the following crash will occur:

  ipanic_die+0x24/0x38 [mrdump]
  die+0x344/0x748
  arm64_notify_die+0x44/0x104
  do_debug_exception+0x104/0x1e0
  el1_dbg+0x38/0x54
  el1_sync_handler+0x40/0x88
  el1_sync+0x8c/0x140
  queued_spin_lock_slowpath+0x2e4/0x3c0
  __ufshcd_transfer_req_compl+0x3b0/0x1164
  ufshcd_trc_handler+0x15c/0x308
  ufshcd_host_reset_and_restore+0x54/0x260
  ufshcd_reset_and_restore+0x28c/0x57c
  ufshcd_err_handler+0xeb8/0x1b6c
  process_one_work+0x288/0x964
  worker_thread+0x4bc/0xc7c
  kthread+0x15c/0x264
  ret_from_fork+0x10/0x30

Link: https://lore.kernel.org/r/20221216032532.1280-1-mason.zhang@mediatek.com
Signed-off-by: Mason Zhang <Mason.Zhang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fb5c9e2fc5348..dae49530201bf 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3006,6 +3006,22 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		} else {
 			dev_err(hba->dev, "%s: failed to clear tag %d\n",
 				__func__, lrbp->task_tag);
+
+			spin_lock_irqsave(&hba->outstanding_lock, flags);
+			pending = test_bit(lrbp->task_tag,
+					   &hba->outstanding_reqs);
+			if (pending)
+				hba->dev_cmd.complete = NULL;
+			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+			if (!pending) {
+				/*
+				 * The completion handler ran while we tried to
+				 * clear the command.
+				 */
+				time_left = 1;
+				goto retry;
+			}
 		}
 	}
 
-- 
2.39.0

