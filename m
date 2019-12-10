Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5410F119D8D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfLJWd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:33:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729766AbfLJWd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:33:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABCCA20836;
        Tue, 10 Dec 2019 22:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017205;
        bh=0paNQ3KtIheJ2LxxBgv2LUM89tiwChRj4J8wYO41Q68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2JDpTQoArIpq4JnHWPOLC/woo9QTPZk1b0DVOFXcJrrKZcNAQ8jjmA+YFXa75V2A
         9necBXsufCkyxHpKXch0LBP7bB+agaq5OXHcxQngMEHBdWZcxRrZg0kyvoz5uXvdbK
         VBl2Iu4cZppQ8ztmdrmhnzzvHO6aDQvZo2WMn0R4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/71] IB/iser: bound protection_sg size by data_sg size
Date:   Tue, 10 Dec 2019 17:32:12 -0500
Message-Id: <20191210223316.14988-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223316.14988-1-sashal@kernel.org>
References: <20191210223316.14988-1-sashal@kernel.org>
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
index 9080161e01af1..edb064f9f0f14 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -646,6 +646,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 		if (ib_conn->pi_support) {
 			u32 sig_caps = ib_conn->device->dev_attr.sig_prot_cap;
 
+			shost->sg_prot_tablesize = shost->sg_tablesize;
 			scsi_host_set_prot(shost, iser_dif_prot_caps(sig_caps));
 			scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP |
 						   SHOST_DIX_GUARD_CRC);
-- 
2.20.1

