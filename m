Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C9021612
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 11:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfEQJOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 05:14:16 -0400
Received: from terminus.zytor.com ([198.137.202.136]:54843 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbfEQJOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 05:14:16 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x4H9DnhM1276940
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 17 May 2019 02:13:49 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x4H9DnhM1276940
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019041745; t=1558084430;
        bh=OYv8bAt0TiIeSeWcCXLn4riQwhM0ceLLg4AFci1cecs=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=TYqXowP9UbEGD0Pr2hYozoY7iU9DRybFkIdTS0YnqjNdPbAGp7LzMBcfdZsooAY+a
         262Cc/I0BPhqGZIpZshwfJTyvBhVKe1WZI0NYKoZFGHm6glAlU6NSSkgTl45mtEr3N
         3vlkOYrEHrjr9TuT6y3qNwI8bMzYPCX0hRwJ8yg8AnU2/iDpAehSMV+8M8qdsdWSRQ
         UFDR8mOVyF+Mn2UkpJDt6y3XXp0yonnS+/WCXB014ba3H4bUGPMztNgrp/a8J555r2
         gSjAlV0ZWYZ8Zxe//Z+6y/MT40k7iJBiO5pUbyca/34k4sA/9b9Jy9mUxkmD31G7fq
         nz+DnY0wskGfg==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x4H9DnE81276937;
        Fri, 17 May 2019 02:13:49 -0700
Date:   Fri, 17 May 2019 02:13:49 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Nathan Chancellor <tipbot@zytor.com>
Message-ID: <tip-8ea58f1e8b11cca3087b294779bf5959bf89cc10@git.kernel.org>
Cc:     tglx@linutronix.de, peterz@infradead.org, jpoimboe@redhat.com,
        ndesaulniers@google.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        hpa@zytor.com, mojha@codeaurora.org, natechancellor@gmail.com,
        stable@vger.kernel.org
Reply-To: natechancellor@gmail.com, stable@vger.kernel.org, hpa@zytor.com,
          mojha@codeaurora.org, torvalds@linux-foundation.org,
          mingo@kernel.org, linux-kernel@vger.kernel.org,
          ndesaulniers@google.com, tglx@linutronix.de, jpoimboe@redhat.com,
          peterz@infradead.org
In-Reply-To: <80822a9353926c38fd7a152991c6292491a9d0e8.1558028966.git.jpoimboe@redhat.com>
References: <80822a9353926c38fd7a152991c6292491a9d0e8.1558028966.git.jpoimboe@redhat.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] objtool: Allow AR to be overridden with HOSTAR
Git-Commit-ID: 8ea58f1e8b11cca3087b294779bf5959bf89cc10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FORGED_REPLYTO,T_DATE_IN_FUTURE_96_Q autolearn=no
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  8ea58f1e8b11cca3087b294779bf5959bf89cc10
Gitweb:     https://git.kernel.org/tip/8ea58f1e8b11cca3087b294779bf5959bf89cc10
Author:     Nathan Chancellor <natechancellor@gmail.com>
AuthorDate: Thu, 16 May 2019 12:49:42 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 17 May 2019 11:10:42 +0200

objtool: Allow AR to be overridden with HOSTAR

Currently, this Makefile hardcodes GNU ar, meaning that if it is not
available, there is no way to supply a different one and the build will
fail.

  $ make AR=llvm-ar CC=clang LD=ld.lld HOSTAR=llvm-ar HOSTCC=clang \
         HOSTLD=ld.lld HOSTLDFLAGS=-fuse-ld=lld defconfig modules_prepare
  ...
    AR       /out/tools/objtool/libsubcmd.a
  /bin/sh: 1: ar: not found
  ...

Follow the logic of HOST{CC,LD} and allow the user to specify a
different ar tool via HOSTAR (which is used elsewhere in other
tools/ Makefiles).

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Cc: <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/80822a9353926c38fd7a152991c6292491a9d0e8.1558028966.git.jpoimboe@redhat.com
Link: https://github.com/ClangBuiltLinux/linux/issues/481
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/objtool/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 53f8be0f4a1f..88158239622b 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -7,11 +7,12 @@ ARCH := x86
 endif
 
 # always use the host compiler
+HOSTAR	?= ar
 HOSTCC	?= gcc
 HOSTLD	?= ld
+AR	 = $(HOSTAR)
 CC	 = $(HOSTCC)
 LD	 = $(HOSTLD)
-AR	 = ar
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
