Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA28199206
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730753AbgCaJFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbgCaJFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:05:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDA3120B1F;
        Tue, 31 Mar 2020 09:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645544;
        bh=HUwnqrq5NS8Aru7Yr1JHV40ZkH6FV4vAeoA/+O9P3og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cV4oSBT3Maph4aYQm7V9qxbrYprFy1c7TkQoj64/DI89cgeltPTOwoUaywC2mvNu1
         wsiQh6Zmi1D3qaxraf+H13QzI3mQ+rD9Q+X1zA72loiaicwYpYF6rXgN73sCWBKmNn
         0X6AG3u5H2TsiOy0FjY3S30kz07BU1jr/eMKAOy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 086/170] IB/rdmavt: Free kernel completion queue when done
Date:   Tue, 31 Mar 2020 10:58:20 +0200
Message-Id: <20200331085433.419979338@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit 941224e09483ea3428ffc6402de56a4a2e2cb6da upstream.

When a kernel ULP requests the rdmavt to create a completion queue, it
allocated the queue and set cq->kqueue to point to it. However, when the
completion queue is destroyed, cq->queue is freed instead, leading to a
memory leak:

https://lore.kernel.org/r/215235485.15264050.1583334487658.JavaMail.zimbra@redhat.com

 unreferenced object 0xffffc90006639000 (size 12288):
 comm "kworker/u128:0", pid 8, jiffies 4295777598 (age 589.085s)
    hex dump (first 32 bytes):
      4d 00 00 00 4d 00 00 00 00 c0 08 ac 8b 88 ff ff  M...M...........
      00 00 00 00 80 00 00 00 00 00 00 00 10 00 00 00  ................
    backtrace:
      [<0000000035a3d625>] __vmalloc_node_range+0x361/0x720
      [<000000002942ce4f>] __vmalloc_node.constprop.30+0x63/0xb0
      [<00000000f228f784>] rvt_create_cq+0x98a/0xd80 [rdmavt]
      [<00000000b84aec66>] __ib_alloc_cq_user+0x281/0x1260 [ib_core]
      [<00000000ef3764be>] nvme_rdma_cm_handler+0xdb7/0x1b80 [nvme_rdma]
      [<00000000936b401c>] cma_cm_event_handler+0xb7/0x550 [rdma_cm]
      [<00000000d9c40b7b>] addr_handler+0x195/0x310 [rdma_cm]
      [<00000000c7398a03>] process_one_req+0xdd/0x600 [ib_core]
      [<000000004d29675b>] process_one_work+0x920/0x1740
      [<00000000efedcdb5>] worker_thread+0x87/0xb40
      [<000000005688b340>] kthread+0x327/0x3f0
      [<0000000043a168d6>] ret_from_fork+0x3a/0x50

This patch fixes the issue by freeing cq->kqueue instead.

Fixes: 239b0e52d8aa ("IB/hfi1: Move rvt_cq_wc struct into uapi directory")
Link: https://lore.kernel.org/r/20200313123957.14343.43879.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org> # 5.4.x
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/sw/rdmavt/cq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -327,7 +327,7 @@ void rvt_destroy_cq(struct ib_cq *ibcq,
 	if (cq->ip)
 		kref_put(&cq->ip->ref, rvt_release_mmap_info);
 	else
-		vfree(cq->queue);
+		vfree(cq->kqueue);
 }
 
 /**


