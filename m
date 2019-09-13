Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD4BB2063
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390792AbfIMNVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388155AbfIMNVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:21:19 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81886206A5;
        Fri, 13 Sep 2019 13:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380879;
        bh=upUGwm/msuem5sT6UoS7SFgRcUJ9ZfVcRt9ovRejGh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zepvc19JQyh51SB3EWTh82LZ07vs7x+TlGowziSgSiBYQwwpH1BSNU+44ZxLxhGyx
         B/7gL07zTaCnoPevgbmULpxyn4NyLbyAf6U1Hnm/1Qba5pvr7ZfrlzCVqpbJyAUTek
         CsH5xU9NnIHhf6VpQqOEsFiMfPT+2UjrSJ0HsTl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 5.2 21/37] IB/rdmavt: Add new completion inline
Date:   Fri, 13 Sep 2019 14:07:26 +0100
Message-Id: <20190913130519.201854592@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is opencoded send completion logic all over all
the drivers.

We need to convert to this routine to enforce ordering
issues for completions.  This routine fixes an ordering
issue where the read of the SWQE fields necessary for creating
the completion can race with a post send if the post send catches
a send queue at the edge of being full.  Is is possible in that situation
to read SWQE fields that are being written.

This new routine insures that SWQE fields are read prior to advancing
the index that post send uses to determine queue fullness.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 include/rdma/rdmavt_qp.h | 72 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 68e38c20afc04..6014f17669071 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -737,6 +737,78 @@ static inline void rvt_put_qp_swqe(struct rvt_qp *qp, struct rvt_swqe *wqe)
 		atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 }
 
+/**
+ * rvt_qp_sqwe_incr - increment ring index
+ * @qp: the qp
+ * @val: the starting value
+ *
+ * Return: the new value wrapping as appropriate
+ */
+static inline u32
+rvt_qp_swqe_incr(struct rvt_qp *qp, u32 val)
+{
+	if (++val >= qp->s_size)
+		val = 0;
+	return val;
+}
+
+/**
+ * rvt_qp_complete_swqe - insert send completion
+ * @qp - the qp
+ * @wqe - the send wqe
+ * @opcode - wc operation (driver dependent)
+ * @status - completion status
+ *
+ * Update the s_last information, and then insert a send
+ * completion into the completion
+ * queue if the qp indicates it should be done.
+ *
+ * See IBTA 10.7.3.1 for info on completion
+ * control.
+ *
+ * Return: new last
+ */
+static inline u32
+rvt_qp_complete_swqe(struct rvt_qp *qp,
+		     struct rvt_swqe *wqe,
+		     enum ib_wc_opcode opcode,
+		     enum ib_wc_status status)
+{
+	bool need_completion;
+	u64 wr_id;
+	u32 byte_len, last;
+	int flags = wqe->wr.send_flags;
+
+	rvt_put_qp_swqe(qp, wqe);
+
+	need_completion =
+		!(flags & RVT_SEND_RESERVE_USED) &&
+		(!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
+		(flags & IB_SEND_SIGNALED) ||
+		status != IB_WC_SUCCESS);
+	if (need_completion) {
+		wr_id = wqe->wr.wr_id;
+		byte_len = wqe->length;
+		/* above fields required before writing s_last */
+	}
+	last = rvt_qp_swqe_incr(qp, qp->s_last);
+	/* see rvt_qp_is_avail() */
+	smp_store_release(&qp->s_last, last);
+	if (need_completion) {
+		struct ib_wc w = {
+			.wr_id = wr_id,
+			.status = status,
+			.opcode = opcode,
+			.qp = &qp->ibqp,
+			.byte_len = byte_len,
+		};
+
+		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &w,
+			     status != IB_WC_SUCCESS);
+	}
+	return last;
+}
+
 extern const int  ib_rvt_state_ops[];
 
 struct rvt_dev_info;
-- 
2.20.1



