Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1997E3D78FB
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 16:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbhG0OvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 10:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232634AbhG0Ot0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 10:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4349E61A61;
        Tue, 27 Jul 2021 14:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627397341;
        bh=fBfP0j7D2+N3WGjep/LhgwnqXbAD8NHyyP4Rj0GWMTg=;
        h=Subject:To:From:Date:From;
        b=xiAfT1vJMuSrLWAaTFIQupP77fe+gupGza4JVq6hpq//5Wj63J8SpY51Zkh9ZdVU1
         lNi+Ugc5ut37JeErN/xnlbvQYS74dHh6696cO0TZnYNKydxIzNSTxWEWQbtIuXsf4T
         JI9qDoyhqKNvt4oqgHU6TT6rGprPDYNOjdDMrDBE=
Subject: patch "virt: acrn: Do hcall_destroy_vm() before resource release" added to char-misc-linus
To:     shuo.a.liu@intel.com, fei1.li@intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Jul 2021 16:48:59 +0200
Message-ID: <1627397339203228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    virt: acrn: Do hcall_destroy_vm() before resource release

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4c4c1257b844ffe5d0933684e612f92c4b78e120 Mon Sep 17 00:00:00 2001
From: Shuo Liu <shuo.a.liu@intel.com>
Date: Thu, 22 Jul 2021 14:27:36 +0800
Subject: virt: acrn: Do hcall_destroy_vm() before resource release

The ACRN hypervisor has scenarios which could run a real-time guest VM.
The real-time guest VM occupies dedicated CPU cores, be assigned with
dedicated PCI devices. It can run without the Service VM after boot up.
hcall_destroy_vm() returns failure when a real-time guest VM refuses.
The clearing of flag ACRN_VM_FLAG_DESTROYED causes some kernel resource
double-freed in a later acrn_vm_destroy().

Do hcall_destroy_vm() before resource release to drop this chance to
destroy the VM if hypercall fails.

Fixes: 9c5137aedd11 ("virt: acrn: Introduce VM management interfaces")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Shuo Liu <shuo.a.liu@intel.com>
Signed-off-by: Fei Li <fei1.li@intel.com>
Link: https://lore.kernel.org/r/20210722062736.15050-1-fei1.li@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/acrn/vm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/virt/acrn/vm.c b/drivers/virt/acrn/vm.c
index 0d002a355a93..fbc9f1042000 100644
--- a/drivers/virt/acrn/vm.c
+++ b/drivers/virt/acrn/vm.c
@@ -64,6 +64,14 @@ int acrn_vm_destroy(struct acrn_vm *vm)
 	    test_and_set_bit(ACRN_VM_FLAG_DESTROYED, &vm->flags))
 		return 0;
 
+	ret = hcall_destroy_vm(vm->vmid);
+	if (ret < 0) {
+		dev_err(acrn_dev.this_device,
+			"Failed to destroy VM %u\n", vm->vmid);
+		clear_bit(ACRN_VM_FLAG_DESTROYED, &vm->flags);
+		return ret;
+	}
+
 	/* Remove from global VM list */
 	write_lock_bh(&acrn_vm_list_lock);
 	list_del_init(&vm->list);
@@ -78,14 +86,6 @@ int acrn_vm_destroy(struct acrn_vm *vm)
 		vm->monitor_page = NULL;
 	}
 
-	ret = hcall_destroy_vm(vm->vmid);
-	if (ret < 0) {
-		dev_err(acrn_dev.this_device,
-			"Failed to destroy VM %u\n", vm->vmid);
-		clear_bit(ACRN_VM_FLAG_DESTROYED, &vm->flags);
-		return ret;
-	}
-
 	acrn_vm_all_ram_unmap(vm);
 
 	dev_dbg(acrn_dev.this_device, "VM %u destroyed.\n", vm->vmid);
-- 
2.32.0


