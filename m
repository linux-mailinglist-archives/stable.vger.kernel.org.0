Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978E41672A7
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731831AbgBUIFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731644AbgBUIF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:05:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA7F420801;
        Fri, 21 Feb 2020 08:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272328;
        bh=sdSNb2htOzeYzNbBS5Qvk1X4kOUPO9Y+4HeFNEpsvL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOIxXGv1d3Rz2JGPDmF7PUhGeAP4UoEUTIsfT+igtmJy70I7YlGvj80zYOk8qeypJ
         X1G5zTDV3lzXR1kWz3yBp1PQ+iHOeoAPP9z3Jxpm7lLSJMIMevAbkPODDC9VhcUH2K
         CN7VSf/DcPbKZIU4WdY0opNgo74DTuVQ+im7N7oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/344] modules: lockdep: Suppress suspicious RCU usage warning
Date:   Fri, 21 Feb 2020 08:38:19 +0100
Message-Id: <20200221072358.025851500@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9fb8fa22e16b3..135861c2ac782 100644
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



