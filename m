Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D301DE9F4
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbgEVOvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731073AbgEVOvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:51:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2F7922256;
        Fri, 22 May 2020 14:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159099;
        bh=waFAhGRwJOXLSjK9UhugYgte+02Okn+Sg08IvdhcZQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTD3hLMFVPlCv+zGr1wkL83CBlhxOU6fbigDeg1CJ9S9tqi6iimM9SkPYv1Bt+M23
         sOSTGxotcW8LiJZ95W6nF5NKlD0nFBCoovsJ8sNb1GeeJzhRMkKcwtJxaQtNcAXH8Z
         LJ85iRN/ZbdecpQcAUMKTe1D/rCs1e/8a92NBwRU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 17/19] riscv: stacktrace: Fix undefined reference to `walk_stackframe'
Date:   Fri, 22 May 2020 10:51:18 -0400
Message-Id: <20200522145120.434921-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145120.434921-1-sashal@kernel.org>
References: <20200522145120.434921-1-sashal@kernel.org>
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
index a4b1d94371a0..74b2168d7298 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -75,7 +75,7 @@ static void notrace walk_stackframe(struct task_struct *task,
 
 #else /* !CONFIG_FRAME_POINTER */
 
-static void notrace walk_stackframe(struct task_struct *task,
+void notrace walk_stackframe(struct task_struct *task,
 	struct pt_regs *regs, bool (*fn)(unsigned long, void *), void *arg)
 {
 	unsigned long sp, pc;
-- 
2.25.1

