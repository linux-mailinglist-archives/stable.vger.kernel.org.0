Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BFB592223
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241430AbiHNPoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241078AbiHNPmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:42:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C751C139;
        Sun, 14 Aug 2022 08:33:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4900260BC9;
        Sun, 14 Aug 2022 15:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A655C433B5;
        Sun, 14 Aug 2022 15:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491221;
        bh=Qv6ZPkimk60J/z99QV34gPcNVKVWvbzTNrs91mDfqTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUcn1LTGw7IKAR8ey2lOlcbcOndz7MZKbQmuy1CUUTccTXoVKnyPbLiaTxjD+WKPT
         C9qm5vn2sfka972L4HoOkU8fftqarJksVEtOWNWky0no40zz2OmQ7iFVunl7q/+NA2
         guqDTOqrDSKHSrMFwJ/Z4zXzSApZyzephxaU4YS1SjO4if9kDhyq3npmVmTFgPW952
         cQfx88L20iqpXW9zRiD8d753wrIuFE/JYwmYn/adorIif3QnIkJY6tbVjOmKtaCSbq
         KVZQHyXunD9+9gIn2lubQGhf7cLGmLuhKk2gQPXIJHrfHDnk6UhFf20CU5iUBPZza+
         xF7c73jXzt98g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        osharabi@habana.ai, ttayar@habana.ai, ynudelman@habana.ai,
        dliberman@habana.ai, fkassabri@habana.ai, dhirschfeld@habana.ai
Subject: [PATCH AUTOSEL 5.15 25/46] habanalabs/gaudi: fix shift out of bounds
Date:   Sun, 14 Aug 2022 11:32:26 -0400
Message-Id: <20220814153247.2378312-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit 01622098aeb05a5efbb727199bbc2a4653393255 ]

When validating NIC queues, queue offset calculation must be
performed only for NIC queues.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 14da87b38e83..801acab048eb 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -5744,15 +5744,17 @@ static int gaudi_parse_cb_no_ext_queue(struct hl_device *hdev,
 {
 	struct asic_fixed_properties *asic_prop = &hdev->asic_prop;
 	struct gaudi_device *gaudi = hdev->asic_specific;
-	u32 nic_mask_q_id = 1 << (HW_CAP_NIC_SHIFT +
-		((parser->hw_queue_id - GAUDI_QUEUE_ID_NIC_0_0) >> 2));
+	u32 nic_queue_offset, nic_mask_q_id;
 
 	if ((parser->hw_queue_id >= GAUDI_QUEUE_ID_NIC_0_0) &&
-			(parser->hw_queue_id <= GAUDI_QUEUE_ID_NIC_9_3) &&
-			(!(gaudi->hw_cap_initialized & nic_mask_q_id))) {
-		dev_err(hdev->dev, "h/w queue %d is disabled\n",
-				parser->hw_queue_id);
-		return -EINVAL;
+			(parser->hw_queue_id <= GAUDI_QUEUE_ID_NIC_9_3)) {
+		nic_queue_offset = parser->hw_queue_id - GAUDI_QUEUE_ID_NIC_0_0;
+		nic_mask_q_id = 1 << (HW_CAP_NIC_SHIFT + (nic_queue_offset >> 2));
+
+		if (!(gaudi->hw_cap_initialized & nic_mask_q_id)) {
+			dev_err(hdev->dev, "h/w queue %d is disabled\n", parser->hw_queue_id);
+			return -EINVAL;
+		}
 	}
 
 	/* For internal queue jobs just check if CB address is valid */
-- 
2.35.1

