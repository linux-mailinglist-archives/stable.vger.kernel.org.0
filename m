Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FA4321708
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhBVMly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:41:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231261AbhBVMji (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:39:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30D6F64F0E;
        Mon, 22 Feb 2021 12:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997499;
        bh=S/bd23BQkwRgKJHcmSwkOS+UEktxaYfet4nnB3sCiAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPyfeyVqPWr8pMzhQfct3nRVDEcts0F2OrlfbV2nZ1hTg64OLzuTKSnJ2RBZnZqbo
         ZFf9FvAd3BEiOE2kXkgnT0O9WJqkTGbpPOZLfu75jXLD87zRodqW2OEmjWivReE7qv
         ZOVSs9ICYIXCCnsiHG2C4G/bhKNNa2iDzRccIeH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 42/57] trace: Use -mcount-record for dynamic ftrace
Date:   Mon, 22 Feb 2021 13:36:08 +0100
Message-Id: <20210222121032.166118470@linuxfoundation.org>
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

From: Andi Kleen <ak@linux.intel.com>

commit 96f60dfa5819a065bfdd2f2ba0df7d9cbce7f4dd upstream.

gcc 5 supports a new -mcount-record option to generate ftrace
tables directly. This avoids the need to run record_mcount
manually.

Use this option when available.

So far doesn't use -mcount-nop, which also exists now.

This is needed to make ftrace work with LTO because the
normal record-mcount script doesn't run over the link
time output.

It should also improve build times slightly in the general
case.
Link: http://lkml.kernel.org/r/20171127213423.27218-12-andi@firstfloor.org

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.build |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -224,6 +224,11 @@ cmd_modversions_c =								\
 endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
+# gcc 5 supports generating the mcount tables directly
+ifneq ($(call cc-option,-mrecord-mcount,y),y)
+KBUILD_CFLAGS += -mrecord-mcount
+else
+# else do it all manually
 ifdef BUILD_C_RECORDMCOUNT
 ifeq ("$(origin RECORDMCOUNT_WARN)", "command line")
   RECORDMCOUNT_FLAGS = -w
@@ -274,6 +279,7 @@ endif
 ifdef CONFIG_RETPOLINE
   objtool_args += --retpoline
 endif
+endif
 
 
 ifdef CONFIG_MODVERSIONS


