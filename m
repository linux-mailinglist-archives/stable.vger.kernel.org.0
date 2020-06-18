Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621A91FE6C2
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgFRCgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgFRBN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB436221F1;
        Thu, 18 Jun 2020 01:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442837;
        bh=r+sGKsCZdJ6ItZ8zWIiODoB6JpSbLYt8qmx53pm6jdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbfnFGRP0qn5v+2EEER51ha004HaA8Eqg0X+VJCWtYFkJldX+01Vj7hlg+u9wqjNG
         BeqnrlOnKk5uS+3+hMlVJ76qfiLs/0NbjdQMmY8qQTqX1//xPbAJ81O6te5VQGW3J8
         MlLx7FKijU3dvpw0zba4lm8CgLwficXsd++G1Oow=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 271/388] RDMA/iw_cxgb4: cleanup device debugfs entries on ULD remove
Date:   Wed, 17 Jun 2020 21:06:08 -0400
Message-Id: <20200618010805.600873-271-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>

[ Upstream commit 49ea0c036ede81f126f1a9389d377999fdf5c5a1 ]

Remove device specific debugfs entries immediately if LLD detaches a
particular ULD device in case of fatal PCI errors.

Link: https://lore.kernel.org/r/20200524190814.17599-1-bharat@chelsio.com
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 599340c1f0b8..541dbcf22d0e 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -953,6 +953,7 @@ void c4iw_dealloc(struct uld_ctx *ctx)
 static void c4iw_remove(struct uld_ctx *ctx)
 {
 	pr_debug("c4iw_dev %p\n", ctx->dev);
+	debugfs_remove_recursive(ctx->dev->debugfs_root);
 	c4iw_unregister_device(ctx->dev);
 	c4iw_dealloc(ctx);
 }
-- 
2.25.1

