Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D997419B16
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236728AbhI0RPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237170AbhI0ROB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:14:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BCBD61360;
        Mon, 27 Sep 2021 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762594;
        bh=sPF98nquJCc77VcECwo/S0m2FQKeRkwxFkDq6nENSXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsfQaLNE8E5i/o4Xl9XFQ/iXcYmmiAFhMWJSllSwgKZjOsvRQDzRvULZu/6uA428V
         3/HTwPc6pX5hmWko63bSZDaFehhEIHVHvK89yBoCqI0O0plEQ17GCwT3uPiOowj9iG
         PHykG7eadF/hM1py5nbdKzYwhXZ+v8LavbjoGXXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Eidelman <anton@lightbitslabs.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/103] nvme-multipath: fix ANA state updates when a namespace is not present
Date:   Mon, 27 Sep 2021 19:02:54 +0200
Message-Id: <20210927170228.604496928@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2747efc03825..46a1e24ba6f4 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -509,14 +509,17 @@ static int nvme_update_ana_state(struct nvme_ctrl *ctrl,
 
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
2.33.0



