Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF0136EE9A
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbhD2RH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233329AbhD2RH4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Apr 2021 13:07:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC257613CC;
        Thu, 29 Apr 2021 17:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619716028;
        bh=Im2BTs+NZ9MgErAVLdzpSEJvmzepTd8kdbdul4j8C3U=;
        h=Subject:To:From:Date:From;
        b=yYwEVRCJUquD0RWdSLYguA1vHubKEWVkPg04Sq0kfOAhRuJg14Z+z/mG3TOvpjUHk
         PX/9rqc2RqpYQOBm3AaEPZDchrt3lGoR7GK0eccTTmaBIRFeXNUmcZFFOSK/rCTY66
         yKh9+qWdvao0w4mqYmxuXG7avsj6Slz4hcttKKU8=
Subject: patch "nitro_enclaves: Fix stale file descriptors on failed usercopy" added to char-misc-linus
To:     minipli@grsecurity.net, andraprs@amazon.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 29 Apr 2021 19:07:05 +0200
Message-ID: <16197160251621@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    nitro_enclaves: Fix stale file descriptors on failed usercopy

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f1ce3986baa62cffc3c5be156994de87524bab99 Mon Sep 17 00:00:00 2001
From: Mathias Krause <minipli@grsecurity.net>
Date: Thu, 29 Apr 2021 19:59:41 +0300
Subject: nitro_enclaves: Fix stale file descriptors on failed usercopy

A failing usercopy of the slot uid will lead to a stale entry in the
file descriptor table as put_unused_fd() won't release it. This enables
userland to refer to a dangling 'file' object through that still valid
file descriptor, leading to all kinds of use-after-free exploitation
scenarios.

Exchanging put_unused_fd() for close_fd(), ksys_close() or alike won't
solve the underlying issue, as the file descriptor might have been
replaced in the meantime, e.g. via userland calling close() on it
(leading to a NULL pointer dereference in the error handling code as
'fget(enclave_fd)' will return a NULL pointer) or by dup2()'ing a
completely different file object to that very file descriptor, leading
to the same situation: a dangling file descriptor pointing to a freed
object -- just in this case to a file object of user's choosing.

Generally speaking, after the call to fd_install() the file descriptor
is live and userland is free to do whatever with it. We cannot rely on
it to still refer to our enclave object afterwards. In fact, by abusing
userfaultfd() userland can hit the condition without any racing and
abuse the error handling in the nitro code as it pleases.

To fix the above issues, defer the call to fd_install() until all
possible errors are handled. In this case it's just the usercopy, so do
it directly in ne_create_vm_ioctl() itself.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210429165941.27020-2-andraprs@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 43 +++++++++--------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index f1964ea4b826..e21e1e86ad15 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1524,7 +1524,8 @@ static const struct file_operations ne_enclave_fops = {
  *			  enclave file descriptor to be further used for enclave
  *			  resources handling e.g. memory regions and CPUs.
  * @ne_pci_dev :	Private data associated with the PCI device.
- * @slot_uid:		Generated unique slot id associated with an enclave.
+ * @slot_uid:		User pointer to store the generated unique slot id
+ *			associated with an enclave to.
  *
  * Context: Process context. This function is called with the ne_pci_dev enclave
  *	    mutex held.
@@ -1532,7 +1533,7 @@ static const struct file_operations ne_enclave_fops = {
  * * Enclave fd on success.
  * * Negative return value on failure.
  */
-static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 *slot_uid)
+static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_uid)
 {
 	struct ne_pci_dev_cmd_reply cmd_reply = {};
 	int enclave_fd = -1;
@@ -1634,7 +1635,18 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 *slot_uid)
 
 	list_add(&ne_enclave->enclave_list_entry, &ne_pci_dev->enclaves_list);
 
-	*slot_uid = ne_enclave->slot_uid;
+	if (copy_to_user(slot_uid, &ne_enclave->slot_uid, sizeof(ne_enclave->slot_uid))) {
+		/*
+		 * As we're holding the only reference to 'enclave_file', fput()
+		 * will call ne_enclave_release() which will do a proper cleanup
+		 * of all so far allocated resources, leaving only the unused fd
+		 * for us to free.
+		 */
+		fput(enclave_file);
+		put_unused_fd(enclave_fd);
+
+		return -EFAULT;
+	}
 
 	fd_install(enclave_fd, enclave_file);
 
@@ -1671,34 +1683,13 @@ static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	case NE_CREATE_VM: {
 		int enclave_fd = -1;
-		struct file *enclave_file = NULL;
 		struct ne_pci_dev *ne_pci_dev = ne_devs.ne_pci_dev;
-		int rc = -EINVAL;
-		u64 slot_uid = 0;
+		u64 __user *slot_uid = (void __user *)arg;
 
 		mutex_lock(&ne_pci_dev->enclaves_list_mutex);
-
-		enclave_fd = ne_create_vm_ioctl(ne_pci_dev, &slot_uid);
-		if (enclave_fd < 0) {
-			rc = enclave_fd;
-
-			mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
-
-			return rc;
-		}
-
+		enclave_fd = ne_create_vm_ioctl(ne_pci_dev, slot_uid);
 		mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
 
-		if (copy_to_user((void __user *)arg, &slot_uid, sizeof(slot_uid))) {
-			enclave_file = fget(enclave_fd);
-			/* Decrement file refs to have release() called. */
-			fput(enclave_file);
-			fput(enclave_file);
-			put_unused_fd(enclave_fd);
-
-			return -EFAULT;
-		}
-
 		return enclave_fd;
 	}
 
-- 
2.31.1


