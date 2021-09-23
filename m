Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA7941565D
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbhIWDlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239351AbhIWDkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEDD261216;
        Thu, 23 Sep 2021 03:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368346;
        bh=5N4Ur0mgyMCiXcsvhHqZoyqvYoB+euTMfqx0cX1DmI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cuu/CP9sIQNh9x5Uot77nBstzd5G+wgNcq6XplqVo2R/ws/NJOCpZRrMUzYGHqwcX
         /5/zGLgg+fQrh1ryTcAb9DAzil8MzAHpx7ALTsbBb9q8+P5DIm8m1EpLcw7LKmlNVV
         UMBz2aGNqp9kSp6XRzVA1ztb0lGEq3DuNjheRYuY4xkQW0K3HXIhasgh/KcbHlV0pq
         RRqCsTz1WGEq9RL/wkoA5H5hPDo3mYp/7h4+YGJpkh2xGA/WQ5G2q51J47bnAzv82U
         ywwoRyOOlG+sNJ0Pokz8qPakZY81amLp3wkmBc6iobD2Le2PwBk5NuHLh7SZfUAHOq
         WHBmDp9UAuTgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Eidelman <anton.eidelman@gmail.com>,
        Anton Eidelman <anton@lightbitslabs.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, Christoph@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 08/19] nvme-multipath: fix ANA state updates when a namespace is not present
Date:   Wed, 22 Sep 2021 23:38:42 -0400
Message-Id: <20210923033853.1421193-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033853.1421193-1-sashal@kernel.org>
References: <20210923033853.1421193-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Eidelman <anton.eidelman@gmail.com>

[ Upstream commit 79f528afa93918519574773ea49a444c104bc1bd ]

nvme_update_ana_state() has a deficiency that results in a failure to
properly update the ana state for a namespace in the following case:

  NSIDs in ctrl->namespaces:	1, 3,    4
  NSIDs in desc->nsids:		1, 2, 3, 4

Loop iteration 0:
    ns index = 0, n = 0, ns->head->ns_id = 1, nsid = 1, MATCH.
Loop iteration 1:
    ns index = 1, n = 1, ns->head->ns_id = 3, nsid = 2, NO MATCH.
Loop iteration 2:
    ns index = 2, n = 2, ns->head->ns_id = 4, nsid = 4, MATCH.

Where the update to the ANA state of NSID 3 is missed.  To fix this
increment n and retry the update with the same ns when ns->head->ns_id is
higher than nsid,

Signed-off-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 590b040e90a3..016a67fd4198 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -522,14 +522,17 @@ static int nvme_update_ana_state(struct nvme_ctrl *ctrl,
 
 	down_read(&ctrl->namespaces_rwsem);
 	list_for_each_entry(ns, &ctrl->namespaces, list) {
-		unsigned nsid = le32_to_cpu(desc->nsids[n]);
-
+		unsigned nsid;
+again:
+		nsid = le32_to_cpu(desc->nsids[n]);
 		if (ns->head->ns_id < nsid)
 			continue;
 		if (ns->head->ns_id == nsid)
 			nvme_update_ns_ana_state(desc, ns);
 		if (++n == nr_nsids)
 			break;
+		if (ns->head->ns_id > nsid)
+			goto again;
 	}
 	up_read(&ctrl->namespaces_rwsem);
 	return 0;
-- 
2.30.2

