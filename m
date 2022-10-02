Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968DE5F2655
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiJBWwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiJBWvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:51:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AFE1A3B2;
        Sun,  2 Oct 2022 15:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AB8CB80D9B;
        Sun,  2 Oct 2022 22:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA97AC43140;
        Sun,  2 Oct 2022 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751011;
        bh=FMtJbvUlcZMfZJsHs+zcMqbDLnAq+to6DJYsgnmO13c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xmqr2luRzWqioY74yM5M7EXsOiGk0RCyjF0DOAqccLnJLq/FS21o3wB75II1BZFEW
         zDtT1m/UY7nyF9D/POQAOXUpuRKcR+L2csuT10YuDKrtLRLuyZBbfl9kjSztWvBRrr
         zATs7SwFQ/fKmuEoJ6fkFIexvlDcy241k//OcXzHqFKSFSG1psiOylO174tr0hAOww
         ciToHauLNsGciyKVwFGbQDb51/gjILW0C7y163xa2oY3vw5YxYw46dNQ7HBBFEo/pm
         u3AEUr61hd+f69w8z/Dy7m9dHtRA3UCo7T/AOmjB67Dk8cCSZQXvvu3oXanQAwJg0C
         dXM8ibhMu88Ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Straub <lukasstraub2@web.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>,
        anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 17/29] um: Cleanup compiler warning in arch/x86/um/tls_32.c
Date:   Sun,  2 Oct 2022 18:49:10 -0400
Message-Id: <20221002224922.238837-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Straub <lukasstraub2@web.de>

[ Upstream commit d27fff3499671dc23a08efd01cdb8b3764a391c4 ]

arch.tls_array is statically allocated so checking for NULL doesn't
make sense. This causes the compiler warning below.

Remove the checks to silence these warnings.

../arch/x86/um/tls_32.c: In function 'get_free_idx':
../arch/x86/um/tls_32.c:68:13: warning: the comparison will always evaluate as 'true' for the address of 'tls_array' will never be NULL [-Waddress]
   68 |         if (!t->arch.tls_array)
      |             ^
In file included from ../arch/x86/um/asm/processor.h:10,
                 from ../include/linux/rcupdate.h:30,
                 from ../include/linux/rculist.h:11,
                 from ../include/linux/pid.h:5,
                 from ../include/linux/sched.h:14,
                 from ../arch/x86/um/tls_32.c:7:
../arch/x86/um/asm/processor_32.h:22:31: note: 'tls_array' declared here
   22 |         struct uml_tls_struct tls_array[GDT_ENTRY_TLS_ENTRIES];
      |                               ^~~~~~~~~
../arch/x86/um/tls_32.c: In function 'get_tls_entry':
../arch/x86/um/tls_32.c:243:13: warning: the comparison will always evaluate as 'true' for the address of 'tls_array' will never be NULL [-Waddress]
  243 |         if (!t->arch.tls_array)
      |             ^
../arch/x86/um/asm/processor_32.h:22:31: note: 'tls_array' declared here
   22 |         struct uml_tls_struct tls_array[GDT_ENTRY_TLS_ENTRIES];
      |                               ^~~~~~~~~

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/um/tls_32.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/um/tls_32.c b/arch/x86/um/tls_32.c
index ac8eee093f9c..66162eafd8e8 100644
--- a/arch/x86/um/tls_32.c
+++ b/arch/x86/um/tls_32.c
@@ -65,9 +65,6 @@ static int get_free_idx(struct task_struct* task)
 	struct thread_struct *t = &task->thread;
 	int idx;
 
-	if (!t->arch.tls_array)
-		return GDT_ENTRY_TLS_MIN;
-
 	for (idx = 0; idx < GDT_ENTRY_TLS_ENTRIES; idx++)
 		if (!t->arch.tls_array[idx].present)
 			return idx + GDT_ENTRY_TLS_MIN;
@@ -240,9 +237,6 @@ static int get_tls_entry(struct task_struct *task, struct user_desc *info,
 {
 	struct thread_struct *t = &task->thread;
 
-	if (!t->arch.tls_array)
-		goto clear;
-
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
 
-- 
2.35.1

