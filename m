Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FD2658062
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbiL1QRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbiL1QQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:16:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705241A39F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:14:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F2F261542
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D62DC433F0;
        Wed, 28 Dec 2022 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244067;
        bh=BTGVFUP1JdWvqlRaCUUYEVaSvv9kxTKah4UUWx/dp0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fufd0uLwyXI3ZXZTor97ZJ3ZNFz+l22GsrT/5B7xVuACB9Dm9VdTM7YX37Kmc7OGj
         BbmPc+Vs6t4TohAkhqSPVGtfMpROCMWZ18zJutFS0FuGdQTCz6SXKk5GLMIgEQo5zE
         1y2+h5f87t7Ei7nmy+e8abukR8d7d9od+Omjb8Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Leonid Ravich <lravich@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0604/1146] IB/mad: Dont call to function that might sleep while in atomic context
Date:   Wed, 28 Dec 2022 15:35:43 +0100
Message-Id: <20221228144346.578856622@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonid Ravich <lravich@gmail.com>

[ Upstream commit 5c20311d76cbaeb7ed2ecf9c8b8322f8fc4a7ae3 ]

Tracepoints are not allowed to sleep, as such the following splat is
generated due to call to ib_query_pkey() in atomic context.

WARNING: CPU: 0 PID: 1888000 at kernel/trace/ring_buffer.c:2492 rb_commit+0xc1/0x220
CPU: 0 PID: 1888000 Comm: kworker/u9:0 Kdump: loaded Tainted: G           OE    --------- -  - 4.18.0-305.3.1.el8.x86_64 #1
 Hardware name: Red Hat KVM, BIOS 1.13.0-2.module_el8.3.0+555+a55c8938 04/01/2014
 Workqueue: ib-comp-unb-wq ib_cq_poll_work [ib_core]
 RIP: 0010:rb_commit+0xc1/0x220
 RSP: 0000:ffffa8ac80f9bca0 EFLAGS: 00010202
 RAX: ffff8951c7c01300 RBX: ffff8951c7c14a00 RCX: 0000000000000246
 RDX: ffff8951c707c000 RSI: ffff8951c707c57c RDI: ffff8951c7c14a00
 RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
 R10: ffff8951c7c01300 R11: 0000000000000001 R12: 0000000000000246
 R13: 0000000000000000 R14: ffffffff964c70c0 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff8951fbc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f20e8f39010 CR3: 000000002ca10005 CR4: 0000000000170ef0
 Call Trace:
  ring_buffer_unlock_commit+0x1d/0xa0
  trace_buffer_unlock_commit_regs+0x3b/0x1b0
  trace_event_buffer_commit+0x67/0x1d0
  trace_event_raw_event_ib_mad_recv_done_handler+0x11c/0x160 [ib_core]
  ib_mad_recv_done+0x48b/0xc10 [ib_core]
  ? trace_event_raw_event_cq_poll+0x6f/0xb0 [ib_core]
  __ib_process_cq+0x91/0x1c0 [ib_core]
  ib_cq_poll_work+0x26/0x80 [ib_core]
  process_one_work+0x1a7/0x360
  ? create_worker+0x1a0/0x1a0
  worker_thread+0x30/0x390
  ? create_worker+0x1a0/0x1a0
  kthread+0x116/0x130
  ? kthread_flush_work_fn+0x10/0x10
  ret_from_fork+0x35/0x40
 ---[ end trace 78ba8509d3830a16 ]---

Fixes: 821bf1de45a1 ("IB/MAD: Add recv path trace point")
Signed-off-by: Leonid Ravich <lravich@gmail.com>
Link: https://lore.kernel.org/r/Y2t5feomyznrVj7V@leonid-Inspiron-3421
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c |  5 -----
 include/trace/events/ib_mad.h | 13 ++++---------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 1893aa613ad7..674344eb8e2f 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -59,9 +59,6 @@ static void create_mad_addr_info(struct ib_mad_send_wr_private *mad_send_wr,
 			  struct ib_mad_qp_info *qp_info,
 			  struct trace_event_raw_ib_mad_send_template *entry)
 {
-	u16 pkey;
-	struct ib_device *dev = qp_info->port_priv->device;
-	u32 pnum = qp_info->port_priv->port_num;
 	struct ib_ud_wr *wr = &mad_send_wr->send_wr;
 	struct rdma_ah_attr attr = {};
 
@@ -69,8 +66,6 @@ static void create_mad_addr_info(struct ib_mad_send_wr_private *mad_send_wr,
 
 	/* These are common */
 	entry->sl = attr.sl;
-	ib_query_pkey(dev, pnum, wr->pkey_index, &pkey);
-	entry->pkey = pkey;
 	entry->rqpn = wr->remote_qpn;
 	entry->rqkey = wr->remote_qkey;
 	entry->dlid = rdma_ah_get_dlid(&attr);
diff --git a/include/trace/events/ib_mad.h b/include/trace/events/ib_mad.h
index 59363a083ecb..d92691c78cff 100644
--- a/include/trace/events/ib_mad.h
+++ b/include/trace/events/ib_mad.h
@@ -49,7 +49,6 @@ DECLARE_EVENT_CLASS(ib_mad_send_template,
 		__field(int,            retries_left)
 		__field(int,            max_retries)
 		__field(int,            retry)
-		__field(u16,            pkey)
 	),
 
 	TP_fast_assign(
@@ -89,7 +88,7 @@ DECLARE_EVENT_CLASS(ib_mad_send_template,
 		  "hdr : base_ver 0x%x class 0x%x class_ver 0x%x " \
 		  "method 0x%x status 0x%x class_specific 0x%x tid 0x%llx " \
 		  "attr_id 0x%x attr_mod 0x%x  => dlid 0x%08x sl %d "\
-		  "pkey 0x%x rpqn 0x%x rqpkey 0x%x",
+		  "rpqn 0x%x rqpkey 0x%x",
 		__entry->dev_index, __entry->port_num, __entry->qp_num,
 		__entry->agent_priv, be64_to_cpu(__entry->wrtid),
 		__entry->retries_left, __entry->max_retries,
@@ -100,7 +99,7 @@ DECLARE_EVENT_CLASS(ib_mad_send_template,
 		be16_to_cpu(__entry->class_specific),
 		be64_to_cpu(__entry->tid), be16_to_cpu(__entry->attr_id),
 		be32_to_cpu(__entry->attr_mod),
-		be32_to_cpu(__entry->dlid), __entry->sl, __entry->pkey,
+		be32_to_cpu(__entry->dlid), __entry->sl,
 		__entry->rqpn, __entry->rqkey
 	)
 );
@@ -204,7 +203,6 @@ TRACE_EVENT(ib_mad_recv_done_handler,
 		__field(u16,            wc_status)
 		__field(u32,            slid)
 		__field(u32,            dev_index)
-		__field(u16,            pkey)
 	),
 
 	TP_fast_assign(
@@ -224,9 +222,6 @@ TRACE_EVENT(ib_mad_recv_done_handler,
 		__entry->slid = wc->slid;
 		__entry->src_qp = wc->src_qp;
 		__entry->sl = wc->sl;
-		ib_query_pkey(qp_info->port_priv->device,
-			      qp_info->port_priv->port_num,
-			      wc->pkey_index, &__entry->pkey);
 		__entry->wc_status = wc->status;
 	),
 
@@ -234,7 +229,7 @@ TRACE_EVENT(ib_mad_recv_done_handler,
 		  "base_ver 0x%02x class 0x%02x class_ver 0x%02x " \
 		  "method 0x%02x status 0x%04x class_specific 0x%04x " \
 		  "tid 0x%016llx attr_id 0x%04x attr_mod 0x%08x " \
-		  "slid 0x%08x src QP%d, sl %d pkey 0x%04x",
+		  "slid 0x%08x src QP%d, sl %d",
 		__entry->dev_index, __entry->port_num, __entry->qp_num,
 		__entry->wc_status,
 		__entry->length,
@@ -244,7 +239,7 @@ TRACE_EVENT(ib_mad_recv_done_handler,
 		be16_to_cpu(__entry->class_specific),
 		be64_to_cpu(__entry->tid), be16_to_cpu(__entry->attr_id),
 		be32_to_cpu(__entry->attr_mod),
-		__entry->slid, __entry->src_qp, __entry->sl, __entry->pkey
+		__entry->slid, __entry->src_qp, __entry->sl
 	)
 );
 
-- 
2.35.1



