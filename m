Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F5153DBF6
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351067AbiFEN4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349895AbiFENz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:55:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA64CE3E;
        Sun,  5 Jun 2022 06:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62A4FB80D9F;
        Sun,  5 Jun 2022 13:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B6CC385A5;
        Sun,  5 Jun 2022 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654437322;
        bh=iKt+DAwJVdKoXIHc2pX0QmqOB5hDft9lDxOE2hekpSw=;
        h=From:To:Cc:Subject:Date:From;
        b=oZWF/hiuoK0tA2eufzbdl6ffG/+G6+S9GsfGI0rIEyxkw8G6s73An6MkfBEs8A/h/
         ZVqrfN3Xyw/p+mQsz93tr/Bo6HTRfvfvAX2yWs2yHfRfy55SyuZB2pZvwLfC6aXzyl
         5tx1Cp39PVk0dPXERCHZSnHnvUpYrvs3Oju8XEhkYKURXk7KvtE+DmX6vEwkzo0nwW
         JjrtxeynjalDYTqgG1Dg5EUfzFl5pxhr8fqGo3QeJnhpfW0nac3CDLVA6W8FYYpd5G
         fQ46c0IIPaW5xw+Uy8Yu0DI1eEtgk2Mn6+xztWXggS9uBWzd+A8bMSpL+djeuThj0a
         S5Fihxw8eIbpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, peterz@infradead.org, jkosina@suse.cz
Subject: [PATCH MANUALSEL 4.19 1/4] x86/nmi: Make register_nmi_handler() more robust
Date:   Sun,  5 Jun 2022 09:55:11 -0400
Message-Id: <20220605135519.61765-1-sashal@kernel.org>
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
index 996eb53f8eb7..75b68e499315 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -158,7 +158,7 @@ int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 	struct nmi_desc *desc = nmi_to_desc(type);
 	unsigned long flags;
 
-	if (!action->handler)
+	if (WARN_ON_ONCE(!action->handler || !list_empty(&action->list)))
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
@@ -178,7 +178,7 @@ int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 		list_add_rcu(&action->list, &desc->head);
 	else
 		list_add_tail_rcu(&action->list, &desc->head);
-	
+
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
@@ -187,7 +187,7 @@ EXPORT_SYMBOL(__register_nmi_handler);
 void unregister_nmi_handler(unsigned int type, const char *name)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
-	struct nmiaction *n;
+	struct nmiaction *n, *found = NULL;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
@@ -201,12 +201,16 @@ void unregister_nmi_handler(unsigned int type, const char *name)
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

