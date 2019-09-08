Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37F9ACDE8
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731024AbfIHMs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730954AbfIHMsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:48:25 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D1EA21924;
        Sun,  8 Sep 2019 12:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946904;
        bh=cC6LQjRnHIQNzCIffnzsBRuYfQC1vJcIUY6FOGwSNwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGKOid3D3ClGYqtI62yIZP1Y/9c2uwHNX1wE2eDeyWP1LoViRyjL89lRwC0OZ/8BV
         IS96NQ/N3aHSygZ8hWA4Mgdww5dkegK1tZ69F49dvNdYwGXyZ95RDQU8W2nmWoMPRP
         E5l3NPIjcokk3FFGlQXaHrr+4DRvZiQNPhylMKQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Leon Romanovsky <leonro@mellanox.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/57] infiniband: hfi1: fix a memory leak bug
Date:   Sun,  8 Sep 2019 13:42:09 +0100
Message-Id: <20190908121145.368492256@linuxfoundation.org>
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



