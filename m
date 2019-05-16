Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD10A20C83
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfEPQFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:05:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42348 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbfEPP6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0006yh-Uu; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001MU-BJ; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Petr Mladek" <pmladek@suse.cz>,
        "Rusty Russell" <rusty@rustcorp.com.au>
Date:   Thu, 16 May 2019 16:55:32 +0100
Message-ID: <lsq.1558022132.775903169@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 02/86] module: add within_module() function
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

From: Petr Mladek <pmladek@suse.cz>

commit 9b20a352d78a7651aa68a9220f77ccb03009d892 upstream.

It is just a small optimization that allows to replace few
occurrences of within_module_init() || within_module_core()
with a single call.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/module.h |  5 +++++
 kernel/module.c        | 12 ++++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -408,6 +408,11 @@ static inline int within_module_init(uns
 	       addr < (unsigned long)mod->module_init + mod->init_size;
 }
 
+static inline int within_module(unsigned long addr, const struct module *mod)
+{
+	return within_module_init(addr, mod) || within_module_core(addr, mod);
+}
+
 /* Search for module by name: must hold module_mutex. */
 struct module *find_module(const char *name);
 
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3489,8 +3489,7 @@ const char *module_address_lookup(unsign
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_init(addr, mod) ||
-		    within_module_core(addr, mod)) {
+		if (within_module(addr, mod)) {
 			if (modname)
 				*modname = mod->name;
 			ret = get_ksymbol(mod, addr, size, offset);
@@ -3514,8 +3513,7 @@ int lookup_module_symbol_name(unsigned l
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_init(addr, mod) ||
-		    within_module_core(addr, mod)) {
+		if (within_module(addr, mod)) {
 			const char *sym;
 
 			sym = get_ksymbol(mod, addr, NULL, NULL);
@@ -3540,8 +3538,7 @@ int lookup_module_symbol_attrs(unsigned
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_init(addr, mod) ||
-		    within_module_core(addr, mod)) {
+		if (within_module(addr, mod)) {
 			const char *sym;
 
 			sym = get_ksymbol(mod, addr, size, offset);
@@ -3804,8 +3801,7 @@ struct module *__module_address(unsigned
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_core(addr, mod)
-		    || within_module_init(addr, mod))
+		if (within_module(addr, mod))
 			return mod;
 	}
 	return NULL;

