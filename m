Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C16B321762
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhBVMrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhBVMnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4CCC64F37;
        Mon, 22 Feb 2021 12:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997633;
        bh=yQGh2vl0zUg1EIMqWZcCkqVEhrEjEivlxnQkj69EwiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBVRn+XAsIjdQG4RNvJQBCyarC5p/YQcul7Mxu0QoOYmFspMOmU84sHr1CM8n5hrY
         vfSnYXJKENTLNTGg6uoYmx2xWDAOwUm2GbZxSuzpcG0CI8MS8+E+Ww3ubUs+2g7g2X
         t9aVBqJCe4zeiYNNjJ92wnA1jkgDwUb1KBDVoaYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.4 23/35] tracing: Fix SKIP_STACK_VALIDATION=1 build due to bad merge with -mrecord-mcount
Date:   Mon, 22 Feb 2021 13:36:19 +0100
Message-Id: <20210222121021.390104014@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
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
@@ -254,7 +254,7 @@ cmd_record_mcount =						\
 	     "$(CC_FLAGS_FTRACE)" ]; then			\
 		$(sub_cmd_record_mcount)			\
 	fi;
-endif
+endif # -record-mcount
 endif
 
 define rule_cc_o_c


