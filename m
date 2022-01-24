Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D904990A6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359765AbiAXUCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:02:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42774 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344007AbiAXUAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:00:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33BBDB81218;
        Mon, 24 Jan 2022 20:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56124C340E5;
        Mon, 24 Jan 2022 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054421;
        bh=ehT1W02LPHHbQC4CpSx98mgh4CIOnT+AKMKHij0IAzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CldPozz/hgOS6PkcXNiifqofcJPm2nXcSNZadRaMqTLhswYJE3HR7GzjwiA6E8mCt
         tA0BdMUR2QYy2HaTDntfQU7iQB0vNz4SxQqEzRy8QNFx0vjlSUgrWSNXpobI6fX9CP
         UkL7zomYVGgGRU5zOdOqPe9x/rUyGF5BvWvLT30Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 357/563] x86/mce: Mark mce_panic() noinstr
Date:   Mon, 24 Jan 2022 19:42:02 +0100
Message-Id: <20220124184036.765131336@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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



