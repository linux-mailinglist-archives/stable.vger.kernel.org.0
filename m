Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B36FA19913F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732123AbgCaJS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732106AbgCaJS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:18:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D81482072E;
        Tue, 31 Mar 2020 09:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646308;
        bh=MuJR827GwbcbpjRRdpPKWhk51Tk5Sf/7WcpNL6TTU6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGAOBhfLRxsNxtQwISV3Mw/OZaIdoAS+PpPCCKArv5z5kFCBq4v2EDW5NL/bQ5Umt
         Ek57wYIFmbJu+z9qkIwLFfccmtw43bpXWyRWit/26bOF0katxb+RvHMyHtIaKE8JWq
         Z12T3mfccOxgjRQ21Jq+F3/pYS9wCueFFeCfESpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 108/155] RDMA/core: Ensure security pkey modify is not lost
Date:   Tue, 31 Mar 2020 10:59:08 +0200
Message-Id: <20200331085430.743868483@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 2d47fbacf2725a67869f4d3634c2415e7dfab2f4 upstream.

The following modify sequence (loosely based on ipoib) will lose a pkey
modifcation:

- Modify (pkey index, port)
- Modify (new pkey index, NO port)

After the first modify, the qp_pps list will have saved the pkey and the
unit on the main list.

During the second modify, get_new_pps() will fetch the port from qp_pps
and read the new pkey index from qp_attr->pkey_index.  The state will
still be zero, or IB_PORT_PKEY_NOT_VALID. Because of the invalid state,
the new values will never replace the one in the qp pps list, losing the
new pkey.

This happens because the following if statements will never correct the
state because the first term will be false. If the code had been executed,
it would incorrectly overwrite valid values.

  if ((qp_attr_mask & IB_QP_PKEY_INDEX) && (qp_attr_mask & IB_QP_PORT))
	  new_pps->main.state = IB_PORT_PKEY_VALID;

  if (!(qp_attr_mask & (IB_QP_PKEY_INDEX | IB_QP_PORT)) && qp_pps) {
	  new_pps->main.port_num = qp_pps->main.port_num;
	  new_pps->main.pkey_index = qp_pps->main.pkey_index;
	  if (qp_pps->main.state != IB_PORT_PKEY_NOT_VALID)
		  new_pps->main.state = IB_PORT_PKEY_VALID;
  }

Fix by joining the two if statements with an or test to see if qp_pps is
non-NULL and in the correct state.

Fixes: 1dd017882e01 ("RDMA/core: Fix protection fault in get_pkey_idx_qp_list")
Link: https://lore.kernel.org/r/20200313124704.14982.55907.stgit@awfm-01.aw.intel.com
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/security.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -349,16 +349,11 @@ static struct ib_ports_pkeys *get_new_pp
 	else if (qp_pps)
 		new_pps->main.pkey_index = qp_pps->main.pkey_index;
 
-	if ((qp_attr_mask & IB_QP_PKEY_INDEX) && (qp_attr_mask & IB_QP_PORT))
+	if (((qp_attr_mask & IB_QP_PKEY_INDEX) &&
+	     (qp_attr_mask & IB_QP_PORT)) ||
+	    (qp_pps && qp_pps->main.state != IB_PORT_PKEY_NOT_VALID))
 		new_pps->main.state = IB_PORT_PKEY_VALID;
 
-	if (!(qp_attr_mask & (IB_QP_PKEY_INDEX | IB_QP_PORT)) && qp_pps) {
-		new_pps->main.port_num = qp_pps->main.port_num;
-		new_pps->main.pkey_index = qp_pps->main.pkey_index;
-		if (qp_pps->main.state != IB_PORT_PKEY_NOT_VALID)
-			new_pps->main.state = IB_PORT_PKEY_VALID;
-	}
-
 	if (qp_attr_mask & IB_QP_ALT_PATH) {
 		new_pps->alt.port_num = qp_attr->alt_port_num;
 		new_pps->alt.pkey_index = qp_attr->alt_pkey_index;


