Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA044173E3
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345357AbhIXNA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345701AbhIXM6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0369B61361;
        Fri, 24 Sep 2021 12:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487982;
        bh=6Rrl62s6MkNSLkZIoXINl/lsIeY3OEoaroy+jfICprk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ii0XlXc69Lln+5DrZJZT+qZssa7Vivt5oTCTeKVU0X/eo7niEAx9QYlNCB+sB2Tl1
         PvtdE8LFfwD2Ut/cRBpVct1g+l5upGG/BbjQY65OksbctaN5+7flMEWcZpv7n4ZWp+
         Fnmwu7S6Oj0YhTYg+HLuTw5k45PBsWMA6zumiegQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, QiuXi <qiuxi1@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 006/100] coredump: fix memleak in dump_vma_snapshot()
Date:   Fri, 24 Sep 2021 14:43:15 +0200
Message-Id: <20210924124341.681985553@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: QiuXi <qiuxi1@huawei.com>

commit 6fcac87e1f9e5b27805a2a404f4849194bb51de8 upstream.

dump_vma_snapshot() allocs memory for *vma_meta, when dump_vma_snapshot()
returns -EFAULT, the memory will be leaked, so we free it correctly.

Link: https://lkml.kernel.org/r/20210810020441.62806-1-qiuxi1@huawei.com
Fixes: a07279c9a8cd7 ("binfmt_elf, binfmt_elf_fdpic: use a VMA list snapshot")
Signed-off-by: QiuXi <qiuxi1@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1127,8 +1127,10 @@ int dump_vma_snapshot(struct coredump_pa
 
 	mmap_write_unlock(mm);
 
-	if (WARN_ON(i != *vma_count))
+	if (WARN_ON(i != *vma_count)) {
+		kvfree(*vma_meta);
 		return -EFAULT;
+	}
 
 	*vma_data_size_ptr = vma_data_size;
 	return 0;


