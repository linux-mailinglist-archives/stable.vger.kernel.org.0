Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD1F20DEB4
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgF2U2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:28:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732503AbgF2TZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EDE4253ED;
        Mon, 29 Jun 2020 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445329;
        bh=pt8TGwydI0Q2NG5Q0h+jWjnuF3rsdC1OdZDVC8mGVLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LApN4g4LCo7QlxCj3Qyr/bPULYTLoBL9cwAHAGrr2HjsajLsMplCFQxw8BLt/FTwW
         QOD5ywrPizbhUa+SmFZVKMq7KHbBi1kcxrH/icw9XusmS4H3q/+1hLptjACj8H8x3w
         ebo9sUeNPjNoS4qy+TPHBC2BLpiLdw6RkJ8bewtk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 093/191] powerpc/kprobes: Fixes for kprobe_lookup_name() on BE
Date:   Mon, 29 Jun 2020 11:38:29 -0400
Message-Id: <20200629154007.2495120-94-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
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
index 2c9759bdb63bc..063d64c1c9e89 100644
--- a/arch/powerpc/include/asm/kprobes.h
+++ b/arch/powerpc/include/asm/kprobes.h
@@ -29,6 +29,7 @@
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
+#include <linux/module.h>
 #include <asm/probes.h>
 #include <asm/code-patching.h>
 
@@ -60,7 +61,7 @@ typedef ppc_opcode_t kprobe_opcode_t;
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

