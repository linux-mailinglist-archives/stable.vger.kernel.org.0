Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3FB3B6180
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbhF1OgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234942AbhF1Oe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB7BC61C75;
        Mon, 28 Jun 2021 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890607;
        bh=KQ23l31pbnn6F4T/aE1U64E3HYX8PqrU2QyBAWX4KVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SA13fvX/NIk+xC+vE/zyo4vKXxWLjjEMybnoVK2QIavVuMfPsVzTl/WqahCf7FbkW
         kt/Z4Co0kKx7ZiV1M+2BPigKlVdHixOuIm0SkKY2mUFgbYeFT1fkl1RqZLb2khA4CZ
         vBPcSDqBlarsVkfwsuOUr42Wgy/KOSD97aa+QYk122RG23RMbglIZFcRyZ0gBUcOwP
         lfemV928VNbNiQPPxF4xYoDMOTXnGtdbocMGumlygkBnQ8L+sIcJM9J+fUCHiZadjJ
         2TKhnxX/cyCh8hcdCEaJq2TGb/N/PEYO9yioKxKGNOGX3RYfzS5dQ9AUN8fW09IzK5
         OQLWWQeQHhyew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>,
        Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/71] module: limit enabling module.sig_enforce
Date:   Mon, 28 Jun 2021 10:28:54 -0400
Message-Id: <20210628143004.32596-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mimi Zohar <zohar@linux.ibm.com>

[ Upstream commit 0c18f29aae7ce3dadd26d8ee3505d07cc982df75 ]

Irrespective as to whether CONFIG_MODULE_SIG is configured, specifying
"module.sig_enforce=1" on the boot command line sets "sig_enforce".
Only allow "sig_enforce" to be set when CONFIG_MODULE_SIG is configured.

This patch makes the presence of /sys/module/module/parameters/sig_enforce
dependent on CONFIG_MODULE_SIG=y.

Fixes: fda784e50aac ("module: export module signature enforcement status")
Reported-by: Nayna Jain <nayna@linux.ibm.com>
Tested-by: Mimi Zohar <zohar@linux.ibm.com>
Tested-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 88a6a9e04f8d..59d487b8d8da 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -268,9 +268,18 @@ static void module_assert_mutex_or_preempt(void)
 #endif
 }
 
+#ifdef CONFIG_MODULE_SIG
 static bool sig_enforce = IS_ENABLED(CONFIG_MODULE_SIG_FORCE);
 module_param(sig_enforce, bool_enable_only, 0644);
 
+void set_module_sig_enforced(void)
+{
+	sig_enforce = true;
+}
+#else
+#define sig_enforce false
+#endif
+
 /*
  * Export sig_enforce kernel cmdline parameter to allow other subsystems rely
  * on that instead of directly to CONFIG_MODULE_SIG_FORCE config.
@@ -281,11 +290,6 @@ bool is_module_sig_enforced(void)
 }
 EXPORT_SYMBOL(is_module_sig_enforced);
 
-void set_module_sig_enforced(void)
-{
-	sig_enforce = true;
-}
-
 /* Block module loading/unloading? */
 int modules_disabled = 0;
 core_param(nomodule, modules_disabled, bint, 0);
-- 
2.30.2

