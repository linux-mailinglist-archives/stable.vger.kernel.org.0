Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD9567A1D8
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 19:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbjAXSwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 13:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbjAXSwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 13:52:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45327485B3;
        Tue, 24 Jan 2023 10:52:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A174E61336;
        Tue, 24 Jan 2023 18:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60217C4339E;
        Tue, 24 Jan 2023 18:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674586332;
        bh=oM/na0j6KDMeNxgMkCt7OnT1CUcFT9V+mDvHYbo5v4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEo/hJUabqEsYEfWYqvuU37DZczDnvT7Tl71Gv1+qOevulSwjqqwBW+t2EuNiOSVp
         Grft20xPVgVdqjmMuKrn3CnvZMNzmD9c1ErpeVvd3ZIBBQBIWxqeCh81npymd9onz7
         4HNgGVElba0Lbu+t1LVroZn+N4+dm9NWFSIZsf55bJxKSWMuM7dgEkfjhNsIY3GRE6
         M0+XvQiWSpvFtim5VCXnBmc2szm1TzAsQQ8+WcFGAprA5NsPG2VbZpMRvUTyKZvYt1
         LU8Afue6V6Kt19dOLDVhKzeaUcUOaDI+H79SEOz/udNTX5wQNeAR5GW7ovkaKBcrid
         6q0IE3zyKjnJA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>,
        Huang Ying <ying.huang@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        tangmeng <tangmeng@uniontech.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-doc@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.15 17/20] panic: Introduce warn_limit
Date:   Tue, 24 Jan 2023 10:51:07 -0800
Message-Id: <20230124185110.143857-18-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124185110.143857-1-ebiggers@kernel.org>
References: <20230124185110.143857-1-ebiggers@kernel.org>
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

commit 9fc9e278a5c0b708eeffaf47d6eb0c82aa74ed78 upstream.

Like oops_limit, add warn_limit for limiting the number of warnings when
panic_on_warn is not set.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: tangmeng <tangmeng@uniontech.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-doc@vger.kernel.org
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221117234328.594699-5-keescook@chromium.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/admin-guide/sysctl/kernel.rst | 10 ++++++++++
 kernel/panic.c                              | 14 ++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index d6f1d3892e71e..48b91c485c993 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1494,6 +1494,16 @@ entry will default to 2 instead of 0.
 2 Unprivileged calls to ``bpf()`` are disabled
 = =============================================================
 
+
+warn_limit
+==========
+
+Number of kernel warnings after which the kernel should panic when
+``panic_on_warn`` is not set. Setting this to 0 disables checking
+the warning count. Setting this to 1 has the same effect as setting
+``panic_on_warn=1``. The default value is 0.
+
+
 watchdog
 ========
 
diff --git a/kernel/panic.c b/kernel/panic.c
index bf0324941e433..604d7ad77042e 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -57,6 +57,7 @@ bool crash_kexec_post_notifiers;
 int panic_on_warn __read_mostly;
 unsigned long panic_on_taint;
 bool panic_on_taint_nousertaint = false;
+static unsigned int warn_limit __read_mostly;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -86,6 +87,13 @@ static struct ctl_table kern_panic_table[] = {
 		.extra2         = SYSCTL_ONE,
 	},
 #endif
+	{
+		.procname       = "warn_limit",
+		.data           = &warn_limit,
+		.maxlen         = sizeof(warn_limit),
+		.mode           = 0644,
+		.proc_handler   = proc_douintvec,
+	},
 	{ }
 };
 
@@ -195,8 +203,14 @@ static void panic_print_sys_info(void)
 
 void check_panic_on_warn(const char *origin)
 {
+	static atomic_t warn_count = ATOMIC_INIT(0);
+
 	if (panic_on_warn)
 		panic("%s: panic_on_warn set ...\n", origin);
+
+	if (atomic_inc_return(&warn_count) >= READ_ONCE(warn_limit) && warn_limit)
+		panic("%s: system warned too often (kernel.warn_limit is %d)",
+		      origin, warn_limit);
 }
 
 /**
-- 
2.39.1

