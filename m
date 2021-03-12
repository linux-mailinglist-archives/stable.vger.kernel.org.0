Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14ED233987F
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 21:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbhCLUjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 15:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbhCLUjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 15:39:05 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F40BC061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 12:39:05 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id m35so8967008qtd.11
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 12:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GJXRaUWw3GBsddoEbFCqXHWGWiuZM+NGHFtwL8hqbbo=;
        b=kiTbp/TBB4IW9seEuwaJF0z8jkRasfyGhYC5/6jewN7cyc4AA4s4JEWIihCcjWIdju
         DNWBg//MF1iK3U3NKGXf2LUEQMdsCUP8PNDwrWdBoqNHoP4zLw59ETth/mG2f+6w82PV
         Ypl4/1UBuH1egBYEywHA15buJB0oPxcbdMZSg0XX4nyfzQoCR0iL8KPNkZ+eR1kj5Yet
         i4NIpGGLeG+NwGNkFgy6iSDceKJuMvSmn3groKwK4cFuNtvITOML1sh4DD9rfEFekQlG
         M1SEM/A6IRsMRpzIFsS7GPZZd9UtoEXoULEerEr9ajylBwQ3dbYx4vx+yyZbTkkymIfr
         X7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GJXRaUWw3GBsddoEbFCqXHWGWiuZM+NGHFtwL8hqbbo=;
        b=dkL7WR7oVg+rxvKM/Y8ty5DIh0hoqM3twIKL2Uc7ChX5h5YqXWqB1rEExiWtx5lN+Y
         Tb/L91uwChI0M3t1SF279KimmH+2I01Tl0yPwjuptp+qaly5LE6zHG0vQL9etiKbxLJK
         h84Wj9nNsxWjfRy3HV30erLMF3y2TW5gwNNXKWKRMsFjzWX564gP7t1h6p/ZhcaLcXSe
         9ZN0LRlCqRuf/LngYlB1xrD6VHu4ynErvlwEYRqeyIHgJh7zCNsvBldilfA29a8kROH1
         gigy4DofQCr/aM2xWfdvQVc4D0MCn4JTssYX21kk/0WuzC3L4SDqOKhxsMY+37Xbn5cw
         +eIw==
X-Gm-Message-State: AOAM530shn1F/jX6S+YV86lvdoo03FpCnuZRlSWdtDsNdSsvPDinUMEK
        K3dNTynL7sPsxEQxBVl/t6PpkbMm2iGlwOxC
X-Google-Smtp-Source: ABdhPJwKXfQYYRE/6tQhMAyalL6PB8nwkUV9aQ/1dpXbUtzsfas/muG272/tFIMAl0/jVEroK9gXjx5q45vYET41
X-Received: from manoj.svl.corp.google.com ([2620:15c:2ce:0:3159:c5f3:85f4:e811])
 (user=manojgupta job=sendgmr) by 2002:a05:6214:8c4:: with SMTP id
 da4mr109925qvb.17.1615581544242; Fri, 12 Mar 2021 12:39:04 -0800 (PST)
Date:   Fri, 12 Mar 2021 12:39:00 -0800
In-Reply-To: <CAH=QcsjHmWdLU6u-imNYWU2v=9ieP8bOk22FLERUd+rVUeqZNw@mail.gmail.com>
Message-Id: <20210312203900.1012048-1-manojgupta@google.com>
Mime-Version: 1.0
References: <CAH=QcsjHmWdLU6u-imNYWU2v=9ieP8bOk22FLERUd+rVUeqZNw@mail.gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH] scripts/recordmcount.{c,pl}: support -ffunction-sections
 .text.* section names
From:   Manoj Gupta <manojgupta@google.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, clang-built-linux@googlegroups.com,
        ndesaulniers@google.com, jiancai@google.com, dianders@google.com,
        llozano@google.com, manojgupta@google.com,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

[nc: Resolve conflict because of missing 42c269c88dc146982a54a8267f71abc99f12852a]
Signed-off-by: Manoj Gupta <manojgupta@google.com>
---
 scripts/recordmcount.c  |  2 +-
 scripts/recordmcount.pl | 13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 7250fb38350c..8cba4c44da4c 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -362,7 +362,7 @@ static uint32_t (*w2)(uint16_t);
 static int
 is_mcounted_section_name(char const *const txtname)
 {
-	return strcmp(".text",           txtname) == 0 ||
+	return strncmp(".text",          txtname, 5) == 0 ||
 		strcmp(".ref.text",      txtname) == 0 ||
 		strcmp(".sched.text",    txtname) == 0 ||
 		strcmp(".spinlock.text", txtname) == 0 ||
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index ccd6614ea218..5ca4ec297019 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -138,6 +138,11 @@ my %text_sections = (
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
@@ -503,6 +508,14 @@ while (<IN>) {
 
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
 
-- 
2.31.0.rc2.261.g7f71774620-goog

