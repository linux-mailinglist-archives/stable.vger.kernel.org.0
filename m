Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B36390D2
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbfFGPzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729081AbfFGPqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:46:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36C172146E;
        Fri,  7 Jun 2019 15:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922371;
        bh=h8L1fHHv0PmMKSwcjjosZJbb9cXUGRghgh47iXuH/mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLAKZebP0JaAddFcuGfpcvTXx4FWMK4eR8HOHu0tPEnwsOXo33tlZ7xXq905aG3yi
         aAIewyO/5VfeQNKTYH2X3kkDT6y0pymOVbmG7A9rRW+9Spf9NMa97k7D66lu2ufcKf
         At9gedyujZKwMzfiiTCs5dUam8gSkZA0clF79WLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Jessica Yu <jeyu@kernel.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH 4.19 63/73] include/linux/module.h: copy __init/__exit attrs to init/cleanup_module
Date:   Fri,  7 Jun 2019 17:39:50 +0200
Message-Id: <20190607153855.988988986@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

commit a6e60d84989fa0e91db7f236eda40453b0e44afa upstream.

The upcoming GCC 9 release extends the -Wmissing-attributes warnings
(enabled by -Wall) to C and aliases: it warns when particular function
attributes are missing in the aliases but not in their target.

In particular, it triggers for all the init/cleanup_module
aliases in the kernel (defined by the module_init/exit macros),
ending up being very noisy.

These aliases point to the __init/__exit functions of a module,
which are defined as __cold (among other attributes). However,
the aliases themselves do not have the __cold attribute.

Since the compiler behaves differently when compiling a __cold
function as well as when compiling paths leading to calls
to __cold functions, the warning is trying to point out
the possibly-forgotten attribute in the alias.

In order to keep the warning enabled, we decided to silence
this case. Ideally, we would mark the aliases directly
as __init/__exit. However, there are currently around 132 modules
in the kernel which are missing __init/__exit in their init/cleanup
functions (either because they are missing, or for other reasons,
e.g. the functions being called from somewhere else); and
a section mismatch is a hard error.

A conservative alternative was to mark the aliases as __cold only.
However, since we would like to eventually enforce __init/__exit
to be always marked,  we chose to use the new __copy function
attribute (introduced by GCC 9 as well to deal with this).
With it, we copy the attributes used by the target functions
into the aliases. This way, functions that were not marked
as __init/__exit won't have their aliases marked either,
and therefore there won't be a section mismatch.

Note that the warning would go away marking either the extern
declaration, the definition, or both. However, we only mark
the definition of the alias, since we do not want callers
(which only see the declaration) to be compiled as if the function
was __cold (and therefore the paths leading to those calls
would be assumed to be unlikely).

Link: https://lore.kernel.org/lkml/20190123173707.GA16603@gmail.com/
Link: https://lore.kernel.org/lkml/20190206175627.GA20399@gmail.com/
Suggested-by: Martin Sebor <msebor@gcc.gnu.org>
Acked-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/module.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -130,13 +130,13 @@ extern void cleanup_module(void);
 #define module_init(initfn)					\
 	static inline initcall_t __maybe_unused __inittest(void)		\
 	{ return initfn; }					\
-	int init_module(void) __attribute__((alias(#initfn)));
+	int init_module(void) __copy(initfn) __attribute__((alias(#initfn)));
 
 /* This is only required if you want to be unloadable. */
 #define module_exit(exitfn)					\
 	static inline exitcall_t __maybe_unused __exittest(void)		\
 	{ return exitfn; }					\
-	void cleanup_module(void) __attribute__((alias(#exitfn)));
+	void cleanup_module(void) __copy(exitfn) __attribute__((alias(#exitfn)));
 
 #endif
 


