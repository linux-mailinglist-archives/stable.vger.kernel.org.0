Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C10321793
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhBVMum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231550AbhBVMqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:46:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B03064F16;
        Mon, 22 Feb 2021 12:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997713;
        bh=dVabIgn138oRIN1YGYQUm7KDBGj96RbtFTWCbmRslFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECnhiVciWElIbgHU1wovQYsAJUi27t01pHYgQGB7vQf2Sp5twsWLUolK8IhNiFsml
         iJMo+vViPq0n4zZUDJTR9CSqx3OmBrJNEh5J4MGXClUSZq62wlWnTUatFTKpaH8QD9
         576Jiw8+6xniJDg6VzBVSjffIZG9B17EdfDnaBUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 37/49] tracing: Fix SKIP_STACK_VALIDATION=1 build due to bad merge with -mrecord-mcount
Date:   Mon, 22 Feb 2021 13:36:35 +0100
Message-Id: <20210222121027.681852585@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Thelen <gthelen@google.com>

commit ed7d40bc67b8353c677b38c6cdddcdc310c0f452 upstream.

Non gcc-5 builds with CONFIG_STACK_VALIDATION=y and
SKIP_STACK_VALIDATION=1 fail.
Example output:
  /bin/sh: init/.tmp_main.o: Permission denied

commit 96f60dfa5819 ("trace: Use -mcount-record for dynamic ftrace"),
added a mismatched endif.  This causes cmd_objtool to get mistakenly
set.

Relocate endif to balance the newly added -record-mcount check.

Link: http://lkml.kernel.org/r/20180608214746.136554-1-gthelen@google.com

Fixes: 96f60dfa5819 ("trace: Use -mcount-record for dynamic ftrace")
Acked-by: Andi Kleen <ak@linux.intel.com>
Tested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.build |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -255,6 +255,7 @@ cmd_record_mcount =						\
 	     "$(CC_FLAGS_FTRACE)" ]; then			\
 		$(sub_cmd_record_mcount)			\
 	fi;
+endif # -record-mcount
 endif
 
 ifdef CONFIG_STACK_VALIDATION
@@ -269,7 +270,6 @@ endif
 ifdef CONFIG_GCOV_KERNEL
 objtool_args += --no-unreachable
 endif
-endif
 
 # 'OBJECT_FILES_NON_STANDARD := y': skip objtool checking for a directory
 # 'OBJECT_FILES_NON_STANDARD_foo.o := 'y': skip objtool checking for a file


