Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8FD20C7C
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfEPQFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:05:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42408 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbfEPP6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:41 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006yo-4s; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001N8-KY; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Rusty Russell" <rusty@rustcorp.com.au>,
        "Jason Baron" <jbaron@akamai.com>
Date:   Thu, 16 May 2019 16:55:32 +0100
Message-ID: <lsq.1558022132.39741117@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 10/86] module, jump_label: Fix module locking
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit bed831f9a251968272dae10a83b512c7db256ef0 upstream.

As per the module core lockdep annotations in the coming patch:

[   18.034047] ---[ end trace 9294429076a9c673 ]---
[   18.047760] Hardware name: Intel Corporation S2600GZ/S2600GZ, BIOS SE5C600.86B.02.02.0002.122320131210 12/23/2013
[   18.059228]  ffffffff817d8676 ffff880036683c38 ffffffff8157e98b 0000000000000001
[   18.067541]  0000000000000000 ffff880036683c78 ffffffff8105fbc7 ffff880036683c68
[   18.075851]  ffffffffa0046b08 0000000000000000 ffffffffa0046d00 ffffffffa0046cc8
[   18.084173] Call Trace:
[   18.086906]  [<ffffffff8157e98b>] dump_stack+0x4f/0x7b
[   18.092649]  [<ffffffff8105fbc7>] warn_slowpath_common+0x97/0xe0
[   18.099361]  [<ffffffff8105fc2a>] warn_slowpath_null+0x1a/0x20
[   18.105880]  [<ffffffff810ee502>] __module_address+0x1d2/0x1e0
[   18.112400]  [<ffffffff81161153>] jump_label_module_notify+0x143/0x1e0
[   18.119710]  [<ffffffff810814bf>] notifier_call_chain+0x4f/0x70
[   18.126326]  [<ffffffff8108160e>] __blocking_notifier_call_chain+0x5e/0x90
[   18.134009]  [<ffffffff81081656>] blocking_notifier_call_chain+0x16/0x20
[   18.141490]  [<ffffffff810f0f00>] load_module+0x1b50/0x2660
[   18.147720]  [<ffffffff810f1ade>] SyS_init_module+0xce/0x100
[   18.154045]  [<ffffffff81587429>] system_call_fastpath+0x12/0x17
[   18.160748] ---[ end trace 9294429076a9c674 ]---

Jump labels is not doing it right; fix this.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jason Baron <jbaron@akamai.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/jump_label.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -309,7 +309,7 @@ static int jump_label_add_module(struct
 			continue;
 
 		key = iterk;
-		if (__module_address(iter->key) == mod) {
+		if (within_module(iter->key, mod)) {
 			/*
 			 * Set key->entries to iter, but preserve JUMP_LABEL_TRUE_BRANCH.
 			 */
@@ -346,7 +346,7 @@ static void jump_label_del_module(struct
 
 		key = (struct static_key *)(unsigned long)iter->key;
 
-		if (__module_address(iter->key) == mod)
+		if (within_module(iter->key, mod))
 			continue;
 
 		prev = &key->next;
@@ -450,14 +450,16 @@ static void jump_label_update(struct sta
 {
 	struct jump_entry *stop = __stop___jump_table;
 	struct jump_entry *entry = jump_label_get_entries(key);
-
 #ifdef CONFIG_MODULES
-	struct module *mod = __module_address((unsigned long)key);
+	struct module *mod;
 
 	__jump_label_mod_update(key, enable);
 
+	preempt_disable();
+	mod = __module_address((unsigned long)key);
 	if (mod)
 		stop = mod->jump_entries + mod->num_jump_entries;
+	preempt_enable();
 #endif
 	/* if there are no users, entry can be NULL */
 	if (entry)

