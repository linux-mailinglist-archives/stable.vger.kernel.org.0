Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8584418A1
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhKAJtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233714AbhKAJra (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:47:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B1E61423;
        Mon,  1 Nov 2021 09:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759064;
        bh=dJq2wuvSxbnSANxJaqJmW5FZA21+1++vbfAzRrgpbGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imUcxLwuNAry/qXQ9V+TZGQij+PGeLnyoTkPWdvttn6GtZ4tGJNbZ+Bqf85FoWj0E
         nNkvI57zShOlUwuf9hOWyg/vkIWryjQhfkhfCWbwMWafAtBPz5J5pflBwY/Q2ALZd2
         1em6N8U/Bh++Mfozxp91yUkWGOg6rq8PlCuOEQhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 098/125] RDMA/irdma: Do not hold qos mutex twice on QP resume
Date:   Mon,  1 Nov 2021 10:17:51 +0100
Message-Id: <20211101082551.683748428@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 2dace185caa580720c7cd67fec9efc5ee26108ac ]

When irdma_ws_add fails, irdma_ws_remove is used to cleanup the leaf node.
This lead to holding the qos mutex twice in the QP resume path. Fix this
by avoiding the call to irdma_ws_remove and unwinding the error in
irdma_ws_add. This skips the call to irdma_tc_in_use function which is not
needed in the error unwind cases.

Fixes: 3ae331c75128 ("RDMA/irdma: Add QoS definitions")
Link: https://lore.kernel.org/r/20211019151654.1943-2-shiraz.saleem@intel.com
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/ws.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/ws.c b/drivers/infiniband/hw/irdma/ws.c
index b68c575eb78e..b0d6ee0739f5 100644
--- a/drivers/infiniband/hw/irdma/ws.c
+++ b/drivers/infiniband/hw/irdma/ws.c
@@ -330,8 +330,10 @@ enum irdma_status_code irdma_ws_add(struct irdma_sc_vsi *vsi, u8 user_pri)
 
 		tc_node->enable = true;
 		ret = irdma_ws_cqp_cmd(vsi, tc_node, IRDMA_OP_WS_MODIFY_NODE);
-		if (ret)
+		if (ret) {
+			vsi->unregister_qset(vsi, tc_node);
 			goto reg_err;
+		}
 	}
 	ibdev_dbg(to_ibdev(vsi->dev),
 		  "WS: Using node %d which represents VSI %d TC %d\n",
@@ -350,6 +352,10 @@ enum irdma_status_code irdma_ws_add(struct irdma_sc_vsi *vsi, u8 user_pri)
 	}
 	goto exit;
 
+reg_err:
+	irdma_ws_cqp_cmd(vsi, tc_node, IRDMA_OP_WS_DELETE_NODE);
+	list_del(&tc_node->siblings);
+	irdma_free_node(vsi, tc_node);
 leaf_add_err:
 	if (list_empty(&vsi_node->child_list_head)) {
 		if (irdma_ws_cqp_cmd(vsi, vsi_node, IRDMA_OP_WS_DELETE_NODE))
@@ -369,11 +375,6 @@ vsi_add_err:
 exit:
 	mutex_unlock(&vsi->dev->ws_mutex);
 	return ret;
-
-reg_err:
-	mutex_unlock(&vsi->dev->ws_mutex);
-	irdma_ws_remove(vsi, user_pri);
-	return ret;
 }
 
 /**
-- 
2.33.0



