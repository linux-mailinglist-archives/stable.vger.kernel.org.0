Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3542711964F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfLJV0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:26:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbfLJVZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:25:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2917020836;
        Tue, 10 Dec 2019 21:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013141;
        bh=pFS7/13JJX6dO6lO1moac4r+EqYfl0x/LCkLPyn44F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwhAXtJa6KWw/XyFMap3oikMC2KgQKdTrFxRvCYKQW9Zw96/KjaSmZiQyEUDU6Cfr
         AMlHHTupMJeyv+rfHVlDfPzFOAaD77HaaH/bFUXdBmtc7CgYVNT8Cznp+WB37SFShq
         KqTflBQStgimyKtHwL/pvqvwhbZz1RoUiuM9QlXc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 025/292] IB/iser: bound protection_sg size by data_sg size
Date:   Tue, 10 Dec 2019 16:20:44 -0500
Message-Id: <20191210212511.11392-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210212511.11392-1-sashal@kernel.org>
References: <20191210212511.11392-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

[ Upstream commit 7718cf03c3ce4b6ebd90107643ccd01c952a1fce ]

In case we don't set the sg_prot_tablesize, the scsi layer assign the
default size (65535 entries). We should limit this size since we should
take into consideration the underlaying device capability. This cap is
considered when calculating the sg_tablesize. Otherwise, for example,
we can get that /sys/block/sdb/queue/max_segments is 128 and
/sys/block/sdb/queue/max_integrity_segments is 65535.

Link: https://lore.kernel.org/r/1569359027-10987-1-git-send-email-maxg@mellanox.com
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 2e72fc5af1573..c4c015c604465 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -646,6 +646,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 		if (ib_conn->pi_support) {
 			u32 sig_caps = ib_dev->attrs.sig_prot_cap;
 
+			shost->sg_prot_tablesize = shost->sg_tablesize;
 			scsi_host_set_prot(shost, iser_dif_prot_caps(sig_caps));
 			scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP |
 						   SHOST_DIX_GUARD_CRC);
-- 
2.20.1

