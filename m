Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A3F13FFD0
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390051AbgAPXWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733030AbgAPXWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72A162072E;
        Thu, 16 Jan 2020 23:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216956;
        bh=D2JDALk0Xq3IA0lFatgD2Tnhdb9kJsSbsj1r7YIGito=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sy+ZiIKDqAZHMq4pjsmUzD/unHM9HKHuyZbLUqbFvh3YXaZIe8XvRHtzfGRyb3YOm
         WKfaUhK0LxEeoCaMz9vvnQyZwbNvKvd0wj4SY0O7l2r5AZY/jXDpCppLGyPTzrKyHa
         bhBsiIoEraZBKItAqGsQjeScJy8uORPb/JfeN2sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangyang Li <liyangyang20@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 073/203] RDMA/hns: Bugfix for qpc/cqc timer configuration
Date:   Fri, 17 Jan 2020 00:16:30 +0100
Message-Id: <20200116231750.543451509@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

commit 887803db866a7a4e1817a3cb8a3eee4e9879fed2 upstream.

qpc/cqc timer entry size needs one page, but currently they are fixedly
configured to 4096, which is not appropriate in 64K page scenarios. So
they should be modified to PAGE_SIZE.

Fixes: 0e40dc2f70cd ("RDMA/hns: Add timer allocation support for hip08")
Link: https://lore.kernel.org/r/1571908917-16220-3-git-send-email-liweihang@hisilicon.com
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -87,8 +87,8 @@
 #define HNS_ROCE_V2_MTT_ENTRY_SZ		64
 #define HNS_ROCE_V2_CQE_ENTRY_SIZE		32
 #define HNS_ROCE_V2_SCCC_ENTRY_SZ		32
-#define HNS_ROCE_V2_QPC_TIMER_ENTRY_SZ		4096
-#define HNS_ROCE_V2_CQC_TIMER_ENTRY_SZ		4096
+#define HNS_ROCE_V2_QPC_TIMER_ENTRY_SZ		PAGE_SIZE
+#define HNS_ROCE_V2_CQC_TIMER_ENTRY_SZ		PAGE_SIZE
 #define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFFF000
 #define HNS_ROCE_V2_MAX_INNER_MTPT_NUM		2
 #define HNS_ROCE_INVALID_LKEY			0x100


