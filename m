Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB321F1E4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfEOL5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728459AbfEOLR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:17:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA8E8206BF;
        Wed, 15 May 2019 11:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919048;
        bh=lRWpwBxAKkzSsOcpMD/arrQGly+y9KLqL+kJlimOI38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEKZSknXB0Cf9iDB/YX2LLDRPZWiyFa6lVMwXfKkR9dQzCL3TOw6UzFEG0k0hUc8e
         6DdE4O+vVbpKCFLoEXdCTV6SjNoAouXHmjLKVVcIt4Lzw2W1vvO1aAUT8i1o5H7zUv
         AZXz8atjJNXnRv61r5g16VPPDDb9vvHrtsxpiWXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Howell <seth.howell@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 045/115] IB/rxe: Revise the ib_wr_opcode enum
Date:   Wed, 15 May 2019 12:55:25 +0200
Message-Id: <20190515090702.763611027@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9a59739bd01f77db6fbe2955a4fce165f0f43568 ]

This enum has become part of the uABI, as both RXE and the
ib_uverbs_post_send() command expect userspace to supply values from this
enum. So it should be properly placed in include/uapi/rdma.

In userspace this enum is called 'enum ibv_wr_opcode' as part of
libibverbs.h. That enum defines different values for IB_WR_LOCAL_INV,
IB_WR_SEND_WITH_INV, and IB_WR_LSO. These were introduced (incorrectly, it
turns out) into libiberbs in 2015.

The kernel has changed its mind on the numbering for several of the IB_WC
values over the years, but has remained stable on IB_WR_LOCAL_INV and
below.

Based on this we can conclude that there is no real user space user of the
values beyond IB_WR_ATOMIC_FETCH_AND_ADD, as they have never worked via
rdma-core. This is confirmed by inspection, only rxe uses the kernel enum
and implements the latter operations. rxe has clearly never worked with
these attributes from userspace. Other drivers that support these opcodes
implement the functionality without calling out to the kernel.

To make IB_WR_SEND_WITH_INV and related work for RXE in userspace we
choose to renumber the IB_WR enum in the kernel to match the uABI that
userspace has bee using since before Soft RoCE was merged. This is an
overall simpler configuration for the whole software stack, and obviously
can't break anything existing.

Reported-by: Seth Howell <seth.howell@intel.com>
Tested-by: Seth Howell <seth.howell@intel.com>
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 include/rdma/ib_verbs.h           | 34 ++++++++++++++++++-------------
 include/uapi/rdma/ib_user_verbs.h | 20 +++++++++++++++++-
 2 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5a24b4c700e59..9e76b2410d03f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1251,21 +1251,27 @@ struct ib_qp_attr {
 };
 
 enum ib_wr_opcode {
-	IB_WR_RDMA_WRITE,
-	IB_WR_RDMA_WRITE_WITH_IMM,
-	IB_WR_SEND,
-	IB_WR_SEND_WITH_IMM,
-	IB_WR_RDMA_READ,
-	IB_WR_ATOMIC_CMP_AND_SWP,
-	IB_WR_ATOMIC_FETCH_AND_ADD,
-	IB_WR_LSO,
-	IB_WR_SEND_WITH_INV,
-	IB_WR_RDMA_READ_WITH_INV,
-	IB_WR_LOCAL_INV,
-	IB_WR_REG_MR,
-	IB_WR_MASKED_ATOMIC_CMP_AND_SWP,
-	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,
+	/* These are shared with userspace */
+	IB_WR_RDMA_WRITE = IB_UVERBS_WR_RDMA_WRITE,
+	IB_WR_RDMA_WRITE_WITH_IMM = IB_UVERBS_WR_RDMA_WRITE_WITH_IMM,
+	IB_WR_SEND = IB_UVERBS_WR_SEND,
+	IB_WR_SEND_WITH_IMM = IB_UVERBS_WR_SEND_WITH_IMM,
+	IB_WR_RDMA_READ = IB_UVERBS_WR_RDMA_READ,
+	IB_WR_ATOMIC_CMP_AND_SWP = IB_UVERBS_WR_ATOMIC_CMP_AND_SWP,
+	IB_WR_ATOMIC_FETCH_AND_ADD = IB_UVERBS_WR_ATOMIC_FETCH_AND_ADD,
+	IB_WR_LSO = IB_UVERBS_WR_TSO,
+	IB_WR_SEND_WITH_INV = IB_UVERBS_WR_SEND_WITH_INV,
+	IB_WR_RDMA_READ_WITH_INV = IB_UVERBS_WR_RDMA_READ_WITH_INV,
+	IB_WR_LOCAL_INV = IB_UVERBS_WR_LOCAL_INV,
+	IB_WR_MASKED_ATOMIC_CMP_AND_SWP =
+		IB_UVERBS_WR_MASKED_ATOMIC_CMP_AND_SWP,
+	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD =
+		IB_UVERBS_WR_MASKED_ATOMIC_FETCH_AND_ADD,
+
+	/* These are kernel only and can not be issued by userspace */
+	IB_WR_REG_MR = 0x20,
 	IB_WR_REG_SIG_MR,
+
 	/* reserve values for low level drivers' internal use.
 	 * These values will not be used at all in the ib core layer.
 	 */
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index e0e83a105953a..e11b4def8630f 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -751,10 +751,28 @@ struct ib_uverbs_sge {
 	__u32 lkey;
 };
 
+enum ib_uverbs_wr_opcode {
+	IB_UVERBS_WR_RDMA_WRITE = 0,
+	IB_UVERBS_WR_RDMA_WRITE_WITH_IMM = 1,
+	IB_UVERBS_WR_SEND = 2,
+	IB_UVERBS_WR_SEND_WITH_IMM = 3,
+	IB_UVERBS_WR_RDMA_READ = 4,
+	IB_UVERBS_WR_ATOMIC_CMP_AND_SWP = 5,
+	IB_UVERBS_WR_ATOMIC_FETCH_AND_ADD = 6,
+	IB_UVERBS_WR_LOCAL_INV = 7,
+	IB_UVERBS_WR_BIND_MW = 8,
+	IB_UVERBS_WR_SEND_WITH_INV = 9,
+	IB_UVERBS_WR_TSO = 10,
+	IB_UVERBS_WR_RDMA_READ_WITH_INV = 11,
+	IB_UVERBS_WR_MASKED_ATOMIC_CMP_AND_SWP = 12,
+	IB_UVERBS_WR_MASKED_ATOMIC_FETCH_AND_ADD = 13,
+	/* Review enum ib_wr_opcode before modifying this */
+};
+
 struct ib_uverbs_send_wr {
 	__u64 wr_id;
 	__u32 num_sge;
-	__u32 opcode;
+	__u32 opcode;		/* see enum ib_uverbs_wr_opcode */
 	__u32 send_flags;
 	union {
 		__u32 imm_data;
-- 
2.20.1



