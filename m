Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08CB31126D
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 21:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhBESoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 13:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbhBESmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 13:42:01 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D557AC06178C
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 12:22:32 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id j14so6158987qtv.3
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 12:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=zaz82GgJfGxiQg+lhL31nJxKpSeV5QcLPOrAgs8tROs=;
        b=E64YiaWh0YrhD/Nh9gBWy61m5SYAKMBEziy2a7oe4vFhsErcZS4kKT8UGF13NzkgdE
         sCR9JFcwguGcQPJ6uVuxkRR5TBTXVxQv+uQwiL/7HdPqfdXoaotYT02v5IWS0xzH8B3S
         ZkRezuwiSUsa2R2TMS0C6kjhhL5KtU8Ck7DPmTfKfpx7T12on5/Y9qMy57za6Ey6iZFw
         MAZAVdqmHN6TaBa13Q1a/HmROQL0stytGDGVtChoWM1522uaopDdJUjdGIOVlHxNNFwc
         1hyswOQIgZ8H2/iXwZlvQyuJAuHlf2rEVaIKH3nPL9n0yMSKOS5tPTKKi+4t7EOn+m3g
         cLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zaz82GgJfGxiQg+lhL31nJxKpSeV5QcLPOrAgs8tROs=;
        b=HiDjOhDj+DrIKvT6JNssxhnLiXsQuPjrgkP568mHEYVUGGQhybCs63M1nBJgCcqWNC
         kbPMigma2JOcsT2/ibYv3rjzAVAkDR4m0HMG1+FwAWO8Qoehf1aGCMMDHcU+IrECNC4l
         0LxtEEJMa1+iXVOiXAAhqxX4pP1g0WShDRMgEaw03o+2VU4xCApJryu9/0+ea7SnWsHA
         AKBc1RylLNgoBngLpAsNqaalVoWwU4iG7E2aGkhHWVYwVqC+HjAtJ3kLiiwKBMS+RAWa
         w62aFGQ+YKlxgnwncJSlhnUNd+yuoTd2hLqOYorvblqxykTTr2rOUGv6nk0zmHLsLq/1
         JMBw==
X-Gm-Message-State: AOAM53303LbOVo6lG4dk0PtgHc6n2jUCgDymgobiKLqXgFv/QlIYE3gk
        Wv6m8eFHioi/C+vzAt+4f6pm85WVSTrbycDSAo8=
X-Google-Smtp-Source: ABdhPJyPpNHm4sgEdl9Luj93zO/VvrNOwFWva8FNNJ6QPZ27iIH3H0PR5OWBdRDqrdDWYxdM1zTfq42LrHteCT1kpDI=
Sender: "ndesaulniers via sendgmr" 
        <ndesaulniers@ndesaulniers1.mtv.corp.google.com>
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:fce9:1439:f67f:bf26])
 (user=ndesaulniers job=sendgmr) by 2002:a05:6214:c8a:: with SMTP id
 r10mr6117500qvr.13.1612556551921; Fri, 05 Feb 2021 12:22:31 -0800 (PST)
Date:   Fri,  5 Feb 2021 12:22:18 -0800
In-Reply-To: <20210205202220.2748551-1-ndesaulniers@google.com>
Message-Id: <20210205202220.2748551-2-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20210205202220.2748551-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v9 1/3] vmlinux.lds.h: add DWARF v5 sections
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>,
        Fangrui Song <maskray@google.com>,
        Caroline Tice <cmtice@google.com>,
        Nick Clifton <nickc@redhat.com>, Yonghong Song <yhs@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Chris Murphy <bugzilla@colorremedies.com>,
        Mark Wielaard <mark@klomp.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We expect toolchains to produce these new debug info sections as part of
DWARF v5. Add explicit placements to prevent the linker warnings from
--orphan-section=warn.

Compilers may produce such sections with explicit -gdwarf-5, or based on
the implicit default version of DWARF when -g is used via DEBUG_INFO.
This implicit default changes over time, and has changed to DWARF v5
with GCC 11.

.debug_sup was mentioned in review, but without compilers producing it
today, let's wait to add it until it becomes necessary.

Cc: stable@vger.kernel.org
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1922707
Reported-by: Chris Murphy <lists@colorremedies.com>
Suggested-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 include/asm-generic/vmlinux.lds.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 34b7e0d2346c..1e7cde4bd3f9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -842,8 +842,13 @@
 		/* DWARF 4 */						\
 		.debug_types	0 : { *(.debug_types) }			\
 		/* DWARF 5 */						\
+		.debug_addr	0 : { *(.debug_addr) }			\
+		.debug_line_str	0 : { *(.debug_line_str) }		\
+		.debug_loclists	0 : { *(.debug_loclists) }		\
 		.debug_macro	0 : { *(.debug_macro) }			\
-		.debug_addr	0 : { *(.debug_addr) }
+		.debug_names	0 : { *(.debug_names) }			\
+		.debug_rnglists	0 : { *(.debug_rnglists) }		\
+		.debug_str_offsets	0 : { *(.debug_str_offsets) }
 
 /* Stabs debugging sections. */
 #define STABS_DEBUG							\
-- 
2.30.0.365.g02bc693789-goog

