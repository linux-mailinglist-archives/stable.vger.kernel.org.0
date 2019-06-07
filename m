Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F8F390D3
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730828AbfFGPpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730862AbfFGPpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:45:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B76932147A;
        Fri,  7 Jun 2019 15:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922349;
        bh=PRLpC5nwM9nO3KrtQa6s3Sz5d8KnuDm79+AssLvw99g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2j88oaUW/AyxPlSlCj9QhVAnT7V66zyq4CKzCb55ipiQUW1F9I9FIfLBS7nADECPA
         S9k0KIfahb5RnWxzGmW7jT9s5CXF/YSRwd+Y/+wMogIQXBYIbV14EFpWd47UGWsJyB
         b1kQ3TIRLPUs+x5TT4c90jGs9gkwVbgelkqRRv58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH 4.19 55/73] gcc-plugins: Fix build failures under Darwin host
Date:   Fri,  7 Jun 2019 17:39:42 +0200
Message-Id: <20190607153855.192539950@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit 7210e060155b9cf557fb13128353c3e494fa5ed3 upstream.

The gcc-common.h file did not take into account certain macros that
might have already been defined in the build environment. This updates
the header to avoid redefining the macros, as seen on a Darwin host
using gcc 4.9.2:

 HOSTCXX -fPIC scripts/gcc-plugins/arm_ssp_per_task_plugin.o - due to: scripts/gcc-plugins/gcc-common.h
In file included from scripts/gcc-plugins/arm_ssp_per_task_plugin.c:3:0:
scripts/gcc-plugins/gcc-common.h:153:0: warning: "__unused" redefined
^
In file included from /usr/include/stdio.h:64:0,
                from /Users/hns/Documents/Projects/QuantumSTEP/System/Library/Frameworks/System.framework/Versions-jessie/x86_64-apple-darwin15.0.0/gcc/arm-linux-gnueabi/bin/../lib/gcc/arm-linux-gnueabi/4.9.2/plugin/include/system.h:40,
                from /Users/hns/Documents/Projects/QuantumSTEP/System/Library/Frameworks/System.framework/Versions-jessie/x86_64-apple-darwin15.0.0/gcc/arm-linux-gnueabi/bin/../lib/gcc/arm-linux-gnueabi/4.9.2/plugin/include/gcc-plugin.h:28,
                from /Users/hns/Documents/Projects/QuantumSTEP/System/Library/Frameworks/System.framework/Versions-jessie/x86_64-apple-darwin15.0.0/gcc/arm-linux-gnueabi/bin/../lib/gcc/arm-linux-gnueabi/4.9.2/plugin/include/plugin.h:23,
                from scripts/gcc-plugins/gcc-common.h:9,
                from scripts/gcc-plugins/arm_ssp_per_task_plugin.c:3:
/usr/include/sys/cdefs.h:161:0: note: this is the location of the previous definition
^

Reported-and-tested-by: "H. Nikolaus Schaller" <hns@goldelico.com>
Fixes: 189af4657186 ("ARM: smp: add support for per-task stack canaries")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/gcc-plugins/gcc-common.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -150,8 +150,12 @@ void print_gimple_expr(FILE *, gimple, i
 void dump_gimple_stmt(pretty_printer *, gimple, int, int);
 #endif
 
+#ifndef __unused
 #define __unused __attribute__((__unused__))
+#endif
+#ifndef __visible
 #define __visible __attribute__((visibility("default")))
+#endif
 
 #define DECL_NAME_POINTER(node) IDENTIFIER_POINTER(DECL_NAME(node))
 #define DECL_NAME_LENGTH(node) IDENTIFIER_LENGTH(DECL_NAME(node))


