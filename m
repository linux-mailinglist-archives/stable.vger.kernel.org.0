Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7780F3D26A3
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 17:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhGVOtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232138AbhGVOtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 10:49:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C69E60BD3;
        Thu, 22 Jul 2021 15:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626967792;
        bh=5V6tTYu89END9HaBFqbE6w1yV9MMmMiHtBi+sOQjHWI=;
        h=Subject:To:Cc:From:Date:From;
        b=u5Z3lXNJT9lLVFopMYyRrFREJ6x15bETbmLQN0Q2h5CN6xOWAMm3wMBOyYOfllaUI
         4eaiYUgU7IWc1iF/fCP/E2m1I+5mCPE8u+TxByaXpNJEoAOg+YfpcdSUNWJdwbJlQt
         0yykLrsFNbMDoG8ouEkH3W1/YpWG1uomttkQM3E0=
Subject: FAILED: patch "[PATCH] kbuild: sink stdout from cmd for silent build" failed to apply to 5.4-stable tree
To:     masahiroy@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Jul 2021 17:27:40 +0200
Message-ID: <162696766018738@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 174a1dcc96429efce4ef7eb2f5c4506480da2182 Mon Sep 17 00:00:00 2001
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Mon, 17 May 2021 16:03:13 +0900
Subject: [PATCH] kbuild: sink stdout from cmd for silent build

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

