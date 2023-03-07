Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1678B6AF135
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjCGSlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjCGSlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:41:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906879BE3F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:31:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 891DEB819D1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EFFC433EF;
        Tue,  7 Mar 2023 18:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213786;
        bh=eJ0KK2OL+MuxD1Lnj5hX6avptKE0b8cOWC1wU9tD2L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwFRUvrSMgltbTMlXPpceJpqfR0kUg/0LQGndXbIuvCPbXlb/6VROHxcq72GgWVhc
         N/2UBjOdNM3n01XbQMNYXYoq2b2EihzmZdP6C64NDMXMSy56stN46fBjgJmNTJ7mA0
         6Na3ViN9fUpntziS4OSt8g85Cv2dcWTjgH0TStu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, farah kassabri <fkassabri@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 619/885] habanalabs: fix bug in timestamps registration code
Date:   Tue,  7 Mar 2023 17:59:13 +0100
Message-Id: <20230307170029.162269685@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
2.39.2



