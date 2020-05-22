Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5C11DE9B5
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbgEVOud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730722AbgEVOuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:50:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EF2922254;
        Fri, 22 May 2020 14:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159032;
        bh=SSr626oosF3ax4S4mvuIs1Z3CkLSI8JeRhlwsAREDNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiKeZBO/cZUgpeGVryo7owc0OpolwnODK2C6rhEovApjO5fLOdw8agK/Xfys/HuDy
         OAATnKgP3ab9rDv9r0FxkRcgPyRZj9pDiMSGqxB8prkCDFbQHwYm6ASNVbFSjpiYZ3
         /M1iP+ntAc7NWohKkQxHmRp/Pm9JE3gkF7RleOyM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 29/41] riscv: stacktrace: Fix undefined reference to `walk_stackframe'
Date:   Fri, 22 May 2020 10:49:46 -0400
Message-Id: <20200522144959.434379-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522144959.434379-1-sashal@kernel.org>
References: <20200522144959.434379-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 0502bee37cdef755d63eee60236562e5605e2480 ]

Drop static declaration to fix following build error if FRAME_POINTER disabled,
  riscv64-linux-ld: arch/riscv/kernel/perf_callchain.o: in function `.L0':
  perf_callchain.c:(.text+0x2b8): undefined reference to `walk_stackframe'

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 0940681d2f68..19e46f4160cc 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -63,7 +63,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 
 #else /* !CONFIG_FRAME_POINTER */
 
-static void notrace walk_stackframe(struct task_struct *task,
+void notrace walk_stackframe(struct task_struct *task,
 	struct pt_regs *regs, bool (*fn)(unsigned long, void *), void *arg)
 {
 	unsigned long sp, pc;
-- 
2.25.1

