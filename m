Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7049E10F
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732850AbfH0IIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:08:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732817AbfH0IFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:05:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F6622173E;
        Tue, 27 Aug 2019 08:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893134;
        bh=qCMxmxgU28Adtb3OCPQ8m5kIGKqy6wzZeC/V8xKHQ30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OivOL2W+2HcL7juI9+ZDmQmtL7zoT0hYZpVjyxr0dJecrfTl0Lz4f+VMbXVlt5xIv
         xui1hSzHlgkAXBLzHx9hqragWxDzOlh94ZHch5PdnSpwVCUZtVZyEBZEodBkuURjwD
         AWv8EDkFMNduevkh02Nzh2cGntTAv9jgrCavcfts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 5.2 132/162] IB/hfi1: Add additional checks when handling TID RDMA WRITE DATA packet
Date:   Tue, 27 Aug 2019 09:51:00 +0200
Message-Id: <20190827072743.146168096@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit 90fdae66e72bf0381d168f12dca0259617927895 upstream.

In a congested fabric with adaptive routing enabled, traces show that
packets could be delivered out of order, which could cause incorrect
processing of stale packets. For stale TID RDMA WRITE DATA packets that
cause KDETH EFLAGS errors, this patch adds additional checks before
processing the packets.

Fixes: d72fe7d5008b ("IB/hfi1: Add a function to receive TID RDMA WRITE DATA packet")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Link: https://lore.kernel.org/r/20190815192051.105923.69979.stgit@awfm-01.aw.intel.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/tid_rdma.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -2947,8 +2947,15 @@ bool hfi1_handle_kdeth_eflags(struct hfi
 	 */
 	spin_lock(&qp->s_lock);
 	qpriv = qp->priv;
+	if (qpriv->r_tid_tail == HFI1_QP_WQE_INVALID ||
+	    qpriv->r_tid_tail == qpriv->r_tid_head)
+		goto unlock;
 	e = &qp->s_ack_queue[qpriv->r_tid_tail];
+	if (e->opcode != TID_OP(WRITE_REQ))
+		goto unlock;
 	req = ack_to_tid_req(e);
+	if (req->comp_seg == req->cur_seg)
+		goto unlock;
 	flow = &req->flows[req->clear_tail];
 	trace_hfi1_eflags_err_write(qp, rcv_type, rte, psn);
 	trace_hfi1_rsp_handle_kdeth_eflags(qp, psn);


