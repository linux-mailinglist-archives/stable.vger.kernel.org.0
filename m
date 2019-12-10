Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A85B11942B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbfLJVNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbfLJVNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3020020838;
        Tue, 10 Dec 2019 21:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012431;
        bh=NvVxvSIMbRFIn8DTwS2PrikjHm61ZD9bX1FQlBWdU4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZL9TMrfQfXD2/jOp+ypi+tjXYvzOE6KSgc4qqwzPCXICs1JICuW4rfcJvInWUYLqp
         ovLy2GOa031IsuEtcfsOVajPU9xXaCnOo3tbEMmV/sxkyKRjRlPOgYRHcRRVsgObB/
         o3VmQTrkjukTQVG/gMB2jaNpaCsmqdp+SXeUYp70=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Devesh Sharma <devesh.sharma@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 345/350] RDMA/bnxt_re: Fix stat push into dma buffer on gen p5 devices
Date:   Tue, 10 Dec 2019 16:07:30 -0500
Message-Id: <20191210210735.9077-306-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Devesh Sharma <devesh.sharma@broadcom.com>

[ Upstream commit 98998ffe5216c7fa2c0225bb5b049ca5cdf8d195 ]

Due to recent advances in the firmware for Broadcom's gen p5 series of
adaptors the driver code to report hardware counters has been broken
w.r.t. roce devices.

The new firmware command expects dma length to be specified during stat
dma buffer allocation.

Fixes: 2792b5b95ed5 ("bnxt_en: Update firmware interface spec. to 1.10.0.89.")
Link: https://lore.kernel.org/r/1574317343-23300-3-git-send-email-devesh.sharma@broadcom.com
Signed-off-by: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index b31e215882004..27e2df44d043d 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -477,6 +477,7 @@ static int bnxt_re_net_stats_ctx_alloc(struct bnxt_re_dev *rdev,
 	bnxt_re_init_hwrm_hdr(rdev, (void *)&req, HWRM_STAT_CTX_ALLOC, -1, -1);
 	req.update_period_ms = cpu_to_le32(1000);
 	req.stats_dma_addr = cpu_to_le64(dma_map);
+	req.stats_dma_length = cpu_to_le16(sizeof(struct ctx_hw_stats_ext));
 	req.stat_ctx_flags = STAT_CTX_ALLOC_REQ_STAT_CTX_FLAGS_ROCE;
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-- 
2.20.1

