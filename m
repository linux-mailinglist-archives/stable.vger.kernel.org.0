Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41AF32170A
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhBVMmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:42:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231462AbhBVMji (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:39:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9738864F13;
        Mon, 22 Feb 2021 12:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997502;
        bh=AWJrq9CTU4jWdDExlrGjWDcFNigDcOUR4XCJyS4QyrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAgqLrnvySKxBELf2i+cg9SwdDTdlA8haxGqmde/Tn31YVdxY/u/17meU4q3T/g7m
         1OOcO0/V1pSA+YzlpXSjR3rWCrEOiiIBqHPR0wqRlXcSFuWQAlkyLIALwRSqjl6qa+
         UfIS71pNOPdeJ5J3CDC5MF7HsvxGzhyBEdkjjC9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 43/57] tracing: Fix SKIP_STACK_VALIDATION=1 build due to bad merge with -mrecord-mcount
Date:   Mon, 22 Feb 2021 13:36:09 +0100
Message-Id: <20210222121032.333497130@linuxfoundation.org>
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
@@ -257,6 +257,7 @@ cmd_record_mcount =						\
 	     "$(CC_FLAGS_FTRACE)" ]; then			\
 		$(sub_cmd_record_mcount)			\
 	fi;
+endif # -record-mcount
 endif # CONFIG_FTRACE_MCOUNT_RECORD
 
 ifdef CONFIG_STACK_VALIDATION
@@ -279,7 +280,6 @@ endif
 ifdef CONFIG_RETPOLINE
   objtool_args += --retpoline
 endif
-endif
 
 
 ifdef CONFIG_MODVERSIONS


