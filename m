Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFF340E500
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349622AbhIPRGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349196AbhIPRDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6251A61B1B;
        Thu, 16 Sep 2021 16:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810077;
        bh=mKUHKt96+zZEBkGgTe+1FJCUtvCvG32ZcnkUl3Tmk68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=laPNrGTpzEekSksiLdMPSbaeFsBypCZ9N7gj+siqhqrybxhVSYBZ/oE7+Nk8xMGS2
         YT6Gr8Al0alUZJ8lQMBk6z+YvahzoiJ+lC7oQO0Ijyh5mdOKwVsi9pe+YE91NC/J7y
         JUeaxehGYdJF1Ac7SmGDozhYAoMf6NhXqkvWGHoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 5.14 001/432] Makefile: use -Wno-main in the full kernel tree
Date:   Thu, 16 Sep 2021 17:55:50 +0200
Message-Id: <20210916155810.865922530@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 49832c819ab85b33b7a2a1429c8d067e82be2977 upstream.

When using gcc (SUSE Linux) 7.5.0 (on openSUSE 15.3), I see a build
warning:

  kernel/trace/trace_osnoise.c: In function 'start_kthread':
  kernel/trace/trace_osnoise.c:1461:8: warning: 'main' is usually a function [-Wmain]
    void *main = osnoise_main;
          ^~~~

Quieten that warning by using "-Wno-main".  It's OK to use "main" as a
declaration name in the kernel.

Build-tested on most ARCHes.

[ v2: only do it for gcc, since clang doesn't have that particular warning ]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/lkml/20210813224131.25803-1-rdunlap@infradead.org/
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -803,6 +803,8 @@ else
 # Disabled for clang while comment to attribute conversion happens and
 # https://github.com/ClangBuiltLinux/linux/issues/636 is discussed.
 KBUILD_CFLAGS += $(call cc-option,-Wimplicit-fallthrough=5,)
+# gcc inanely warns about local variables called 'main'
+KBUILD_CFLAGS += -Wno-main
 endif
 
 # These warnings generated too much noise in a regular build.


