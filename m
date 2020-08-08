Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A12B23FB69
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgHHXsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgHHXhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CB0F206E9;
        Sat,  8 Aug 2020 23:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929840;
        bh=QDAW9zoveqrWFCuC7xBLGn80jtKBU8onUkR3R7/heiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcwZA6Y+ypqr2wkInlkOpVtuLEsfUZeJoy/SZdl3IkdRwjGE7xBfVZjuzh2AkeJkz
         +TC3EYFLvI7t0mMfKzi5BxM77X2sXquLXVQUVMA282C+eN7J/7xXwH2LCrhVW7njQ1
         fY3q3y9xxeQ0u0Z/ZsdJFi7+uargv+Ujvok4oKqY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 70/72] nvme-multipath: do not fall back to __nvme_find_path() for non-optimized paths
Date:   Sat,  8 Aug 2020 19:35:39 -0400
Message-Id: <20200808233542.3617339-70-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit fbd6a42d8932e172921c7de10468a2e12c34846b ]

When nvme_round_robin_path() finds a valid namespace we should be using it;
falling back to __nvme_find_path() for non-optimized paths will cause the
result from nvme_round_robin_path() to be ignored for non-optimized paths.

Fixes: 75c10e732724 ("nvme-multipath: round-robin I/O policy")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index fe8f7f123fac7..57d51148e71b6 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -272,10 +272,13 @@ inline struct nvme_ns *nvme_find_path(struct nvme_ns_head *head)
 	struct nvme_ns *ns;
 
 	ns = srcu_dereference(head->current_path[node], &head->srcu);
-	if (READ_ONCE(head->subsys->iopolicy) == NVME_IOPOLICY_RR && ns)
-		ns = nvme_round_robin_path(head, node, ns);
-	if (unlikely(!ns || !nvme_path_is_optimized(ns)))
-		ns = __nvme_find_path(head, node);
+	if (unlikely(!ns))
+		return __nvme_find_path(head, node);
+
+	if (READ_ONCE(head->subsys->iopolicy) == NVME_IOPOLICY_RR)
+		return nvme_round_robin_path(head, node, ns);
+	if (unlikely(!nvme_path_is_optimized(ns)))
+		return __nvme_find_path(head, node);
 	return ns;
 }
 
-- 
2.25.1

