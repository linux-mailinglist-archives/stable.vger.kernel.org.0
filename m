Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB394A2481
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfH2SXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729833AbfH2SQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:16:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEE8523427;
        Thu, 29 Aug 2019 18:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102601;
        bh=l7jXH8gR18nTmlsizaS9Q9kMpe14K8OqTs5d/CXTuJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOErJr7Sj5PD4KxfrelZpPqdBIKG4ehomWyiP1wQ9eUvKW6tUX6NtHKfwxbYHl4yS
         ezZxSsunDiLkSFxcJHOAQI9EoaHzHTXXmtagAw+L/TJctmoZ6to1UxbZj8uU/4LGEW
         XhMvCjd1VAbLFD0ODbPp8hvK2Xm/DY45dHSWlJ/c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Leon Romanovsky <leonro@mellanox.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 37/45] infiniband: hfi1: fix memory leaks
Date:   Thu, 29 Aug 2019 14:15:37 -0400
Message-Id: <20190829181547.8280-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181547.8280-1-sashal@kernel.org>
References: <20190829181547.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 2323d7baab2b18d87d9bc267452e387aa9f0060a ]

In fault_opcodes_write(), 'data' is allocated through kcalloc(). However,
it is not deallocated in the following execution if an error occurs,
leading to memory leaks. To fix this issue, introduce the 'free_data' label
to free 'data' before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Link: https://lore.kernel.org/r/1566154486-3713-1-git-send-email-wenwen@cs.uga.edu
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/fault.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/fault.c b/drivers/infiniband/hw/hfi1/fault.c
index 72ca0dc5f3b59..5bc811b7e6cf9 100644
--- a/drivers/infiniband/hw/hfi1/fault.c
+++ b/drivers/infiniband/hw/hfi1/fault.c
@@ -141,12 +141,14 @@ static ssize_t fault_opcodes_write(struct file *file, const char __user *buf,
 	if (!data)
 		return -ENOMEM;
 	copy = min(len, datalen - 1);
-	if (copy_from_user(data, buf, copy))
-		return -EFAULT;
+	if (copy_from_user(data, buf, copy)) {
+		ret = -EFAULT;
+		goto free_data;
+	}
 
 	ret = debugfs_file_get(file->f_path.dentry);
 	if (unlikely(ret))
-		return ret;
+		goto free_data;
 	ptr = data;
 	token = ptr;
 	for (ptr = data; *ptr; ptr = end + 1, token = ptr) {
@@ -195,6 +197,7 @@ static ssize_t fault_opcodes_write(struct file *file, const char __user *buf,
 	ret = len;
 
 	debugfs_file_put(file->f_path.dentry);
+free_data:
 	kfree(data);
 	return ret;
 }
-- 
2.20.1

