Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C86BE194D16
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgCZXY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727879AbgCZXYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C06A2077D;
        Thu, 26 Mar 2020 23:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265064;
        bh=Mq8XZp3oxdegVK/AR4yoqDQJKIhsfYHXvEdCtjjFlkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKFVNLem5oipBDeKya5Uba/fFIDlWTvgZKtiB3dzcS0LvsQYDKDyQfO3nccHuDPSZ
         2OVqTicJQBleOR630w6Bv0qII52ztTxh852b9UMLMsG1YV7aDp4Ef9UjmlhrnidQML
         QIOF2dQ9vHrJrZsuBichHPwUHMA0u+4TUuxzy/5M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dmitry Vyukov <dvyukov@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 23/28] kconfig: Add yes2modconfig and mod2yesconfig targets.
Date:   Thu, 26 Mar 2020 19:23:52 -0400
Message-Id: <20200326232357.7516-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232357.7516-1-sashal@kernel.org>
References: <20200326232357.7516-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit 89b9060987d988333de59dd218c9666bd7ee95a5 ]

Since kernel configs provided by syzbot are close to "make allyesconfig",
it takes long time to rebuild. This is especially waste of time when we
need to rebuild for many times (e.g. doing manual printk() inspection,
bisect operations).

We can save time if we can exclude modules which are irrelevant to each
problem. But "make localmodconfig" cannot exclude modules which are built
into vmlinux because /sbin/lsmod output is used as the source of modules.

Therefore, this patch adds "make yes2modconfig" which converts from =y
to =m if possible. After confirming that the interested problem is still
reproducible, we can try "make localmodconfig" (and/or manually tune
based on "Modules linked in:" line) in order to exclude modules which are
irrelevant to the interested problem. While we are at it, this patch also
adds "make mod2yesconfig" which converts from =m to =y in case someone
wants to convert from =m to =y after "make localmodconfig".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/Makefile   |  4 +++-
 scripts/kconfig/conf.c     | 16 ++++++++++++++++
 scripts/kconfig/confdata.c | 16 ++++++++++++++++
 scripts/kconfig/lkc.h      |  3 +++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 2f1a59fa51694..811fb930b93bc 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -67,7 +67,7 @@ localyesconfig localmodconfig: $(obj)/conf
 #  deprecated for external use
 simple-targets := oldconfig allnoconfig allyesconfig allmodconfig \
 	alldefconfig randconfig listnewconfig olddefconfig syncconfig \
-	helpnewconfig
+	helpnewconfig yes2modconfig mod2yesconfig
 
 PHONY += $(simple-targets)
 
@@ -135,6 +135,8 @@ help:
 	@echo  '  allmodconfig	  - New config selecting modules when possible'
 	@echo  '  alldefconfig    - New config with all symbols set to default'
 	@echo  '  randconfig	  - New config with random answer to all options'
+	@echo  '  yes2modconfig	  - Change answers from yes to mod if possible'
+	@echo  '  mod2yesconfig	  - Change answers from mod to yes if possible'
 	@echo  '  listnewconfig   - List new options'
 	@echo  '  helpnewconfig   - List new options and help text'
 	@echo  '  olddefconfig	  - Same as oldconfig but sets new symbols to their'
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 1f89bf1558ce2..f6e548b8f7955 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -34,6 +34,8 @@ enum input_mode {
 	listnewconfig,
 	helpnewconfig,
 	olddefconfig,
+	yes2modconfig,
+	mod2yesconfig,
 };
 static enum input_mode input_mode = oldaskconfig;
 
@@ -467,6 +469,8 @@ static struct option long_opts[] = {
 	{"listnewconfig",   no_argument,       NULL, listnewconfig},
 	{"helpnewconfig",   no_argument,       NULL, helpnewconfig},
 	{"olddefconfig",    no_argument,       NULL, olddefconfig},
+	{"yes2modconfig",   no_argument,       NULL, yes2modconfig},
+	{"mod2yesconfig",   no_argument,       NULL, mod2yesconfig},
 	{NULL, 0, NULL, 0}
 };
 
@@ -489,6 +493,8 @@ static void conf_usage(const char *progname)
 	printf("  --allmodconfig          New config where all options are answered with mod\n");
 	printf("  --alldefconfig          New config with all symbols set to default\n");
 	printf("  --randconfig            New config with random answer to all options\n");
+	printf("  --yes2modconfig         Change answers from yes to mod if possible\n");
+	printf("  --mod2yesconfig         Change answers from mod to yes if possible\n");
 }
 
 int main(int ac, char **av)
@@ -553,6 +559,8 @@ int main(int ac, char **av)
 		case listnewconfig:
 		case helpnewconfig:
 		case olddefconfig:
+		case yes2modconfig:
+		case mod2yesconfig:
 			break;
 		case '?':
 			conf_usage(progname);
@@ -587,6 +595,8 @@ int main(int ac, char **av)
 	case listnewconfig:
 	case helpnewconfig:
 	case olddefconfig:
+	case yes2modconfig:
+	case mod2yesconfig:
 		conf_read(NULL);
 		break;
 	case allnoconfig:
@@ -660,6 +670,12 @@ int main(int ac, char **av)
 		break;
 	case savedefconfig:
 		break;
+	case yes2modconfig:
+		conf_rewrite_mod_or_yes(def_y2m);
+		break;
+	case mod2yesconfig:
+		conf_rewrite_mod_or_yes(def_m2y);
+		break;
 	case oldaskconfig:
 		rootEntry = &rootmenu;
 		conf(&rootmenu);
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 17298239e3633..eb1efa3abdee6 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1362,3 +1362,19 @@ bool conf_set_all_new_symbols(enum conf_def_mode mode)
 
 	return has_changed;
 }
+
+void conf_rewrite_mod_or_yes(enum conf_def_mode mode)
+{
+	struct symbol *sym;
+	int i;
+	tristate old_val = (mode == def_y2m) ? yes : mod;
+	tristate new_val = (mode == def_y2m) ? mod : yes;
+
+	for_all_symbols(i, sym) {
+		if (sym_get_type(sym) == S_TRISTATE &&
+		    sym->def[S_DEF_USER].tri == old_val) {
+			sym->def[S_DEF_USER].tri = new_val;
+			sym_add_change_count(1);
+		}
+	}
+}
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 4fb16f3166268..2bcc7bde6a338 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -34,6 +34,8 @@ enum conf_def_mode {
 	def_default,
 	def_yes,
 	def_mod,
+	def_y2m,
+	def_m2y,
 	def_no,
 	def_random
 };
@@ -52,6 +54,7 @@ const char *conf_get_configname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
 bool conf_set_all_new_symbols(enum conf_def_mode mode);
+void conf_rewrite_mod_or_yes(enum conf_def_mode mode);
 void set_all_choice_values(struct symbol *csym);
 
 /* confdata.c and expr.c */
-- 
2.20.1

