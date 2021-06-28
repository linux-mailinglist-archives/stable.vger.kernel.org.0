Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129AE3B62D3
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbhF1Oti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235848AbhF1Opp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF74B61CE4;
        Mon, 28 Jun 2021 14:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890860;
        bh=6TbD/fNk0JSCvm1pT3u1oy4+HIV/lZeun77ZocXtP1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlVdTBrM0kle9Zp/KoFoaKr+qI/cCUv2Ij+Yn71ZIvv6YkNujhQQPSnA1FrFeWQsz
         74qCd7q7w/fwk97BKB87vXAXoanQVtHidfjnbYzzFe8Vk4yu+4Cvtg4irp2qkAE983
         /hfoQ487ygAQxWDwaw+vFCDczyJXvhiRgFIyN9c0yR2jSDnSIs2WK5LBEbhWWcfXC2
         YEoELFsuBYpFTzIOvuTAIPK5WfslfC2abRHRqvGdOcAU0t5YsW2ly9JGmCMVjES3pD
         V2o1hmD3U+eDjalIoRKZMyIBQfk51DfUAlVYije2r5K8qNsp4tbNCxk6H6rhZvGx/d
         OjsoYO6yqTdMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>,
        Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/109] module: limit enabling module.sig_enforce
Date:   Mon, 28 Jun 2021 10:32:39 -0400
Message-Id: <20210628143305.32978-84-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
 kernel/module.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 92d8610742c7..68637e661d75 100644
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
-- 
2.30.2

