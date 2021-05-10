Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DE0378565
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhEJLAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234133AbhEJKz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCE5E60FEF;
        Mon, 10 May 2021 10:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643451;
        bh=DkoOxMJz8YpuchWQL/RtRgbH0rxYa/FDFDv2JcYcdZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5uIK4YMhnN5vFLbHyQc6fYSUtQUigP5caFxMfPJJfMTM6vivbM1hhezcnjbUyssz
         8Dczj4LKSG8+cps9TB9qn94zD5Bmr7jGgM86SjIYkFaBz336DbgruqZXEO5bsR/mSF
         1hrc87Qvgc8yCER59A7qDqtYkqXO8qEEsYPyy6bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH 5.11 006/342] nitro_enclaves: Fix stale file descriptors on failed usercopy
Date:   Mon, 10 May 2021 12:16:36 +0200
Message-Id: <20210510102010.311209337@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Krause <minipli@grsecurity.net>

commit f1ce3986baa62cffc3c5be156994de87524bab99 upstream.

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
 drivers/virt/nitro_enclaves/ne_misc_dev.c |   43 +++++++++++-------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1524,7 +1524,8 @@ static const struct file_operations ne_e
  *			  enclave file descriptor to be further used for enclave
  *			  resources handling e.g. memory regions and CPUs.
  * @ne_pci_dev :	Private data associated with the PCI device.
- * @slot_uid:		Generated unique slot id associated with an enclave.
+ * @slot_uid:		User pointer to store the generated unique slot id
+ *			associated with an enclave to.
  *
  * Context: Process context. This function is called with the ne_pci_dev enclave
  *	    mutex held.
@@ -1532,7 +1533,7 @@ static const struct file_operations ne_e
  * * Enclave fd on success.
  * * Negative return value on failure.
  */
-static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 *slot_uid)
+static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_uid)
 {
 	struct ne_pci_dev_cmd_reply cmd_reply = {};
 	int enclave_fd = -1;
@@ -1634,7 +1635,18 @@ static int ne_create_vm_ioctl(struct ne_
 
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
 
@@ -1671,34 +1683,13 @@ static long ne_ioctl(struct file *file,
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
 


