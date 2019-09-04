Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AE6A8CC9
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731741AbfIDQRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732190AbfIDP7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F88A2339D;
        Wed,  4 Sep 2019 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612742;
        bh=5NgFewY6WF0/ll0jM4pfbCuhJk4jlxUU9PS5C1LOheg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGR986PhLclZx3vrvxk6NBv2pNyN8TqZsqPvk5/h3nmVZO7d4wuV+EuLKbdY0EsCY
         +us7kvCEgHbbGHWpaCTXxQFXLfG25KJdx4MOc2jIePsZ4DKGduadgRCrTr5A32ClDT
         ZTjEKhwn07j4cjNDD2c1ePOdIqCoiFia2NK+/7eM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 55/94] NFS: remove set but not used variable 'mapping'
Date:   Wed,  4 Sep 2019 11:57:00 -0400
Message-Id: <20190904155739.2816-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 99300a85260c2b7febd57082a617d1062532067e ]

Fixes gcc '-Wunused-but-set-variable' warning:

fs/nfs/write.c: In function nfs_page_async_flush:
fs/nfs/write.c:609:24: warning: variable mapping set but not used [-Wunused-but-set-variable]

It is not use since commit aefb623c422e ("NFS: Fix
writepage(s) error handling to not report errors twice")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 0d6d7beb85053..ee6932c9819e0 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -606,7 +606,6 @@ static void nfs_write_error(struct nfs_page *req, int error)
 static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
 				struct page *page)
 {
-	struct address_space *mapping;
 	struct nfs_page *req;
 	int ret = 0;
 
@@ -621,7 +620,6 @@ static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
 	WARN_ON_ONCE(test_bit(PG_CLEAN, &req->wb_flags));
 
 	/* If there is a fatal error that covers this write, just exit */
-	mapping = page_file_mapping(page);
 	ret = pgio->pg_error;
 	if (nfs_error_is_fatal_on_server(ret))
 		goto out_launder;
-- 
2.20.1

