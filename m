Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D91509E0BF
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732813AbfH0IFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731443AbfH0IFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:05:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10F4217F5;
        Tue, 27 Aug 2019 08:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893131;
        bh=wzbZxtrhX9Gj/EB3qIZ6hzivxxPXIUx1MjSENaTyTD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsJPWPIkCLLuUou4FEuUeWTaeqk9fZPiK/SoIL1I4KcYVLpUnWxIIWBNqN9sDpNC0
         rOiIc0A0AEnKpXeLEcn1EdNvEk05UhvrpFSxteVws3jSmEkrHOvpFyfAlnNlqu9isr
         WawKRwZHcQTHusqeSmUh4lc4FwmqXCt6gV/DyBfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 5.2 131/162] IB/hfi1: Add additional checks when handling TID RDMA READ RESP packet
Date:   Tue, 27 Aug 2019 09:50:59 +0200
Message-Id: <20190827072743.100909227@linuxfoundation.org>
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

commit a8adbf7d0d0a6e3bf7f99da461a06039364e028b upstream.

In a congested fabric with adaptive routing enabled, traces show that
packets could be delivered out of order, which could cause incorrect
processing of stale packets. For stale TID RDMA READ RESP packets that
cause KDETH EFLAGS errors, this patch adds additional checks before
processing the packets.

Fixes: 9905bf06e890 ("IB/hfi1: Add functions to receive TID RDMA READ response")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Link: https://lore.kernel.org/r/20190815192045.105923.59813.stgit@awfm-01.aw.intel.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/tid_rdma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -2742,9 +2742,12 @@ static bool handle_read_kdeth_eflags(str
 
 		wqe = do_rc_completion(qp, wqe, ibp);
 		if (qp->s_acked == qp->s_tail)
-			break;
+			goto s_unlock;
 	}
 
+	if (qp->s_acked == qp->s_tail)
+		goto s_unlock;
+
 	/* Handle the eflags for the request */
 	if (wqe->wr.opcode != IB_WR_TID_RDMA_READ)
 		goto s_unlock;


