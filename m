Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F4E501518
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243424AbiDNNlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344454AbiDNNcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:32:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D68612752;
        Thu, 14 Apr 2022 06:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37593B82984;
        Thu, 14 Apr 2022 13:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C339C385A1;
        Thu, 14 Apr 2022 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942981;
        bh=6edktBjNwLCAmGm1pNy3t6pAc75Aw+dsVthR9PK6/JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPV/kWhCL4731dq/0jr0NvH27VxpeCYKZrnuNsImgagafTjzpuRLQJz70g1ppeqkV
         CKAv5ZGKe/LTGJEX2vLq46oTEGXch5Z41pIzfo9WWajbFXYeE3PAylYrpQt1HuXs3b
         3Y76HPqC+QBvfLPPUP0yuXQTfprTbvYVfRr6oGcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Fangrui Song <maskray@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        John Keeping <john@metanate.com>, Leo Yan <leo.yan@linaro.org>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 4.19 324/338] tools build: Filter out options and warnings not supported by clang
Date:   Thu, 14 Apr 2022 15:13:47 +0200
Message-Id: <20220414110848.112450137@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 41caff459a5b956b3e23ba9ca759dd0629ad3dda upstream.

These make the feature check fail when using clang, so remove them just
like is done in tools/perf/Makefile.config to build perf itself.

Adding -Wno-compound-token-split-by-macro to tools/perf/Makefile.config
when building with clang is also necessary to avoid these warnings
turned into errors (-Werror):

    CC      /tmp/build/perf/util/scripting-engines/trace-event-perl.o
  In file included from util/scripting-engines/trace-event-perl.c:35:
  In file included from /usr/lib64/perl5/CORE/perl.h:4085:
  In file included from /usr/lib64/perl5/CORE/hv.h:659:
  In file included from /usr/lib64/perl5/CORE/hv_func.h:34:
  In file included from /usr/lib64/perl5/CORE/sbox32_hash.h:4:
  /usr/lib64/perl5/CORE/zaphod32_hash.h:150:5: error: '(' and '{' tokens introducing statement expression appear in different macro expansion contexts [-Werror,-Wcompound-token-split-by-macro]
      ZAPHOD32_SCRAMBLE32(state[0],0x9fade23b);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /usr/lib64/perl5/CORE/zaphod32_hash.h:80:38: note: expanded from macro 'ZAPHOD32_SCRAMBLE32'
  #define ZAPHOD32_SCRAMBLE32(v,prime) STMT_START {  \
                                       ^~~~~~~~~~
  /usr/lib64/perl5/CORE/perl.h:737:29: note: expanded from macro 'STMT_START'
  #   define STMT_START   (void)( /* gcc supports "({ STATEMENTS; })" */
                                ^
  /usr/lib64/perl5/CORE/zaphod32_hash.h:150:5: note: '{' token is here
      ZAPHOD32_SCRAMBLE32(state[0],0x9fade23b);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /usr/lib64/perl5/CORE/zaphod32_hash.h:80:49: note: expanded from macro 'ZAPHOD32_SCRAMBLE32'
  #define ZAPHOD32_SCRAMBLE32(v,prime) STMT_START {  \
                                                  ^
  /usr/lib64/perl5/CORE/zaphod32_hash.h:150:5: error: '}' and ')' tokens terminating statement expression appear in different macro expansion contexts [-Werror,-Wcompound-token-split-by-macro]
      ZAPHOD32_SCRAMBLE32(state[0],0x9fade23b);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /usr/lib64/perl5/CORE/zaphod32_hash.h:87:41: note: expanded from macro 'ZAPHOD32_SCRAMBLE32'
      v ^= (v>>23);                       \
                                          ^
  /usr/lib64/perl5/CORE/zaphod32_hash.h:150:5: note: ')' token is here
      ZAPHOD32_SCRAMBLE32(state[0],0x9fade23b);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /usr/lib64/perl5/CORE/zaphod32_hash.h:88:3: note: expanded from macro 'ZAPHOD32_SCRAMBLE32'
  } STMT_END
    ^~~~~~~~
  /usr/lib64/perl5/CORE/perl.h:738:21: note: expanded from macro 'STMT_END'
  #   define STMT_END     )
                          ^

Please refer to the discussion on the Link: tag below, where Nathan
clarifies the situation:

<quote>
acme> And then get to the problems at the end of this message, which seem
acme> similar to the problem described here:
acme>
acme> From  Nathan Chancellor <>
acme> Subject	[PATCH] mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO
acme>
acme> https://lkml.org/lkml/2020/9/1/135
acme>
acme> So perhaps in this case its better to disable that
acme> -Werror,-Wcompound-token-split-by-macro when building with clang?

Yes, I think that is probably the best solution. As far as I can tell,
at least in this file and context, the warning appears harmless, as the
"create a GNU C statement expression from two different macros" is very
much intentional, based on the presence of PERL_USE_GCC_BRACE_GROUPS.
The warning is fixed in upstream Perl by just avoiding creating GNU C
statement expressions using STMT_START and STMT_END:

  https://github.com/Perl/perl5/issues/18780
  https://github.com/Perl/perl5/pull/18984

If I am reading the source code correctly, an alternative to disabling
the warning would be specifying -DPERL_GCC_BRACE_GROUPS_FORBIDDEN but it
seems like that might end up impacting more than just this site,
according to the issue discussion above.
</quote>

Based-on-a-patch-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # Debian/Selfmade LLVM-14 (x86-64)
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Keeping <john@metanate.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Link: http://lore.kernel.org/lkml/YkxWcYzph5pC1EK8@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/feature/Makefile |    7 +++++++
 tools/perf/Makefile.config   |    3 +++
 2 files changed, 10 insertions(+)

--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -196,6 +196,13 @@ PERL_EMBED_LIBADD = $(call grep-libs,$(P
 PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
 FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
+ifeq ($(CC_NO_CLANG), 0)
+  PERL_EMBED_LDOPTS := $(filter-out -specs=%,$(PERL_EMBED_LDOPTS))
+  PERL_EMBED_CCOPTS := $(filter-out -flto=auto -ffat-lto-objects, $(PERL_EMBED_CCOPTS))
+  PERL_EMBED_CCOPTS := $(filter-out -specs=%,$(PERL_EMBED_CCOPTS))
+  FLAGS_PERL_EMBED += -Wno-compound-token-split-by-macro
+endif
+
 $(OUTPUT)test-libperl.bin:
 	$(BUILD) $(FLAGS_PERL_EMBED)
 
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -662,6 +662,9 @@ else
     LDFLAGS += $(PERL_EMBED_LDFLAGS)
     EXTLIBS += $(PERL_EMBED_LIBADD)
     CFLAGS += -DHAVE_LIBPERL_SUPPORT
+    ifeq ($(CC_NO_CLANG), 0)
+      CFLAGS += -Wno-compound-token-split-by-macro
+    endif
     $(call detected,CONFIG_LIBPERL)
   endif
 endif


