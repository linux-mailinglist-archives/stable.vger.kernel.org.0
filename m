Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F74227C598
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbgI2Lgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729416AbgI2LgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4CBE23E1C;
        Tue, 29 Sep 2020 11:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379077;
        bh=i7eIckC7xCZ6WpgoCxRS80uZO80NLNjN682rXocEHmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ6IpMwbtl7VcMeZT5oCLB7Ue9n7EW/UbwX/33EjlsWxaA8G0SOJVsDRULMyJHnxe
         neUyso6Ex9wcTliulJz1Yi/39H3eCpFNbM91MmaH/+D6DebFtahNr32pJZTlHI+FJ7
         xzCIaPGQd8TC5/O3Fyzdhet1Yg7ZJnvq1ookt7SY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 241/245] kprobes: Fix compiler warning for !CONFIG_KPROBES_ON_FTRACE
Date:   Tue, 29 Sep 2020 13:01:32 +0200
Message-Id: <20200929105958.724720484@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 10de795a5addd1962406796a6e13ba6cc0fc6bee upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kprobes.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1065,9 +1065,20 @@ static int disarm_kprobe_ftrace(struct k
 	return ret;
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


