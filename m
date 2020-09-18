Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9EA26EE86
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgIRC3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbgIRCPK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:15:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AD32238E6;
        Fri, 18 Sep 2020 02:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395310;
        bh=IMqgfg1I+JZ+Db7k4qTX1k8eQKQ+wMBHtVjAinua6Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbezRxYsp4g2h/gVn7C7nQ4+/1FySTx8t2y4ZY9ximV2X5Cyj1eCfy/ahdaKhJcnG
         0BqydnAmbWRhxUQovWp98An4d4ad/K9oPJMvSB6mLE+BQ3g4UWtZLrecYj/O+YjVX3
         5ju0XK5XB3a/0mI/QS1paTJ2IFIr2hBYYMFfHd0k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/90] RDMA/i40iw: Fix potential use after free
Date:   Thu, 17 Sep 2020 22:13:37 -0400
Message-Id: <20200918021455.2067301-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit da046d5f895fca18d63b15ac8faebd5bf784e23a ]

Release variable dst after logging dst->error to avoid possible use after
free.

Link: https://lore.kernel.org/r/1573022651-37171-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 282a726351c81..ce1a4817ab923 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -2036,9 +2036,9 @@ static int i40iw_addr_resolve_neigh_ipv6(struct i40iw_device *iwdev,
 	dst = i40iw_get_dst_ipv6(&src_addr, &dst_addr);
 	if (!dst || dst->error) {
 		if (dst) {
-			dst_release(dst);
 			i40iw_pr_err("ip6_route_output returned dst->error = %d\n",
 				     dst->error);
+			dst_release(dst);
 		}
 		return rc;
 	}
-- 
2.25.1

