Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C196AEBD0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjCGRtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjCGRsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:48:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C398088896
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:43:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7D1EB818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A8AC433D2;
        Tue,  7 Mar 2023 17:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210974;
        bh=IBCkHIpZeDJTFn+mUBCsEZmhHXCuKQdybjKciyxdnaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlaPr4AcfnnXhsp0wVa15+oLH7E52Ed2iVOe58tT0tTLQ1NWnZOnu8Mug2NfB/wwb
         7hnBJeAl6BmzxUwxDJuydlUjIVYV1oao0riisWjp31PZ4ucoF3ZSeNlWAFud7/eca8
         UYL6Pgf/8IjGcFrMsgMckKI5hixG9x2gqYL28jO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, farah kassabri <fkassabri@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0714/1001] habanalabs: fix bug in timestamps registration code
Date:   Tue,  7 Mar 2023 17:58:06 +0100
Message-Id: <20230307170052.629973856@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index ea0e5101c10ed..6367cbea4ca2a 100644
--- a/drivers/misc/habanalabs/common/command_submission.c
+++ b/drivers/misc/habanalabs/common/command_submission.c
@@ -3119,19 +3119,18 @@ static int ts_buff_get_kernel_ts_record(struct hl_mmap_mem_buf *buf,
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
@@ -3179,7 +3178,7 @@ static int _hl_interrupt_wait_ioctl(struct hl_device *hdev, struct hl_ctx *ctx,
 			goto put_cq_cb;
 		}
 
-		/* Find first available record */
+		/* get ts buffer record */
 		rc = ts_buff_get_kernel_ts_record(buf, cq_cb, ts_offset,
 						cq_counters_offset, target_value,
 						&interrupt->wait_list_lock, &pend);
@@ -3227,7 +3226,19 @@ static int _hl_interrupt_wait_ioctl(struct hl_device *hdev, struct hl_ctx *ctx,
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
2.39.2



