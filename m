Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58BE1A9D74
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405961AbgDOLnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897544AbgDOLnu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D123F20775;
        Wed, 15 Apr 2020 11:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951029;
        bh=8Zkwt3Nxc5a6mdUgf20I8irYrlccMGLwx42I/QawL/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaizbATumPpqTER0cHRfxfEuEzj61wXwSP/JgVoWkPWZwdigOKXUv8AsGXJNl8dE4
         IXQWOOCOCIj2vuqzoh1faXNL27yxEDHgQt2gos8WzqkeawKmBYW8w1QHVfL0wbB797
         qaoXoNzbVG58ueTWlfBdPemSnJjdewOATOUyCDsk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Andrew Morton <akpm@linux-foundation.org>,
        Marco Elver <elver@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 068/106] percpu_counter: fix a data race at vm_committed_as
Date:   Wed, 15 Apr 2020 07:41:48 -0400
Message-Id: <20200415114226.13103-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 7e2345200262e4a6056580f0231cccdaffc825f3 ]

"vm_committed_as.count" could be accessed concurrently as reported by
KCSAN,

 BUG: KCSAN: data-race in __vm_enough_memory / percpu_counter_add_batch

 write to 0xffffffff9451c538 of 8 bytes by task 65879 on cpu 35:
  percpu_counter_add_batch+0x83/0xd0
  percpu_counter_add_batch at lib/percpu_counter.c:91
  __vm_enough_memory+0xb9/0x260
  dup_mm+0x3a4/0x8f0
  copy_process+0x2458/0x3240
  _do_fork+0xaa/0x9f0
  __do_sys_clone+0x125/0x160
  __x64_sys_clone+0x70/0x90
  do_syscall_64+0x91/0xb05
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 read to 0xffffffff9451c538 of 8 bytes by task 66773 on cpu 19:
  __vm_enough_memory+0x199/0x260
  percpu_counter_read_positive at include/linux/percpu_counter.h:81
  (inlined by) __vm_enough_memory at mm/util.c:839
  mmap_region+0x1b2/0xa10
  do_mmap+0x45c/0x700
  vm_mmap_pgoff+0xc0/0x130
  ksys_mmap_pgoff+0x6e/0x300
  __x64_sys_mmap+0x33/0x40
  do_syscall_64+0x91/0xb05
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The read is outside percpu_counter::lock critical section which results in
a data race.  Fix it by adding a READ_ONCE() in
percpu_counter_read_positive() which could also service as the existing
compiler memory barrier.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Marco Elver <elver@google.com>
Link: http://lkml.kernel.org/r/1582302724-2804-1-git-send-email-cai@lca.pw
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/percpu_counter.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 4f052496cdfd7..0a4f54dd4737b 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -78,9 +78,9 @@ static inline s64 percpu_counter_read(struct percpu_counter *fbc)
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	/* Prevent reloads of fbc->count */
+	s64 ret = READ_ONCE(fbc->count);
 
-	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
 		return ret;
 	return 0;
-- 
2.20.1

