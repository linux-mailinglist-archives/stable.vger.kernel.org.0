Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5031431E01
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhJRN4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233966AbhJRNyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:54:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB60F619F6;
        Mon, 18 Oct 2021 13:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564386;
        bh=onbzt/OA7b97z/LVhERZJ34VAKYYc3A6b3rtRjO1JoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiislrYdWCPKtAWT6mFWz4o8YWmU+wBMKDBwDgtkzUbY08kIpDSzvm10gdTgEJMIi
         txsvKahkhWeSzp5Urvamx/tpsvHjJ/Ezpkwb6COG3RaSfYvNxhHmCrG+leyvDaWL60
         IiUAiMKO1LFJUtMgsfQ5HWOMleykXLUNB1dSu2DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Miroslav Benes <mbenes@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.14 036/151] module: fix clang CFI with MODULE_UNLOAD=n
Date:   Mon, 18 Oct 2021 15:23:35 +0200
Message-Id: <20211018132341.865594008@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 0d67e332e6df72f43eaa21228daa3a79e23093f3 upstream.

When CONFIG_MODULE_UNLOAD is disabled, the module->exit member
is not defined, causing a build failure:

kernel/module.c:4493:8: error: no member named 'exit' in 'struct module'
                mod->exit = *exit;

add an #ifdef block around this.

Fixes: cf68fffb66d6 ("add support for Clang CFI")
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4484,8 +4484,10 @@ static void cfi_init(struct module *mod)
 	/* Fix init/exit functions to point to the CFI jump table */
 	if (init)
 		mod->init = *init;
+#ifdef CONFIG_MODULE_UNLOAD
 	if (exit)
 		mod->exit = *exit;
+#endif
 
 	cfi_module_add(mod, module_addr_min);
 #endif


