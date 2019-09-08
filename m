Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD888ACE28
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732970AbfIHMyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732982AbfIHMwT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:52:19 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0D312082C;
        Sun,  8 Sep 2019 12:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947139;
        bh=FO5gHr8dnNSQ2RU2dbqQBpuvGlmBQpI/J/6PWMXIbSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oj0vFf/XmodhqWBMW3g/JCArlY8Kw9RkJYhpxmkYDqq98lfVe7Dx3NrdZr1MoUNpo
         ZShq6uVCXDR0xi9RHlLTzxA/gztezmhs9XevUTkY/EP4hCC0JBz0qfns/naznsTM3E
         bMetpQL0zshA1Aek1fSvcYWo1O9f584j+TIZUf7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Leon Romanovsky <leonro@mellanox.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 76/94] infiniband: hfi1: fix memory leaks
Date:   Sun,  8 Sep 2019 13:42:12 +0100
Message-Id: <20190908121152.614020707@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 814324d172950..986c12153e62e 100644
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



