Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428881A5A23
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgDKXlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbgDKXHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:07:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56CEE216FD;
        Sat, 11 Apr 2020 23:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646433;
        bh=sGcawhSCorjKNqb+a3+qFPoK9A8AmdvKn3bP+dfMO2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6aiFXP7NxfrP/8pMnaOTXWrlr/35MPpp9NETjbeQRT3K5kLroJKgBRfMazPxNTGF
         KC9nlDfhHkXR5jlAiJbVAm9GJU/J7Zqf5E+8CI2dj9cHvOQ1jK7MsVJ++x3ezwlS7m
         Wjhs9D/84ngPFv6SCS1Wi6cyU4ZKjpZVyNgTMVYU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhu Yanjun <yanjunz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 005/121] RDMA/rxe: Set sys_image_guid to be aligned with HW IB devices
Date:   Sat, 11 Apr 2020 19:05:10 -0400
Message-Id: <20200411230706.23855-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Yanjun <yanjunz@mellanox.com>

[ Upstream commit d0ca2c35dd15a3d989955caec02beea02f735ee6 ]

The RXE driver doesn't set sys_image_guid and user space applications see
zeros. This causes to pyverbs tests to fail with the following traceback,
because the IBTA spec requires to have valid sys_image_guid.

 Traceback (most recent call last):
   File "./tests/test_device.py", line 51, in test_query_device
     self.verify_device_attr(attr)
   File "./tests/test_device.py", line 74, in verify_device_attr
     assert attr.sys_image_guid != 0

In order to fix it, set sys_image_guid to be equal to node_guid.

Before:
 5: rxe0: ... node_guid 5054:00ff:feaa:5363 sys_image_guid
 0000:0000:0000:0000

After:
 5: rxe0: ... node_guid 5054:00ff:feaa:5363 sys_image_guid
 5054:00ff:feaa:5363

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20200323112800.1444784-1-leon@kernel.org
Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 0946a301a5c5d..4afdd2e208839 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -103,6 +103,8 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
 	rxe->attr.max_fast_reg_page_list_len	= RXE_MAX_FMR_PAGE_LIST_LEN;
 	rxe->attr.max_pkeys			= RXE_MAX_PKEYS;
 	rxe->attr.local_ca_ack_delay		= RXE_LOCAL_CA_ACK_DELAY;
+	addrconf_addr_eui48((unsigned char *)&rxe->attr.sys_image_guid,
+			rxe->ndev->dev_addr);
 
 	rxe->max_ucontext			= RXE_MAX_UCONTEXT;
 }
-- 
2.20.1

