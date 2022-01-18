Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4FE49163E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345854AbiARCcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344033AbiARC2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:28:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECB1C0612A3;
        Mon, 17 Jan 2022 18:25:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B385F6093C;
        Tue, 18 Jan 2022 02:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC0EC36AE3;
        Tue, 18 Jan 2022 02:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472754;
        bh=76k952JqIoqnSJrdx/YN9ePOzNmgl602GkwnJ/y28TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y07r/UnybbIRW+JE5316GaCnU065a1dwGtYCz/zmb6QLi0gmJLreQoTBpz0AsjOzi
         c6IHbqchmNwmM+nyreqMzaPNnxB+uRA3amhuQFjnsg8QVdAK+24KUJFPuRFWF2k+R7
         N2tTX2tapU+0HdcHkOrUwt5J/ydkZ96JoEX49+/fEd30QkUewWJgdDGrxXIDh9Z+aw
         B81U0tX4O3Jnq1vDGrPa9o8jwUQ/G9ExQpGZG3XOGIJ4nXMTmGaRukK45GHETQZl5T
         4O3J/oR75yLGn4Di4yxY7oMWqYf033a7meP1pm6GGv6UbfvminakcSd9KFENdSQlXq
         IoOeGJAAkezig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 124/217] x86/mce: Mark mce_panic() noinstr
Date:   Mon, 17 Jan 2022 21:18:07 -0500
Message-Id: <20220118021940.1942199-124-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 70ec5685906b2..9a52ec55e0555 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -267,11 +267,17 @@ static void wait_for_panic(void)
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
@@ -286,7 +292,7 @@ static void mce_panic(const char *msg, struct mce *final, char *exp)
 	} else {
 		/* Don't log too much for fake panic */
 		if (atomic_inc_return(&mce_fake_panicked) > 1)
-			return;
+			goto out;
 	}
 	pending = mce_gen_pool_prepare_records();
 	/* First print corrected ones that are still unlogged */
@@ -324,6 +330,9 @@ static void mce_panic(const char *msg, struct mce *final, char *exp)
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

