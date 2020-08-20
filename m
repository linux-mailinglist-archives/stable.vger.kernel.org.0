Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0979424BEBE
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgHTNbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgHTJcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:32:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C32C207DE;
        Thu, 20 Aug 2020 09:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915962;
        bh=qFl7Iy+52Gchs3UMwFRTr9Ko4Q5HlQTP0GJLrl82L6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+P2oz4iSFwYoExS6xvJQEJ6M+Q7VMJvEMNtcDhNVRCfk/V3gXTBF3e/O/gUlTKX2
         aidyQQN/mNHxEta2LxoeZ/co7U2iwXTzl+ighlkxTlJjGPWxoaw7RNJR7j1ZZ4EHeq
         Dq53YRLiHsemRMaJsjfx2aVYVkGSZotL1e+snkp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 188/232] kprobes: Fix compiler warning for !CONFIG_KPROBES_ON_FTRACE
Date:   Thu, 20 Aug 2020 11:20:39 +0200
Message-Id: <20200820091621.901039914@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 10de795a5addd1962406796a6e13ba6cc0fc6bee ]

Fix compiler warning(as show below) for !CONFIG_KPROBES_ON_FTRACE.

kernel/kprobes.c: In function 'kill_kprobe':
kernel/kprobes.c:1116:33: warning: statement with no effect
[-Wunused-value]
 1116 | #define disarm_kprobe_ftrace(p) (-ENODEV)
      |                                 ^
kernel/kprobes.c:2154:3: note: in expansion of macro
'disarm_kprobe_ftrace'
 2154 |   disarm_kprobe_ftrace(p);

Link: https://lore.kernel.org/r/20200805142136.0331f7ea@canb.auug.org.au
Link: https://lkml.kernel.org/r/20200805172046.19066-1-songmuchun@bytedance.com

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 0cb2f1372baa ("kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index f54d4a29fc26e..72af5d37e9ff1 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1079,9 +1079,20 @@ static int disarm_kprobe_ftrace(struct kprobe *p)
 		ipmodify ? &kprobe_ipmodify_enabled : &kprobe_ftrace_enabled);
 }
 #else	/* !CONFIG_KPROBES_ON_FTRACE */
-#define prepare_kprobe(p)	arch_prepare_kprobe(p)
-#define arm_kprobe_ftrace(p)	(-ENODEV)
-#define disarm_kprobe_ftrace(p)	(-ENODEV)
+static inline int prepare_kprobe(struct kprobe *p)
+{
+	return arch_prepare_kprobe(p);
+}
+
+static inline int arm_kprobe_ftrace(struct kprobe *p)
+{
+	return -ENODEV;
+}
+
+static inline int disarm_kprobe_ftrace(struct kprobe *p)
+{
+	return -ENODEV;
+}
 #endif
 
 /* Arm a kprobe with text_mutex */
-- 
2.25.1



