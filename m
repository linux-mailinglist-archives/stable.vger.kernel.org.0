Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA8419B3F0
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387790AbgDAQ1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387657AbgDAQ1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:27:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8946A21582;
        Wed,  1 Apr 2020 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758420;
        bh=rOotCIjwWgz/HVtDMOKtKcP6oZ6IWtFte9or8xVoQg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOCCEeZ13mD9XhATh8K5lgAb24QLgFJH36AeBTOh5R5Uz/mxc5mMkTEbqzvuuWVjC
         NfqF8eHKmvyRFphmhTdRUIFrNosolGIhpsdMbU2POIGFNP15xBrgRNH5twkP0yYNTt
         LrXQ+WRfXeoEiTw8FfAquKK9xGwltz/je8ASYzwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 046/116] ftrace/x86: Anotate text_mutex split between ftrace_arch_code_modify_post_process() and ftrace_arch_code_modify_prepare()
Date:   Wed,  1 Apr 2020 18:17:02 +0200
Message-Id: <20200401161548.389053638@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit 074376ac0e1d1fcd4fafebca86ee6158e7c20680 upstream.

ftrace_arch_code_modify_prepare() is acquiring text_mutex, while the
corresponding release is happening in ftrace_arch_code_modify_post_process().

This has already been documented in the code, but let's also make the fact
that this is intentional clear to the semantic analysis tools such as sparse.

Link: http://lkml.kernel.org/r/nycvar.YFH.7.76.1906292321170.27227@cbobk.fhfr.pm

Fixes: 39611265edc1a ("ftrace/x86: Add a comment to why we take text_mutex in ftrace_arch_code_modify_prepare()")
Fixes: d5b844a2cf507 ("ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/ftrace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -35,6 +35,7 @@
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 int ftrace_arch_code_modify_prepare(void)
+    __acquires(&text_mutex)
 {
 	mutex_lock(&text_mutex);
 	set_kernel_text_rw();
@@ -43,6 +44,7 @@ int ftrace_arch_code_modify_prepare(void
 }
 
 int ftrace_arch_code_modify_post_process(void)
+    __releases(&text_mutex)
 {
 	set_all_modules_text_ro();
 	set_kernel_text_ro();


