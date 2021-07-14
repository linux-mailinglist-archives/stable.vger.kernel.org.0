Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FD13C8C76
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbhGNTmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234001AbhGNTlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77276613CF;
        Wed, 14 Jul 2021 19:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291537;
        bh=p7QADGqyhrtfkCp/gEg7J+X9qhcFmVaqvBc+66MLyMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlvHgUHoS69yrvWXj7VfX4d+FQA25Ml3RqdZ5e5SbpbfSmnEAu1we6WId77rka1Hv
         zBZDjASw8Bi7bWMr7YJ0eesSffExtCuTyvLEw/ewJCzCyFmyzueNFiEdP9E2cyD5w2
         zN+YJd/mV0EaqH3ZwUQI0K++uTYvBRWgco+N0PhIPg7GBHoSl7rb2w1VG18WTuNCnX
         0HQSC+9SwV4qvYaP2pm5ELmO2FIn5WiNPWpl3+/iX+LKQ4bzn0sZmEUv5PWyn+k41K
         QSxHSUXlbQURloGU6vhKqbNZDUr0F/JaEMQbkenE/M3WDo/yc2ThDgf7epD/zcDMV1
         x6smkEFKeO2Lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 039/108] kbuild: sink stdout from cmd for silent build
Date:   Wed, 14 Jul 2021 15:36:51 -0400
Message-Id: <20210714193800.52097-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index 82dd1b65b7a8..f247e691562d 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -90,8 +90,13 @@ clean := -f $(srctree)/scripts/Makefile.clean obj
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

