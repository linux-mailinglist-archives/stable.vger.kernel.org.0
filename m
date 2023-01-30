Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068006811A3
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbjA3OP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237324AbjA3OP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:15:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C00C678
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:15:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B268D6104A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9552DC433D2;
        Mon, 30 Jan 2023 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088126;
        bh=1NncRQnNIj/73/OYMHncHkZe5r/DwOTJdKXbrFMm+LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFN4cBijpUrZr07rfEeQS7G4AQR6+65wau4mLzlFXKloA7qF9oWKEj4/wX8glPXLY
         VpEoTA2ttIVLv4yoHA7baO7BvJNFfXfNrcgxDc7tw9D/825pqZ5fxY4Pr6WTHDc4Rh
         WTTiAT4hkEA8/kHXR4JWg9OHiBo9Xo3MjAh4vPWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaoming Ni <nixiaoming@huawei.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Qing Wang <wangqing@vivo.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Amir Goldstein <amir73il@gmail.com>,
        Stephen Kitt <steve@sk2.org>, Antti Palosaari <crope@iki.fi>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        Lukas Middendorf <kernel@tuxforce.de>,
        Mark Fasheh <mark@fasheh.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jani Nikula <jani.nikula@intel.com>,
        John Ogness <john.ogness@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Theodore Tso" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/204] sysctl: add a new register_sysctl_init() interface
Date:   Mon, 30 Jan 2023 14:51:28 +0100
Message-Id: <20230130134321.905285901@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>

commit 3ddd9a808cee7284931312f2f3e854c9617f44b2 upstream.

Patch series "sysctl: first set of kernel/sysctl cleanups", v2.

Finally had time to respin the series of the work we had started last
year on cleaning up the kernel/sysct.c kitchen sink.  People keeps
stuffing their sysctls in that file and this creates a maintenance
burden.  So this effort is aimed at placing sysctls where they actually
belong.

I'm going to split patches up into series as there is quite a bit of
work.

This first set adds register_sysctl_init() for uses of registerting a
sysctl on the init path, adds const where missing to a few places,
generalizes common values so to be more easy to share, and starts the
move of a few kernel/sysctl.c out where they belong.

The majority of rework on v2 in this first patch set is 0-day fixes.
Eric Biederman's feedback is later addressed in subsequent patch sets.

I'll only post the first two patch sets for now.  We can address the
rest once the first two patch sets get completely reviewed / Acked.

This patch (of 9):

The kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we
just care about the core logic.

Today though folks heavily rely on tables on kernel/sysctl.c so they can
easily just extend this table with their needed sysctls.  In order to
help users move their sysctls out we need to provide a helper which can
be used during code initialization.

We special-case the initialization use of register_sysctl() since it
*is* safe to fail, given all that sysctls do is provide a dynamic
interface to query or modify at runtime an existing variable.  So the
use case of register_sysctl() on init should *not* stop if the sysctls
don't end up getting registered.  It would be counter productive to stop
boot if a simple sysctl registration failed.

Provide a helper for init then, and document the recommended init levels
to use for callers of this routine.  We will later use this in
subsequent patches to start slimming down kernel/sysctl.c tables and
moving sysctl registration to the code which actually needs these
sysctls.

[mcgrof@kernel.org: major commit log and documentation rephrasing also moved to fs/proc/proc_sysctl.c                  ]

Link: https://lkml.kernel.org/r/20211123202347.818157-1-mcgrof@kernel.org
Link: https://lkml.kernel.org/r/20211123202347.818157-2-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Turner <pjt@google.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Qing Wang <wangqing@vivo.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/proc_sysctl.c  | 33 +++++++++++++++++++++++++++++++++
 include/linux/sysctl.h |  3 +++
 2 files changed, 36 insertions(+)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 013fc5931bc3..0b7a00ed6c49 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/bpf-cgroup.h>
 #include <linux/mount.h>
+#include <linux/kmemleak.h>
 #include "internal.h"
 
 static const struct dentry_operations proc_sys_dentry_operations;
@@ -1384,6 +1385,38 @@ struct ctl_table_header *register_sysctl(const char *path, struct ctl_table *tab
 }
 EXPORT_SYMBOL(register_sysctl);
 
+/**
+ * __register_sysctl_init() - register sysctl table to path
+ * @path: path name for sysctl base
+ * @table: This is the sysctl table that needs to be registered to the path
+ * @table_name: The name of sysctl table, only used for log printing when
+ *              registration fails
+ *
+ * The sysctl interface is used by userspace to query or modify at runtime
+ * a predefined value set on a variable. These variables however have default
+ * values pre-set. Code which depends on these variables will always work even
+ * if register_sysctl() fails. If register_sysctl() fails you'd just loose the
+ * ability to query or modify the sysctls dynamically at run time. Chances of
+ * register_sysctl() failing on init are extremely low, and so for both reasons
+ * this function does not return any error as it is used by initialization code.
+ *
+ * Context: Can only be called after your respective sysctl base path has been
+ * registered. So for instance, most base directories are registered early on
+ * init before init levels are processed through proc_sys_init() and
+ * sysctl_init().
+ */
+void __init __register_sysctl_init(const char *path, struct ctl_table *table,
+				 const char *table_name)
+{
+	struct ctl_table_header *hdr = register_sysctl(path, table);
+
+	if (unlikely(!hdr)) {
+		pr_err("failed when register_sysctl %s to %s\n", table_name, path);
+		return;
+	}
+	kmemleak_not_leak(hdr);
+}
+
 static char *append_path(const char *path, char *pos, const char *name)
 {
 	int namelen;
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index fa372b4c2313..47cf70c8eb93 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -206,6 +206,9 @@ struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 void unregister_sysctl_table(struct ctl_table_header * table);
 
 extern int sysctl_init(void);
+extern void __register_sysctl_init(const char *path, struct ctl_table *table,
+				 const char *table_name);
+#define register_sysctl_init(path, table) __register_sysctl_init(path, table, #table)
 void do_sysctl_args(void);
 
 extern int pwrsw_enabled;
-- 
2.39.0



