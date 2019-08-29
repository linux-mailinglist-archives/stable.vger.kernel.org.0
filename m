Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EB1A247F
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfH2SXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729825AbfH2SQl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:16:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D995233FF;
        Thu, 29 Aug 2019 18:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102600;
        bh=ZMYfwV9pRcY90yyM8n7BaLjvLIpcsobYXfb7dZJOOlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlnXDfCLb9sgAQGiCfqeKE1NTDSxFVvcnlu1yz+TLXCqRx8o2T2q3EXTnf6P0VVfQ
         ZnKfPBik6+ArpKgpakhGsMi+hlox1rMnehe5wpWQ4HPnFOWCh8wk1t/0U8eJ4WMtVF
         EmVH4wcns/8u+r8cZlKp5f6eOsOV4koG4I0jnmGQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Leon Romanovsky <leonro@mellanox.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 36/45] infiniband: hfi1: fix a memory leak bug
Date:   Thu, 29 Aug 2019 14:15:36 -0400
Message-Id: <20190829181547.8280-36-sashal@kernel.org>
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

[ Upstream commit b08afa064c320e5d85cdc27228426b696c4c8dae ]

In fault_opcodes_read(), 'data' is not deallocated if debugfs_file_get()
fails, leading to a memory leak. To fix this bug, introduce the 'free_data'
label to free 'data' before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Link: https://lore.kernel.org/r/1566156571-4335-1-git-send-email-wenwen@cs.uga.edu
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/fault.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/fault.c b/drivers/infiniband/hw/hfi1/fault.c
index 7eaff4dcbfd77..72ca0dc5f3b59 100644
--- a/drivers/infiniband/hw/hfi1/fault.c
+++ b/drivers/infiniband/hw/hfi1/fault.c
@@ -214,7 +214,7 @@ static ssize_t fault_opcodes_read(struct file *file, char __user *buf,
 		return -ENOMEM;
 	ret = debugfs_file_get(file->f_path.dentry);
 	if (unlikely(ret))
-		return ret;
+		goto free_data;
 	bit = find_first_bit(fault->opcodes, bitsize);
 	while (bit < bitsize) {
 		zero = find_next_zero_bit(fault->opcodes, bitsize, bit);
@@ -232,6 +232,7 @@ static ssize_t fault_opcodes_read(struct file *file, char __user *buf,
 	data[size - 1] = '\n';
 	data[size] = '\0';
 	ret = simple_read_from_buffer(buf, len, pos, data, size);
+free_data:
 	kfree(data);
 	return ret;
 }
-- 
2.20.1

