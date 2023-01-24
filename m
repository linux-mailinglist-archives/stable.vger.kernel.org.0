Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187B067A315
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 20:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbjAXTfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 14:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbjAXTfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 14:35:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71DECA18;
        Tue, 24 Jan 2023 11:35:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 406736134B;
        Tue, 24 Jan 2023 19:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D744C4339B;
        Tue, 24 Jan 2023 19:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674588921;
        bh=dM/d0ubHLSl2Cs4adfZyHmQBOJqZC9Il4OfnR6+zIyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1YfeeBGeTJDr4GlHYVDNWDIW8dokgKt0iy6zlPWj0sXR5pkwqam6OgvXA2VnlLN1
         5CHXf5orzZy4Xdp2PTN3A2YLpnSHUpZtcHSnRag5SCLiuiQ+QkDhPov/OXp2DpR2JD
         6yL0p9+iBHpcIr8S0P6wO3nWqRO9ENFmUvjyeWlsCPLmbbFl7fOy8UPmVKvnSX2BIn
         pfcyAHvoV713cVcfumCFdTR9sAdM+PBcrnw+tny+U9TWeC9V85Tmo412JhglurJLpd
         F3QAdJjlLcepAynMGKuJvKPAnaoz5DnHDdtiuYyDLOSA3dr93LYsMmPN+XzKyD0PEL
         lwP2KATxZs+Xw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        tangmeng <tangmeng@uniontech.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.10 12/20] panic: Separate sysctl logic from CONFIG_SMP
Date:   Tue, 24 Jan 2023 11:29:56 -0800
Message-Id: <20230124193004.206841-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124193004.206841-1-ebiggers@kernel.org>
References: <20230124193004.206841-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 9360d035a579d95d1e76c471061b9065b18a0eb1 upstream.

In preparation for adding more sysctls directly in kernel/panic.c, split
CONFIG_SMP from the logic that adds sysctls.

Cc: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: tangmeng <tangmeng@uniontech.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221117234328.594699-1-keescook@chromium.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 kernel/panic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 960c2be2759cb..09f0802212c38 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -72,8 +72,9 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
-#if defined(CONFIG_SMP) && defined(CONFIG_SYSCTL)
+#ifdef CONFIG_SYSCTL
 static struct ctl_table kern_panic_table[] = {
+#ifdef CONFIG_SMP
 	{
 		.procname       = "oops_all_cpu_backtrace",
 		.data           = &sysctl_oops_all_cpu_backtrace,
@@ -83,6 +84,7 @@ static struct ctl_table kern_panic_table[] = {
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = SYSCTL_ONE,
 	},
+#endif
 	{ }
 };
 
-- 
2.39.1

