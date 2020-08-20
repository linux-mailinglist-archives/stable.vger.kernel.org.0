Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBA724ABBD
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgHTAM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbgHTABh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:01:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A4DB207DA;
        Thu, 20 Aug 2020 00:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881696;
        bh=8hxAY/ez0AI4ber36LIJeoh29mu4g8ODN0OrS542L3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2JxtcBJ8KWGLihK4aQn5GzqgN8kWFC08BI9co6wU3v8H6j1Prq1YP8LDX12b8Vkf
         7eDVjrs0yjyTcmunz7jZwypv74NQB4epXLDDalOrdIzBMM6UAUIP2wtkNTE63X5NIF
         jnK+YDZkMjZTkGluzH5h6Vj9N0bOIEJO8kMoAodk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 15/27] riscv: Fixup static_obj() fail
Date:   Wed, 19 Aug 2020 20:01:04 -0400
Message-Id: <20200820000116.214821-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000116.214821-1-sashal@kernel.org>
References: <20200820000116.214821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 6184358da0004c8fd940afda6c0a0fa4027dc911 ]

When enable LOCKDEP, static_obj() will cause error. Because some
__initdata static variables is before _stext:

static int static_obj(const void *obj)
{
        unsigned long start = (unsigned long) &_stext,
                      end   = (unsigned long) &_end,
                      addr  = (unsigned long) obj;

        /*
         * static variable?
         */
        if ((addr >= start) && (addr < end))
                return 1;

[    0.067192] INFO: trying to register non-static key.
[    0.067325] the code is fine but needs lockdep annotation.
[    0.067449] turning off the locking correctness validator.
[    0.067718] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.7.0-rc7-dirty #44
[    0.067945] Call Trace:
[    0.068369] [<ffffffe00020323c>] walk_stackframe+0x0/0xa4
[    0.068506] [<ffffffe000203422>] show_stack+0x2a/0x34
[    0.068631] [<ffffffe000521e4e>] dump_stack+0x94/0xca
[    0.068757] [<ffffffe000255a4e>] register_lock_class+0x5b8/0x5bc
[    0.068969] [<ffffffe000255abe>] __lock_acquire+0x6c/0x1d5c
[    0.069101] [<ffffffe0002550fe>] lock_acquire+0xae/0x312
[    0.069228] [<ffffffe000989a8e>] _raw_spin_lock_irqsave+0x40/0x5a
[    0.069357] [<ffffffe000247c64>] complete+0x1e/0x50
[    0.069479] [<ffffffe000984c38>] rest_init+0x1b0/0x28a
[    0.069660] [<ffffffe0000016a2>] 0xffffffe0000016a2
[    0.069779] [<ffffffe000001b84>] 0xffffffe000001b84
[    0.069953] [<ffffffe000001092>] 0xffffffe000001092

static __initdata DECLARE_COMPLETION(kthreadd_done);

noinline void __ref rest_init(void)
{
	...
	complete(&kthreadd_done);

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vmlinux.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
index e6f8016b366ab..f3586e31ed1ec 100644
--- a/arch/riscv/kernel/vmlinux.lds.S
+++ b/arch/riscv/kernel/vmlinux.lds.S
@@ -22,6 +22,7 @@ SECTIONS
 	/* Beginning of code and text segment */
 	. = LOAD_OFFSET;
 	_start = .;
+	_stext = .;
 	HEAD_TEXT_SECTION
 	. = ALIGN(PAGE_SIZE);
 
@@ -54,7 +55,6 @@ SECTIONS
 	. = ALIGN(SECTION_ALIGN);
 	.text : {
 		_text = .;
-		_stext = .;
 		TEXT_TEXT
 		SCHED_TEXT
 		CPUIDLE_TEXT
-- 
2.25.1

