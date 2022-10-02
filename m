Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4606F5F2718
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJBXLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 19:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiJBXLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 19:11:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C59E4BA68;
        Sun,  2 Oct 2022 16:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 740BDB80DAD;
        Sun,  2 Oct 2022 22:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF69C433D7;
        Sun,  2 Oct 2022 22:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751176;
        bh=FMtJbvUlcZMfZJsHs+zcMqbDLnAq+to6DJYsgnmO13c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqA4ZLWgQHXbrmDDjj1y8BMnFDx2z8xLf3KUR+FVkwdJrfSjUTJOQrhE5xhCp7gsC
         o8hK3BwbQaBYsheaSVKw+j4+GDa7ZuVGiZVNJzX75M21H5gjDqoigGTnaeA1rd/44Z
         J6W3SD8mZZpatlPwUGTxsHeBkCtYBSKG8hFbmQkHc77p5r3BZ3e7Y9xUS/DlHAAjCl
         7Sq0rnSpAFcDYzIDanq6FpfxvC0fLavlX+D2Z2sUOR2c5zpS5nHG/mIYF1T1NONbIK
         MHQpOW1sOBpT94A/bpeRm3ZqpWeRclVEf2Kue0pm75JNYk/IbKKrfybpXqqS2FIHqB
         z9n0x4TOrbtkA==
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
Subject: [PATCH AUTOSEL 5.4 8/9] um: Cleanup compiler warning in arch/x86/um/tls_32.c
Date:   Sun,  2 Oct 2022 18:52:35 -0400
Message-Id: <20221002225236.239675-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225236.239675-1-sashal@kernel.org>
References: <20221002225236.239675-1-sashal@kernel.org>
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

