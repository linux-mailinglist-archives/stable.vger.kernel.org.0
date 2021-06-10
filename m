Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E2F3A2179
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 02:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhFJAjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 20:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229845AbhFJAjc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 20:39:32 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D016613F2;
        Thu, 10 Jun 2021 00:37:37 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1lr8hU-002b6C-CC; Wed, 09 Jun 2021 20:37:36 -0400
Message-ID: <20210610003736.214817589@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 09 Jun 2021 20:33:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-linus][PATCH 2/5] tools/bootconfig: Fix a build error accroding to undefined
 fallthrough
References: <20210610003344.783752614@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

Since the "fallthrough" is defined only in the kernel, building
lib/bootconfig.c as a part of user-space tools causes a build
error.

Add a dummy fallthrough to avoid the build error.

Link: https://lkml.kernel.org/r/162087519356.442660.11385099982318160180.stgit@devnote2

Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 4c1ca831adb1 ("Revert "lib: Revert use of fallthrough pseudo-keyword in lib/"")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/bootconfig/include/linux/bootconfig.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/bootconfig/include/linux/bootconfig.h b/tools/bootconfig/include/linux/bootconfig.h
index 078cbd2ba651..de7f30f99af3 100644
--- a/tools/bootconfig/include/linux/bootconfig.h
+++ b/tools/bootconfig/include/linux/bootconfig.h
@@ -4,4 +4,8 @@
 
 #include "../../../../include/linux/bootconfig.h"
 
+#ifndef fallthrough
+# define fallthrough
+#endif
+
 #endif
-- 
2.30.2
