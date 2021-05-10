Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB4A378161
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhEJK0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231281AbhEJKZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6D9861481;
        Mon, 10 May 2021 10:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642278;
        bh=2q8uTJYygAJRXWi86Lvfxv7JRnQP2NPsjPxE8HsdnpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/hu0dxMGfrGnrLsq90Tq+d17clzvhyaUqP4Inj//URyVP8vIJ7mN31NdHaOWbFRx
         2ySf02S4J0AqvRXlm+RuAOnAabJiswAMnJ86VFCQ+tT0MFX4gpqOO7SbKTVkfuT4dA
         xnREgKyNXDGU15eBhBIDIbgWiZZbnDYobz4zjSZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.4 030/184] modules: return licensing information from find_symbol
Date:   Mon, 10 May 2021 12:18:44 +0200
Message-Id: <20210510101951.220172235@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit ef1dac6021cc8ec5de02ce31722bf26ac4ed5523 upstream.

Report the GPLONLY status through a new argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/module.h |    2 +-
 kernel/module.c        |   16 +++++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -561,7 +561,7 @@ struct module *find_module(const char *n
 struct symsearch {
 	const struct kernel_symbol *start, *stop;
 	const s32 *crcs;
-	enum {
+	enum mod_license {
 		NOT_GPL_ONLY,
 		GPL_ONLY,
 		WILL_BE_GPL_ONLY,
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -493,6 +493,7 @@ struct find_symbol_arg {
 	struct module *owner;
 	const s32 *crc;
 	const struct kernel_symbol *sym;
+	enum mod_license license;
 };
 
 static bool check_exported_symbol(const struct symsearch *syms,
@@ -526,6 +527,7 @@ static bool check_exported_symbol(const
 	fsa->owner = owner;
 	fsa->crc = symversion(syms->crcs, symnum);
 	fsa->sym = &syms->start[symnum];
+	fsa->license = syms->license;
 	return true;
 }
 
@@ -585,6 +587,7 @@ static bool find_exported_symbol_in_sect
 static const struct kernel_symbol *find_symbol(const char *name,
 					struct module **owner,
 					const s32 **crc,
+					enum mod_license *license,
 					bool gplok,
 					bool warn)
 {
@@ -599,6 +602,8 @@ static const struct kernel_symbol *find_
 			*owner = fsa.owner;
 		if (crc)
 			*crc = fsa.crc;
+		if (license)
+			*license = fsa.license;
 		return fsa.sym;
 	}
 
@@ -1072,7 +1077,7 @@ void __symbol_put(const char *symbol)
 	struct module *owner;
 
 	preempt_disable();
-	if (!find_symbol(symbol, &owner, NULL, true, false))
+	if (!find_symbol(symbol, &owner, NULL, NULL, true, false))
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -1350,7 +1355,7 @@ static inline int check_modstruct_versio
 	 * locking is necessary -- use preempt_disable() to placate lockdep.
 	 */
 	preempt_disable();
-	if (!find_symbol("module_layout", NULL, &crc, true, false)) {
+	if (!find_symbol("module_layout", NULL, &crc, NULL, true, false)) {
 		preempt_enable();
 		BUG();
 	}
@@ -1434,6 +1439,7 @@ static const struct kernel_symbol *resol
 	struct module *owner;
 	const struct kernel_symbol *sym;
 	const s32 *crc;
+	enum mod_license license;
 	int err;
 
 	/*
@@ -1443,7 +1449,7 @@ static const struct kernel_symbol *resol
 	 */
 	sched_annotate_sleep();
 	mutex_lock(&module_mutex);
-	sym = find_symbol(name, &owner, &crc,
+	sym = find_symbol(name, &owner, &crc, &license,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
 	if (!sym)
 		goto unlock;
@@ -2258,7 +2264,7 @@ void *__symbol_get(const char *symbol)
 	const struct kernel_symbol *sym;
 
 	preempt_disable();
-	sym = find_symbol(symbol, &owner, NULL, true, true);
+	sym = find_symbol(symbol, &owner, NULL, NULL, true, true);
 	if (sym && strong_try_module_get(owner))
 		sym = NULL;
 	preempt_enable();
@@ -2294,7 +2300,7 @@ static int verify_exported_symbols(struc
 	for (i = 0; i < ARRAY_SIZE(arr); i++) {
 		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
 			if (find_symbol(kernel_symbol_name(s), &owner, NULL,
-					true, false)) {
+					NULL, true, false)) {
 				pr_err("%s: exports duplicate symbol %s"
 				       " (owned by %s)\n",
 				       mod->name, kernel_symbol_name(s),


