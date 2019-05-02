Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20F311DB0
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbfEBPca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbfEBPca (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60BC4204FD;
        Thu,  2 May 2019 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811149;
        bh=nKnfFAXeiKLBlx2nKx070WDhRTUsQCSsZJz4+ogYXyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TROx0FDUtPTm/TeMAvjZOMrONv6BqjLD4L+hb/wv5+tWHdd9+4TU5Zv0U0xfa4cO3
         Dg1kgOdt+sVkTZePZVdgdm+N8qzX9JadzcIQrynTZ439R7pXlIxLpnRZmexw/+U1kp
         VtJ+zXQDzAgOlUYR55zW1UeV5K7WEbPzp0fqoJ2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Bates <sbates@raithlin.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 093/101] nvmet: fix error flow during ns enable
Date:   Thu,  2 May 2019 17:21:35 +0200
Message-Id: <20190502143346.096568864@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a536b49785759bf99465fdf6e248d34322123fcd ]

In case we fail to enable p2pmem on the current namespace, disable the
backing store device before exiting.

Cc: Stephen Bates <sbates@raithlin.com>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 02c63c463222..7bad21a2283f 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -517,7 +517,7 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 
 	ret = nvmet_p2pmem_ns_enable(ns);
 	if (ret)
-		goto out_unlock;
+		goto out_dev_disable;
 
 	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
 		nvmet_p2pmem_ns_add_p2p(ctrl, ns);
@@ -558,7 +558,7 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 out_dev_put:
 	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
 		pci_dev_put(radix_tree_delete(&ctrl->p2p_ns_map, ns->nsid));
-
+out_dev_disable:
 	nvmet_ns_dev_disable(ns);
 	goto out_unlock;
 }
-- 
2.19.1



