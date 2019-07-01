Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B1A3A734
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbfFIQrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730798AbfFIQrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:47:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EABA12081C;
        Sun,  9 Jun 2019 16:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098835;
        bh=1UTgMr9SJoHnfT0WfOenI8NDzCMDHeZtBSXR4xaotXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgaJ5nNeQ6W5iaLKpk1sNxQ5YJn2jn7BeadR/m09lgsqLoGXQ7gmsFfTwjhe5SYtS
         8LDEvr6QWLNzm48lHswaFN7eCEQVNx/yq1ti8Z8itXQS6U+epyujdS3S0nnPVJ+Lh2
         O0NaEBLyJBKtB+8cxHNSpnYHpdsBOV1ty8qS/b5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Brodkin <abrodkin@synopsys.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 5.1 35/70] kbuild: use more portable command -v for cc-cross-prefix
Date:   Sun,  9 Jun 2019 18:41:46 +0200
Message-Id: <20190609164130.078925185@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 913ab9780fc021298949cc5514d6255a008e69f9 upstream.

To print the pathname that will be used by shell in the current
environment, 'command -v' is a standardized way. [1]

'which' is also often used in scripts, but it is less portable.

When I worked on commit bd55f96fa9fc ("kbuild: refactor cc-cross-prefix
implementation"), I was eager to use 'command -v' but it did not work.
(The reason is explained below.)

I kept 'which' as before but got rid of '> /dev/null 2>&1' as I
thought it was no longer needed. Sorry, I was wrong.

It works well on my Ubuntu machine, but Alexey Brodkin reports noisy
warnings on CentOS7 when 'which' fails to find the given command in
the PATH environment.

  $ which foo
  which: no foo in (/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin)

Given that behavior of 'which' depends on system (and it may not be
installed by default), I want to try 'command -v' once again.

The specification [1] clearly describes the behavior of 'command -v'
when the given command is not found:

  Otherwise, no output shall be written and the exit status shall reflect
  that the name was not found.

However, we need a little magic to use 'command -v' from Make.

$(shell ...) passes the argument to a subshell for execution, and
returns the standard output of the command.

Here is a trick. GNU Make may optimize this by executing the command
directly instead of forking a subshell, if no shell special characters
are found in the command and omitting the subshell will not change the
behavior.

In this case, no shell special character is used. So, Make will try
to run it directly. However, 'command' is a shell-builtin command,
then Make would fail to find it in the PATH environment:

  $ make ARCH=m68k defconfig
  make: command: Command not found
  make: command: Command not found
  make: command: Command not found

In fact, Make has a table of shell-builtin commands because it must
ask the shell to execute them.

Until recently, 'command' was missing in the table.

This issue was fixed by the following commit:

| commit 1af314465e5dfe3e8baa839a32a72e83c04f26ef
| Author: Paul Smith <psmith@gnu.org>
| Date:   Sun Nov 12 18:10:28 2017 -0500
|
|     * job.c: Add "command" as a known shell built-in.
|
|     This is not a POSIX shell built-in but it's common in UNIX shells.
|     Reported by Nick Bowler <nbowler@draconx.ca>.

Because the latest release is GNU Make 4.2.1 in 2016, this commit is
not included in any released versions. (But some distributions may
have back-ported it.)

We need to trick Make to spawn a subshell. There are various ways to
do so:

 1) Use a shell special character '~' as dummy

    $(shell : ~; command -v $(c)gcc)

 2) Use a variable reference that always expands to the empty string
    (suggested by David Laight)

    $(shell command$${x:+} -v $(c)gcc)

 3) Use redirect

    $(shell command -v $(c)gcc 2>/dev/null)

I chose 3) to not confuse people. The stderr would not be polluted
anyway, but it will provide extra safety, and is easy to understand.

Tested on Make 3.81, 3.82, 4.0, 4.1, 4.2, 4.2.1

[1] http://pubs.opengroup.org/onlinepubs/9699919799/utilities/command.html

Fixes: bd55f96fa9fc ("kbuild: refactor cc-cross-prefix implementation")
Cc: linux-stable <stable@vger.kernel.org> # 5.1
Reported-by: Alexey Brodkin <abrodkin@synopsys.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Tested-by: Alexey Brodkin <abrodkin@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/Kbuild.include |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -73,8 +73,13 @@ endef
 # Usage: CROSS_COMPILE := $(call cc-cross-prefix, m68k-linux-gnu- m68k-linux-)
 # Return first <prefix> where a <prefix>gcc is found in PATH.
 # If no gcc found in PATH with listed prefixes return nothing
+#
+# Note: '2>/dev/null' is here to force Make to invoke a shell. Otherwise, it
+# would try to directly execute the shell builtin 'command'. This workaround
+# should be kept for a long time since this issue was fixed only after the
+# GNU Make 4.2.1 release.
 cc-cross-prefix = $(firstword $(foreach c, $(filter-out -%, $(1)), \
-					$(if $(shell which $(c)gcc), $(c))))
+			$(if $(shell command -v $(c)gcc 2>/dev/null), $(c))))
 
 # output directory for tests below
 TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)


