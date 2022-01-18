Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E28F491DF9
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347301AbiARDpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350710AbiARCwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:52:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBBAC07E5FC;
        Mon, 17 Jan 2022 18:42:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED29CB81229;
        Tue, 18 Jan 2022 02:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A124AC36AEF;
        Tue, 18 Jan 2022 02:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473770;
        bh=ehT1W02LPHHbQC4CpSx98mgh4CIOnT+AKMKHij0IAzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TM8mSvH25ygAbWXSJu7522o0H7eWcxclcyB+Ha4SYk533o/JgUwP1fnU1+oO9g13o
         qdLH38k9WHFa/V0WkyYlp+0viQjkyV9SAPjPyi6qRATuDDAlAlVocuxwCyxskaM2NC
         42E9R5St1coC3HCrxeEVWfEAoCf4Xg8/vxQ2GYF3utdgnD8qPULjKugXbmDs1SdPx+
         avn1/2FUHZxw0kjcvcJVLQqfkPr7txElsqtOfPUTUCGbNLfkBfJzVlxidOqnOH0qQs
         kTEt1dzATV/9v4LcwbYi25NlaUsxbYyjWDJD7BilHSZ+UP48HGGmdpFrk7HOIF9eR5
         yo+5hldwqM9wA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 062/116] x86/mce: Mark mce_panic() noinstr
Date:   Mon, 17 Jan 2022 21:39:13 -0500
Message-Id: <20220118024007.1950576-62-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 3c7ce80a818fa7950be123cac80cd078e5ac1013 ]

And allow instrumentation inside it because it does calls to other
facilities which will not be tagged noinstr.

Fixes

  vmlinux.o: warning: objtool: do_machine_check()+0xc73: call to mce_panic() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211208111343.8130-8-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 34fffffaf8730..64d8a96a2bf1e 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -295,11 +295,17 @@ static void wait_for_panic(void)
 	panic("Panicing machine check CPU died");
 }
 
-static void mce_panic(const char *msg, struct mce *final, char *exp)
+static noinstr void mce_panic(const char *msg, struct mce *final, char *exp)
 {
-	int apei_err = 0;
 	struct llist_node *pending;
 	struct mce_evt_llist *l;
+	int apei_err = 0;
+
+	/*
+	 * Allow instrumentation around external facilities usage. Not that it
+	 * matters a whole lot since the machine is going to panic anyway.
+	 */
+	instrumentation_begin();
 
 	if (!fake_panic) {
 		/*
@@ -314,7 +320,7 @@ static void mce_panic(const char *msg, struct mce *final, char *exp)
 	} else {
 		/* Don't log too much for fake panic */
 		if (atomic_inc_return(&mce_fake_panicked) > 1)
-			return;
+			goto out;
 	}
 	pending = mce_gen_pool_prepare_records();
 	/* First print corrected ones that are still unlogged */
@@ -352,6 +358,9 @@ static void mce_panic(const char *msg, struct mce *final, char *exp)
 		panic(msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
+
+out:
+	instrumentation_end();
 }
 
 /* Support code for software error injection */
-- 
2.34.1

