Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8283D284B
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhGVP41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232234AbhGVP4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:56:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D66D6135A;
        Thu, 22 Jul 2021 16:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971800;
        bh=PmuHXE9H4zNBy25vnRaIZ9Atb03pBeeR/qmffxxS/XA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsrQW5pJ0cUgYQaq0oZrcaer6xTWGKQIOffeW5DkynmZLJHpd2WawDM+MMYKWJYfX
         BqCqKxwXSMR0I236ejlxZKAmUbgBxrd4SY9vFavzPXQJYE9NatBVt/nPpBRtwvdwCV
         hcnJBtyhirQFBG38a5V1ydya/0SBAbGq3gHYw328=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/125] kbuild: sink stdout from cmd for silent build
Date:   Thu, 22 Jul 2021 18:30:21 +0200
Message-Id: <20210722155625.690955017@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 08e011175b4c..0d6e11820791 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -174,8 +174,13 @@ clean := -f $(srctree)/scripts/Makefile.clean obj
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



