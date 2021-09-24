Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE8F416B8D
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 08:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244230AbhIXGYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 02:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244232AbhIXGW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 02:22:57 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45149C0613C1
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 23:20:18 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id j14so5779972plx.4
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 23:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5WCcuqE5ATqYYHgSY5EFkOCbHMpsSpyspHQpjUNcv5Y=;
        b=USHlnTajiNdM3P0VqSbAStEFaTYJqzSg2nm8ztUGra2sh16n3N01QtIiwG20m1d8E6
         gGXkwSZDUKgQ0zX/AiF0MDejr+diNlb9FGN0Zhf6/ppRfEeSRs3ijG839x/k4a+/DPb9
         JAS5vCtmD2lzaA67KHZaDPUzKqWnavkhSuSRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5WCcuqE5ATqYYHgSY5EFkOCbHMpsSpyspHQpjUNcv5Y=;
        b=gh5fL+k5Yk8ptk0TF5xfujGEzgkg5xIWDXTOO3MaeCN0d5yOebA29BpNNdPTS6pg3v
         c5sC7L7h8Sua8+EvwEJwMjoaRfrQ01rqTZRFyTtFzlFGOJaj2iIKmE4OKYFKfIgHXYIF
         LHGirhyWD/wso+Fxe0ctTRZyjgK+nDolrCJgaP3TmiFndHyKhH7CSCImi8ZmLw6WZNVS
         IET1FAX8VygFcW2LsJRJbk39JWHNUxIhNjl8otdP9lZ7pvOOyCCb68jFJ2HYfW5+pgyO
         n17/vIUYyJXOkrR5pUVGE6/lrSoSrz+dmMf901yIwnmvr/yOHlNKJrUEW4DfurUaLJHc
         nNrg==
X-Gm-Message-State: AOAM531AXpCtIwckUpptx5gE864LkIpYiWKj33UDjPPNCCnzqtzUTWwo
        kyaAB0McnnYdyV6vYadwaoNp8Q==
X-Google-Smtp-Source: ABdhPJzfo1VcZJOORPchCfryh29i7+7kZ0+4SqFHpt+xI9bVgeTLDt8+VLo9QSQzSiBPaVyH03zneg==
X-Received: by 2002:a17:90a:460a:: with SMTP id w10mr270337pjg.132.1632464417651;
        Thu, 23 Sep 2021 23:20:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e2sm7733726pfn.141.2021.09.23.23.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 23:20:16 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <oliver.sang@intel.com>,
        Vito Caputo <vcaputo@pengaru.com>,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Tobin C. Harding" <me@tobin.cc>,
        Tycho Andersen <tycho@tycho.pizza>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Stefan Metzmacher <metze@samba.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Michal Hocko <mhocko@suse.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ohhoon Kwon <ohoono.kwon@samsung.com>,
        YiFei Zhu <yifeifz2@illinois.edu>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        x86@kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/3] Revert "proc/wchan: use printk format instead of lookup_symbol_name()"
Date:   Thu, 23 Sep 2021 23:20:04 -0700
Message-Id: <20210924062006.231699-2-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924062006.231699-1-keescook@chromium.org>
References: <20210924062006.231699-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1921; h=from:subject; bh=48rNinxgYhX0MMt+z9ytmuG8GHuOw2IZ5/XYplBnCcc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhTW4V3aAmkY3cNkeh8mx6qR4Wd4ABLM9VfEd7+ihZ Bx7vHSCJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYU1uFQAKCRCJcvTf3G3AJnoXD/ 9+ie60XyWvsYauLjXuepEjG45dMmVfHo8TJw7OCNXZ2lTIe5ZGlf6Rx4OVEwn44n4dTUH8avAsCeKU tw8F1HJKdyRsL3NojF9a7XLqhrfqcnRaDkh/0BQejpIToUmgWFrtjFdKlKi0AfADEqEiMAqi7JHSZj lE1dM2Vxe1Paqq79EITBohvHgYebZ3WrG4OuDaw1Vxpy8DoeElQfU+5pcvDokYbIls5rQAnAH4AtUp TVlgob8YzJvqYTYCDyIb9yxXKG7NAaY16IKLIhgnxcu75kkVFJ9CDRNIj1YHu7bbosm4rYpS7zACEM 0X2UGQ5R4jMA2jP2jP5CeNr3hotGrlZ8rtZ/SkhcWdcgu6Br7T4YnrAo6o99k7unwja/t4wugVSbcc sm7ZrehQY2OqsB/m7q4ClgVslqFfVcJRTvXlrAQJoQuCp419WQ90WLqdWheX1fZmu+kILVE2c3Zz28 fSCWDwW2Tc/g4VxVVqtjtiZkSZxBkcfyzt0e9R/Aciv2Y+Z95MtshjPERDwO6BaarMumHYWcwmMG+Z uBdVf6svZlcVnsn3J4HEnNZlk47ez87SpbihS9Vud0VBydXWwYsXBTLtFi9yT/EzMIG1INYJ62cs1B w/bp15u2DxJQTfDAKRvzhLl7s/oYbFUbxJ+vogxQzPbKDzPi2NQ4UKbDo4wQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 152c432b128cb043fc107e8f211195fe94b2159c.

When a kernel address couldn't be symbolized for /proc/$pid/wchan, it
would leak the raw value, a potential information exposure. This is a
regression compared to the safer pre-v5.12 behavior.

Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/all/20210103142726.GC30643@xsang-OptiPlex-9020/
Reported-by: Vito Caputo <vcaputo@pengaru.com>
Link: https://lore.kernel.org/lkml/20210921193249.el476vlhg5k6lfcq@shells.gnugeneration.com/
Reported-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/lkml/CAG48ez2zC=+PuNgezH53HBPZ8CXU5H=vkWx7nJs60G8RXt3w0Q@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/proc/base.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 533d5836eb9a..1f394095eb88 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -67,6 +67,7 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/rcupdate.h>
+#include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
 #include <linux/resource.h>
 #include <linux/module.h>
@@ -386,17 +387,19 @@ static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
 			  struct pid *pid, struct task_struct *task)
 {
 	unsigned long wchan;
+	char symname[KSYM_NAME_LEN];
 
-	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
-		wchan = get_wchan(task);
-	else
-		wchan = 0;
+	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
+		goto print0;
 
-	if (wchan)
-		seq_printf(m, "%ps", (void *) wchan);
-	else
-		seq_putc(m, '0');
+	wchan = get_wchan(task);
+	if (wchan && !lookup_symbol_name(wchan, symname)) {
+		seq_puts(m, symname);
+		return 0;
+	}
 
+print0:
+	seq_putc(m, '0');
 	return 0;
 }
 #endif /* CONFIG_KALLSYMS */
-- 
2.30.2

