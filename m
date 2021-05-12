Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A55537C4E6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhELPd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232285AbhELP2u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F28B61936;
        Wed, 12 May 2021 15:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832503;
        bh=OqRXgZiLc/duX1tnzvNI3h9UIXALkeYkxo5jIsuPOKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CeO6nMFdStypF28CGld2P2th40sYf/G49gnho7/JTa6TQf1LEZ7mAgLyMnDjj2a0
         usTEliL+xyLyfR5VXdlHwpNe0dHAraG1BbTlBOh7cNnq6K7rmr14SlxoJ+XdoV/ctP
         pDvfuaXp93ZGSoeOZ1404+6xTTJ87SJwyNai0ea0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenta Tada <Kenta.Tada@sony.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/530] seccomp: Fix CONFIG tests for Seccomp_filters
Date:   Wed, 12 May 2021 16:46:57 +0200
Message-Id: <20210512144829.887200008@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenta.Tada@sony.com <Kenta.Tada@sony.com>

[ Upstream commit 64bdc0244054f7d4bb621c8b4455e292f4e421bc ]

Strictly speaking, seccomp filters are only used
when CONFIG_SECCOMP_FILTER.
This patch fixes the condition to enable "Seccomp_filters"
in /proc/$pid/status.

Signed-off-by: Kenta Tada <Kenta.Tada@sony.com>
Fixes: c818c03b661c ("seccomp: Report number of loaded filters in /proc/$pid/status")
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/OSBPR01MB26772D245E2CF4F26B76A989F5669@OSBPR01MB2677.jpnprd01.prod.outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/array.c  | 2 ++
 init/init_task.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 65ec2029fa80..18a4588c35be 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -341,8 +341,10 @@ static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
 	seq_put_decimal_ull(m, "NoNewPrivs:\t", task_no_new_privs(p));
 #ifdef CONFIG_SECCOMP
 	seq_put_decimal_ull(m, "\nSeccomp:\t", p->seccomp.mode);
+#ifdef CONFIG_SECCOMP_FILTER
 	seq_put_decimal_ull(m, "\nSeccomp_filters:\t",
 			    atomic_read(&p->seccomp.filter_count));
+#endif
 #endif
 	seq_puts(m, "\nSpeculation_Store_Bypass:\t");
 	switch (arch_prctl_spec_ctrl_get(p, PR_SPEC_STORE_BYPASS)) {
diff --git a/init/init_task.c b/init/init_task.c
index 16d14c2ebb55..5fa18ed59d33 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -210,7 +210,7 @@ struct task_struct init_task
 #ifdef CONFIG_SECURITY
 	.security	= NULL,
 #endif
-#ifdef CONFIG_SECCOMP
+#ifdef CONFIG_SECCOMP_FILTER
 	.seccomp	= { .filter_count = ATOMIC_INIT(0) },
 #endif
 };
-- 
2.30.2



