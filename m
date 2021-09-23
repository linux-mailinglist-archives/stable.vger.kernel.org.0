Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BF74156D7
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239504AbhIWDoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239488AbhIWDlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:41:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDCEA61211;
        Thu, 23 Sep 2021 03:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368379;
        bh=GkCK4i7uspIGLeLdrME7n9hpFHZVNM9Kkct98bRiwgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dyjESnI77pARAFcFBF0a0+8LSsLe9f7/QYcBF4INvpdTe57kHD7tYUYbHEsEVCBB8
         dpUDuxprVRo5JeTJxPDaDTlil3kGbSw9Ck/8tXHcoUliF/IwChzKMNbL57jR2DyB+X
         lAEmSOoheyK6qKK1ox2ARdX96LX+JsPYHcoV9999r98BuTEMB01bKDogBlPTLbwQmt
         dr/eZzvSeIonxMz4MDU/S90LAYDpkvTWLpAj777woHbq9z9FGYTuH04fDDFS2yUfp6
         lE7EvPL5Te+evZwqm8cSAIC/blY72fPW2gH93Vo+4utBUKjEmbM3kqDulPmFefsWcX
         B2167AVn9Ym2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Eidelman <anton.eidelman@gmail.com>,
        Anton Eidelman <anton@lightbitslabs.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, Christoph@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 06/15] nvme-multipath: fix ANA state updates when a namespace is not present
Date:   Wed, 22 Sep 2021 23:39:20 -0400
Message-Id: <20210923033929.1421446-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033929.1421446-1-sashal@kernel.org>
References: <20210923033929.1421446-1-sashal@kernel.org>
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
index 64f699a1afd7..022e03643dac 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -398,14 +398,17 @@ static int nvme_update_ana_state(struct nvme_ctrl *ctrl,
 
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

