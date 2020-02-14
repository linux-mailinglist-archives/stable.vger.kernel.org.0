Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1720315F30E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgBNPwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:52:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731018AbgBNPwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A77224676;
        Fri, 14 Feb 2020 15:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695557;
        bh=deNAJfb+HengsUnbWaZWDBpg7gTmWXmNHJ17KELUfr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHwq/1oon3DHLu7R8SeMY2V94QOfzouF17aXsLfJ3Y2rGaCpYRtbyscd6J6RPuIF7
         hPQzJI4liadweaHlXLRW3bLArY+7uNTUnpmiPALT8RiTry1OojJsLRXTTMDFFOwqKA
         92gxfKEds8WSV+8G6t1nyII1KKyov78AD3DCUA+k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 171/542] modules: lockdep: Suppress suspicious RCU usage warning
Date:   Fri, 14 Feb 2020 10:42:43 -0500
Message-Id: <20200214154854.6746-171-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit bf08949cc8b98b7d1e20cfbba169a5938d42dae8 ]

While running kprobe module test, find_module_all() caused
a suspicious RCU usage warning.

-----
 =============================
 WARNING: suspicious RCU usage
 5.4.0-next-20191202+ #63 Not tainted
 -----------------------------
 kernel/module.c:619 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by rmmod/642:
  #0: ffffffff8227da80 (module_mutex){+.+.}, at: __x64_sys_delete_module+0x9a/0x230

 stack backtrace:
 CPU: 0 PID: 642 Comm: rmmod Not tainted 5.4.0-next-20191202+ #63
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
 Call Trace:
  dump_stack+0x71/0xa0
  find_module_all+0xc1/0xd0
  __x64_sys_delete_module+0xac/0x230
  ? do_syscall_64+0x12/0x1f0
  do_syscall_64+0x50/0x1f0
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x4b6d49
-----

This is because list_for_each_entry_rcu(modules) is called
without rcu_read_lock(). This is safe because the module_mutex
is locked.

Pass lockdep_is_held(&module_mutex) to the list_for_each_entry_rcu()
to suppress this warning, This also fixes similar issue in
mod_find() and each_symbol_section().

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 8785e31c2dd0f..d83edc3a41a33 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -214,7 +214,8 @@ static struct module *mod_find(unsigned long addr)
 {
 	struct module *mod;
 
-	list_for_each_entry_rcu(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list,
+				lockdep_is_held(&module_mutex)) {
 		if (within_module(addr, mod))
 			return mod;
 	}
@@ -448,7 +449,8 @@ bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
 	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
 		return true;
 
-	list_for_each_entry_rcu(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list,
+				lockdep_is_held(&module_mutex)) {
 		struct symsearch arr[] = {
 			{ mod->syms, mod->syms + mod->num_syms, mod->crcs,
 			  NOT_GPL_ONLY, false },
@@ -616,7 +618,8 @@ static struct module *find_module_all(const char *name, size_t len,
 
 	module_assert_mutex_or_preempt();
 
-	list_for_each_entry_rcu(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list,
+				lockdep_is_held(&module_mutex)) {
 		if (!even_unformed && mod->state == MODULE_STATE_UNFORMED)
 			continue;
 		if (strlen(mod->name) == len && !memcmp(mod->name, name, len))
-- 
2.20.1

