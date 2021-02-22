Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0864E321704
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhBVMlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:41:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhBVMjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:39:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1109964F11;
        Mon, 22 Feb 2021 12:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997504;
        bh=pfB20PaEP/d3YlRucANyFqt6sb2jXlwtltdptV7Bc3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zIuU4PLNEXTtbXIoVrfp8RrsCuzb+G5zbL890AuwVXUCZ8uceOfNwOt2q6oa+TxD
         mpy0uC9Q6Ps/azYxRyt9R+Jpy6XK9OOamDlBLlJCwZI62s0a8Ny8AWaPO/odlFFM37
         JThGcx8cF30UddDTTzn2ExSY4B0CRXfd9FSu13Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 44/57] tracing: Avoid calling cc-option -mrecord-mcount for every Makefile
Date:   Mon, 22 Feb 2021 13:36:10 +0100
Message-Id: <20210222121032.561311243@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit 07d0408120216b60625c9a5b8012d1c3a907984d upstream.

Currently if CONFIG_FTRACE_MCOUNT_RECORD is enabled -mrecord-mcount
compiler flag support is tested for every Makefile.

Top 4 cc-option usages:
    511 -mrecord-mcount
     11  -fno-stack-protector
      9 -Wno-override-init
      2 -fsched-pressure

To address that move cc-option from scripts/Makefile.build to top Makefile
and export CC_USING_RECORD_MCOUNT to be used in original place.

While doing that also add -mrecord-mcount to CC_FLAGS_FTRACE (if gcc
actually supports it).

Link: http://lkml.kernel.org/r/patch-2.thread-aa7b8d.git-de935bace15a.your-ad-here.call-01533557518-ext-9465@work.hours

Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile               |    7 +++++++
 scripts/Makefile.build |    9 +++------
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -760,6 +760,13 @@ ifdef CONFIG_FUNCTION_TRACER
 ifndef CC_FLAGS_FTRACE
 CC_FLAGS_FTRACE := -pg
 endif
+ifdef CONFIG_FTRACE_MCOUNT_RECORD
+  # gcc 5 supports generating the mcount tables directly
+  ifeq ($(call cc-option-yn,-mrecord-mcount),y)
+    CC_FLAGS_FTRACE	+= -mrecord-mcount
+    export CC_USING_RECORD_MCOUNT := 1
+  endif
+endif
 export CC_FLAGS_FTRACE
 ifdef CONFIG_HAVE_FENTRY
 CC_USING_FENTRY	:= $(call cc-option, -mfentry -DCC_USING_FENTRY)
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -224,11 +224,8 @@ cmd_modversions_c =								\
 endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
-# gcc 5 supports generating the mcount tables directly
-ifneq ($(call cc-option,-mrecord-mcount,y),y)
-KBUILD_CFLAGS += -mrecord-mcount
-else
-# else do it all manually
+ifndef CC_USING_RECORD_MCOUNT
+# compiler will not generate __mcount_loc use recordmcount or recordmcount.pl
 ifdef BUILD_C_RECORDMCOUNT
 ifeq ("$(origin RECORDMCOUNT_WARN)", "command line")
   RECORDMCOUNT_FLAGS = -w
@@ -257,7 +254,7 @@ cmd_record_mcount =						\
 	     "$(CC_FLAGS_FTRACE)" ]; then			\
 		$(sub_cmd_record_mcount)			\
 	fi;
-endif # -record-mcount
+endif # CC_USING_RECORD_MCOUNT
 endif # CONFIG_FTRACE_MCOUNT_RECORD
 
 ifdef CONFIG_STACK_VALIDATION


