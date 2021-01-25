Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C034304ACE
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbhAZE5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731036AbhAYStQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A95B20679;
        Mon, 25 Jan 2021 18:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600540;
        bh=YRDhHawHPzSnZSitjYPPVI9uapMujMO5D+sYLQsexXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzOrolbAMRrExhaecs6CzoAqT9mZtqaJaEsVu1ecSpPWSLlfemO5W03CYXNvPweLG
         lKU8Xgo4fTKvBuwg7xP7mFel6CHgnA3LW/NPiDW2DA/2rEPsdFYaz+L6TWN5ZK7wD6
         xShsfN2wviv8sg8sRQbhWECkFUOavw1KTRUnmufE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <atish.patra@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/199] riscv: cacheinfo: Fix using smp_processor_id() in preemptible
Date:   Mon, 25 Jan 2021 19:37:55 +0100
Message-Id: <20210125183218.506997486@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 80709af7325d179b433817f421c85449f2454046 ]

Use raw_smp_processor_id instead of smp_processor_id() to fix warning,

BUG: using smp_processor_id() in preemptible [00000000] code: init/1
caller is debug_smp_processor_id+0x1c/0x26
CPU: 0 PID: 1 Comm: init Not tainted 5.10.0-rc4 #211
Call Trace:
  walk_stackframe+0x0/0xaa
  show_stack+0x32/0x3e
  dump_stack+0x76/0x90
  check_preemption_disabled+0xaa/0xac
  debug_smp_processor_id+0x1c/0x26
  get_cache_size+0x18/0x68
  load_elf_binary+0x868/0xece
  bprm_execve+0x224/0x498
  kernel_execve+0xdc/0x142
  run_init_process+0x90/0x9e
  try_to_run_init_process+0x12/0x3c
  kernel_init+0xb4/0xf8
  ret_from_exception+0x0/0xc

The issue is found when CONFIG_DEBUG_PREEMPT enabled.

Reviewed-by: Atish Patra <atish.patra@wdc.com>
Tested-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
[Palmer: Added a comment.]
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cacheinfo.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/cacheinfo.c b/arch/riscv/kernel/cacheinfo.c
index de59dd457b415..d867813570442 100644
--- a/arch/riscv/kernel/cacheinfo.c
+++ b/arch/riscv/kernel/cacheinfo.c
@@ -26,7 +26,16 @@ cache_get_priv_group(struct cacheinfo *this_leaf)
 
 static struct cacheinfo *get_cacheinfo(u32 level, enum cache_type type)
 {
-	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(smp_processor_id());
+	/*
+	 * Using raw_smp_processor_id() elides a preemptability check, but this
+	 * is really indicative of a larger problem: the cacheinfo UABI assumes
+	 * that cores have a homonogenous view of the cache hierarchy.  That
+	 * happens to be the case for the current set of RISC-V systems, but
+	 * likely won't be true in general.  Since there's no way to provide
+	 * correct information for these systems via the current UABI we're
+	 * just eliding the check for now.
+	 */
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(raw_smp_processor_id());
 	struct cacheinfo *this_leaf;
 	int index;
 
-- 
2.27.0



