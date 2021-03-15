Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AC933B706
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhCON7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232301AbhCON6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93BE764F27;
        Mon, 15 Mar 2021 13:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816700;
        bh=JlX7I7P2oKyZTLg6QpqcGde9p+mPUDB9CsaboOaFBR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4QbDMwhC+KLxPDYqT/s1q53ltKST8R37jlN4tVuDR1I9GlU2Tf0Aut09b/g0ZNoV
         d0cXajF6JTuXRKa6bvC52ei9tyzS3Xut2lc3A2vs3PdAmXLaCV9QcwJwwzROuJczpu
         v1hWQhXxisCTC/EMjEpmGpRTzPnKoH1k9tsJthCQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Manoj Gupta <manojgupta@google.com>
Subject: [PATCH 4.19 015/120] scripts/recordmcount.{c,pl}: support -ffunction-sections .text.* section names
Date:   Mon, 15 Mar 2021 14:56:06 +0100
Message-Id: <20210315135720.514047684@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Joe Lawrence <joe.lawrence@redhat.com>

commit 9c8e2f6d3d361439cc6744a094f1c15681b55269 upstream.

When building with -ffunction-sections, the compiler will place each
function into its own ELF section, prefixed with ".text".  For example,
a simple test module with functions test_module_do_work() and
test_module_wq_func():

  % objdump --section-headers test_module.o | awk '/\.text/{print $2}'
  .text
  .text.test_module_do_work
  .text.test_module_wq_func
  .init.text
  .exit.text

Adjust the recordmcount scripts to look for ".text" as a section name
prefix.  This will ensure that those functions will be included in the
__mcount_loc relocations:

  % objdump --reloc --section __mcount_loc test_module.o
  OFFSET           TYPE              VALUE
  0000000000000000 R_X86_64_64       .text.test_module_do_work
  0000000000000008 R_X86_64_64       .text.test_module_wq_func
  0000000000000010 R_X86_64_64       .init.text

Link: http://lkml.kernel.org/r/1542745158-25392-2-git-send-email-joe.lawrence@redhat.com

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Manoj Gupta <manojgupta@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/recordmcount.c  |    2 +-
 scripts/recordmcount.pl |   13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -401,7 +401,7 @@ static uint32_t (*w2)(uint16_t);
 static int
 is_mcounted_section_name(char const *const txtname)
 {
-	return strcmp(".text",           txtname) == 0 ||
+	return strncmp(".text",          txtname, 5) == 0 ||
 		strcmp(".init.text",     txtname) == 0 ||
 		strcmp(".ref.text",      txtname) == 0 ||
 		strcmp(".sched.text",    txtname) == 0 ||
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -142,6 +142,11 @@ my %text_sections = (
      ".text.unlikely" => 1,
 );
 
+# Acceptable section-prefixes to record.
+my %text_section_prefixes = (
+     ".text." => 1,
+);
+
 # Note: we are nice to C-programmers here, thus we skip the '||='-idiom.
 $objdump = 'objdump' if (!$objdump);
 $objcopy = 'objcopy' if (!$objcopy);
@@ -523,6 +528,14 @@ while (<IN>) {
 
 	# Only record text sections that we know are safe
 	$read_function = defined($text_sections{$1});
+	if (!$read_function) {
+	    foreach my $prefix (keys %text_section_prefixes) {
+	        if (substr($1, 0, length $prefix) eq $prefix) {
+	            $read_function = 1;
+	            last;
+	        }
+	    }
+	}
 	# print out any recorded offsets
 	update_funcs();
 


