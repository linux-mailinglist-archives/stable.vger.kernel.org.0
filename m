Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5621F3642C7
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239737AbhDSNLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239575AbhDSNKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69BAC61360;
        Mon, 19 Apr 2021 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837814;
        bh=vgMLBGM+lwTxcjMgUdAb8HjzfZ650ikG0/NB+I7vEmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1UCJgvwOBF4ZFgM6AMkbF9GtmWWkAvseiy/FzNyCpNKEI1cUPlubEH4wacEiNM06f
         ZaT0qTMLqvloGvv18Q4OiLzrzfpS9hkxpZgeB1Xn+2KHQ4a3tu25EYdbbPOrQMqoaC
         fsjrmJAlsgHui8zzxNdugUZ3GYNCuINV4A2bUu1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 028/122] bpf: Take module reference for trampoline in module
Date:   Mon, 19 Apr 2021 15:05:08 +0200
Message-Id: <20210419130531.120425054@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 861de02e5f3f2a104eecc5af1d248cb7bf8c5f75 ]

Currently module can be unloaded even if there's a trampoline
register in it. It's easily reproduced by running in parallel:

  # while :; do ./test_progs -t module_attach; done
  # while :; do rmmod bpf_testmod; sleep 0.5; done

Taking the module reference in case the trampoline's ip is
within the module code. Releasing it when the trampoline's
ip is unregistered.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210326105900.151466-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     |  2 ++
 kernel/bpf/trampoline.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 564ebf91793e..88b581b75d5b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -41,6 +41,7 @@ struct bpf_local_storage;
 struct bpf_local_storage_map;
 struct kobject;
 struct mem_cgroup;
+struct module;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -630,6 +631,7 @@ struct bpf_trampoline {
 	/* Executable image of trampoline */
 	struct bpf_tramp_image *cur_image;
 	u64 selector;
+	struct module *mod;
 };
 
 struct bpf_attach_target_info {
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 986dabc3d11f..a431d7af884c 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -9,6 +9,7 @@
 #include <linux/btf.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/rcupdate_wait.h>
+#include <linux/module.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -87,6 +88,26 @@ out:
 	return tr;
 }
 
+static int bpf_trampoline_module_get(struct bpf_trampoline *tr)
+{
+	struct module *mod;
+	int err = 0;
+
+	preempt_disable();
+	mod = __module_text_address((unsigned long) tr->func.addr);
+	if (mod && !try_module_get(mod))
+		err = -ENOENT;
+	preempt_enable();
+	tr->mod = mod;
+	return err;
+}
+
+static void bpf_trampoline_module_put(struct bpf_trampoline *tr)
+{
+	module_put(tr->mod);
+	tr->mod = NULL;
+}
+
 static int is_ftrace_location(void *ip)
 {
 	long addr;
@@ -108,6 +129,9 @@ static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
 		ret = unregister_ftrace_direct((long)ip, (long)old_addr);
 	else
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, NULL);
+
+	if (!ret)
+		bpf_trampoline_module_put(tr);
 	return ret;
 }
 
@@ -134,10 +158,16 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 		return ret;
 	tr->func.ftrace_managed = ret;
 
+	if (bpf_trampoline_module_get(tr))
+		return -ENOENT;
+
 	if (tr->func.ftrace_managed)
 		ret = register_ftrace_direct((long)ip, (long)new_addr);
 	else
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
+
+	if (ret)
+		bpf_trampoline_module_put(tr);
 	return ret;
 }
 
-- 
2.30.2



