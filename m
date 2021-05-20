Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0840438A2FF
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhETJsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233681AbhETJp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:45:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6784A6145A;
        Thu, 20 May 2021 09:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503225;
        bh=m01zPOYsU87sGQPUh4+50NgnRHnnt/RF/bgAdWuUA2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FdBYG0eMubAOEvAKFVVwWSIqmqnfrnPzsMvYcYtTsxy7TtUYth6M8A4N6pJYuMXb
         +6oHBIlhRUOjGoB/+2Ecp/qT3zIkPR3AZyScCVd4XmUJYfLLzrPPYMo1jcEN7E8DPw
         qCk2JsbGLoEsxOQYdmxe54kJ9qQUUBIutLfz4nc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.19 125/425] modules: return licensing information from find_symbol
Date:   Thu, 20 May 2021 11:18:14 +0200
Message-Id: <20210520092135.538414555@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -529,7 +529,7 @@ struct module *find_module(const char *n
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
@@ -487,6 +487,7 @@ struct find_symbol_arg {
 	struct module *owner;
 	const s32 *crc;
 	const struct kernel_symbol *sym;
+	enum mod_license license;
 };
 
 static bool check_symbol(const struct symsearch *syms,
@@ -520,6 +521,7 @@ static bool check_symbol(const struct sy
 	fsa->owner = owner;
 	fsa->crc = symversion(syms->crcs, symnum);
 	fsa->sym = &syms->start[symnum];
+	fsa->license = syms->license;
 	return true;
 }
 
@@ -570,6 +572,7 @@ static bool find_symbol_in_section(const
 static const struct kernel_symbol *find_symbol(const char *name,
 					struct module **owner,
 					const s32 **crc,
+					enum mod_license *license,
 					bool gplok,
 					bool warn)
 {
@@ -584,6 +587,8 @@ static const struct kernel_symbol *find_
 			*owner = fsa.owner;
 		if (crc)
 			*crc = fsa.crc;
+		if (license)
+			*license = fsa.license;
 		return fsa.sym;
 	}
 
@@ -1056,7 +1061,7 @@ void __symbol_put(const char *symbol)
 	struct module *owner;
 
 	preempt_disable();
-	if (!find_symbol(symbol, &owner, NULL, true, false))
+	if (!find_symbol(symbol, &owner, NULL, NULL, true, false))
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -1334,7 +1339,7 @@ static inline int check_modstruct_versio
 	 * locking is necessary -- use preempt_disable() to placate lockdep.
 	 */
 	preempt_disable();
-	if (!find_symbol("module_layout", NULL, &crc, true, false)) {
+	if (!find_symbol("module_layout", NULL, &crc, NULL, true, false)) {
 		preempt_enable();
 		BUG();
 	}
@@ -1383,6 +1388,7 @@ static const struct kernel_symbol *resol
 	struct module *owner;
 	const struct kernel_symbol *sym;
 	const s32 *crc;
+	enum mod_license license;
 	int err;
 
 	/*
@@ -1392,7 +1398,7 @@ static const struct kernel_symbol *resol
 	 */
 	sched_annotate_sleep();
 	mutex_lock(&module_mutex);
-	sym = find_symbol(name, &owner, &crc,
+	sym = find_symbol(name, &owner, &crc, &license,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
 	if (!sym)
 		goto unlock;
@@ -2222,7 +2228,7 @@ void *__symbol_get(const char *symbol)
 	const struct kernel_symbol *sym;
 
 	preempt_disable();
-	sym = find_symbol(symbol, &owner, NULL, true, true);
+	sym = find_symbol(symbol, &owner, NULL, NULL, true, true);
 	if (sym && strong_try_module_get(owner))
 		sym = NULL;
 	preempt_enable();
@@ -2258,7 +2264,7 @@ static int verify_export_symbols(struct
 	for (i = 0; i < ARRAY_SIZE(arr); i++) {
 		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
 			if (find_symbol(kernel_symbol_name(s), &owner, NULL,
-					true, false)) {
+					NULL, true, false)) {
 				pr_err("%s: exports duplicate symbol %s"
 				       " (owned by %s)\n",
 				       mod->name, kernel_symbol_name(s),


