Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946453B60CB
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbhF1Oap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:30:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233977AbhF1O2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:28:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70205619BF;
        Mon, 28 Jun 2021 14:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890371;
        bh=hNb6fmoEw17cPpw3/BoKnm5hJ+ZN+5cx/Gw6Kva35tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHT9vqwIvzQnntkM34SAHqFPj824AyML9Dq5IhLpsALycvuue4Fhy1Y+qiw8DWW0a
         hpZgNYiMaeZ2oZKZAZLA6PP8AjapgT4zXg7SsNHrn9UIQkadSRdfVx8kNgLJ+PdnuN
         ZvWxBmwnDlwWYtE5+/ZZgDEFrGkDzkn0cM0RkVOEWFFzky+VBesF4ZCfLthTT3pYF7
         XnidNjRSRcSrvKVb88r43k57Pt/MUbm4sszv+Nn2IWZ8B13H2oqgcyxE9nKV1tzgTN
         ZagOZIdcqPryqbx53ZtqhYCs58NkKiWDv4S4BN9qKxBpiNpBSaVtio5rtYCt6TZSEK
         1DrjmLJSdEu1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>,
        Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/101] module: limit enabling module.sig_enforce
Date:   Mon, 28 Jun 2021 10:24:27 -0400
Message-Id: <20210628142607.32218-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index 908d46abe165..185b2655bc20 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -272,9 +272,18 @@ static void module_assert_mutex_or_preempt(void)
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
@@ -285,11 +294,6 @@ bool is_module_sig_enforced(void)
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

