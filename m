Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF653D28EB
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhGVQAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232723AbhGVP7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C3B4613B7;
        Thu, 22 Jul 2021 16:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971973;
        bh=CBpg0I9t+iAacq5dKrWgPhxIjIYjrsIru2PcukA/+do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBinBDTeY846Dx2pOKAdHXtmAEZId7bNEnoYiF1WAvpCv5PxWQ2shrZLgiDElz4XD
         MjuKyx55Ldjgd6O6uWiVN3Nz3baBwAtg2Z6rHKd4lUIyfYJCr+g1C+cfOVrf3+tOoP
         LFazyBYEmFScsS+4GxGt/4L9+eGU2RIZQjeEhhIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 098/125] net/sched: act_ct: remove and free nf_table callbacks
Date:   Thu, 22 Jul 2021 18:31:29 +0200
Message-Id: <20210722155627.952316310@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

commit 77ac5e40c44eb78333fbc38482d61fc2af7dda0a upstream.

When cleaning up the nf_table in tcf_ct_flow_table_cleanup_work
there is no guarantee that the callback list, added to by
nf_flow_table_offload_add_cb, is empty. This means that it is
possible that the flow_block_cb memory allocated will be lost.

Fix this by iterating the list and freeing the flow_block_cb entries
before freeing the nf_table entry (via freeing ct_ft).

Fixes: 978703f42549 ("netfilter: flowtable: Add API for registering to flow table events")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -320,11 +320,22 @@ err_alloc:
 
 static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
 {
+	struct flow_block_cb *block_cb, *tmp_cb;
 	struct tcf_ct_flow_table *ct_ft;
+	struct flow_block *block;
 
 	ct_ft = container_of(to_rcu_work(work), struct tcf_ct_flow_table,
 			     rwork);
 	nf_flow_table_free(&ct_ft->nf_ft);
+
+	/* Remove any remaining callbacks before cleanup */
+	block = &ct_ft->nf_ft.flow_block;
+	down_write(&ct_ft->nf_ft.flow_block_lock);
+	list_for_each_entry_safe(block_cb, tmp_cb, &block->cb_list, list) {
+		list_del(&block_cb->list);
+		flow_block_cb_free(block_cb);
+	}
+	up_write(&ct_ft->nf_ft.flow_block_lock);
 	kfree(ct_ft);
 
 	module_put(THIS_MODULE);


