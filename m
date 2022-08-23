Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B82E59DB60
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352707AbiHWKNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353402AbiHWKL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:11:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E387F094;
        Tue, 23 Aug 2022 01:56:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C4FEB81C3E;
        Tue, 23 Aug 2022 08:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F00CC433D6;
        Tue, 23 Aug 2022 08:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244999;
        bh=Qv6ZPkimk60J/z99QV34gPcNVKVWvbzTNrs91mDfqTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITZ5Agz8P9NiqzZ9GZBfO01aYHqx8fHjuUyUFEAy5prxYVBF8FrGPmFCqIKkRgeGe
         /fR7Ge4vLtQIOur2xbjvSBx5hJ1DNSm+pakQ7F5HiToC+92q0FVb4MlKhpy6NpGF93
         MZqoIAtXnoRBwb3b5IkrYN61d1rPEmMDb4wHwJg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/244] habanalabs/gaudi: fix shift out of bounds
Date:   Tue, 23 Aug 2022 10:25:45 +0200
Message-Id: <20220823080105.561121637@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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



