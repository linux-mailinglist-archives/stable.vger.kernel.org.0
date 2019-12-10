Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108141196AC
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfLJVKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbfLJVKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C20C246A8;
        Tue, 10 Dec 2019 21:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012223;
        bh=LNb5tT2SBnK5bHgP1NX43CYoSjrTbdSaem5o9Bb6YFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kljyK0wLEImGhSOPSglDMn/2rvAL2QKUDAPpmzfhJanOkt91Y+rHjFjr8g2eyn2DL
         OyWynW6L5LbDNIZ71bWbnjY3mUBI540TlJCqfoYV56KzuM+fPNnM6+W/oJd8fC30EX
         kSlRpfJ2dYdNsOsG5ktDMAX9V+66LO03jMEWpkpM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 173/350] RDMA/qedr: Fix srqs xarray initialization
Date:   Tue, 10 Dec 2019 16:04:38 -0500
Message-Id: <20191210210735.9077-134-sashal@kernel.org>
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

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 73ab512f720298aabe23b34110e3f6a8545b0ba5 ]

There was a missing initialization for the srqs xarray.
SRQs xarray can also be called from irq context when searching
for an element and uses the xa_XXX_irq apis, therefore should
be initialized with IRQ flags.

Fixes: 9fd15987ed27 ("qedr: Convert srqidr to XArray")
Link: https://lore.kernel.org/r/20191027200451.28187-2-michal.kalderon@marvell.com
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index dc71b6e16a07f..b462eaca1ee3c 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -357,6 +357,7 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 		return -ENOMEM;
 
 	spin_lock_init(&dev->sgid_lock);
+	xa_init_flags(&dev->srqs, XA_FLAGS_LOCK_IRQ);
 
 	if (IS_IWARP(dev)) {
 		xa_init_flags(&dev->qps, XA_FLAGS_LOCK_IRQ);
-- 
2.20.1

