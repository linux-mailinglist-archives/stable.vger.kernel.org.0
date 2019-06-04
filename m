Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E42B63430C
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 11:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfFDJWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 05:22:14 -0400
Received: from mail.kmu-office.ch ([178.209.48.109]:44168 "EHLO
        mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfFDJWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 05:22:13 -0400
Received: from trochilidae.toradex.int (unknown [46.140.72.82])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 3D0205C0169;
        Tue,  4 Jun 2019 11:22:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1559640129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=QkMqDMvjhf5q4WW9eZUi9zH/rdyboWNw8AJESUXVoOQ=;
        b=or5E5hDf0G/NtlZn200gcatQyjgAr1SS3PVMqbQ9A+lqsf5EI3xNrTzYnZvW66hju6AJYN
        B0TPLQDanY6jicvBnLNfr1KCAFS7yOorkEyrBqEb15AFDYmOimI4pDEKygPMs1Hdm71KWy
        iZsiDX5X8cXl2cGOzWgQ9QbH1xE2kFM=
From:   Stefan Agner <stefan@agner.ch>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Martin Sebor <msebor@gcc.gnu.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH BACKPORT 4.14 1/2] Compiler Attributes: add support for __copy (gcc >= 9)
Date:   Tue,  4 Jun 2019 11:21:59 +0200
Message-Id: <20190604092200.29545-1-stefan@agner.ch>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

[ Upstream commit c0d9782f5b6d7157635ae2fd782a4b27d55a6013

From the GCC manual:

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

Cc: <stable@vger.kernel.org> # 4.14+
Suggested-by: Martin Sebor <msebor@gcc.gnu.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 include/linux/compiler-gcc.h   | 4 ++++
 include/linux/compiler_types.h | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 4816355b9875..6d7ead22c1b4 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -343,6 +343,10 @@
 #define __designated_init __attribute__((designated_init))
 #endif
 
+#if GCC_VERSION >= 90100
+#define __copy(symbol)                 __attribute__((__copy__(symbol)))
+#endif
+
 #endif	/* gcc version >= 40000 specific checks */
 
 #if !defined(__noclone)
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 4be464a07612..20112bb1a8f9 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -230,6 +230,10 @@ struct ftrace_likely_data {
 # define __latent_entropy
 #endif
 
+#ifndef __copy
+# define __copy
+#endif
+
 #ifndef __randomize_layout
 # define __randomize_layout __designated_init
 #endif
-- 
2.21.0

