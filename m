Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D36272D8C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgIUQlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729405AbgIUQlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:41:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DB67235F9;
        Mon, 21 Sep 2020 16:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706463;
        bh=CAMmbCG2+8lt7wmTtJgX9Y/v4gO4n2z2qtNG6PrPVBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMKLuq545ZhGsBWHBBgkVSOejjrCm4QuMJj3S8tnwaHrZJ1wVrMClGXZxIlUWfBDn
         VKJrlTEOzt2NYjaK+L7ZXVeBFJkXDODGAe6PMd8nCzgovYWc98EwZNm3l/Ellsr0mx
         aE0KJsoSRspC7yiRMbK09eGtbrCnZpmVPdWsTKcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.19 06/49] RDMA/bnxt_re: Restrict the max_gids to 256
Date:   Mon, 21 Sep 2020 18:27:50 +0200
Message-Id: <20200921162034.945079334@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>

commit 847b97887ed4569968d5b9a740f2334abca9f99a upstream.

Some adapters report more than 256 gid entries. Restrict it to 256 for
now.

Fixes: 1ac5a4047975("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://lore.kernel.org/r/1598292876-26529-6-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c |    2 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -141,7 +141,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_
 	attr->max_inline_data = le32_to_cpu(sb->max_inline_data);
 	attr->l2_db_size = (sb->l2_db_space_size + 1) *
 			    (0x01 << RCFW_DBR_BASE_PAGE_SHIFT);
-	attr->max_sgid = le32_to_cpu(sb->max_gid);
+	attr->max_sgid = BNXT_QPLIB_NUM_GIDS_SUPPORTED;
 
 	bnxt_qplib_query_version(rcfw, attr->fw_ver);
 
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -47,6 +47,7 @@
 struct bnxt_qplib_dev_attr {
 #define FW_VER_ARR_LEN			4
 	u8				fw_ver[FW_VER_ARR_LEN];
+#define BNXT_QPLIB_NUM_GIDS_SUPPORTED	256
 	u16				max_sgid;
 	u16				max_mrw;
 	u32				max_qp;


