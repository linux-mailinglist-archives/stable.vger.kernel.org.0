Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262B126144C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbgIHQMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731509AbgIHQLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB1802473A;
        Tue,  8 Sep 2020 15:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580240;
        bh=DITzt/B9wNHVJdDb3h4cpYhPbS/qe4lFuDYNaO76Dkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPWOmyTFe9cngLfmnkUh0U0KADhC0frP5RTuIldIhgSFkuBIdT5zzyeb3DiYqJ3ri
         gNh+Uo81PCKLhqIB3e0Obmhog6OoBCN03tF4buNwI8Qci57TUvjbPgaZsqLgEIsZrt
         wp6sh9hUNL2GqKQT2TB5yOoUa4w3rvqUP9v9R0jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 86/88] mm/hugetlb: fix a race between hugetlb sysctl handlers
Date:   Tue,  8 Sep 2020 17:26:27 +0200
Message-Id: <20200908152225.498997627@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 17743798d81238ab13050e8e2833699b54e15467 upstream.

There is a race between the assignment of `table->data` and write value
to the pointer of `table->data` in the __do_proc_doulongvec_minmax() on
the other thread.

  CPU0:                                 CPU1:
                                        proc_sys_write
  hugetlb_sysctl_handler                  proc_sys_call_handler
  hugetlb_sysctl_handler_common             hugetlb_sysctl_handler
    table->data = &tmp;                       hugetlb_sysctl_handler_common
                                                table->data = &tmp;
      proc_doulongvec_minmax
        do_proc_doulongvec_minmax           sysctl_head_finish
          __do_proc_doulongvec_minmax         unuse_table
            i = table->data;
            *i = val;  // corrupt CPU1's stack

Fix this by duplicating the `table`, and only update the duplicate of
it.  And introduce a helper of proc_hugetlb_doulongvec_minmax() to
simplify the code.

The following oops was seen:

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    #PF: supervisor instruction fetch in kernel mode
    #PF: error_code(0x0010) - not-present page
    Code: Bad RIP value.
    ...
    Call Trace:
     ? set_max_huge_pages+0x3da/0x4f0
     ? alloc_pool_huge_page+0x150/0x150
     ? proc_doulongvec_minmax+0x46/0x60
     ? hugetlb_sysctl_handler_common+0x1c7/0x200
     ? nr_hugepages_store+0x20/0x20
     ? copy_fd_bitmaps+0x170/0x170
     ? hugetlb_sysctl_handler+0x1e/0x20
     ? proc_sys_call_handler+0x2f1/0x300
     ? unregister_sysctl_table+0xb0/0xb0
     ? __fd_install+0x78/0x100
     ? proc_sys_write+0x14/0x20
     ? __vfs_write+0x4d/0x90
     ? vfs_write+0xef/0x240
     ? ksys_write+0xc0/0x160
     ? __ia32_sys_read+0x50/0x50
     ? __close_fd+0x129/0x150
     ? __x64_sys_write+0x43/0x50
     ? do_syscall_64+0x6c/0x200
     ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: e5ff215941d5 ("hugetlb: multiple hstates for multiple page sizes")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/20200828031146.43035-1-songmuchun@bytedance.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2918,6 +2918,22 @@ static unsigned int cpuset_mems_nr(unsig
 }
 
 #ifdef CONFIG_SYSCTL
+static int proc_hugetlb_doulongvec_minmax(struct ctl_table *table, int write,
+					  void *buffer, size_t *length,
+					  loff_t *ppos, unsigned long *out)
+{
+	struct ctl_table dup_table;
+
+	/*
+	 * In order to avoid races with __do_proc_doulongvec_minmax(), we
+	 * can duplicate the @table and alter the duplicate of it.
+	 */
+	dup_table = *table;
+	dup_table.data = out;
+
+	return proc_doulongvec_minmax(&dup_table, write, buffer, length, ppos);
+}
+
 static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
 			 struct ctl_table *table, int write,
 			 void __user *buffer, size_t *length, loff_t *ppos)
@@ -2929,9 +2945,8 @@ static int hugetlb_sysctl_handler_common
 	if (!hugepages_supported())
 		return -EOPNOTSUPP;
 
-	table->data = &tmp;
-	table->maxlen = sizeof(unsigned long);
-	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
+					     &tmp);
 	if (ret)
 		goto out;
 
@@ -2975,9 +2990,8 @@ int hugetlb_overcommit_handler(struct ct
 	if (write && hstate_is_gigantic(h))
 		return -EINVAL;
 
-	table->data = &tmp;
-	table->maxlen = sizeof(unsigned long);
-	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
+					     &tmp);
 	if (ret)
 		goto out;
 


