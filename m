Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D603ACAA32
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389999AbfJCQUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389992AbfJCQUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:20:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 162422054F;
        Thu,  3 Oct 2019 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119647;
        bh=TEG5FMLOPxC2m3iJa7OAlqaOJOc/fweVtH3XyEcLuQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxH6VGXmPlVQexKQE1GVNdLrGH45Mq3Cjg6MySjyUg4G4SFV2elStCN5VjK5BA1SS
         8tqlgEaz+jzIw8KWjkQS1eo2oWX0EzXSmUWZzN1rKIYGwpTJ+/jBaLckG/N0wtENhj
         8yShK90ACDbmfppIYtfcjoJcTNo1ZE7gmc2KqWA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Eidelman <anton@lightbitslabs.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/211] nvme-multipath: fix ana log nsid lookup when nsid is not found
Date:   Thu,  3 Oct 2019 17:53:00 +0200
Message-Id: <20191003154513.499252504@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Eidelman <anton@lightbitslabs.com>

[ Upstream commit e01f91dff91c7b16a6e3faf2565017d497a73f83 ]

ANA log parsing invokes nvme_update_ana_state() per ANA group desc.
This updates the state of namespaces with nsids in desc->nsids[].

Both ctrl->namespaces list and desc->nsids[] array are sorted by nsid.
Hence nvme_update_ana_state() performs a single walk over ctrl->namespaces:
- if current namespace matches the current desc->nsids[n],
  this namespace is updated, and n is incremented.
- the process stops when it encounters the end of either
  ctrl->namespaces end or desc->nsids[]

In case desc->nsids[n] does not match any of ctrl->namespaces,
the remaining nsids following desc->nsids[n] will not be updated.
Such situation was considered abnormal and generated WARN_ON_ONCE.

However ANA log MAY contain nsids not (yet) found in ctrl->namespaces.
For example, lets consider the following scenario:
- nvme0 exposes namespaces with nsids = [2, 3] to the host
- a new namespace nsid = 1 is added dynamically
- also, a ANA topology change is triggered
- NS_CHANGED aen is generated and triggers scan_work
- before scan_work discovers nsid=1 and creates a namespace, a NOTICE_ANA
  aen was issues and ana_work receives ANA log with nsids=[1, 2, 3]

Result: ana_work fails to update ANA state on existing namespaces [2, 3]

Solution:
Change the way nvme_update_ana_state() namespace list walk
checks the current namespace against desc->nsids[n] as follows:
a) ns->head->ns_id < desc->nsids[n]: keep walking ctrl->namespaces.
b) ns->head->ns_id == desc->nsids[n]: match, update the namespace
c) ns->head->ns_id >= desc->nsids[n]: skip to desc->nsids[n+1]

This enables correct operation in the scenario described above.
This also allows ANA log to contain nsids currently invisible
to the host, i.e. inactive nsids.

Signed-off-by: Anton Eidelman <anton@lightbitslabs.com>
Reviewed-by:   James Smart <james.smart@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index f57feb8fdea45..892ef52122329 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -404,14 +404,16 @@ static int nvme_update_ana_state(struct nvme_ctrl *ctrl,
 
 	down_write(&ctrl->namespaces_rwsem);
 	list_for_each_entry(ns, &ctrl->namespaces, list) {
-		if (ns->head->ns_id != le32_to_cpu(desc->nsids[n]))
+		unsigned nsid = le32_to_cpu(desc->nsids[n]);
+
+		if (ns->head->ns_id < nsid)
 			continue;
-		nvme_update_ns_ana_state(desc, ns);
+		if (ns->head->ns_id == nsid)
+			nvme_update_ns_ana_state(desc, ns);
 		if (++n == nr_nsids)
 			break;
 	}
 	up_write(&ctrl->namespaces_rwsem);
-	WARN_ON_ONCE(n < nr_nsids);
 	return 0;
 }
 
-- 
2.20.1



