Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66D853DBE6
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347913AbiFEN4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347947AbiFENzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:55:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC215F4F;
        Sun,  5 Jun 2022 06:55:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDC35B80DA1;
        Sun,  5 Jun 2022 13:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5804EC385A5;
        Sun,  5 Jun 2022 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654437306;
        bh=Vr7VThk1XbeLwsLjyjYcdxc1AE5dwjiu8m73nzLb5Wk=;
        h=From:To:Cc:Subject:Date:From;
        b=Uiqxk0rjAFfy1erfD7f/0rriWL+8N9Ve6uGI3lyKttKkyJI3yi51Gd50rS7AzpoTW
         BkJhsrGioj/6+IJhGUn038YE2yixB1uhPkL3/Iiqm6VKyrAopBBAKAgtP3USfR1x5c
         Tet1u7EBDoKttvxCOeTC0VEPvf6Tm7cMmvWEmkvh15cfrum8lLjwJvKGFMlxizO3KQ
         tNwFNg9XeHPFysA4JG+j5xjVtN5SVfIII7rWQtIEyXGX71KzvSwBF0zKFYTwxNNPX8
         ajQJ0dDNLIkcuQ9qrTfppOcHpXsbY6YUjdajCn0ESMT7iHQ02tcrwaZ/tJQxVroBC1
         /+Os8aukGovIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, peterz@infradead.org, jkosina@suse.cz
Subject: [PATCH MANUALSEL 5.4 1/4] x86/nmi: Make register_nmi_handler() more robust
Date:   Sun,  5 Jun 2022 09:54:57 -0400
Message-Id: <20220605135503.61690-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit a7fed5c0431dbfa707037848830f980e0f93cfb3 ]

register_nmi_handler() has no sanity check whether a handler has been
registered already. Such an unintended double-add leads to list corruption
and hard to diagnose problems during the next NMI handling.

Init the list head in the static NMI action struct and check it for being
empty in register_nmi_handler().

  [ bp: Fixups. ]

Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/lkml/20220511234332.3654455-1-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/nmi.h |  1 +
 arch/x86/kernel/nmi.c      | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 9d5d949e662e..655ca59acfe7 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -48,6 +48,7 @@ struct nmiaction {
 #define register_nmi_handler(t, fn, fg, n, init...)	\
 ({							\
 	static struct nmiaction init fn##_na = {	\
+		.list = LIST_HEAD_INIT(fn##_na.list),	\
 		.handler = (fn),			\
 		.name = (n),				\
 		.flags = (fg),				\
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 5bb001c0c771..0d95273951ea 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -160,7 +160,7 @@ int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 	struct nmi_desc *desc = nmi_to_desc(type);
 	unsigned long flags;
 
-	if (!action->handler)
+	if (WARN_ON_ONCE(!action->handler || !list_empty(&action->list)))
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
@@ -180,7 +180,7 @@ int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 		list_add_rcu(&action->list, &desc->head);
 	else
 		list_add_tail_rcu(&action->list, &desc->head);
-	
+
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
@@ -189,7 +189,7 @@ EXPORT_SYMBOL(__register_nmi_handler);
 void unregister_nmi_handler(unsigned int type, const char *name)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
-	struct nmiaction *n;
+	struct nmiaction *n, *found = NULL;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
@@ -203,12 +203,16 @@ void unregister_nmi_handler(unsigned int type, const char *name)
 			WARN(in_nmi(),
 				"Trying to free NMI (%s) from NMI context!\n", n->name);
 			list_del_rcu(&n->list);
+			found = n;
 			break;
 		}
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	synchronize_rcu();
+	if (found) {
+		synchronize_rcu();
+		INIT_LIST_HEAD(&found->list);
+	}
 }
 EXPORT_SYMBOL_GPL(unregister_nmi_handler);
 
-- 
2.35.1

