Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441AD499C3E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578839AbiAXWDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577000AbiAXV5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:57:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14005C09426C;
        Mon, 24 Jan 2022 12:38:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF3E9B81218;
        Mon, 24 Jan 2022 20:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0C0C340E5;
        Mon, 24 Jan 2022 20:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056715;
        bh=sUaXfDJ9Sn5dKwepOQtj6siD2em1urOqxKMAIkUatHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5P6qHCm77e5PcSVKe91pZRDTsIVk1UX3rIUlQSaMGrY+Vzqg9s2plJZmyHGlphMt
         F5lm8GaLzXoJGJARlLPyYY+qZ5M5Qfua2uTnr316Pdr/XCkBxNNxRc8u2nZ0WcsyJV
         Me0DHZvmTFyBRC6CkCTe+ajNPFmVYN9lVg40C7c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 543/846] x86/mce: Mark mce_panic() noinstr
Date:   Mon, 24 Jan 2022 19:41:00 +0100
Message-Id: <20220124184119.759494910@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



