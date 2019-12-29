Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15BCF12C880
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732924AbfL2Rzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:55:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732940AbfL2Rzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:55:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1463421744;
        Sun, 29 Dec 2019 17:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642134;
        bh=S8SlpLr8wUiokgeBTGg+8fyV1PcseT48fnzXqTlIk3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iD7V4SA/0Q0B7Hw5P3V5z68bNO5RigzwQmPynybyCpmUSOy2xFsqY7EEh4tzjYHrz
         ZBDgs6QYNiUCIvOJz4s0T2zaNcEIsYakQ826ixao7Bhi6RnsHUrCTEoyAHI5Wl4AM0
         A71jmBYDnhqADpOqVKdYNeYt1WvWkj/vhswNvHds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Devesh Sharma <devesh.sharma@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 355/434] RDMA/bnxt_re: Fix stat push into dma buffer on gen p5 devices
Date:   Sun, 29 Dec 2019 18:26:48 +0100
Message-Id: <20191229172725.550694083@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b31e21588200..27e2df44d043 100644
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



