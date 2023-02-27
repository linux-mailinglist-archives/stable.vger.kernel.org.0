Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4755C6A3790
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjB0CKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjB0CJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:09:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EF11BAF2;
        Sun, 26 Feb 2023 18:08:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7988060D3D;
        Mon, 27 Feb 2023 02:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC76C4339B;
        Mon, 27 Feb 2023 02:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463617;
        bh=sZ5lHAbfGMMG/fUMnuLaSimItk3k9edOwj2T4y+D9HU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ra7qxvg6oGCXHqGRIR5lDh5Qk+fX9GAj3UBbJo59q2TZhG+zyA5GKK/cAQv884eQ6
         pA9VT3xbXid+PQOmIrj91+LWwtQsGNrnFyQ5xYE5UCp0PWpwcyjQhhA4+sq/20JHwo
         HdIc2D8bs2DqN19+nElT+NIc6Gx6FLtXKGuec7uh469Kswvirh6lJta66o0PysIr2s
         WU1Z9v+EUkkDliBrEK+BEbhLGseEHFfNDp/eEgv8OMljT7gy4PS9mXi7JrTUvLJXzL
         SUY9KQWrAKjcdIORLtgOvDMd8dAB8/X9qwBoppFlOa7LoJDHxjTR66ZZDQ6G9ZRIY2
         ZVi+gsKR7+r3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     farah kassabri <fkassabri@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        ttayar@habana.ai, talcohen@habana.ai, ynudelman@habana.ai
Subject: [PATCH AUTOSEL 6.1 30/58] habanalabs: fix bug in timestamps registration code
Date:   Sun, 26 Feb 2023 21:04:28 -0500
Message-Id: <20230227020457.1048737-30-sashal@kernel.org>
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

From: farah kassabri <fkassabri@habana.ai>

[ Upstream commit ac5af9900f82b7034de7c9eb1d70d030ba325607 ]

Protect re-using the same timestamp buffer record before actually
adding it to the to interrupt wait list.
Mark ts buff offset as in use in the spinlock protection area of the
interrupt wait list to avoid getting in the re-use section in
ts_buff_get_kernel_ts_record before adding the node to the list.
this scenario might happen when multiple threads are racing on
same offset and one thread could set data in the ts buff in
ts_buff_get_kernel_ts_record then the other thread takes over
and get to ts_buff_get_kernel_ts_record and we will try
to re-use the same ts buff offset then we will try to
delete a non existing node from the list.

Signed-off-by: farah kassabri <fkassabri@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../habanalabs/common/command_submission.c    | 33 ++++++++++++-------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/habanalabs/common/command_submission.c b/drivers/misc/habanalabs/common/command_submission.c
index fa05770865c65..1071bf492e423 100644
--- a/drivers/misc/habanalabs/common/command_submission.c
+++ b/drivers/misc/habanalabs/common/command_submission.c
@@ -3091,19 +3091,18 @@ static int ts_buff_get_kernel_ts_record(struct hl_mmap_mem_buf *buf,
 			goto start_over;
 		}
 	} else {
+		/* Fill up the new registration node info */
+		requested_offset_record->ts_reg_info.buf = buf;
+		requested_offset_record->ts_reg_info.cq_cb = cq_cb;
+		requested_offset_record->ts_reg_info.timestamp_kernel_addr =
+				(u64 *) ts_buff->user_buff_address + ts_offset;
+		requested_offset_record->cq_kernel_addr =
+				(u64 *) cq_cb->kernel_address + cq_offset;
+		requested_offset_record->cq_target_value = target_value;
+
 		spin_unlock_irqrestore(wait_list_lock, flags);
 	}
 
-	/* Fill up the new registration node info */
-	requested_offset_record->ts_reg_info.in_use = 1;
-	requested_offset_record->ts_reg_info.buf = buf;
-	requested_offset_record->ts_reg_info.cq_cb = cq_cb;
-	requested_offset_record->ts_reg_info.timestamp_kernel_addr =
-			(u64 *) ts_buff->user_buff_address + ts_offset;
-	requested_offset_record->cq_kernel_addr =
-			(u64 *) cq_cb->kernel_address + cq_offset;
-	requested_offset_record->cq_target_value = target_value;
-
 	*pend = requested_offset_record;
 
 	dev_dbg(buf->mmg->dev, "Found available node in TS kernel CB %p\n",
@@ -3151,7 +3150,7 @@ static int _hl_interrupt_wait_ioctl(struct hl_device *hdev, struct hl_ctx *ctx,
 			goto put_cq_cb;
 		}
 
-		/* Find first available record */
+		/* get ts buffer record */
 		rc = ts_buff_get_kernel_ts_record(buf, cq_cb, ts_offset,
 						cq_counters_offset, target_value,
 						&interrupt->wait_list_lock, &pend);
@@ -3199,7 +3198,19 @@ static int _hl_interrupt_wait_ioctl(struct hl_device *hdev, struct hl_ctx *ctx,
 	 * Note that we cannot have sorted list by target value,
 	 * in order to shorten the list pass loop, since
 	 * same list could have nodes for different cq counter handle.
+	 * Note:
+	 * Mark ts buff offset as in use here in the spinlock protection area
+	 * to avoid getting in the re-use section in ts_buff_get_kernel_ts_record
+	 * before adding the node to the list. this scenario might happen when
+	 * multiple threads are racing on same offset and one thread could
+	 * set the ts buff in ts_buff_get_kernel_ts_record then the other thread
+	 * takes over and get to ts_buff_get_kernel_ts_record and then we will try
+	 * to re-use the same ts buff offset, and will try to delete a non existing
+	 * node from the list.
 	 */
+	if (register_ts_record)
+		pend->ts_reg_info.in_use = 1;
+
 	list_add_tail(&pend->wait_list_node, &interrupt->wait_list_head);
 	spin_unlock_irqrestore(&interrupt->wait_list_lock, flags);
 
-- 
2.39.0

