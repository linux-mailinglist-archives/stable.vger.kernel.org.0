Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B6B15F109
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390148AbgBNR73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387969AbgBNP4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3491622314;
        Fri, 14 Feb 2020 15:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695805;
        bh=HKeMxL5ZUVTWH4JoSyoUUnaQXnce4b+RfVZRfN5KBUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYjxW9GDY94K+WEGYkSjnK0DoM5eiC4vsSqR/ZrKiN8mc/m3/vwQyW2mONpAwCDOW
         lDiCGNsXybOCHcqKKK0Mtz52/AfsTgcbVNAHMs4xq+9Y3fX3EJi328SOzztX7walxE
         JL59QYtuLgbkEXbPA6R4wM9fDoy1uPKMpZx01viA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 365/542] kbuild: remove *.tmp file when filechk fails
Date:   Fri, 14 Feb 2020 10:45:57 -0500
Message-Id: <20200214154854.6746-365-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 88fe89a47153facd8cb2d06d5c8727f7224c43c2 ]

Bartosz Golaszewski reports that when "make {menu,n,g,x}config" fails
due to missing packages, a temporary file is left over, which is not
ignored by git.

For example, if GTK+ is not installed:

  $ make gconfig
  *
  * Unable to find the GTK+ installation. Please make sure that
  * the GTK+ 2.0 development package is correctly installed.
  * You need gtk+-2.0 gmodule-2.0 libglade-2.0
  *
  scripts/kconfig/Makefile:208: recipe for target 'scripts/kconfig/gconf-cfg' failed
  make[1]: *** [scripts/kconfig/gconf-cfg] Error 1
  Makefile:567: recipe for target 'gconfig' failed
  make: *** [gconfig] Error 2
  $ git status
  HEAD detached at v5.4
  Untracked files:
    (use "git add <file>..." to include in what will be committed)

          scripts/kconfig/gconf-cfg.tmp

  nothing added to commit but untracked files present (use "git add" to track)

This is because the check scripts are run with filechk, which misses
to clean up the temporary file on failure.

When the line

  { $(filechk_$(1)); } > $@.tmp;

... fails, it exits immediately due to the 'set -e'. Use trap to make
sure to delete the temporary file on exit.

For extra safety, I replaced $@.tmp with $(dot-target).tmp to make it
a hidden file.

Reported-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Kbuild.include | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index bc5f25763c1b9..f3155af04d859 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -55,14 +55,13 @@ kecho := $($(quiet)kecho)
 # - stdin is piped in from the first prerequisite ($<) so one has
 #   to specify a valid file as first prerequisite (often the kbuild file)
 define filechk
-	$(Q)set -e;				\
-	mkdir -p $(dir $@);			\
-	{ $(filechk_$(1)); } > $@.tmp;		\
-	if [ -r $@ ] && cmp -s $@ $@.tmp; then	\
-		rm -f $@.tmp;			\
-	else					\
-		$(kecho) '  UPD     $@';	\
-		mv -f $@.tmp $@;		\
+	$(Q)set -e;						\
+	mkdir -p $(dir $@);					\
+	trap "rm -f $(dot-target).tmp" EXIT;			\
+	{ $(filechk_$(1)); } > $(dot-target).tmp;		\
+	if [ ! -r $@ ] || ! cmp -s $@ $(dot-target).tmp; then	\
+		$(kecho) '  UPD     $@';			\
+		mv -f $(dot-target).tmp $@;			\
 	fi
 endef
 
-- 
2.20.1

