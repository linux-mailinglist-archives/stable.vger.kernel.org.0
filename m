Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D4D419A4B
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbhI0RIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236056AbhI0RHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:07:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 711B5611C5;
        Mon, 27 Sep 2021 17:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762337;
        bh=i4iaWoQ1Sgn/qBlgsSBs9HIavAn/HhwJWpFMBgsledo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVKCmu26NWNbrKVl+VumLFu4EEJR7ZUDExNnnBRE/27w3LXGh+stTkeVCD6JCb9Pd
         szAXj5SVKLjOr7Y+LrhlmRpKpXylwstj4gjbSXcjQTT+qCNwDXwFBThDSErAfnc1pi
         XWL/HDYlSTHyv82LHG5ai5yENqdfdrkBw5qHOZ7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Eidelman <anton@lightbitslabs.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/68] nvme-multipath: fix ANA state updates when a namespace is not present
Date:   Mon, 27 Sep 2021 19:02:48 +0200
Message-Id: <20210927170221.754953512@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
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
2.33.0



