Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50573A7086
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbfICQY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730194AbfICQY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:24:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D52523697;
        Tue,  3 Sep 2019 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527896;
        bh=ClRwCvx8HHpkFwO3LeGjqjqNIj13E59y3JUVDZqeXGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfpXAegAvu3TWt4HSrhXA9VdtXFeb2ze8ju3j2jm8R20jV3e8axUYvR35XCcwC8d4
         MqJgrxEqqsykGqY9mz6JUL2xRt+AsAh7N8n89ylk6+YdYjh64S5Edlzyeis7P5qxnb
         q7wSPaz7sP52tYhH3RMRRoiEzRUt10LcKUEGFIis=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 09/23] IB/rdmavt: Add new completion inline
Date:   Tue,  3 Sep 2019 12:24:10 -0400
Message-Id: <20190903162424.6877-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162424.6877-1-sashal@kernel.org>
References: <20190903162424.6877-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

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

