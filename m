Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF0022B3C9
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 18:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbgGWQlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 12:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbgGWQlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 12:41:10 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FD0C0619E2
        for <stable@vger.kernel.org>; Thu, 23 Jul 2020 09:41:10 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x8so2785293plm.10
        for <stable@vger.kernel.org>; Thu, 23 Jul 2020 09:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A87XLVT/mwoYsvUu3DQEbPXgKLDgFyVKudNGLFIute8=;
        b=jlxOywcTtoxg7VnVQd+GGm0eocelog5HelcNWqoiS+UWYW/Swqth1cDfbuP3Ey14L3
         wslTbcMU/8ADRhayIDDNrcR+FkjrKps6EB1HgR8jCi59hBrieadyYBtOSBtEqF2FQ33B
         XgPTQ8ZSnErY/PuNFnE/0eH+CXcYR4YcmEdmsuczlz1QLhM9QNwHRcYRKYrPJxsGIXRU
         5XVQfuDI0K2U410PtfNcqlSRbCseOGCbpHrfyfmVdh2qdNoxxttkFaGE8qfNOB+zsg19
         oVdh86jzbDFAqoxb3+jxJvT7a0gonsoxMX+0eBrJFtfyMzrw5eJP6TJE0Hclr9S0qB4s
         07nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A87XLVT/mwoYsvUu3DQEbPXgKLDgFyVKudNGLFIute8=;
        b=duoeMIJi7dzua6LxMu1sLqCnZSQ/V/YKuZnZRZl7xKDUgRbnqb8QiUaaECeg5YAwg0
         62ivRxejXzvA97JGy9KAI7/age4qR58ju5eY5CfSjLWKHEzXc7ddALQz1ZVO/9PCzic+
         29AWN7cXHoZ/9/lFZib7XI3G079CNUQGvz09gU8w5lJd8lBXtVQLI2xohSi5UFuLX0WD
         1dto8yCZM4tJKWLxK+uRoC/D1N8GbghenecjY2nU37dObIDkroB7k2DfKeq4vmIoBqb6
         Jk02nU37qDcEjgrxwVCbDtr3Rqt8Jo+mjJwL5OXQQATfTE82pP5WPuILQCmeDey6ggKk
         PLCg==
X-Gm-Message-State: AOAM532V+A1D9deo7F53xTn786c6wf4i2VrAOjbld1qUqey6Kw53Rayz
        4cw+sFunhjUXY6S2dlDglHcTTdHP9gQ=
X-Google-Smtp-Source: ABdhPJwzTf4e6heWCDhaHQdak+Ge7nlIwCERw/hbZgSZyW4A+RU3FCzwW58/6Y0APc0t2UM5sl/kvQ==
X-Received: by 2002:a17:902:6901:: with SMTP id j1mr4362215plk.203.1595522469019;
        Thu, 23 Jul 2020 09:41:09 -0700 (PDT)
Received: from nagraj.local ([49.206.21.239])
        by smtp.gmail.com with ESMTPSA id o128sm3464139pfg.127.2020.07.23.09.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 09:41:07 -0700 (PDT)
From:   Sumit Semwal <sumit.semwal@linaro.org>
To:     stable@vger.kernel.org
Cc:     Charan Teja Kalla <charante@codeaurora.org>,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH for v5.4.y] dmabuf: use spinlock to access dmabuf->name
Date:   Thu, 23 Jul 2020 22:10:56 +0530
Message-Id: <20200723164056.4645-1-sumit.semwal@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charan Teja Kalla <charante@codeaurora.org>

 [commit 6348dd291e3653534a9e28e6917569bc9967b35b upstream]

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
 [sumits: reworked for 5.4.y]
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 drivers/dma-buf/dma-buf.c | 11 +++++++----
 include/linux/dma-buf.h   |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index cf65a47310c3..eba7e3fe769c 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -45,10 +45,10 @@ static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
 	size_t ret = 0;
 
 	dmabuf = dentry->d_fsdata;
-	mutex_lock(&dmabuf->lock);
+	spin_lock(&dmabuf->name_lock);
 	if (dmabuf->name)
 		ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
-	mutex_unlock(&dmabuf->lock);
+	spin_unlock(&dmabuf->name_lock);
 
 	return dynamic_dname(dentry, buffer, buflen, "/%s:%s",
 			     dentry->d_name.name, ret > 0 ? name : "");
@@ -338,8 +338,10 @@ static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
 		kfree(name);
 		goto out_unlock;
 	}
+	spin_lock(&dmabuf->name_lock);
 	kfree(dmabuf->name);
 	dmabuf->name = name;
+	spin_unlock(&dmabuf->name_lock);
 
 out_unlock:
 	mutex_unlock(&dmabuf->lock);
@@ -402,10 +404,10 @@ static void dma_buf_show_fdinfo(struct seq_file *m, struct file *file)
 	/* Don't count the temporary reference taken inside procfs seq_show */
 	seq_printf(m, "count:\t%ld\n", file_count(dmabuf->file) - 1);
 	seq_printf(m, "exp_name:\t%s\n", dmabuf->exp_name);
-	mutex_lock(&dmabuf->lock);
+	spin_lock(&dmabuf->name_lock);
 	if (dmabuf->name)
 		seq_printf(m, "name:\t%s\n", dmabuf->name);
-	mutex_unlock(&dmabuf->lock);
+	spin_unlock(&dmabuf->name_lock);
 }
 
 static const struct file_operations dma_buf_fops = {
@@ -537,6 +539,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	dmabuf->size = exp_info->size;
 	dmabuf->exp_name = exp_info->exp_name;
 	dmabuf->owner = exp_info->owner;
+	spin_lock_init(&dmabuf->name_lock);
 	init_waitqueue_head(&dmabuf->poll);
 	dmabuf->cb_excl.poll = dmabuf->cb_shared.poll = &dmabuf->poll;
 	dmabuf->cb_excl.active = dmabuf->cb_shared.active = 0;
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index ec212cb27fdc..12eac4293af6 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -303,6 +303,7 @@ struct dma_buf {
 	void *vmap_ptr;
 	const char *exp_name;
 	const char *name;
+	spinlock_t name_lock; /* spinlock to protect name access */
 	struct module *owner;
 	struct list_head list_node;
 	void *priv;
-- 
2.27.0

