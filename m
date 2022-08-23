Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABAD259D8DE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243401AbiHWJOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348506AbiHWJMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:12:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EAD86C33;
        Tue, 23 Aug 2022 01:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF1E0614BC;
        Tue, 23 Aug 2022 08:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE261C433D6;
        Tue, 23 Aug 2022 08:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243479;
        bh=epSUldJ7qZaSa/KN4cH2lvf0JxykKV7qMCXgRU+QuaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0l7i63AkSN42453pTLeDfJFTBngHltKBNV9+I9omEU4VpmjsA+QyuVpCYhvSQ7hL
         gDuo2R1lcZHhZDF9EIvQtPK67cxvGPoK168beIlCOvRX6zmWW/Bh64lSdpiL+36zi7
         ZcftaY1vLSXDaJnxeCtQsJ3fTq63MAvhR2OEJ8kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 290/365] habanalabs/gaudi: fix shift out of bounds
Date:   Tue, 23 Aug 2022 10:03:11 +0200
Message-Id: <20220823080130.342666788@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index e6bfaf55c6b6..3fb221f2e393 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -5654,15 +5654,17 @@ static int gaudi_parse_cb_no_ext_queue(struct hl_device *hdev,
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



