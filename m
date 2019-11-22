Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B7110651D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfKVGVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:21:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:57818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbfKVFwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F185320721;
        Fri, 22 Nov 2019 05:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401934;
        bh=aSTWXn1mXOhWQyL0OsDJGPKyYnCAWp191htXRIztyUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkVuvFNMf0PHy5ioMXucrM4EgCzpOfSXH32iDLVPclun7ixOzg6Q8ysA/xFycXTSB
         5H65I4hc4Meobuh9G5nLtoeswZl06YMQB1tCS8xyJml0xn4kz6iIX9ElJkWOWHmqOJ
         9fqE4421XvmHqFhEJ6tdPQOxANWC0tzR8t1/pouM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 160/219] infiniband: bnxt_re: qplib: Check the return value of send_message
Date:   Fri, 22 Nov 2019 00:48:12 -0500
Message-Id: <20191122054911.1750-153-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 94edd87a1c59f3efa6fdf4e98d6d492e6cec6173 ]

In bnxt_qplib_map_tc2cos(), bnxt_qplib_rcfw_send_message() can return an
error value but it is lost. Propagate this error to the callers.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Acked-By: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 4097f3fa25c5f..09e7d3dd30553 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -775,9 +775,8 @@ int bnxt_qplib_map_tc2cos(struct bnxt_qplib_res *res, u16 *cids)
 	req.cos0 = cpu_to_le16(cids[0]);
 	req.cos1 = cpu_to_le16(cids[1]);
 
-	bnxt_qplib_rcfw_send_message(rcfw, (void *)&req, (void *)&resp, NULL,
-				     0);
-	return 0;
+	return bnxt_qplib_rcfw_send_message(rcfw, (void *)&req, (void *)&resp,
+						NULL, 0);
 }
 
 int bnxt_qplib_get_roce_stats(struct bnxt_qplib_rcfw *rcfw,
-- 
2.20.1

