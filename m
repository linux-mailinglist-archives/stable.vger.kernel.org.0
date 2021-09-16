Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3B940DF48
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhIPQIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232392AbhIPQHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:07:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC86661351;
        Thu, 16 Sep 2021 16:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808378;
        bh=QlJJ9g6oDafpKf1UXnmxpl/ubm3+gpg3qtxl0d4dDoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ah9FwbcPhEusaHGByZoAOr3q1ccd2bVuQ0zNRYbnCfkDeBcmyPcV43fqle6CW/JTb
         4FWyKunft784OnMxeEpUbz9I9LeUOozQ4R+Xl2J18+eHgVc7d6IncDZt3K0Yk4psth
         x8IGKfPdidFMTKaYxtFOrK4YUDqK1i4NeRDsY8k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Wang Hai <wanghai38@huawei.com>
Subject: [PATCH 5.10 036/306] VMCI: fix NULL pointer dereference when unmapping queue pair
Date:   Thu, 16 Sep 2021 17:56:21 +0200
Message-Id: <20210916155755.178000563@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

commit a30dc6cf0dc51419021550152e435736aaef8799 upstream.

I got a NULL pointer dereference report when doing fuzz test:

Call Trace:
  qp_release_pages+0xae/0x130
  qp_host_unregister_user_memory.isra.25+0x2d/0x80
  vmci_qp_broker_unmap+0x191/0x320
  ? vmci_host_do_alloc_queuepair.isra.9+0x1c0/0x1c0
  vmci_host_unlocked_ioctl+0x59f/0xd50
  ? do_vfs_ioctl+0x14b/0xa10
  ? tomoyo_file_ioctl+0x28/0x30
  ? vmci_host_do_alloc_queuepair.isra.9+0x1c0/0x1c0
  __x64_sys_ioctl+0xea/0x120
  do_syscall_64+0x34/0xb0
  entry_SYSCALL_64_after_hwframe+0x44/0xae

When a queue pair is created by the following call, it will not
register the user memory if the page_store is NULL, and the
entry->state will be set to VMCIQPB_CREATED_NO_MEM.

vmci_host_unlocked_ioctl
  vmci_host_do_alloc_queuepair
    vmci_qp_broker_alloc
      qp_broker_alloc
        qp_broker_create // set entry->state = VMCIQPB_CREATED_NO_MEM;

When unmapping this queue pair, qp_host_unregister_user_memory() will
be called to unregister the non-existent user memory, which will
result in a null pointer reference. It will also change
VMCIQPB_CREATED_NO_MEM to VMCIQPB_CREATED_MEM, which should not be
present in this operation.

Only when the qp broker has mem, it can unregister the user
memory when unmapping the qp broker.

Only when the qp broker has no mem, it can register the user
memory when mapping the qp broker.

Fixes: 06164d2b72aa ("VMCI: queue pairs implementation.")
Cc: stable <stable@vger.kernel.org>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20210818124845.488312-1-wanghai38@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_vmci/vmci_queue_pair.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -2238,7 +2238,8 @@ int vmci_qp_broker_map(struct vmci_handl
 
 	result = VMCI_SUCCESS;
 
-	if (context_id != VMCI_HOST_CONTEXT_ID) {
+	if (context_id != VMCI_HOST_CONTEXT_ID &&
+	    !QPBROKERSTATE_HAS_MEM(entry)) {
 		struct vmci_qp_page_store page_store;
 
 		page_store.pages = guest_mem;
@@ -2345,7 +2346,8 @@ int vmci_qp_broker_unmap(struct vmci_han
 		goto out;
 	}
 
-	if (context_id != VMCI_HOST_CONTEXT_ID) {
+	if (context_id != VMCI_HOST_CONTEXT_ID &&
+	    QPBROKERSTATE_HAS_MEM(entry)) {
 		qp_acquire_queue_mutex(entry->produce_q);
 		result = qp_save_headers(entry);
 		if (result < VMCI_SUCCESS)


