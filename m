Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713D2ACDEB
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbfIHMs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731027AbfIHMs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:48:28 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B38E8218AC;
        Sun,  8 Sep 2019 12:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946907;
        bh=xk3vxclXRVEDM55Kf+2Kthrd3peq97DDf0Qu8/tVHHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jscpywP7GGEzA0HyKjz6UzlY6Z1LU5OUJTlSnd890pdczFF/ZZn/om4sFMMpBthY
         c7IXdIqVxQuvq6DJ7uFmEKUYthDKCusn3lHTGzRccsUN6BfakY6NZg8+CILM8HIZbK
         kbPmCDuKPVJrjTKC4WYHar5SHeHsiYjRQfvU8Fss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Leon Romanovsky <leonro@mellanox.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 46/57] infiniband: hfi1: fix memory leaks
Date:   Sun,  8 Sep 2019 13:42:10 +0100
Message-Id: <20190908121145.480160111@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
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



