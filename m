Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3345820D3C7
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgF2TCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730358AbgF2TAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7EDA25519;
        Mon, 29 Jun 2020 15:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446073;
        bh=nnG65npblopB49xLdLnlkOiuMveqdiuLEcgLLxBTwKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baWVMTkBuoQ3AB/z30Hj4C5+HANgNouQ3Y9LryVp9eLWiwWz0JOyuDGLYe6B3WLDi
         mOmyKrLzyCZhEPZ3sk/hc5UnONqIbMk8M7QQd0jXrehkB6QWIBJpWYzrXHZdkPd5l7
         XX2oAb2jxeRFVVnlAYqc0quxETKWEWAB9EscGkgQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 071/135] powerpc/kprobes: Fixes for kprobe_lookup_name() on BE
Date:   Mon, 29 Jun 2020 11:52:05 -0400
Message-Id: <20200629155309.2495516-72-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 30176466e36aadba01e1a630cf42397a3438efa4 ]

Fix two issues with kprobes.h on BE which were exposed with the
optprobes work:
  - one, having to do with a missing include for linux/module.h for
    MODULE_NAME_LEN -- this didn't show up previously since the only
    users of kprobe_lookup_name were in kprobes.c, which included
    linux/module.h through other headers, and
  - two, with a missing const qualifier for a local variable which ends
    up referring a string literal. Again, this is unique to how
    kprobe_lookup_name is being invoked in optprobes.c

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kprobes.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/kprobes.h b/arch/powerpc/include/asm/kprobes.h
index 039b583db0292..f0717eedf781c 100644
--- a/arch/powerpc/include/asm/kprobes.h
+++ b/arch/powerpc/include/asm/kprobes.h
@@ -29,6 +29,7 @@
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
+#include <linux/module.h>
 #include <asm/probes.h>
 #include <asm/code-patching.h>
 
@@ -61,7 +62,7 @@ typedef ppc_opcode_t kprobe_opcode_t;
 #define kprobe_lookup_name(name, addr)					\
 {									\
 	char dot_name[MODULE_NAME_LEN + 1 + KSYM_NAME_LEN];		\
-	char *modsym;							\
+	const char *modsym;							\
 	bool dot_appended = false;					\
 	if ((modsym = strchr(name, ':')) != NULL) {			\
 		modsym++;						\
-- 
2.25.1

