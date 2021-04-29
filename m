Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657C536EE79
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240803AbhD2RAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:00:51 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:10516 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbhD2RAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:00:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619715604; x=1651251604;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=36NT0ag+PSZSNAfEleywXJUlZYv9YutgKNtt3fuQsnM=;
  b=SQr1Q4EQxhuA8YWdxnCLLw3rrpDax4+fvo5mVKMVtyV63VPn0+fLXKua
   0EcXlOT52zlDD1pYPeJX2QpShuhwQFPpeu4ivEi6UMKTZO6i6tZjjORCl
   ESjwAzzf2n1zhrgqHiz+dpR+J1PDPa6jrUovmF+X3h+6fBEEy1aQw1nmk
   8=;
X-IronPort-AV: E=Sophos;i="5.82,259,1613433600"; 
   d="scan'208";a="930133175"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 29 Apr 2021 16:59:56 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id 6478EC42CB;
        Thu, 29 Apr 2021 16:59:55 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.85) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 16:59:51 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Mathias Krause <minipli@grsecurity.net>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        stable <stable@vger.kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v1 1/1] nitro_enclaves: Fix stale file descriptors on failed usercopy
Date:   Thu, 29 Apr 2021 19:59:41 +0300
Message-ID: <20210429165941.27020-2-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20210429165941.27020-1-andraprs@amazon.com>
References: <20210429165941.27020-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D11UWC003.ant.amazon.com (10.43.162.162) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Krause <minipli@grsecurity.net>

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
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 43 +++++++++--------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index f1964ea4b8269..e21e1e86ad15f 100644
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
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

