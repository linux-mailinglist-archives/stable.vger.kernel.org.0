Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DFD226800
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388521AbgGTQQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388535AbgGTQQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:16:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ED4E2064B;
        Mon, 20 Jul 2020 16:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261783;
        bh=xz0NRadDYyfXdGb2SLxQ9ztVsQFjGKCquql/x+dk9no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYd71jUQN2eknvfsl9V8ewvgPbsy6nA6V7W6ghse24ocro3TqghdgygNRy8F5ZP0/
         zxbQEjPokUSeZUnlnA5GvDWIZQffCxxc1LKAp6Wg5o0Ysktm9WvjMf+yQlvd/FIlb1
         s8QJUbzCMCEGbrGIujZ9p3nvmbW2493Y0Jq+vT90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charan Teja Kalla <charante@codeaurora.org>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 5.7 210/244] dmabuf: use spinlock to access dmabuf->name
Date:   Mon, 20 Jul 2020 17:38:01 +0200
Message-Id: <20200720152835.839478322@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charan Teja Kalla <charante@codeaurora.org>

commit 6348dd291e3653534a9e28e6917569bc9967b35b upstream.

There exists a sleep-while-atomic bug while accessing the dmabuf->name
under mutex in the dmabuffs_dname(). This is caused from the SELinux
permissions checks on a process where it tries to validate the inherited
files from fork() by traversing them through iterate_fd() (which
traverse files under spin_lock) and call
match_file(security/selinux/hooks.c) where the permission checks happen.
This audit information is logged using dump_common_audit_data() where it
calls d_path() to get the file path name. If the file check happen on
the dmabuf's fd, then it ends up in ->dmabuffs_dname() and use mutex to
access dmabuf->name. The flow will be like below:
flush_unauthorized_files()
  iterate_fd()
    spin_lock() --> Start of the atomic section.
      match_file()
        file_has_perm()
          avc_has_perm()
            avc_audit()
              slow_avc_audit()
	        common_lsm_audit()
		  dump_common_audit_data()
		    audit_log_d_path()
		      d_path()
                        dmabuffs_dname()
                          mutex_lock()--> Sleep while atomic.

Call trace captured (on 4.19 kernels) is below:
___might_sleep+0x204/0x208
__might_sleep+0x50/0x88
__mutex_lock_common+0x5c/0x1068
__mutex_lock_common+0x5c/0x1068
mutex_lock_nested+0x40/0x50
dmabuffs_dname+0xa0/0x170
d_path+0x84/0x290
audit_log_d_path+0x74/0x130
common_lsm_audit+0x334/0x6e8
slow_avc_audit+0xb8/0xf8
avc_has_perm+0x154/0x218
file_has_perm+0x70/0x180
match_file+0x60/0x78
iterate_fd+0x128/0x168
selinux_bprm_committing_creds+0x178/0x248
security_bprm_committing_creds+0x30/0x48
install_exec_creds+0x1c/0x68
load_elf_binary+0x3a4/0x14e0
search_binary_handler+0xb0/0x1e0

So, use spinlock to access dmabuf->name to avoid sleep-while-atomic.

Cc: <stable@vger.kernel.org> [5.3+]
Signed-off-by: Charan Teja Kalla <charante@codeaurora.org>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Acked-by: Christian König <christian.koenig@amd.com>
 [sumits: added comment to spinlock_t definition to avoid warning]
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/a83e7f0d-4e54-9848-4b58-e1acdbe06735@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma-buf/dma-buf.c |   11 +++++++----
 include/linux/dma-buf.h   |    1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -45,10 +45,10 @@ static char *dmabuffs_dname(struct dentr
 	size_t ret = 0;
 
 	dmabuf = dentry->d_fsdata;
-	dma_resv_lock(dmabuf->resv, NULL);
+	spin_lock(&dmabuf->name_lock);
 	if (dmabuf->name)
 		ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
-	dma_resv_unlock(dmabuf->resv);
+	spin_unlock(&dmabuf->name_lock);
 
 	return dynamic_dname(dentry, buffer, buflen, "/%s:%s",
 			     dentry->d_name.name, ret > 0 ? name : "");
@@ -338,8 +338,10 @@ static long dma_buf_set_name(struct dma_
 		kfree(name);
 		goto out_unlock;
 	}
+	spin_lock(&dmabuf->name_lock);
 	kfree(dmabuf->name);
 	dmabuf->name = name;
+	spin_unlock(&dmabuf->name_lock);
 
 out_unlock:
 	dma_resv_unlock(dmabuf->resv);
@@ -402,10 +404,10 @@ static void dma_buf_show_fdinfo(struct s
 	/* Don't count the temporary reference taken inside procfs seq_show */
 	seq_printf(m, "count:\t%ld\n", file_count(dmabuf->file) - 1);
 	seq_printf(m, "exp_name:\t%s\n", dmabuf->exp_name);
-	dma_resv_lock(dmabuf->resv, NULL);
+	spin_lock(&dmabuf->name_lock);
 	if (dmabuf->name)
 		seq_printf(m, "name:\t%s\n", dmabuf->name);
-	dma_resv_unlock(dmabuf->resv);
+	spin_unlock(&dmabuf->name_lock);
 }
 
 static const struct file_operations dma_buf_fops = {
@@ -542,6 +544,7 @@ struct dma_buf *dma_buf_export(const str
 	dmabuf->size = exp_info->size;
 	dmabuf->exp_name = exp_info->exp_name;
 	dmabuf->owner = exp_info->owner;
+	spin_lock_init(&dmabuf->name_lock);
 	init_waitqueue_head(&dmabuf->poll);
 	dmabuf->cb_excl.poll = dmabuf->cb_shared.poll = &dmabuf->poll;
 	dmabuf->cb_excl.active = dmabuf->cb_shared.active = 0;
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -311,6 +311,7 @@ struct dma_buf {
 	void *vmap_ptr;
 	const char *exp_name;
 	const char *name;
+	spinlock_t name_lock; /* spinlock to protect name access */
 	struct module *owner;
 	struct list_head list_node;
 	void *priv;


