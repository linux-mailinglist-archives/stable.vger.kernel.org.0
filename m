Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5980B38FDA
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbfFGPqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730632AbfFGPqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:46:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CE92212F5;
        Fri,  7 Jun 2019 15:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922369;
        bh=GnmitQ/FmhUl1iQbeJpEQmDM6jx8+AikL4E/B9gvUfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjm40VFZmaaZzjIQJcCdq6udW1VbiOrM/zD6xxFEN9bvF8xvnVZwM8b8egN/nX0Pc
         pv47YppUeDnRseXsoP5IlK7HBnvtzAJtkiB1APAcCyMLwpB1NoP1qhEwpMp/xT7pmK
         +Q0d8CQXfM03VbeUOI5IXAZitWnIhMhRIXP94wf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH 4.19 62/73] Compiler Attributes: add support for __copy (gcc >= 9)
Date:   Fri,  7 Jun 2019 17:39:49 +0200
Message-Id: <20190607153855.885568110@linuxfoundation.org>
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

commit c0d9782f5b6d7157635ae2fd782a4b27d55a6013 upstream.

>From the GCC manual:

  copy
  copy(function)

    The copy attribute applies the set of attributes with which function
    has been declared to the declaration of the function to which
    the attribute is applied. The attribute is designed for libraries
    that define aliases or function resolvers that are expected
    to specify the same set of attributes as their targets. The copy
    attribute can be used with functions, variables, or types. However,
    the kind of symbol to which the attribute is applied (either
    function or variable) must match the kind of symbol to which
    the argument refers. The copy attribute copies only syntactic and
    semantic attributes but not attributes that affect a symbol’s
    linkage or visibility such as alias, visibility, or weak.
    The deprecated attribute is also not copied.

  https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html

The upcoming GCC 9 release extends the -Wmissing-attributes warnings
(enabled by -Wall) to C and aliases: it warns when particular function
attributes are missing in the aliases but not in their target, e.g.:

    void __cold f(void) {}
    void __alias("f") g(void);

diagnoses:

    warning: 'g' specifies less restrictive attribute than
    its target 'f': 'cold' [-Wmissing-attributes]

Using __copy(f) we can copy the __cold attribute from f to g:

    void __cold f(void) {}
    void __copy(f) __alias("f") g(void);

This attribute is most useful to deal with situations where an alias
is declared but we don't know the exact attributes the target has.

For instance, in the kernel, the widely used module_init/exit macros
define the init/cleanup_module aliases, but those cannot be marked
always as __init/__exit since some modules do not have their
functions marked as such.

Suggested-by: Martin Sebor <msebor@gcc.gnu.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/compiler-gcc.h   |    4 ++++
 include/linux/compiler_types.h |    4 ++++
 2 files changed, 8 insertions(+)

--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -201,6 +201,10 @@
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #endif
 
+#if GCC_VERSION >= 90100
+#define __copy(symbol)                 __attribute__((__copy__(symbol)))
+#endif
+
 #if !defined(__noclone)
 #define __noclone	/* not needed */
 #endif
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -180,6 +180,10 @@ struct ftrace_likely_data {
 #define __diag_GCC(version, severity, string)
 #endif
 
+#ifndef __copy
+# define __copy(symbol)
+#endif
+
 #define __diag_push()	__diag(push)
 #define __diag_pop()	__diag(pop)
 


