Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922CE12C7FA
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731627AbfL2RtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:49:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731624AbfL2RtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD28021D7E;
        Sun, 29 Dec 2019 17:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641761;
        bh=IIvtXK4zljKP9WSSZCo7XgAgIVI9zg8nm3j28BEUGsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6ekKA4zEA2QG0Xf1q8oxOabjTzLbDQRJYn2SmmDW9ar5wUGgbX7OBaTIhuibUM6t
         f406G7eHdkEbIZriQtbt9ufCqnvDxOQC9WThe0C+/0XLPe+r76oYk4b+ClDd/g20XF
         NT9iclnmtak1sKNFA6RurjPQiqMby/bpmr8rd+Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 201/434] RDMA/qedr: Fix srqs xarray initialization
Date:   Sun, 29 Dec 2019 18:24:14 +0100
Message-Id: <20191229172715.180533685@linuxfoundation.org>
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
index dc71b6e16a07..b462eaca1ee3 100644
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



