Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3D73F9ADE
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 16:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245329AbhH0O1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 10:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233282AbhH0O1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 10:27:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2846860F45;
        Fri, 27 Aug 2021 14:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630074378;
        bh=D3KlkH5hwBfnX+9PA3HGGmFL4S7jl0eUpqzi1MQVdY8=;
        h=Subject:To:From:Date:From;
        b=WuDKdQ30ly8OiGM2+7nxEU6dag2Ep/3Q16iyCe15BtgmoE/JGf2ZP9ml5lFbVFTBN
         RSc5/VlecNKGDKBLqaDJEq9FOnRTqIZq7ZdC1PfPbI5cmDnuVODVrfhP3KT3lxRgON
         LJ++mNYqvlKRImmOdEGMGuPcFAq8TZgpd7dBm6m4=
Subject: patch "VMCI: fix NULL pointer dereference when unmapping queue pair" added to char-misc-testing
To:     wanghai38@huawei.com, gregkh@linuxfoundation.org,
        hulkci@huawei.com, jhansen@vmware.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 27 Aug 2021 16:26:04 +0200
Message-ID: <1630074364366@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    VMCI: fix NULL pointer dereference when unmapping queue pair

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From a30dc6cf0dc51419021550152e435736aaef8799 Mon Sep 17 00:00:00 2001
From: Wang Hai <wanghai38@huawei.com>
Date: Wed, 18 Aug 2021 20:48:45 +0800
Subject: VMCI: fix NULL pointer dereference when unmapping queue pair

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
 drivers/misc/vmw_vmci/vmci_queue_pair.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index 880c33ab9f47..94ebf7f3fd58 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -2243,7 +2243,8 @@ int vmci_qp_broker_map(struct vmci_handle handle,
 
 	result = VMCI_SUCCESS;
 
-	if (context_id != VMCI_HOST_CONTEXT_ID) {
+	if (context_id != VMCI_HOST_CONTEXT_ID &&
+	    !QPBROKERSTATE_HAS_MEM(entry)) {
 		struct vmci_qp_page_store page_store;
 
 		page_store.pages = guest_mem;
@@ -2350,7 +2351,8 @@ int vmci_qp_broker_unmap(struct vmci_handle handle,
 		goto out;
 	}
 
-	if (context_id != VMCI_HOST_CONTEXT_ID) {
+	if (context_id != VMCI_HOST_CONTEXT_ID &&
+	    QPBROKERSTATE_HAS_MEM(entry)) {
 		qp_acquire_queue_mutex(entry->produce_q);
 		result = qp_save_headers(entry);
 		if (result < VMCI_SUCCESS)
-- 
2.32.0


