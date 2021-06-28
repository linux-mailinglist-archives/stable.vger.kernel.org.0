Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB2B3B5FD3
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbhF1OU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232310AbhF1OU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:20:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75D5A61C78;
        Mon, 28 Jun 2021 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889912;
        bh=qmFqD2LTCYZrgaUM1BuMc5Hc/Ud2PARQdSR00pA4vEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4e62lL+4euyQexDOEyeYjhwtZTSWYUyM4ALXTIo5RpQ6sdRrydlKzkVn+xMxqmaM
         2I63CVIcljDvBYP6lExoveB2x52Q8JZhZSOM7FjQt5VU4bAL7qu/MrDrCiyTb9HKs6
         6kr1KYyU6FjDTyzSUQp8bzt0/GWa1VbXQNSlrIMSmyIyLnNKUoT/7WuMPEyOYDn6GU
         irljliOBL1b6nwO/UT53dKxf/sTOk71QigXYm7RUYlOAYGKDHnMEQC9cy2e6SviZVL
         JpolciTdSGrCAtu9jXPQODIrPX/BiiCUdwNcbz4bTkwqSghKJv7aF5zwTO018QHfFw
         DmVWhhbcpseag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>,
        Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 001/110] module: limit enabling module.sig_enforce
Date:   Mon, 28 Jun 2021 10:16:39 -0400
Message-Id: <20210628141828.31757-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index 30479355ab85..260d6f3f6d68 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -266,9 +266,18 @@ static void module_assert_mutex_or_preempt(void)
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
@@ -279,11 +288,6 @@ bool is_module_sig_enforced(void)
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

