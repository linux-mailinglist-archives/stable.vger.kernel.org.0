Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B468A3C8FE8
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240540AbhGNTxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240650AbhGNTt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D86F6143E;
        Wed, 14 Jul 2021 19:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291945;
        bh=vO6jLsstg1PqDiZfbP7AfOwVNt2TH0F65zgaoPMvmsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tswgjlQDr95KfXqJGDz9NK9xQkYEA+CuZwt0uFgbhzm/l9exZNHwExkXIEfJlGhco
         saHBRrKt5HJArLmkFe4Vh8/sR87urzdS4ftVhUvSSkqmfz4rZwvoBtx6ROjFl9ocjk
         Dl08Hd/l01yO2WnDx73KmtubSDDIwfgm3ID0KzYqc07vc50qhttlrvF2i7yWyV01dr
         +Z7f7dnC70xHwyMykyqyYovElXX2SiFiFTiTlSo4hxjRyuACumPlFErPE3vmAFE9lh
         1UjaA1XEJaFqZ8Bj4TSufDNxtpI0PS3VsFW81cLoMjgCVGMkgQzFYU1evBIIMRzf7k
         pUE4+USxdho4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 22/51] kbuild: sink stdout from cmd for silent build
Date:   Wed, 14 Jul 2021 15:44:44 -0400
Message-Id: <20210714194513.54827-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 174a1dcc96429efce4ef7eb2f5c4506480da2182 ]

When building with 'make -s', no output to stdout should be printed.

As Arnd Bergmann reported [1], mkimage shows the detailed information
of the generated images.

I think this should be suppressed by the 'cmd' macro instead of by
individual scripts.

Insert 'exec >/dev/null;' in order to redirect stdout to /dev/null for
silent builds.

[Note about this implementation]

'exec >/dev/null;' may look somewhat tricky, but this has a reason.

Appending '>/dev/null' at the end of command line is a common way for
redirection, so I first tried this:

  cmd = @set -e; $(echo-cmd) $(cmd_$(1)) >/dev/null

... but it would not work if $(cmd_$(1)) itself contains a redirection.

For example, cmd_wrap in scripts/Makefile.asm-generic redirects the
output from the 'echo' command into the target file.

It would be expanded into:

  echo "#include <asm-generic/$*.h>" > $@ >/dev/null

Then, the target file gets empty because the string will go to /dev/null
instead of $@.

Next, I tried this:

  cmd = @set -e; $(echo-cmd) { $(cmd_$(1)); } >/dev/null

The form above would be expanded into:

  { echo "#include <asm-generic/$*.h>" > $@; } >/dev/null

This works as expected. However, it would be a syntax error if
$(cmd_$(1)) is empty.

When CONFIG_TRIM_UNUSED_KSYMS is disabled, $(call cmd,gen_ksymdeps) in
scripts/Makefile.build would be expanded into:

  set -e;  { ; } >/dev/null

..., which causes an syntax error.

I also tried this:

  cmd = @set -e; $(echo-cmd) ( $(cmd_$(1)) ) >/dev/null

... but this causes a syntax error for the same reason.

So, finally I adopted:

  cmd = @set -e; $(echo-cmd) exec >/dev/null; $(cmd_$(1))

[1]: https://lore.kernel.org/lkml/20210514135752.2910387-1-arnd@kernel.org/

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Kbuild.include | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 7da10afc92c6..b14a7d4a2f05 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -182,8 +182,13 @@ clean := -f $(srctree)/scripts/Makefile.clean obj
 echo-cmd = $(if $($(quiet)cmd_$(1)),\
 	echo '  $(call escsq,$($(quiet)cmd_$(1)))$(echo-why)';)
 
+# sink stdout for 'make -s'
+       redirect :=
+ quiet_redirect :=
+silent_redirect := exec >/dev/null;
+
 # printing commands
-cmd = @set -e; $(echo-cmd) $(cmd_$(1))
+cmd = @set -e; $(echo-cmd) $($(quiet)redirect) $(cmd_$(1))
 
 ###
 # if_changed      - execute command if any prerequisite is newer than
-- 
2.30.2

