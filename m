Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F483127EB5
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfLTOrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:47:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727381AbfLTOrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:47:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33BDD2465E;
        Fri, 20 Dec 2019 14:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576853222;
        bh=JXTV5rA+VR9UgylwUbsmCMZjorEv2/sD5C3a50xkd4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2g2SlNF0cbRiANpB4trWQKWIdTGYRjt3yO1jJfZn78GuID5rASs1tuAIeEB2UX2r
         /r+uCr60/wBu9SsKO7CXi8pFdfQLgRmDLdVegyGF+uLabfV8NEMfk8wJ7TNNul1azm
         dkXe/ijTC8pUxshqa0x+ZbLj/8dIbk7v7XSvf6oQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Parav Pandit <parav@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 02/14] RDMA/cma: add missed unregister_pernet_subsys in init failure
Date:   Fri, 20 Dec 2019 09:46:46 -0500
Message-Id: <20191220144658.10414-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220144658.10414-1-sashal@kernel.org>
References: <20191220144658.10414-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 44a7b6759000ac51b92715579a7bba9e3f9245c2 ]

The driver forgets to call unregister_pernet_subsys() in the error path
of cma_init().
Add the missed call to fix it.

Fixes: 4be74b42a6d0 ("IB/cma: Separate port allocation to network namespaces")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Link: https://lore.kernel.org/r/20191206012426.12744-1-hslester96@gmail.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index dcfbf326f45c9..27653aad8f218 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4440,6 +4440,7 @@ static int __init cma_init(void)
 	unregister_netdevice_notifier(&cma_nb);
 	rdma_addr_unregister_client(&addr_client);
 	ib_sa_unregister_client(&sa_client);
+	unregister_pernet_subsys(&cma_pernet_operations);
 err_wq:
 	destroy_workqueue(cma_wq);
 	return ret;
-- 
2.20.1

