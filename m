Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A7649173E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346411AbiARCis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:38:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46562 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344515AbiARCgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:36:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAE0DB81239;
        Tue, 18 Jan 2022 02:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3359C36AE3;
        Tue, 18 Jan 2022 02:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473403;
        bh=sUaXfDJ9Sn5dKwepOQtj6siD2em1urOqxKMAIkUatHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8wy0OdQLDoSZKkO/aDclWAM3QEEwmAxytOIzO3w9RfTr0CjzU3XDtCW8WJh7bfWp
         Ajuv/dbReXjIvbWetp346bIZcdPMkRrQaN8bYvZkZ0UL9pJa44mzFNVE9w1ZPhx12t
         /xUFaHDN05dXNYDUv69LU0sSReGET1xbU6ExchRGxT3Z3A3Jg/lwdRJM9s7X9V0Aqb
         spbmBNrM3m0nFO+AlRKlRsAB5Yzdf/rGY0+rowOxRN51MRFbxd5gxVzKkI5Xh7dx7L
         /zD+6VZhYTfPkk/zfbBZWP+Lt1uydQRVoITTzVeSHlULVKqLhpvvchqI+Sb6Jp43vF
         qtKipxRVQqh9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 105/188] x86/mce: Mark mce_panic() noinstr
Date:   Mon, 17 Jan 2022 21:30:29 -0500
Message-Id: <20220118023152.1948105-105-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index c8d121085c8f7..c5a1022463bcc 100644
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

